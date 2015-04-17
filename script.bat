del FRST.img
del SCND.img
nasm -o FRST.bin first_stage.asm
nasm -o SCND.bin second_stage.asm
ren FRST.bin FRST.img
ren SCND.bin SCND.img