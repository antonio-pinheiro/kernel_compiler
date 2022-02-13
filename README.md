<h1>Kernel Compiler</h1>
<h2>Desenvolvido em Shell Script</h2>

<h5>Desenvolvedor:</h5>
Antônio Pinheiro<br>


<h5>Objetivo do projeto:</h5> O script Kernel Compiler permite que o usuário compile um novo Kernel em seu sistema Debian de forma automatizada. Através desse script é possível adicionar o usuário ao arquivo sudoers, liberando o acesso ao comando sudo que auxialiará no processo. Realiza de forma automática toda a compilação do Kernel, bastando apenas escolher a versão da qual se deseja instalar.<p></p> 

<h5>Detalhes técnicos</h5> O script é capaz de identificar automaticamente a quantidade de núcleos do processador permitindo que todas as suas threads sejam usadas durante o processo, garantindo uma execução muito mais rápida e eficiente. O Kernel Linux oferece suporte à um vasto conjunto de hardwares podendo gerar um Kernel inflado após a compilação. O script Kernel Compiler realiza um Strip removendo módulos e opções desnecessárias, gerando um arquivo em torno de 90% menor do que seria sem o Strip.<p></p>

Sistema Operacional compatível: DEBIAN<p></p>

<h5>DEPENDÊNCIAS DO PROJETO</h5>

libelf-dev / build-essential / linux-source / bc / kmod / cpio / flex / libncurses5-dev / libelf-dev / libssl-dev / dwarves

As dependências podem ser instaladas facilmente pelo usuário, bastando apenas selecionar a função de instalá-las, após isso o processo de compilação pode ser iniciado.

<h5>INSTRUÇÕES DE USO</h5>

O projeto possui o arquivo kernel_compiler.sh e o arquivo compilar_kernel_pt_BR.sh

Aplicar permissão de execução ao script: chmod +x kernel_compiler.sh ou compilar_kernel_pt_BR.sh<br></br>
Executar o script: ./kernel_compiler.sh ou compilar_kernel_pt_BR.sh<br></br>
Selecionar a versão do kernel da qual se deseja compilar.

ou executar o arquivo em português:



<h5>IMAGENS DO PROJETO</h5>

<p align="center">
  <img src="/images/img1.png" width="350" title="Compile Script">
  <img src="/images/img2.png" width="350" height="197" title="Compile Script">
</p>

<p align="center">
  <img src="/images/img3.png" width="350" title="Compile Script">
  <img src="/images/img4.png" width="350" title="Compile Script">
</p>

<p align="center">
  <img src="/images/img5.png" width="350" title="Compile Script">
</p>



