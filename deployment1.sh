#!/bin/bash

# Despliegue de la red 5G
-	helm install open5gs oci://registry-1.docker.io/gradiantcharts/open5gs --version 2.2.9 --values https://gradiant.github.io/5g-charts/docs/open5gs-ueransim-gnb/5gSA-values.yaml

# Despliegue de gNode

-	helm install ueransim-gnb oci://registry-1.docker.io/gradiant/ueransim-gnb --version 0.2.6 --values https://gradiant.github.io/5g-charts/docs/open5gs-ueransim-gnb/gnb-ues-values.yaml
