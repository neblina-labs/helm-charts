# dbt-core-docs

You can use the chart running the following comamnds:

```
helm repo add neblina-labs https://neblina-labs.github.io/helm-charts

helm install dbt-docs neblina-labs/dbt-core-docs \
    --namespace dbt \
    --create-namespace \
    --values values.yaml \
    --version 0.1.4
```


An example of `values.yaml` for my personal project:
- Docker image dbt-core with BigQuery adapter.
- Ingress configured with ingress-nginx, cert-manager, and oauth2-proxy

**Note**: this configure doesn't work for everyone ( because of environment variables & ingress configuration) - it is just an example tailored to my person project.

```
replicaCount: 1

image:
  repository: "YOUR_DBT_IMAGE"
  tag: "YOUR_DBT_IMAGE_TAG"

env:
  - name: BIGQUERY_DATASET
    value: "YOUR_DATASET"
  - name: GCP_PROJECT_ID
    value: "YOUR_PROJECT_ID"

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
    nginx.ingress.kubernetes.io/auth-url: "https://MY_OAUTH2_PROXY_HOSTNAME/oauth2/auth"
    nginx.ingress.kubernetes.io/auth-signin: "https://MY_OAUTH2_PROXY_HOSTNAME/oauth2/start?rd=https://MY_DBT_DOCS_HOSTNAME"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
  hosts:
    - host: MY_DBT_DOCS_HOSTNAME
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - hosts:
        - MY_DBT_DOCS_HOSTNAME
      secretName: dbt-tls

```