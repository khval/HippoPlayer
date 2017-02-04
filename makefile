# asm one don't work on AmigaOS4, we need to use VBCC

all:	comment_log_file keyfile.exe hippoplayer.exe 

hippoplayer.exe: puu016.s objects/puu016.o
		c/vlink  -bamigahunk -o hippoplayer.exe -s objects/puu016.o 

objects/puu016.o: puu016.s
		c/vasmm68k_mot -Iinclude -Fhunk -o objects/puu016.o puu016.s *> t:error.log
#		c/vasmm68k_mot -Iwork:Amiga_Dev_CD_v1.1/NDK_3.1/INCLUDES/INCLUDE_I/ -Fhunk -o objects/puu016.o puu016.s

keyfile.exe: keyfile0.s objects/keyfile0.o 
		c/vlink -bamigahunk -o keyfile0.exe -s objects/keyfile0.o

objects/keyfile0.o: keyfile0.s
		c/vasmm68k_mot -Fhunk -o objects/keyfile0.o keyfile0.s

comment_log_file:
		grep -n "\*[[:space:]]" puu016.s > comment.log