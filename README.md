# open5gs-deployments
# Guía para el despliegue de entornos de simulacion basados en Open5gs y Ueransim

# Implementación de microk8s
# Instalar microk8s
-	sudo snap install microk8s --classic
# Dar permisos para usar
-	sudo usermod -a -G microk8s admin
-	sudo mkdir -p ~/.kube
-	sudo chown -f -R admin ~/.kube
# Comprobar instalación
-	microk8s kubectl get nodes 
-	microk8s kubectl get ns
-	microk8s kubectl get svc
-	microk8s status --wait-ready
# Activar funciones de microk8s 
-	microk8s enable dashboard dns registry helm storage ingress
# Instalar helm 
-	sudo snap install helm --classic
# Dar permisos para que funcione 
-	sudo usermod -a -G microk8s admin
-	sudo chown -f -R admin ~/.kube
-	newgrp microk8s 
-	microk8s config > ~/.kube/config
# Reiniciar VM para implementar permisos 
-	sudo reboot
# Activar servicios de microk8s 
-	microk8s start
# Abrir dashboard de kuberentes 
-	microk8s dashboard-proxy
# Para deployment 1
# Implementar open5gs 
-	helm install open5gs oci://registry-1.docker.io/gradiantcharts/open5gs --version 2.2.9 --values https://gradiant.github.io/5g-charts/docs/open5gs-ueransim-gnb/5gSA-values.yaml
# Implementar Ueransim
-	helm install ueransim-gnb oci://registry-1.docker.io/gradiant/ueransim-gnb --version 0.2.6 --values https://gradiant.github.io/5g-charts/docs/open5gs-ueransim-gnb/gnb-ues-values.yaml
# Comprobar pods de los servicios 
-	microk8s kubectl get pods -A
# Ingreso a pod de usuarios 
-	microk8s kubectl exec deployment/ueransim-gnb-ues -ti – bash
# Hacer ping con los usuarios 
-	ping 10.45.0.x
# Para deployment 2
# Implementar open5gs
-	helm install open5gs-operator oci://registry-1.docker.io/gradiantcharts/open5gs-operator --version 1.0.3
-	microk8s kubectl apply -f https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/open5gs-one-slice.yaml
-	microk8s kubectl apply -f https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/open5gs-users.yaml
-	microk8s kubectl apply -f https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/open5gs-one-slice-uncommented.yaml
# Implementar ueransim
-	helm install ueransim-gnb-1 oci://registry-1.docker.io/gradiant/ueransim-gnb --version 0.2.6 --values https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/gnb-1-values.yaml

-	helm install ueransim-gnb-2 oci://registry-1.docker.io/gradiant/ueransim-gnb --version 0.2.6 --values https://gradiant.github.io/open5gs-operator/docs/complete-demo-ueransim/gnb-2-values.yaml
# Ingreso de usuarios en gnb 1 y gnb 2
-	microk8s kubectl exec deployment/ueransim-gnb-1-ues -ti – bash
-	microk8s kubectl exec deployment/ueransim-gnb-2-ues -ti – bash
# Hacer ping con los usuarios 
-	ping 10.45.0.x
# Para deployment 3
# Ingreso a pod populate
-	microk8s kubectl exec deployment/open5gs-populate -ti – bash
# Crear un nuevo usuario
-	open5gs-dbctl add_ue_with_slice 999700000000003 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111
# Comprobar registro en MongoDB
-	microk8s kubectl exec deployment/open5gs-mongodb -ti – bash
-	mongo
-	use open5gs
-	db.subscribers.find().pretty()
# Crear fichero con la información para crear nuevo usuario
amf:
hostname: open5gs-amf-ngap

mcc: '999'
mnc: '70'
sst: 1
sd: "0x111111"
tac: '0001'

ues:
enabled: true
count: 3
initialMSISDN: '0000000001'

# Despliegue de ueransim con nuevo fichero
-	helm install ueransim-gnb oci://registry-1.docker.io/gradiant/ueransim-gnb --version 0.2.6 –values <nombre del fichero>
# Ejemplo:
-	helm install ueransim-gnb oci://registry-1.docker.io/gradiant/ueransim-gnb --version 0.2.6 –values gnb-ues-values.yaml
# Ingreso a pod de usuarios 
-	microk8s kubectl exec deployment/ueransim-gnb-ues -ti – bash
# Hacer ping con los usuarios 
-	ping 10.45.0.x
# Instalar wireshark
-	sudo apt install wireshark
-	sudo dpkg-reconfigure wireshark-common
-	sudo usermod -a -G wireshark $(whoami)
-	sudo reboot

