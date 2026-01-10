{{- define "ark-scraper-collector.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ark-scraper-collector.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "ark-scraper-collector.labels" -}}
app.kubernetes.io/name: {{ include "ark-scraper-collector.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{- end -}}

{{- define "ark-scraper-collector.validateRabbitmqAuth" -}}
{{- $hasUsername := not (empty .Values.rabbitmq.auth.username) -}}
{{- $hasPassword := not (empty .Values.rabbitmq.auth.password) -}}
{{- if or (and $hasUsername (not $hasPassword)) (and $hasPassword (not $hasUsername)) -}}
{{- fail "rabbitmq.auth.username and rabbitmq.auth.password must be set together when using inline credentials" -}}
{{- end -}}
{{- end -}}

{{- define "ark-scraper-collector.validateMailer" -}}
{{- if .Values.mailer.enabled -}}
{{- if empty .Values.mailer.apiUrl -}}
{{- fail "mailer.apiUrl is required when mailer.enabled is true" -}}
{{- end -}}
{{- if empty .Values.mailer.toEmails -}}
{{- fail "mailer.toEmails is required when mailer.enabled is true" -}}
{{- end -}}
{{- $hasExisting := not (empty .Values.mailer.api.existingSecret) -}}
{{- $hasInline := not (empty .Values.mailer.api.apiKey) -}}
{{- if and $hasExisting $hasInline -}}
{{- fail "mailer.api.existingSecret and mailer.api.apiKey are mutually exclusive; set only one when mailer.enabled is true" -}}
{{- end -}}
{{- if not (or $hasExisting $hasInline) -}}
{{- fail "mailer.api.existingSecret or mailer.api.apiKey must be set when mailer.enabled is true" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "ark-scraper-collector.rabbitmqSecretName" -}}
{{- printf "%s-rabbitmq" (include "ark-scraper-collector.fullname" .) -}}
{{- end -}}

{{- define "ark-scraper-collector.mailerSecretName" -}}
{{- printf "%s-mailer" (include "ark-scraper-collector.fullname" .) -}}
{{- end -}}

{{- define "ark-scraper-collector.arkConfigMapName" -}}
{{- printf "%s-ark" (include "ark-scraper-collector.fullname" .) -}}
{{- end -}}
