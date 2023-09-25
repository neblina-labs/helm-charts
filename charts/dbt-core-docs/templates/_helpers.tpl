{{/*
Expand the name of the chart.
*/}}
{{- define "dbt-core-docs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dbt-core-docs.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dbt-core-docs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dbt-core-docs.labels" -}}
helm.sh/chart: {{ include "dbt-core-docs.chart" . }}
{{ include "dbt-core-docs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: dbt
service: dbt
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dbt-core-docs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dbt-core-docs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: dbt
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dbt-core-docs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dbt-core-docs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
