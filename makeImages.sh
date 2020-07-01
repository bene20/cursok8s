#!/bin/bash
. ~/scripts/biblioteca_funcoes.sh

rm -f Dockerfile

echob "Build da imagem de sistema?"
if simOuNao; then
  #VS (sistema)
  cp DockerfileSistema Dockerfile
  docker image build -t imagem-sistema .
  docker image tag imagem-sistema bene20/noticias-alura:vs
  docker image push bene20/noticias-alura:vs
fi

echob "Build da imagem de noticias?"
if simOuNao; then
  #VN (noticias)
  cp DockerfileNoticias Dockerfile
  docker image build -t noticias-alura .
  docker image tag noticias-alura bene20/noticias-alura:vn
  docker image push bene20/noticias-alura:vn
fi

rm -f Dockerfile
