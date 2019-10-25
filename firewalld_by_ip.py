#!/usr/bin/python

import os

# example var
# ports = ["80", "443", "22", ....]
# ips = ["192.168.0.123/32", "192.168.0.233/32", ...]

ports = [""]
ips = [""]


os.system("systemctl restart firewalld")
for ip in ips :
    for port in ports :
        cmd = 'firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address=' + '"' + ip + '"' + ' port protocol="tcp" port="' + port + '" accept"'
        os.system(cmd)

os.system("firewall-cmd --reload")
