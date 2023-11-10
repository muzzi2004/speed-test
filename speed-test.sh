#!/bin/bash
###########Parametrs###########
version="0.1"


dir_source=$(pwd)
###Log files
output_log="./output.log"
error_log="./error.log"
iperf3_server_log="./iperf3-s.log"

###Function
show_menu () {
         normal=`echo "\033[m"`
         menu=`echo "\033[36m"` #Blue
         number=`echo "\033[33m"` #yellow
         bgred=`echo "\033[41m"`
         fgred=`echo "\033[31m"`

	 printf "${menu}${number} 1)${menu} Проверить доступность Площадки 2 ${normal}\n"
         printf "${menu}${number} 2)${menu} Запустить замеры скорости ${normal}\n"
         printf "${menu}${number} 3)${menu} Запустить iperf3 сервер ${normal}\n"
         printf "${menu}${number} 4)${menu} Остановить iperf3 сервер ${normal}\n"
         printf "${menu}${number} 5)${menu} Архивация логов ${normal}\n"
         printf "...........................................................\n"
	     printf "Пожалуйста, выбирете вариант или нажмите ${fgred}q для выхода. ${normal}"
         read opt
}

###Function

function_option_picked () {
          msgcolor=`echo "\033[01;31m"` # bold red
          normal=`echo "\033[00;00m"` # normal white
          message=${@:-"${normal}Error: No message passed"}
          printf "${msgcolor}${message}${normal}\n"
}

function_access_ip_address () {
        echo -e '\n------------------------\n##########Проверка доступности площадки 2############\n' && sleep 1
        read -p 'Введите ip addrss интерфейса ноутбука на Плащадки 2:
Пример [192.168.0.10]:   ' IP
        if ping -c 5 $IP 2>>$error_log 1>>$output_log ; then echo "Узел доступен" && echo "Трассировка до узла" && tracepath $IP 2>>$error_log 1>>$output_log ; else echo "Узел не доступен"; fi 
}

function_iperf3_server_start () {
        echo -e '\n------------------------\n##########IPERF3-SERVER START############\n' && sleep 1
        pid_id_iperf3=$(pidof iperf3) && kill -9 $pid_id_iperf3
        nohup iperf3 -s --logfile $iperf3_server_log 2>&1 & 
}

function_iperf3_server_stop () {
        echo -e '\n------------------------\n##########IPERF3-SERVER STOP############\n' && sleep 1
        if pidof iperf3 2>>$error_log 1>>$output_log ; then pid_id_iperf3=$(pidof iperf3) 2>&1 && kill -9 $pid_id_iperf3 && echo "iperf3 server остановлен"; else echo "iperf3 server не был запущен"; fi
}

function_iperf3_client_start_tcp_1400_upload () {
        echo -e '\n------------------------\nПроисходит замер скорости утилитой iperf3 -M 1400 -t 28 upload\n' && sleep 1
        if nc -z -v -w5 $IP_IPRF3SERVER 5201 2>>$error_log 1>>$output_log; 
        then iperf3 -c $IP_IPRF3SERVER -M 1400 -t 28 --logfile ./iperf3_client_start_tcp_1400_upload-$(date --iso-8601).txt && echo "Замер завершен";
        else echo 'Сервер IPERF3 недоступен на порту 5201'; fi
}

function_iperf3_client_start_tcp_1400_download () {
        echo -e '\n------------------------\nПроисходит замер скорости утилитой iperf3 -M 1400 -t 28 download\n' && sleep 1
        if nc -z -v -w5 $IP_IPRF3SERVER 5201 2>>$error_log 1>>$output_log; 
        then iperf3 -c $IP_IPRF3SERVER -M 1400 -R -t 28 --logfile ./iperf3_client_start_tcp_1400_download-$(date --iso-8601).txt && echo "Замер завершен";
        else echo 'Сервер IPERF3 недоступен на порту 5201'; fi
}

