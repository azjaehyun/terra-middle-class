resource "null_resource" "execute_test" {
  provisioner "local-exec" {
    command = "echo ${var.shell_test}"
  }
}