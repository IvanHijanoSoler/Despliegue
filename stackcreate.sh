#!/usr/bin/env bash

#Introducimos el nombre de la pila a crear a traves de argumentos de este script
STACK_NAME=$1

#Comprobamos que se ha introducido un nombre. De no haberse hecho, se avisa y cierra el script
if [ -z "$1" ]
  then
    echo "Introducir nombre de  la pila a crear."
    exit 1
fi

#Creamos la pila con el comando deploy de cloudformation
echo "Creando stack ... "
aws cloudformation deploy --stack-name $1 --template-file main.yml --capabilities CAPABILITY_IAM

final="Finalizado el proceso de creación de la pila '"STACK_NAME"'"
echo final