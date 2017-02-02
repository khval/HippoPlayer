# asm one don't work on AmigaOS4, we need to use VBCC

all:	keyfile.exe hippoplayer.exe

hippoplayer.exe: puu016.s objects/puu016.o
		c/vlink  -bamigahunk -o hippoplayer.exe -s objects/puu016.o 


objects/puu016.o: puu016.s
		c/vasmm68k_mot -Iwork:NDK_3.9/Include/include_i -Fhunk -o objects/puu016.o puu016.s

keyfile.exe: keyfile0.s objects/keyfile0.o 
		c/vlink -bamigahunk -o keyfile0.exe -s objects/keyfile0.o

objects/keyfile0.o: keyfile0.s
		c/vasmm68k_mot -Fhunk -o objects/keyfile0.o keyfile0.s
