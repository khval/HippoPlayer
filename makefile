# asm one don't work on AmigaOS4, we need to use VBCC (vasm)

enable=.enable
disable=.disable

include makefile.cfg

# hippo players

pl = pl/Hippo_PS3M3${enable}		\
	pl/aon4channel${disable}		\
	pl/okta${disable}				\
	pl/bpsm${enable}				\
	pl/bpsm_ahi0${disable}		\
	pl/DBM0player_v2.16${disable}	\
	pl/DigiBooster16${disable}		\
	pl/fc10${enable}				\
	pl/FC14${disable}				\
	pl/Hippelcoso${disable}			\
	pl/Hippelcoso_ahi5${disable}		\
	pl/Hippelcoso_ahi5_test${enable}	\
	pl/jamc${enable}				\
	pl/sampleplayer6${enable}		\
	pl/SoundMon3${enable}		\
	pl/tfmx7c${enable}		

pl2 = pl2/Hippo_PS3M3${enable}		

# hippo player test's

tests = tests/kpl.exe 

# How to compile it all

all:	init ${pl} ${pl2} ${tests} hippoplayer.exe copy_files
	

clean:
		execute clean_script

# compile programs

%.disable:
		@true

%.enable:		%.hunk	%.s
		@echo $< >> hunk_files
		@echo > $@

%.hunk:	%.s
		make -f makefile.modules $@

kpl:
		make -f makefile.modules   kpl

hippoplayer.exe: objects/puu016.o  $(shell cat hunk_files)
		c/vlink  -bamigahunk -o hippoplayer.exe -s   objects/puu016.o 

objects/puu016.o: $(shell cat hunk_files) $(shell cat object_files) puu016.s kpl
		$(compiler)  -m${cpu} -Iinclude -Fvobj -o objects/puu016.o puu016.s $(module_options)

keyfile.exe: keyfile0.s objects/keyfile0.o 
		c/vlink -bamigahunk -o keyfile0.exe -s objects/keyfile0.o 

# compile tests

tests/kpl.exe: kpl14_ahi.s
		$(compiler) $(test_options) -Iinclude -Fvobj -o tests/kpl.o kpl14_ahi.s 
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

init:
		@echo init > t:init
		@delete $(shell list pl/#?.enable lformat pl/%n) $(shell list pl2/#?.enable lformat pl2/%n) t:init >NIL:
		@echo > hunk_files
		@echo > object_files
		@echo > source_files
		@true

.PRECIOUS: %.hunk 