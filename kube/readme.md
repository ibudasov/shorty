# Shorty + k8s

This is an attempt of kubernetization of Shorty

## Preconditions

1. Ingress controller — Check if you have it: `kubectl get pods`

2. Install Ingress Controller if you do not have it: https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac or: 

```sh
helm upgrade --install ingress-nginx ingress-nginx \
   --repo https://kubernetes.github.io/ingress-nginx 
```
3. Make sure you have installed the Ingress controller in the same namespace as your application

4. `kubectl exec pod/shorty-app-deployment-8bfd5784d-s5hsb -- 'echo "shorty" >> /usr/share/nginx/html/index.html'`

## Install

```sh
# install upon configured cluster
helm install shorty .

# uninstall 
helm uninstall shorty

# get the IP of ingress 
kubectl get ingress

# and try to reach it
curl "http://192.168.0.1/"
```