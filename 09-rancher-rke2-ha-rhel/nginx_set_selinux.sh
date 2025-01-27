semanage port -a -t http_port_t  -p tcp 9345 
semanage port -a -t http_port_t  -p tcp 6443

setsebool -P httpd_can_network_connect 1