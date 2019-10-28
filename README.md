# do-k8s-build
Deploy and Manage Kubernetes on DigitalOcean

### Docker setup

```shell

docker pull sagebinary/iac-do
docker run -itd --name prod-k8s-do --hostname prod-k8s-do sagebinary/iac-do
docker exec -it prod-k8s-do /bin/sh
```

#### Step 1 - Setup Credentials

```shell

# Digital Ocean Personal API Token
export DO_TOKEN=""
# Terraform Cloud API Token
export TF_TOKEN=""

# Write to the environment
echo -e "\nexport do_token=\"${DO_TOKEN}\"" >> ~/.profile
echo  -e "\ncredentials \"app.terraform.io\" {\n  token = \"${TF_TOKEN}\"\n}" >> ~/.terraformrc
```

#### Step 2 - Edit your desired configuration in `config.ini`

```ini
cluster_name="dev-33pr66s7-k8s-example-com"
environment="dev-33pr66s7"
dns_zone="k8s.example.com"
k8s_version="1.15.5-do.0"
k8s_region="sfo2"

node_pool_name="main-node-pool"
node_size="s-2vcpu-4gb"
node_count=3

tf_cloud_org="example-com"
tf_cloud_workspace="dev-33pr66s7"
do_token="${do_token}"
```

#### Step 3 - Install K8s cluster

```shell
chmod +x ./install.sh
./install.sh
```
