os-dev
======

Learning project

Developing a functioning bootloader and primitive OS kernel

test.asm - this is a simple bootloader that generates some graphics and then initiates a very primitive shell

(first/second)_stage.asm - this is a two-stage bootloader. the first stage will print out a message and then read the next sector on the disk where the second bootloader is and load it into RAM and execute it.
