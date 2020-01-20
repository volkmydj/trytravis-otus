[![Build Status](https://travis-ci.com/volkmydj/trytravis-otus.svg?branch=ansible-3)](https://travis-ci.com/volkmydj/trytravis-otus)

# volkmydj_infra

bastion_IP = 35.225.27.208
someinternalhost_IP = 10.132.0.7

---

# Create GCP instance with startup script

gcloud compute instances create reddit-app\  
  --boot-disk-size=10GB \  
  --image-family ubuntu-1604-lts \  
  --image-project=ubuntu-os-cloud \  
  --machine-type=g1-small \  
  --tags puma-server \  
  --restart-on-failure \  
  --metadata startup-script-url=gs://avolkov-otus/startup_script.sh  

---

# Create GCP firewall rules

gcloud compute firewall-rules create default-puma-server\  
  --allow tcp:9292 \  
  --target-tags=puma-server  

---

# Test connections to reddit app

testapp_IP = 35.205.164.130
testapp_port = 9292

---

# Packer-Base
1. Создан шаблон базового шаблона  reddit-base
2. Создан файл с переменными variables.json. По заданию в репозитории индексируется фэйковый файл с переменными (variables.json.example).
3. Создан полный шаблон с необходимыми пакетами и зависимостями. По этому шаблона развернут целевой хост в GCP.
4. Создан скрипт для полного деплоя в одну команду.
5. Хост в онлайне и доступен на порту 9292.

---


# Terraform-1
1. Создан файл переменных terraform.tfvars (т.к. файл по правилам попадает в .gitignore, то вместо него используется terraform.tfvars.example).
2. Создан файл выходных данных, в котором выводится IP балансировщика GCP.
3. В main.tf описан код создания инстанса через определение count.
4. В файле lb.tf описана инфраструктура создания балансировщика GCP через подключаемый модуль.

#### Внимание!
***Любые изменения, внесенные в ручную (не через код) будут изменены обратно или удалены после применения команды terraform apply***

### Как использовать:
1. `cd terraform && terraform apply -var-file="terraform.tfvars.example"`
2. После построения будет выведен адрес подключения.Скопировать его и перейти по адрессу в браузере.

# Terraform-2
1. Созданы модули terraform: app, db, vpc.
2. Созданы 2 проекта для окружения stage и prod.В данных окружениях созданы конфигурации, в которых одно из окружений доступно из всей сети интернет, а другое только с конкретного IP.
3. В окружениях prod и stage добавлены файлы конфигураций, описывающие, где хранить файлы состояний terraform (terraform.tfstate).
4. Для каждого окружения создан отдельный bucket, где хранятся файлы состояний terraform. Сам файл, описывающий конфигурацию создания баккета находится непосредственно в папке terraform.
5. Добавлены provisioner  для модулей app и db. Реализовано управление provisioner через переключатель. По-умолчанию provisioner выключен в самом модуле app.
6. Т.к. изначально Puma Server и MongoDB устанавливались на один хост, а в текущем ДЗ наши сервисы находятся на разных хостах, необходимо внести некоторые изменения в конфигурационные файлы данных сервисов.
   1. Для puma.servce необходимо добавить запуск с использованием Environment, в котором необходимо указать адрес полученный инстансом БД (DATABASE_URL=).
   2. Для MongoDB в конфигурационном файле необходимо указать прослушивание со всех адрессов. Для этого специальным provisioner необходимо добавить изменение в конфигурацию БД. После этого перезапустить сервис БД.
7. Созданы отдельные имиджи для приложения reddit-app и reddit-db.

### Как использовать
1. Создание storage-bucket:
`cd terraform && terraform apply -var-file="terraform.tfvars.example"`
2. Запуск для окружения stage:
`cd terraform/stage && terraform apply -var-file="terraform.tfvars.example"`
3. Запуск для окружения production:
`cd terraform/prod && terraform apply -var-file="terraform.tfvars.example"`
4. После построения будут выведены внешние IP адреса подключения для приложения и для БД.Также, для информации будет выведен внутренний адресс БД.
5. Скопировать внешний IP приложения и перейти по адрессу в браузере:
`http://<external-ip>:9292`


# Ansible-1
Повторное выполнение команды `ansible app -m command -a 'rm -rf ~/reddit'` приводит к такому же результату, как и ее первичное выполнение. Результат будет тот же: `appserver | CHANGED | rc=0 >>`, что является неправильной информацией. Команда в модуле `command` выполняется без прохождения через оболочку /bin/sh. Поэтому переменные определенные в оболочке и перенаправления-конвееры работать не будут.

1. Созданы 3 вида файла инвентори: статический (ini),статический (YAML), статический (JSON). Ansible может работать с любым из них. Для этого необходимо в файле ansible.cfg прописать путь до одного из них. Если в процессе запуска playbook или adhoc команды необходимо использовать другой инвентори, то необходимо запускать команду с указанием конкретного инвентори. Например: `ansible all -m ping -i inventory.yml`

2. Создан простой playbook, в котором мы клонируем репозиторий с использованием модуля "git".

3. Для использования динамического инвентори в terraform /stage/main.tf добавлен дополнительный функционал. С помощью ресурса "template_file" генерируется файл dynamic_inventory.json, в который мы передаем переменные внешних ip созданных инстансов. В выходных параметрах объвляется данный ресурс.
Для получения динамических данных инвентори необходимо запускать команды ansible с указанием этого скрипта в качестве источника инвентори.

### Как использовать

1. `cd terraform/stage && terraform apply -var-file="terraform.tfvars.example`
2. `cd ansible && ansible all -m ping`(для статического инвентори).
3. `cd ansible && ansible all -m ping -i dynamic_inventory.sh`(для динамического инвентори).

# Ansible-2
В предыдущем ДЗ я уже описывал один из вариантов использования динамического инвентори.(пункт 3). Есть еще один способ. Это использование готового модуля gcp_compute. Для этого необходимо создать сервисный аккаунт в GCP. Скачать файл .json для этого аккаунта. В модуле указать его расположение. Более полное описание модуля есть в официальной документации ansible. При использовании данного модуля необходимо использовать следующий вид запуска:
`ansible-playbook -i inventory.gcp.yml site.yml`
Эти два варианта по своему хороши, но я оставлю вариант из предыдущего ДЗ.

1. Созданы отдельные таски для деплоя app и db приложений.
2. Пакером созданы образы, в которых привиженинг скриптами заменен на провиженинг ansible.
3. Создан плейбук, в который импортируются tasks app & db & deploy.
4. Протестирован еще один из вариантов использования динамического инвентори.

### Как использовать
1. `cd terraform/stage && terraform apply -var-file="terraform.tfvars.example`
2. Записать значение внутреннего IP БД в переменную `db_host`
2. `cd ansible`
3. `ansible-playbook -i dynamic_inventory.sh site.yml --check`
4. `ansible-playbook -i dynamic_inventory.sh site.yml`
5. `http://<external-ip>:9292`
