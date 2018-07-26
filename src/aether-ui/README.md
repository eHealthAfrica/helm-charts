Aether UI helm chart
===

Values:
* app.adminUser: The admin username (to be created at install time)
* app.kernelUrl: The URL of the kernel
* app.db.secrets: The name of the secret resource holding the DB password
* app.db.host: The DB host name
* app.db.name: The DB name to be used
* app.db.port: The DB port
* app.db.user: The user to connect to the DB
* debug: Enables debug logs for all containers
* domain: The domain for the DNS records. Default: `http://RELEASE-NAME.{{ .Values.domain }}`
* image.repository: The name of the image. Default: _"ehealthafrica/aether-ui"_
* image.tag: The docker image tag
* ingress.annotations: A list of annotations for the ingress
* ingress.enabled: Enable/disable ingress creation. Default: `true`
* pullPolicy: The `imagePullPolicy` to use. Default: _"Always"_
* replicaCount: The number of replicas. Default: `3`
