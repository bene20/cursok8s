#!/bin/bash

oldDir=$(pwd)
workdir=$(realpath $(dirname $0))

echo "workdir=$workdir"

echo "============================================"
echo "(Re)criando base de dados da aplicação"
cd $workdir/mysql
sh import.sh

echo "============================================"
echo "Gerando imagens das aplicações 'noticia' e 'sistema'"
cd $workdir
./makeImages.sh <<EOF
1
1
EOF

echo "============================================"
echo "Encerrando o Minikube caso esteja de pé..."
minikube stop
echo "Excluindo potencial cluster antigo do Minikube..."
minikube delete
echo "Carregando o Minikube..."
minikube start

echo "============================================"
echo "Criando o cluster K8S..."
kubectl create -f kubernetes/permissao-imagens.yml 
kubectl create -f kubernetes/permissao-sessao.yml 
kubectl create -f kubernetes/deployment-aplicacao.yml 
kubectl create -f kubernetes/deployment-sistema.yml 
kubectl create -f kubernetes/servico-aplicacao-noticia.yml 
kubectl create -f kubernetes/servico-aplicacao-sistema.yml 
kubectl create -f kubernetes/servico-statefulset.yml 
kubectl create -f kubernetes/statefulset-sistema.yml

echo "============================================"
echo "Listando os dados de acesso à aplicação que roda no cluster:"
minikube service list

cd $oldDir
