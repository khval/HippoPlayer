
compiler = c/os4_cross_compiler_vasmm68k_mot

# asm one don't work on AmigaOS4, we need to use VBCC

all:	keyfile.exe hippoplayer.exe copy_files

clean:
	delete objects/#?
	delete kpl
	delete #?.exe

# compile programs

hippoplayer.exe: puu016.s objects/puu016.o kpl
		c/vlink  -bamigahunk -o hippoplayer.exe -s  objects/puu016.o 

keyfile.exe: keyfile0.s objects/keyfile0.o 
		c/vlink -bamigahunk -o keyfile0.exe -s objects/keyfile0.o 

# compile modules

objects/puu016.o: puu016.s kpl
		$(compiler)  -Iinclude -Fhunk -o objects/puu016.o puu016.s 

kpl: 	kpl14.s 
		$(compiler)  -Iinclude -Fbin -o kpl kpl14.s 

objects/keyfile0.o: keyfile0.s
		$(compiler)  -Iinclude -Fhunk -o objects/keyfile0.o keyfile0.s

comment_log_file:
		grep -n "\*[[:space:]]" puu016.s > comment.log

copy_files:
		copy hippoplayer.exe work:UAE-HD/Work/
