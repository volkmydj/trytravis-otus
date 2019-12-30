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
1. Создан файл переменных variable.tf (т.к. файл по правилам попадает в .gitignore, то вместо него используется variables.tf.example).
2. Создан файл выходных данных, в котором выводится IP балансировщика GCP.
3. В main.tf описан код создания инстанса через определение count.
4. В файле lb.tf описана инфраструктура создания балансировщика GCP через подключаемый модуль.

#### Внимание!
***Любые изменения, внесенные в ручную (не через код) будут изменены обратно или удалены после применения команды terraform apply***

### Как использовать:
1. `cd terraform && terraform apply -var-file="terraform.tfvars.example"`
2. После построения будет выведен адрес подключения.Скопировать его и перейти по адрессу в браузере.
