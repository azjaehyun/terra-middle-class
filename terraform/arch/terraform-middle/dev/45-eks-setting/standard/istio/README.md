## [Istio document 설치 공식 문서 ](https://istio.io/latest/docs/setup/getting-started/#download)
### 공식 문서 가이드
~~~ 
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.16.1
export PATH=$PWD/bin:$PATH
~~~

### istioOperator 적용
~~~
> vi istioOperator.yaml // 마지막 라인은 본인의 acm ARN으로 변경!!  - certificate manager에서 확인
> cd terra-middle-class/terraform/arch/terraform-middle/dev/45-eks-setting/standard/istio-1.16.1
> export PATH=$PWD/bin:$PATH // 꼭 위의 경로에서 export Path 지정. // bin 안에서 export 하지 말것!
> istioctl install -f istioOperator.yaml

// 결과확인
This will install the Istio 1.16.1 default profile with ["Istio core" "Istiod" "Ingress gateways" "Egress gateways"] components into the cluster. Proceed? (y/N) y <- y 입력!!
✔ Istio core installed
✔ Istiod installed
✔ Ingress gateways installed
✔ Egress gateways installed
✔ Installation complete
... 
~~~

### 설치 확인
~~~
> kubectl get all -n istio-system
NAME                                        READY   STATUS    RESTARTS   AGE
pod/istio-egressgateway-6659cbcbfc-ddfqr    1/1     Running   0          24s
pod/istio-egressgateway-6659cbcbfc-gzxpg    1/1     Running   0          8s
pod/istio-ingressgateway-7cbdc88f56-c2d5d   1/1     Running   0          8s
pod/istio-ingressgateway-7cbdc88f56-h2v9z   1/1     Running   0          24s
pod/istiod-5d5b45c577-965m9                 1/1     Running   0          13s
pod/istiod-5d5b45c577-w6xgq                 1/1     Running   0          28s

NAME                           TYPE           CLUSTER-IP       EXTERNAL-IP                                                                   PORT(S)                                      AGE
service/istio-egressgateway    ClusterIP      10.100.146.132   <none>                                                                        80/TCP,443/TCP                               23s
service/istio-ingressgateway   LoadBalancer   10.100.125.104   aa693598cce3245a5a56d3fbfcfad86b-852897955.ap-northeast-2.elb.amazonaws.com   15021:30018/TCP,80:32639/TCP,443:32121/TCP   23s
service/istiod                 ClusterIP      10.100.71.103    <none>                                                                        15010/TCP,15012/TCP,443/TCP,15014/TCP        28s

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/istio-egressgateway    2/2     2            2           24s
deployment.apps/istio-ingressgateway   2/2     2            2           24s
deployment.apps/istiod                 2/2     2            2           28s

NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/istio-egressgateway-6659cbcbfc    2         2         2       24s
replicaset.apps/istio-ingressgateway-7cbdc88f56   2         2         2       24s
replicaset.apps/istiod-5d5b45c577                 2         2         2       28s

NAME                                                       REFERENCE                         TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/istio-egressgateway    Deployment/istio-egressgateway    <unknown>/80%   2         5         1          23s
horizontalpodautoscaler.autoscaling/istio-ingressgateway   Deployment/istio-ingressgateway   <unknown>/80%   2         5         1          23s
horizontalpodautoscaler.autoscaling/istiod                 Deployment/istiod                 <unknown>/80%   2         5         1          28s
~~~