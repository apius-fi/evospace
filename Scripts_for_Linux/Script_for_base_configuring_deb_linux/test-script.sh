#!/bin/bash
#-----------------------------------------------------------------------------------
# It is simple script for test
# Prod by Alexander Guzeev in 2023
# All Rights reserved by the LICENSE. Copyright © 2023 Guzeew Alexander
#-----------------------------------------------------------------------------------
echo -e "Данный скрипт выводит дату и время в формате YYYY.MM.DD HH:MM:SS за заданное вами количество итераций\n"
sleep 1s

read -p "Please, type number of iteration: " numberIteration

case $numberIteration in 

[1-9] | [1-9][0-9]* )
    echo -e "Будет выполнено $numberIteration итераций!\n"
    for (( i = 1; i <= $numberIteration; i++ ))
    do
    date +"%Y.%m.%d %H:%M:%S"
    sleep 1s
    echo -e "Количество выполненных итераций: $i\n"
    done
;;

[-_.,\*\&?!@/a-zA-ZА-Яа-я]* )
    echo -e "Вы ввели не числовое значение"
;;

"" )
    echo -e "Ошибка! Вы ничего не ввели"
;;

esac
