crc start
eval $(crc oc-env)
 oc login -u kubeadmin  https://api.crc.testing:6443
 oc get  nodes



first time in linux workstation
# gcloud init
login to GCP UI by URL
give project name
or 

next again login
gcloud auth login

export gcp_project=vimalapigeeproject13

gcloud config set project ${gcp_project}
gcloud config list
gcloud projects list




gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
gcloud config list

from other Linux:
gcloud alpha billing projects link ${gcp_project} --billing-account $(gcloud alpha billing accounts list | tail -1  | awk '{print $1 }')

or

from gcloud shell"
gcloud alpha billing projects link ${gcp_project} --billing-account $(gcloud alpha billing accounts list | head -1  | awk '{print $2 }')

export gcp_project=vimalapigeeproject13
export PROJECT_ID=$gcp_project
export ORG_NAME=$PROJECT_ID

gcloud services enable \
    apigee.googleapis.com \
    apigeeconnect.googleapis.com \
    cloudresourcemanager.googleapis.com \
    monitoring.googleapis.com \
    pubsub.googleapis.com  --project $PROJECT_ID

gcloud services list --project $PROJECT_ID


export TOKEN=$(gcloud auth print-access-token)
export ORG_NAME=$PROJECT_ID
export ANALYTICS_REGION="us-central1"
export RUNTIMETYPE=HYBRID


curl -H "Authorization: Bearer $TOKEN" -X POST -H "content-type:application/json" \
  -d '{
    "name":"'"$ORG_NAME"'",
    "runtimeType":"'"$RUNTIMETYPE"'",
    "analyticsRegion":"'"$ANALYTICS_REGION"'"
  }' \
  "https://apigee.googleapis.com/v1/organizations?parent=projects/$PROJECT_ID"

curl -H "Authorization: Bearer $TOKEN" \
  "https://apigee.googleapis.com/v1/organizations/$ORG_NAME/operations/$LONG_RUNNING_OPERATION_ID"

curl -H "Authorization: Bearer $TOKEN" \
  "https://apigee.googleapis.com/v1/organizations/$ORG_NAME"

gcloud apigee organizations list

create environment and enviornment group with hostname ${PROJECT_ID}-test.hybrid-apigee.net , from GCP UI:

export ENV_NAME="test"
export ENV_GROUP="test-group"
export DOMAIN=${PROJECT_ID}-test.hybrid-apigee.net
export INGRESS_DN=$DOMAIN
export GCP_REGION="us-central1"
export GCP_ZONE="us-central1-a"



mkdir -p apigee-hybrid/helm-charts

cd apigee-hybrid/helm-charts
export APIGEE_HELM_CHARTS_HOME=$PWD

export CHART_REPO=oci://us-docker.pkg.dev/apigee-release/apigee-hybrid-helm-charts
export CHART_VERSION=1.15.1
helm pull $CHART_REPO/apigee-operator --version $CHART_VERSION --untar
helm pull $CHART_REPO/apigee-datastore --version $CHART_VERSION --untar
helm pull $CHART_REPO/apigee-env --version $CHART_VERSION --untar
helm pull $CHART_REPO/apigee-ingress-manager --version $CHART_VERSION --untar
helm pull $CHART_REPO/apigee-org --version $CHART_VERSION --untar
helm pull $CHART_REPO/apigee-redis --version $CHART_VERSION --untar
helm pull $CHART_REPO/apigee-telemetry --version $CHART_VERSION --untar
helm pull $CHART_REPO/apigee-virtualhost --version $CHART_VERSION --untar


chmod +x $APIGEE_HELM_CHARTS_HOME/apigee-operator/etc/tools/create-service-account

$APIGEE_HELM_CHARTS_HOME/apigee-operator/etc/tools/create-service-account \
  --env prod \
  --dir $APIGEE_HELM_CHARTS_HOME/service-accounts



ls -l $APIGEE_HELM_CHARTS_HOME/service-accounts/

oc create namespace apigee
export APIGEE_NAMESPACE=apigee

oc create secret generic apigee-logger-svc-account \
  --from-file="client_secret.json=$APIGEE_HELM_CHARTS_HOME/service-accounts/$PROJECT_ID-apigee-logger.json" \
  -n $APIGEE_NAMESPACE

