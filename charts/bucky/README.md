# bucky

At Neblina, we use bucky to host elementary-data(https://www.elementary-data.com/) reports. You can use the chart running the following comamnds:

```
helm repo add neblina-labs https://neblina-labs.github.io/helm-charts

helm install bucky neblina-labs/bucky \
    --namespace elementary \
    --create-namespace \
    --values values.yaml \
    --version 0.1.0
```


An example of `values.yaml` for my personal project:
- Ingress configured with ingress-nginx, cert-manager, and oauth2-proxy
- Workload Identity configured for bucky service account

**Note**: this configure doesn't work for everyone ( because of environment variables & ingress configuration) - it is just an example tailored to my person project.

```
replicaCount: 1
image:
  # for AWS use tag: s3fuse-latest
  tag: gcsfuse-latest

env:
  - name: GCS_BUCKET_NAME
    value: "YOUR_BUCKET"

resources:
  requests:
    cpu: 200m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi

ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/auth-url: "https://OAUTH2_PROXY_HOSTNAME/oauth2/auth"
    nginx.ingress.kubernetes.io/auth-signin: "https://OAUTH2_PROXY_HOSTNAME/oauth2/start?rd=https://elementary.neblina.co"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
  hosts:
    - host: elementary.neblina.co
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - hosts:
        - elementary.neblina.co
      secretName: elementary-tls
```