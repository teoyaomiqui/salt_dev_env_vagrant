vagrant up --provider libvirt
sleep 10
minions=$(vagrant status | awk '/running/ {print $1}')
key_name="id_rsa"
salt_conf_dir="deployment/salt/etc"
key_file_path="/etc/salt/${key_name}"
SALT_MASTER_IP=$(grep base_ip_net deployment_model.yaml | tr -d "[:space:],\",\',base_ip_net:").1

__distribute_key() {

cmd="ssh -oStrictHostKeyChecking=no -i ${1} ${2}@${3} echo ${4} >> ~/.ssh/authorized_keys"
$cmd

}

generate_key_pair(){
  local result=$1
  local local_key_path="${salt_conf_dir}/${key_name}"
  local local_public_key_path="${salt_conf_dir}/${key_name}.pub"
  echo "generating key-pair"
  if [ ! -f /tmp/foo.txt ]; then
    ssh-keygen -t rsa -N "" -f ${local_key_path}
  else
    echo "key at ${local_key_path} already exists, skipping"
  fi
  local pub_key=$(cat $local_public_key_path)
  eval $result="'$pub_key'"

}

parse_and_deploy_keys() {
  local prefix='  '
  local map_file_path="$salt_conf_dir/minion_map"
  generate_key_pair public_key
  echo "saltification:" > $map_file_path
  echo "starting to distribute ssh_keys, minions are: \\n $minions"
  for minion in $minions; do
    echo "distributing key to minion: $minion"
    ssh_conf=$(vagrant ssh-config "${minion}")
    local user=$(awk '/User / {print $2}' <<<"$ssh_conf")
    local hname=$(awk '/HostName / {print $2}' <<<"$ssh_conf")
    local key_file=$(awk '/IdentityFile / {print $2}' <<<"$ssh_conf")
    __distribute_key "$key_file" "$user" "$hname" "$public_key"
    echo "$public_key"
    echo "$prefix$minion:" >> $map_file_path
    echo "${prefix}${prefix}ssh_username: $user" >> $map_file_path
    echo "${prefix}${prefix}ssh_host: $hname" >> $map_file_path
    echo "${prefix}${prefix}key_filename: $key_file_path">> $map_file_path
  done
  echo "setting minion connfiguration for salification"
  sed -i "s/<master_ip_address>/${SALT_MASTER_IP}/" deployment/salt/etc/cloud.providers

}

configure_master(){

  echo "setting minion connfiguration for salification"
  sed -i "s/<master_ip_address>/${SALT_MASTER_IP}/" deployment/salt/etc/cloud.provider
  sed -i "s/<key_name>/${key_name}/" deployment/salt/etc/minion_map
}

build_and_run_master(){
  local master_image_name=salt-master-${SALT_MASTER_IP}
  local master_container_name=salt-master-${SALT_MASTER_IP}

  if [[ "$(sudo docker images | grep -v $master_image_name)" ]]; then
    sudo docker build --tag ${master_image_name} .
  fi
  if [[ "$(sudo docker ps | grep -v ${master_container_name})" ]]; then
    sudo docker run -it -d --network=host --name=${master_container_name} ${master_image_name}
  fi

}

parse_and_deploy_keys
configure_master
build_and_run_master
