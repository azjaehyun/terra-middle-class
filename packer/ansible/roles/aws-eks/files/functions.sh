#!/usr/bin/env bash

################################################################
# Wait for the cloud-init process to finish before moving
# to the next step.
# 
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   0 finishes when the cloud-init process is complete
################################################################
wait_for_cloudinit() {
    cloud-init status --wait
}



################################################################
# Install iptables-restore service
# 
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
################################################################
install_iptables_restore() {
    mkdir -p /etc/sysconfig
    bash -c "/sbin/iptables-save > /etc/sysconfig/iptables"
    curl -sL -o /etc/systemd/system/iptables-restore.service https://raw.githubusercontent.com/awslabs/amazon-eks-ami/master/files/iptables-restore.service
    systemctl daemon-reload && systemctl enable iptables-restore
}


################################################################
# Install the OpenSCAP based on the operating system
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   0 after a successful installation
################################################################
install_openscap() {
    if is_rhel || is_centos; then
        yum install -y openscap openscap-scanner scap-security-guide
    elif is_amazonlinux2; then
        yum install -y openscap openscap-scanner scap-security-guide
    elif is_ubuntu; then
        apt-get install -y libopenscap8 ssg-debian ssg-debderived
    else
        echo "failed to install the openscap libraries"
        exit 1
    fi
}

################################################################
# Generate the OpenSCAP fix shell script to harden to the
# operating system
# 
# Globals:
#   None
# Arguments:
#   1 - the openscap data source file path
#   2 - the openscap profile name
#   3 - (optional) the openscap tailoring file
# Outputs:
#   None
################################################################
oscap_generate_fix() {
    local oscap_source=$1
    local oscap_profile=$2
    local oscap_tailoring_file=${3:-}

    # install openscap dependencies
    install_openscap

    # check if the tailoring file is provided
    if [ ! -z "${oscap_tailoring_file}" ]; then

        oscap xccdf generate fix \
            --output /etc/packer/hardening.sh \
            --tailoring-file $oscap_tailoring_file \
            --profile $oscap_profile \
            --fetch-remote-resources $oscap_source

    else

        oscap xccdf generate fix \
            --output /etc/packer/hardening.sh \
            --profile $oscap_profile \
            --fetch-remote-resources $oscap_source
    fi
}

