#!/bin/bash
#  __           _       _      __                                                  
# / _\ ___ _ __(_)_ __ | |_   / _| ___  _ __                                       
# \ \ / __| '__| | '_ \| __| | |_ / _ \| '__|                                      
# _\ \ (__| |  | | |_) | |_  |  _| (_) | |                                         
# \__/\___|_|  |_| .__/ \__| |_|  \___/|_|                                         
#                |_|                                                               
#                  _       _   _                               _                   
#  _   _ _ __   __| | __ _| |_(_)_ __   __ _    __ _ _ __   __| |                  
# | | | | '_ \ / _` |/ _` | __| | '_ \ / _` |  / _` | '_ \ / _` |                  
# | |_| | |_) | (_| | (_| | |_| | | | | (_| | | (_| | | | | (_| |                  
#  \__,_| .__/ \__,_|\__,_|\__|_|_| |_|\__, |  \__,_|_| |_|\__,_|                  
#  _    |_|    _        _ _ _          |___/                                       
# (_)_ __  ___| |_ __ _| | (_)_ __   __ _                                          
# | | '_ \/ __| __/ _` | | | | '_ \ / _` |                                         
# | | | | \__ \ || (_| | | | | | | | (_| |                                         
# |_|_| |_|___/\__\__,_|_|_|_|_| |_|\__, |                                         
#    ___                            |___/     _   ___      _         ___           
#   / __\___  _ __ ___  _ __ ___  _   _ _ __ (_) / _ \__ _| |_ ___  / _ \_ __ ___  
#  / /  / _ \| '_ ` _ \| '_ ` _ \| | | | '_ \| |/ /_\/ _` | __/ _ \/ /_)/ '__/ _ \ 
# / /__| (_) | | | | | | | | | | | |_| | | | | / /_\\ (_| | ||  __/ ___/| | | (_) |
# \____/\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|_\____/\__,_|\__\___\/    |_|  \___/ 
#
#-----------------------------------------------------------------------------------
# Developed by Alexander Guzeew (@guzeew_alex) in December 2024
# All Rights reserved by the LICENSE. Copyright © 2024 Guzeew Alexander
#-----------------------------------------------------------------------------------

# color section
end_color="\e[0m" #  Сброс цвета
yellow_b_in_red_back="\e[33;1m\e[41m" # Критические замечания и ошибки
blue_b_in_red_back="\e[36;1m\e[41m" # Подсветка команд, утилит и пользователей в критических замечаниях и ошибках
blue_b="\e[36;1m" # Запрос действий от пользователя
dark_blue_b="\e[34;1m" # Варианты ответа в запросе действий от пользователя
green_b="\e[32;1m" # Инфо
white_b_in_green_back="\e[97;1m\e[42m" # Успешное завершение скрипта
white_b_in_orange_back="\e[97;1m\e[48;5;130m" # Актуальная версия CGP, полученная с ресурса https://doc.communigatepro.ru/packages/
yellow_b="\e[33;1m" # Предупреждения
purple="\e[35m" # Начало скрипта и отображение информации об установленном пакете CommuniGate Pro
yellow_b_in_purple_back="\e[33;1m\e[45m" # Сообщение для задания метки лога

