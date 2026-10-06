{{- define "ark-scraper.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ark-scraper.fullname" -}}
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

{{- define "ark-scraper.labels" -}}
app.kubernetes.io/name: {{ include "ark-scraper.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{- end -}}

{{- define "ark-scraper.validatePostgresAuth" -}}
{{- $hasUsername := not (empty .Values.postgres.auth.username) -}}
{{- $hasPassword := not (empty .Values.postgres.auth.password) -}}
{{- if or (and $hasUsername (not $hasPassword)) (and $hasPassword (not $hasUsername)) -}}
{{- fail "postgres.auth.username and postgres.auth.password must be set together when using inline credentials" -}}
{{- end -}}
{{- end -}}

{{- define "ark-scraper.validateMailer" -}}
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

{{- define "ark-scraper.postgresSecretName" -}}
{{- printf "%s-postgres" (include "ark-scraper.fullname" .) -}}
{{- end -}}

{{- define "ark-scraper.mailerSecretName" -}}
{{- printf "%s-mailer" (include "ark-scraper.fullname" .) -}}
{{- end -}}

{{- define "ark-scraper.arkConfigMapName" -}}
{{- printf "%s-ark" (include "ark-scraper.fullname" .) -}}
{{- end -}}
