#!/bin/bash
#IMPORTANTE: TENER EL FICHERO  gnb-ues-values.yaml y modificar "count=3"
# Desplegar Core 5G
helm install open5gs oci://registry-1.docker.io/gradiantcharts/open5gs --version 2.2.9 --values https://gradiant.github.io/5g-charts/docs/open5gs-ueransim-gnb/5gSA-values.yaml

# Resgistrar un nuevo usuario a traves del populate
# Ingresar a Pod populate
microk8s kubectl exec deployment/open5gs-populate -ti – bash
# Registrar nuevo usuario
open5gs-dbctl add_ue_with_slice 999700000000003 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111

# Desplegar gNode con nuevo usuario 

helm install ueransim-gnb oci://registry-1.docker.io/gradiant/ueransim-gnb --version 0.2.6 –values gnb-ues-values.yaml
