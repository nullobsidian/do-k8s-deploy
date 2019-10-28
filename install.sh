source config.ini

source ~/.profile

if [ ! -f main.tf ]; then
    git clone https://github.com/sagebinary/do-k8s-tf.git
    mv do-k8s-tf/main.tf .
fi

if [ ! -f backend.tf ]; then
    git clone https://github.com/sagebinary/tf-backends.git
    mv backends-tf/tf_cloud/backend.tf .
    sed -i 's/organization = ".*"/organization = "'"${tf_cloud_org}"'"/' backend.tf
    sed -i 's/\<name\> = ".*"/name = "'${tf_cloud_workspace}'"/' backend.tf
    rm -rf tf-backends/
fi

if [ ! -f terraform.auto.tfvars ]; then
    cat terraform.tfvars > config.ini
    echo -e "\ndo_token=${do_token}" >> config.ini
    envsubst < config.ini > terraform.auto.tfvars
    sed -i '/tf_cloud_org=".*"/d' terraform.auto.tfvars
    sed -i '/tf_cloud_workspace=".*"/d' terraform.auto.tfvars
    rm -rf do-k8s-tf/
fi

terraform init &> /dev/null

terraform apply -auto-approve

echo "==> K8s installation on Digital Ocean complete!"
