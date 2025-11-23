# What gets a install_script.sh for automation/ 

Plain-language rules:
If you see “file /etc/systemd/system/<svc>.service is not owned by any package”: make an install_<svc>.sh script.

If you see “/usr/local/bin/<binary>” and it is not findable via rpm -qf <binary>: make an install_<binary>.sh script.

Do not script things you install only via dnf install <pkg>.
