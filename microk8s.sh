#!/bin/bash
# Instalar Microk8s, extension de kubernetes
sudo snap install microk8s --classic
# Dar permisos de uso
sudo usermod -a -G microk8s admin
sudo mkdir -p ~/.kube
sudo chown -f -R admin ~/.kube
# Permitir addons necesarios
microk8s enable dashboard dns registry helm storage ingress
# Instalar herramienta helm 
sudo snap install helm --classic
sudo usermod -a -G microk8s admin
sudo chown -f -R admin ~/.kube
newgrp microk8s 
microk8s config > ~/.kube/config

# Reiniciar VM para que se confirme los permisos
sudo reboot
