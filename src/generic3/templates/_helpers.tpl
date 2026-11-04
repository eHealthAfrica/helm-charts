{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "generic.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "generic.fullname" -}}
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
{{- define "generic.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
"true" when every container the workload renders requests the given resource
("cpu" or "memory"). Utilization is usage / request summed over ALL containers,
so one container without the request makes that HPA metric uncomputable.
Usage: include "generic.allContainersRequest" (list . "cpu")
*/}}
{{- define "generic.allContainersRequest" -}}
{{- $root := index . 0 -}}
{{- $r := index . 1 -}}
{{- $v := $root.Values -}}
{{- $req := list -}}
{{- $req = append $req ($v.app.resources | default dict) -}}
{{- if or $v.sidecar.enabled (and $v.app.db.enabled $v.gcp) -}}
{{- $req = append $req ($v.sidecar.resources | default dict) -}}
{{- end -}}
{{- if $v.nginx.enabled -}}
{{- $req = append $req ((eq $v.resourceType "statefulset" | ternary $v.sidecar.resources $v.nginx.resources) | default dict) -}}
{{- end -}}
{{- if $v.extraContainers -}}
{{- range (tpl $v.extraContainers $root | fromYamlArray) -}}
{{- $req = append $req ((kindIs "map" .) | ternary (get . "resources") dict | default dict) -}}
{{- end -}}
{{- end -}}
{{- $ok := true -}}
{{- range $req -}}
{{- if not (dig "requests" $r "" .) -}}{{- $ok = false -}}{{- end -}}
{{- end -}}
{{- if $ok -}}true{{- end -}}
{{- end -}}
