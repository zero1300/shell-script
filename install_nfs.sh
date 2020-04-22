#!/bin/bash

# ----------- server ------------

function insatll_nfs_on_server(){
    clear
    dnf install nfs-utils -y
    systemctl enable nfs-server rpcbind
    systemctl start nfs-server rpcbind
}

function config_nfs_on_server(){
    clear
    read -p "which directory you want to share(if no existi system will create it): " dir
    read -p "which network you want to share(ip/prefix): " network
    [ -d $dir ] || mkdir -p $dir

cat >> /etc/exports << EOF
$dir $network(rw,no_root_squash)
EOF
    exportfs -var
    # if selinux open then run below command
    setsebool -P nfs_export_all_rw 1
    # config firewall
    firewall-cmd --add-service={nfs,nfs3,mountd,rpc-bind} --permanent
    firewall-cmd --reload
    exportfs -var
}

function edit_exports(){
    vim /etc/exports
}

# ----------- client ------------
function install_nfs_on_client(){
    dnf install nfs-utils -y
}

function showmount_on_client(){
    read -p "ip: " ip
    showmount --exports $ip
}


function mount_nfs_share(){
    read -p "which directory you want to mount nfs share(if no existi system will create it): ": dir
    read -p "nfs server ip: " ip
    echo "directory you can choose on this server: "
    showmount --exports $ip
    read -p "choose one: " sdir
    [ -d $dir ] || mkdir -p $dir
    mount -t nfs $ip:$sdir $dir
    df -h $dir
    read -p "Do you permanent config(y/n): " opt
    if [ $opt == "y" ];then
        echo "$ip:$sdir $dir nfs defaults 0 0" >> /etc/fstab
    fi
}

read -p "Are you server or client(s/c): " opt
if [ $opt == s ];then
    echo "--- server option ---"
    echo "1. install nfs"
    echo "2. config nfs"
    echo "3. edit /etc/exports"
    read -p "choose: " choose
    case $choose in
        1)
            insatll_nfs_on_server
            ;;
        2) 
            config_nfs_on_server
            ;;
        3)
            edit_exports
            ;;
        *) 
            echo "nothing to do"
            ;;
    esac
    
elif [ $opt == c ];then
    echo "--- client option ---"
    echo "1. insatll_nfs"
    echo "2. mount_nfs"
    read -p "choose: " choose
    if [ $choose == 1 ];then
        install_nfs_on_client
    fi
    if [ $choose == 2 ];then
        mount_nfs_share
    fi
fi
    