oc create secret generic apigee-metrics-svc-account \
  --from-file="client_secret.json=$APIGEE_HELM_CHARTS_HOME/service-accounts/$PROJECT_ID-apigee-metrics.json" \
  -n $APIGEE_NAMESPACE

oc create secret generic apigee-watcher-svc-account \
  --from-file="client_secret.json=$APIGEE_HELM_CHARTS_HOME/service-accounts/$PROJECT_ID-apigee-watcher.json" \
  -n $APIGEE_NAMESPACE

oc create secret generic apigee-udca-svc-account \
  --from-file="client_secret.json=$APIGEE_HELM_CHARTS_HOME/service-accounts/$PROJECT_ID-apigee-udca.json" \
  -n $APIGEE_NAMESPACE
    
oc create secret generic apigee-mart-svc-account \
  --from-file="client_secret.json=$APIGEE_HELM_CHARTS_HOME/service-accounts/$PROJECT_ID-apigee-mart.json" \
  -n $APIGEE_NAMESPACE

oc create secret generic apigee-synchronizer-svc-account \
  --from-file="client_secret.json=$APIGEE_HELM_CHARTS_HOME/service-accounts/$PROJECT_ID-apigee-synchronizer.json" \
  -n $APIGEE_NAMESPACE

oc create secret generic apigee-runtime-svc-account \
  --from-file="client_secret.json=$APIGEE_HELM_CHARTS_HOME/service-accounts/$PROJECT_ID-apigee-runtime.json" \
  -n $APIGEE_NAMESPACE

oc create secret generic apigee-mint-task-scheduler-svc-account \
  --from-file="client_secret.json=$APIGEE_HELM_CHARTS_HOME/service-accounts/$PROJECT_ID-apigee-mint-task-scheduler.json" \
  -n $APIGEE_NAMESPACE


oc get secret -n $APIGEE_NAMESPACE




gcloud auth list

ROOT_EMAIL="preeti13101311@gmail.com"

gcloud projects get-iam-policy $PROJECT_ID  \
  --flatten="bindings[].members" \
  --format='table(bindings.role)' \
  --filter="bindings.members:${ROOT_EMAIL}"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member user:${ROOT_EMAIL} \
  --role roles/apigee.admin

gcloud projects get-iam-policy $PROJECT_ID  \
  --flatten="bindings[].members" \
  --format='table(bindings.role)' \
  --filter="bindings.members:${ROOT_EMAIL}"


export TOKEN=$(gcloud auth print-access-token)


gcloud iam service-accounts list --project ${PROJECT_ID} --filter "apigee-synchronizer"

curl -X GET -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type:application/json" \
  "https://apigee.googleapis.com/v1/organizations/${ORG_NAME}/controlPlaneAccess"

curl -X PATCH -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type:application/json" \
  "https://apigee.googleapis.com/v1/organizations/${ORG_NAME}/controlPlaneAccess?update_mask=synchronizer_identities" \
  -d "{\"synchronizer_identities\": [\"serviceAccount:apigee-synchronizer@${ORG_NAME}.iam.gserviceaccount.com\"]}"

curl -X GET -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type:application/json" \
  "https://apigee.googleapis.com/v1/organizations/${ORG_NAME}/controlPlaneAccess"


gcloud iam service-accounts list --project ${PROJECT_ID} --filter "apigee-runtime OR apigee-mart OR apigee-mint-task-scheduler"


curl -X GET -H "Authorization: Bearer $(gcloud auth print-access-token)"  \
  -H "Content-Type:application/json"  \
  "https://apigee.googleapis.com/v1/organizations/$ORG_NAME/operations/$OPERATION_ID"

curl "https://apigee.googleapis.com/v1/organizations/$ORG_NAME/controlPlaneAccess" \
-H "Authorization: Bearer $(gcloud auth print-access-token)"


curl -X PATCH -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type:application/json" \
  "https://apigee.googleapis.com/v1/organizations/$ORG_NAME/controlPlaneAccess?update_mask=analytics_publisher_identities" \
  -d "{\"analytics_publisher_identities\": [\"serviceAccount:apigee-mart@$ORG_NAME.iam.gserviceaccount.com\",\"serviceAccount:apigee-runtime@$ORG_NAME.iam.gserviceaccount.com\"]}"


