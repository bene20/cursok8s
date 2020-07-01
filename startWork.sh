#!/bin/bash

oldDir=$(pwd)
workdir=$(realpath $(dirname $0))

echo "workdir=$workdir"

simOuNao(){
  select sn in "Sim" "Não"; do
    case $sn in
      Sim ) return 0;;
      Não ) return 1;;
    esac
  done
  echo
}

echo "Recriar base de dados do projeto?"
if simOuNao; then
  echo "============================================"
  echo "(Re)criando base de dados da aplicação"
  cd $workdir/mysql
  sh import.sh
fi

echo "Subir o container de banco de dados do projeto?"
if simOuNao; then
  echo "============================================"
  echo "Subindo o container do mysql"
  cd $workdir/mysql
  docker-compose up -d
fi

echo "Regerar as imagens das aplicações 'noticia' e 'sistema'?"
if simOuNao; then
  echo "============================================"
  echo "Gerando imagens das aplicações 'noticia' e 'sistema'"
  cd $workdir
  ./makeImages.sh <<EOF
1
1
EOF
fi

echo "============================================"
echo "Encerrando o Minikube caso esteja de pé..."
minikube stop
echo "Excluindo potencial cluster antigo do Minikube..."
minikube delete
echo "Carregando o Minikube..."
minikube start

echo "============================================"
echo "Criando o cluster K8S..."
cd $workdir
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
