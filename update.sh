#!/bin/bash


for CHART in `ls src`; do helm package --destination charts/ src/$CHART; done
helm repo index . --url https://ehealthafrica.github.io/helm-charts --merge index.yaml
