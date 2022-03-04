#!/bin/bash

distro=$(lsb_release -i | cut -f 2-)
kernel_instalado=$(uname -r)

adicionar_sudoers(){
    
    if [[ $(id -u) == 0 ]]; then
        echo "Qual usuário você deseja adicionar ao arquivo Sudoers: "
        read usuario
        echo "$usuario  ALL=(ALL:ALL) ALL" >> /etc/sudoers
        echo "Usuário adicionado com sucesso!"
        echo "Agora você será capaz de utilizar o comando SUDO"
        funcao_principal
    else
        echo "Você deve ser root para executar essa função"
        echo "Por favor, execute esse script novamente como usuário root!!!"
        funcao_principal
    fi
}

compilar_dependencias(){

        echo "As dependencias aqui instaladas permitem que você compile seu Kernel"
        echo "Instalando dependências..."
        sudo apt update && sudo apt upgrade && sudo apt install libelf-dev build-essential \
        linux-source bc kmod cpio flex libncurses5-dev \
        libelf-dev libssl-dev dwarves lsb-release wget
        echo "Todas as dependências foram instaladas com sucesso"
        echo "Agora você pode executar a opção 2 e compilar seu novo Kernel..."
        funcao_principal
}

compilar_kernel(){
    
    if [[ $distro == "Debian" ]]; then
        echo "************************************************************************************" 
        echo "Insira o número da versão do Kernel da qual deseja instalar."
        echo "Exemplo: 5.15.23, 5.16.9, 5.10.9"
        echo "************************************************************************************"
        echo
        read kernel_versao

        if [[ $kernel_versao !=  $kernel_instalado ]]; then
            sudo wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$kernel_versao.tar.xz
            sudo tar -xvf linux-$kernel_versao.tar.xz -C /usr/src
            cd /usr/src/linux-$kernel_versao/
            sudo make menuconfig
            sudo sed -ri '/CONFIG_SYSTEM_TRUSTED_KEYS/s/=.+/=""/g' .config
            sudo make -j $(nproc)
            sudo make -j $(nproc) modules
            sudo make INSTALL_MOD_STRIP=1 modules_install
            sudo make install
            cd /boot
            sudo mkinitramfs -o initrd.img-$kernel_versao $kernel_versao
            sudo update-grub
            cd /usr/src/linux-$kernel_versao
            sudo make clean
            echo
            echo "************************************************************************************"
            echo "************************************************************************************"
            echo "O Kernel $kernel_versao foi instalado com sucesso!!!"
            echo 
            echo "Você deseja reiniciar o computador e começar a usar o seu mais novo Kernel? 'sim' ou 'nao'"
            echo "************************************************************************************"
            echo "************************************************************************************"
            read resposta

            if [[ $resposta == "sim" ]]; then
                sudo reboot
            else
                exit
            fi
            
        else
            echo "Essa versão do Kernel já encontra-se instalada..."
            echo "Selecione uma versão diferente ou encerre o programa."
            funcao_principal
        fi

    else
        echo "Esse script funciona apenas com sistemas Debian"
        echo "Fechando..."
        exit
    fi
}
 
funcao_principal(){
echo
echo "Selecione uma opção."
echo
echo "1  - Instalar as dependências necessárias para a compilação do Kernel."
echo "2  - Compilar seu novo Kernel Debian."
echo "3  - Adicionar seu usuário ao arquivo Sudoers e habilita-lo"
echo "4  - Sair do script"

while :
do
  read selecionar_opcao
  case $selecionar_opcao in

    1)  compilar_dependencias;;
	
    2)  compilar_kernel;;

    3)  adicionar_sudoers;;
    
    4)  exit

  esac
done
}

funcao_principal
