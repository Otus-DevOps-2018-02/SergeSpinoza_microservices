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


# Homework-19

## Основное задание
- Создали инстанс для Prometheus и контейнеров приложения, с которых будем собирать метрики;
- Ознакомились с WEB-интерфейсом Prometheus;
- Созданы образы приложения при помощи скриптов docker_build.sh (ui, post-py, comment);
- Изменили docker-compose.yml для добавления сервиса Prometheus;
- Создан prometheus.yml с настройками Prometheus;
- Добавлен экспортер для Node;
- Ссылки на репозитарии с моими образами:
  - https://hub.docker.com/r/s1spinoza/ui/
  - https://hub.docker.com/r/s1spinoza/comment/
  - https://hub.docker.com/r/s1spinoza/post/
  - https://hub.docker.com/r/s1spinoza/prometheus/

## Запуск
- Создать инстанс в GCP при помощи docker-machine
- Создать необходимые образы приложения при помощи скрипта docker_build.sh, запустив команду из корня репозитория `for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done`
- Запустить команду из директории docker `docker-compose up -d`

## Дополнительное задание со * 
- Добавлен экспортер для mongodb (использован этот - https://hub.docker.com/r/eses/mongodb_exporter/);
- Добавлен экспортер blackbox (использован этот - https://hub.docker.com/r/prom/blackbox-exporter/);
- Добавлен makefile для автоматического билда и пуша образов. Для запуска билда и пуша только одного образа или только билда/пуша - необходимо указать параметр `-e` и действие (см. пример ниже).

## Запуск для задания со * 
- Предварительно необходимо выполнить команду `export USER_NAME=username`, где вместо `username` указать свое имя на docker HUB;
- Для использования makefile из корня репозитория необходимо выполнить команду `make`. По умолчанию делается билд и пуш всех образов, указанных в makefile. Если необходимо запустить только определенный билд - то команду необходимо указать с параметром `-e`, а после параметра указать действие `build`, пример - `make -e IMAGE_PATH=./monitoring/prometheus build`.


# Homework-20

## Основное задание
- Разделен на два docker-compose.yml файл (на docker-compose.yml и docker-compose-monitoring.yml);
- Добавлен cAdvisor для наблюдением за состоянием контейнеров;
- Установлена Grafana и добавлено несколько дашбордов;
- В Grafana добавлены метрики мониторинга приложения и бизнес метрики;
- Установлен Alertmanager;
- Настроен алертинг в Slack канал.

## Дополнительное задание со * 
- В Makefile добавлены билды и пуши новых сервисов;
- Настроена отдача метрики Docker'ом в формате Prometheus. Добавлен сбор этих метрик в Prometheus;
- Добавлен и настроен алерт на 95 перцентиль времени ответа UI;
- Настроена интеграция Alertmanager с e-mail.

## Запуск проекта
- Ввести данные от необходимого e-mail в файле `monitoring/alertmanager/config.yml`;
- Из корневой директории проекта выполнить команды:
  - `export USER_NAME=username`, где вместо `username` указать свое имя на docker HUB;
  - выполнить команду `make`.
- Из директории `docker` последовательно выполнить команды: 
  - `docker-compose up -d`
  - `docker-compose -f docker-compose-monitoring.yml up -d`


# Homework-21

## Основное задание
- Настроен стек EFK, в т.ч создан образ Fluentd с нужной нам конфигурацией и добавлен его запуск в docker-compose-logging.yml;
- Настроена отправка логов в Fluentd;
- Настроены фильтры и парсинг логов для сервисов post (json) и UI (grok)
- Добавлен запуск Zipkin в docker-compose-logging.yml

## Дополнительное задание со * 
- Добавлен еще один grok парсер для полного разбора логов от сервиса UI;
- Проблема с приложением была определена с помощью трейсинга с помощью зипкина - она находилось в сервисе (спане) post, который выполнялся 3 секунды. Проблема в 167 строке `time.sleep(3)` файла post_app.py. 

## Как запустить
- Собрать образы, выполнив из корня репозитария команду `for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done`
- Из директории docker выполнить команду `docker-compose -f docker-compose-logging.yml -f docker-compose.yml up -d`


# Homework-22

## Основное задание
- Созданы необходимые манифесты в каталоге `kubernetes/reddit`;
- Пройден туториал Kubernetes The Hard way (https://github.com/kelseyhightower/kubernetes-the-hard-way).

## Дополнительное задание со * 
- Пройден тот же туториал Kubernetes The Hard way, но с использованием плейбуков на Ansible (оригинал взят отсюда https://github.com/jugatsu/kubernates-the-hard-way-using-only-ansible и внесены небольшие изменения, чтобы заработало).

## Как запустить задание со *
- Перейти в каталог `kubernetes/ansible`;
- Выполнить создание ключа, используя команду `ssh-keygen -f ./files/ssh/k8s_the_hard_way -P "" -C k8s`;
- Создать сервисный аккаунт в GCP и сохранить json файл в каталог `kubernetes/ansible/files`;
- Скопировать пример файла и внести необходимые данные (можно взять из json файла) `cp .env.gce.example .env.gce`;
- Сделать экспорт переменных окружения export $(cat .env.gce);
- Скопировать пример файла и внести необходимые данные (можно взять из json файла) `cp ./inventory/gce.ini.example ./inventory/gce.ini`;
- Удостовериться, что в этом проекте нет никаких других инстансов, иначе будет ошибка;
- Запустить плейбук Ansible `ansible-playbook playbook.yml` (при необходимости закоментировать первые 2 инклуда в playbook.yml);
- Проверить, что все успешно развернулось можно командами:
```
kubectl get cs
kubectl get no
```
- Выполнить очистку после успешной проверки командами:
```
ansible-playbook 14-cleanup.yml
kubectl config delete-context kubernetes-the-hard-way
kubectl config delete-cluster kubernetes-the-hard-way
```


# Homework-23

## Основное задание
- Развернуто локальное окружение minikube для работы с Kubernetes;
- Создали YAML-манифесты для работы приложения reddit в Kubernetes;
- Самостоятельно сконфигурировали deployment компонента post;
- Ознакомились с dashboard Kubernetes;
- Ознакомились с работой Namespaces;
- Развернуто и запущено наше приложение в Kubernetes в GCE;
- Назначена роль cluster-admin для service account dashboard-а с помощью clusterrolebinding (привязки).

## Дополнительное задание со * (#1)
- Развернут Kubernetes кластер с помощью Terraform.

## Дополнительное задание со * (#2)
- Не выполнено, т.к. не понял, что конкретно нужно сделать.

## Как запустить
- Для развертывания локального кружения minikube необходимо предварительно установить kubectl, VirtualBox, Minukube и выполнить команду `minikube start`;
- Для развертывания кластера Kubernetes в GCE необходимо зайти в дирректорию kubernetes/terraform/stage и выполнить последовательно команды: `terraform init`, `terraform plan` и `terraform apply`, после убедиться, что кластер развернут;
- Для развертывания приложения reddit в Kubernetes необходимо последовательно выполнить команды, находясь в директории `kubernetes/reddit`: `kubectl apply -f ./dev-namespace.yml`, `kubectl apply -f ./ -n dev`.

## Список команд (моя памятка)
`kubectl get nodes` - список нод
`kubectl config get-contexts` - список всех контекстов
`kubectl config current-context` - посмотреть текущий контекст
`kubectl apply -f <filename/dir_with_yaml>` - запустить компонент в Kubernetes;
`kubectl get deployment` - просмотр состояния Подов;
`kubectl get services` - просмотр состояния сервисов;
`kubectl get pods --selector component=ui` - вывести список подов, например для компонента UI;
`kubectl port-forward <pod-name> local_port:pod_port` - проброс локального порта в Под;
`kubectl get nodes -o wide` - просмотреть IP адреса нод;
`kubectl describe service ui -n dev | grep NodePort` - найти номер порта (в данном случае для модуля ui в namespace dev);
`kubectl proxy` - proxy для входа в dashboard Kubernetes;
`kubectl get ingress` - просмотреть адрес балансира ingress;
`kubectl get persistentvolume` - просмотреть PersistentVolume.


# Homework-24

## Основное задание
- Ознакомились с работой сервиса kube-dns;
- Ознакомились с работой сервиса kube-proxy;
- Настроен балансир сервиса UI с применением объекта типа LoadBalancer;
- Настроен балансир сервиса UI с применением объекта типа Ingress (использован плагин Ingress Controller);
- Настроен Ingress с применением TLS, созданы необходимые сертификаты для работы HTTPS;
- Ознакомились с работой NetworkPolicy, включена работа с сетевым плагином Calico;
- Внесены изменения в файл mongo-network-policy.yml, чтобы сервис post мог достучаться до базы данных;
- Ознакомились с работой PersistentVolume (создан ресурс хранилища);
- Ознакомились с возможностью создания запроса на хранилище - PersistentVolumeClaim;

## Дополнительное задание со *
- Описан создаваемый объект Secret в виде Kubernetes-манифеста (файл ui-ingress-secret.yml). Данные файлов tls.crt и tls.key необходимо вносить в переменные в файле ui-ingress-secret.yml в формате base64. Для конвертирования содержимого сертификатов в base64 необходимо выполнить команды `base64 tls.crt` и `base64 tls.key`.

## Как запустить
- Проверить, что в настройках GCE включен плагин Ingress Controller (Kubernetes Engine -> Clusters -> Выбрать свой кластер -> Add-ons -> HTTP load balancing -> Enabled)
- Включить network-policy для GCE, выполнив последовательно команды:
  - `gcloud beta container clusters update cluster-1 --zone=europe-west1-b --update-addons=NetworkPolicy=ENABLED`
  - `gcloud beta container clusters update cluster-1 --zone=europe-west1-b --enable-network-policy`
- Создать диск, выполнив команду `gcloud compute disks create --size=25GB --zone=europe-west1-b reddit-mongo-disk`;
- Для развертывания приложения reddit в Kubernetes необходимо последовательно выполнить команды, находясь в директории `kubernetes/reddit`: 
  - `kubectl apply -f ./dev-namespace.yml`;
  - `kubectl apply -f ./ -n dev`.


# Homework-25

## Основное задание
- Установлен и настроен Helm и Tiller;
- Созданы helm-Chart'ы для приложения reddit;
- Развернут Gitlab-CI;
- Настроен Pipeline для приложения;
- Задание со * - связаны пайплайны сборки образов и пайплайн деплоя на staging и production так, чтобы после релиза образа из ветки мастер - запускался деплой уже новой версии приложения на production (оставил ручной запуск со stage на production. Для автоматического - надо убрать в файле .gitlab-ci.yml приложения reddit-deploy строчку `when: manual` в секции `production`)(запуск описан ниже).

## Как запустить

### Первая часть задания
- Скопировать `kubernetes/terraform/stage/terraform.tfvars.example` и задать свои переменные;
- Из директории `kubernetes/terraform` выполнить последовательно команды:
  - `terraform init`;
  - `terraform apply`;
- Из директории `kubernetes/reddit` выполнить команду `kubectl apply -f tiller.yml`;
- Для запуска tiller-сервера выполнить команду `helm init --service-account tiller`;
- Удостовериться что под запущен, выполнив команду `kubectl get pods -n kube-system --selector app=helm`;
- Загрузить зависимости, выполнив команду `helm dep update ./reddit`, находясь в директории `kubernetes/Charts`;
- Установить приложение, выполнив команду `helm install reddit --name reddit-test`, находясь в директории `kubernetes/Charts/reddit`;
- При изменении Chart'ов - выполнить команду для обновления `helm upgrade reddit-test ./reddit` из директории `kubernetes/Charts`
- Для удаления - выполнить команду `helm del --purge <chart_name>`

### Для задания со *
- Создать триггер в проекте reddit-deploy (Setting -> CI/CD -> Pipeline triggers) и скопировать Token;
- Добавить переменную DEPLOY_TRIGGER в каждом из проектов ui, post, comment (Setting -> CI/CD -> Secret variables) с ранее скопированным значением;

### Gitlab-CI
- Добавить новый пул узлов bigpool;
- Включить Legacy authorization (Kubernetes clusters -> Настройки кластера cluster -> Установить Legacy authorization Enable);
- Из директории `kubernetes/Charts/gitlab-omnibus` выполнить команду `helm install --name gitlab . -f values.yaml`
- Добавить группу s1spinoza и проекты ui, post, comment, reddit-deploy;
- Добавить в Gitlab 2 переменные - CI_REGISTRY_USER и CI_REGISTRY_PASSWORD (логин и пароль на DockerHub);
- Сделать пуш соответствующих частей приложения (сервисов) в соответствующий проект, причем в проект reddit-deploy запушить в самом конце;


# Homework-26

## Основное задание
- Развернул и настроил Prometheus для сбора метрик в k8s;
- Разбил конфигурацию job’а `reddit-endpoints` (слайд 24) так, чтобы было 3 job’а для каждой из компонент приложений (post-endpoints, commentendpoints, ui-endpoints), а reddit-endpoints закоментировал;
- Развернул и настроил Grafana;
- получившиеся дашборды экспортировал в каталог `kubernetes/grafana_dashboards`;
- Настроили EFK для сбора логов в k8s.

## Как запустить
- В настройках:
  - Stackdriver Logging - Отключен
  - Stackdriver Monitoring - Отключен
  - Устаревшие права доступа - Включено
- Из Helm-чарта установим ingress-контроллер nginx, выполнив команду `helm install stable/nginx-ingress --name nginx`
- Найдите IP-адрес, выданный nginx’у, выполнив команду `kubectl get svc`
- Прописать в /etc/hosts: `Найденный_выше_IP reddit reddit-prometheus reddit-grafana reddit-non-prod production reddit-kibana staging prod`
- Запустить Prometheus в k8s из charsts/prometheus, выполнив команду `helm upgrade prom . -f custom_values.yml --install`
- Запустить приложение, выполнив команды из директории kubernetes/Charts:
  - `helm upgrade reddit-test ./reddit —install`
  - `helm upgrade production --namespace production ./reddit --install`
  - `helm upgrade staging --namespace staging ./reddit —install`
- Запустим Grafana (команда из 33 слайда не корректная):
  - ```helm upgrade --install grafana stable/grafana \
--set "service.type=NodePort" \
--set "ingress.enabled=true" \
--set "ingress.hosts={reddit-grafana}"```
- Узнаем пароль пользователя admin для Grafana, выполнив команду `kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`;
- Загрузить в Grafana готовые дашборды из директории `kubernetes/grafana_dashboards`;
- Добавить label самой мощной ноде в кластере, выполнив команду `kubectl label node gke-cluster-1-big-pool-b4209075-tvn3 elastichost=true` (вместо gke-cluster-1-big-pool-b4209075-tvn3 подставить название своей ноды);
- Запустить стек EFK, выполнив команду `kubectl apply -f ./efk` из директории kubernetes;
- Установить Kibana из helm чарта:
  - ```helm upgrade --install kibana stable/kibana \
--set "ingress.enabled=true" \
--set "ingress.hosts={reddit-kibana}" \
--set "env.ELASTICSEARCH_URL=http://elasticsearch-logging:9200" \
--version 0.1.1```
