Ansible Playbook for MakeStack Server
=====================================

```sh
$ cp hosts.example hosts
$ cp database.yml.example database.yml
$ cp secrets.yml.example secrets.yml
$ ansible-playbook -e DB_PASSWORD=123456 -i hosts playbook.yml
```