function_iperf3_client_start_tcp_500_upload () {
        echo -e '\n------------------------\nПроисходит замер скорости утилитой iperf3 -M 500 -t 28 upload\n' && sleep 1
        if nc -z -v -w5 $IP_IPRF3SERVER 5201 2>>$error_log 1>>$output_log; 
        then iperf3 -c $IP_IPRF3SERVER -M 500 -t 28 --logfile ./iperf3_client_start_tcp_500_upload-$(date --iso-8601).txt && echo "Замер завершен";
        else echo 'Сервер IPERF3 недоступен на порту 5201'; fi
}

function_iperf3_client_start_tcp_500_download () {
        echo -e '\n------------------------\nПроисходит замер скорости утилитой iperf3 -M 500 -t 28 download\n' && sleep 1
        if nc -z -v -w5 $IP_IPRF3SERVER 5201 2>>$error_log 1>>$output_log; 
        then iperf3 -c $IP_IPRF3SERVER -M 500 -R -t 28 --logfile ./iperf3_client_start_tcp_500_download-$(date --iso-8601).txt && echo "Замер завершен";
        else echo 'Сервер IPERF3 недоступен на порту 5201'; fi
}

function_iperf3_client_start_udp_1400_upload () {
        echo -e '\n------------------------\nПроисходит замер скорости утилитой iperf3 -u -l 1400 -b 100m -t 28 upload\n' && sleep 1
        if nc -z -v -w5 $IP_IPRF3SERVER 5201 2>>$error_log 1>>$output_log; 
        then iperf3 -c $IP_IPRF3SERVER -u -l 1400 -b 100m -t 28 --logfile ./iperf3_client_start_udp_1400_upload-$(date --iso-8601).txt && echo "Замер завершен";
        else echo 'Сервер IPERF3 недоступен на порту 5201'; fi
}
function_iperf3_client_start_udp_1400_download () {
        echo -e '\n------------------------\nПроисходит замер скорости утилитой iperf3 -u -l 1400 -b 100m -t 28 download\n' && sleep 1
        if nc -z -v -w5 $IP_IPRF3SERVER 5201 2>>$error_log 1>>$output_log; 
        then iperf3 -c $IP_IPRF3SERVER -u -l 1400 -b 100m -R -t 28 --logfile ./iperf3_client_start_udp_1400_download-$(date --iso-8601).txt && echo "Замер завершен";
        else echo 'Сервер IPERF3 недоступен на порту 5201'; fi
}

function_iperf3_client_start_udp_500_upload () {
        echo -e '\n------------------------\nПроисходит замер скорости утилитой iperf3 -u -l 500 -b 100m -t 28 upload\n' && sleep 1
        if nc -z -v -w5 $IP_IPRF3SERVER 5201 2>>$error_log 1>>$output_log; 
        then iperf3 -c $IP_IPRF3SERVER -u -l 500 -b 100m -t 28 --logfile ./iperf3_client_start_udp_500_upload-$(date --iso-8601).txt && echo "Замер завершен";
        else echo 'Сервер IPERF3 недоступен на порту 5201'; fi
}
function_iperf3_client_start_udp_500_download () {
        echo -e '\n------------------------\nПроисходит замер скорости утилитой iperf3 -u -l 500 -b 100m -t 28 download\n' && sleep 1
        if nc -z -v -w5 $IP_IPRF3SERVER 5201 2>>$error_log 1>>$output_log; 
        then iperf3 -c $IP_IPRF3SERVER -u -l 500 -b 100m -R -t 28 --logfile ./iperf3_client_start_udp_500_download-$(date --iso-8601).txt && echo "Замер завершен";
        else echo 'Сервер IPERF3 недоступен на порту 5201'; fi
}

function_select_iperf3_server_addr () {
        read -p 'Введите ip addrss интерфейса ноутбука на Плащадки 2 где запущен IPERF3 SERVER:
Пример [192.168.0.10]:   ' IP_IPRF3SERVER
}

function_select_interface_collection () {
        echo -e '\n------------------------\n##########Выбор интерфейса с которого будет сборс данных############\n' && sleep 1
        dir=$(pwd)
        cd /sys/class/net/ && select opt in *; do select_interface_collection=$opt && break; done
        cd $dir
        echo $select_interface_collection 2>>$error_log 1>>$output_log
}

