
compiler = c/os4_cross_compiler_vasmm68k_mot

# asm one don't work on AmigaOS4, we need to use VBCC (vasm)

cpu=68020

pl = pl/Hippo_PS3M3.o		\
	pl/aon4channel.off		\
	pl/okta.off				\
	pl/bpsm.o				\
	pl/bpsm_ahi0.off		\
	pl/DBM0player_v2.16.off	\
	pl/DigiBooster16.off		\
	pl/fc10.o				\
	pl/FC14.off				\
	pl/Hippelcoso.off			\
	pl/Hippelcoso_ahi5.off		\
	pl/Hippelcoso_ahi5_test.o	\
	pl/jamc.o				\
	pl/sampleplayer6.o		\
	pl/SoundMon3.o		\
	pl/tfmx7c.o		

all:	${pl} kpl hippoplayer.exe

# keyfile.exe hippoplayer.exe copy_files

clean:
	delete objects/#?
	delete kpl
	delete #?.exe
	delete pl/(#?.o|#?.off)

# compile programs

hippoplayer.exe: puu016.s objects/puu016.o  
		c/vlink  -bamigahunk -o hippoplayer.exe -s   objects/puu016.o 

keyfile.exe: keyfile0.s objects/keyfile0.o 
		c/vlink -bamigahunk -o keyfile0.exe -s objects/keyfile0.o 

# compile modules

objects/puu016.o: puu016.s kpl
		$(compiler) -m${cpu} -Iinclude -Fvobj -o objects/puu016.o puu016.s 

pl/%.off:	
		echo > $@

pl/%.o:	pl/%.s
		$(compiler) -m${cpu} -Iinclude -Fbin $< -o $@

pl/%.o:	pl/%.S
		$(compiler) -m${cpu} -Iinclude -Fbin $< -o $@

kpl: 	kpl14.s 
		$(compiler) -Iinclude -Fbin -o kpl kpl14.s 

objects/keyfile0.o: keyfile0.s
		$(compiler)  -Iinclude -Fhunk -o objects/keyfile0.o keyfile0.s

copy_files:
		copy hippoplayer.exe work:UAE-HD/Work/hippoplaye