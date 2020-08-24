#!/bin/bash

PROJECT_ID="spiritual-grin-251709"
INSTANCE_NAME="osjnp-stream01"
ZONE="asia-east1-b"

 echo -e "\n----------------------------------------------------------------"
 echo -e "You have provided the instance name: ${INSTANCE_NAME}."
 echo -e "----------------------------------------------------------------"

VM_STATUS=$(gcloud compute instances list --project ${PROJECT_ID} --format='value(status)' --filter=name=osjnp-stream01)

if [[ ${VM_STATUS} == "" ]];
then
   echo "Provided instance name is not found";
   exit 1;
else
    if [[ ${VM_STATUS} == "TERMINATED" ]];
    then
      echo "Starting VM ${INSTANCE_NAME}..." 
      gcloud compute instances start ${INSTANCE_NAME} --zone $ZONE --project ${PROJECT_ID}  > /dev/null 2>&1
    else 
      echo "Instance is already in running state!"
        
    fi
fi

echo "Connecting to instance..."
EXTERNAL_IP=$(echo $(gcloud compute instances list --filter="name(${INSTANCE_NAME})" --project ${PROJECT_ID} --format='value(EXTERNAL_IP)'))
KEY_PATH="./kadmin"
MY_PUBLICIP=$(curl -s icanhazip.com)
gcloud compute firewall-rules update osjnonprodfw01-ssh  --project ${PROJECT_ID} --source-ranges "${MY_PUBLICIP}" > /dev/null 2>&1

ssh -i ${KEY_PATH} kadmin@"${EXTERNAL_IP}" -o StrictHostKeyChecking=no
