# Generic3 Chart Versions

Change Summary for this chart.

Newer versions are all backward-compatible.


### 0.5.11 (2026-11-05)
- deployment / statefulset: with an HPA rendered, `spec.replicas` carries the **live** count
  (Helm `lookup`), or `app.scaling.min` on first install, instead of `replicaCount`. Writing
  `replicaCount` let every deploy reset the HPA's choice: server-side apply (eha-workflow,
  Helm 4) re-asserts it or conflicts with the HPA's field ownership. Dropping the field instead
  would make the API default it to 1 on the next client-side upgrade. DEVOPS-447.
- `generic.hpaRendered` helper: one definition of "an HPA is rendered", shared by the HPA and
  the workload templates.
- pod-disruption-budget: `gt (float64 .Values.replicaCount) 1.0`. An integer from
  `--set replicaCount=N` previously failed with "incompatible types for comparison".

### 0.5.10 (2026-11-04)
- horizontal-pod-autoscaler: a Resource metric is emitted only when **every** container the
  workload renders requests that resource: app, `sidecar`, `cloudsql-proxy`, nginx and each
  `extraContainers` item. Utilization is summed across all containers, so 0.5.9's check of
  the app container alone still let a request-less sidecar break the HPA
  (`FailedGetResourceMetric`, stuck at its current replicas). DEVOPS-447.
- If no metric is computable for all containers, the HPA is not rendered and the workload
  keeps `replicaCount`, instead of failing the deploy. The 0.5.9 hard fail (app container has
  neither request) is unchanged.

### 0.5.9 (2026-10-19)
- horizontal-pod-autoscaler: emit a Resource metric only when the matching request is set on
  the app container. An HPA computes `Utilization` as `usage / request`, so a metric whose
  resource has no request is uncomputable — and one bad metric stops the HPA acting on the
  others, including ones that would have worked. The chart's own defaults set a memory request
  but never a cpu one while `scaling.enabled` is true, so a release taking the defaults got an
  HPA that was inert from creation. On eha-dev, 36 of 75 HPAs were in this state, surfacing as
  either `FailedGetResourceMetric: missing request for cpu` or `No recommendation`. If neither
  request is set the template now fails with an actionable message rather than rendering an HPA
  with no metrics, which would silently fall back to the API default of 80% cpu.

### 0.5.8 (2026-10-06)
- add `podAnnotations` (default `{}`), rendered onto the pod template of both the Deployment
  and the StatefulSet. Previously the pod template carried labels only, so pod-level scheduler
  annotations could not be set from an override at all. The motivating case is
  `karpenter.sh/do-not-disrupt: "true"` on single-replica services: Karpenter consolidates the
  node and evicts the only pod (`Evicted pod: Underutilized`), causing a 40-60s outage, and
  `pod-disruption-budget.yaml` is gated on `replicaCount > 1` so a PDB cannot cover them.

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
