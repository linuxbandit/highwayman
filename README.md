# A vagrant vm to develop stuff on

provider: VMware
box: bento/ubuntu-22.04

Specific versions of the box can be found on the `start.sh` script

## Dev stuff
Specific versions of the dev stuff (node/python) can be found on the Ansible values file `scripts-vagrant_provision/local.yml`

## Notes
Remember to set dnsmasq.

## TODOS
- [ x ] write the todos
- [ x ] add the traefik reverse proxy
- [ x ] add the ssl from mkcert to traefik folder in start.sh
- [ ] add the personal dotfiles instead of the bashrc
- [ ] add a modular way to plug components and have them bootstrapped (mostly like dharma) 

### Fixes
- [ ] vmware having issues 
```
blc.dev: dos2unix: Failed to change the owner and group of temporary output file /vagrant/scripts-vagrant_provision/d2utmpiTv8Su: Operation not permitted
blc.dev: dos2unix: problems converting file /vagrant/scripts-vagrant_provision/bashrc
    ```
