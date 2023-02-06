apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: istio-system
  name: istio-operator-1-14-3
spec:
  profile: default
  components:
    ingressGateways:
    - enabled: true
      k8s:
        service:
           ports:
           - name: status-port
             port: 15021
             protocol: TCP
             targetPort: 15021
           - name: http2
             port: 80
             protocol: TCP
             targetPort: 8080
           - name: https
             port: 443
             protocol: TCP
             targetPort: 8443
      name: istio-ingressgateway
  values:
    gateways:
      istio-ingressgateway:
        serviceAnnotations:
          service.beta.kubernetes.io/aws-load-balancer-name: "${load_balancer_name}"
          service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
          service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
          service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
          service.beta.kubernetes.io/aws-load-balancer-internal: false
          service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: true
          service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "${acm_arm}"
          #service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags: "${resource_tags}"