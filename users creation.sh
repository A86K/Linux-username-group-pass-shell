#!/bin/bash


RED="\033[0;31m"
GR="\033[0;32m"
NC="\e[0m"

read -p $'Чем займёмся?
\n 1)Создать пользователя или изменить пользователя
\n 2)Удалить пользователя с таким-же именем?' next


read -p "Выбери файл: " file
for line in $(cat $file)
do

    username=$(echo $line | cut -d ":" -f1)
    group=$(echo $line | cut -d ":" -f2)
    password=$(echo $line | cut -d ":" -f3)
    shell=$(echo $line | cut -d ":" -f4)
    ssl_password=`openssl passwd -1 $password`
    echo "Имя пользователя: $username | Группа: $group | Пароль: $password | Оболочка: $shell"
    
    case $next in  
    1) if [[ `grep $username /etc/passwd` ]]
    then 
        read -e -p "Произвести изменения пользователю $GR $username? $NC [Y/N]" first
        if [[ "$first" =~ ^([yY])$ ]]
        then
            read -p "Изменить пароль пользователя $GR $username? $NC [Y/N]" second
            if [[ "$second" =~ ^([yY])$ ]]
            then
                usermod -p $ssl_password $username
                echo -e "$GR $username $NC пароль изменён" 
            fi      
            read -p "Изменить $username оболочку? [Y/N]" third
            if [[ "$third" =~ ^([yY])$ ]]
            then
                current_shell=`grep  $username /etc/passwd | cut -d : -f4`
                if [[ $third != $shell ]]
                then
                    usermod -s $shell $username
                    echo -e "$GR $username $NC оболочка изменена на $shell"
                else
                    echo -e "$RED $username $NC пользователь уже находится в $shell"
                fi
            fi
            read -p "Изменить группу пользователя $username? [Y/N]" fourth
            if [[ "$fourth" =~ ^([yY])$ ]]
            then
                current_group=`groups $username | cut -d " " -f2`
                if [[ $current_group != $group ]]
                then
                    usermod -g $group $username
                    echo -e "$GR $username $NC группа изменена на $group"
                else
                    echo -e "$RED $username $NC уже находится в группе $group"
                fi
            
                fi
                    fi
                        else
                        groupadd -f $group;
                        useradd $username -p $ssl_password -g $group -s $shell;
                        echo -e "Созданный $username добавлен в группу $group"
                        fi;;
  2) if [[ `grep $username /etc/passwd` ]] 
    then
        userdel -r $username
        echo -e "$user $username удалён"
    fi;;
            esac
done


                    
            




   
    

			
