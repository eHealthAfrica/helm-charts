# alloy-logs (wrapper chart) — DEVOPS-180

Renders the Grafana **Alloy** CR (`collectors.grafana.com/v1alpha1`) for the Alloy Operator — a file-based
pod-log collector (Promtail parity incl. `stream`/`filename`) shipping to Loki. Concourse is helm-only, so the
CR is deployed as this thin chart (there is no kubectl step).

## Deploy (per cluster, via system/<cluster>/alloy.pipeline.yaml)
1. `deploy-alloy-operator` — helm install `grafana/alloy-operator` (pinned 0.6.2).
2. `deploy-alloy-logs` — this chart, values from `system/<cluster>/overrides/alloy.yaml`.

Values: `namespace`, `clusterName`, `lokiUrl`, `lokiTenant` (Phase 2). Config is embedded in the template.

## Promtail decommission (NOT a pipeline change)
The node Promtail is **live/manual** (not in concourse) and was cut over by pausing its DaemonSet
(`nodeSelector: alloy-cutover-disabled=true`, reversible). After each cluster's soak, remove it manually:
```
helm uninstall promtail -n monitoring   # eha-dev / ehealth-africa-prod
# clinics-dev: the node promtail in eha-care-test (loki-internal target)
```
⚠️ Do NOT touch `eha-care/test/promtail.pipeline.yaml` — that is `promtail-test`, a SEPARATE custom component
(app-specific), out of scope for this migration.

## clinics-prod
Phase 2 only (no local Loki). Its pipeline exists but must not be run until the hub Loki exists and
`overrides/alloy.yaml lokiUrl` points at it.
