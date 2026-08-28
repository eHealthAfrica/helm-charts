# Generic3 Chart Versions

Change Summary for this chart.

Newer versions are all backward-compatible.


### 0.5.8 (2026-08-28)
- horizontal-pod-autoscaler: only emit a Resource metric whose request is actually
  set on `app.resources.requests`, and skip the HPA entirely when neither cpu nor
  memory is requested.

  An HPA computes Utilization as usage/request, so a metric with no request is
  uncomputable. Kubernetes does not fail loudly: it sets `ScalingActive=False`
  with `FailedGetResourceMetric` ("missing request for cpu") and then autoscales
  on **nothing** - including the metric that would have worked. Because this chart
  defaults `app.resources.requests` to memory only while always emitting a cpu
  metric, every release taking the defaults got an HPA that was inert from
  creation, advertising elasticity it did not have.

  Backward-compatible for any release that sets a cpu request: the rendered HPA is
  byte-identical. Releases without one previously had a broken HPA and now get a
  working memory-only one - so a workload sitting above `app.scaling.utilization.memory`
  (default 70%) can begin scaling out where it previously could not. Check
  `app.scaling.min`/`max` on releases that omit a cpu request before upgrading.

### 0.5.7 (2026-07-28)
- vault-extra-secrets: `rolloutRestartTargets` now applies to **all** secrets in the list
  (previously only the first one, due to a `$first` guard). Each secret also accepts an
  optional `restartTargets` list to restart multiple/other Deployments — needed for shared
  credentials consumed across several releases (e.g. a DB secret used by many workloads).
  When `restartTargets` is omitted, `vaultextrasecrets.rolloutrestart: true` still defaults
  to the release's own Deployment (backward-compatible). Also sets `hmacSecretData: true`
  explicitly so VSO reliably detects secret-data changes and fires the rollout.

### 0.4.7 (2025-12-12)
- set minAvailable: 0  by default to allow for pod disruption 

### 0.4.6 (2025-12-12)
- add variable to specify the app health check path
- use extra memory limits for nginx

### 0.4.5 (2024-09-20)
- according to some best practice recommendations it is not good to set cpu resource limits on pods,
  remove the cpu setting from the defaults, they can still be set with the project overrides

### 0.4.4 (2024-05-14)
- Add 'Host' http header to health check, some servers rely on a proper hostname

### 0.4.3 (2024-04-03)
- Replaced option value `app.static_root` from `/var/www/static` to `/var/www/static/`

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