################################################################
# Migrate existing folder to a new partition
# 
# Globals:
#   None
# Arguments:
#   1 - the path of the disk or partition
#   2 - the folder path to migration
#   3 - the mount options to use.
# Outputs:
#   None
################################################################
migrate_and_mount_disk() {
    local disk_name=$1
    local folder_path=$2
    local mount_options=$3
    local temp_path="/mnt${folder_path}"
    local old_path="${folder_path}-old"

    # install an ext4 filesystem to the disk
    mkfs -t ext4 ${disk_name}

    # check if the folder already exists
    if [ -d "${folder_path}" ]; then
        mkdir -p ${temp_path}
        mount ${disk_name} ${temp_path}
        cp -Rax ${folder_path}/* ${temp_path}
        mv ${folder_path} ${old_path}
        umount ${disk_name}
    fi

    # create the folder
    mkdir -p ${folder_path}

    # add the mount point to fstab and mount the disk
    echo "UUID=$(blkid -s UUID -o value ${disk_name}) ${folder_path} ext4 ${mount_options} 0 1" >> /etc/fstab
    mount -a

    # if selinux is enabled restore the objects on it
    if selinuxenabled; then
        restorecon -R ${folder_path}
    fi
}

################################################################
# Partition the disks based on the standard layout for common
# hardening frameworks
# 
# Globals:
#   None
# Arguments:
#   1 - the name of the disk
# Outputs:
#   None
################################################################
partition_disks() {
    local disk_name=$1

    # partition the disk
    parted -a optimal -s $disk_name \
        mklabel gpt \
        mkpart var ext4 0% 20% \
        mkpart varlog ext4 20% 40% \
        mkpart varlogaudit ext4 40% 60% \
        mkpart home ext4 60% 70% \
        mkpart varlibdocker ext4 70% 90%

    # wait for the disks to settle
    sleep 5

    # migrate and mount the existing
    migrate_and_mount_disk "${disk_name}p1" /var            defaults,nofail,nodev
    migrate_and_mount_disk "${disk_name}p2" /var/log        defaults,nofail,nodev,nosuid
    migrate_and_mount_disk "${disk_name}p3" /var/log/audit  defaults,nofail,nodev,nosuid
    migrate_and_mount_disk "${disk_name}p4" /home           defaults,nofail,nodev,nosuid
    migrate_and_mount_disk "${disk_name}p5" /var/lib/docker defaults,nofail
}


partition_disks_gitlab() {
    local disk_name=$1

    # partition the disk
    parted -a optimal -s $disk_name \
        mklabel gpt \
        mkpart varlog ext4 0% 20% \
        mkpart varlibdocker ext4 20% 40% \
        mkpart data ext4 40% 95%

    # wait for the disks to settle
    sleep 5

    # migrate and mount the existing
    migrate_and_mount_disk "${disk_name}p1" /var/log        defaults,nofail,nodev,nosuid
    migrate_and_mount_disk "${disk_name}p2" /var/lib/docker defaults,nofail
    migrate_and_mount_disk "${disk_name}p3" /data defaults,nofail
}


partition_disks_default() {
    local disk_name=$1

    # partition the disk
    parted -a optimal -s $disk_name \
        mklabel gpt \
        mkpart varlog ext4 0GB 20GB \
        mkpart varlibdocker ext4 20GB 40GB \
        mkpart data ext4 40GB 99%

    # wait for the disks to settle
    sleep 5

    # migrate and mount the existing
    migrate_and_mount_disk "${disk_name}p1" /var/log        defaults,nofail,nodev,nosuid
    migrate_and_mount_disk "${disk_name}p2" /var/lib/docker defaults,nofail
    migrate_and_mount_disk "${disk_name}p3" /data defaults,nofail
}

################################################################
# Configure the host with HTTP_PROXY, HTTPS_PROXY, and NO_PROXY
# by setting values in /etc/environment
# 
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
################################################################
configure_http_proxy() {
    touch /etc/environment

    if [ -z "${HTTP_PROXY}" ]; then
        echo "http_proxy=${HTTP_PROXY}" >> /etc/environment
        echo "HTTP_PROXY=${HTTP_PROXY}" >> /etc/environment
    fi

    if [ -z "${HTTPS_PROXY}" ]; then
        echo "https_proxy=${HTTPS_PROXY}" >> /etc/environment
        echo "HTTPS_PROXY=${HTTPS_PROXY}" >> /etc/environment
    fi

    if [ -z "${NO_PROXY}" ]; then
        echo "no_proxy=${NO_PROXY}" >> /etc/environment
        echo "NO_PROXY=${NO_PROXY}" >> /etc/environment
    fi
}

configure_docker_environment() {
    local docker_dir="/etc/systemd/system/docker.service.d"
    local docker_env_file="${docker_dir}/environment.conf"

    mkdir -p "${docker_dir}"
    echo "[Service]" >> "${docker_env_file}"
    echo "EnvironmentFile=/etc/environment" >> "${docker_env_file}"
}

configure_kubelet_environment() {
    local kubelet_dir="/etc/systemd/system/kubelet.service.d"
    local kubelet_env_file="${kubelet_dir}/environment.conf"

    mkdir -p "${kubelet_dir}"
    echo "[Service]" >> "${kubelet_env_file}"
    echo "EnvironmentFile=/etc/environment" >> "${kubelet_env_file}"
}

################################################################
# Enable FIPS 140-2 mode on the operating system
# 
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
################################################################
enable_fips() {
    if is_rhel_7; then

        # install dependencies
        yum install -y dracut-fips-aesni dracut-fips

        # we will configure FIPS ourselves as the generated STIG locks the OS
        # configure dracut-fips
        dracut -f

        # udpate the kernel settings
        grubby --update-kernel=ALL --args="fips=1"

        # configure this to meet the stig checker
        sed -i "/^GRUB_CMDLINE_LINUX/ s/\"$/ fips=1\"/" /etc/default/grub

        # set the ssh ciphers
        sed -i 's/^Cipher.*/Ciphers aes128-ctr,aes192-ctr,aes256-ctr/' /etc/ssh/sshd_config
        sed -i 's/^MACs.*/MACs hmac-sha2-256,hmac-sha2-512/' /etc/ssh/sshd_config

    elif is_rhel_8; then
        fips-mode-setup --enable
    else
        echo "FIPS 140-2 is not supported on this operating system."
        exit 1
    fi
}