function_iptraf_ng_start () {
        echo -e '\n------------------------\n##########Запуск сбора статистики с интерфейса############\n' && sleep 1
        #read -p 'Введите количество минут, которое будет собираться статистика с интерфейса:
#Пример [2]:   ' minutes
        minutes='1'
        iptraf-ng -d $select_interface_collection -t $minutes -L ./$select_interface_collection.detail-$1-$(date --iso-8601).txt -B 2>>$error_log 1>>$output_log
        iptraf-ng -z $select_interface_collection -t $minutes -L ./$select_interface_collection.pkt_size-$1-$(date --iso-8601).txt -B 2>>$error_log 1>>$output_log
        echo -e 'PID-ы процессов iptraf-ng \n' && sleep 3 && pidof iptraf-ng  
}

iptraf_ng_stop () {
        if pidof iptraf-ng 2>>$error_log 1>>$output_log ; then killall -s 9 iptraf-ng && echo "iptraf-ng остановлен"; else echo "iptraf-ng не был запущен"; fi
}

archive_log () {
        echo -e '\n------------------------\n##########Запуск архивации логов############\n' && sleep 1
        tar -zcf ./log-$(date --iso-8601).tar.gz *.log *.txt 2>>$error_log 1>>$output_log
}

####Logic
logic_1 () {
        function_access_ip_address
}

logic_2 () {
        function_select_interface_collection
        function_select_iperf3_server_addr
        so_logic_tcp_1400
        so_logic_tcp_500
        so_logic_udp_1400
        so_logic_udp_500
}

so_logic_tcp_1400 () {
        function_iptraf_ng_start tcp_1400
        function_iperf3_client_start_tcp_1400_upload
        function_iperf3_client_start_tcp_1400_download
}

so_logic_tcp_500 () {
        function_iptraf_ng_start tcp_500
        function_iperf3_client_start_tcp_500_upload
        function_iperf3_client_start_tcp_500_download
}

so_logic_udp_1400 () {
        function_iptraf_ng_start udp_1400
        function_iperf3_client_start_udp_1400_upload
        function_iperf3_client_start_udp_1400_download       
}

so_logic_udp_500 () {
        function_iptraf_ng_start udp_500
        function_iperf3_client_start_udp_500_upload
        function_iperf3_client_start_udp_500_download
}

###Menu
clear
show_menu
while :
    do
    if [ $opt = '' ]; then
      exit;
    else
      case $opt in
        1) clear;
            function_option_picked "Проверить доступность Площадки 2";
            printf "Началась проверка\n" && logic_1 && printf "Проверка завершена.Логи можно посмотреть в \n $output_log\n $error_log\n\n";
            show_menu;
        ;;
        2) clear;
            function_option_picked "Запустить замеры скорости и сбор информации с интерфейса";
            printf "Запуск замера скорости и сбора информации с интерфейса\n" && logic_2 && printf "Замер и сбор завершины. Логи можно посмотреть в \n $output_log\n $error_log\n ./$select_interface_collection.detail-*-$(date --iso-8601).txt\n ./$select_interface_collection.pkt_size-*-$(date --iso-8601).txt\n ./iperf3_client_start*-$(date --iso-8601).txt\n\n";
            show_menu;
        ;;
        3) clear;
            function_option_picked "Запустить iperf3 сервер";
            function_iperf3_server_start && printf "IPERF3 Server запущен \n\n";
            show_menu;
        ;;
        4) clear;
            function_option_picked "Остановить iperf3 сервер";
            function_iperf3_server_stop;
            show_menu;
        ;;
        5) clear;
            function_option_picked "Архивация логов";
            archive_log;
            show_menu;
        ;;
        q)exit;
        ;;
        \n)exit;
        ;;
        *)clear;
            option_picked "Выберите вариант в меню";
            show_menu;
        ;;
      esac
    fi
done