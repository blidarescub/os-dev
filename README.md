os-dev
======

Learning project

Developing a functioning bootloader and primitive OS kernel

test.asm - this is a simple bootloader that generates some graphics and then initiates a very primitive shell

(first/second)_stage.asm - this is a two-stage bootloader. the first stage will print out a message and then read the next sector on the disk where the second bootloader is and load it into RAM and execute it.

BOOT.img - mount this image in VirtualBox as a floppy drive and boot from it (this will always be at the latest version of the code)

script.bat - this compiles the two stage bootloader, but only on windows. the script is self explanatory, only at the end you will need to use a hex editor and append the second bootloader to the first one in a single file.
