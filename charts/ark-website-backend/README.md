# ark-website-backend

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.6](https://img.shields.io/badge/AppVersion-1.0.6-informational?style=flat-square)

Deployment chart for the Ark Website backend API

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules for pod scheduling. |
| api.auth.apiKey | string | `""` | API key (chart creates a Secret when set and existingSecret is empty). One of existingSecret or apiKey is required. |
| api.auth.apiKeyKey | string | `"api_key"` | Secret key for the API key. |
| api.auth.existingSecret | string | `""` | Existing secret containing the API key clients must send in the X-API-KEY header. |
| app.env | string | `"production"` | Application environment (APP_ENV). "development" enables CORS for http://localhost:3000. |
| app.webConcurrency | int | `2` | Number of gunicorn workers (WEB_CONCURRENCY). Set explicitly because gunicorn otherwise sizes workers from the node's CPU count, ignoring the pod's CPU limit. Each worker opens up to 5 PostgreSQL connections. |
| deploymentAnnotations | object | `{}` | Annotations to add to the Deployment. |
| extraEnv | list | `[]` | Additional environment variables for the pod. |
| fullnameOverride | string | `""` | Override full release name for resources. |
| httpRoute.enabled | bool | `false` | Enable HTTPRoute resource (Gateway API). |
| httpRoute.gatewayName | string | `"external-gateway"` | Name of the Gateway the route attaches to. |
| httpRoute.gatewayNamespace | string | `"gateway-system"` | Namespace where the Gateway resides. |
| httpRoute.hostnames | list | `["chart-example.local"]` | List of hostnames for this route. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.repository | string | `"schwitzd/ark-website-backend"` | Container image repository. |
| image.tag | string | `"1.0.6"` | Container image tag. |
| imagePullSecrets | list | `[]` | Image pull secrets for private registries. |
| ingress.annotations | object | `{}` | Ingress annotations. |
| ingress.className | string | `""` | Ingress class name. |
| ingress.enabled | bool | `false` | Enable Ingress resource. |
| ingress.host | string | `"chart-example.local"` | Ingress hostname. |
| ingress.tls | list | `[]` | TLS configuration. Each entry has a secretName and a list of hosts. |
| livenessProbe | object | `{"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":5,"periodSeconds":30}` | Liveness probe configuration. Hits / (does not touch the database), so a transient PostgreSQL outage doesn't cause Kubernetes to restart the pod. |
| nameOverride | string | `""` | Override chart name for resources. |
| nodeSelector | object | `{}` | Node selector for pod scheduling. |
| podAnnotations | object | `{}` | Annotations to add to the pod. |
| podLabels | object | `{}` | Labels to add to the pod. |
| podSecurityContext | object | `{"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod-level security context applied to all containers. runAsUser/runAsGroup match the image's arkuser (uid/gid 10001). |
| postgres.auth.existingSecret | string | `""` | Existing secret containing PostgreSQL credentials. |
| postgres.auth.password | string | `""` | PostgreSQL password (chart creates a Secret when set and existingSecret is empty). |
| postgres.auth.passwordKey | string | `"password"` | Secret key for the PostgreSQL password. |
| postgres.auth.username | string | `""` | PostgreSQL username (chart creates a Secret when set and existingSecret is empty). |
| postgres.auth.usernameKey | string | `"username"` | Secret key for the PostgreSQL username. |
| postgres.database | string | `""` | PostgreSQL database name. Required. |
| postgres.host | string | `""` | PostgreSQL host. Required. |
| postgres.port | int | `5432` | PostgreSQL port. |
| readinessProbe | object | `{"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":5,"periodSeconds":15}` | Readiness probe configuration. |
| replicaCount | int | `1` | Number of pod replicas. The app is stateless, so it can be scaled freely. |
| resources.limits.cpu | string | `"250m"` | CPU limit. |
| resources.limits.memory | string | `"256Mi"` | Memory limit. |
| resources.requests.cpu | string | `"50m"` | CPU request. |
| resources.requests.memory | string | `"128Mi"` | Memory request. |
| revisionHistoryLimit | int | `4` | Number of old ReplicaSets to retain. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true}` | Container-level security context. |
| service.port | int | `80` | Service port. |
| service.targetPort | int | `5000` | Container target port (passed to the app as PORT). |
| service.type | string | `"ClusterIP"` | Service type. |
| serviceAccountName | string | `""` | Service account name for the pod. |
| tolerations | list | `[]` | Tolerations for pod scheduling. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
