{{- define "ark-website-frontend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ark-website-frontend.fullname" -}}
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

{{- define "ark-website-frontend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ark-website-frontend.labels" -}}
helm.sh/chart: {{ include "ark-website-frontend.chart" . }}
{{ include "ark-website-frontend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "ark-website-frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ark-website-frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "ark-website-frontend.validateBackend" -}}
{{- if empty .Values.backend.url -}}
{{- fail "backend.url is required - nginx refuses to start without ARK_BACKEND_URL" -}}
{{- end -}}
{{- if not (regexMatch "^https?://[^/]+$" .Values.backend.url) -}}
{{- fail "backend.url must be scheme + host (+ port) with no path or trailing slash, e.g. http://ark-website-backend.ark.svc.cluster.local" -}}
{{- end -}}
{{- $hasExisting := not (empty .Values.backend.auth.existingSecret) -}}
{{- $hasInline := not (empty .Values.backend.auth.apiKey) -}}
{{- if and $hasExisting $hasInline -}}
{{- fail "backend.auth.existingSecret and backend.auth.apiKey are mutually exclusive; set only one" -}}
{{- end -}}
{{- if not (or $hasExisting $hasInline) -}}
{{- fail "backend.auth.existingSecret or backend.auth.apiKey is required - nginx refuses to start without ARK_BACKEND_API" -}}
{{- end -}}
{{- end -}}

{{- define "ark-website-frontend.apiSecretName" -}}
{{- printf "%s-api" (include "ark-website-frontend.fullname" .) -}}
{{- end -}}
