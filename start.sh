#!/bin/bash
#THIS IS RUN ON THE HOST MACHINE manually by the user
# It will also start vagrant (or not)

#check how to bootstrap
reset=false
while [ "$#" -gt 0 ]; do
    case "$1" in
        --reset) reset=true; shift ;;

        -*) echo "Usage: start.sh [--reset] "; exit 1;;
        *) echo "Usage: start.sh [--reset] "; exit 1;;
    esac
done

check_etc_hosts () {
  # shellcheck disable=SC2143
  if grep -q 'traefik' /etc/hosts ; then #TODO improve by checking also the base_url
    echo '[Start script] ##### host file already good!'
  else
    echo '[Start script] ##### modifying the hosts file'
    # shellcheck disable=SC2016
    sudo bash -c 'echo "$1" "$2" "portainer.$2" "my.$2" "traefik.$2" "pgadmin.$2" "apidocs.$2" >> /etc/hosts' -- "${1}" "${2}"
  fi
}

check_mkcert() {

  if type mkcert >/dev/null 2>&1; then
    DIRECTORY=./gateways/docker/certs
    if [[ ! -f "${DIRECTORY}/${BASE_URL}.crt" ]]; then
      echo '[Start script] ##### cert files are to be generated'
      mkcert -install
      mkcert "*.${BASE_URL}"
      if [ ! -d "${DIRECTORY}" ]; then mkdir -p "${DIRECTORY}"; fi
      mv "./_wildcard.${BASE_URL}-key.pem" "${DIRECTORY}/${BASE_URL}.key"
      mv "./_wildcard.${BASE_URL}.pem"     "${DIRECTORY}/${BASE_URL}.crt"
      # to keep the traefik config static, we use symlinks. This way we also retain the knowledge of the domain name in the file name
      ln -s "${BASE_URL}.key" "${DIRECTORY}/mycert.key"
      ln -s "${BASE_URL}.crt" "${DIRECTORY}/mycert.crt"
      echo '[Start script] ##### created cert files'
    else
      echo '[Start script] ##### cert files already good!'
    fi
  else
    echo "You don't have mkcert, check how to install it on github.com/filosottile/mkcert"
  fi

}

check_dnsmasq() {

  local conf_file="$(brew --prefix)/etc/dnsmasq.conf"
  local domain=".${BASE_URL##*.}"
  echo 
  grep "${domain}" "${conf_file}"
  if [ -n "$?" ]; then
    echo "[Start script] ##### DNSmasq already good!"
  else
    echo "[Start script] ##### DNSmasq not set! Do not forget to set it"
    echo "[Start script] ##### DNSmasq not set! Do not forget to set it"
    echo "[Start script] ##### DNSmasq not set! Do not forget to set it"
    echo "[Start script] ##### DNSmasq not set! Do not forget to set it"
    echo "[Start script] ##### DNSmasq not set! Do not forget to set it"
    echo "[Start script] ##### DNSmasq not set, checking file /etc/hosts"
    check_etc_hosts "192.168.42.168" "${BASE_URL}"
  fi

}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if ( $reset ); then
  vagrant destroy
fi

if [ ! -f "${DIR}"/.env ]; then #check if it exists, if not take the example
    cp "${DIR}"/.env.example "${DIR}"/.env
fi

#shellcheck disable=SC2046
export $(grep -v '^#' "${DIR}/.env" | xargs -d '\n')

check_mkcert
if [[ "$(uname)" == "Darwin" ]]; then
  check_dnsmasq
else
  echo "no need for DNSmasq or resolv.conf editing on remote server"
fi

TARGET_BOX_VERSION="202401.31.0"
TARGET_BOX_DISTRO="bento/ubuntu-22.04"

# Pick between "virtualbox" and "vmware_desktop"
PROVIDER_NAME=vmware_desktop

vagrant box list | grep "${TARGET_BOX_VERSION}" -q || vagrant box add "${TARGET_BOX_DISTRO}" --provider "${PROVIDER_NAME}" --box-version "${TARGET_BOX_VERSION}" -c

if [[ "${PROVIDER_NAME}" == "vmware_desktop" ]]; then
  vagrant plugin list | grep vmware -q || vagrant plugin install vagrant-vmware-desktop
else
  vagrant plugin list | grep vbguest -q || vagrant plugin install vagrant-vbguest
fi

ansible-galaxy role install -r scripts-vagrant_provision/requirements-ansible.yml

export ANSIBLE_NOCOWS=true
vagrant up --provider "${PROVIDER_NAME}"
