# !/bin/bash

[ -d /etc/yum.repos.d/bak/ ] || mkdir -p /etc/yum.repos.d/bak/
mv /etc/yum.repos.d/* /etc/yum.repos.d/bak/
[ -d /mnt/iso ] || mkdir -p /mnt/iso
mount /dev/sr0 /mnt/iso

cat > /etc/yum.repos.d/localyum.repo << EOF
[localyum_BaseOS]
name=localyum_BaseOS
baseurl=file:///mnt/iso/BaseOS
enabled=1
gpgcheck=0
EOF

cat >> /etc/yum.repos.d/localyum.repo << EOF

[localyum_AppStream]
name=localyum_AppStream
baseurl=file:///mnt/iso/AppStream
enabled=1
gpgcheck=0
EOF

dnf makecache 
dnf repolist
