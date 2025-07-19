#!/bin/bash

# Script automatizado para desplegar Core 5G, slices y gNodeBs con operador Open5GS

echo "==============================================="
echo "Paso 1: Instalando Open5GS Operator..."
echo "==============================================="
helm install open5gs-operator oci://registry-1.docker.io/gradiantcharts/open5gs-operator --version 1.0.3

echo "==============================================="
echo "Paso 2: Aplicando slice principal del Core 5G..."
echo "Archivo: open5gs-one-slice.yaml"
echo "==============================================="
microk8s kubectl apply -f https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/open5gs-one-slice.yaml

echo "==============================================="
echo "Paso 3: Registrando usuarios en la base de datos..."
echo "Archivo: open5gs-users.yaml"
echo "==============================================="
microk8s kubectl apply -f https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/open5gs-users.yaml

echo "==============================================="
echo "Paso 4: Aplicando slice adicional para segundo gNB..."
echo "Archivo: open5gs-one-slice-uncommented.yaml"
echo "==============================================="
microk8s kubectl apply -f https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/open5gs-one-slice-uncommented.yaml

echo "==============================================="
echo "Paso 5: Desplegando gNodeB 1 con UERANSIM..."
echo "Archivo: gnb-1-values.yaml"
echo "==============================================="
helm install ueransim-gnb-1 oci://registry-1.docker.io/gradiant/ueransim-gnb \
  --version 0.2.6 \
  --values https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/gnb-1-values.yaml

echo "==============================================="
echo "Paso 6: Desplegando gNodeB 2 con UERANSIM..."
echo "Archivo: gnb-2-values.yaml"
echo "==============================================="
helm install ueransim-gnb-2 oci://registry-1.docker.io/gradiant/ueransim-gnb \
  --version 0.2.6 \
  --values https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/gnb-2-values.yaml

echo "==============================================="
echo "✅ Despliegue completo de Core 5G y gNodeBs finalizado"
echo "Puedes verificar los pods con: microk8s kubectl get pods"
echo "==============================================="
