# Generic3 Chart Versions

Change Summary for this chart.

Newer versions are all backward-compatible.

### 0.4.3 (2024-04-03)
- Replaced option value `app.static_root` from `/var/www/static` to `/var/www/static/`
- Added more default values for `ingress.annotations` option:
```yaml
ingress:
  enabled: false
  annotations:
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/affinity-mode: persistent
    nginx.ingress.kubernetes.io/session-cookie-expires: "172800"
    nginx.ingress.kubernetes.io/session-cookie-hash: sha1
    nginx.ingress.kubernetes.io/session-cookie-max-age: "172800"
    nginx.ingress.kubernetes.io/session-cookie-name: "sticky-cookie"
```

### 0.3.2
- Added option to point to an existing PersistentVolumeClaim
```yaml
  existingClaim: false
    claimName:
```
- Added option to disable service default true
```yaml
service:
  enabled: true
```

### 0.3.1
-  Reduce resource requests and limits
```yaml
    requests:
      cpu: 64m
      memory: 256M
    limits:
      cpu: 250m
      memory: 1024M
```

### 0.3.0
- Collapse aether-producer into generic3
- Update redis subchart activation key-flag

### 0.2.7
- Collapse aether-kernel charts into generic3

### 0.2.6
- Collapse aether-kernel-ui charts into generic3

### 0.2.5
- Cut down default readiness probe delay to 20sec

### 0.2.4
- Add PodDisruptionBudgets

### 0.2.3
- Add HorizontalPodAutoscaling
- Collapse aether-*-consumer charts
