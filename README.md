# apigee_gcp_openshift_setup

https://docs.cloud.google.com/apigee/docs/hybrid/v1.15/what-is-hybrid


crc setup

crc config set cpus 24
crc config set memory 50000
crc config set disk-size 500
crc config set enable-cluster-monitoring true

crc config set disable-update-check true

crc start

eval $(crc oc-env)




export gcp_project=my-apigee-project-44444
export gcp_sa=my-apigee-openshift-sa-44444
export gcp_domain=lwhirex.com

export PROJECT_ID=$gcp_project
export TOKEN=$(gcloud auth print-access-token)
export ORG_NAME=$PROJECT_ID
export ANALYTICS_REGION="us-central1"
export RUNTIMETYPE=HYBRID
export ENV_NAME="test"
export ENV_GROUP="test-group"
export DOMAIN=${PROJECT_ID}-test.hybrid-apigee.net
export INGRESS_DN=$DOMAIN
export GCP_REGION="us-central1"
export GCP_ZONE="us-central1-a"
export ENV_GROUP=test-group

export ENV_RELEASE_NAME=$ENV_GROUP

export ENV_GROUP_RELEASE_NAME=$ENV_GROUP


cd apigee-hybrid/helm-charts
export APIGEE_HELM_CHARTS_HOME=$PWD


export APIGEE_NAMESPACE=apigee


curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xvzf google-cloud-cli-linux-x86_64.tar.gz

./google-cloud-sdk/install.sh
source  .bashrc
gcloud init


curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-install-linux.tar.gz

https://console.redhat.com/openshift/install/gcp/installer-provisioned

https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz


https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz
tar -xvf crc-linux-amd64.tar.xz








