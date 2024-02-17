function post_install_kernel_debs__install_proxmox_port() {
	display_alert "Add https://github.com/jiangcuo/Proxmox-Port repository"
	do_with_retries 3 run_host_command_logged echo 'deb [arch=arm64] https://mirrors.apqa.cn/proxmox/debian/pve bookworm port' > ${SDCARD}/etc/apt/sources.list.d/pveport-tmp.list
	do_with_retries 3 run_host_command_logged curl https://mirrors.apqa.cn/proxmox/debian/pveport.gpg -o ${SDCARD}/etc/apt/trusted.gpg.d/pveport.gpg

	# Update
	display_alert "Update proxmox packages"
	do_with_retries 3 chroot_sdcard_apt_get_update
	# Install packages
	display_alert "Install proxmox packages"
	#do_with_retries 3 chroot_sdcard_apt_get_install isc-dhcp-server ifupdown2 - ifupdown want install for some reasons
	do_with_retries 3 chroot_sdcard_apt_get_install proxmox-ve postfix open-iscsi

	# Because now we have .list file from package
	do_with_retries 3 run_host_command_logged rm -rf ${SDCARD}/etc/apt/sources.list.d/pveport-tmp.list

	return 0
}