curl -X PATCH -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type:application/json" \
  "https://apigee.googleapis.com/v1/organizations/$ORG_NAME/controlPlaneAccess?update_mask=analytics_publisher_identities" \
  -d "{\"analytics_publisher_identities\": [\"serviceAccount:apigee-mart@$ORG_NAME.iam.gserviceaccount.com\",\"serviceAccount:apigee-runtime@$ORG_NAME.iam.gserviceaccount.com\",\"serviceAccount:apigee-mint-task-scheduler@$ORG_NAME.iam.gserviceaccount.com\"]}"


gcloud auth activate-service-account apigee-udca@${PROJECT_ID}.iam.gserviceaccount.com   --key-file=$APIGEE_HELM_CHARTS_HOME/service-accounts/${PROJECT_ID}-apigee-udca.json
gcloud auth list

curl -H "Authorization: Bearer $TOKEN" "https://apigee.googleapis.com/v1/organizations/${PROJECT_ID}/environments"
curl -H "Authorization: Bearer $TOKEN" "https://apigee.googleapis.com/v1/organizations/${PROJECT_ID}/instances"
curl -H "Authorization: Bearer $TOKEN" "https://apigee.googleapis.com/v1/organizations/${PROJECT_ID}/environments/test"

gcloud config set account $ROOT_EMAIL
gcloud auth list



################ Day 1 ###############################




mkdir $APIGEE_HELM_CHARTS_HOME/apigee-virtualhost/certs/
openssl req  -nodes -new -x509 -keyout $APIGEE_HELM_CHARTS_HOME/apigee-virtualhost/certs/keystore-$ENV_GROUP.key -out \
    $APIGEE_HELM_CHARTS_HOME/apigee-virtualhost/certs/keystore-$ENV_GROUP.pem -subj '/CN='$DOMAIN'' -days 3650


openssl x509 -in $APIGEE_HELM_CHARTS_HOME/apigee-virtualhost/certs/keystore-$ENV_GROUP.pem -text -noout | grep "CN"
openssl x509 -in $APIGEE_HELM_CHARTS_HOME/apigee-virtualhost/certs/keystore-$ENV_GROUP.pem -text -noout | grep "Not"


ls $APIGEE_HELM_CHARTS_HOME/apigee-virtualhost/certs



cat <<EOF > $APIGEE_HELM_CHARTS_HOME/overrides.yaml
instanceID: "${PROJECT_ID}-hybrid-runtime"
namespace: "apigee"

gcp:
  projectID: $PROJECT_ID
  region: $GCP_REGION

k8sCluster:
  name: hybrid-cluster
  region: $GCP_REGION

org: $ORG_NAME

enhanceProxyLimits: true

#contractProvider: https://us-apigee.googleapis.com

envs:
- name: $ENV_NAME
  serviceAccountSecretRefs:
    synchronizer: "apigee-synchronizer-svc-account"
    runtime: "apigee-runtime-svc-account"
    udca: "apigee-udca-svc-account"

cassandra:
  hostNetwork: false
  replicaCount: 1
  storage:
    storageSize: 100Gi
  resources:
    requests:
      cpu: 4
      memory: 6Gi
  maxHeapSize: 4096M
  heapNewSize: 1200M

ingressGateways:
- name: my-ingress-1
  replicaCountMin: 2
  replicaCountMax: 10

virtualhosts:
- name: ${ENV_GROUP}
  selector:
    app: apigee-ingressgateway
    ingress_name: my-ingress-1
  sslCertPath: certs/keystore-${ENV_GROUP}.pem
  sslKeyPath: certs/keystore-${ENV_GROUP}.pem

mart:
  serviceAccountRef: "apigee-mart-svc-account"

connectAgent:
  serviceAccountRef: "apigee-mart-svc-account"

logger:
  enabled: true
  serviceAccountRef: "apigee-logger-svc-account"

metrics:
  serviceAccountRef: "apigee-metrics-svc-account"

udca:
  serviceAccountRef: "apigee-udca-svc-account"

watcher:
  serviceAccountRef: "apigee-watcher-svc-account"

