#!/usr/bin/env bash

#Determinamos la pila a borrar por su nombre en el argumento de este script
STACK_NAME=$1

#Nos aseguramos de que se ha introducido un argumento
if [ -z "$1" ]
  then
    echo "Introducir nombre de  la pila a crear."
    exit 1
fi

#Eliminamos el stack
echo "Eliminando stack ... "
aws cloudformation delete-stack --stack-name $1