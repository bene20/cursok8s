#!/bin/bash

urlServico="http://172.17.0.7:31262"
numRequisicoes=10000
qtdReqsSimultaneas=10

#Manual: https://www.petefreitag.com/item/689.cfm

echo "Serão feitas $numRequisicoes requisições, sendo $qtdReqsSimultaneas simultâneas."
echo "ab -n $numRequisicoes -c $qtdReqsSimultaneas $urlServico/"
echo

ab -n $numRequisicoes -c $qtdReqsSimultaneas $urlServico/
