{{- define "ark-website-backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ark-website-backend.fullname" -}}
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

{{- define "ark-website-backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ark-website-backend.labels" -}}
helm.sh/chart: {{ include "ark-website-backend.chart" . }}
{{ include "ark-website-backend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "ark-website-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ark-website-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "ark-website-backend.validateApiKey" -}}
{{- $hasExisting := not (empty .Values.api.auth.existingSecret) -}}
{{- $hasInline := not (empty .Values.api.auth.apiKey) -}}
{{- if and $hasExisting $hasInline -}}
{{- fail "api.auth.existingSecret and api.auth.apiKey are mutually exclusive; set only one" -}}
{{- end -}}
{{- if not (or $hasExisting $hasInline) -}}
{{- fail "api.auth.existingSecret or api.auth.apiKey is required - the backend refuses to start without an API key" -}}
{{- end -}}
{{- end -}}

{{- define "ark-website-backend.validatePostgres" -}}
{{- if empty .Values.postgres.host -}}
{{- fail "postgres.host is required" -}}
{{- end -}}
{{- if empty .Values.postgres.database -}}
{{- fail "postgres.database is required" -}}
{{- end -}}
{{- $hasUsername := not (empty .Values.postgres.auth.username) -}}
{{- $hasPassword := not (empty .Values.postgres.auth.password) -}}
{{- if or (and $hasUsername (not $hasPassword)) (and $hasPassword (not $hasUsername)) -}}
{{- fail "postgres.auth.username and postgres.auth.password must be set together when using inline credentials" -}}
{{- end -}}
{{- end -}}

{{- define "ark-website-backend.apiSecretName" -}}
{{- printf "%s-api" (include "ark-website-backend.fullname" .) -}}
{{- end -}}

{{- define "ark-website-backend.postgresSecretName" -}}
{{- printf "%s-postgres" (include "ark-website-backend.fullname" .) -}}
{{- end -}}
