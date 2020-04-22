#!/bin/bash

function network_config(){
    gang="/"
    clear
    echo "--- menu ---"
    echo "1. config_static_ip"
    echo "2. use_DHCP"
    echo "3. active_a_device"
    echo "4. add_hosts"
    echo "5. which dns i using"
    echo "q. quit"
    read -p "option: " option
    case $option in
        1) 
            echo "connection you have:"
            nmcli con show | grep ethernet | awk '{ print $1 }' 
            read -p "which connection you want config: " connection
            read -p "ip:" ip
            read -p "prefix:" prefix
            read -p "dns:" dns
            read -p "gateway:" gateway
            nmcli connection modify $connection  IPv4.method manual
            nmcli con modify $connection ipv4.address $ip/$prefix ipv4.dns $dns ipv4.gateway $gateway
            nmcli con down $connection
            nmcli con up $connection
            echo "Done"
            ;;
        2) 
            echo "connection you have:"
            nmcli con show | grep ethernet | awk '{ print $1 }' 
            read -p "which connection you want config: " connection
            echo $connection
            nmcli con modify $connection IPv4.method auto
            nmcli con down $connection
            nmcli con up $connection
            echo "Done"
            ;;
        3)
            echo "device you have:"
            nmcli dev status 
            read -p "which device you want active: " device
            nmcli device connect $device || nmcli connection add type ethernet ifname $device
            echo "Done"
            ;;
        4)
            read -p "ip:" ip
            read -p "domain_name: " domain
cat >> /etc/hosts <<EOF
$ip   $domain
EOF
            ;;
        5)
            cat /etc/resolv.conf
            ;;
        q)
            exit
            ;;
        t)
            ;;
        *) 
            echo "nothing to do"
            ;;
    esac
}
network_config
