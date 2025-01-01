#!/bin/bash
#-----------------------------------------------------------------------------------
# Script for base configuration of Debian-like OS (for example: Debian, Ubuntu)
# Prod by Alexander Guzeev in 2024
# All Rights reserved by the LICENSE. Copyright © 2024 Guzeew Alexander
#-----------------------------------------------------------------------------------

# Данный скрипт стоит использовать на свежоразвернутой ОС Debian

# Проверка, что скрипт запускается от имени пользователя root, либо от другого пользователя с sudo правами
if [[ $EUID -eq 0 ]]
then

    echo -e "Данный скрипт стоит использовать на свежоразвернутой ОС Debian\n"
    sleep 1s
    # Отображение добавляемых репозиториев, лишняя информация удалена при помощи sed
    echo -e "В файле /etc/apt/sources.list будут указаны следующие репозитории: \n\n$(sed '/^#\|^$/d' techFiles/repo.txt) \n"
    sleep 1s
    # Отображение устанавливаемых пакетов
    echo -e "В рамках данного скрипта будут установлены следующие пакеты: $(cat techFiles/packageList.txt). \nТакже опционально можно будет накатить обновления на ОС и установить VSCode"
    sleep 2s

    # Инициализация переменной responseOnFerstQuestion для конструкцие case, управляющей запуском скрипта
    read -p "Запустить выполнение скрипта? Да/Нет (Yes/No): " responseOnFerstQuestion

    case $responseOnFerstQuestion in

    "Y" | "y" | "yes" | "YES" | "Yes" | "Д" | "д" | "да" | "ДА" | "Да")
        # Перезапись /etc/apt/sources.list в соответствии с файлом repo.txt
        echo -e "1. Запуск скрипта"
        sleep 1s
        sudo cat techFiles/repo.txt > /etc/apt/sources.list
        echo -e "\n2. Файл /etc/apt/sources.list перезаписан, добавлены основные репозитории из файла repo.txt"

        sleep 2s

        # Функция correction для удаления пакетов, которые были установлены автоматически, 
        # поскольку они требовались для некоторых других пакетов, но после удаления этих пакетов они больше не нужны.
        function correction {
            sleep 1s
            echo -e "\n5. Запуск коррекции через apt autoremove\n"
            sleep 1s
            sudo apt autoremove -y
            sleep 2s
        }

        sudo apt update 2> techFiles/logs/preerror_update.log

        # Если обновление репозиториев прошло успешно
        if [ $? -eq 0 ]
            then 
            # Будут установлены пакеты указанные через пробел в файле packageList.txt
            echo -e "\n3. Команда apt update применена успешно, через 5 секунд начнется установка пакетов $(cat techFiles/packageList.txt)"
            sleep 5s
            sudo dpkg -a --configure
            sudo apt install -f
            sudo apt install $(cat techFiles/packageList.txt) -y 2> techFiles/logs/preerror_install.log

            # Если установка пакетов прошла успешно
            if [ $? -eq 0 ]
                then echo -e "\n4. ПАКЕТЫ: $(cat techFiles/packageList.txt) УСТАНОВЛЕНЫ КОРРЕКТНО"
                # Запуск функции correction
                correction

                # Цикл для обновления всех пакllетов ОС Debian до свежей версии с тройным подтверждением в случае некорректного ответа
                for (( var1=1; var1 <= 3; var1++ ))
                do
                echo -e "\nПроверить наличие обновлений пакетов и ядра ОС и установить их, если они есть?"
                # Инициализация переменной response
                read -p 'Да/Нет (Yes/No): ' response
                sleep 1s
                    # Если пользователь соглашается - ставиться обновление ОС. Можно было также реализовать через case, но в целях демонстрации сделал через конструкцию if-elif-else
                    if [[ "$response" == "Да" ]] || [[ "$response" == "да" ]] || [[ "$response" == "ДА" ]] || [[ "$response" == "д" ]] || [[ "$response" == "Д" ]] || [[ "$response" == "Yes" ]] || [[ "$response" == "yes" ]] || [[ "$response" == "YES" ]] || [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]
                        then
                        echo -e "\nПроверка наличия обновлений пакетов ОС"
                        sleep 1s
                        sudo apt update
                        echo -e "\nУстановка имеющихся обновлений ОС начнётся через 5 секунд"
                        sleep 5s
                        sudo apt dist-upgrade -y
                        sleep 1s
                        echo -e "\nОбновления пакетов установлены, необходима перезагрузка"
                        break
                    # Пользователь отказывается от обновления
                    elif [[ "$response" == "Нет" ]] || [[ "$response" == "нет" ]] || [[ "$response" == "НЕТ" ]] || [[ "$response" == "н" ]] || [[ "$response" == "Н" ]] || [[ "$response" == "No" ]] || [[ "$response" == "no" ]] || [[ "$response" == "NO" ]] || [[ "$response" == "n" ]] || [[ "$response" == "N" ]]
                        then
                        echo -e "Вы отказались от установки обновлений пакетов ОС"
                        break
                    # Пользователь вводит любой ответ, который нельзя интерпретировать как ответ Да или Нет, цикл перезапускается и так три раза
                    else
                        echo -e "Вы ввели слово или символ, которые нельзя интерпретировать как ответ на вопрос об установке обновлений. Попробуйте снова"
                    fi
                done
                sleep 1s
            
                # Проверка наличия VSCode в системе, если его нет, будет предложено установить
                echo -e "\nПроверка наличия VSCode в системе"
                sleep 2s
                dpkg --status code &> /dev/null
                
                # Если VSCode уже есть в системе
                if [ $? -eq 0 ]
                    then
                    echo -e "\nVSCode уже имеется в системе"
                # VSCode отсуствует в системе, будет предложено установить
                else
                    # Установка VSCode. Реализована через оператор case
                    for (( var2=1; var2 <= 3; var2++ ))
                    do
                    echo -e "\nПакет отсутствует в системе. Установить Visual Studio Code?"
                    # Инициализация переменной responseOnTrhitdQuestion для оператора case
                    read -p "Да/Нет (Yes/No): " responseOnTrhitdQuestion
                    sleep 1s
                    case $responseOnTrhitdQuestion in
                        # Пользователь соглашается на установку VSCode в систему
                        "Y" | "y" | "yes" | "YES" | "Yes" | "Д" | "д" | "да" | "ДА" | "Да")
                            sudo apt install software-properties-common apt-transport-https wget gnupg -y
                            wget -O- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg
                            echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main | sudo tee /etc/apt/sources.list.d/vscode.list
                            # Обновление пакетной базы после добавления репозитория для Установки VSCode
                            sudo apt update
                            # Установка VSCode
                            sudo apt install code -y
                            break
                        ;;
                        # Пользователь отказывается от установки VSCode
                        "N" | "n" | "no" | "NO" | "No" | "Н" | "н" | "нет" | "НЕТ" | "Нет")
                            echo -e "Вы отказались от установки VSCode"
                            break
                        ;;
                        # Пользователем был введён недопустимый ответ
                        *) 
                            echo -e "Вы ввели недопустимый ответ. Попробуйте снова"
                        ;;

                    esac
                    done
                fi
            
            # Если установка пакетов прошла с ошибками
            else
                sudo mv techFiles/logs/preerror_install.log techFiles/logs/error_install.log
                echo -e "\n4. Один или несколько пакетов из списка: $(cat techFiles/packageList.txt) - установлены некорректно. Вывод ошибок команды apt install перенаправлен в файл error_install.log, находящийся по пути techFiles/logs/"
                # Запуск функции correction
                correction
            fi
        # Обновление репозиториев прошло с ошибками
        elif [ $? -ne 0 ]
            then sudo mv techFiles/logs/preerror_update.log techFiles/logs/error_update.log
            echo -e "\n3. Команда apt update завершила свою работу с ошибками, проверьте соединение с Интернетом и попробуйте сначала. \nЕсли это не поможет - по пути techFiles/logs/ создан файл error_update.log для анализа имеющихся ошибок из вывода apt update"
        fi

        # Удаляет технические файлы логов, которые использовались в процессе работы скрипта.
        rm techFiles/logs/preerror_update.log 2> /dev/null
        rm techFiles/logs/preerror_install.log 2> /dev/null

        echo -e "\nРабота скрипта завершена"
    ;;

    # Пользователь отказался от запуска скрипта
    "N" | "n" | "no" | "NO" | "No" | "Н" | "н" | "нет" | "НЕТ" | "Нет")
        echo -e "Вы отказались от запуска скрипта"
    ;;

    # Пользователем был введён недопустимый ответ
    *) 
        echo -e "Вы ввели недопустимый ответ, запустите скрипт заново"
    ;;

    esac

# Скрипт был запущен из под пользователя без sudo прав
else
    echo -e "Вы запустили скрипт без привелегий суперпользователя. \nПопробуйте запустить скрипт из под пользователя root, \nлибо с использованием sudo для пользователя, обладающего такими правами"
fi
