#!/bin/bash


for CHART in `ls src`; do helm3 package --destination charts/ src/$CHART; done
helm3 repo index . --url https://ehealthafrica.github.io/helm-charts --merge index.yaml
