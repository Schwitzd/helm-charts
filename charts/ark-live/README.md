# ark-live

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Deployment chart for Ark Live, a VPS-only viewer for the last 7 days of ARK trades

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules for pod scheduling. |
| deploymentAnnotations | object | `{}` | Annotations to add to the Deployment. |
| extraEnv | list | `[]` | Additional environment variables for the pod. |
| fullnameOverride | string | `""` | Override full release name for resources. |
| httpRoute.enabled | bool | `false` | Enable HTTPRoute resource (Gateway API). |
| httpRoute.gatewayName | string | `"external-gateway"` | Name of the Gateway the route attaches to. |
| httpRoute.gatewayNamespace | string | `"gateway-system"` | Namespace where the Gateway resides. |
| httpRoute.hostnames | list | `["chart-example.local"]` | List of hostnames for this route. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.repository | string | `"harbor.schwitzd.me/library/ark-live"` | Container image repository. |
| image.tag | string | `"0.1.0"` | Container image tag. |
| imagePullSecrets | list | `[]` | Image pull secrets for private registries. |
| ingress.annotations | object | `{}` | Ingress annotations. |
| ingress.className | string | `""` | Ingress class name. |
| ingress.enabled | bool | `false` | Enable Ingress resource. |
| ingress.host | string | `"chart-example.local"` | Ingress hostname. |
| ingress.tls | list | `[]` | TLS configuration. Each entry has a secretName and a list of hosts. |
| livenessProbe | object | `{"httpGet":{"path":"/api/trades","port":"http"},"initialDelaySeconds":5,"periodSeconds":30}` | Liveness probe configuration. Hits /api/trades (a cheap in-memory read) rather than a dedicated health endpoint, so a transient RabbitMQ outage doesn't cause Kubernetes to kill/restart the pod. |
| nameOverride | string | `""` | Override chart name for resources. |
| nodeSelector | object | `{}` | Node selector for pod scheduling. |
| podAnnotations | object | `{}` | Annotations to add to the pod. |
| podLabels | object | `{}` | Labels to add to the pod. |
| podSecurityContext | object | `{"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod-level security context applied to all containers. |
| rabbitmq.auth.existingSecret | string | `""` | Existing secret containing RabbitMQ credentials. |
| rabbitmq.auth.password | string | `""` | RabbitMQ password (chart creates a Secret when set and existingSecret is empty). |
| rabbitmq.auth.passwordKey | string | `"password"` | Secret key for the RabbitMQ password. |
| rabbitmq.auth.username | string | `""` | RabbitMQ username (chart creates a Secret when set and existingSecret is empty). |
| rabbitmq.auth.usernameKey | string | `"username"` | Secret key for the RabbitMQ username. |
| rabbitmq.prefetch | int | `100` | Consumer prefetch count. |
| rabbitmq.queue | string | `""` | Stream queue name to tail. Required - intentionally has no default, since it names a specific piece of RabbitMQ infrastructure that can change independently of this chart. |
| rabbitmq.queuePassive | bool | `true` | Whether the app only passively declares the queue; it never creates one. |
| rabbitmq.reconnectDelay | int | `5` | Seconds to wait between reconnect attempts after a connection failure. |
| rabbitmq.streamOffset | string | `"first"` | Stream offset to replay from on every (re)connect. |
| rabbitmq.url | string | `""` | AMQP connection URL (without credentials when using existingSecret). Required. |
| rabbitmq.vhost | string | `""` | RabbitMQ virtual host. |
| readinessProbe | object | `{"httpGet":{"path":"/api/trades","port":"http"},"initialDelaySeconds":5,"periodSeconds":15}` | Readiness probe configuration. |
| resources.limits.cpu | string | `"150m"` | CPU limit. |
| resources.limits.memory | string | `"128Mi"` | Memory limit. |
| resources.requests.cpu | string | `"50m"` | CPU request. |
| resources.requests.memory | string | `"64Mi"` | Memory request. |
| revisionHistoryLimit | int | `4` | Number of old ReplicaSets to retain. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true}` | Container-level security context. |
| service.port | int | `80` | Service port. |
| service.targetPort | int | `80` | Container target port. |
| service.type | string | `"ClusterIP"` | Service type. |
| serviceAccountName | string | `""` | Service account name for the pod. |
| tolerations | list | `[]` | Tolerations for pod scheduling. |

Note: `replicas` and the deployment `strategy` are not configurable values - they're
hardcoded to `1`/`Recreate` in the template. The app holds trades in an in-memory
store with no locking, which is only safe with exactly one running pod at a time.

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