# Monetization for Apigee hybrid
runtime:
  image:
    url: "gcr.io/apigee-release/hybrid/apigee-runtime"
    tag: "1.15.1"

mintTaskScheduler:
  serviceAccountRef: apigee-mint-task-scheduler-svc-account

# For message payloads larger than 10MB:
runtime:
  cwcAppend:
    bin_setenv_max_mem: 2048m   # Increase max heap size to 4 gigs
  resources:
    requests:
      memory: 2Gi
    limits:
      memory: 3Gi
EOF



oc apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.4/cert-manager.yaml
oc get all -n cert-manager -o wide


oc apply -k  apigee-operator/etc/crds/default/ \
  --server-side \
  --force-conflicts \
  --validate=false

oc get crds | grep apigee


in helm chart:
nodeSelector:
  requiredForScheduling: false
  apigeeRuntime:
    key: "cloud.google.com/gke-nodepool"
    value: "apigee-runtime"
  apigeeData:
    key: "cloud.google.com/gke-nodepool"
    value: "apigee-data"



helm upgrade operator apigee-operator/ \
  --install \
  --namespace $APIGEE_NAMESPACE \
  --atomic \
  -f overrides.yaml

helm ls -n $APIGEE_NAMESPACE

oc -n $APIGEE_NAMESPACE get deploy apigee-controller-manager



helm upgrade datastore apigee-datastore/ \
  --install \
  --namespace $APIGEE_NAMESPACE \
  --atomic \
  -f overrides.yaml 

oc -n apigee get apigeedatastore default


helm upgrade telemetry apigee-telemetry/ \
  --install \
  --namespace apigee \
  --atomic \
  -f overrides.yaml

oc -n apigee get apigeetelemetry apigee-telemetry


helm upgrade redis apigee-redis/ \
  --install \
  --namespace apigee \
  --atomic \
  -f overrides.yaml \
  

oc -n apigee get apigeeredis default



helm upgrade ingress-manager apigee-ingress-manager/ \
  --install \
  --namespace apigee \
  --atomic \
  -f overrides.yaml


oc -n apigee get deployment apigee-ingressgateway-manager




helm upgrade $ORG_NAME apigee-org/ \
  --install \
  --namespace apigee \
  --atomic \
  -f overrides.yaml


oc -n apigee get apigeeorg


helm upgrade test-env apigee-env/ \
  --install \
  --namespace apigee \
  --atomic \
  --set env=$ENV_NAME \
  -f overrides.yaml

kubectl -n apigee get apigeeenv


export  ENV_GROUP=test-group
export ENV_RELEASE_NAME=$ENV_GROUP
export ENV_GROUP_RELEASE_NAME=$ENV_GROUP

helm upgrade $ENV_GROUP apigee-virtualhost/ \
  --install \
  --namespace apigee \
  --atomic \
  --set envgroup=$ENV_GROUP \
  -f overrides.yaml

oc -n apigee get ar
oc -n apigee get arc


create proxy from GCP UI:

Proxy name: Enter myproxy
Base path: /myproxy
Target (Existing API): Enter "https://mocktarget.apigee.net"

Update the ingressGateways[].svcType property to ClusterIP in your overrides file:
ingressGateways:
  svcType: ClusterIP

helm upgrade ORG_NAME apigee-org/ \
  --install \
  --namespace apigee \
  --atomic \
  -f overrides.yaml

  
  
kubectl get svc -n apigee -l app=apigee-ingressgateway
apigee-ingressgateway-internal-chaining-myprojectlw5555-8cb0159   ClusterIP   10.217.5.163   <none>        15021/TCP,443/TCP   123m

login to CRC VM:
ssh -i ~/.crc/machines/crc/id_ed25519 core@127.0.0.1 -p 2222


curl -H 'User-Agent: GoogleHC'  https://myprojectlw55555-test.hybrid-apigee.net:443/healthz/ingress --resolve myprojectlw55555-test.hybrid-apigee.net:443:10.217.5.163 -k
Apigee Ingress is healthy

curl https://myprojectlw55555-test.hybrid-apigee.net:443/myproxy --resolve myprojectlw55555-test.hybrid-apigee.net:443:10.217.5.163 -k
Hello, Guest!













