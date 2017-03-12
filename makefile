# asm one don't work on AmigaOS4, we need to use VBCC (vasm)

# tools

compiler = c/os4_cross_compiler_vasmm68k_mot

# supported CPU

cpu=68020

# options

module_options = -Dcommand_line_player=0 \
			-Dtesti=0 \
			-Duse_decrypt=0 \
			-Dhave_cia_timers=0 \
			-Dhardware_poking_enabled=0


test_options = -Dcommand_line_player=1 \
			-Dtesti=1 \
			-Duse_decrypt=0 \
			-Dhave_cia_timers=0 \
			-Dhardware_poking_enabled=0 

# hippo players

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

pl2 = pl2/Hippo_PS3M3.o		

# hippo player test's

tests = tests/kpl.exe 

# How to compile it all

all:	$(tests)  hippoplayer.exe copy_files

clean:
	execute clean_script

# compile programs

hippoplayer.exe: ${pl} ${pl2} kpl puu016.s objects/puu016.o  
		c/vlink  -bamigahunk -o hippoplayer.exe -s   objects/puu016.o 

keyfile.exe: keyfile0.s objects/keyfile0.o 
		c/vlink -bamigahunk -o keyfile0.exe -s objects/keyfile0.o 

# compile modules

objects/puu016.o: ${pl} ${pl2} puu016.s kpl
		$(compiler)  -m${cpu} -Iinclude -Fvobj -o objects/puu016.o puu016.s $(module_options)

pl/%.off:	
		echo > $@

pl/%.o:	pl/%.s
		$(compiler)  -m${cpu} -Iinclude -Fbin $< -o $@ $(module_options)

pl2/%.o:	pl2/%.s
		$(compiler)  -m${cpu} -Iinclude -Fbin $< -o $@ $(module_options)

pl/%.o:	pl/%.S
		$(compiler)  -m${cpu} -Iinclude -Fbin $< -o $@ $(module_options)

kpl: 	kpl14.s 
		$(compiler)  -Iinclude -Fbin -o kpl kpl14.s $(module_options)

# compile tests

tests/kpl.exe: kpl14.s
		$(compiler) $(test_options) -Iinclude -Fvobj -o tests/kpl.o kpl14.s 
		c/vlink  -bamigahunk -o tests/kpl.exe -s  tests/kpl.o

tests/%.exe: pl/%.s	
		$(compiler) $(test_options) -Iinclude -Fvobj  $< -o $@.o
		c/vlink  -bamigahunk -o tests/$@ -s  tests/$@.o

objects/keyfile0.o: keyfile0.s
		$(compiler)  -Iinclude -Fhunk -o objects/keyfile0.o keyfile0.s

# where to copy compiled files

copy_files:
		copy hippoplayer.exe work:UAE-HD/Work/hippoplayer
		copy tests/#?.exe work:UAE-HD/Work/hippoplayer
