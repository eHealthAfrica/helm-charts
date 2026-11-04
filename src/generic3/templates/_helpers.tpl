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

{{/*
"true" when the chart renders a HorizontalPodAutoscaler for this workload.
*/}}
{{- define "generic.hpaRendered" -}}
{{- $v := .Values -}}
{{- if and $v.app.scaling.enabled (ne $v.resourceType "cronjob") -}}
{{- $cpu := and (include "generic.allContainersRequest" (list . "cpu")) $v.app.scaling.utilization.cpu -}}
{{- $mem := and (include "generic.allContainersRequest" (list . "memory")) $v.app.scaling.utilization.memory -}}
{{- if or $cpu $mem -}}true{{- end -}}
{{- end -}}
{{- end -}}

{{/*
spec.replicas for a Deployment or StatefulSet. With an HPA it carries the live
count, so a deploy neither resets the HPA's choice nor drops the field (which
the API defaults to 1). On first install it starts at the HPA minimum.
Usage: include "generic.replicas" (list . "Deployment")
*/}}
{{- define "generic.replicas" -}}
{{- $root := index . 0 -}}
{{- $kind := index . 1 -}}
{{- if eq (include "generic.hpaRendered" $root) "true" -}}
{{- $live := lookup "apps/v1" $kind $root.Release.Namespace (include "generic.fullname" $root) -}}
{{- $n := dig "spec" "replicas" nil ($live | default dict) -}}
{{- if kindIs "invalid" $n }}{{ $root.Values.app.scaling.min }}{{ else }}{{ $n }}{{ end -}}
{{- else -}}
{{- $root.Values.replicaCount -}}
{{- end -}}
{{- end -}}
