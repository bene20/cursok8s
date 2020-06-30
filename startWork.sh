#!/bin/bash

./makeImages.sh

minikube stop
minikube delete
minikube start

kubectl create -f kubernetes/permissao-imagens.yml 
kubectl create -f kubernetes/permissao-sessao.yml 
kubectl create -f kubernetes/deployment-aplicacao.yml 
kubectl create -f kubernetes/deployment-sistema.yml 
kubectl create -f kubernetes/servico-aplicacao-noticia.yml 
kubectl create -f kubernetes/servico-aplicacao-sistema.yml 
kubectl create -f kubernetes/servico-statefulset.yml 
kubectl create -f kubernetes/statefulset-sistema.yml

minikube service list
