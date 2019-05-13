{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "odk.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "odk.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "odk.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Reusable ODK environment variable section.
*/}}
{{- define "odk.env" -}}
- name: DJANGO_STORAGE_BACKEND
  value: {{ .Values.app.storage.backend }}
- name: BUCKET_NAME
  value: {{ .Values.app.storage.bucket.name }}
{{ if .Values.provider.aws }}
- name: AWS_S3_REGION_NAME
  value: {{ .Values.app.storage.bucket.region }}
- name: AWS_S3_ENDPOINT_URL
  value: s3.{{ .Values.app.storage.bucket.region }}.amazonaws.com
- name: AWS_DEFAULT_ACL
  value: {{ .Values.app.storage.bucket.default_acl }}
{{ end }}
{{ if .Values.provider.gcp }}
- name: GOOGLE_APPLICATION_CREDENTIALS
  value: {{ .Values.app.storage.bucket.credentialsPath }}
{{ end }}
{{ if .Values.sentry.enabled }}
- name: SENTRY_DSN
  valueFrom:
    secretKeyRef:
      name: {{ .Values.app.secret }}
      key: sentry-dsn
{{ end }}
- name: CAS_SERVER_URL
  value: {{ .Values.ums_url }}
- name: CSRF_COOKIE_DOMAIN
  value: {{ .Values.domain }}
- name: CSRF_TRUSTED_ORIGINS
  value: .{{ .Values.domain }}
- name: HOSTNAME
  value: "{{ .Values.app.url }}"
- name: DJANGO_SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.app.secret }}
      key: odk-django-secret-key
- name: ADMIN_USERNAME
  value: {{ .Values.app.admin_user }}
- name: ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.app.secret }}
      key: odk-django-admin-password
- name: ADMIN_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ .Values.app.secret }}
      key: odk-django-admin-token
- name: AETHER_KERNEL_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ .Values.app.kernel.secret }}
      key: kernel-django-admin-token
- name: AETHER_KERNEL_URL
  value: {{ .Values.app.kernel.url }}
- name: AETHER_KERNEL_URL_TEST
  value: {{ .Values.app.kernel.url_test }}
- name: DEBUG
  value: {{ if .Values.debug }}"1"{{ else }}""{{ end }}
- name: TESTING
  value: {{ if .Values.testing }}"1"{{ else }}""{{ end }}
- name: PGUSER
  value: {{ .Values.app.db.user }}
- name: PGPORT
  value: {{ .Values.app.db.port | default 5432 | quote }}
- name: PGHOST
  valueFrom :
    secretKeyRef:
      name: {{ .Values.app.db.secret }}
      key: host
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.app.secret }}
      key: odk-database-password
- name: DB_NAME
  value: {{ .Values.app.db.name }}
# `WEB_SERVER_PORT` is kept around for compatibility with the old tests,
# which are using different ports in different environments. Once all
# tests have been updated to run inside the cluster, `WEB_SERVER_PORT`
# can be removed.
- name: WEB_SERVER_PORT
  value: {{ quote .Values.app.port }}
{{- end -}}

{{/*
Reusable ODK environment variable section.
*/}}
{{- define "odk.initenv" -}
- name: PGHOST
  valueFrom :
    secretKeyRef:
      name: {{ .Values.app.db.secret }}
      key: host
- name: PGUSER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.app.db.secret }}
      key: user
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.app.db.secret }}
      key: password
- name: DB_USERNAME
  value: {{ .Values.app.db.user }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.app.secret }}
      key: odk-database-password
- name: DB_NAME
  value: {{ .Values.app.db.name }}
{{- end -}}
