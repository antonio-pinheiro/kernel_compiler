#!/bin/bash
############################################################################## 
##									    ## 
##			     Kernel Compiler           		.~.         ##
##		    Created by:  Antônio Pinheiro 		/V\	    ##
##							       // \\	    ##
##							      /(   )\	    ##
##							       ^`~'^        ##
##							        TUX	    ##
##				                         		    ##
##	              OS Compatibility: Debian 11                           ##	
##                      						    ##
##############################################################################
##  Project:		Kernel Compiler				            ##
##									    ##
##  File name:		kernel_compiler.sh 			            ##
##									    ##
##  Description:	Automatically compiles the kernel                   ##
##	                                                                    ##
##  Date:               12/02/2022				            ##             
##  									    ##
## 									    ##
##############################################################################
##			    !!!INSTRUCTIONS!!!	                            ##
##                                                                          ##
##		        chmod +x kernel_compiler.sh                         ##
## 		            ./kernel_compiler.sh                            ##
##############################################################################

distro=$(lsb_release -i | cut -f 2-)
kernel_installed=$(uname -r)
cpu_threads=$(nproc)

add_user_sudoers(){
    
    if [[ $(id -u) == 0 ]]; then
        echo "Which User do you want to add in Sudoers File?: "
        read user
        echo "$user  ALL=(ALL:ALL) ALL" >> /etc/sudoers
        start_function
    else
        echo "You must be root to run this function"
        echo "Please execute this script as root and run this option again."
        start_function
    fi
}

compile_dependencies(){
    
        echo "The dependencies in this script allow you to compile the kernel"
        echo "Installing dependencies..."
        sudo apt update && sudo apt upgrade && sudo apt install libelf-dev build-essential \
        linux-source bc kmod cpio flex libncurses5-dev \
        libelf-dev libssl-dev dwarves lsb-release wget
        echo "All dependencies have been installed."
        echo "Now you can execute option 2 to compile the kernel..."
        start_function
}

compile_kernel(){
    
    if [[ $distro == "Debian" ]]; then
        #User can choose the linux kernel version
        echo "************************************************************************************" 
        echo "Insert the number of the kernel version do you want to install"
        echo "Example: 5.15.23, 5.16.9, 5.10.9"
        echo "************************************************************************************"
        read kernel_version

        if [[ $kernel_version !=  $kernel_installed ]]; then
            #Download chosen version of Kernel Linux and compile it.
            sudo wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$kernel_version.tar.xz
            sudo tar -xvf linux-$kernel_version.tar.xz -C /usr/src
            cd /usr/src/linux-$kernel_version/
            sudo make menuconfig
            sudo sed -ri '/CONFIG_SYSTEM_TRUSTED_KEYS/s/=.+/=""/g' .config
            sudo make -j $cpu_threads
            sudo make -j $cpu_threads modules
            sudo make INSTALL_MOD_STRIP=1 modules_install
            sudo make install
            cd /boot
            sudo mkinitramfs -o initrd.img-$kernel_version $kernel_version
            sudo update-grub
            echo
            echo "************************************************************************************"
            echo "************************************************************************************"
            echo "The Kernel $kernel_version has been successfully compiled!"
            echo 
            echo "Do you want to reboot the system now and start to use your new Kernel? 'yes' or 'no'"
            echo "************************************************************************************"
            echo "************************************************************************************"
            read answer

            if [[ $answer == "yes" ]]; then
                sudo reboot
            else
                exit
            fi
            
        else
            echo "This Kernel version is already installed."
            echo "Please select other version or close this script."
            start_function
        fi

    else
        echo "This script only works with Debian System"
        echo "Close..."
        exit
    fi
}

#Shows to user the script options. 
start_function(){
echo
echo "Please select an option."
echo
echo "1  - Install the dependencies that are needed to compile the kernel."
echo "2  - Compile the Kernel."
echo "3  - Add users to sudoers file and enable it"
echo "4  - Exit"

while :
do
  read select_option
  case $select_option in

    1)  compile_dependencies;;
	
    2)  compile_kernel;;

    3)  add_user_sudoers;;
    
    4)  exit

  esac
done
}

start_function
