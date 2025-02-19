# Banana Owner - RISC-V

## Descrição

Esse projeto implementa uma releitura do jogo Fix it Felix usando a linguagem de programação Assembly para a arquitetura RISC-V.
O objetivo é demostrar a capacidade de desenvolvimento de softwares em linguagem de baixo nível.

![tela_principal](data\screenshot\tela_principal.png)

## Funcionalidades

- Interface Gráfica (Bitmap Display, 320x240, 8 bits/pixel);
- Interface de Teclado (Keyboard and Display MMIO simulator);
- Interface de *Gamepad* (por meio do C++ e da API DirecInput da Microsoft)
- Interface de audio MIDI (ecalls 31,32,33);
- Multiplos layouts de nível;
- Colisão com projéteis, com o cenário e com os inimigos;
- Sistema de *powerup;*
- Movimentação e animação do personagem;
- HUD com informações sobre os coletáveis do nivel e o tempo para o fim deste;
- Musica e efeitos sonoros;

## Pré-requisitos

- Compilador RISC-V CPU ou emulador. ([FPGARS](https://leoriether.github.io/FPGRARS/) incluso no jogo);
- Pode ser necessário a instalação de certas [DLLs](https://www.dll-files.com) para rodar o jogo pelo executável. Entretanto, ainda é possível diretamente pelo emulador [FPGARS](https://leoriether.github.io/FPGRARS/)
  - Dentre os DLLs necessários estão: `dinput8.dll`, `dxguid.dll,` `dinput.dll` e o `libgcc_s_seh-1.dll`
  - Lembrando que só é preciso para **emular o controle**, não sendo necessário para jogar.

## Contribuição

Contribuições são bem vindas! Sinta-se convidado para reportar bugs, sugestões e para fazer pull requests.

## Como jogar

Para rodar o jogo, abra o executável `ProjetoISC.exe` ou rode diretamente pelo emulador.

## Imagens do Jogo

![tela do jogo principal](data\screenshot\tela_jogo.png)
![tela do fim do jogo](data\screenshot\tela_final.png)
![tela da morte](data\screenshot\tela_morte.png)

## Licença

Esse projeto é licenciado por [MIT License](https://opensource.org/licenses/MIT) - veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## Autores

- Caio Dias Fleury ([@CaioDFleury](https://github.com/CaioDFleury))
- Enzo Cardono Martins ([@CorsaRebaixado](https://github.com/CorsaRebaixado))
- Kaio Santos Araújo ([@Kisrym](https://github.com/Kisrym))

---

Se divirta jogando Banana Owner! 🎮