echo -e "${purple}                            ____            _       _                                
                           / ___|  ___ _ __(_)_ __ | |_                              
                           \___ \ / __| '__| | '_ \| __|                             
                            ___) | (__| |  | | |_) | |_                              
                           |____/ \___|_|  |_| .__/ \__|                             
                                             |_|                                     
                 __              _           _        _ _ _                          
                / _| ___  _ __  (_)_ __  ___| |_ __ _| | (_)_ __   __ _              
               | |_ / _ \| '__| | | '_ \/ __| __/ _\` | | | | '_ \ / _\` |             
               |  _| (_) | |    | | | | \__ \ || (_| | | | | | | | (_| |             
               |_|  \___/|_|    |_|_| |_|___/\__\__,_|_|_|_|_| |_|\__, |             
                                                                  |___/              
                             _                   _       _   _                       
              __ _ _ __   __| |  _   _ _ __   __| | __ _| |_(_)_ __   __ _           
             / _\` | '_ \ / _\` | | | | | '_ \ / _\` |/ _\` | __| | '_ \ / _\` |          
            | (_| | | | | (_| | | |_| | |_) | (_| | (_| | |_| | | | | (_| |          
             \__,_|_| |_|\__,_|  \__,_| .__/ \__,_|\__,_|\__|_|_| |_|\__, |          
                                      |_|                            |___/           
   ____                                      _  ____       _         ____            
  / ___|___  _ __ ___  _ __ ___  _   _ _ __ (_)/ ___| __ _| |_ ___  |  _ \ _ __ ___  
 | |   / _ \| '_ \` _ \| '_ \` _ \| | | | '_ \| | |  _ / _\` | __/ _ \ | |_) | '__/ _ \ 
 | |__| (_) | | | | | | | | | | | |_| | | | | | |_| | (_| | ||  __/ |  __/| | | (_) |
  \____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|_|\____|\__,_|\__\___| |_|   |_|  \___/ 
                                                                                     
 
Данный скрипт является интерактивным и предназначен для установки с нуля 
или обновления до актуальной версии почтового сервера CommuniGate Pro${end_color}
"

# Проверяем, что скрипт запущен от имени пользователя root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${yellow_b_in_red_back}Этот скрипт должен быть запущен от имени пользователя root.${end_color}"
    echo -e "${yellow_b_in_red_back}Пожалуйста, выполните перед запуском скрипта команду: sudo su${end_color}"
    exit 1
fi

# Инициализируем основную директорию для работы скрипта
download_dir="/root/CGP-install"
# Проверяем, существует ли директория для работы скрипта
if [ ! -d "$download_dir" ]; then
    echo -e "\n${green_b}Директория $download_dir не существует. Скрипт будет использовать эту директорию для сохранения лога скрипта, файла установщика и по умолчанию для бэкапов.
Создаём директорию $download_dir...${end_color}"
    mkdir -p "$download_dir"  # Создаём директорию и все промежуточные
else
    echo -e "\n${green_b}Скрипт будет использовать директорию $download_dir для сохранения лога скрипта, файла установщика и по умолчанию для бэкапов.${end_color}"
fi
# Инициализируем директорию для логов скрипта
log_dir="$download_dir/logs"
if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi
# Получаем текущую дату и время для меток в именах лог-файлов
timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
# Инициализируем лог-файл скрипта
LOG_FILE="$log_dir/cgp_installer_$timestamp.log"
# Функция для добавления временной метки в лог
log_message() {
    echo -e "${yellow_b_in_purple_back}$(date +'%d/%m/%Y_%H:%M:%S') - $1${end_color}"
}
# Дублируем весь дальнейший вывод скрипта в лог
exec > >(tee "$LOG_FILE") 2>&1
end_log_message="Скрипт завершён. Лог выполнения скрипта сохранён по пути: $LOG_FILE"

ask_user() {
    local attempts=3
    local choice_question="$1"
    local exit_answer="$2"
    # Переменная для задания постоянной строки с вариантами ответа на вопрос
    local various_answer="${dark_blue_b}yes/no (y/n):${end_color}"

    while [ $attempts -gt 0 ]; do
        echo -ne "${blue_b}$choice_question $various_answer${end_color} "
        read user_answer
        user_answer=${user_answer,,} # Преобразуем всё в нижний регистр
        case "$user_answer" in
            yes|y|д|да) return 0 ;;  # Если ответ "yes" или "y", возвращаем 0 (да)
            no|n|н|нет) return 1 ;;   # Если ответ "no" или "n", возвращаем 1 (нет)
            *)
                ((attempts--))
                echo -e "${yellow_b_in_red_back}Вы ввели недопустимый ответ. Осталось попыток: $attempts.${end_color}"
                ;;
        esac
    done

    echo -e "${yellow_b_in_red_back}$exit_answer${end_color}"
    log_message "$end_log_message"
    exit 1
}
#----------КОНЕЦ ФУНКЦИИ запроса ответа----------#

choice_question_start="Продолжить выполнение скрипта?"
exit_answer_start="Выполнение скрипта остановлено"

ask_user "$choice_question_start" "$exit_answer_start"
response=$?
if [ $response -ne 0 ]; then
    echo -e "${yellow_b_in_red_back}Вы отказались от выполнения скрипта${end_color}"
    exit 0
fi
echo "" # Отступ для красивого оформления
log_message "Запуск скрипта"

# Определяем тип дистрибутива
if command -v rpm &>/dev/null; then
    package_type="rpm"  # Для RPM дистрибутива
    echo -e "\n${green_b}Тип дистрибутива: RPM${end_color}"
elif command -v dpkg &>/dev/null; then
    package_type="deb"  # Для DEB дистрибутива
    echo -e "\n${green_b}Тип дистрибутива: DEB${end_color}"
else
    echo -e "\n${yellow_b_in_red_back}Данный дистрибутив не поддерживает почтовый сервер CommuniGate Pro.${end_color}"
    log_message "$end_log_message"
    exit 1
fi

#----------НАЧАЛО ФУНКЦИИ запроса ответа----------#
# Функция для запроса ответа yes/no(y/n) со стороны пользователя с проверкой ввода

#----------НАЧАЛО ФУНКЦИИ проверки наличия Интернета----------#
# Проверка наличия интернета с помощью ping
check_internet() {
    echo -e "\nПроверка доступа к ресурсу doc.communigatepro.ru с репозиторием для CGP..."
    if ping -c 4 doc.communigatepro.ru &>/dev/null; then
        echo -e "${green_b}Ресурс c репозиторием для CGP доступен. Парсим https://doc.communigatepro.ru/packages/ в поисках актуальной версии CGP... ${end_color}\n"
        return 0
    else
        echo -e "${yellow_b}Нет доступа к ресурсу с репозиториями CGP, возможно, проблемы с интернет-соединением, либо у вас используется закрытый контур.${end_color}\n"
        return 1
    fi
}
#----------КОНЕЦ ФУНКЦИИ проверки наличия Интернета----------#

#----------НАЧАЛО ФУНКЦИИ получения ссылки----------#
# Функция для получения списка ссылок на последние версии пакетов (deb или rpm)
get_latest_package_url() {
    local cgp_url="https://doc.communigatepro.ru/packages/"

    # Проверка наличия команды curl и установка, если она отсутствует
    if ! command -v curl &>/dev/null; then
        # Установка curl в зависимости от типа дистрибутива
        if [ "$package_type" == "deb" ]; then
            apt update && apt install -y curl
        elif [ "$package_type" == "rpm" ]; then
            # Для RPM дистрибутивов (CentOS, RHEL, Fedora и другие) - приоритет для более нового пакетного менеджера DNF
            if command -v dnf &>/dev/null; then
                dnf install -y curl
                if [ ! $? -eq 0 ]; then
                    echo -e "${yellow_b}Для корректной работы скрипта в открытом контуре необходима утилита curl.${end_color}"
                    echo -e "${yellow_b_in_red_back}Скачивание или установка утилиты curl завершилось с ошибкой${end_color}"
                    log_message "$end_log_message"
                    exit 1
                fi
            elif command -v yum &>/dev/null; then
                yum install -y curl
                if [ ! $? -eq 0 ]; then
                    echo -e "${yellow_b}Для корректной работы скрипта в открытом контуре необходима утилита curl.${end_color}"
                    echo -e "${yellow_b_in_red_back}Скачивание или установка утилиты curl завершилось с ошибкой${end_color}"
                    log_message "$end_log_message"
                    exit 1
                fi
            else
                echo "Не удалось найти подходящий пакетный менеджер для установки curl."
                log_message "$end_log_message"
                exit 1
            fi
        fi
    fi

    # Загружаем страницу и ищем ссылки на файлы .deb или .rpm
    page_content=$(curl -s "$cgp_url")

    if [ "$package_type" == "deb" ]; then
        # Ищем ссылки на .deb файлы, исключая "rc" версии
        mapfile -t package_urls < <(echo "$page_content" | grep -oP 'href="([^"]+\.deb)"' | sed 's/href="//' | sed 's/"//' | grep -v "rc" | grep -i CGatePro-Linux)
    elif [ "$package_type" == "rpm" ]; then
        # Ищем ссылки на .rpm файлы, исключая "rc" версии
        mapfile -t package_urls < <(echo "$page_content" | grep -oP 'href="([^"]+\.rpm)"' | sed 's/href="//' | sed 's/"//' | grep -v "rc" | grep -i CGatePro-Linux)
    fi

    # Если нет ссылок, выводим ошибку и завершаем выполнение скрипта
    if [ -z "$package_urls" ]; then
        echo -e "${yellow_b_in_red_back}Не удалось найти ссылку на пакет. Скрипт завершен.${end_color}"
        log_message "$end_log_message"
        exit 1
    fi

    # Сортируем версии пакетов по номеру версии и релизу, выбираем последний
    latest_package=$(printf "%s\n" "${package_urls[@]}" | sort -t'-' -k3,3 -k4,4n | tail -n 1)
    echo "$latest_package"
}
#----------КОНЕЦ ФУНКЦИИ получения ссылки----------#

#----------НАЧАЛО ФУНКЦИИ бэкапа----------#
# Бэкапим /var/CommuniGate, если она существует и пользователь дал согласие на это
backup_func() {
    if [ "$package_type" == "deb" ]; then
        echo -e "${green_b}Пакет $deb_package_name-$deb_package_name_version не установлен в системе. Продолжаем установку...${end_color}\n"
    elif [ "$package_type" == "rpm" ]; then
        echo -e "${green_b}Пакет $rpm_package_name_version не установлен в системе. Продолжаем установку...${end_color}\n"
    fi
    
    backup_source="/var/CommuniGate"
    # Функция для создания бэкапа из директории $backup_source при помощи утилиты tar
    creating_backup() {
        # Определяем имя файла для бэкапа
        local backup_filename="CGP_backup_$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"
        local progress=0 # Инициализация переменной progress
        local current_backup_fd=0 # Инициализация счётчика для прогресса архивации
        # Подсчитываем общее количество файлов, включая те, что находятся в подкаталогах
        local total_backup_fd=$(find "$backup_source" | wc -l)

        if [ $total_backup_fd -eq 0 ]; then
            echo -e "${yellow_b}В директории $backup_source нет файлов для архивации. Бэкап не будет выполнен.${end_color}"
            return 1
        fi

        # Запускаем архивацию с прогрессом
        tar -czf "$backup_dir/$backup_filename" -C /var CommuniGate --verbose | while read -r line; do
        # Каждая строка - это один файл или каталог, обрабатываемый в архив
            if [[ "$line" =~ .*/.* ]]; then
                # Увеличиваем счётчик обработанных позиций
                current_backup_fd=$((current_backup_fd + 1))
                progress=$((current_backup_fd * 100 / total_backup_fd))
                printf "\rПрогресс: %3d%%  (Обработано %d из %d)" $progress $current_backup_fd $total_backup_fd
            fi
        done

        if [ ${PIPESTATUS[0]} -eq 0 ]; then
            echo -e "\n${green_b}Бэкап успешно сохранён в $backup_dir/$backup_filename${end_color}\n"
        else
            echo "\n${yellow_b_in_red_back}Ошибка при создании бэкапа. Скрипт остановлен. Пожалуйста, проверьте права доступа${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
    }

    # backup_source="/var/CommuniGate"
    if [ ! -d "$backup_source" ]; then
        echo -e "${yellow_b}Директория $backup_source отсутствует на сервере. Бэкап не нужен${end_color}\n"
        return 1
    else
        echo "Найдена директория $backup_source"
        choice_question_backup="Создать бэкап директории $backup_source в формате tar.gz с меткой времени в имени бэкапа?"
        exit_answer_backup="Вы ввели недопустимые ответы, запустите скрипт заново"

        ask_user "$choice_question_backup" "$exit_answer_backup"
        response=$?

        if [[ $response -eq 0 ]]; then
            # Инициализируем директорию для бэкапов по умолчанию
            default_backup_dir="$download_dir/backup"
            # Просим пользователя ввести путь до заданной им директории для бэкапа
            echo -en "${blue_b}Введите путь до ДИРЕКТОРИИ для сохранения бэкапа (по умолчанию: $default_backup_dir):${end_color} "
            read user_backup_dir
            # Инициализируем переменную для пути к бэкапу, которая выберет значение, введённое пользователем, либо, если его нет, возьмёт путь по умолчанию
            backup_dir="${user_backup_dir:-$default_backup_dir}"
            if [ "$backup_dir" == "$default_backup_dir" ]; then
                # Проверяем, существует ли директория для бэкапов
                if [ ! -d "$default_backup_dir" ]; then
                    echo -e "${yellow_b}Заданная по умолчанию директория $default_backup_dir для бэкапов не существует. Создаём её...${end_color}"
                    mkdir -p "$default_backup_dir"  # Создаём директорию для бэкапов
                    echo -e "${green_b} Директория $default_backup_dir создана, приступаем к созданию бэкапа...${end_color}"
                    creating_backup
                else
                    echo -e "Создаём бэкап директории $backup_source..."
                    creating_backup
                fi
            elif [ "$backup_dir" == "$user_backup_dir" ]; then
                if [ ! -d "$user_backup_dir" ]; then
                    echo -e "${yellow_b_in_red_back}Заданная директория $user_backup_dir отсутствует или не примонтирована к серверу в качестве внешнего хранилища${end_color}"
                    choice_question_error="Продолжить выполнение скрипта без создания бэкапа?"
                    exit_answer_error="Вы ввели недопустимые ответы, запустите скрипт заново"

                    ask_user "$choice_question_error" "$exit_answer_error"
                    response=$?
                    if [ $response -ne 0 ]; then
                        echo -e "${yellow_b_in_red_back}Вы отказались от дальнейшего выполнения скрипта${end_color}"
                        log_message "$end_log_message"
                        exit 0
                    fi
                else
                    creating_backup
                fi
            fi
        else
            echo -e "${yellow_b}Вы ввели отрицательный ответ. Бэкап директории /var/CommuniGate не будет выполнен.${end_color}\n"
        fi
    fi
}

#----------КОНЕЦ ФУНКЦИИ бэкапа----------#

#----------НАЧАЛО ФУНКЦИИ по отключению фаервола----------#
firewall_func() {
    echo -e "${yellow_b}Для корректной работы CommuniGate Pro перед первой установкой рекомендуется отключить фаервол ufw/firewalld${end_color} 
${yellow_b}или очистить все правила для iptables/nftables на данном сервере и настроить их на ином forward-оборудовании/сервере${end_color}"
    choice_question_firewall="Хотите ли вы, чтобы скрипт отключил ufw/firewalld и очистил правила для iptables/nftables, если указанные сервисы есть на сервере?"
    exit_answer_firewall="Вы ввели недопустимые ответы, запустите скрипт заново"

    ask_user "$choice_question_firewall" "$exit_answer_firewall"
    response=$?

    # Если пользователь ответил "yes", продолжаем выполнение скрипта
    if [ $response -eq 0 ]; then
        # Флаг для отслеживания, найден ли хотя бы один фаервол
        local firewall_found="false"
        local error_disable_firewall=1

        # Проверка наличия ufw и его отключение
        if command -v ufw &>/dev/null; then
            echo "Установлен ufw. Отключаем..."
            ufw disable
            if [ $? -eq 0 ]; then
                echo "ufw отключен."
            else
                echo -e "Возникла ошибка при отключении ufw"
                error_disable_firewall=0
                problem_firewall_ufw="ufw"
            fi
            firewall_found="true"
        fi

        # Проверка наличия firewalld и его отключение
        if command -v firewall-cmd &>/dev/null; then
            echo "Установлен firewalld. Отключаем..."
            systemctl disable --now firewalld
            if [ $? -eq 0 ]; then
                echo "firewalld отключен."
            else
                echo -e "Возникла ошибка при отключении firewalld"
                error_disable_firewall=0
                problem_firewall_firewalld="firewalld"
            fi
            firewall_found="true"
        fi

        # Проверка наличия iptables и его сброс
        if command -v iptables &>/dev/null; then
            echo "Установлен iptables. Очищаем правила..."
            iptables -F \
            && iptables -X \
            && iptables -t nat -F \
            && iptables -t nat -X \
            && iptables -t mangle -F \
            && iptables -t mangle -X
            if [ $? -eq 0 ]; then
                echo "Правила iptables очищены."
            else
                echo -e "Возникла ошибка при очистке правил iptables"
                error_disable_firewall=0
                problem_firewall_iptables="iptables"
            fi
            firewall_found="true"
        fi

        # Проверка наличия nftables и его сброс
        if command -v nft &>/dev/null; then
            echo "Установлен nftables. Очищаем правила..."
            nft flush ruleset
            if [ $? -eq 0 ]; then
                echo "Правила nftables очищены."
            else
                echo -e "Возникла ошибка при очистке правил nftables"
                error_disable_firewall=0
                problem_firewall_nftables="nftables"
            fi
            firewall_found="true"
        fi

        # Проверка, был ли найден фаервол
        if [ "$firewall_found" == "false" ]; then
            echo -e "${green_b}На сервере НЕ установлен ни один из поддерживаемых фаерволов: ufw, firewalld, iptables и nftables.${end_color}\n"
        else
            if [ "$error_disable_firewall" -eq 0 ]; then
                # Инициализация пустой строки для результата
                local problem_firewalls=""

                # Добавляем переменные с пробелами, если они инициализированы
                [ -v problem_firewall_ufw ] && problem_firewalls+="$ufw, "
                [ -v problem_firewall_firewalld ] && problem_firewalls+="$firewalld, "
                [ -v problem_firewall_iptables ] && problem_firewalls+="$nftables, "
                [ -v problem_firewall_nftables ] && problem_firewalls+="$iptables, "

                # Убираем лишнюю запятую и пробел в конце (если они есть)
                problem_firewalls=$(echo "$problem_firewalls" | sed 's/, $//')
                echo -e "${yellow_b_in_red_back}Отключение ${blue_b_in_red_back}'$problem_firewalls'${end_color}${yellow_b_in_red_back} завершилось с ошибкой, выполните их отключение самостоятельно после завершения работы данного скрипта${end_color}"
                
                choice_question_error="Продолжить выполнение скрипта?"
                exit_answer_error="Вы ввели недопустимые ответы, запустите скрипт заново"

                ask_user "$choice_question_error" "$exit_answer_error"
                response=$?
                if [ $response -ne 0 ]; then
                    echo -e "${yellow_b_in_red_back}Вы отказались от дальнейшего выполнения скрипта, настройте ${blue_b_in_red_back}'$problem_firewalls'${end_color}${yellow_b_in_red_back} самостоятельно, либо запустите скрипт заново${end_color}"
                    log_message "$end_log_message"
                    exit 0
                fi
            else
                echo -e "${green_b}Проверка завершена. Все найденные фаерволы были отключены.${end_color}\n"
            fi
        fi
    else
        echo -e "${yellow_b_in_red_back}Вы ввели отрицательный ответ. В случае некорректной работы почтового сервера CommuniGate Pro${end_color} 
${yellow_b_in_red_back}после установки проверьте наличие фаервола на сервере и правил для него самостоятельно${end_color}\n"
    fi
}
#----------КОНЕЦ ФУНКЦИИ по отключению фаервола----------#

#----------НАЧАЛО ФУНКЦИИ, выводящей информацию об установленном пакете----------#
info_about_installed_package() {
    echo -e "\n${green_b}Получаем информацию об установленном пакете...${end_color}"

    if [ "$package_type" == "deb" ]; then
        echo -e "${purple}"
        dpkg -s "$deb_package_name" 
        echo -e "${end_color}"
    elif [ "$package_type" == "rpm" ]; then
        echo -e "${purple}"
        rpm -qi "$rpm_package_name_version"
        echo -e "${end_color}"
    else
        echo "${yellow_b}Не удалось получить информацию об установленном пакете.${end_color}"
    fi
}
#----------КОНЕЦ ФУНКЦИИ, выводящей информацию об установленном пакете----------#

#----------------------------------------------------------ОСНОВНОЕ ТЕЛО СКРИПТА----------------------------------------------------------#
# Проверка доступности ресурса с репозиториями CGP
if ! check_internet; then
    choice_question_offline="У вас нет доступа к ресурсу с репозиторием CGP. Хотите продолжить установку с опциями закрытого контура?"
    exit_answer_offline="Вы ввели недопустимые ответы, запустите скрипт заново"

    ask_user "$choice_question_offline" "$exit_answer_offline"
    response=$?

    if [[ $response -ne 0 ]]; then
        echo -e "${yellow_b_in_red_back}Вы отменили установку в закрытом контуре. Восстановите доступ к ресурсу https://doc.communigatepro.ru/packages/ с репозиторием CGP и попробуйте снова.${end_color}"
        log_message "$end_log_message"
        exit 1
    else
            # Попросим пользователя указать путь до установочного файла
        echo -en "${blue_b}Пожалуйста, укажите полный путь до установочного файла (.deb или .rpm):${end_color} "
        read offline_package_path

        # Проверка на существование файла и соответствие типу дистрибутива, где он будет устанавливаться
        if [ ! -f "$offline_package_path" ]; then
            echo -e "${yellow_b_in_red_back}Файл не найден. Убедитесь, что путь указан правильно и запустите скрипт заново.${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
        user_package_filename=$(basename "$offline_package_path")

        # Функция для кода на соответствие типу пакета
        copy_func() {
            if [ ! -f  "$download_dir/$user_package_filename" ]; then
                cp "$offline_package_path" "$download_dir/"
                echo -e "Пакет $user_package_filename скопирован в директорию для установки: $download_dir"
                if [ $? -ne 0 ]; then
                    echo "Ошибка при копировании файла."
                    log_message "$end_log_message"
                    exit 1
                fi
            else
                :
            fi
        }

        # Проверка на соответствие типу пакета
        if [[ "$offline_package_path" == *.deb && "$package_type" == "deb" ]]; then
            echo "Пакет .deb выбран правильно."
            copy_func
        elif [[ "$offline_package_path" == *.rpm && "$package_type" == "rpm" ]]; then
            echo "Пакет .rpm выбран правильно."
            copy_func
        else
            echo "${yellow_b_in_red_back}Тип пакета не соответствует менеджеру пакетов, используемого $package_type-дистрибутивом. Установка не может продолжиться${end_color}"
            log_message "$end_log_message"
            exit 1
        fi

        package_filename=$(basename "$download_dir/$user_package_filename")
        fi
else
    # Получаем ссылку на последний пакет
    package_url=$(get_latest_package_url)
    package_filename=$(basename "$package_url")
    full_url="https://doc.communigatepro.ru/packages/$package_url"

    # Проверяем, действительно ли ссылка ведет на файл перед скачиванием
    if [[ ! "$package_url" =~ \.deb$ && ! "$package_url" =~ \.rpm$ ]]; then
        echo -e "${yellow_b_in_red_back}Неверный URL пакета: $full_url.${end_color}"
        log_message "$end_log_message"
        exit 1
    fi
    
    echo -e "${white_b_in_orange_back}Найдена актуальная на данный момент версия пакета почтового сервера CommuniGate Pro: $package_filename${end_color}\n"

    if [ ! -f $download_dir/$package_filename ]; then
        # Скачиваем файл
        echo "Скачиваем файл с URL: $full_url в директорию $download_dir"
        wget -q --show-progress "$full_url" -O "$download_dir/$package_filename"

        # Проверяем успешность скачивания
        if [ $? -eq 0 ]; then
            echo "Файл успешно загружен и сохранен в $download_dir/$package_filename"
        else
            echo -e "${yellow_b_in_red_back}Ошибка при скачивании файла. Пожалуйста, проверьте интернет-соединение.${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
    else
        echo -e "${yellow_b}Загрузка файла установщика не нужна, актуальная версия почтового сервера CommuniGate Pro уже лежит по пути $download_dir/$package_filename
Будет выполнена установка из данного пакета.${end_color}"
    fi
fi

package_exist="false" # Инициализация технической переменной для вывода предупреждения в конце скрипта, если не буйдет найдено других версий CGP
# Проверяем, установлен ли уже этот пакет с такой версией
if [ "$package_type" == "deb" ]; then
    # Получаем точное имя и версию пакета из скачанного .deb файла
    deb_package_name="cgatepro-linux"
    deb_package_name_version=$(dpkg-deb -I "$download_dir/$package_filename" | grep Version | awk '{print $2}')

    # Проверка, установлен ли уже пакет
    dpkg -s "$deb_package_name" &>/dev/null
    if [ $? -eq 0 ]; then
        installed_version=$(dpkg -s "$deb_package_name" | grep "Version" | awk '{print $2}')
        if [ "$installed_version" == "$deb_package_name_version" ]; then
            echo -e "${white_b_in_green_back}Пакет $deb_package_name-$installed_version уже установлен в системе.${end_color}"
            info_about_installed_package
            log_message "$end_log_message"
            exit 0
        else
            package_exist="true"
            backup_func
        fi
    else
        # Бэкап в целях экономии места на диске будет создан только в том случае, когда скрипт убедиться в необходимости установки/обновления пакета CGP
        backup_func
        # Предлагаем отключить фаервол при первоначальной установке CGP на сервер
        firewall_func
    fi
elif [ "$package_type" == "rpm" ]; then
    # Получаем имя пакета из скачанного файла .rpm
    rpm_package_name="CGatePro-Linux"
    rpm_package_name_version=$(rpm -qp "$download_dir/$package_filename")

    # Проверка, установлен ли уже пакет
    rpm -q "$rpm_package_name" &>/dev/null
    if [ $? -eq 0 ]; then
            rpm -q "$rpm_package_name_version" &>/dev/null
            if [ $? -eq 0 ]; then
                echo -e "${white_b_in_green_back}Пакет $rpm_package_name_version уже установлен в системе.${end_color}"
                info_about_installed_package
                log_message "$end_log_message"
                exit 0
            else
                package_exist="true"
                backup_func
            fi
    else
        # Бэкап в целях экономии места на диске будет создан только в том случае, когда скрипт убедиться в необходимости установки/обновления пакета CGP
        backup_func
        # Предлагаем отключить фаервол при первоначальной установке CGP на сервер
        firewall_func
    fi
fi

# Проверяем наличие и статус службы "CommuniGate" в systemd
echo -e "${green_b}Проверка наличия запущенной службы 'CommuniGate' на сервере...${end_color}"
if systemctl list-units --type=service --all | grep "CommuniGate"; then
    # Если служба найдена, проверим её статус
    if systemctl is-active --quiet CommuniGate; then
        systemctl stop CommuniGate
        echo -e "${green_b}Служба 'CommuniGate' остановлена.${end_color}\n"
    else 
        echo -e "${green_b}Служба 'CommuniGate' неактивна.${end_color}\n"
    fi
else
    echo -e "${green_b}Служба CommuniGate не найдена, остановка не требуется.${end_color}\n"
fi

# Устанавливаем скачанный файл в зависимости от типа пакета
echo -e "${yellow_b}Устанавливаем пакет: $download_dir/$package_filename${end_color}"

if [ "$package_type" == "deb" ]; then
    # Устанавливаем .deb файл с помощью dpkg
    dpkg -i "$download_dir/$package_filename"
    if [ $? -eq 0 ]; then
        echo -e "${white_b_in_green_back}Пакет .deb успешно установлен.${end_color}"
    else
        echo -e "${yellow_b}Ошибка при установке .deb пакета. Попробуем исправить зависимостями...${end_color}"
        apt-get install -f -y  # Исправление зависимостей для Debian/Ubuntu
        if [ $? -ne 0 ]; then
            echo -e "${yellow_b_in_red_back}Не удалось установить пакет $download_dir/$package_filename. Работа скрипта завершена${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
    fi
elif [ "$package_type" == "rpm" ]; then
    # Устанавливаем .rpm файл с помощью rpm
    rpm -ivh "$download_dir/$package_filename"
    if [ $? -eq 0 ]; then
        echo -e "${white_b_in_green_back}Пакет .rpm успешно установлен.${end_color}"
    else
        echo -e "${yellow_b}Ошибка при установке .rpm пакета. Попытка установить при помощи DNF...${end_color}"
        dnf install "$download_dir/$package_filename"
        if [ $? -ne 0 ]; then
            echo -e "${yellow_b_in_red_back}Не удалось установить пакет $download_dir/$package_filename. Работа скрипта завершена${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
    fi
else
    echo -e "${yellow_b_in_red_back}Неизвестный тип пакета. Установка не выполнена. Проверьте, что файл $download_dir/$package_filename является установщиком${end_color}"
    log_message "$end_log_message"
    exit 1
fi

# Выводим информацию об установленном пакете
info_about_installed_package

# Добавляем службу CommuniGate в автозагрузку, если это необходимо
if ! systemctl is-enabled --quiet CommuniGate; then
    echo -e "${yellow_b}Добавление службы 'CommuniGate' в автозагрузку...${end_color}"
    systemctl enable CommuniGate
    echo -e "${green_b}Служба 'CommuniGate' добавлена в автозагрузку${end_color}\n"
else
    echo -e "${green_b}Служба 'CommuniGate' уже добавлена в автозагрузку.${end_color}\n"
fi

# Функция для предупреждения в случае, если CGP устанавливается на сервере впервые.
notice_end_output(){
    if [[ "$package_exist" != "true" ]]; then
        echo -e "\n${yellow_b_in_red_back}\e[4mВАЖНОЕ ПРЕДУПРЕЖДЕНИЕ:${end_color}${yellow_b_in_red_back} Если вы впервые устанавливаете почтовый сервер CommuniGate Pro,${end_color} 
${yellow_b_in_red_back}после перезагрузки нужно будет выполнить в терминале команду ${blue_b_in_red_back}'systemctl start CommuniGate'${end_color}${yellow_b_in_red_back}, чтобы запустить сервис CGP, если он не запустится автоматически после ребута,${end_color} 
${yellow_b_in_red_back}затем в течение 10 минут перейдите по адресу ${blue_b_in_red_back}https://localhost:9010 ${end_color}${yellow_b_in_red_back}для задания пароля УЗ ${blue_b_in_red_back}'postmaster'${end_color}${yellow_b_in_red_back}, являющегося администратором CGP${end_color}\n"
        return 0
    fi
}

# Запрос на перезагрузку
choice_question_reboot="Для завершения установки может потребоваться перезагрузка сервера. Хотите перезагрузить сервер сейчас?"
exit_answer_reboot="Перезагрузка отменена. Выполните её самостоятельно для стабильной работы CommuniGate Pro!"

ask_user "$choice_question_reboot" "$exit_answer_reboot"
response=$?

if [[ "$response" -eq 0 ]]; then
    notice_end_output
    if [ $? -eq 0 ]; then
        echo -e "${blue_b}Для продолжения перезагрузки нажмите ENTER...${end_color}"
        read  # Ожидает нажатия ENTER
    fi
    log_message "$end_log_message"
    sleep 1s
    echo -e "${yellow_b}\nПерезагружаем сервер...${end_color}"
    sleep 3s
    reboot
else
    echo -e "${yellow_b_in_red_back}Вы отказались от перезагрузки. Выполните её самостоятельно для стабильной работы CommuniGate Pro!${end_color}"
    notice_end_output
    log_message "$end_log_message"
fi