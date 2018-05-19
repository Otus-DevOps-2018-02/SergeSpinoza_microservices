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


# Homework-15

## Основное задание
- Созданы 3 docker образа: post:1.0, comment:1.0 и ui:1.0;
- Ответ на вопрос на 13 слайде: сборка по команде `docker build -t s1spinoza/ui:1.0 ./ui` начинается с 6 шага, потому что был использован кеш. Использовался один и тот же базовый образ и первые 4 команды как и в образе `comment:1.0`, который мы собирали перед этим;
- Проверена связка работы всех контейнеров, запущенных из созданных образов; 
- Создан docker volume и подключен к mongodb, чтобы данные не пропадали при остановке контейнера;
- Сделана проверка Dockerfile с помощью hadolint, внесены исправления. Оригинальные файлы сохранены в Dockerfile.orig


## Дополнительное задание со *
- Запуск контейнеров с другими сетевыми алиасами и передача новых названий через ENV-переменные: 
  - `docker run -d --network=reddit --network-alias=post_db_2 --network-alias=comment_db_2 mongo:latest`
  - `docker run -d --network=reddit --network-alias=post_2 --env POST_DATABASE_HOST=post_db_2 <your-dockerhub-login>/post:1.0`
  - `docker run -d --network=reddit --network-alias=comment_2 --env COMMENT_DATABASE_HOST=comment_db_2 <your-dockerhub-login>/comment:1.0`
  - `docker run -d --network=reddit -p 9292:9292 --env POST_SERVICE_HOST=post_2 --env COMMENT_SERVICE_HOST=comment_2 <your-dockerhub-login>/ui:1.0`
- Сборка образа ui на базе образа alpine описана в файле **Dockerfile_alpine**. Для запуска сборки необходимо выполнить команду `docker build -f ./ui/Dockerfile_alpine -t <your-dockerhub-login>/ui:3.0 ./ui`. Размер образа уменьшился до 58MB;


## Дополнительное задание с **
- Не выполнено


# Homework-16

## Основное задание
- Выполнено сравнение вывода команд `docker exec -ti net_test ifconfig` и `docker-machine ssh docker-host ifconfig` (слайд 10). Вывод одинаковый - т.к. контейнер запущен в сетевом пространстве docker-хоста (опция `--network host`);
- Запущена несколько раз команда `docker run --network host -d nginx`. `docker ps` показывает, что запущен только 1 контейнер nginx, запуск остальных завершился ошибкой т.к. 80 порт уже занят первым запущенным контейнером (ошибка `nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)`);
- Выполнен запуск контейнеров с использованием драйверов none и host (задание на слайде 12). Список namespace-ов меняется следующим образом: при использовании драйвера none - создается новый namespace с идентификатором, при использовании драйвера host - используется существующий namespace хостовой машины с названием `default`;
- Запущен проект (4 контейнера) в 2-х bridge сетях (front_net и back_net), для того, чтобы сервис ui не имел доступа к базе данных;
- Ознакомился, как выглядит сетевой стек Linux после добавления bridge сетей;
- Ознакомился, как выглядят правила iptables после добавления сетей;
- Изменен docker-compose.yml под кейс с множеством сетей и сетевых алиасов (оригинальны файл сохранен с именем docker-compose.yml.orig). Параметризованы с помощью переменных окружений необходимые параметры, и записаны в файл .env (пример файла в .env.example);

## Дополнительное задание со *
- Базовое имя проекта образуется из названия директории, где расположен docker-compose файл;
- Базовое имя проекта можно задать при запуске, используя ключ `-p`, например `docker-compose -p reddit_app up -d`. Также, название проекта задать можно в файле .env параметром `COMPOSE_PROJECT_NAME`
- Создан файл docker-compose.override.yml который переопределяет необходимые параметры (запуск puma с флагами --debug и -w 2), и монтирует директории, позволяя менять код приложения не выполняя пересборку образа. 


# Homework-17

## Основное задание
- Создан инстанс для установки GitLab CI. Для запуска инстанса и установки docker-compose необходимо выполнить команды:
  - `docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
--google-machine-type n1-standard-1 \
--google-disk-size 100 \
--google-zone europe-west1-b \
gitlab-ci`;
  - `docker-machine ssh gitlab-ci`;
  - `apt install docker-compose`;
- Выполнена omnibus-установка GitLab CI. Для установки необходимо на инстансе gitlab-ci выполнить команды: 
  - `mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs`;
  - `cd /srv/gitlab/`;
  - `touch docker-compose.yml`;
  - содержимое файла docker-compose.yml взять отсюда: https://gist.github.com/Nklya/c2ca40a128758e2dc2244beb09caebe1
  - для запуска выполнить команду `docker-compose up -d` из директории /srv/gitlab
- Выполнена настройка GitLab CI: создана группа, проект, CI/CD Pipeline;
- В проекте создан файл .gitlab-ci.yml, описывающий Pipeline;
- Запущен и зарегистрирован Runner для GitLab CI;
- Протестирован проект.

## Дополнительное задание со *
- Автоматизировано развертывание и регистрация Gitlab CI Runner. Для автоматического развертывания необходимого количества Gitlab CI Runner необходимо выполнить скрипт run-register-runners.sh, предварительно настроив в нем параметры: 
  - `RUNNERS` - количество Gitlab CI Runner;
  - `URL` - GitLab URL;
  - `TOKEN` - GitLab registration token.
- Настроена интеграция с тестовым Slack-чатом (Slack-канал #serge_fedonin). 


# Homework-18

## Основное задание
- Расширили существующий пайплайн в Gitlab CI;
- Включили существующий runner для нового проекта;
- Ознакомились как можно динамечески менять пайплайн в зависимости от условий (в нашем случае динамическое изменение при наличии тега у коммита).

## Дополнительное задание со * и с **
- Предварительные действия: 
  - добавить опцию `--docker-privileged` при регистрации runner (полную команду можно посмотреть в моем файле run-register-runners.sh). Это необходимо для доступа к /var/run/docker.sock (для использования docker daemon);
  - в настройках проекта в "CI/CD" в "Secret variables" задать секретные переменные `DOCKER_HUB_LOGIN` и `DOCKER_HUB_PASS`;
  - записать название своего репозитория в переменную `DOCKER_HUB_REPO` в файле .gitlab-ci.yml;
  - т.к. Gitlab установлен на инстансе в GCP - то необходимо для этого инстанса в его настройках дать права на проект, чтобы с этого инстанса можно было также развовачивать и удалять дополнительные инстансы без авторизации и СМС =);
- Создан пайплайн, который при добавление ветки запускает билд докер-образа, заливает его на docker HUB, разворачивает через docker-machine хост с докером на GCP и поднимает докер-контейнер с приложением reddit. Также реализована возможность удаления созданного инстанса по кнопке. Для передачи данных, необходимых для управления созданным инстансом через docker-machine между джобами - использовал cache. 
