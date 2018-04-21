# SergeSpinoza_microservices
SergeSpinoza microservices repository


# Homework-13

## Основное задание
- Установлены docker, docker-compose и docker-machine;
- Изучены основные команды для работы с docker;
- Создан образ из запущенного контейнера, на котором были внесены изменения;
- Записан вывод команды `docker images` в файл docker-monolith/docker-1.log


## Дополнительное задание со *
- В файл docker-monolith/docker-1.log добавлено описание различия между образом и контейнером.


# Homework-14

## Основное задание
- Создан новый проект в GCP с названием docker; 
- Создан instance с Docker machine;
- Различие вывода между `docker run --rm -ti tehbilly/htop` и `docker run --rm --pid host -ti tehbilly/htop` в том, что: 
  - первая команда запускает контейнер в обычном режиме, будут видны только процессы, которые запущенны в самом контейнере;
  - вторая команда запускает контейнер с выключенной изоляцией pid namespaces, будут видны все процессы на системе. 
- Создан образ Docker из Dockerfile и выложен на hub.docker.com.


## Дополнительное задание со *
- Создан конфигурационный файл Terraform для автоматического поднятия инстансов. Файл находиться в директории **docker-monolith/infra/terraform**. Количество инстансов задается в файле terraform.tfvars в переменной `count`;
- Созданы плейбуки Ansible с использованием динамического инвентори для установки Docker и запуска ранее созданного контейнера;
- Создан шаблон для packer, с помощью которого можно собрать образ с уже установленным Docker.


## Запуск 
- Из директории **docker-monolith** поочередно выполнить команды:
  - `docker build -t <your-login>/otus-reddit:1.0 .` 
  - `docker push <your-login>/otus-reddit:1.0`
- Для запуска развертывания инстансов, находясь в директории **docker-monolith/infra/terraform**, выполнить поочередно команды:
  - `terraform plan`
  - `terraform apply`
- Для развертывания Docker и запуска необходимого контейнера с помощью ansible необходимо, находясь в директории **docker-monolith/infra/ansible** выполнить команду `ansible-galaxy install -r environments/prod/requirements.yml` для установки необходимых ролей и команду ansible `ansible-playbook playbooks/start.yml` - для установки docker и запуска контейнера; 
- Для создания образа, с уже установленным docker, с помощью пакера необходимо, находясь в директории **docker-monolith/infra** выполнить команду `packer build -var-file=packer/variables.json packer/docker.json`
