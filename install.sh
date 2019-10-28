source config.ini

if ! grep -i "DIGITALOCEAN_ACCESS_TOKEN" ~/.profile; then
    echo -e "\nexport DIGITALOCEAN_ACCESS_TOKEN=\"${DO_TOKEN}\"" >> ~/.profile
fi    

if ! grep -i "app.terraform.io" ~/.terraformrc; then
    echo  -e "\ncredentials \"app.terraform.io\" {\n  token = \"${TF_TOKEN}\"\n}" >> ~/.terraformrc
fi

source ~/.profile

doctl auth init

if [ ! -f main.tf ]; then
    git clone https://github.com/sagebinary/do-k8s-tf.git
    mv do-k8s-tf/main.tf .
fi

if [ ! -f backend.tf ]; then
    git clone https://github.com/sagebinary/backends-tf.git
    mv backends-tf/tf_cloud/backend.tf .
    sed -i 's/organization = ".*"/organization = "'"${tf_cloud_org}"'"/' backend.tf
    sed -i 's/\<name\> = ".*"/name = "'${tf_cloud_workspace}'"/' backend.tf
    rm -rf backends-tf/
fi

if [ ! -f terraform.auto.tfvars ]; then
    envsubst < config.ini > terraform.auto.tfvars
    sed -i '/tf_cloud_org=".*"/d' terraform.auto.tfvars
    sed -i '/tf_cloud_workspace=".*"/d' terraform.auto.tfvars
    rm -rf do-k8s-tf/
fi

terraform init &> /dev/null

terraform apply -auto-approve

echo "==> K8s installation on Digital Ocean complete!"
