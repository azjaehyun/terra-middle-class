# busybox
busybox pod 를 배포 합니다.

Deploy
---------------

```
# SSH conntecting
ssh -i <YOUR_PEM_FILE_LOCATION> ubuntu@<PUBLIC_IP_ADDRESS>

kubectl apply -f busybox-pv.yaml

kubectl apply -f busybox-po.yaml
```
 
Appendix
---------------
kubectl 를 통해 busybox-pod 컨테이너 내부에 접속할 수 있습니다.
````shell
kubectl exec -it busybox-pod -- /bin/sh  
````
