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
  
  echo "(Re)fazer o build da imagem de sistema?"
  if simOuNao; then
    #VS (sistema)
    cp DockerfileSistema Dockerfile
    docker image build -t imagem-sistema .
    rm -f Dockerfile
    docker image tag imagem-sistema bene20/noticias-alura:vs
    docker image push bene20/noticias-alura:vs
  fi
  
  echo "(Re)fazer o build da imagem de noticias?"
  if simOuNao; then
    #VN (noticias)
    cp DockerfileNoticias Dockerfile
    docker image build -t noticias-alura .
    rm -f Dockerfile
    docker image tag noticias-alura bene20/noticias-alura:vn
    docker image push bene20/noticias-alura:vn
  fi
fi

echo "============================================"
echo "Encerrando o Minikube caso esteja de pé..."
minikube stop
echo "============================================"
echo "Excluindo potencial cluster antigo do Minikube..."
minikube delete
echo "============================================"
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
echo "Registrando o autoscale do deployment de notícias..."
minikube addons enable metrics-server
minikube addons enable logviewer
kubectl autoscale deployment aplicacao-noticia-deployment --cpu-percent=20 --min=1 --max=10

echo "============================================"
echo "Listando os dados de acesso à aplicação que roda no cluster:"
minikube service list


cd $oldDir
