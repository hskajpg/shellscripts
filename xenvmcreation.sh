#This Script automates the creation of VM's on XenServer
#!/bin/bash

cd /var/opt/iso-images-storage

ls /var/opt/iso-images-storage
while true; do 
 printf "Pick one of the listed images: " ; read image_option
   if [ -n "$image_option" ]; then
   break
  fi
done

image=$image_option

xe sr-list 
while true; do 
 printf "Pick one of the listed sr uuid's: " ; read sr_uuid
  if [ -n "$sr_uuid" ]; then
   break
  fi
done

xe network-list
while true; do 
 printf "Pick one of the listed networks: " ; read network_uuid
  if [ -n "$network_uuid" ]; then
   break
  fi
done

create_vms(){
 while true; do
  printf "Type the name of the VM: " ; read vm_name
  if [ -n "$vm_name" ]; then
	break
  fi
 done 
 vm_uuid=$(xe vm-install new-name-label=$vm_name template=Other\ install\ media)
 vdi_uuid=$(xe vdi-create sr-uuid=$sr_uuid name-label=$vm_name virtual-size=35GiB)
 vbd_uuid=$(xe vbd-create vm-uuid=$vm_uuid vdi-uuid=$vdi_uuid device=xvda)
 xe vif-create vm-uuid=$vm_uuid network-uuid=$network_uuid device=0
 xe vm-cd-add uuid=$vm_uuid cd-name=$imagem device=1
 #add cpu, memory, edit description 
 xe vm-memory-limits-set dynamic-max=2GiB dynamic-min=2GiB static-max=2GiB static-min=512MiB uuid=$vm_uuid
 xe vm-start uuid=$vm_uuid
 #xe vm-cd-eject vm=$vm_nome
}

if [ ! -f $imagem ]; then
	{ echo "File does not exist" && exit; }
else
	echo "File exists, continuing the process"
	cria_vms
fi

if [ $? -eq 0 ]
then
	echo "The script ended successfully"
else
	echo "There were erros in the script execution"
fi
