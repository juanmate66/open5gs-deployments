#!/bin/bash

# Desplegar Core 5G
echo "Instalando Open5GS Core..."
helm install open5gs oci://registry-1.docker.io/gradiantcharts/open5gs \
  --version 2.2.9 \
  --values https://gradiant.github.io/5g-charts/docs/open5gs-ueransim-gnb/5gSA-values.yaml

# Esperar a que el pod open5gs-populate esté listo
echo "Esperando a que el pod open5gs-populate esté listo..."
until microk8s kubectl get pod -l app.kubernetes.io/component=populate -o jsonpath="{.items[0].status.phase}" | grep -q "Running"; do
    sleep 3
    echo -n "."
done
echo -e "\nPod populate listo."

# Ejecutar el comando open5gs-dbctl dentro del pod
echo "Registrando nuevo UE en la base de datos..."
POPULATE_POD=$(microk8s kubectl get pod -l app.kubernetes.io/component=populate -o jsonpath="{.items[0].metadata.name}")
microk8s kubectl exec -i "$POPULATE_POD" -- \
  open5gs-dbctl add_ue_with_slice 999700000000003 \
  465B5CE8B199B49FAA5F0A2EE238A6BC \
  E8ED289DEBA952E4283B54E88E6183CA \
  internet 1 111111

# Desplegar gNB y UEs
echo "Desplegando UERANSIM (gNB y UEs)..."
helm install ueransim-gnb oci://registry-1.docker.io/gradiant/ueransim-gnb \
  --version 0.2.6 \
  --values gnb-ues-values.yaml
