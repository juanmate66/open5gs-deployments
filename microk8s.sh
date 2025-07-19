#!/bin/bash

echo "==============================================="
echo "Paso 1: Instalando MicroK8s..."
echo "==============================================="
sudo snap install microk8s --classic

echo "==============================================="
echo "Paso 2: Añadiendo usuario actual ('admin') al grupo microk8s..."
echo "==============================================="
sudo usermod -a -G microk8s admin

echo "==============================================="
echo "Paso 3: Configurando permisos para kubeconfig..."
echo "==============================================="
sudo mkdir -p ~/.kube
sudo chown -f -R admin ~/.kube

echo "==============================================="
echo "Paso 4: Habilitando addons necesarios en MicroK8s..."
echo "Addons: dashboard, dns, registry, helm, storage, ingress"
echo "==============================================="
microk8s enable dashboard dns registry helm storage ingress

echo "==============================================="
echo "Paso 5: Instalando Helm..."
echo "==============================================="
sudo snap install helm --classic

echo "==============================================="
echo "Paso 6: Confirmando permisos de usuario y kubeconfig..."
echo "==============================================="
sudo usermod -a -G microk8s admin
sudo chown -f -R admin ~/.kube

echo "==============================================="
echo "Paso 7: Recargando grupo del usuario actual..."
echo "==============================================="
newgrp microk8s

echo "==============================================="
echo "Paso 8: Exportando configuración de MicroK8s a ~/.kube/config..."
echo "==============================================="
microk8s config > ~/.kube/config

echo "==============================================="
echo "✅ Instalación finalizada. Es necesario reiniciar la máquina para aplicar los permisos de grupo."
echo "Reiniciando en 5 segundos..."
echo "==============================================="
sleep 5
sudo reboot
