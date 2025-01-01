#!/bin/bash
#-----------------------------------------------------------------------------------
# Developed by Alexander Guzeew (@guzeew_alex) in December 2024
# All Rights reserved by the LICENSE. Copyright © 2024 Guzeew Alexander
#-----------------------------------------------------------------------------------

# color section
end_color="\e[0m" #  Сброс цвета
yellow_b_in_red_back="\e[33;1m\e[41m" # Критические замечания и ошибки

# Проверяем, что скрипт запущен от имени пользователя root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${yellow_b_in_red_back}Этот скрипт должен быть запущен от имени пользователя root.${end_color}"
    echo -e "${yellow_b_in_red_back}Пожалуйста, выполните перед запуском скрипта команду: sudo su${end_color}"
    exit 1
fi

# Определяем тип дистрибутива
if command -v rpm &>/dev/null; then
    package_type="rpm"  # Для RPM дистрибутива
    echo -e "\n${green_b}Тип дистрибутива: RPM${end_color}"
elif command -v dpkg &>/dev/null; then
    package_type="deb"  # Для DEB дистрибутива
    echo -e "\n${green_b}Тип дистрибутива: DEB${end_color}"
else
    echo -e "\n${yellow_b_in_red_back}Данный дистрибутив не поддерживается скриптом.${end_color}"
    log_message "$end_log_message"
    exit 1
fi

# Создаём временную директорию в /tmp для загружаемого архива node_exporter
download_dir=$(mktemp -d)

# Устанавливаем wget, если его нет
if [ "$package_type" == "rpm" ]; then
  if ! command -v wget &>/dev/null; then
    if command -v dnf &>/dev/null; then
      dnf install -y wget
    else
      yum install -y wget
  fi
elif [ "$package_type" == "deb" ]; then
  if ! command -v wget &>/dev/null; then
    apt install -y wget
  fi
fi

echo -e "Введите полную ссылку до файла node_exporter, который вы хотите скачать: "
# Пример для ввода: https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
read -r package_url
if [ -z "$package_url" ]; then
  echo "Не указан URL для скачивания."
  exit 1
fi
wget -P $download_dir/ "$package_url" || { echo "Ошибка при скачивании файла. Проверьте доступность до ресурса."; exit 1; }

file_archive=$(basename $package_url)
archive_dir=$(tar -tf "$download_dir/$file_archive" | head -n 1 | cut -f1 -d"/")
tar -xzvf "$download_dir/$file_archive" -C "$download_dir/" || { echo "Ошибка при распаковке файла."; exit 1; }
if [ -f "$download_dir/$archive_dir/node_exporter" ]; then
  mv "$download_dir/$archive_dir/node_exporter" /usr/local/bin/node_exporter
else
  echo "Ошибка: файл node_exporter не найден."
  exit 1
fi

admin_node_exporter="node_exporter"
group_admin_ne="node_exporter"
getent passwd "$admin_node_exporter" &>/dev/null
if [ $? -eq 0 ]; then
    echo -e "Пользователь $admin_node_exporter уже существует"
else
    useradd -rs /bin/false "$admin_node_exporter"
fi
chown "$admin_node_exporter:$group_admin_ne" /usr/local/bin/node_exporter

contain_unitd=$(cat <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=$admin_node_exporter
Group=$group_admin_ne
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
)

unitd=/etc/systemd/system/node-exporter.service
if [ ! -f "$unitd" ]; then
    echo "$contain_unitd" > "$unitd"
else
    echo -e "Файл $unitd уже есть в системе"
fi

systemctl daemon-reload
systemctl enable --now node-exporter || { echo "Ошибка при включении и запуске сервиса."; exit 1; }
systemctl status node-exporter
node_exporter --version

rm -rf $download_dir
