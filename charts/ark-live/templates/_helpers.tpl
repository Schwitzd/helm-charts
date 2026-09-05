{{- define "ark-live.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ark-live.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "ark-live.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ark-live.labels" -}}
helm.sh/chart: {{ include "ark-live.chart" . }}
{{ include "ark-live.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "ark-live.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ark-live.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "ark-live.validateRabbitmq" -}}
{{- if empty .Values.rabbitmq.url -}}
{{- fail "rabbitmq.url is required" -}}
{{- end -}}
{{- if empty .Values.rabbitmq.queue -}}
{{- fail "rabbitmq.queue is required - it names a specific piece of RabbitMQ infrastructure and must always be set explicitly" -}}
{{- end -}}
{{- $hasUsername := not (empty .Values.rabbitmq.auth.username) -}}
{{- $hasPassword := not (empty .Values.rabbitmq.auth.password) -}}
{{- if or (and $hasUsername (not $hasPassword)) (and $hasPassword (not $hasUsername)) -}}
{{- fail "rabbitmq.auth.username and rabbitmq.auth.password must be set together when using inline credentials" -}}
{{- end -}}
{{- end -}}

{{- define "ark-live.rabbitmqSecretName" -}}
{{- printf "%s-rabbitmq" (include "ark-live.fullname" .) -}}
{{- end -}}
