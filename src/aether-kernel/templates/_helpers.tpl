{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kernel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kernel.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kernel.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Reusable cloudsql mountPath
*/}}
{{- define "kernel.clousqlmount" -}}
- mountPath: /secrets/cloudsql
      name: cloudsql-instance-credentials
      readOnly: true
{{- end -}}

{{/*
Reusable kernel environment variable section.
*/}}
{{- define "kernel.env" -}}
{{printf "%s\n" .}}
	env:
	- name: ADMIN_USERNAME
	  value: {{ .Values.app.admin_user }}
	- name: ADMIN_PASSWORD
	  valueFrom:
	    secretKeyRef:
	      name: {{ .Values.app.secret }}
	      key: kernel-django-admin-password
	- name: ADMIN_TOKEN
	  valueFrom:
	    secretKeyRef:
	      name: {{ .Values.app.secret }}
	      key: kernel-django-admin-token
	- name: PGPASSWORD
	  valueFrom:
	    secretKeyRef:
	      name: {{ .Values.app.secret }}
	      key: kernel-database-password
	- name: PGUSER
	  value: {{ .Values.app.db.user }}
	- name: PGPORT
	  value: {{ .Values.app.db.port | default 5432 | quote }}
	- name: PGHOST
	  value: {{ .Values.app.db.host }}
	- name: DB_PASSWORD
	  valueFrom:
	    secretKeyRef:
	      name: {{ .Values.app.secret }}
	      key: kernel-database-password
	- name: DEBUG
	  value: {{ if .Values.debug }}"1"{{ else }}""{{ end }}
	- name: LOGGING_FORMATTER
	  value: {{ .Values.app.logFormatter | default "json" }}
	- name: CAS_SERVER_URL
	  value: {{ .Values.ums_url }}
	- name: CSRF_COOKIE_DOMAIN
	  value: {{ .Values.domain }}
	- name: CSRF_TRUSTED_ORIGINS
	  value: .{{ .Values.domain }}
	- name: HOSTNAME
	  value: {{ .Values.app.url }}
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
	- name: DJANGO_SECRET_KEY
	  valueFrom:
	    secretKeyRef:
	      name: {{ .Values.app.secret }}
	      key: kernel-django-secret-key
	- name: DB_USERNAME
	  value: {{ .Values.app.db.user }}
	- name: DB_NAME
	  value: {{ .Values.app.db.name }}
	- name: KERNEL_READONLY_DB_USERNAME
	  value: {{ .Values.app.db.readonly_user }}
	- name: KERNEL_READONLY_DB_PASSWORD
	  valueFrom:
	    secretKeyRef:
	      name: {{ .Values.app.secret }}
	      key: kernel-readonly-db-password
	- name: WEB_SERVER_PORT
	  value: {{ quote .Values.app.port }}
{{- end }}

{{/*
Reusable kernel environment variable section.
*/}}
{{- define "kernel.readonlyuserenv" -}}
{{printf "%s\n" .}}
	env:
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
	- name: PGPORT
	  value: {{ .Values.app.db.port | default 5432 | quote }}
	- name: DB_NAME
	  value: {{ .Values.app.db.name }}
	- name: KERNEL_READONLY_DB_USERNAME
	  value: {{ .Values.app.db.readonly_user }}
	- name: KERNEL_READONLY_DB_PASSWORD
	  valueFrom:
	    secretKeyRef:
	      name: {{ .Values.app.secret }}
	      key: kernel-readonly-db-password
{{- end }}
