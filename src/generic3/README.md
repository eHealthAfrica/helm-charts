Generic3
========
A Generic Helm chart for installing Kubernetes Applications using Helm v3

## TL;DR;

```bash
$ helm install my-release eha/generic3 --namespace=release-ns -f /path-to-overide-file.yaml --version 0.1.4
```


## Introduction

This chart is a generic chart for deploying Kubernetes applications using Helm3.


## Prerequisites

- Kubernetes 1.8+ 
- Helm3 from version 3.0+
- PV provisioner support in the underlying infrastructure


## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release eha/generic
```

These commands deploys an application on the Kubernetes cluster in the default configuration.
The [Parameters](#Parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```


## Parameters

The following tables lists the configurable parameters of the Generic3 chart and their default values.


| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| app.args | list | `[]` |  |
| app.config.enabled | bool | `false` |  |
| app.db.create | bool | `false` |  |
| app.db.enabled | bool | `false` |  |
| app.db.host | string | `"127.0.0.1"` |  |
| app.db.name | string | `nil` |  |
| app.db.port | int | `5432` |  |
| app.db.secret | string | `"database-credentials"` |  |
| app.db.ssl.enabled | bool | `false` |  |
| app.db.type | string | `"postgres"` |  |
| app.db.user | string | `nil` |  |
| app.name | string | `nil` |  |
| app.port | string | `nil` |  |
| app.probe.initialDelaySeconds | int | `120` |  |
| app.probe.path | string | `"/health"` |  |
| app.probe.periodSeconds | int | `10` |  |
| app.probe.type | string | `"request"` |  |
| app.secret | string | `nil` |  |
| app.static_path | string | `"/static"` |  |
| app.static_root | string | `"/var/www/static"` |  |
| app.storage.bucket.credentialsSecret | string | `nil` |  |
| app.volume.accessMode | string | `"ReadWriteOnce"` |  |
| app.volume.enabled | bool | `false` |  |
| app.volume.mountPath | string | `nil` |  |
| app.volume.persist | bool | `false` |  |
| app.volume.size | string | `"10Gi"` |  |
| app.volume.type | string | `"standard"` |  |
| app.volume.existingClaim | bool | `false` |  |
| app.volume.claimName | string | `nil` |  |
| database.instance | string | `nil` |  |
| env_secrets.enabled | bool | `false` |  |
| env_secrets.name | string | `nil` |  |
| extraContainers | string | `""` |  |
| extraInitContainers | string | `""` |  |
| extraVolumes | string | `""` |  |
| extra_env_vars | object | `{}` |  |
| fullnameOverride | string | `nil` |  |
| gcp | bool | `true` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `nil` |  |
| image.tag | string | `nil` |  |
| imagePullSecrets.enabled | bool | `false` |  |
| imagePullSecrets.name | string | `nil` |  |
| ingress.annotations."cert-manager.io/acme-challenge-type" | string | `"dns01"` |  |
| ingress.annotations."cert-manager.io/acme-dns01-provider" | string | `"route53"` |  |
| ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt"` |  |
| ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| ingress.annotations."kubernetes.io/tls-acme" | string | `"true"` |  |
| ingress.annotations."monitor.stakater.com/enabled" | string | `"true"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/enable-cors" | string | `"true"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/proxy-body-size" | string | `"75M"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect" | string | `"true"` |  |
| ingress.annotations."statuscake.monitor.stakater.com/contact-group" | string | `"DevOps"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0] | string | `"chart-example.local"` |  |
| ingress.path | string | `"/"` |  |
| ingress.ssl.cert_secret | string | `"wildcard"` |  |
| ingress.ssl.letsencrypt | bool | `true` |  |
| nameOverride | string | `nil` |  |
| nginx.config | string | `"server {\n  {{- if .Values.debug }}\n  error_log /var/log/nginx/error.log info;\n  {{- else }}\n  access_log off;\n  {{- end }}\n  location /health {\n    proxy_pass http://127.0.0.1:{{ .Values.app.port }};\n  }\n}\nserver {\n  server_name {{ .Values.url }};\n  {{- if .Values.debug }}\n  error_log   /var/log/nginx/error.log info;\n  {{- else }}\n  access_log  off;\n  {{- end }}\n  # Max upload size\n  client_max_body_size 75M;   # adjust to taste\n\n  location {{ .Values.app.static_path }}/ {\n    alias {{ .Values.app.static_root }};\n  }\n  # Finally, send all non-static requests to the Django server.\n  location / {\n    proxy_pass http://127.0.0.1:{{ .Values.app.port }};\n    proxy_set_header        Host               $host;\n    proxy_set_header        X-Real-IP          $remote_addr;\n    proxy_set_header        X-Forwarded-For    $proxy_add_x_forwarded_for;\n    proxy_set_header        X-Forwarded-Host   $host:443;\n    proxy_set_header        X-Forwarded-Server $host;\n    proxy_set_header        X-Forwarded-Port   443;\n    proxy_set_header        X-Forwarded-Proto  https;\n    include    /etc/nginx/uwsgi_params; # or the uwsgi_params you installed manually\n  }\n}\n"` |  |
| nginx.enabled | bool | `false` |  |
| nodeSelector | object | `{}` |  |
| podAntiAffinity.enabled | bool | `true` |  |
| replicaCount | int | `3` |  |
| resourceType | string | `"deployment"` |  |
| resources | object | `{}` |  |
| service.enabled | bool | `true` |  |
| service.externalPort | string | `nil` |  |
| service.internalPort | string | `nil` |  |
| service.type | string | `"NodePort"` |  |
| sidecar.args | list | `[]` |  |
| sidecar.db.enabled | bool | `false` |  |
| sidecar.enabled | bool | `false` |  |
| sidecar.image.pullPolicy | string | `"IfNotPresent"` |  |
| sidecar.image.repository | string | `nil` |  |
| sidecar.image.tag | string | `nil` |  |
| sidecar.name | string | `nil` |  |
| sidecar.port | string | `nil` |  |
| sidecar.probe.initialDelaySeconds | int | `120` |  |
| sidecar.probe.path | string | `"/health"` |  |
| sidecar.probe.periodSeconds | int | `10` |  |
| sidecar.probe.type | string | `"request"` |  |
| tolerations | list | `[]` |  |
| url | string | `nil` |  |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release eha/generic3 \
  --set=nameOverride=demo,url=demo.app
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
