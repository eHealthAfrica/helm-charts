#!/bin/bash

for CHART in src/*; do helm package --destination charts/ $CHART; done
helm repo index . --url https://ehealthafrica.github.io/helm-charts --merge index.yaml
