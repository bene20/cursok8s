#!/bin/bash
. ~/scripts/biblioteca_funcoes.sh

rm -f Dockerfile

echob "Build da imagem de sistema (V2)?"
if simOuNao; then
  #V2 (sistema)
  cp Dockerfilev2 Dockerfile
  docker image build -t imagem-sistema .
  docker image tag imagem-sistema bene20/noticias-alura:v2
  docker image push bene20/noticias-alura:v2
fi

echob "Build da imagem de noticias (V3)?"
if simOuNao; then
  #V3 (noticias)
  cp Dockerfilev3 Dockerfile
  docker image build -t noticias-alura .
  docker image tag noticias-alura bene20/noticias-alura:v3
  docker image push bene20/noticias-alura:v3
fi

rm -f Dockerfile
