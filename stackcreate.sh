#!/usr/bin/env bash

#Introducimos el nombre de la pila a crear a traves de argumentos de este script
STACK_NAME=Pila



#Creamos la pila con el comando deploy de cloudformation
echo "Creando stack ... "
aws cloudformation deploy --stack-name $STACK_NAME --template-file ubuntu.yml --capabilities CAPABILITY_IAM

if [ $? -eq 0 ]; then
    aws cloudformation list-exports \
        --query "Exports[?Name=='IPaddress'].Value"
fi

final="Finalizado el proceso de creación de la pila '"$STACK_NAME"'"
echo final