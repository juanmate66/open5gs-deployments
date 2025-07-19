#!/bin/bash

# Script para desplegar la red 5G con Open5GS y UERANSIM (gNodeB + UEs)

echo "==============================================="
echo "Paso 1: Desplegando Core 5G con Open5GS..."
echo "Archivo de configuración: 5gSA-values.yaml"
echo "==============================================="
helm install open5gs oci://registry-1.docker.io/gradiantcharts/open5gs \
  --version 2.2.9 \
  --values https://gradiant.github.io/5g-charts/docs/open5gs-ueransim-gnb/5gSA-values.yaml

echo "==============================================="
echo "Paso 2: Desplegando gNodeB + UEs con UERANSIM..."
echo "Archivo de configuración: gnb-ues-values.yaml"
echo "==============================================="
helm install ueransim-gnb oci://registry-1.docker.io/gradiant/ueransim-gnb \
  --version 0.2.6 \
  --values https://gradiant.github.io/5g-charts/docs/open5gs-ueransim-gnb/gnb-ues-values.yaml

echo "==============================================="
echo "✅ Despliegue completo. Puedes verificar los pods con:"
echo "microk8s kubectl get pods"
echo "==============================================="
