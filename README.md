eHealth Africa's Helm Charts
===

Repository of all the helm charts provided by the [eHealth Africa](https://www.ehealthafrica.org/) NGO.


Installing
---

To use these helm charts, first you have to add the repository:
```bash
helm repo add eha https://ehealthafrica.github.io/helm-charts/
```


Usage
---

Once added to your repos you can install any chart by prefixing its name with the repo name:
```bash
helm install eha/kernel -f ./my-values.yaml
```

Where `my-values.yaml` is a custom values file with your own configuration.


Release
---

To release a new chart run the following command from the root of the repo:
```bash
for CHART in `ls src`; do helm package --destination charts/ src/$CHART; done
helm repo index . --url https://ehealthafrica.github.io/helm-charts --merge index.yaml
```
