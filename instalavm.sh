#!/bin/bash

cd /var/opt/iso-images-storage

ls /var/opt/iso-images-storage
while true; do 
 printf "Escolha uma das imagens listadas: " ; read opcao_imagem
   if [ -n "$opcao_imagem" ]; then
   break
  fi
done

imagem=$opcao_imagem

xe sr-list 
while true; do 
 printf "Escolha um sr uuid listado: " ; read sr_uuid
  if [ -n "$sr_uuid" ]; then
   break
  fi
done

xe network-list
while true; do 
 printf "Escolha uma rede listada: " ; read network_uuid
  if [ -n "$network_uuid" ]; then
   break
  fi
done

cria_vms(){
 while true; do
  printf "Digite o nome da VM: " ; read vm_nome
  if [ -n "$vm_nome" ]; then
	break
  fi
 done 
 vm_uuid=$(xe vm-install new-name-label=$vm_nome template=Other\ install\ media)
 vdi_uuid=$(xe vdi-create sr-uuid=$sr_uuid name-label=$vm_nome virtual-size=35GiB)
 vbd_uuid=$(xe vbd-create vm-uuid=$vm_uuid vdi-uuid=$vdi_uuid device=xvda)
 xe vif-create vm-uuid=$vm_uuid network-uuid=$network_uuid device=0
 xe vm-cd-add uuid=$vm_uuid cd-name=$imagem device=1
 #adicionar cpu, memória, editar descrição 
 xe vm-memory-limits-set dynamic-max=2GiB dynamic-min=2GiB static-max=2GiB static-min=512MiB uuid=$vm_uuid
 xe vm-start uuid=$vm_uuid
 #xe vm-cd-eject vm=$vm_nome
}

if [ ! -f $imagem ]; then
	{ echo "Arquivo não existe" && exit; }
else
	echo "Arquivo existe, dando continuidade ao processo"
	cria_vms
fi

if [ $? -eq 0 ]
then
	echo "O script foi executado com sucesso"
else
	echo "Ocorreram erros na execução do script"
fi

