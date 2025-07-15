#!/bin/bash

# Despliegue de operador
-	helm install open5gs-operator oci://registry-1.docker.io/gradiantcharts/open5gs-operator --version 1.0.3
# Slice para desplegar servicios de 5G 
-	microk8s kubectl apply -f https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/open5gs-one-slice.yaml
# Slice para registrar usuarios
-	microk8s kubectl apply -f https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/open5gs-users.yaml
# Slice para habilitar segundo gNode
-	microk8s kubectl apply -f https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/open5gs-one-slice-uncommented.yaml
# Desplegar gNode 1 y gNode 2
-	helm install ueransim-gnb-1 oci://registry-1.docker.io/gradiant/ueransim-gnb --version 0.2.6 --values https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/gnb-1-values.yaml
-	helm install ueransim-gnb-2 oci://registry-1.docker.io/gradiant/ueransim-gnb --version 0.2.6 --values https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/gnb-2-values.yaml
