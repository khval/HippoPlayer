;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
*******************************************************************************
*                                HippoPlayer
*******************************************************************************
* Aloitettu 5.2.-94



ver	macro
;	dc.b	"v2.30 (5.8.1996)"
;	dc.b	"v2.31�A (24.8.-96)"
;	dc.b	"v2.31�C (?.?.1996)"
;	dc.b	"v2.35 (23.11.1996)"
;	dc.b	"v2.37 (31.12.1996)"
;	dc.b	"v2.38 (9.2.1997)"
;	dc.b	"v2.40 (29.6.1997)"
;	dc.b	"v2.41 (25.10.1997)"
;	dc.b	"v2.42 (20.12.1997)"
;	dc.b	"v2.44 (16.8.1998)"
;	dc.b	"v2.44 (16.8.1998)"
	dc.b	"v2.45 (10.1.2000)"
	endm	


DEBUG	= 0
BETA	= 0	;* 0: ei beta, 1: public beta, 2: private beta

asm	= 0	;* 1: AsmOnesta ajettava versio

zoom	= 0	;* 1: zoomaava hippo
fprog	= 0 	;* 1: file add progress indicator, ei oikein toimi (kaataa)
floadpr = 1	;* 1: unpacked file load progress indicator
PILA	= 0	;* 1: pikku pila niille joilla on wRECin key muttei 060:aa
TARK	= 0	;* 1: tekstien tarkistus
EFEKTI  = 0	;* 1: efekti volumesliderill�
ANNOY	= 0     ;* 1: Unregistered version tekstej� ymp�riins�

 ifne TARK
 ifeq asm
 printt "Onko CHECKSUMMI oikea? Molemmat!"
 printt "Onko CHECKSUMMI oikea?"
 endc
 endc
 

WINX	= 2	;* X ja Y lis�ykset p��ikkunan grafiikkaan
WINY	= 3



iword	macro
	ror	#8,\1
	endm

ilword	macro
	ror	#8,\1
	swap	\1
	ror	#8,\1
	endm

tlword	macro
	move.b	\1,\2
	ror.l	#8,\2
	move.b	\1,\2
	ror.l	#8,\2
	move.b	\1,\2
	ror.l	#8,\2
	move.b	\1,\2
	ror.l	#8,\2
	endm

tword	macro
	move.b	\1,\2
	ror	#8,\2
	move.b	\1,\2
	ror	#8,\2
	endm

***** Tarkistaa rekister�itymiseen liittyv�t tekstit


check	macro

 ifne TARK
 ifeq asm
	lea	CHECKSTART(pc),a0	
	moveq	#0,d0
	moveq	#0,d1
	moveq	#8,d2
.qghg\1	move.b	(a0)+,d1
	neg.b	d1
	add	d2,d0
	add	d1,d0
	addq	#1,d2
	cmp.b	#$ff,(a0)
	bne.b	.qghg\1
 ifeq BETA
	tst.b	eicheck(a5)
	bne.b	.fghz\1
	sub	textchecksum(a5),d0
	sne	exitmainprogram(a5)
.fghz\1
 endc
 endc
 endc

	endm


 	incdir	include:
	include	exec/exec_lib.i
	include	exec/ports.i
	include	exec/types.i
	include	exec/execbase.i
	include	exec/memory.i
	include	exec/lists.i

	include	graphics/gfxbase.i
	include	graphics/graphics_lib.i
	include	graphics/rastport.i
	include graphics/scale.i

;	include	graphics/rpattr.i

	include	intuition/intuition_lib.i
	include	intuition/intuition.i

	include	dos/dos_lib.i
	include	dos/dosextens.i


	include	rexx/rxslib.i

	include	devices/audio.i
	include	devices/input.i
	include	devices/inputevent.i

	include	workbench/startup.i
	include	workbench/workbench.i
	include	workbench/wb_lib.i

	include	hardware/intbits.i
	include	hardware/cia.i

	include	resources/cia_lib.i
	include	libraries/diskfont_lib.i
	


	include	libraries/powerpacker_lib.i
	include	libraries/reqtools.i
	include	libraries/reqtools_lib.i
	include	libraries/xpk.i
	include	libraries/xpkmaster_lib.i
	include	libraries/playsidbase.i
	include	libraries/playsid_lib.i
	include	libraries/xfdmaster_lib.i
	include	libraries/xfdmaster.i
	include	libraries/screennotify_lib.i
	include	libraries/screennotify.i

	include	devices/ahi.i
	include	devices/ahi_lib.i

	incdir include/
	include	mucro.i
	include	med.i
	include	Guru.i
	include	ps3m.i
use = 0
	include	player61.i

	incdir

	include	kpl_offsets.s

;*******************************************************************************
;*
;* Prefs tiedoston rakenne
;*

prefsversio	=	20	;* Prefs-tiedoston versio
		rsreset
prefs_versio		rs.b	1
prefs_play		rs.b	1
prefs_show		rs.b	1
prefs_tempo		rs.b	1
prefs_tfmxrate		rs.b	1
prefs_s3mmode1		rs.b	1
prefs_s3mmode2		rs.b	1
prefs_s3mmode3		rs.b	1
prefs_ps3mb		rs.b	1
prefs_timeoutmode	rs.b	1
prefs_quadmode		rs.b	1
prefs_quadon		rs.b	1		;* 1: quad oli p��ll�
prefs_ptmix		rs.b	1		;* 0: chip, 1: fast, 2: ps3m
prefs_xpkid		rs.b	1
prefs_fade		rs.b	1
prefs_pri		rs.b	1
prefs_boxsize		rs.b	1
prefs_infoon		rs.b	1
prefs_doubleclick	rs.b	1
prefs_startuponoff	rs.b	1
prefs_hotkey		rs.b	1
prefs_cerr		rs.b	1
prefs_nasty		rs.b	1
prefs_dbf		rs.b	1
prefs_filter		rs.b	1
prefs_vbtimer		rs.b	1
prefs_timeout		rs	1
prefs_s3mrate		rs.l	1
prefs_mainpos1		rs.l	1
prefs_mainpos2		rs.l	1
prefs_prefspos		rs.l	1
prefs_quadpos		rs.l	1
_l216			rs	1
prefs_alarm		rs	1
prefs_moddir		rs.b	150
prefs_prgdir		rs.b	150-1
prefs_stereofactor	rs.b	1
prefs_arclha		rs.b	100
prefs_arczip		rs.b	100
prefs_arclzx		rs.b	100
prefs_pubscreen		rs.b	MAXPUBSCREENNAME+1
prefs_startup		rs.b	120
prefs_fkeys		rs.b	120*10
prefs_textattr		rs.b	ta_SIZEOF-4
prefs_fontname		rs.b	20
prefs_groupmode		rs.b	1
prefs_groupname		rs.b	99
prefs_div		rs.b	1
prefs_early		rs.b	1
prefs_prefix		rs.b	1
prefs_xfd		rs.b	1
_l235			rs.l	1
prefs_infopos2		rs.l	1
prefs_arcdir		rs.b	150
prefs_pattern		rs.b	70
prefs_infosize		rs	1
prefs_ps3msettings	rs.b	1
prefs_prefsivu		rs.b	1
prefs_kokolippu		rs.b	1		;* 0: ikkuna pieni
prefs_samplebufsiz	rs.b	1
prefs_cybercalibration	rs.b 1
prefs_calibrationfile	rs.b	99
prefs_forcerate		rs	1

prefs_ahi_use		rs.b	1
prefs_ahi_muutpois	rs.b	1
prefs_ahi_rate		rs.l	1
prefs_ahi_mastervol	rs	1
prefs_ahi_stereolev	rs	1
prefs_ahi_mode		rs.l	1
prefs_ahi_name		rs.b	44

prefs_autosort		rs.b	1

prefs_samplecyber	rs.b	1
prefs_mpegaqua		rs.b	1
prefs_mpegadiv		rs.b	1
prefs_medmode		rs.b	1
_l262			rs.b	1

prefs_medrate		rs	1


prefs_size		rs.b	0

;*******************************************************************************
;*
;* Scopejen muuttujat
;*

 	rsreset
ns_start	rs.l	1
ns_length	rs	1
ns_loopstart	rs.l	1
ns_replen	rs	1
ns_tempvol2	rs	1
ns_period	rs	1
ns_tempvol	rs	1
ns_size		rs.b	0


;*******************************************************************************
;*
;* "HiP-Port":in rakenne
;*

	STRUCTURE	HippoPort,MP_SIZE
	LONG		hip_private1	;* Private..
	APTR		hip_kplbase	;* Protracker replayer data area
	WORD		hip_reserved0	;* Private..
	BYTE		hip_quit			:* If non-zero, your program should quit
	BYTE		hip_opencount		:* Open count
	BYTE		hip_mainvolume	:* Main volume, 0-64
	BYTE		hip_play			;* If non-zero, HiP is playing
	BYTE		hip_playertype 	;* 33 = Protracker, 49 = PS3M. 

	;*** Protracker ***
	BYTE		hip_reserved2
	APTR		hip_PTch1	* Protracker channel data for ch1
	APTR		hip_PTch2	* ch2
	APTR		hip_PTch3	* ch3
	APTR		hip_PTch4	* ch4

	;*** PS3M ***
	APTR		hip_ps3mleft	;* Buffer for the left side
	APTR		hip_ps3mright	;* Buffer for the right side
	LONG		hip_ps3moffs	;* Playing position
	LONG		hip_ps3mmaxoffs	;* Max value for hip_ps3moffs

	BYTE		hip_PTtrigger1
	BYTE		hip_PTtrigger2
	BYTE		hip_PTtrigger3
	BYTE		hip_PTtrigger4

	APTR		hip_listheader	;* pointer to the listheader of modules
	LONG		hip_playtime	;* time played in secs
	LONG		hip_colordiv	;*
	WORD		hip_ps3mrate	;* ps3m mix rate

	LABEL		HippoPort_SIZEOF 


	;*** PT channel data block
	STRUCTURE	PTch,0
	LONG		PTch_start	;* Start address of sample
	WORD		PTch_length	;* Length of sample in words
	LONG		PTch_loopstart	;* Start address of loop
	WORD		PTch_replen	;* Loop length in words
	WORD		PTch_volume	;* Channel volume
	WORD		PTch_period	;* Channel period
	WORD		PTch_private1	;* Private...
	

;*******************************************************************************
;*
;* Globaalit muuttujat ja ty�alueet
;*

	rsreset
_ExecBase	rs.l	1
_GFXBase	rs.l	1
_IntuiBase	rs.l	1
_DosBase	rs.l	1
_ReqBase	rs.l	1
_WBBase		rs.l	1
_RexxBase	rs.l	1
_ScrNotifyBase	rs.l	1
_DiskFontBase	rs.l	1
_PPBase		rs.l	1
_XPKBase	rs.l	1
_SIDBase	rs.l	1
_MedPlayerBase	rs.l	1
_MedPlayerBase1	rs.l	1
_MedPlayerBase2	rs.l	1
_MedPlayerBase3	rs.l	1
_MlineBase	rs.l	1
_XFDBase	rs.l	1


 ifne DEBUG
output		rs.l	1
 endc

sidlibstore1	rs.l	2		:* pSid kick13 patchin varasto
sidlibstore2	rs.l	2

owntask		rs.l	1
lockhere	rs.l	1		;* currentdir-lock
cli		rs.l	1
segment		rs.l	1	;* Toisiks ekan hunkin segmentti
fileinfoblock	rs.b	260		;* 4:ll� jaollisessa osoitteessa!
fileinfoblock2	rs.b	260		
filecomment	rs.b	80+4	;* tiedoston kommentti
windowbase	rs.l	1		;* p��ohjelma
appwindow	rs.l	1		;* appwindowbase
screenlock	rs.l	1
rastport	rs.l	1		;*
userport	rs.l	1		;*
windowbase2	rs.l	1	;* prefs
rastport2	rs.l	1		;* 
userport2	rs.l	1		;*
rastport3	rs.l	1		;* quadrascope
userport3	rs.l	1		;* 
windowbase3	rs.l	1	;*
fontbase	rs.l	1
topazbase	rs.l	1
notifyhandle	rs.l	1	;* Screennotifylle
windowtop	rs	1	;* ikkunoiden eisysteemialueen yl�reuna
windowright	rs	1
windowleft	rs	1
windowbottom	rs	1
windowtopb	rs	1
gotscreeninfo	rs.b	1
infolag		rs.b	1	;* mit� n�ytet��n infoikkunassa: 0=sample, ~0=about

infotaz		rs.l	1	;* infoikkunan datan osoite

windowtop2	rs	1
windowleft2	rs	1
windowbottom2	rs	1


nilfile		rs.l	1		;* NIL:

keycheckroutine	rs.l	1	;* check_keyfile rutiinin osoite

pen_0		rs.l	1		;* piirtokyn�t
pen_1		rs.l	1
pen_2		rs.l	1
pen_3		rs.l	1

WINSIZX		rs	1		;* p��ikkunan koot
WINSIZY		rs	1

eicheck		rs.b	1
reghippo	rs.b 	1 		;* ensimm�inen hippo hieman sivummalle

req_file	rs.l	1		;* p��requesteri
req_file2	rs.l	1		;* load/save program
req_file3	rs.l	1		;* prefs
kokolippu	rs	1		;* 0: pieni
wkork		rs	1	;* korkeus-vertailu zipwindowille
windowpos	rs	2	;* Ison ikkunan paikka
windowpos2	rs	2	;* Pienen ikkunan paikka
windowpos22	rs	2	;* ja koko
infopos2	rs	2		;* sampleikkunan ja sidinfon paikka

screenaddr	rs.l	1	;* N�yt�n osoite
windowpos_p	rs	2	;* Prefs ikkunan paikka
quadpos		rs	2	;* Quad-ikkunan paikka
wbkorkeus	rs	1	;* Workbench n�yt�n korkeus
wbleveys	rs	1
prefs_prosessi	rs	1	;* ei-0: Prefs-prosessi p��ll�
filereq_prosessi rs	1	;* ei-0: Files-prosessi p��ll�
quad_prosessi	rs	1	;* ...
info_prosessi	rs	1	;* ...
about_moodi	rs.b	1	;* 0: normaali, 1: moduleinfo
filereqmode	rs.b	1	;* onko add vai insert
fileinsert	rs.l	1		;* node jonka j�lkeen insertti
haluttiinuusimodi rs	1	;* new-nappulaa ja play:t� varten
quad_task	rs.l	1	;* Scopen taski
quadon		rs.b	1	;* jos 1: quad oli p��ll�
tapa_quad	rs.b	1	;* scopelle lopetus lippu
scopeflag	rs.b	1		;* ~0: scope p��ll�
infoon		rs.b	1	;* 1: info on

exitmainprogram	rs.b	1	;* <>1: poistu ohjelmasta
startuperror	rs.b	1		;* virhe k�ynnistyksess�
oldchip		rs	1		;* free memille vertailua varten
oldfast		rs	1		;* ...

prefsexit	rs.b	1		* ~0: prefssist� poistuttu
lprgadd		rs.b	1		* ~0: loadprg addaa vanhan per��n (join)
prefsivu	rs	1		* 0..5: sivu prefs-ikkunassa
prefsivugads	rs.l	1		* vastaavien gadgettien alkuosoite

seed		rs.l	1		* randomgeneratorin SEED
freezegads	rs.b	1		* ~0: Mainwindowin gadgetit OFF
hippoporton	rs.b	1		* ~0: hippo portti initattu

ciasaatu	rs.b	1		* 1: saatiin cia timeri
vbsaatu		rs.b	1		* 1: saatiin vb intti

prefs_task	rs.l	1		* prefs-prosessi

prefs_signal	rs.b	1		* prefs-signaali
prefs_signal2	rs.b	1		* prefs-signaali 2
ownsignal1	rs.b	1	* Kappale soinut
ownsignal2	rs.b	1	* positionin p�ivitys
ownsignal3	rs.b	1	* lootan p�ivitys
ownsignal4	rs.b	1	* Sulje ja avaa ikkuna
ownsignal5	rs.b	1	* AudioIO:n signaali
ownsignal6	rs.b	1	* Filereqprosessin signaali
ownsignal7	rs.b	1	* rawkey inputhandlerilta
info_signal	rs.b	1	* about signaali infojen p�ivitykseen
info_signal2	rs.b	1	* about signaali infojen p�ivitykseen

oli_infoa	rs.b	1	* freemodulea ennen inforequn tila (0:eip��ll�)

info_task	rs.l	1	* infoikkunan taski

ciabasea	rs.l	1	* ciaa resource base
ciabaseb	rs.l	1	* ciab
ciabase		rs.l	1	* jompikumpi kumpi on k�yt�ss�
ciaddr		rs.l	1	* ...
timerhi		rs.b	1	* timerin arvo
timerlo		rs.b	1	* ...
whichtimer	rs.b	1	* Kumpi cia timeri
kelattiintaakse	rs.b	1	* <>0: kelattiin taakkepp�in

mousex		rs	1		* hiiren paikka x,y
mousey		rs	1


******* Scopen muuttujia

draw1		rs.l	1
draw2		rs.l	1
ch1		rs.b	ns_size
ch2		rs.b	ns_size
ch3		rs.b	ns_size
ch4		rs.b	ns_size
mtab		rs.l	1
buffer0		rs.l	1
buffer1		rs.l	1
buffer2		rs.l	1
wotta		rs.l	1
deltab1		rs.l	1	
deltab2		rs.l	1	
deltab3		rs.l	1	
deltab4		rs.l	1	
omatrigger	rs.b	1	* kopio kplayerin usertrigist�
		rs.b	1	
multab		rs.b	512

tempexec	rs.l	1

ps3mchannels	rs.l	1	* Osoitin PS3M mixer channel blockeihin

**** Sampleplayerin datat

sampleforcerate		rs	1
sampleforcerate_new 	rs	1
sampleforceratepot_new	rs	1
samplebufsizpot_new	rs.l	1
samplebufsiz_new	rs.b	1
samplebufsiz0		rs.b	1
samplebufsiz		rs.l	1

sampleadd		rs.l	1
samplefollow		rs.l	1
samplepointer		rs.l	1
samplepointer2		rs.l	1
samplestereo		rs.b	1
sampleinit		rs.b	1
sampleformat		rs.b	1
			rs.b	1

****** Prefs asetukset, joita k�sitell��n

mixingrate_new	rs.l	1		* Prefs-uudet arvot kaikille
ps3mb_new	rs.b	1
timeoutmode_new	rs.b	1
s3mmixpot_new	rs	1		* Propgadgettien arvot
tfmxmixpot_new	rs	1
volumeboostpot_new rs	1
stereofactorpot_new rs	1
tfmxmixingrate_new rs	1
lootamoodi_new	rs	1
timeout_new	rs	1
timeoutpot_new	rs	1
tempoflag_new	rs.b	1
playmode_new	rs.b	1
s3mmode1_new	rs.b	1
s3mmode2_new	rs.b	1
s3mmode3_new	rs.b	1
stereofactor_new rs.b	1
div_new		rs.b	1
quadmode_new	rs.b	1
moduledir_new	rs.b	150
prgdir_new	rs.b	150
arcdir_new	rs.b	150
ptmix_new	rs.b	1
xpkid_new	rs.b	1
fade_new	rs.b	1
pri_new		rs.b	1
ps3msettings_new rs.b	1
ps3msettings	rs.b	1

dclick_new	rs.b	1
centname_new	rs.b	1
startuponoff_new rs.b	1
newdir_new	rs.b	1
hotkey_new	rs.b	1
cerr_new	rs.b	1
dbf_new		rs.b	1
nasty_new	rs.b	1
pubscreen_new	rs.b	MAXPUBSCREENNAME+1 ; = 140
arclha_new	rs.b	100
arczip_new	rs.b	100
arclzx_new	rs.b	100
pattern_new	rs.b	70
startup_new	rs.b	120
fkeys_new	rs.b	120*10
pubwork		rs.l	1
xfd_new		rs.b	1
fontname_new	rs.b	20+1

early_new	rs.b	1
prefix_new	rs.b	1
autosort_new	rs.b	1
		rs.b	1

samplecyber_new	rs.b	1
mpegaqua_new	rs.b	1
mpegadiv_new	rs.b	1
medmode_new	rs.b	1
medrate_new	rs	1
medratepot_new	rs	1

alarmpot_new	rs.l	1
alarm_new	rs	1
vbtimer_new	rs.b	1
scopechanged	rs.b	1		* scopea muutettu
contonerr_laskuri rs.b 1		* kuinka monta virheellist� lataus
cybercalibration_new rs.b 1		* yrityst�
calibrationfile_new rs.b 100
newcalibrationfile rs.b	1

prefs_exit	rs.b	1		* Prefs exit-flaggi



slider4oldheight rs	1
slider1old	rs	1
slider4old	rs	1
mainvolume	rs	1		* p��-��nenvoimakkuus
mixirate	rs.l	1		* miksaustaajuus S3M:�lle
textchecksum	rs	1
priority	rs.l	1		* ohjelman prioriteetti
tfmxmixingrate	rs	1		* rate 1-22
s3mmode1	rs.b	1		* prioriteetti / killeri
s3mmode2	rs.b	1	* surround,stereo,mono,real surround,14-bit
s3mmode3	rs.b	1		* Volume boost
stereofactor	rs.b	1		* stereofactor
xfd		rs.b	1		* ~0: k�ytet��n xfdmaster.libb��
ps3mb		rs.b	1
timeoutmode	rs.b	1
quadmode	rs.b	1		* scopemoodi
quadmode2	rs.b	1		
filterstatus	rs.b	1		* filtterin 
modulefilterstate rs.b	1		* ..
ptmix		rs.b	1		* 0: normi ptreplay, 1:mixireplay
xpkid		rs.b	1		* 0: ei xpktunnistusta, 1:joo
fade		rs.b	1		* 0: ei feidausta
boxsize		rs	1		* montako nime� mahtuu fileboksiin
boxsize_new	rs	1
boxsizepot_new	rs	1
boxy		rs	1		* 8-nimisen lootaan y-kokomuutos
boxsize0	rs	1	
boxsize00	rs	1	
boxsizez	rs	1		* rmb + ? zoomausta varten
doubleclick	rs.b	1		* <>0: tiedoston doubleclick-play
tabularasa	rs.b	1		* aloitettiinko tyhjalla modilistalla?
startuponoff	rs.b	1		* <>0: startupsoitto p��ll�
hotkey		rs.b	1		* <>0: hotkeyt p��ll�
contonerr	rs.b	1		* <>0: jatketaan latauserrorin sattuessa
vbtimer		rs.b	1		* ~0: K�ytet��n vb ajastusta	
vbtimeruse	rs.b	1		* ~0: t�m�n hetkinen
groupmode_new	rs.b	1
groupname_new	rs.b	100
infosize_new	rs	1		* module infon koko
infosize	rs	1
infosizepot_new	rs	1

prefixcut	rs.b	1
earlyload	rs.b	1
divdir		rs.b	1
cybercalibration rs.b	1

timeout		rs	1		* moduulin soittoaika

alarm		rs	1		* alarm aika
do_alarm	rs.b	1		* ~0: her�tys! :)

new		rs.b	1		* onko painettu New:i�?
new2		rs.b	1		* onko painettu New:i�?

gfxcard		rs.b 	1		* jos ~0, k�yt�ss� n�ytt�kortti

samplecyber	rs.b	1		* ~0: sampleplayer k�ytt�� cybercalibr.
mpegaqua	rs.b	1		* MPEGA quality
mpegadiv	rs.b	1		* MPEGA freq. division
medmode		rs.b	1		* MED mode
medrate		rs	1		* MED mixing rate


*******

sortbuf		rs.l	1		* sorttaukseen puskuri

lootamoodi	rs	1		* lootan moodi
lootassa	rs	1		* viimeisin tieto lootassa
colordiv	rs.l	1		* colorclock/vbtaajuus
vertfreq	rs	1		* virkistystaajuudet
horizfreq	rs	1


clockconstant	rs.l	1		* Clock Constant PAL/NTSC

pos_nykyinen	rs	1		* moduulin position
pos_maksimi	rs	1		
positionmuutos	rs	1

datestamp1	rs.l	3		 * ajanottoa varten
datestamp2	rs.l	3
aika1		rs.l	1
aika2		rs.l	1
vanhaaika	rs	1
ticktack	rs	1	* vbcounteri
kokonaisaika	rs	2	* pt-moduille laskettu kesto aika, min/sec
				* tai sampleille

markedline	rs	1	* merkitty rivi
modamount	rs	1	* modien m��r�
divideramount	rs	1	* dividereitten m��r� (info window)
chosenmodule	rs	1	* valittu moduuli
firstname	rs	1	* nimi ikkunan ekan nimen numero
firstname2	rs	1	* 
playingmodule	rs	1	* moduuli jota soitetaan

groupmode	rs.b	1

movenode	rs.b	1	* ~0: move p��ll�
nodetomove	rs.l	1	* t�t� nodea siirret��n

chosenmodule2	rs	1
hippoonbox	rs.b	1	* ~0: shownames p�ivitt�� koko n�yt�n
dontmark	rs.b	1	* ei merkata nime� listassa

clickmodule	rs	1	* doubleklikattumodule
clicksecs	rs.l	1	* aika CurrentTime()lt� DoubleClick()ille
clickmicros	rs.l	1

playerbase	rs.l	1	* soittorutiinin base
playertype	rs	1	* pt_????

tempoflag	rs.b	1	* 0: tempo sallittu, ei-0: tempo ei sallitu
songover	rs.b	1	* kappale soinut loppuun
uusikick	rs.b	1	* ~0 jos kickstart 2.0+
win		rs.b 	1	* ~0: ikkuna auki, 0: EI IKKUNAA, hide!



playing		rs.b	1	* 0: ei soiteta, ei-0: soitetaan
playmode	rs.b	1	* kuinka soitetaan listaa
filterstore	rs.b	1	* filtterin tila

keyfilechecked	rs.b	1	* ~0: keyfile tarkistettu

songnumber	rs	1	* modin sis�isen kappaleen numero
maxsongs	rs	1	* maximi songnumber


moduleaddress	rs.l	1	* modin osoite
moduleaddress2	rs.l	1	* modin osoite ladattaessa doublebufferingilla
modulelength	rs.l	1	* modin pituus
modulefilename	rs.l	1	* modin tiedoston nimi
solename	rs.l	1	* osoitin pelkk��n tied.nimeen
kanavatvarattu	rs	1	* 0: ei varattu, ei-0: varattu

;earlymoduleaddress	rs.l	1	*
;earlymodulelength	rs.l	1	*
;earlytfmxsamples	rs.l	1
;earlytfmxsamlen		rs.l	1
;earlylod_tfmx		rs.b	1
;do_early		rs.b	1



oldst		rs.b	1	* 0: pt modi, ~0: old soundtracker modi
sidflag		rs.b	1	* songnumberin muuttamiseen
	rs.b	1

kelausnappi	rs.b	1	* 0: jos ei cia kelausta
kelausvauhti	rs.b	1	* 1: 2x, 2: 4x
do_early	rs.b	1


externalplayers	rs.l	1	* ulkoisen soittorutiininivaskan osoite

external	rs.b	1	* lippu: tarvitaan xplayeri
xtype		rs.b	1	* ladatun replayerin tyyppi
xplayer		rs.l	1	* osote
xlen		rs.l	1	* pakattupituus

ps3msettingsfile rs.l	1	* ps3m settings filen osoite
calibrationaddr	 rs.l	1	* CyberSound 14-bit calibration table

sampleroutines	rs.l	0
aonroutines	rs.l	0
thxroutines	rs.l	0
digiboosterroutines rs.l 0
digiboosterproroutines rs.l 0
hippelcosoroutines rs.l	0
ps3mroutines	rs.l	0
oktaroutines	rs.l	0
bpsmroutines	rs.l	0
fc14routines	rs.l	0
fc10routines	rs.l	0
jamroutines	rs.l	0
p60routines	rs.l	0
tfmxroutines	rs.l	0
tfmx7routines	rs.l	1	* Soittorutiini purettuna (TFMX 7ch)
player60samples	rs.l	1	* P60A:n samplejen osoite
tfmxsamplesaddr	rs.l	1	* TFMX:n samplejen osoite
tfmxsampleslen	rs.l	1	* TFMX:n samplejen pituus
medrelocced	rs.b	1	* ei-0: Med-modi relocatoitu
medtype		rs.b	1	* 0: 1-4, 1: 5-8, 2: 1-64

ps3m_mname	rs.l	1	* ps3m:n informaation v�lityst� varten
ps3m_numchans	rs.l	1
ps3m_mtype	rs.l	1
ps3m_samples	rs.l	1
ps3m_xm_insts	rs.l	1
ps3m_buff1	rs.l	1
ps3m_buff2	rs.l	1
ps3m_mixingperiod rs.l	1
ps3m_playpos	rs.l	1
ps3m_buffSizeMask rs.l	1


ahi_use_new		rs.b	1
ahi_muutpois_new	rs.b	1
ahi_rate_new		rs.l	1
ahi_ratepot_new		rs	1
ahi_mastervol_new	rs	1
ahi_mastervolpot_new	rs	1
ahi_mode_new		rs.l	1
ahi_stereolev_new	rs	1
ahi_stereolevpot_new	rs	1
ahi_name_new		rs.b	44


listheader	rs.b	MLH_SIZE	* tiedostolistan headeri
filelistaddr	rs.l	1		* REQToolsin tiedostolistan osoite

loading		rs.b	1		* ~0: lataus meneill��n
loading2	rs.b	1		* ~0: filejen addaus meneill��n

** InfoWindow kamaa
infosample	rs.l	1		* samplesoittajan v�liaikaisalue
swindowbase	rs.l	1
suserport	rs.l	1
srastport	rs.l	1
ssliderold	rs.l	1
sfirstname	rs	1
sfirstname2	rs	1
riviamount	rs	1
oldswinsiz	rs	1
oldsgadsiz	rs	1
skokonaan	rs.b	1
	rs.b	1

******* LoadDatan muuttujia
lod_a			rs.b	0
lod_address		rs.l	1
lod_length		rs.l	1
lod_filename		rs.l	1
lod_memtype		rs.l	1
lod_start		rs.l	1
lod_len			rs.l	1
lod_filehandle		rs.l	1
lod_error		rs	1
lod_xpkerror		rs	1
lod_xfderror		rs	1
lod_archive		rs.b	1	 * 0: ei archive, <>0: archive
lod_tfmx		rs.b	1
lod_pad			rs.b	1
lod_kommentti		rs.b	1	 * 0: ei oteta kommenttia
lod_xpkfile		rs.b	1	 * <>0: tiedosto oli xpk-pakattu
	rs.b	1			
lod_dirlock		rs.l	1
lod_buf			rs.b	200
lod_b			rs.b	0

newdirectory	rs.b	1
newdirectory2	rs.b	1

prefsdata	rs.b	prefs_size	* Prefs-tiedosto
startup		= prefsdata+prefs_startup
fkeys		= prefsdata+prefs_fkeys
groupname	= prefsdata+prefs_groupname

ahi_rate	= prefsdata+prefs_ahi_rate
ahi_mastervol	= prefsdata+prefs_ahi_mastervol
ahi_stereolev	= prefsdata+prefs_ahi_stereolev
ahi_mode	= prefsdata+prefs_ahi_mode
ahi_name	= prefsdata+prefs_ahi_name
ahi_use		= prefsdata+prefs_ahi_use
ahi_muutpois	= prefsdata+prefs_ahi_muutpois
ahi_use_nyt	rs.b	1
		rs.b	1
autosort	= prefsdata+prefs_autosort

* audio homman muuttujat
acou_deviceerr	rs.l	1
iorequest	rs.b	ioa_SIZEOF
audioport	rs.b	MP_SIZE

* input devicen muuttujat
idopen		rs.l	1
iorequest2	rs.b	IO_SIZE
idmsgport	rs.b	MP_SIZE
intstr		rs.b	IS_SIZE
rawkeyinput	rs	1		* rawkoodi

******* Viestiportti
omaviesti0	rs.l	1		* Porttiin saapunut viesti

hippoport	rs.b	HippoPort_SIZEOF

poptofrontr	rs.l	1		* rutiini esiinpullauttamiseksi
newcommand	rs.l	1		* osoitin uuteen komentoon
appnamebuf	rs.l	1		* appviestin nimien ty�puskuri
*******

********* ARexx
rexxport	rs.b	MP_SIZE
rexxmsg		rs.l	1
rexxon		rs.b	1		* ~0: ARexx aktivoitu!
keycheck	rs.b	1		* keyfile checkki. 0=oikea keyfile
rexxresult	rs.l	1		* argstringi

********

wintitl		rs.b	80
wintitl2	rs.b	80

tfmx_L0000DC	rs.l	1		* TFMX:n dataa
tfmx_L0000E0	rs.l	1
tfmx_L0000E4	rs.l	1
tfmx_L0000E8	rs.l	1
tfmx_L0000EC	rs.l	1
sidheader	rs.b	sidh_sizeof

 
moduledir	= prefsdata+prefs_moddir * modulehakemisto
prgdir		= prefsdata+prefs_prgdir * prghakemisto
arcdir		= prefsdata+prefs_arcdir
arclha		= prefsdata+prefs_arclha * pakkerit
arczip		= prefsdata+prefs_arczip
arclzx		= prefsdata+prefs_arclzx
pattern		= prefsdata+prefs_pattern
pubscreen	= prefsdata+prefs_pubscreen
nastyaudio	= prefsdata+prefs_nasty
doublebuf	= prefsdata+prefs_dbf
calibrationfile = prefsdata+prefs_calibrationfile

tokenizedpattern	rs.b	70*2+2

newpubscreen	rs.b	1
newpubscreen2	rs.b	1


deleteflag	rs.b	1	* filen ja dividerin deletointiin

* teksti: "Registered to "
	
;regtext		rs.b	14-1
;	rs.b	1
keycode		rs.b	1		* 33
keyfile		rs.b	64		* keyfile!

modulename	rs.b	40		* moduulin nimi
		rs.b	4
moduletype	rs.b	40		* tyyppi tekstin�
req_array	rs.b	0		* reqtoolsin muotoiluparametrit
desbuf		rs.b	200		* muotoilupuskuri
desbuf2		rs.b	200		* muotoilupuskuri prefssille
filename	rs.b	108		* tiedoston nimi (reqtools)
filename2	rs.b	108		* Load/Save program-rutiineille
tempdir		rs.b	200		* ReqToolsin hakemistopolku 
probebuffer	rs.b	2048		* tiedoston tutkimispuskuri
randomtable	rs.b	1024		* Taulukko satunnaissoittoon
ptsonglist	rs.b	64		* Protrackerin songlisti
xpkerror	rs.b	82		* XPK:n virhe (max. 80 merkki�)
findpattern	rs.b	30		* find pattern
divider		rs.b	26		* divider

omabitmap	rs.b	bm_SIZEOF-7*4	* 1 bitplanea, ei tilaa muille
omabitmap2	rs.b	bm_SIZEOF-6*4	* 2
omabitmap3	rs.b	bm_SIZEOF-7*4	* 1
omabitmap4	rs.b	bm_SIZEOF-6*4	* 2
omabitmap5	rs.b	bm_SIZEOF-6*4	* 2


ARGVSLOTS	=	16		* max. parametrej�
sv_argvArray	rs.l	ARGVSLOTS	* parametrihommia
sv_argvBuffer	rs.b	256		*

kplbase	rs.b	k_sizeof		* KPlayerin muuttujat (ProTracker)

size_var	rs.b	0

	ifne	size_var&1
	fail
	endc


*********************************************************************************
*
* Playerbasen rakenne
*
	rsreset
p_init		rs.l	1
p_ciaroutine	rs.l	0
p_play		rs.l	1
p_vblankroutine	rs.l	1
p_end		rs.l	1
p_stop		rs.l	1
p_cont		rs.l	1
p_volume	rs.l	1
p_song		rs.l	1
p_eteen		rs.l	1
p_taakse	rs.l	1
p_ahiupdate	rs.l	1
p_liput		rs	1	* ominaisuudet
p_name		rs.l	1

* Playerit
	rsset	33
pt_prot		rs.b	1
pt_sid		rs.b	1
pt_delta2	rs.b	1
pt_musicass	rs.b	1
pt_fred		rs.b	1
pt_sonicarr	rs.b	1
pt_sidmon1	rs.b	1
pt_med		rs.b	1
pt_markii	rs.b	1
pt_mon		rs.b	1
pt_dw		rs.b	1
pt_hippel	rs.b	1
pt_mline	rs.b	1

	rsset	49		* Ulkoiset
pt_multi	rs.b	1	* PS3M (mod,ftm,mtm,s3m)
pt_tfmx		rs.b	1
pt_tfmx7	rs.b	1
pt_jamcracker	rs.b	1
pt_future10	rs.b	1
pt_future14	rs.b	1
pt_soundmon2	rs.b	1
pt_soundmon3	rs.b	1
pt_oktalyzer	rs.b	1
pt_player	rs.b	1
pt_hippelcoso	rs.b	1
pt_digibooster	rs.b	1
pt_thx		rs.b	1
pt_sample	rs.b	1
pt_aon		rs.b	1
pt_digiboosterpro rs.b	1

xpl_versio	=	20	* playergroupin versio
xpl_offs	=	49


*********************************************************************************
*
* Tiedostolistan yhden yksik�n rakenne
*

	rsreset
		rs.b	MLH_SIZE		* Minimal List Header
l_nameaddr	rs.l	1			* osoitin pelkk��n tied.nimeen
l_rplay		rs.b	1			* randomplay-lippu: ~0=soitettu
l_filename	rs.b	0			* tied.nimi ja polku alkaa t�st�
		rs.b	30			* turvallisuustekij�
l_size		rs.b	0



*********************************************************************************
*
* Soittomoodit
*

pm_repeat	=	1
pm_through	=	2
pm_repeatmodule	=	3
pm_module	=	4
pm_random	=	5
pm_max		=	5


*********************************************************************************
*
* Soittorutiinin ominaisuusliput
*

pb_cont		=	0
pb_stop		=	1
pb_song		=	2
pb_kelauseteen	=	3
pb_kelaustaakse =	4
pb_volume	=	5
pb_ciakelaus	=	6		* 2x = lmb, 4x = rmb
pb_ciakelaus2	=	7		* pattern = lmb, 2x = rmb
pb_end		=	14
pb_poslen	=	15
pb_scope	=	13
pb_ahi		=	12
pf_cont		=	1<<pb_cont
pf_stop		=	1<<pb_stop
pf_song		=	1<<pb_song
pf_kelauseteen	=	1<<pb_kelauseteen
pf_kelaustaakse	=	1<<pb_kelaustaakse
pf_kelaus	=	pf_kelauseteen!pf_kelaustaakse
pf_volume	=	1<<pb_volume
pf_ciakelaus	=	1<<pb_ciakelaus!1<<pb_kelauseteen
pf_ciakelaus2	=	1<<pb_ciakelaus2!1<<pb_kelauseteen
pf_end		=	1<<pb_end
pf_poslen	=	1<<pb_poslen
pf_scope	=	1<<pb_scope
pf_ahi		=	1<<pb_ahi


*********************************************************************************
*
* PS3M:n moodit
*

sm_surround	=	1
sm_stereo	=	2
sm_mono		=	3
sm_real		=	4
sm_stereo14	=	5


*********************************************************************************
*
* P��- ja prefsikkunan liput
*

wflags set WFLG_ACTIVATE!WFLG_DRAGBAR!WFLG_CLOSEGADGET!WFLG_DEPTHGADGET
wflags set wflags!WFLG_SMART_REFRESH!WFLG_RMBTRAP
idcmpflags set IDCMP_GADGETUP!IDCMP_MOUSEBUTTONS!IDCMP_CLOSEWINDOW
idcmpflags set idcmpflags!IDCMP_MOUSEMOVE!IDCMP_RAWKEY

wflags2	set WFLG_ACTIVATE!WFLG_DRAGBAR!WFLG_CLOSEGADGET!WFLG_DEPTHGADGET
wflags2 set wflags2!WFLG_SMART_REFRESH!WFLG_RMBTRAP
idcmpflags2 set IDCMP_GADGETUP!IDCMP_CLOSEWINDOW!IDCMP_MOUSEMOVE
idcmpflags2 set idcmpflags2!IDCMP_MOUSEBUTTONS!IDCMP_RAWKEY

*********************************************************************************
*
* Aloituskoodi. Komentoriviparametrit, uusi prosessi, WB viesti.
*

 ifeq asm


	section	detach,code_p

progstart
	lea	var_b,a5
	move.l	a0,d6
	move.l	d0,d7


	move.l	4.w,a6
	move.l	a6,(a5)
	lea	dosname,a1
	lob	OldOpenLibrary
	move.l	d0,a4
	move.l	d0,_DosBase(a5)

	sub.l	a1,a1
	lob	FindTask
	move.l	d0,a3

	moveq	#0,d5
	tst.l	pr_CLI(a3)	* ajettiinko WB:st�
	bne.b	.nowb
	lea	pr_MsgPort(a3),a0
	lob	WaitPort
	lea	pr_MsgPort(a3),a0
	lob	GetMsg
	move.l	d0,d5
	move.l	d0,a0
	move.l	sm_ArgList(a0),d0	* nykyisen hakemiston lukko
	beq.b	.waswb			* workbenchilt�
	move.l	d0,a0
	move.l	(a0),lockhere(a5)
	bra.b	.waswb
.nowb	
	move.l	pr_CurrentDir(a3),lockhere(a5) * nykyinen hakemisto CLI:lt�

	bsr.w	CLIparms

.waswb	
	move.l	(a5),a6
	lea	portname,a1		* joko oli yksi HiP??
	lob	FindPort
	tst.l	d0
	bne.b	.poptofront

	move.l	a4,a6			* hankitaan kopio lukosta
	move.l	lockhere(a5),d1
	lob	DupLock
	move.l	d0,lockhere(a5)

	move.l	#procname,d1
	moveq	#0,d2			* prioriteetti
	lea	progstart-4(pc),a0
	move.l	(a0),d3
	move.l	d3,segment(a5)		* seuraavan hunkin pointteri
	clr.l	(a0)
;	move.l	#4000,d4		* stacksize
	move.l	#5000,d4		* stacksize
	move.l	a4,a6
	lob	CreateProc

.eien	move.l	(a5),a6			* vastataan WB:n viestiin
	tst.l	d5
	beq.b	.nomsg
	lob	Forbid
	move.l	d5,a1
	lob	ReplyMsg
.nomsg
	moveq	#0,d0
	rts

.poptofront
	tst.l	sv_argvArray+4(a5)	* oliko parametrej�?
	bne.b	.huh			* jos ei, pullautetaan hip!

	move.l	d0,a0
	move.l	poptofrontr-hippoport(a0),a0	* pullautusrutiini
	jsr	(a0)
	bra.b	.eien

* Oli! L�hetet��n hipille!
.huh
	move.l	d0,a3			* p��ll�olevan hipin portti

	sub.l	a1,a1
	lore	Exec,FindTask
	move.l	d0,owntask(a5)

	jsr	createport0		* luodaan oma portti!

	lea	desbuf(a5),a0		* portti desbufiin
	NEWLIST	a0

	move.l	a3,a0			* kohdeportti
	lea	desbuf(a5),a1		* viesti

	pushpea	sv_argvArray(a5),MN_LENGTH(a1) * uudet parametrit viestiin
	move.l	#"K-P!",MN_LENGTH+4(a1) * tunnistin!

	pushpea	hippoport(a5),MN_REPLYPORT(a1)	* t�h�n porttiin vastaus

	lob	PutMsg

	lea	hippoport(a5),a0	* odotellaan vastausta
	lob	WaitPort

	jsr	deleteport0

	bra.b	.eien


CLIparms
;=======================================================================
;====== CLI Startup Code ===============================================
;=======================================================================
;       d0  process CLI BPTR (passed in), then temporary
;       d2  dos command length (passed in)
;       d3  argument count
;       a0  temporary
;       a1  argv buffer
;       a2  dos command buffer (passed in)
;       a3  argv array
*       a4  Task (passed in)
*       a5  SVar structure if not QARG (passed in)
*       a6  AbsExecBase (passed in)
*       sp  WBenchMsg (still 0), sVar or 0, then RetAddr (passed in)
*       sp  argc, argv, WBenchMsg, sVar or 0,RetAddr (at bra domain)

	move.l	172(a3),d0			* pr_CLI
	move.l	d7,d2
	move.l	d6,a2

        ;------ find command name
                lsl.l   #2,d0           ; pr_CLI bcpl pointer conversion
                move.l  d0,a0
                move.l  cli_CommandName(a0),d0
                lsl.l   #2,d0           ; bcpl pointer conversion

                ;-- start argv array
                lea     sv_argvBuffer(a5),a1
                lea     sv_argvArray(a5),a3

                ;-- copy command name
                move.l  d0,a0
                moveq.l #0,d0
                move.b  (a0)+,d0        ; size of command name
                clr.b   0(a0,d0.l)      ; terminate the command name
                move.l  a0,(a3)+
                moveq   #1,d3           ; start counting arguments

        ;------ null terminate the arguments, eat trailing control characters
                lea     0(a2,d2.l),a0
stripjunk:
                cmp.b   #' ',-(a0)
                dbhi    d2,stripjunk

                clr.b   1(a0)

        ;------ start gathering arguments into buffer
newarg:
                ;-- skip spaces
                move.b  (a2)+,d1
                beq.s   parmExit
                cmp.b   #' ',d1
                beq.s   newarg
                cmp.b   #9,d1           ; tab
                beq.s   newarg

                ;-- check for argument count verflow
                cmp.w   #ARGVSLOTS-1,d3
                beq.s   parmExit

                ;-- push address of the next parameter
                move.l  a1,(a3)+
                addq.w  #1,d3

                ;-- process quotes
                cmp.b   #'"',d1
                beq.s   doquote

                ;-- copy the parameter in
                move.b  d1,(a1)+

nextchar:
                ;------ null termination check
                move.b  (a2)+,d1
                beq.s   parmExit
                cmp.b   #' ',d1
                beq.s   endarg

                move.b  d1,(a1)+
                bra.s   nextchar

endarg:
                clr.b   (a1)+
                bra.s   newarg

doquote:
        ;------ process quoted strings
                move.b  (a2)+,d1
                beq.s   parmExit
                cmp.b   #'"',d1
                beq.s   endarg

                ;-- '*' is the BCPL escape character
                cmp.b   #'*',d1
                bne.s   addquotechar

                move.b  (a2)+,d1
                move.b  d1,d2
                and.b   #$df,d2         ;d2 is temp toupper'd d1

                cmp.b   #'N',d2         ;check for dos newline char
                bne.s   checkEscape

                ;--     got a *N -- turn into a newline
                moveq   #10,d1
                bra.s   addquotechar

checkEscape:
                cmp.b   #'E',d2
                bne.s   addquotechar

                ;--     got a *E -- turn into a escape
                moveq   #27,d1

addquotechar:
                move.b  d1,(a1)+
                bra.s   doquote

parmExit:
        ;------ all done -- null terminate the arguments
                clr.b   (a1)
                clr.l   (a3)

	rts



 endc
 

*********************************************************************************
*
* P��ohjelma
*


	section	refridgerator,code

* Segmentit uusille prosesseille. 4:ll� jaollisissa osoitteissa.

main0	jmp	main(pc)

	dc.l	16
filereq_segment
	dc.l	0
	jmp	filereq_code(pc)

	dc.l	16
prefs_segment
	dc.l	0
	jmp	prefs_code(pc)

	dc.l	16
info_segment
	dc.l	0
;	jmp	info_code(pc)
	jmp	info_code

	dc	0 * pad


	dc.l	16
quad_segment
	dc.l	0
	jmp	quad_code

;	dc	0	* pad



intuiname	dc.b	"intuition.library",0
gfxname		dc.b	"graphics.library",0
dosname		dc.b	"dos.library",0
reqname		dc.b	"reqtools.library",0
wbname		dc.b	"workbench.library",0
diskfontname	dc.b	"diskfont.library",0
rexxname	dc.b	"rexxsyslib.library",0
scrnotifyname	dc.b	"screennotify.library",0
idname		dc.b	"input.device",0
nilname		dc.b	"NIL:",0
portname	dc.b	"HiP-Port",0
rmname		dc.b	"RexxMaster",0
fileprocname	dc.b	"HiP-Filereq",0
prefsprocname	dc.b	"HiP-Prefs",0
infoprocname	dc.b	"HiP-Info",0



CHECKSTART
CHECKSUM	=	43647

procname	
reqtitle
windowname1
	dc.b	"HippoPlayer",0

about_tt
 
 dc.b "This program is registered to          ",10,3
 dc.b "%39s",10,3
 dc.b "���������������������������������������",10,3
 dc.b " List has %5ld files,  %5ld dividers ",10,3
 dc.b 0


scrtit	dc.b	"HippoPlayer - Copyright � 1994-2000 K-P Koljonen",0
	dc.b	"$VER: "
banner_t
	dc.b	"HippoPlayer "
	ver
	dc.b	10,"Programmed by K-P Koljonen",0

regtext_t dc.b	"Registered to",0
no_one	 dc.b	"   no-one",0


about_t
 dc.b "���������������������������������������",10,3
 dc.b "���  HippoPlayer v2.45  (10.1.2000) ���",10,3
 dc.b "��          by K-P Koljonen          ��",10,3
 dc.b "���       Hippopotamus Design       ���",10,3
 dc.b "���������������������������������������",10,3

about_t1
 dc.b "    This program is not registered!    ",10,3
 dc.b "You should register to support quality ",10,3
 dc.b "    software and to reward the poor    ",10,3
 dc.b "       author from his hard work.      ",10,3
  
 dc.b "���������������������������������������",10,3
 dc.b " HippoPlayer can be freely distributed",10,3
 dc.b " as long as all the files are included",10,3
 dc.b "   unaltered. Not for commercial use",10,3
 dc.b " without a permission from the author.",10,3
 dc.b " Copyright � 1994-2000 by K-P Koljonen",10,3
 dc.b "           *** SHAREWARE ***",10,3
 dc.b "���������������������������������������",10,3
 dc.b "Snail mail: Kari-Pekka Koljonen",10,3
 dc.b "            Torikatu 31",10,3
 dc.b "            FIN-40900 S�yn�tsalo",10,3
 dc.b "            Finland",10,3
 dc.b 10,3
 dc.b "E-mail:     kpk@cc.tut.fi",10,3
 dc.b "            k-p@s2.org",10,3
 dc.b 10,3
 dc.b "WWW:        www.students.tut.fi/~kpk",10,3
 dc.b "IRC:        K-P",10,3,10,3
 dc.b "���������������������������������������",10,3
 dc.b "    Hippopothamos the river-horse",10,3
 dc.b "    Hippopotamus  amphibius:   a  large",10,3
 dc.b "herbivorous   mammal,  having  a  thick",10,3
 dc.b "hairless  body, short legs, and a large",10,3
 dc.b "head and muzzle.",10,3
 dc.b "    Hippopotami  live in the rivers and",10,3
 dc.b "lakes  of  Africa.  A hippo weighs 2500",10,3
 dc.b "kilos, is 140-160 cm high and 4 m long.",10,3
 dc.b "Hippos  form  herds  of 30 individuals.",10,3
 dc.b "They  are  good swimmers and divers and",10,3
 dc.b "can  stay  under water for six minutes.",10,3
 dc.b "In  the  daytime they lie on the shores",10,3
 dc.b "of  small  islands  or rest in water so",10,3
 dc.b "that  only  their eyes and nostrils can",10,3
 dc.b "be  seen.   With  the  fall of darkness",10,3
 dc.b "they get up from the water and graze on",10,3
 dc.b "the   riverside   walking   along  well",10,3
 dc.b "trampled  paths.   On  a single night a",10,3
 dc.b "hippo   eats   60   kilos   of   grass,",10,3
 dc.b "waterplants and fruit.",10,3
 dc.b 0
 dc.b $ff
 even


 ifne DEBUG
PRINTOUT
	pushm	d0-d3/a0/a1/a5/a6
	lea	var_b,a5
	move.l	32+4(sp),a0
	move.l	output(a5),d1
	beq.b	.x
	moveq	#0,d3
	move.l	a0,d2
.p	addq	#1,d3
	tst.b	(a0)+
	bne.b	.p
 	lore	Dos,Write
.x	popm	d0-d3/a0/a1/a5/a6
	move.l	(sp)+,(sp)
	rts
 endc

DEBU	macro
	ifne	DEBUG
	pea	\1
	jsr	PRINTOUT
	endc
	endm


 ifne asm
flash	
.p	move	$dff006,$dff180
	btst	#6,$bfe001
	bne.b	.p
	rts
 endc


 ifne DEBUG
PAH1	dc.b	"Loa",10,0
PAH2	dc.b	"TUt",10,0
 even
 endc

main
	lea	var_b,a5
	move.l	4.w,a6
	move.l	a6,(a5)
	move.l	a6,exeksi

	sub.l	a1,a1
	lob	FindTask
	move.l	d0,owntask(a5)


	not.l	idopen(a5)		* -1 = input.devide ei avattu

;	move	#0,pen_0+2(a5)		* kick2.0+ v�rit
	clr	pen_0+2(a5)
	move	#1,pen_1+2(a5)
	move	#2,pen_2+2(a5)
	move	#3,pen_3+2(a5)
	move.b	#33,keycode(a5)		* keycode

	pushpea	poptofront(pc),poptofrontr(a5)

	move	#264,WINSIZX(a5)
	move	#136,WINSIZY(a5)
	move	WINSIZX(a5),wsizex
	move	WINSIZY(a5),wsizey


	cmp	#34,LIB_VERSION(a6)		* v�rit kickstartin mukaan
	ble.b	.vanha
	st	uusikick(a5)		* Uusi kickstart

	lea	colors,a0
	move	#$0301,d0
;	moveq	#$0001,d0
	move	d0,(a0)			* Ikkunoiden v�rit sen mukaan
	move	d0,colors2-colors(a0)
	move	d0,colors3-colors(a0)



	lea	winstruc,a0		* Ikkunat avautuu publiscreeneille
	bsr.b	.boob
	lea	winstruc2-winstruc(a0),a0
	bsr.b	.boob
	lea	winstruc3-winstruc2(a0),a0
	bsr.b	.boob
	lea	winlistsel-winstruc3(a0),a0
	bsr.b	.boob
	lea	swinstruc-winlistsel(a0),a0
	bsr.b	.boob
	bra.b	.ohib

.boob	move	#PUBLICSCREEN,nw_Type(a0)
	or.l	#WFLG_NW_EXTENDED,nw_Flags(a0)
	rts

.ohib
	move	WINSIZX(a5),windowpos22(a5)	* Pienen koko ZipWindowille
	move	#11,windowpos22+2(a5)
	or.l	#IDCMP_CHANGEWINDOW,idcmpmw	

.vanha



 ifeq asm				* uusi nykyinen hakemisto
	move.l	lockhere(a5),d1
	lore	Dos,CurrentDir
 endc

 ifne asm
	lea	dosname(pc),a1
	lore	Exec,OldOpenLibrary
	move.l	d0,_DosBase(a5)
 endc

	lea	intuiname(pc),a1
	lore	Exec,OldOpenLibrary
	move.l	d0,_IntuiBase(a5)

	tst.b	uusikick(a5)
	beq.b	.olld
	lea	wbname(pc),a1
	lob	OldOpenLibrary
	move.l	d0,_WBBase(a5)
	lea	diskfontname(pc),a1
	lob	OldOpenLibrary
	move.l	d0,_DiskFontBase(a5)
	lea	scrnotifyname(pc),a1
	lob	OldOpenLibrary
	move.l	d0,_ScrNotifyBase(a5)
.olld

	lea	rmname(pc),a1		* Onko RexxMast p��ll�?
	lob	FindTask
	tst.l	d0
	beq.b	.norexx
	lea	rexxname(pc),a1		* jos on, avataan rexxsyslib
	lob	OldOpenLibrary
	move.l	d0,_RexxBase(a5)
	sne	rexxon(a5)		* Lippu
.norexx

	lea 	gfxname(pc),a1		
	lob	OldOpenLibrary
	move.l	d0,_GFXBase(a5)

	pushpea	nilname(pc),d1
	move.l	#MODE_OLDFILE,d2
	lore	Dos,Open
	move.l	d0,nilfile(a5)

 ifne DEBUG
	move.l	#.bmb,d1
	move.l	#MODE_NEWFILE,d2
	lob	Open
	move.l	d0,output(a5)
	bra.b	.tr
.bmb	dc.b	"CON:0/0/300/150/HiP debug window",0
 even
.tr
 endc

	lea	cianame,a1
	push	a1
	move.b	#'a',3(a1)
	moveq	#0,d0
	lore	Exec,OpenResource
	move.l	d0,ciabasea(a5)
	pop	a1
	move.b	#'b',3(a1)
	moveq	#0,d0
	lob	OpenResource
	move.l	d0,ciabaseb(a5)



*** Multab scopeille
	lea	multab(a5),a0
	moveq	#0,d0
.mu	move	d0,(a0)+
	add	#40,d0
	cmp	#40*256,d0
	bne.b	.mu



	lea	text_attr,a0	* t�ss� vaiheessa tavaalinen topaz.8
	lore	GFX,OpenFont
	move.l	d0,topazbase(a5)


	pushm	all
	bsr.w	loadprefs
	bsr.w	loadps3msettings
	bsr.w	loadcybersoundcalibration
	popm	all
	bsr.w	setboxy

	tst	boxsize(a5)		* jos alkukoko 0 niin laitetaan zoomiks
	bne.b	.nzo			* 8
	move	#8,boxsizez(a5)	
.nzo

* fontti

	tst.b	uusikick(a5)
	bne.b	.poh


.qer	lea	text_attr,a0	* vanha kick (sama fontti kun yll�)
	move.l	#topaz,(a0)+
	move	#8,(a0)+
	clr	(a0)
	move.l	topazbase(a5),fontbase(a5)

	bra.b	.koh

.poh

	lea	text_attr,a0	* nyt jo muutettu prefssien mukaan
	tst.l	_DiskFontBase(a5)	* onko libbi�?
	beq.b	.qer


	lore	DiskFont,OpenDiskFont
	move.l	d0,fontbase(a5)
	beq.b	.qer		* error?

.koh



	bsr.w	createport0
	tst.b	rexxon(a5)
	beq.b	.nor1
	bsr.w	createrexxport
.nor1



	bsr.w	getsignal
	move.b	d0,ownsignal1(a5)
;	bmi.w	exit
	bsr.w	getsignal
	move.b	d0,ownsignal2(a5)
;	bmi.w	exit
	bsr.w	getsignal
	move.b	d0,ownsignal3(a5)
;	bmi.w	exit
	bsr.w	getsignal
	move.b	d0,ownsignal4(a5)
;	bmi.w	exit
	bsr.w	getsignal
	move.b	d0,ownsignal5(a5)
;	bmi.w	exit
	bsr.w	getsignal
	move.b	d0,ownsignal6(a5)
;	bmi.w	exit
	bsr.w	getsignal
	move.b	d0,ownsignal7(a5)
;	bmi.w	exit


	lea	sivu0,a0		* Kaikkia pageja 3pix yl�sp�in!
	bsr.b	.hum
	lea	sivu1-sivu0(a0),a0
	bsr.b	.hum
	lea	sivu2-sivu1(a0),a0
	bsr.b	.hum
	lea	sivu3-sivu2(a0),a0
	bsr.b	.hum
	lea	sivu4-sivu3(a0),a0
	bsr.b	.hum
	lea	sivu5-sivu4(a0),a0
	bsr.b	.hum
	lea	sivu6-sivu5(a0),a0
	bsr.b	.hum
	bra.b	.him
.hum
	move.l	a0,a1
.lop0	subq	#3,6(a1)
	tst.l	(a1)
	beq.b	.e0
	move.l	(a1),a1
	bra.b	.lop0
.e0	rts

.him

	move.l	_IntuiBase(a5),a6



	moveq	#1,d0
	lea	gadgets,a1
	bsr.b	.num

** Prefs
	moveq	#1,d0
	lea	gadgets2-gadgets(a1),a1
	bsr.b	.num

	moveq	#20,d0
	lea	sivu0-gadgets2(a1),a1
	bsr.b	.num
	moveq	#20,d0
	lea	sivu1-sivu0(a1),a1
	bsr.b	.num
	moveq	#20,d0
	lea	sivu2-sivu1(a1),a1
	bsr.b	.num
	moveq	#20,d0
	lea	sivu3-sivu2(a1),a1
	bsr.b	.num
	moveq	#20,d0
	lea	sivu4-sivu3(a1),a1
	bsr.b	.num
	moveq	#20,d0
	lea	sivu5-sivu4(a1),a1
	bsr.b	.num
	moveq	#20,d0
	lea	sivu6-sivu5(a1),a1
	bsr.b	.num

	bra.b	.eer2


.num
* Numeroidaan gadgetit
	move.l	a1,a0

.er	bsr.b	.gadu
	move.l	(a0),d1
	beq.b	.eer
	move.l	d1,a0
	addq	#1,d0
	bra.b	.er
.eer	rts


.gadu	move	d0,gg_GadgetID(a0)
	tst.b	uusikick(a5)
	beq.b	.nobo1
	cmp	#GTYP_PROPGADGET,gg_GadgetType(a0)	* vain kick2.0+
	bne.b	.nobo1
	or	#GFLG_GADGHNONE,gg_Flags(a0)
.nobo1	tst.l	gg_GadgetText(a0)
	beq.b	.nt2
	move.l	gg_GadgetText(a0),a2	* IntuiText
	move.l	#text_attr,it_ITextFont(a2)	* fontti
	tst.l	it_NextText(a2)
	beq.b	.nt2
	move.l	it_NextText(a2),a2
	move.l	#text_attr,it_ITextFont(a2)	* fontti
.nt2	rts

.eer2






	tst.b	uusikick(a5)
	beq.w	.ropp

** kick 2.0+ asetuksia


	lea	slider4,a0			* filebox-slideriin image
	move.l	#slimage,gg_GadgetRender(a0)
	move.l	gg_SpecialInfo(a0),a1
	and	#~AUTOKNOB,pi_Flags(a1)

	lea	gAD1-slider4(a0),a0		* moduleinfo-slideriin image
	move.l	#slimage2,gg_GadgetRender(a0)
	move.l	gg_SpecialInfo(a0),a1
	and	#~AUTOKNOB,pi_Flags(a1)


** s��det��n propgadgetteja

	lea	kelloke+gg_Height,a0
	lea	gg_Width-gg_Height(a0),a1
	subq	#3,(a0)			* gg_Height
	subq	#1,(a1)			* gg_Width
	subq	#3,kelloke2-kelloke(a0)
	subq	#1,kelloke2-kelloke(a1)

	subq	#3,meloni-kelloke(a0)
	subq	#1,meloni-kelloke(a1)
	subq	#3,eskimO-kelloke(a0)
	subq	#1,eskimO-kelloke(a1)

	subq	#3,pslider2-kelloke(a0)
	subq	#1,pslider2-kelloke(a1)
	subq	#3,nAMISKA5-kelloke(a0)
	subq	#1,nAMISKA5-kelloke(a1)
	subq	#3,sIPULI-kelloke(a0)
	subq	#1,sIPULI-kelloke(a1)
	subq	#3,sIPULI2-kelloke(a0)
	subq	#1,sIPULI2-kelloke(a1)

	subq	#3,pslider1-kelloke(a0)
	subq	#1,pslider1-kelloke(a1)
	subq	#3,juusto-kelloke(a0)
	subq	#1,juusto-kelloke(a1)
	subq	#3,juust0-kelloke(a0)
	subq	#1,juust0-kelloke(a1)

	subq	#3,slider1-kelloke(a0)
	subq	#1,slider1-kelloke(a1)

	subq	#3,ahiG4-kelloke(a0)
	subq	#1,ahiG4-kelloke(a1)
	subq	#3,ahiG5-kelloke(a0)
	subq	#1,ahiG5-kelloke(a1)
	subq	#3,ahiG6-kelloke(a0)
	subq	#1,ahiG6-kelloke(a1)


.nova0



	move.l	(a5),a0
	cmp	#37,LIB_VERSION(a0)
	blo.b	.faef
	
	move	#GFLG_TABCYCLE,d0	* string-gadgetit cyclattaviks tabilla
	lea	gg_Flags+ack2,a0
	or	d0,(a0)
	or	d0,ack3-ack2(a0)
	or	d0,ack4-ack2(a0)
	or	d0,DuU0-ack2(a0)

.faef


** s��det��n slidereit� edelleen

	lea	slider1,a0
	bsr.b	.rop
	lea	slider4-slider1(a0),a0
	bsr.b	.rop

	lea	gAD1-slider4(a0),a0
	bsr.b	.rop

	lea	pslider1-gAD1(a0),a0
	bsr.b	.rop
	lea	pslider2-pslider1(a0),a0
	bsr.b	.rop
	lea	juusto-pslider2(a0),a0
	bsr.b	.rop
	lea	juust0-juusto(a0),a0
	bsr.b	.rop
	lea	meloni-juust0(a0),a0
	bsr.b	.rop
	lea	eskimO-meloni(a0),a0
	bsr.b	.rop
	lea	kelloke-eskimO(a0),a0
	bsr.b	.rop
	lea	kelloke2-kelloke(a0),a0
	bsr.b	.rop
	lea	sIPULI-kelloke2(a0),a0
	bsr.b	.rop
	lea	sIPULI2-sIPULI(a0),a0
	bsr.b	.rop
	lea	ahiG4-sIPULI2(a0),a0
	bsr.b	.rop
	lea	ahiG5-ahiG4(a0),a0
	bsr.b	.rop
	lea	ahiG6-ahiG5(a0),a0
	bsr.b	.rop
	lea	nAMISKA5-ahiG6(a0),a0
	bsr.b	.rop

	bra.b	.ropp


.rop
	move.l	gg_SpecialInfo(a0),a1

	moveq	#AUTOKNOB,d0		* kick1.3: vanhat autoknobit
	tst.b	uusikick(a5)
	beq.b	.nova
	moveq	#PROPNEWLOOK!PROPBORDERLESS,d0	* kick2.0+, newlook borderless

	addq	#1,gg_TopEdge(a0)
.nova	
	or	d0,pi_Flags(a1)
	rts
.ropp


	addq	#1,gg_TopEdge+juust0
	addq	#1,gg_LeftEdge+slider4



	move	#-1,chosenmodule2(a5)

	bset	#1,$bfe001
	sne	filterstore(a5)			* filtterin tila talteen
	st	modulefilterstate(a5)

	lea	listheader(a5),a0		* Uusi lista
	NEWLIST	a0

	bsr.w	loadkeyfile		* ladataan key-file


******* Vanha kick: otsikkopalkin ja WB-nayton koko
	tst.b	uusikick(a5)
	bne.w	.newkick


	moveq	#AUTOKNOB,d0		* kick1.3: vanhat autoknobit
	lea	slider1s,a0
	or	d0,(a0)
	or	d0,slider4s-slider1s(a0)
	or	d0,pslider1s-slider1s(a0)
	or	d0,pslider2s-slider1s(a0)
	or	d0,juustos-slider1s(a0)
	or	d0,juust0s-slider1s(a0)
	or	d0,melonis-slider1s(a0)
	or	d0,kellokes-slider1s(a0)
	or	d0,kelloke2s-slider1s(a0)
	or	d0,eskimOs-slider1s(a0)
	or	d0,gAD1s-slider1s(a0)
	or	d0,sIPULIs-slider1s(a0)
	or	d0,sIPULI2s-slider1s(a0)
	or	d0,ahiG4s-slider1s(a0)
	or	d0,ahiG5s-slider1s(a0)
	or	d0,ahiG6s-slider1s(a0)


** 3 pixeli� korkeempi infowindowin slideri
;	addq	#3,gg_Height+gAD1

* kick1.3 v�rit
;	move	#0,pen_0+2(a5)	
	clr	pen_0+2(a5)
	move	#1,pen_1+2(a5)
	move	#2,pen_2+2(a5)
	move	#3,pen_3+2(a5)


** Poistetaan reqtoolsrequesterien pubscreentagit
	lea	otag1(pc),a0
	clr.l	(a0)
	clr.l	otag2-otag1(a0)
	clr.l	otag3-otag1(a0)
	clr.l	otag4-otag1(a0)
	clr.l	otag5-otag1(a0)
;	clr.l	otag6-otag1(a0)
;	clr.l	otag7-otag1(a0)
	clr.l	otag8-otag1(a0)
;	clr.l	otag9-otag1(a0)
;	clr.l	otag10-otag1(a0)
;	clr.l	otag11-otag1(a0)
;	clr.l	otag12-otag1(a0)
;	clr.l	otag13-otag1(a0)
	clr.l	otag14-otag1(a0)
	clr.l	otag15-otag1(a0)
	clr.l	otag16-otag1(a0)
	clr.l	otag17-otag1(a0)
	

	lea	winstruc,a0
	move.l	#$00010001,wsizex-winstruc(a0)	* koko 1x1
	lore	Intui,OpenWindow
	tst.l	d0
	bne.b	.go2
	move.b	#i_nowindow,startuperror(a5)
	bra.w	exit
.go2	
	move.l	d0,a0
	move.l	wd_WScreen(a0),a1		* WB screen addr
	move	sc_Width(a1),wbleveys(a5)	* WB:n leveys
	move	sc_Height(a1),wbkorkeus(a5)	* WB:n korkeus
	move.b	sc_BarHeight(a1),windowtop+1(a5) * palkin korkeus
	lob	CloseWindow
	move	WINSIZX(a5),wsizex
	move	WINSIZY(a5),wsizey
	sub	#10,windowtop(a5)
.newkick

	bsr.w	inithippo
	bsr.w	initkorva
	bsr.w	initkorva2
	st	reghippo(a5)


	move.l	(a5),a0
	moveq	#0,d1
	move.b	PowerSupplyFrequency(a0),d1	
	move.l	#3546895,d0
	cmp	#50,d1
	beq.b	.pal
;	move.l	#3579545,d0
	move	#$9E99,d0
.pal	move.l	d0,clockconstant(a5)

	bsr.w	divu_32
	move.l	d0,colordiv(a5)		* 50Hz tai 60Hz n�yt�lle

	move	#15600,horizfreq(a5)
	move	#50,vertfreq(a5)
	
	bsr.w	srand			* randomgeneratorin seed!



	lea	sv_argvArray+4(a5),a3	* ei ekaa
	tst.l	(a3)
	beq.b	.nohide
	move.l	(a3),a0
	bsr.w	kirjainta4
	cmp.l	#"HIDE",d0		* oliko komento 'HIDE'??
	bne.b	.nohide
	clr.b	win(a5)
	bra.b	.hid
.nohide
	bsr.w	get_rt

	st	win(a5)
	bsr.w	avaa_ikkuna		* palauttaa d4:ss� keycheckin~
	beq.b	.go3
	clr.b	win(a5)
	move.b	#i_nowindow,startuperror(a5)
	bra.w	exit
.go3


* ikkuna avattu.. katotaan pit��ko olla pieni
	tst.b	prefsdata+prefs_kokolippu(a5)
	beq.b	.hid
	bsr.w	zippowi
.hid

	bsr.w	inforivit_clear


	tst.b	groupmode(a5)			* ladataanko playergrouppi?
	bne.b	.purr
	jsr	loadplayergroup
	move.l	d0,externalplayers(a5)
;	bne.b	.purr
;	lea	grouperror_t,a1		* ei valiteta vaikka ei l�ydykk��n
;	bsr.w	request

* ladataan playerlibitkin samantien
	jsr	get_sid
	jsr	get_med1
	jsr	get_med2
	jsr	get_med3
	jsr	get_mline

.purr




	pushpea	ch1(a5),hippoport+hip_PTch1(a5)
	pushpea	ch2(a5),hippoport+hip_PTch2(a5)
	pushpea	ch3(a5),hippoport+hip_PTch3(a5)
	pushpea	ch4(a5),hippoport+hip_PTch4(a5)
	pushpea	kplbase(a5),hippoport+hip_kplbase(a5)
	pushpea	listheader(a5),hippoport+hip_listheader(a5)

	move.l	colordiv(a5),hip_colordiv+hippoport(a5)


	moveq	#INTB_VERTB,d0
	lea	intserver,a1
	lore	Exec,AddIntServer
	st	ciasaatu(a5)
	st	vbsaatu(a5)

	bsr.w	init_inputhandler
	bsr.w	init_screennotify

	tst.b	quadon(a5)			* avataanko scope?
	beq.b	.q
	jsr	start_quad
.q
	tst.b	infoon(a5)
	beq.b	.qq
;	st	oli_infoa(a5)
	bsr.w	rbutton10b
.qq

	bsr.w	inforivit_clear

 ifne asm!DEBUG!BETA
	lea	.pah(pc),a0			* registered to..
	moveq	#34+WINX,d0
	moveq	#70+WINY,d1
	bsr.w	print
	bra.w	.vv
.pah	
 if BETA=2
	dc.b	"** For betatesters only **",10
	dc.b	" No further distribution!",0
 endc
 if BETA=1
	dc.b	"* This is a public beta. *",10
 	dc.b	"** Use at your own risk! **",0
 endc
	even
.vv
  endc


	tst	boxsize(a5)
	beq.b	.oohi

	lea	banner_t(pc),a0			* registered to..
	moveq	#11+WINX,d0
	moveq	#18+WINY,d1
	bsr.w	print


	; ei annoytekstia vaikkei rekisteroity
	cmp.b	#' ',keyfile(a5)
	beq.b	.oohi

	lea	regtext_t(pc),a0
	moveq	#62+WINY,d1
	bsr.b	.rount

	lea	keyfile(a5),a0
	moveq	#72+WINY,d1
	bsr.b	.rount
	bra.b	.oohi

.rount
	moveq	#34+WINX,d0
	tst.b	uusikick(a5)
	bne.b	.uere
	add	#28,d0
.uere	
	move	boxsize(a5),d2
	beq.b	.oohi
	cmp	#7,d2
	bhi.b	.re
	add	#50,d0
.re	cmp	#3,d2
	bne.b	.r
	addq	#6,d1
	bra.b	.w

 
.r	lsr	#1,d2
	subq	#1,d2
	lsl	#3,d2
	add	d2,d1
.w	bra.w	print

.oohi


 ifne EFEKTI
	jsr	efekti
 endc
	tst.l	sv_argvArray+4(a5)
	bne.b	.komento0
	tst.b	startuponoff(a5)
	beq.b	.komento0
	tst.b	startup(a5)
	beq.b	.komento0
	pushpea	startup(a5),sv_argvArray+4(a5) * Parametriksi startupmoduuli
	clr.l	sv_argvArray+8(a5)
.komento0
	bsr.w	komentojono			* tutkitaan komentojono.


*********************************************************************************
*
* P��silmukka
*	

	bra.b	msgloop
returnmsg
	bsr.w	flush_messages
msgloop	
	tst.b	exitmainprogram(a5)
	bne.w	exit

	cmp.b	#1,do_alarm(a5)
	bne.b	.noal				* her�tys!
	addq.b	#1,do_alarm(a5)
	lea	startup(a5),a0
	tst.b	(a0)
	beq.b	.noal				* onko moduulia??
	move.l	a0,sv_argvArray+4(a5)		* Parametriksi startupmoduuli
	clr.l	sv_argvArray+8(a5)
	bsr.w	komentojono
	bra.b	returnmsg
.noal


	moveq	#0,d0
	move.b	ownsignal1(a5),d1
	bset	d1,d0
	move.b	ownsignal2(a5),d1
	bset	d1,d0
	move.b	ownsignal3(a5),d1
	bset	d1,d0
	move.b	ownsignal4(a5),d1
	bset	d1,d0
	move.b	ownsignal5(a5),d1
	bset	d1,d0
	move.b	ownsignal6(a5),d1
	bset	d1,d0
	move.b	ownsignal7(a5),d1
	bset	d1,d0
	move.b	hippoport+MP_SIGBIT(a5),d1 * oman viestiportin bitti
	bset	d1,d0

	tst.b	win(a5)
	beq.b	.nw
	move.l	userport(a5),a0
	move.b	MP_SIGBIT(a0),d1		* ikkunan IDCMP:n sigbit
	bset	d1,d0
.nw
	tst.b	rexxon(a5)
	beq.b	.nre
	move.b	rexxport+MP_SIGBIT(a5),d1	* ARexx-portin signalibitti
	bset	d1,d0
.nre

	lore	Exec,Wait		* Odotellaan...



	tst.b	rexxon(a5)
	beq.b	.nrexm
	move.b	rexxport+MP_SIGBIT(a5),d3	* Tuliko ARexx viesti?
	btst	d3,d0
;	bne.w	rexxmessage
	beq.b	.nrexm
	jmp	rexxmessage

.nrexm
* Tuliko viesti� porttiin?
	move.b	hippoport+MP_SIGBIT(a5),d3
	btst	d3,d0
	beq.b	.ow
	push	d0
	bsr.w	omaviesti
	pop	d0
.ow

* Tuliko omia signaaleja??
	move.b	ownsignal1(a5),d3
	btst	d3,d0
	beq.b	.nowo
	pushm	all
	bsr.w	signalreceived
	popm	all


*** Poituttiinko preffsist�?
.nowo	move.b	ownsignal2(a5),d3	* p�ivitet��n positionia
	btst	d3,d0
	beq.w	.nowow
	push	d0
	bsr.w	lootaan_pos
	pop	d0


	tst.b	prefsexit(a5)
	beq.b	.noe
	clr.b	prefsexit(a5)

	move	boxsize(a5),d0		* onko boxin koko vaihtunut??
	cmp	boxsize0(a5),d0
	bne.b	.noe

	st	hippoonbox(a5)
	bsr.w	resh
.noe

** ei saa r�mp�t� ikkunaa jos se ei oo oikeassa koossaan!!

	moveq	#0,d7
	move	boxsize(a5),d0		* onko boxin koko vaihtunut??
	cmp	boxsize0(a5),d0
	beq.b	.weew
	move	d0,boxsize0(a5)
	bsr.w	setboxy
	st	d7

	push	d7


	tst.b	win(a5)
	beq.b	.av
	tst.b	kokolippu(a5)
	bne.b	.iso
	bsr.w	sulje_ikkuna
	clr.b	win(a5)
.av	bsr.w	openw
	bra.b	.bar
.iso
	bsr.w	avaa_ikkuna2
.bar
	pop	d7
	tst.l	d0
	bne.w	exit
	move	boxsize(a5),boxsize0(a5)
.weew


** ei saa r�mp�t� ikkunaa jos se ei oo oikeassa koossaan!!

	tst.b	newpubscreen(a5)	* Valittiinko prefsista uusi
	beq.b	.noewp			* pubscreeni?
	clr.b	newpubscreen(a5)	* siirret��n ikkunat sinne

	tst.b	win(a5)
	beq.b	.av2
	tst.b	kokolippu(a5)
	bne.b	.iso2
	bsr.w	sulje_ikkuna
	clr.b	win(a5)
.av2	bsr.w	openw
	bra.b	.bar2
.iso2
	bsr.w	avaa_ikkuna2
	bne.w	exit
.bar2
	tst	quad_prosessi(a5)
	beq.b	.qer
	jsr	sulje_quad
	jsr	start_quad
.qer	tst	info_prosessi(a5)
	beq.w	returnmsg
	bsr.w	sulje_info
	move.b	oli_infoa(a5),d0
	st	oli_infoa(a5)
	push	d0
	bsr.w	start_info
	pop	d0
	move.b	d0,oli_infoa(a5)

	bra.w	returnmsg

.noewp	tst.b	d7
	bne.w	returnmsg

.nowow

	move.b	ownsignal3(a5),d3	* p�ivitet��n...
	btst	d3,d0
	beq.b	.wow
	push	d0
	bsr.w	lootaan_aika
	bsr.w	lootaan_kello
;	bsr.w	lootaan_muisti
	bsr.w	lootaan_nimi
	bsr.w	zipwindow
	pop	d0

.wow


*** poistuttiin filerequesterista

	push	d0
	move.b	ownsignal6(a5),d3
	btst	d3,d0
	beq.b	.nwww

	tst.b	autosort(a5)		* automaattinen sorttaus?
	beq.b	.nas
	bsr.w	rsort
.nas

	bsr.w	clear_random
	st	hippoonbox(a5)
	bsr.w	resh

	move.b	haluttiinuusimodi(a5),d1
	clr.b	haluttiinuusimodi(a5)

	move.b	new(a5),d0
	clr.b	new(a5)
	tst.b	d0
;	beq.b	.nwww		* ??
	beq.b	.whm		* ??
	bpl.b	.nwww	

.whm	;tst.b	haluttiinuusimodi(a5)
	tst.b	d1
	beq.b	.nwww
	;clr.b	haluttiinuusimodi(a5)


* T�nne tullaan sillon, kun on painettu playt� eik� ollut modeja,
* filereq-prosessin signaalista. Eli aletaan soittaa ekaa valittua modia.

	tst	modamount(a5)		* Ei modeja edelleenk��n
	beq.b	.nwww

	movem.l	d0-a6,-(sp)
	clr	firstname(a5)		* valitaan eka
	clr	chosenmodule(a5)
	tst	playingmodule(a5)
	bmi.b	.ee
	move	#$7fff,playingmodule(a5)
.ee	bsr.w	rbutton1
	movem.l	(sp)+,d0-a6
	
.nwww	pop	d0

	tst.b	freezegads(a5)		* gadgetit freezattu!?
	bne.b	.nwwwq

	move.b	ownsignal7(a5),d3	* rawkey inputhandlerilta
	btst	d3,d0
	beq.b	.nwwwq
	moveq	#0,d4
	move	rawkeyinput(a5),d3
	cmp	#$25,d3			* oliko 'h'?
	beq.b	.hide
	cmp	#$01,d3			* '1'? -> iconify
	bne.b	.nico
	moveq	#0,d3			* muutetaan -> ~`
	bra.w	nappuloita
.nico

	tst	d3
	bne.w	nappuloita

	tst.b	win(a5)
	bne.b	.obh
.open	
	bsr.w	openw
	bne.w	exit
	bra.w	returnmsg

.obh	
* painettiinko zip windowi ei-ikkunassa? pullautetaan..
	tst.b	kokolippu(a5)
	beq.b	.op
	bsr.w	front
	bra.b	.nwwwq
.op	bsr.w	sulje_ikkuna
	clr.b	win(a5)
	bra.b	.open


.hide
	tst.b	win(a5)
	beq.b	.open
	bsr.w	sulje_ikkuna
	clr.b	win(a5)
	bra.w	returnmsg


.nwwwq



	move.b	ownsignal4(a5),d3
	btst	d3,d0
	beq.b	.nowww
	bsr.w	sulje_ikkuna
	bsr.w	avaa_ikkuna
	bne.w	exit
	bra.w	returnmsg

.nowww	
* Vastataan IDCMP:n viestiin

getmoremsg
	tst.b	win(a5)
	beq.w	msgloop

	move.l	userport(a5),a4
	move.l	a4,a0
	lob	GetMsg
	tst.l	d0
	beq.w	msgloop

	move.l	d0,a1
	move.l	im_Class(a1),d2		* luokka	
	move	im_Code(a1),d3		* koodi
	move	im_Qualifier(a1),d4	* RAWKEY: IEQUALIFIER_?
	move.l	im_IAddress(a1),a2 	* gadgetin tai olion osoite
	move	im_MouseX(a1),mousex(a5)
	move	im_MouseY(a1),mousey(a5)

	lob	ReplyMsg

	tst.b	freezegads(a5)
	bne.w	msgloop

	cmp.l	#IDCMP_CHANGEWINDOW,d2
	bne.b	.nz
	bsr.w	zipwindow
.nz

	cmp.l	#IDCMP_RAWKEY,d2
	beq.w	nappuloita
	cmp.l	#IDCMP_MOUSEMOVE,d2
	beq.w	mousemoving
	cmp.l	#IDCMP_GADGETUP,d2
	beq.w	gadgetsup
	cmp.l	#IDCMP_MOUSEBUTTONS,d2
	beq.w	buttonspressed
	cmp.l	#IDCMP_CLOSEWINDOW,d2
	bne.w	msgloop

exit	
	lea	var_b,a5

* poistetaan loput prosessit...


* onko prosessien k�ynnistys kesken?
;	cmp	#1,prefs_prosessi(a5)
;	beq.b	.er2	
;	cmp	#1,quad_prosessi(a5)
;	beq.b	.er2	
;	cmp	#1,filereq_prosessi(a5)
;	beq.b	.er2	

	bsr.w	sulje_prefs
	jsr	sulje_quad
	bsr.w	sulje_info

	tst.b	hippoport+hip_opencount(a5)	* onko portilla
	beq.b	.joer				* k�ytt�ji�?

** k�sket��n niit� sammumaan.
	st	hippoport+hip_quit(a5)

	moveq	#3*25-1,d7		* odotetaan max 2 sekkaa
.jorl	tst.b	hippoport+hip_opencount(a5)
	beq.b	.joer
	bsr.w	dela
	dbf	d7,.jorl
	bra.b	.er
	clr.b	hippoport+hip_quit(a5)	* ei en�� quittia jos ei onnistunu.

.joer

* n�it� ei voida niin vaan poistaakaan.
	tst	filereq_prosessi(a5)
	beq.b	.ex

.er	lea	.clo(pc),a1
.req	jsr	request
	clr.b	exitmainprogram(a5)	* ei en�� exitti�.	
	bra.w	msgloop
;.er2	lea	.cl(pc),a1
;	bra.b	.req
;.cl	dc.b	"Can't quit just yet!",0
.clo	dc.b	"Close all requesters & external programs and try again!",0
 even

.ex
	bsr.w	freelist		* vapautetaan lista


	bsr.w	rbutton4b		* eject /wo fade
;	bsr	freeearly

;	tst	playingmodule(a5)
;	bmi.b	.uh00
;	move.l	playerbase(a5),a0
;	jsr	p_end(a0)
;.uh00;	bsr.w	freemodule


	jsr	rem_ciaint

	tst.b	vbsaatu(a5)
	beq.b	.nbv
	moveq	#INTB_VERTB,d0
	lea	intserver,a1
	lore	Exec,RemIntServer
.nbv



	tst.b	filterstore(a5)
	bne.b	.ee
	bclr	#1,$bfe001
.ee
	jsr	vapauta_kanavat
	bsr.w	rem_inputhandler
	bsr.w	rem_screennotify

	move.l	externalplayers(a5),a0		* vapautetaan playerit
	bsr.w	freemem

	move.l	xplayer(a5),a0
	bsr.w	freemem
	move.l	ps3msettingsfile(a5),a0		* vapautetaan ps3masetustied.
	bsr.w	freemem
	move.l	calibrationaddr(a5),a0
	bsr.w	freemem

	bsr.w	flush_messages
	bsr.w	sulje_ikkuna

	move.b	ownsignal1(a5),d0
	bsr.w	freesignal
	move.b	ownsignal2(a5),d0
	bsr.w	freesignal
	move.b	ownsignal3(a5),d0
	bsr.w	freesignal
	move.b	ownsignal4(a5),d0
	bsr.w	freesignal
	move.b	ownsignal5(a5),d0
	bsr.w	freesignal
	move.b	ownsignal6(a5),d0
	bsr.w	freesignal
	move.b	ownsignal7(a5),d0
	bsr.w	freesignal

	move.l	fontbase(a5),d0
	beq.b	.uh2
	cmp.l	topazbase(a5),d0
	beq.b	.uh2
	move.l	d0,a1
	lore	GFX,CloseFont
.uh2


	move.l	topazbase(a5),a1
	lore	GFX,CloseFont

	move.l	req_file(a5),d0
	beq.b	.whoop
	move.l	d0,a1
	lore	Req,rtFreeRequest
.whoop

	tst.b	rexxon(a5)
	beq.b	.nor2
	bsr.w	deleterexxport
.nor2	bsr.w	deleteport0

	move.l	nilfile(a5),d1
	lore	Dos,Close

 ifne DEBUG
 	move.l	output(a5),d1
 	beq.b	.xef
	lob	Close
.xef
 endc

	move.l	_SIDBase(a5),d0		* poistetaan sidplayer
	beq.b	.nahf			
	jsr	rem_sidpatch		* patchi kanssa
	move.l	_SIDBase(a5),a1
	lore	Exec,CloseLibrary
.nahf	
	move.l	_MedPlayerBase1(a5),d0
	bsr.w	closel
	move.l	_MedPlayerBase2(a5),d0
	bsr.b	closel
	move.l	_MedPlayerBase3(a5),d0
	bsr.b	closel
	move.l	_MlineBase(a5),d0
	bsr.b	closel

	move.l	_PPBase(a5),d0
	bsr.b	closel
	move.l	_XPKBase(a5),d0
	bsr.b	closel
	move.l	_XFDBase(a5),d0
	bsr.b	closel
	move.l	_ScrNotifyBase(a5),d0
	bsr.b	closel
	move.l	_RexxBase(a5),d0
	bsr.b	closel
	move.l	_DiskFontBase(a5),d0
	bsr.b	closel
	move.l	_WBBase(a5),d0
	bsr.b	closel
	move.l	_IntuiBase(a5),d0
	bsr.b	closel
	move.l	_GFXBase(a5),d0
	bsr.b	closel
	move.l	_ReqBase(a5),d0
	bsr.b	closel
	move.l	_DosBase(a5),d0
	bsr.b	closel

	bsr.w	tulostavirhe
exit2

	move.l	_IntuiBase(a5),d0
	bsr.b	closel

 ifeq asm
	move.l	lockhere(a5),d1		* vapautetaan kopioitu lukko
	lore	Dos,UnLock
	lore	Exec,Forbid		* kiellet��n moniajo

	bsr.w	vastomaviesti		* vastataan killeriviestiin

	move.l	segment(a5),d1
	lore	Dos,UnLoadSeg		* vapautetaan omat hunkit
 endc

	moveq	#0,d0
	rts


closel	beq.b	.huh
	move.l	d0,a1
	lore	Exec,CloseLibrary
.huh	rts

freesignal
	tst.b	d0
	bmi.b	.e
	lore	Exec,FreeSignal
.e	rts

getsignal
	moveq	#-1,d0
	move.l	(a5),a6
	jmp	_LVOAllocSignal(a6)

dela	pushm	all		* pienenpieni delay
	moveq	#2,d1
	lore	Dos,Delay
	popm	all
	rts

*** Avaa ReqToolssin

get_rt	lea	var_b,a5
	tst.l	_ReqBase(a5)
	bne.b	.o
	pushm	d0/d1/a0/a1/a6
	lea 	reqname(pc),a1		
	moveq	#38,d0
	lore	Exec,OpenLibrary
	move.l	d0,_ReqBase(a5)
	bne.b	.ok

	move.b	#1,startuperror(a5)
	bsr.b	tulostavirhe
;	move.l	#$7fffffff,d1
	moveq	#-2,d1
	ror.l	#1,d1

	lore	Dos,Delay
.ok
	popm	d0/d1/a0/a1/a6
.o	move.l	_ReqBase(a5),a6
	rts


;se_noreq
;	move.b	#i_noreq,startuperror(a5)
;	bsr.b	tulostavirhe
;	bra.b	exit2

tulostavirhe
	tst.b	startuperror(a5)
	bne.b	.ee
	rts
.ee	pushm	all

	move.b	startuperror(a5),d0
	lea	.r1(pc),a0
	subq.b	#1,d0
	beq.b	.r
	lea	.r2(pc),a0
	subq.b	#1,d0
	beq.b	.r
	lea	.r3(pc),a0
	subq.b	#1,d0
	bne.b	.x
.r	
	moveq	#0,d0		* recovery
	moveq	#19,d1		* korkeus
	lore	Intui,DisplayAlert
	
.x	popm	all
	rts

.r1	;dc	(640-((.r1e-.r1-2)*8))/2
	;dc	208
	dc	176
	dc.b	11
	dc.b	"HiP frozen: no reqtools.library V38+!",0,0
.r1e
 even
.r2	
	;dc	(640-((.r2e-.r2-2)*8))/2
	dc	212
	dc.b	11
	dc.b	"HiP: no CIA interrupts!",0,0
.r2e
 even
.r3	
	;dc	(640-((.r3e-.r3-2)*8))/2
	dc	248
	dc.b	11
 	dc.b	"HiP: no window!",0,0
.r3e
  even
 
i_noreq		=	1
i_nocia		=	2
i_nowindow	=	3


*******
* Flushataan ikkunan viestit puis
*******
flush_messages
	bsr.b	.fl
	tst.l	windowbase(a5)
	bne.b	.e
	rts
.e	move.l	(a5),a6
	move.l	userport(a5),a0	* flushataan pois kaikki messaget
	lob	GetMsg
	tst.l	d0
	beq.b	.ex
	move.l	d0,a1
	lob	ReplyMsg
	bra.b	flush_messages
.ex	rts

* Hippoportin messaget pois
.fl	tst.b	hippoporton(a5)
	beq.b	.ex
	move.l	(a5),a6
	lea	hippoport(a5),a0
	lob	GetMsg
	tst.l	d0
	beq.b	.ex
	move.l	d0,a1
	lob	ReplyMsg
	bra.b	.fl



createrexxport	pushm	all
		lea	.p(pc),a4
		lea	rexxport(a5),a2
		bra.b	createport1

.p	dc.b	"HIPPOPLAYER",0
 even
	
createport0	pushm	all
		lea	portname(pc),a4
		lea	hippoport(a5),a2
		st	hippoporton(a5)
createport1	moveq	#-1,d0
		lore	Exec,AllocSignal	* varataan signaalibitti
		move.b	d0,MP_SIGBIT(a2)	* asetetaan signaali porttiin
		move.l	owntask(a5),MP_SIGTASK(a2) * asetataan osoite porttiin
		move.b	#NT_MSGPORT,LN_TYPE(a2)	* noden tyyppi = MSGPORT
		clr.b	MP_FLAGS(a2)		* nollataan liput
		move.l	a4,LN_NAME(a2)
		move.l	a2,a1
		lob	AddPort
		popm	all
		rts

deleterexxport	pushm	all
		lea	rexxport(a5),a2
		bra.b	deleteport1

deleteport0	
		tst.b	hippoporton(a5)
		bne.b	.n
		rts

.n		clr.b	hippoporton(a5)
		pushm	all
		lea	hippoport(a5),a2
deleteport1	move.l	a2,a1
		lore	Exec,RemPort
		moveq	#0,d0
		move.b	MP_SIGBIT(a2),d0	* signaalin numero
		lob	FreeSignal
		popm	all
		rts


******************************************************************************
* Screennotify
*****************************************************************************

init_screennotify
	tst.b	uusikick(a5)
	beq.b	.x
	move.l	_ScrNotifyBase(a5),d0
	beq.b	.x
	move.l	d0,a6
	moveq	#0,d0			* priority
	lea	hippoport(a5),a0
	lob	AddWorkbenchClient
	move.l	d0,notifyhandle(a5)
.x	rts

rem_screennotify
	move.l	notifyhandle(a5),d0
	beq.b	.x
	move.l	d0,a0
	lore	ScrNotify,RemWorkbenchClient
.x	rts


******************************************************************************
* Inputhandler
*****************************************************************************

init_inputhandler
	lea	idname(pc),a0
	moveq	#0,d0			* unit
	lea	iorequest2(a5),a1
	moveq	#0,d1			* flags
	lore	Exec,OpenDevice
	move.l	d0,idopen(a5)
	bne.w	iderror	

	lea	idmsgport(a5),a2
	move.b	#NT_MSGPORT,LN_TYPE(a2)
	clr.b	MP_FLAGS(a2)
	clr.l	LN_NAME(a2)		* name

	moveq	#-1,d0			* get signal bit
	lob	AllocSignal
	move.b	d0,MP_SIGBIT(a2)
;	bmi.b	iderror

	move.l	owntask(a5),MP_SIGTASK(a2)
	lea	MP_MSGLIST(a2),a0
	NEWLIST	a0
	lea	iorequest2(a5),a1
	move.l	a2,MN_REPLYPORT(a1)

	lea	intstr(a5),a4
	move.b	#NT_INTERRUPT,LN_TYPE(a4)
	move.b	#60,LN_PRI(a4)
	lea	inputhandler(pc),a2
	move.l	a2,IS_CODE(a4)
	move.l	a5,IS_DATA(a4)		* IS_DATA = var_b

	lea	iorequest2(a5),a1
	move	#IND_ADDHANDLER,IO_COMMAND(a1)
	move.l	a4,IO_DATA(a1)
	lob	DoIO


*** Registration check.
	tst.b	keycheck(a5)
	beq.b	.rite
	lea	no_one(pc),a0
	lea	keyfile(a5),a1
.jaffa	move.b	(a0)+,(a1)+
	bne.b	.jaffa
.rite
****

	tst.l	d0
	bne.b	iderror
	moveq	#0,d0
	rts

 
rem_inputhandler
iderror
	tst.l	idopen(a5)
	bne.b	.nope

	lea	iorequest2(a5),a1
	move	#IND_REMHANDLER,IO_COMMAND(a1)
	lea	intstr(a5),a0
	move.l	a0,IO_DATA(a1)
	lore	Exec,DoIO

	move.l	idopen(a5),d0
	lea	iorequest2(a5),a1
	lob	CloseDevice

.nope	
	moveq	#0,d0
	move.b	idmsgport+MP_SIGBIT(a5),d0
	bmi.b	.nope2
	beq.b	.nope2
	lore	Exec,FreeSignal
.nope2

	moveq	#0,d0
	rts


* a0 = start of the event list
* a1 = user data pointer (var_b)
inputhandler
	tst.b	hotkey(a1)
	beq.b	.quit
	pushm	d0/d1/a0/a1/a6
.handlerloop
	move.b	ie_Class(a0),d0			* class
	cmp.b	#IECLASS_RAWKEY,d0
	bne.b	.cont
	move	ie_Qualifier(a0),d0
	and	#IEQUALIFIER_LSHIFT!IEQUALIFIER_CONTROL!IEQUALIFIER_LCOMMAND,d0
	cmp	#IEQUALIFIER_LSHIFT!IEQUALIFIER_CONTROL!IEQUALIFIER_LCOMMAND,d0
	bne.b	.cont
	move	ie_Code(a0),d0			* rawkoodi
	tst.b	d0
	bmi.b	.cont				* vain jos nappula alhaalla
	clr.b	ie_Class(a0)			* ieclass_null (syodaan pois)
	move	d0,rawkeyinput(a1)		* a1 = var_b
	move.b	ownsignal7(a1),d1
	jsr	signalit
	bra.b	.exhand
	
.cont	move.l	ie_NextEvent(a0),d0		* seuraava
	move.l	d0,a0
	bne.b	.handlerloop
.exhand	
	popm	d0/d1/a0/a1/a6
.quit	move.l	a0,d0
	rts



*******
* Printti rutiini
*******

* sPrint = Info-ikkunaan
sprint  pushm	all
	add	windowleft(a5),d0
	add	windowtop(a5),d1	* suhteutetaan palkin fonttiin
	move.l	srastport(a5),a4
	bra.b	uup	


* Print3 = Prefs-ikkunaan
print3	pushm	all
	add	windowleft(a5),d0
	add	windowtop(a5),d1	* suhteutetaan palkin fonttiin
	move.l	rastport2(a5),a4
	bra.b	uup	

* P��ikkunaan
* d0/d1 = x,y
* a0 = teksti
print	add	windowleft(a5),d0
	add	windowtop(a5),d1	* suhteutetaan palkin fonttiin
	tst.b	win(a5)		* onko ikkunaa?
	beq.b	.r
	tst.b	kokolippu(a5)	* ei tulosteta, jos ikkuna pienen�
	bne.b	.e
.r	rts
.e
	pushm	all
	move.l	rastport(a5),a4
uup	


	move.l	_GFXBase(a5),a6
	move.l	a0,a2

	move	d0,d4
	move	d1,d5
.luup	
	move	d4,d0
	move	d5,d1

	move.l	a4,a1
	lob	Move
	move.l	a4,a1
	move.l	a2,a0

	moveq	#0,d7
	moveq	#0,d0
.plah	addq	#1,d0
	tst.b	(a2)
	beq.b	.pog
	cmp.b	#10,(a2)+
	bne.b	.plah
	moveq	#1,d7
.pog
	subq	#1,d0
	lob	Text

	tst	d7
	beq.b	.x
	addq	#8,d5
	bra.b	.luup		

.x	popm	all
	rts

*** A0:sta 4 ascii-kirjainta D0:aan 
kirjainta4
	move.b	(a0)+,d0
	beq.b	.x
	lsl.l	#8,d0
	move.b	(a0)+,d0
	beq.b	.x
	lsl.l	#8,d0
	move.b	(a0)+,d0
	beq.b	.x
	lsl.l	#8,d0
	move.b	(a0),d0
.x	and.l	#$dfdfdfdf,d0		* muunnetaan isoiksi
	rts



******************************************************************************
* Avaa ikkunan ja pikkasen alustaakin
*******

openw
	tst.b	win(a5)
	bne.b	.x
	st	win(a5)
	clr.b	kokolippu(a5)		* pieni -> iso
	bsr.b	avaa_ikkuna
	bne.b	.x
	jsr	whatgadgets2
	moveq	#0,d0
.x	rts


plx1	equr	d4
ply1	equr	d5
plx2	equr	d6
ply2	equr	d7

*** Painettiin Zoom-gadgettia

*** P�ivitet��n ikkunan sis�lt�

zipwindow
	tst.b	win(a5)
	bne.b	.onw	
	rts
.onw
	pushm	all
	move.l	windowbase(a5),a0
	move	wd_Height(a0),d0
	cmp	wkork(a5),d0
	beq.b	.x
	move	d0,d1
	sub	wkork(a5),d1	* onko muutos suurempi kuin 60 pixeli�?
	move	d0,wkork(a5)
	tst	d1
	bpl.b	.e
	neg	d1
.e	cmp	#40,d1
	blo.b	.x


	not.b	kokolippu(a5)
	bne.b	.big
	move.l	4(a0),windowpos2(a5)
** pieni ikkuna!
	move.l	windowbase(a5),a0
	lea	gadgets,a1
	moveq	#-1,d0
	moveq	#-1,d1
	sub.l	a2,a2
	lore	Intui,RemoveGList
	bra.b	.x
.big
	move.l	4(a0),windowpos(a5)
	bsr.w	wrender
.x	popm	all
	rts



avaa_ikkuna2
	bsr.w	sulje_ikkuna
	not.b	kokolippu(a5)
	

avaa_ikkuna
	bsr.w	getscreeninfo
	bne.w	.opener

	move.l	_IntuiBase(a5),a6
	lea	winstruc,a0

	move.l	windowpos2(a5),(a0)		* Pienen paikka ja koko
	moveq	#11,d0
	tst.b	uusikick(a5)
	bne.b	.new1
	moveq	#10,d0				* kick1.3
.new1	add	windowtop(a5),d0
	move	d0,wsizey-winstruc(a0)
	bsr.w	.leve

	not.b	kokolippu(a5)
	beq.b	.small

	move	#7,slimheight		* slideri pieneks, jotta ei tuu sotkuja

	move	WINSIZY(a5),d0
	add	boxy(a5),d0
	add	windowtop(a5),d0
	move	d0,wsizey-winstruc(a0)	* Ison koko ja paikka
	move.l	windowpos(a5),(a0)
	bsr.w	.leve

	move	wbkorkeus(a5),d6	* Mahtuuko ruudulle pystysuunnassa?
	sub	WINSIZY(a5),d6
	sub	windowtop(a5),d6
.uudest
	move	d6,d0
	sub	boxy(a5),d0		* mahtuuko fileboxi?
	bmi.b	.negatiivi

	cmp	2(a0),d0
	bge.b	.okkk
	move	d0,2(a0)
	bra.b	.okkk

.negatiivi
	subq	#1,boxsize(a5)		* Pienennet��n fileboksia..
	subq	#1,boxsize0(a5)
	bsr.w	setboxy
	move	d6,d0
	sub	boxy(a5),d0
	bmi.b	.negatiivi
	move	WINSIZY(a5),d0
	add	windowtop(a5),d0
	add	boxy(a5),d0
	move	d0,wsizey-winstruc(a0)	* Ison koko ja paikka
	bra.b	.uudest
.okkk

.small	
	lea	slider4,a3		* fileboxin slideri
	moveq	#67,d3			* y-koko
	and	#~$80,gg_TopEdge(a3)
	add	boxy(a5),d3
	bpl.b	.r
	or	#$80,gg_TopEdge(a3)
	clr	d3
.r	move	d3,gg_Height(a3)


	tst.b	uusikick(a5)
	beq.b	.ded
	subq	#3,gg_Height(a3)
.ded

	lob	OpenWindow
	move.l	d0,windowbase(a5)
	bne.b	.ok
	bsr.w	unlockscreen

.opener	moveq	#-1,d0			* Ei auennut!
	rts

.leve	move	wbleveys(a5),d0		* WB:n leveys
	move	(a0),d1			* Ikkunan x-paikka
	add	4(a0),d1		* Ikkunan oikea laita
	cmp	d0,d1
	bls.b	.okk
	sub	4(a0),d0	* Jos ei mahdu ruudulle, laitetaan
	move	d0,(a0)		* mahdollisimman oikealle
.okk	rts

.ok
	move.l	d0,a0
	move.l	wd_RPort(a0),rastport(a5)
	move.l	wd_UserPort(a0),userport(a5)
	move	wd_Height(a0),wkork(a5)

	move.l	rastport(a5),a1
	move.l	fontbase(a5),a0
	lore	GFX,SetFont	


	tst.b	uusikick(a5)	* jos kickstart 2.0+, pistet��n ikkuna
	beq.b	.elderly	* appwindowiksi.

	moveq	#0,d0		* ID
	move.l	#"AppW",d1	* userdata
	move.l	windowbase(a5),a0
	lea	hippoport(a5),a1 * msgport
	sub.l	a2,a2		* null
	lore	WB,AddAppWindowA
	move.l	d0,appwindow(a5)
.elderly

	bsr.w	wrender
;	bsr.w	front		
	moveq	#0,d0
	rts





getscreeninfo
	st	gotscreeninfo(a5)

*** Selvitet��n ikkunan n�yt�n ominaisuudet
*** Uusi kick 
	tst.b	uusikick(a5)
	beq.w	.olde

	lea	pubscreen(a5),a0
	lore	Intui,LockPubScreen
	move.l	d0,screenlock(a5)
	bne.b	.ok1
	sub.l	a0,a0
	lob	LockPubScreen
	move.l	d0,screenlock(a5)
	beq.w	.opener
.ok1
	move.l	d0,a0

	move.l	d0,screenaddr(a5)
	move	sc_Width(a0),wbleveys(a5)	* N�yt�n leveys
	move	sc_Height(a0),wbkorkeus(a5)	* N�yt�n korkeus
	clr	windowtop(a5)
	clr	windowtopb(a5)
	clr	windowbottom(a5)
	clr	windowleft(a5)
	clr	windowright(a5)
	move.b	sc_BarHeight(a0),windowtop+1(a5) * Palkin korkeus
	move.b	sc_WBorBottom(a0),windowbottom+1(a5)
	move.b	sc_WBorTop(a0),windowtopb+1(a5)
	move.b	sc_WBorLeft(a0),windowleft+1(a5)
	move.b	sc_WBorRight(a0),windowright+1(a5)

	move	windowtopb(a5),d0
	add	d0,windowtop(a5)

	subq	#4,windowleft(a5)		* saattaa menn� negatiiviseksi
	subq	#4,windowright(a5)
	subq	#2,windowtop(a5)
	subq	#2,windowbottom(a5)

;	subq	#4,windowleft(a5)
;	subq	#4,windowright(a5)
;	subq	#2,windowbottom(a5)


** Tutkaillaan n�yt�n tyyppi�!
* Talteen oikea hz scopeja varten


	lea	sc_ViewPort(a0),a2
	move.l	a2,a0
	lore	GFX,GetVPModeID
	and.l	#$40000000,d0		* onko native amiga screeni?
	beq.b	.nogfxcard
	st	gfxcard(a5)
	bra.w	.ba	
.nogfxcard


;	lea	sc_ViewPort(a0),a0	* viewport
	move.l	a2,a0
	move.l	vp_ColorMap(a0),a0	* colormap
	move.l	cm_VPModeID(a0),d0	* handle

	lob	FindDisplayInfo
	move.l	d0,d4
	beq.b	.ba

	lea	-40(sp),sp
	move.l	sp,a4

	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7

	move.l	#DTAG_DISP,d1
	bsr.b	.pa
	move	dis_PixelSpeed(a4),d5

	move.l	#DTAG_MNTR,d1
	bsr.b	.pa
	move	mtr_TotalRows(a4),d6	
	move	mtr_TotalColorClocks(a4),d7

	lea	40(sp),sp

	move.l	#1000000000,d0
;	divu.l	d5,d0		* pixelclock in Hz
	move.l	d5,d1
	bsr.w	divu_32
	
	move.l	#280,d1
	divu	d5,d1		* pixelclocks/280ns colorclock
	mulu	d7,d1		* pixelclocks per line
	
;	divu.l	d1,d0		* linefrequency in Hz
	bsr.w	divu_32

	move.l	d0,d1
	divu	d6,d1		* vertical frequency

	move	d0,horizfreq(a5)
	move	d1,vertfreq(a5)

	move.l	clockconstant(a5),d0
	ext.l	d1
	bsr.w	divu_32
	move.l	d0,colordiv(a5)
	bra.b	.ba

.pa	move.l	d4,a0
	moveq	#0,d2
	move.l	a4,a1
	moveq	#40,d0		* buf size
	jmp	_LVOGetDisplayInfoData(a6)
;	rts

.ba


;******************************* Piirtokynien selvitys

;	move.l	(a5),a1
;	cmp	#39,LIB_VERSION(a1)
;	blo.w	.kick2

;	move.l	screenaddr(a5),a0
;	lea	sc_ViewPort(a0),a3
;	move.l	vp_ColorMap(a3),a3	* ColorMappi

;	move.l	#$a0000000,d1
;	move.l	d1,d2
;	move.l	d1,d3
;	move.l	a3,a0
;	lea	.tags(pc),a1
;	lore	GFX,ObtainBestPenA
;	move.l	d0,pen_0(a5)

;	moveq	#0,d1
;	moveq	#0,d2
;	moveq	#0,d3
;	move.l	a3,a0
;	lea	.tags(pc),a1
;	lob	ObtainBestPenA
;	move.l	d0,pen_1(a5)

;	moveq	#0,d1
;	moveq	#0,d2
;	moveq	#0,d3
;	move.l	a3,a0
;	lea	.tags(pc),a1
;	lob	ObtainBestPenA
;	move.l	d0,pen_1(a5)

;	move.l	#$f0000000,d1
;	move.l	d1,d2
;	move.l	d1,d3
;	move.l	a3,a0
;	lea	.tags(pc),a1
;	lob	ObtainBestPenA
;	move.l	d0,pen_2(a5)

;	move.l	#$60000000,d1
;	move.l	#$80000000,d2
;	move.l	#$B0000000,d3
;	move.l	a3,a0
;	lea	.tags(pc),a1
;	lob	ObtainBestPenA
;	move.l	d0,pen_3(a5)

;	bra.b	.kick2

;.tags
;	dc.l	OBP_Precision,PRECISION_GUI
;	dc.l	TAG_END

;.kick2


	sub	#10,windowtop(a5)
	;bpl.b	.olde
	;clr	windowtop(a5)
	
*** S��det��n ikkunat ja gadgetit otsikkopalkin koon mukaan

.olde
	move	windowtop(a5),d0
	move	windowtop2(a5),d1
	move	d0,windowtop2(a5)
	sub	d1,d0			* ERO!

* nw_TopEdge = 2
* nw_Width   = 4
* nw_Height  = 6

	add	d0,winstruc+nw_Height		* suhteutetaan koot fonttiin
	add	d0,winstruc2+nw_Height
	add	d0,winstruc3+nw_Height
	add	d0,swinstruc+nw_Height
	add	d0,windowpos22+2(a5)	* pienen ikkunan zip-koko

	move	windowleft(a5),d1
	move	windowleft2(a5),d2
	move	d1,windowleft2(a5)
	sub	d2,d1
	add	d1,winstruc+nw_Width
	add	d1,winstruc2+nw_Width
	add	d1,winstruc3+nw_Width
	add	d1,swinstruc+nw_Width

	add	d1,WINSIZX(a5)

	move	windowbottom(a5),d3
	move	windowbottom2(a5),d4
	move	d3,windowbottom2(a5)
	sub	d4,d3
	add	d3,WINSIZY(a5)
	add	d3,prefssiz+2
	add	d3,quadsiz+2
	add	d3,swinsiz+2

	move	WINSIZX(a5),wsizex
	move	WINSIZY(a5),wsizey

	lea	gadgets,a0
	bsr.b	.hum
	lea	gadgets2-gadgets(a0),a0
	bsr.b	.hum
	lea	gAD1-gadgets2(a0),a0
	bsr.b	.hum
	lea	sivu0-gAD1(a0),a0
	bsr.b	.hum
	lea	sivu1-sivu0(a0),a0
	bsr.b	.hum
	lea	sivu2-sivu1(a0),a0
	bsr.b	.hum
	lea	sivu3-sivu2(a0),a0
	bsr.b	.hum
	lea	sivu4-sivu3(a0),a0
	bsr.b	.hum
	lea	sivu5-sivu4(a0),a0
	bsr.b	.hum
	lea	sivu6-sivu5(a0),a0
	bsr.b	.hum


	bsr.w	unlockscreen
	moveq	#0,d0
	rts
.opener	moveq	#-1,d0
	rts


.hum
	move.l	a0,a1
.lop0	add	d0,6(a1)
	add	d1,4(a1)
	tst.l	(a1)
	beq.b	.e0
	move.l	(a1),a1
	bra.b	.lop0
.e0	rts


	


****** Piirret��n ikkunan kamat

wrender
	move.l	pen_0(a5),d0
	move.l	rastport(a5),a1
	lore	GFX,SetBPen

	lea	gadgets,a4


	tst.b	kokolippu(a5)
	beq.w	.pienehko


	tst.b	uusikick(a5)		* uusi kick?
	beq.b	.vanaha

	move.l	rastport(a5),a2
	moveq	#4,d0
	moveq	#11,d1
	move	#259,d2
	move	WINSIZY(a5),d3
	subq	#3,d3
	add	boxy(a5),d3
	sub	windowbottom(a5),d3
	bsr.w	drawtexture

.ohih



* tyhjennet��n...
* laatikoitten alueet

;	lea	gadgets,a3
;	move.l	a3,a4
	move.l	a4,a3
.clrloop
	move.l	(a3),d7
	movem	4(a3),d0/d1/d4/d5	* putsataan gadgetin alue..
	bsr.b	.cler
	move.l	d7,a3
	tst.l	d7
	bne.b	.clrloop
	bra.b	.oru

.cler	
	tst	boxsize(a5)
	bne.b	.clef
	cmp.l	#slider4,a3		* fileslider
	bne.b	.clef
	rts	
.clef
	move.l	rastport(a5),a0
	move.l	a0,a1
	move	d0,d2
	move	d1,d3
	moveq	#$0a,d6
	move.l	_GFXBase(a5),a6
	jmp	_LVOClipBlit(a6)
;	lore	GFX,ClipBlit
;	rts
.oru
.vanaha


* sitten isket��n gadgetit ikkunaan..
	move.l	windowbase(a5),a0
;	lea	gadgets,a1
	lea	(a4),a1
	moveq	#-1,d0
	moveq	#-1,d1
	sub.l	a2,a2
	lore	Intui,AddGList
;	lea	gadgets,a0
	lea	(a4),a0
	move.l	windowbase(a5),a1
	sub.l	a2,a2
	lob	RefreshGadgets




**** paksunnetaan gadujen reunat


;	lea	gadgets,a3
	lea	(a4),a3
.loloop
	move.l	(a3),d3
	cmp.l	#slider4,a3
	beq.b	.nel
	cmp.l	#slider1,a3
	beq.b	.nel

	movem	4(a3),plx1/ply1/plx2/ply2
	add	plx1,plx2
	add	ply1,ply2
	subq	#1,ply2
	subq	#1,plx1

	push	d3
	move.l	rastport(a5),a1
	bsr.w	laatikko1
	pop	d3

.nel	move.l	d3,a3
	tst.l	d3
	bne.b	.loloop


	tst.b	uusikick(a5)
	beq.b	.nelq

	tst	boxsize(a5)
	beq.b	.nofs

	movem	slider4+4,plx1/ply1/plx2/ply2	* fileslider
	add	plx1,plx2
	add	ply1,ply2
	subq	#2,plx1
	addq	#1,plx2
	subq	#2,ply1
	addq	#1,ply2
	move.l	rastport(a5),a1
	bsr.w	sliderlaatikko
.nofs
	movem	slider1+4,plx1/ply1/plx2/ply2	* volumeslider
	add	plx1,plx2
	add	ply1,ply2
	subq	#2,plx1
	addq	#1,plx2
	subq	#2,ply1
	addq	#1,ply2
	move.l	rastport(a5),a1
	bsr.w	sliderlaatikko

.nelq






*** Piirret��n korvat
	pushm	all
	lea	button7,a0		* Add
	bsr.w	printkorva
	lea	lilb1-button7(a0),a0	* M
	bsr.w	printkorva
	lea	lilb2-lilb1(a0),a0	* S
	bsr.w	printkorva
	lea	kela2-lilb2(a0),a0	* >, forward
	bsr.w	printkorva
	lea	plg-kela2(a0),a0	* Prg
	bsr.w	printkorva
	lea	button8-plg(a0),a0	* Del
	bsr.w	printkorva
	lea	button2-button8(a0),a0	* i
	bsr.w	printkorva
	lea	button11-button2(a0),a0	* new
	bsr.w	printkorva
	lea	button20-button11(a0),a0 * pr
	bsr.w	printkorva
	lea	button1-button20(a0),a0 * play
	bsr.w	printkorva


 ifd abda

*** Piirret��n 'underlinet'


	move.l	pen_1(a5),d0
	move.l	rastport(a5),a1
	lore	GFX,SetAPen

	lea	button11+4,a3

	movem	(a3),d0/d1
	bsr.b	.dru

	movem	button7-button11(a3),d0/d1
	bsr.b	.dru

	movem	button8-button11(a3),d0/d1
	bsr.b	.dru

	movem	plg-button11(a3),d0/d1
	bsr.b	.dru

	movem	lilb1-button11(a3),d0/d1
	subq	#1,d0
	bsr.b	.dru

	movem	lilb2-button11(a3),d0/d1
	subq	#1,d0
	bsr.b	.dru

	movem	button20-button11(a3),d0/d1
	addq	#6,d0
	bsr.b	.dru
	bra.b	.dru0

.dru
	addq	#4,d0
	add	#11,d1

	movem	d0/d1,-(sp)
	move.l	rastport(a5),a1
	lore	GFX,Move
	movem	(sp)+,d0/d1
	addq	#6,d0
	move.l	rastport(a5),a1
	jmp	_LVODraw(a6)

.dru0
 endc



	popm	all


	bsr.w	inforivit_clear


	tst	boxsize(a5)		* filebox
	beq.b	.b
	moveq	#28+WINX,plx1
	move	#253+WINX,plx2
	moveq	#61+WINY,ply1
	move	#128+WINY,ply2
	add	windowleft(a5),plx1
	add	windowleft(a5),plx2
	add	boxy(a5),ply2
	add	windowtop(a5),ply1
	add	windowtop(a5),ply2
	move.l	rastport(a5),a1
	bsr.w	laatikko1
.b
	moveq	#5+WINX,plx1		* infobox
	move	#254+WINX,plx2
	moveq	#10+WINY,ply1
	moveq	#29+WINY,ply2
	add	windowleft(a5),plx1
	add	windowleft(a5),plx2
	add	windowtop(a5),ply1
	add	windowtop(a5),ply2
	move.l	rastport(a5),a1
	bsr.w	laatikko2



	tst	playingmodule(a5)
	bmi.b	.npl
	bsr.w	inforivit_play

	tst.b	playing(a5)
	bne.b	.npl
	bsr.w	inforivit_pause

.npl	st	hippoonbox(a5)
	bsr.w	shownames


.pienehko
	st	lootassa(a5)
	clr.b	wintitl2(a5)
	bsr.w	lootaa
	bsr.w	reslider

	move.l	windowbase(a5),a0
	bsr.b	setscrtitle
	move.l	keycheckroutine(a5),-(sp)
	rts
	

setboxy	move	boxsize(a5),d0
	subq	#8,d0
	muls	#8,d0

	tst	boxsize(a5)
	bne.b	.x
	subq	#6,d0

.x	move	d0,boxy(a5)
	rts


front	pushm	all
	move.l	windowbase(a5),d7
	beq.b	.q
.a	move.l	d7,a0
	lore	Intui,WindowToFront
	move.l	d7,a0
	lob	ActivateWindow
	move.l	d7,a0
	bsr.w	get_rt
	move.l	wd_WScreen(a0),a0
	lob	rtScreenToFrontSafely
.qq	popm	all
	rts

.q	bsr.w	avaa_ikkuna2	
	move.l	windowbase(a5),d7
	bne.b	.a
	bra.b	.qq

unlockscreen
	tst.b	uusikick(a5)
	beq.b	.q
	move.l	screenlock(a5),a1
	sub.l	a0,a0
	lore	Intui,UnlockPubScreen
.q	rts



*******************************************************************************
* Asettaa ikkunan screentitlen
* a0 = windowbase
setscrtitle
	pushm	d0/d1/a0/a1/a6
	lea	-1.w,a1
	lea	scrtit(pc),a2
	lore	Intui,SetWindowTitles
	popm	d0/d1/a0/a1/a6
	rts



*******************************************************************************
* Sulkee ikkunan
*******
sulje_ikkuna
	tst.b	win(a5)
	bne.b	.x
.uh	rts
.x	
	bsr.w	flush_messages
	
	move.l	appwindow(a5),d0
	beq.b	.noapp
	move.l	d0,a0
	lore	WB,RemoveAppWindow
	clr.l	appwindow(a5)
.noapp
;	bsr	freepens

	move.l	_IntuiBase(a5),a6		
	move.l	windowbase(a5),d0
	beq.b	.uh
	move.l	d0,a0

	tst.b	kokolippu(a5)
	bne.b	.big
	move.l	4(a0),windowpos2(a5)	* Pienen ikkunan koordinaatit
	bra.b	.small
.big	move.l	4(a0),windowpos(a5)	* Ison ikkunan koordinaatit
.small
	move.l	46(a0),a1		* WB screen addr
	move	14(a1),wbkorkeus(a5)	* WB:n korkeus
	clr.l	windowbase(a5)
	jmp	_LVOCloseWindow(a6)
;.uh	rts



;freepens
;	move.l	(a5),a0
;	cmp	#39,LIB_VERSION(a0)
;	blo.b	.q
;	move.l	screenlock(a5),a3
;	lea	sc_ViewPort(a3),a3
;	move.l	vp_ColorMap(a3),a3	* ColorMappi
;	move.l	pen_0(a5),d0
;	bsr.b	.burb
;	move.l	pen_1(a5),d0
;	bsr.b	.burb
;	move.l	pen_2(a5),d0
;	bsr.b	.burb
;	move.l	pen_3(a5),d0
;	bsr.b	.burb
;.q	rts
;.burb	move.l	a3,a0
;	lore	GFX,ReleasePen
;	rts



******************************************************************************
* WaitPointer
**************

pon1	pushm	all
	move.l	windowbase(a5),d0
	bra.b	pon0

pon2	pushm	all
	move.l	windowbase2(a5),d0

pon0	beq.b	.q
	move.l	d0,a0
	bsr.w	get_rt
	lob	rtSetWaitPointer
.q	popm	all
	rts

poff1	pushm	all
	move.l	windowbase(a5),d0
	bra.b	poff0

poff2	pushm	all
	move.l	windowbase2(a5),d0

poff0	beq.b	.q
	move.l	d0,a0
	lore	Intui,ClearPointer
.q	popm	all
	rts


******************************************************************************
* Grafiikkaa *
**************
* Hipon tulostaminen

inithippo
*** Lasketaan checksummi infoikkunan no-onelle ja unregistered-tekstille.

	check	1

	lea	omabitmap2(a5),a2
	move.l	a2,a0
	moveq	#2,d0
	moveq	#96,d1
	moveq	#66,d2
	lore	GFX,InitBitMap
	move.l	#hippohead,bm_Planes(a2)
	move.l	#hippohead+792,bm_Planes+4(a2)
	rts

 ifeq zoom
* tavallinen hipon p��
printhippo1
	tst	boxsize(a5)
	beq.b	.q
	tst.b	win(a5)
	beq.b	.q
	tst.b	uusikick(a5)
	bne.b	.yep
.q	rts
.yep
	pushm	d0-d7/a0-a2/a6
	move.b	reghippo(a5),d7
	clr.b	reghippo(a5)

;	cmp.b	#' ',keyfile(a5)
;	bne.b	.az
;	moveq	#0,d7
;.az


	moveq	#0,d0		* l�hde x,y
	moveq	#0,d1
	moveq	#66,d5		* y-koko

	moveq	#76+WINY-14,d3
	move	boxsize(a5),d6
	subq	#8,d6
	bmi.b	.r
	beq.b	.rr
	subq	#1,d6
	beq.b	.rrr
	lsl	#2,d6
	add	d6,d3
.rrr
	moveq	#0,d1
.rr
	lea	omabitmap2(a5),a0
	move.l	rastport(a5),a1		* main
	moveq	#92,d2		* kohde x
	tst.b	d7
	beq.b	.e
	move	#150,d2
.e
	add	windowleft(a5),d2
	add	windowtop(a5),d3
;	move	#$ee,d6		* minterm, kopio a or d ->d
	move	#$c0,d6		* minterm, suora kopio
	moveq	#96,d4		* x-koko
	lore	GFX,BltBitMapRastPort
.r	popm	d0-d7/a0-a2/a6
	rts
 else

printhippo1
* zoomaava hipon p��
	tst.b	win(a5)
	beq.b	.q
	tst.b	uusikick(a5)
	bne.b	.yep
.q	rts
.yep
	pushm	all
	move.b	reghippo(a5),d7
	clr.b	reghippo(a5)

	lea	-(bm_SIZEOF+bsa_SIZEOF)(sp),sp
	move.l	sp,a4
	lea	bm_SIZEOF(a4),a3

	move.l	sp,a0
	moveq	#(bm_SIZEOF+bsa_SIZEOF)/2-1,d0
.cl	clr	(a0)+
	dbf	d0,.cl

	tst	boxsize(a5)
	beq.w	.r

	move.l	#224,d0
	move.l	#400*2,d1		* 2 planea
	lore	GFX,AllocRaster
	tst.l	d0
	beq.w	.r
	move.l	d0,a2

	move.l	a4,a0
	moveq	#2,d0
	move	#220,d1		* leveys 220
	move	#400,d2		* korkeus 400
	lob	InitBitMap
	move.l	a2,bm_Planes(a4)
	lea	(224/8)*400(a2),a0
	move.l	a0,bm_Planes+4(a4)


* alkup. x: 96, y: 66
* max  x: 220, y: 400

	moveq	#96,d0
	moveq	#66,d1

	move	d0,bsa_SrcWidth(a3)
	move	d1,bsa_SrcHeight(a3)
	move	d0,bsa_XSrcFactor(a3)
	move	d1,bsa_YSrcFactor(a3)
	move	d0,bsa_XDestFactor(a3)
	move	d1,bsa_YDestFactor(a3)

	move.l	a4,bsa_DestBitMap(a3)
	pushpea	omabitmap2(a5),bsa_SrcBitMap(a3)


	move.l	windowbase(a5),a0
	move	wd_Height(a0),d0
	sub	#88,d0

	move	d0,bsa_YDestFactor(a3)

	move	d0,d1
	add	#30,d1

	move	#220,d2
	tst.b	d7
	beq.b	.ne0
	moveq	#94,d2
.ne0

	cmp	d2,d1
	blo.b	.e
	move	d2,d1
.e
	move	d1,bsa_XDestFactor(a3)

	move.l	a3,a0
	lob	BitMapScale


	moveq	#0,d0		* l�hde x
	moveq	#0,d1		* y
	moveq	#79+1,d3	* y
	move	bsa_DestWidth(a3),d4
	move	bsa_DestHeight(a3),d5


	move	#32+220/2+3,d2	* kohde x
	move	d4,d6
	lsr	#1,d6
	sub	d6,d2

	tst.b	d7
	beq.b	.ne
	move	#160,d2
.ne


	move.l	a4,a0
	move.l	rastport(a5),a1		* main
	add	windowleft(a5),d2
	add	windowtop(a5),d3
	move	#$ee,d6		* minterm, kopio a or d ->d
	lob	BltBitMapRastPort

	move.l	a2,d0
	beq.b	.r
	move.l	a2,a0
	move.l	#224,d0
	move.l	#400*2,d1		* 2 planea
	lob	FreeRaster

.r	
	
	lea	(bm_SIZEOF+bsa_SIZEOF)(sp),sp
	
	popm	all
	rts
 endc
	

printhippo2
	tst.b	uusikick(a5)
	bne.b	.yep
	rts
.yep	pushm	d0-d6/a0-a2/a6
	lea	omabitmap2(a5),a0
	move.l	rastport3(a5),a1		* quad
	moveq	#0,d0	
	moveq	#0,d1
	moveq	#126,d2
	moveq	#14,d3
	moveq	#96,d4	
	moveq	#66,d5

	add	windowleft(a5),d2
	add	windowtop(a5),d3
;	move	#$ee,d6			* D: A or D
	move	#$c0,d6			* suora kopio
	lore	GFX,BltBitMapRastPort
	popm	d0-d6/a0-a2/a6
	rts


*********

initkorva
	lea	omabitmap4(a5),a2
	move.l	a2,a0
	moveq	#2,d0
	moveq	#16,d1
	moveq	#4,d2
	lore	GFX,InitBitMap
	move.l	#korvadata,bm_Planes(a2)
	move.l	#korvadata+8,bm_Planes+4(a2)
	rts

initkorva2
	lea	omabitmap5(a5),a2
	move.l	a2,a0
	moveq	#2,d0
	moveq	#16,d1
	moveq	#4,d2
	lore	GFX,InitBitMap
	move.l	#korvadata2,bm_Planes(a2)
	move.l	#korvadata2+8,bm_Planes+4(a2)
	rts

* d2 = x
* d3 = y

printkorva2
	pushm	d0-d7/a0-a2/a6
	move.l	rastport2(a5),a1	* prefs
	lea	omabitmap4(a5),a2
	bra.b	pkor

printkorva
	tst.b	win(a5)
	bne.b	.q
	rts
.q
	pushm	d0-d7/a0-a2/a6
	move.l	rastport(a5),a1		* main
	lea	omabitmap5(a5),a2
	tst.b	uusikick(a5)
	bne.b	pkor
	lea	omabitmap4(a5),a2	* kick13: korva ilman tausta patternia

pkor
	movem	gg_LeftEdge(a0),d2/d3
	add	gg_Width(a0),d2
	subq	#4,d2

	moveq	#0,d0		* l�hde x,y
	moveq	#0,d1
	moveq	#5,d4		* x-koko
	moveq	#4,d5		* y-koko

	move	#$c0,d6		* minterm, suora kopio a->d
	move.l	a2,a0
	lore	GFX,BltBitMapRastPort
.r	popm	d0-d7/a0-a2/a6
	rts


******** Tick-merkki

inittick
	lea	omabitmap3(a5),a2
	move.l	a2,a0
	moveq	#1,d0			* planes
	moveq	#16,d1			* lev
	moveq	#7,d2			* kork
	lore	GFX,InitBitMap
	move.l	#tickdata,bm_Planes(a2)
	rts

* d0 = <>0: aseta merkki, muutoin tyhjenn� alue
* d2/d3 = kohde x,y

tickaa	pushm	d0-d6/a0-a2/a6

	move	#$c0,d6			* suora kopio
;	move	#$ee,d6			* D: A or D
	tst.b	d0
	bne.b	.set
	moveq	#$0a,d6		* clear
.set

	movem	gg_LeftEdge(a0),d2/d3
	addq	#7,d2
	addq	#2+1,d3
	
	lea	omabitmap3(a5),a0
	move.l	rastport2(a5),a1		* prefs
	moveq	#0,d0				* l�hde x,y
	moveq	#0,d1
	moveq	#16,d4				* koko x,y
	moveq	#7,d5
;	add	windowleft(a5),d2
;	add	windowtop(a5),d3
	lore	GFX,BltBitMapRastPort
	popm	d0-d6/a0-a2/a6
	rts




*******************************************************************************
* Merkkijonon muotoilu
*******
desmsg	movem.l	d0-d7/a0-a3/a6,-(sp)
	lea	desbuf(a5),a3	;puskuri
ulppa	move.l	sp,a1		* parametrit ovat t��ll�!
pulppa	lea	putc(pc),a2	;merkkien siirto
	move.l	(a5),a6
	lob	RawDoFmt
	movem.l	(sp)+,d0-d7/a0-a3/a6
	rts
putc	move.b	d0,(a3)+	
	rts


desmsg2	movem.l	d0-d7/a0-a3/a6,-(sp)
	lea	desbuf2(a5),a3
	bra.b	ulppa

* a3 = desbuf
desmsg3	movem.l	d0-d7/a0-a3/a6,-(sp)
	bra.b	ulppa

* a3 = desbuf
* a1 = parametrit
desmsg4	movem.l	d0-d7/a0-a3/a6,-(sp)
	bra.b	pulppa


*******************************************************************************
* Laatikoiden piirto
*******

* Taalla bugaa joku, kun kaatuu P96 ja MCP

* d0 = x1
* d1 = y1
* d2 = x2
* d3 = y2



** bevelboksit, reunat kaks pixeli�

laatikko1
	move.l	pen_2(a5),d3
	move.l	pen_1(a5),d2
	bra.b	laatikko0


laatikko2
	move.l	pen_1(a5),d3
	move.l	pen_2(a5),d2
;	bra.b	laatikko0



laatikko0
	move.l	a1,a3
	move	d2,a4
	move	d3,a2

** valkoset reunat

	move	a2,d0
	move.l	a3,a1
	lore	GFX,SetAPen

	move	plx2,d0		* x1
	subq	#1,d0		
	move	ply1,d1		* y1
	move	plx1,d2		* x2
	move	ply1,d3		* y2
	bsr.w	drawli

	move	plx1,d0		* x1
	move	ply1,d1		* y1
	move	plx1,d2
	addq	#1,d2
	move	ply2,d3
	bsr.w	drawli
	
** mustat reunat

	move	a4,d0
	move.l	a3,a1
	lob	SetAPen

	move	plx1,d0
	addq	#1,d0
	move	ply2,d1
	move	plx2,d2
	move	ply2,d3
	bsr.b	drawli

	move	plx2,d0
	move	ply2,d1
	move	plx2,d2
	move	ply1,d3
	bsr.b	drawli

	move	plx2,d0
	subq	#1,d0
	move	ply1,d1
	addq	#1,d1
	move	plx2,d2
	subq	#1,d2
	move	ply2,d3
	bsr.b	drawli

looex	move.l	pen_1(a5),d0
	move.l	a3,a1
	jmp	_LVOSetAPen(a6)


** bevelboksi, reunat 1 pix

laatikko3
	move.l	a1,a3
	move.l	pen_2(a5),a2
	move.l	pen_1(a5),a4

	move	a4,d0
	move.l	a3,a1
	lore	GFX,SetAPen

	move	plx1,d0
	move	ply2,d1
	move	plx1,d2
	move	ply1,d3
	bsr.b	drawli

	move	plx1,d0
	move	ply1,d1
	move	plx2,d2
	move	ply1,d3
	bsr.b	drawli

	move	a2,d0
	move.l	a3,a1
	lob	SetAPen

	move	plx2,d0
	move	ply1,d1
	addq	#1,d1
	move	plx2,d2
	move	ply2,d3
	bsr.b	drawli

	move	plx2,d0
	move	ply2,d1
	move	plx1,d2
	addq	#1,d2
	move	ply2,d3
	bsr.b	drawli

	bra.b	looex



drawli	cmp	d0,d2
	bhi.b	.e
	exg	d0,d2
.e	cmp	d1,d3
	bhi.b	.x
	exg	d1,d3
.x	move.l	a3,a1
	move.l	_GFXBase(a5),a6
	jmp	_LVORectFill(a6)


** muikea sliderkehys



sliderlaatikko
;	rts
	
	move.l	a1,a3
	move.l	pen_1(a5),a2
	move.l	pen_2(a5),a4

** valkoset reunat

	move	a4,d0
	move.l	a3,a1
	lore	GFX,SetAPen

	move	plx2,d0
	move	ply1,d1
	move	plx1,d2
	move	ply1,d3
	bsr.b	drawli

	move	plx1,d0
	move	ply1,d1
	move	plx1,d2
	move	ply2,d3
	bsr.b	drawli

	move	plx1,d0
	addq	#2,d0
	move	ply2,d1
	subq	#1,d1
	move	plx2,d2
	subq	#1,d2
	move	ply2,d3
	subq	#1,d3
	bsr.b	drawli

	move	plx2,d0
	subq	#1,d0
	move	ply2,d1
	subq	#1,d1
	move	plx2,d2
	subq	#1,d2
	move	ply1,d3
	addq	#2,d3
	bsr.b	drawli

** mustat

	move	a2,d0
	move.l	a3,a1
	lob	SetAPen

	move	plx2,d0
	move	ply1,d1
	addq	#1,d1
	move	plx2,d2
	move	ply2,d3
	bsr.b	drawli

	move	plx2,d0
	move	ply2,d1
	move	plx1,d2
	addq	#1,d2
	move	ply2,d3
	bsr.w	drawli

	move	plx1,d0
	addq	#1,d0
	move	ply2,d1
	move	plx1,d2
	addq	#1,d2
	move	ply1,d3
	addq	#1,d3
	bsr.w	drawli

	move	plx1,d0
	addq	#1,d0
	move	ply1,d1
	addq	#1,d1
	move	plx2,d2
	subq	#1,d2
	move	ply1,d3
	addq	#1,d3
	bsr.w	drawli

	bra.w	looex


*******************************************************************************
* Tyhjent�� alueen ikkunasta
*******
* d0 = x1
* d1 = y1
* d2 = x2
* d3 = y2
tyhjays
	tst.b	win(a5)
	beq.b	.q
	movem.l	d0-a6,-(sp)
	sub	d0,d2
	sub	d1,d3
	move	d2,d4
	move	d3,d5
	addq	#1,d4
	addq	#1,d5
 	move.l	rastport(a5),a0
	move.l	a0,a1
	add	windowleft(a5),d0
	add	windowtop(a5),d1
	move	d0,d2
	move	d1,d3
	moveq	#$0a,d6
	lore	GFX,ClipBlit
	movem.l	(sp)+,d0-a6
.q	rts


*******************************************************************************
* Pullautetaan ikkuna p��limm�iseksi
*******
poptofront
	movem.l	d0-a6,-(sp)
	lea	var_b,a5
	move	#$25,rawkeyinput(a5)
	tst.b	win(a5)
	beq.b	.now
	clr	rawkeyinput(a5)
.now	move.b	ownsignal7(a5),d1
	bsr.w	signalit
	movem.l	(sp)+,d0-a6
	rts


*******************************************************************************
* Muistin k�sittely�
*******
* d0=koko
* d1=tyyppi
getmem	movem.l	d1/d3/a0/a1/a6,-(sp)
	addq.l	#4,d0
	move.l	d0,d3
	move.l	4.w,a6
	lob	AllocMem
	tst.l	d0
	beq.b	.err
	move.l	d0,a0
	move.l	d3,(a0)+
	move.l	a0,d0
.err	movem.l	(sp)+,d1/d3/a0/a1/a6
	rts

* a0=osoite
freemem	movem.l	d0/d1/a0/a1/a6,-(sp)
	move.l	a0,d0
	beq.b	.n
	move.l	-(a0),d0
	move.l	a0,a1
	move.l	4.w,a6
	lob	FreeMem
.n	movem.l	(sp)+,d0/d1/a0/a1/a6
	rts


;freeearly
;	pushm	all

;	move.l	(a5),a6
;	move.l	earlymoduleaddress(a5),d0
;	beq.b	.ee
;	move.l	d0,a1
;	move.l	earlymodulelength(a5),d0
;	beq.b	.ee

;	lob	FreeMem
;	clr.l	earlymoduleaddress(a5)
;	clr.l	earlymodulelength(a5)

;.ee	
;	move.l	earlytfmxsamples(a5),d0
;	beq.b	.eee
;	tst.b	earlylod_tfmx(a5)
;	bne.b	.cl
;	move.l	d0,a1
;	move.l	earlytfmxsamlen(a5),d0
;	lob	FreeMem
;.cl	clr.l	earlytfmxsamples(a5)
;	clr.l	earlytfmxsamlen(a5)
;	clr.b	earlylod_tfmx(a5)
;.eee	
;	popm	all
;	rts




freemodule
	movem.l	d0-a6,-(sp)


	clr.b	modulename(a5)
	clr.b	moduletype(a5)
	clr.b	kelausnappi(a5)
	clr.b	do_early(a5)
	clr.b	oldst(a5)
	clr.b	sidflag(a5)
	clr	ps3minitcount
	clr.b	ahi_use_nyt(a5)

	clr	pos_maksimi(a5)
	clr	pos_nykyinen(a5)
;	st	positionmuutos(a5)
	clr	positionmuutos(a5)
	clr	songnumber(a5)
;	bsr.w	lootaa
	bsr.w	inforivit_clear


	lea	ps3mroutines(a5),a0		* vapautetaan replayeri
	jsr	freereplayer

	move.l	(a5),a6
	move.l	moduleaddress(a5),d0
	beq.b	.ee
	move.l	d0,a1
	move.l	modulelength(a5),d0
	beq.b	.ee

	lob	FreeMem				* hit!
	clr.l	moduleaddress(a5)
	clr.l	modulelength(a5)

	tst.l	keyfile+44(a5)	* datan v�lilt� 38-50 pit�� olla nollia
	beq.b	.zz
	move.l	tempexec(a5),a0
	addq.l	#1,IVVERTB+IV_DATA(a0)
;	jsr	flash
.zz

	bsr.w	sulje_foo	

.ee	
	move.l	tfmxsamplesaddr(a5),d0
	beq.b	.eee

	cmp	#pt_tfmx,playertype(a5)
	beq.b	.na
	cmp	#pt_tfmx7,playertype(a5)
	bne.b	.naw
.na

	move.l	d0,a1
	move.l	tfmxsampleslen(a5),d0
	lob	FreeMem
.naw	clr.l	tfmxsamplesaddr(a5)
	clr.l	tfmxsampleslen(a5)
	clr.b	lod_tfmx(a5)

.eee	


	movem.l	(sp)+,d0-a6
	rts

	

*******************************************************************************
* Volumen feidaus
********
fadevolumedown
	movem.l	d1-a6,-(sp)
	move	mainvolume(a5),d7
	move	d7,d6

	tst.b	fade(a5)
	beq.b	.nop
	tst	playingmodule(a5)
	bmi.b	.nop
	tst.b	playing(a5)
	beq.b	.nop
	move.l	playerbase(a5),a0
	moveq	#pf_volume,d0
	and	p_liput(a0),d0
	beq.b	.nop

	cmp	#pt_multi,playertype(a5)	* onko ps3m?
	bne.b	.loop
	move.l	priority(a5),d5
	move.b	#10,priority+3(a5)
	bsr.w	mainpriority
.loop
	moveq	#1,d1
	lore	Dos,Delay

	move	d6,mainvolume(a5)
	move.l	playerbase(a5),a0
	jsr	p_volume(a0)
	subq	#1,d6
	cmp	#-1,d6
	bne.b	.loop

	cmp	#pt_multi,playertype(a5)	* onko ps3m?
	bne.b	.nop
	move.l	d5,priority(a5)
	bsr.b	mainpriority

.nop	

	

	move	d7,d0
	movem.l	(sp)+,d1-a6
	rts


fadevolumeup
	movem.l	d1-a6,-(sp)
	move	mainvolume(a5),d7
	addq	#1,d7
	moveq	#0,d6

	tst.b	fade(a5)
	beq.b	.nop
	tst	playingmodule(a5)
	bmi.b	.nop
	tst.b	playing(a5)
	beq.b	.nop
	move.l	playerbase(a5),a0
	moveq	#pf_volume,d0
	and	p_liput(a0),d0
	beq.b	.nop

	cmp	#pt_multi,playertype(a5)	* onko ps3m?
	bne.b	.loop
	move.l	priority(a5),d5
	move.b	#10,priority+3(a5)
	bsr.b	mainpriority
.loop
	moveq	#1,d1
	lore	Dos,Delay

	move	d6,mainvolume(a5)
	move.l	playerbase(a5),a0
	jsr	p_volume(a0)
	addq	#1,d6
	cmp	d6,d7
	bne.b	.loop

	cmp	#pt_multi,playertype(a5)	* onko ps3m?
	bne.b	.nop
	move.l	d5,priority(a5)
	bsr.b	mainpriority

.nop	
	movem.l	(sp)+,d1-a6
	rts


*******************************************************************************
* Asettaa p��ohjelman prioriteetin
******** 

mainpriority
	pushm	d0/d1/a0/a1/a6
	move.l	owntask(a5),a1		* asetetaan p��ohjelman prioriteetin
	move.l	priority(a5),d0
	lore	Exec,SetTaskPri
	popm	d0/d1/a0/a1/a6
	rts




******************************************************************************
* Hiiren nappeja painettiin
*******

buttonspressed
	tst.b	win(a5)			* onko ikkuna auki?
	beq.w	.nowindow

	cmp	#SELECTDOWN,d3		* vasen nappula
	beq.w	.left
	cmp	#MENUDOWN,d3		* oikea
	bne.w	returnmsg

* Oikeata nappulaa painettu. Tutkitaan oliko rmbfunktio-nappuloiden p��ll�

	tst.b	kokolippu(a5)		* onko pienen�?
	beq.w	.nowindow

** onko lootan p��ll�
	move	mousex(a5),d0
	move	mousey(a5),d1
	sub	windowleft(a5),d0
	sub	windowtop(a5),d1	* suhteutus fonttiin

	cmp	#7+WINX,d0
	blo.b	.y
	cmp	#70+WINX,d0	* 247
	bhi.b	.y
	cmp	#10+WINY,d1
	blo.b	.y
	cmp	#30+WINY,d1
	bhi.b	.y

	tst	quad_prosessi(a5)	* jos ei ollu, p��lle
	bne.b	.rew
	bsr.w	start_quad		
	bra.w	returnmsg
.rew	bsr.w	sulje_quad		* suljetaan jos oli auki
	bra.w	returnmsg
.y


	movem	button11+4,d0-d3	* new
	bsr.w	.namiska
	bne.b	.eipa2
	bsr.w	rbutton9	* clr list
	bra.w	returnmsg
.eipa2

	movem	button20+4,d0-d3	* prefs
	bsr.w	.namiska
	bne.b	.eipa1
	bsr.w	zoomfilebox	* fileboxi pois/p��lle
	bra.w	returnmsg
.eipa1


	movem	lilb2+4,d0-d3		* sort-gadgetti
	bsr.w	.namiska
	bne.b	.eip
	bsr.w	find_new	* search
	bra.w	returnmsg
.eip
	movem	lilb1+4,d0-d3		* move-gadgetti
	bsr.w	.namiska
	bne.b	.eip1
	bsr.w	add_divider	* add divider
	bra.w	returnmsg	
.eip1

	movem	button7+4,d0-d3		* add-gadgetti
	bsr.w	.namiska
	bne.b	.eip3
	bsr.w	rinsert		* insert
	bra.w	returnmsg
.eip3

	movem	plg+4,d0-d3		* load prg
	bsr.w	.namiska
	bne.b	.eip2
	bsr.w	rsaveprog	* load prg
	bra.w	returnmsg
.eip2


	movem	kela2+4,d0-d3		* >
	bsr.w	.namiska
	bne.b	.eip4
	bsr.w	rbutton_kela2_turbo
	bra.w	returnmsg
.eip4

	movem	button8+4,d0-d3		* del
	bsr.w	.namiska
	bne.b	.eip5
	bsr.w	hiiridelete	* nuke file
	bra.w	returnmsg
.eip5

	movem	button2+4,d0-d3		* i
	bsr.b	.namiska
	bne.b	.eip6
	bsr.w	rbutton10	* toggle about
	bra.w	returnmsg
.eip6

	movem	button1+4,d0-d3		* play
	bsr.b	.namiska
	bne.b	.eip7
	bsr.w	soitamodi_random * soita randomi
	bra.w	returnmsg
.eip7


.nowindow

	tst.b	uusikick(a5)
	bne.b	.new
	bsr.w	sulje_ikkuna		* Vaihdetaan ikkunan kokoa (kick1.3)
	bsr.w	avaa_ikkuna
	bra.w	returnmsg

.new	move.l	windowbase(a5),a0	* Kick2.0+
	lore	Intui,ZipWindow
	bra.w	returnmsg

.left	

;	tst	modamount(a5)
;	beq.w	returnmsg

* jos oli lootan p��ll� niin avataan info ikkuna!
	move	mousex(a5),d0
	move	mousey(a5),d1
	sub	windowleft(a5),d0
	sub	windowtop(a5),d1	* suhteutus fonttiin

	cmp	#7+WINX,d0
	blo.b	.x
	cmp	#70+WINX,d0	* 247
	bhi.b	.x
	cmp	#10+WINY,d1
	blo.b	.x
	cmp	#30+WINY,d1
	blo.b	.yea

.x	bsr.w	markline		* merkit��n modulenimi
	bra.w	returnmsg

.yea

** modinfon infon avaus
	bsr.b	modinfoaaa
	bra.w	returnmsg


*** tutkitaan hiiren napin painamista gadgetin p��ll�
.namiska
	move	mousex(a5),d6
	move	mousey(a5),d7
	subq	#1,d3
	add	d0,d2
	add	d1,d3
	cmp	d0,d6
	blo.b	.xx
	cmp	d2,d6
	bhi.b	.xx
	cmp	d1,d7
	blo.b	.xx
	cmp	d3,d7
	bhi.b	.xx
	moveq	#0,d0			* kelpaa
	rts
.xx	moveq	#-1,d0
	rts


*** Zoomataan fileboxi pois tai takasin

zoomfilebox
	move	boxsize(a5),d0
	beq.b	.z
	clr	boxsize(a5)
	move	d0,boxsizez(a5)
	bra.b	.x
.z
	move	boxsizez(a5),boxsize(a5)
.x
	bsr.w	setprefsbox
	move.b	ownsignal2(a5),d1
	bra.w	signalit		* prefsp�ivitys-signaali
	

modinfoaaa
	tst	info_prosessi(a5)
	beq.b	.zz
	move.l	infotaz(a5),a0		* jos oli jo modinfo niin suljetaan
	cmp.l	#about_t,a0
	beq.b	.rrz
	bsr.w	sulje_info
	bra.b	.xz
.rrz
	bsr.w	start_info
	bra.b	.xz

.zz	clr.b	infolag(a5)
	bsr.w	rbutton10b
.xz	rts


*******************************************************************************
* Omaan viestiporttiin tuli viesti
******
omaviesti
	pushm	all
	lea	hippoport(a5),a0
	lore	Exec,GetMsg
	tst.l	d0
	beq.w	.huh
	move.l	d0,a1
	move.l	a1,omaviesti0(a5)

	cmp.l	#"KILL",MN_LENGTH+2(a1)	* ????????
	beq.w	.killeri

	cmp.l	#"K-P!",MN_LENGTH+4(a1)
	beq.w	.oma

	cmp.l	#'AppW',am_UserData(a1)		* Onko AppWindow-viesti?
	beq.b	.appw

** Screennotify-viesti.
	movem.l	snm_Type(a1),d3/d4
	cmp.l	#SCREENNOTIFY_TYPE_WORKBENCH,d3
	bne.w	.huh
	tst.l	d4
	bne.b	.open

	tst.b	win(a5)			* HIDE!
	beq.w	.huh
	bsr.w	sulje_ikkuna
	clr.b	win(a5)
	bsr.w	sulje_prefs
	jsr	sulje_quad
	bsr.w	sulje_info
	bra.w	.huh

.open	
	tst.b	win(a5)
	bne.w	.huh
	bsr.w	openw
	bra.w	.huh


.appw
** AppWindow-viesti!!

	move.l	am_NumArgs(a1),d7	* argsien m��r�
	cmp	#20,d7			* max. 10 kappaletta
	bls.b	.oe
	moveq	#20,d7
.oe	subq	#1,d7
	move.l	am_ArgList(a1),a3	* args
	lea	sv_argvArray+4(a5),a4

	move.l	#4000,d0		* 20 nime�,  � 200 merkki�
	moveq	#MEMF_PUBLIC,d1		* varataan muistia
	bsr.w	getmem
	move.l	d0,appnamebuf(a5)
	beq.b	.huh			* ERROR!
	move.l	d0,a2

.addfiles
.getname
	move.l	wa_Lock(a3),d1
	move.l	a2,d2
	moveq	#100,d3			* max pituus
	push	a2
	lore	Dos,NameFromLock
	pop	a2
	tst.l	d0
	beq.b	.error
	move.l	a2,(a4)+
.fe	tst.b	(a2)+
	bne.b	.fe
	subq	#1,a2
	cmp.b	#':',-1(a2)
	beq.b	.na
	move.b	#'/',(a2)+
.na	move.l	wa_Name(a3),a0
.cp	move.b	(a0)+,(a2)+
	bne.b	.cp

.file

.error
	lea	200(a2),a2
	addq	#wa_SIZEOF,a3
	dbf	d7,.addfiles
.lop	clr.l	(a4)
	bra.b	.app


* oma viesti saapui!
.oma
	move.l	MN_LENGTH(a1),a0	* uudet parametrit
	lea	sv_argvArray(a5),a2
.c	move.l	(a0)+,(a2)+
	bne.b	.c

	move.l	sv_argvArray+4(a5),a0
	bsr.w	kirjainta4
	cmp.l	#"QUIT",d0
	bne.b	.app
	st	exitmainprogram(a5)
	bra.b	.huh

.app
	bsr.w	komentojono		* tutkitaan uudet komennot
.huh	bsr.b	vastomaviesti


.he	popm	all
	rts

.killeri
	st	exitmainprogram(a5)
	bra.b	.he



vastomaviesti
	pushm	d0/d1/a0/a1/a6
	move.l	omaviesti0(a5),d0
	beq.b	.x
	clr.l	omaviesti0(a5)
	move.l	d0,a1
	lore	Exec,ReplyMsg
.x	move.l	appnamebuf(a5),a0
	bsr.w	freemem
	clr.l	appnamebuf(a5)
	popm	d0/d1/a0/a1/a6
	rts


*******************************************************************************
* Oman signaalin vastaanotto (moduuli soitettu, jatkotoimenpiteet)
*******
signalreceived

	moveq	#1,d7			* menn��n listassa eteenp�in

	cmp.b	#pm_random,playmode(a5)	* Arvotaanko j�rjestys?
	bne.b	.norand

** Onko subsongeja soiteltavaks?
	move.l	playerbase(a5),a0
	move	p_liput(a0),d0
	btst	#pb_song,d0
 	beq.b	.ran
	move	songnumber(a5),d0
	cmp	maxsongs(a5),d0
	bne.w	rbutton13		* next song!

.ran	bra.w	.karumeininki
.norand


	cmp.b	#pm_repeatmodule,playmode(a5) * Jatketaanko soittoa?
	beq.w	.reet

	cmp	#1,modamount(a5) * Jos vain yksi modi ja repeatti p��ll�,
	bne.b	.notone		* jatketaan soittoa keskeytyksett�.
	cmp	#$7fff,playingmodule(a5) * Listassa yksi modi, joka on uusi.
	bne.b	.oon			* Soitetaan se.
	moveq	#0,d7			* ei lis�t� eik� v�hennet�
	bra.b	.notone
.oon

	cmp.b	#pm_repeat,playmode(a5)
	bne.b	.notone

** Onko subsongeja soiteltavaks?
	move.l	playerbase(a5),a0
	move	p_liput(a0),d0
	btst	#pb_song,d0
 	beq.w	.reet
	move	songnumber(a5),d0
	cmp	maxsongs(a5),d0
	bne.w	rbutton13		* next song!

	bra.w	.reet


.notone

	tst	playingmodule(a5)	* soitettiinko edes mit��n
	bmi.w	.err

	cmp.b	#pm_module,playmode(a5)
	beq.w	.stop

** Onko subsongeja soiteltavaks?
	move.l	playerbase(a5),a0
	move	p_liput(a0),d0
	btst	#pb_song,d0
 	beq.b	.eipa
	move	songnumber(a5),d0
	cmp	maxsongs(a5),d0
	bne.w	rbutton13		* next song!
	

.eipa
	clr.b	playing(a5)		* soitto seis
	move.l	playerbase(a5),a0	* stop module
	jsr	p_end(a0)

	bsr.w	freemodule

	tst	modamount(a5)		* onko modeja?
	beq.w	.err

.opg
	cmp	#$7fff,playingmodule(a5) * Lista tyhj�tty? Soitetaan eka modi.
	bne.b	.eekk
	moveq	#0,d7
	clr	chosenmodule(a5)
.eekk
	add	d7,chosenmodule(a5)	* lis�t��n valittuun moduulin 1 tai -1
	move	chosenmodule(a5),d0
	bpl.b	.repea			* meni yli listan alkup��st�?
	cmp	#-1,d0			* valitaan listan viimeinen
	bne.w	.err
	move	modamount(a5),chosenmodule(a5)
	subq	#1,chosenmodule(a5)

.repea	move	chosenmodule(a5),playingmodule(a5)
	move	playingmodule(a5),d0

	st	hippoonbox(a5)
	bsr.w	resh

* etsit��n vastaava listasta tiedoston nimi

	lea	listheader(a5),a4
.luuppo
	TSTNODE	a4,a3
	beq.b	.erer			* loppuivatko modit??
	move.l	a3,a4
	dbf	d0,.luuppo

	cmp.b	#'�',l_filename(a3)	* onko divideri??
	bne.b	.wasfile
	tst	d7			* pit�� olla jotain ett� ei j�� 
	bne.b	.eekk			* jummaamaan dividerin kohdalle
	moveq	#1,d7
	bra.b	.eekk
.wasfile



	lea	l_filename(a3),a0	* ladataan
	move.l	l_nameaddr(a3),solename(a5)
	moveq	#0,d0			* no dbuf
	jsr	loadmodule
	tst.l	d0
	bne.b	.loader


	move.l	playerbase(a5),a0	* soitto p��lle
	jsr	p_init(a0)
	tst.l	d0
	bne.b	.mododo

	bsr.w	settimestart
.reet0	st	playing(a5)
	bsr.w	inforivit_play
	bsr.w	start_info

.reet
	rts

.loader	
	move	#-1,playingmodule(a5)	* latausvirhe
	bra.b	.reet

.mododo	move	#-1,playingmodule(a5)	* initti virhe
	bsr.w	init_error
	bra.b	.reet

.err	move	#-1,playingmodule(a5)	* ei modeja mit� soittaa
	move	#-1,chosenmodule(a5)
	rts

.stop  	bsr.w	rbutton3		* stop!
	bra.b	.reet


* modit loppui, mit� tehd��n?
.erer	move	#-1,playingmodule(a5)

	cmp.b	#pm_through,playmode(a5)
	bne.b	.hm
	move	modamount(a5),chosenmodule(a5)
	subq	#1,chosenmodule(a5)
	bsr.w	resh
	bra.b	.reet

.hm	clr	playingmodule(a5)	* Alotetaan alusta
	clr	chosenmodule(a5)
	bra.w	.repea



* Shuffle-soitto
.karumeininki
	move	modamount(a5),d0
	beq.b	.reet		* jos ei yht��n, jatketaan entisen soittoa
	cmp	#1,d0		* Jos vain yksi, jatketaan soittoa
	beq.b	.reet
	bra.w	soitamodi2



satunnaismodi
	move	modamount(a5),d0
	
	cmp	#1,d0
	bhi.b	.nof
	clr	chosenmodule(a5)
	rts
.nof
	cmp	#8192,d0		* jos liikaa, ei yll�pidet� listaa
	bhi.b	.onviela

	subq	#1,d0

.h	bsr.b	testrandom
	beq.b	.onviela
	dbf	d0,.h

	bsr.b	clear_random
	bra.b	satunnaismodi

.onviela
	move	modamount(a5),d3
	subq	#1,d3
.a	bsr.w	getrandom
	cmp	d3,d1
	bhi.b	.a

	move	d1,d0
	bsr.b	testrandom
	bne.b	.a
	bsr.b	setrandom

	move	d1,chosenmodule(a5)
.reet	rts


clear_random
	pushm	all

** taulukko tyhj�ks
	lea	randomtable(a5),a0
	move	#1024/4-1,d0
.c	clr.l	(a0)+
	dbf	d0,.c

	cmp.b	#pm_random,playmode(a5)
	bne.b	.x

	lea	listheader(a5),a4
.l	TSTNODE	a4,a3
	beq.b	.xx
	move.l	a3,a4
	clr.b	l_rplay(a3)
	bra.b	.l

.xx
	st	hippoonbox(a5)
	bsr.w	shownames
.x

	popm	all
	rts


* d0 = numero
testrandom
	movem.l	d0/d1/a0,-(sp)
	bsr.b	rando
	btst	d1,(a0,d0)
	movem.l	(sp)+,d0/d1/a0
	rts

rando	move	d0,d1
	lsr	#3,d0
;	not	d1
	lea	randomtable(a5),a0
	rts

setrandom
	pushm	all
	push	d0
	bsr.b	rando
	bset	d1,(a0,d0)

	pop	d0

	cmp.b	#pm_random,playmode(a5)
	bne.b	.x

	lea	listheader(a5),a4
.l	TSTNODE	a4,a3
	beq.b	.x
	move.l	a3,a4
	dbf	d0,.l
	st	l_rplay(a3)
	st	hippoonbox(a5)
.x

	popm	all
	rts


srand   
	move.l	4.w,a6
	moveq	#MEMF_PUBLIC,d1
	lob	AvailMem
	add.l	ThisTask(a6),d0

	lea	$dff000,a1
	add.l	4(a1),d0      ; Initialize random generator.. Call once
        add.l   2(a1),d0
	lea	$dc0000,a0
	add.l	(a0)+,d0
	add.l	(a0)+,d0
	add.l	(a0)+,d0
	add.l	(a0),d0

	moveq	#0,d1
	move.b	$bfec01,d1
;	add.l	d1,d0
	rol.l	d1,d0

	move	$a(a1),d1	* joy0dat
	add	d1,d0
	move	$c(a1),d1	* joy1dat
	add	d1,d0
	move	$1a(a1),d1	* dskbytr
	add	d1,d0
	move	$18(a1),d1	* serdatr
	add	d1,d0

        move.l  d0,seed(a5)
        rts

getrandom
	push	d0
	move.l  seed(a5),d0     ; Returns random number (result: d0 = 0-32767)
        move.l  #$41c64e6d,d1
        bsr.b	mulu_32
        add.l   #$3039,d0
        move.l  d0,seed(a5)
        moveq   #$10,d1
        lsr.l   d1,d0
 ;       and.l   #$7fff,d0
        and     #$fff,d0
	move	d0,d1
	pop	d0
        rts



* mulu_32 --- d0 = d0*d1
mulu_32	movem.l	d2/d3,-(sp)
	move.l	d0,d2
	move.l	d1,d3
	swap	d2
	swap	d3
	mulu	d1,d2
	mulu	d0,d3
	mulu	d1,d0
	add	d3,d2
	swap	d2
	clr	d2
	add.l	d2,d0
	movem.l	(sp)+,d2/d3
	rts	

* divu_32 --- d0 = d0/d1, d1=jakoj��nn�s
divu_32	move.l	d3,-(a7)
	swap	d1
	tst	d1
	bne.b	.lb_5f8c
	swap	d1
	move.l	d1,d3
	swap	d0
	move	d0,d3
	beq.b	.lb_5f7c
	divu	d1,d3
	move	d3,d0
.lb_5f7c	swap	d0
	move	d0,d3
	divu	d1,d3
	move	d3,d0
	swap	d3
	move	d3,d1
	move.l	(a7)+,d3
	rts	

.lb_5f8c	swap	d1
	move	d2,-(a7)
	moveq	#16-1,d3
	move	d3,d2
	move.l	d1,d3
	move.l	d0,d1
	clr	d1
	swap	d1
	swap	d0
	clr	d0
.lb_5fa0	add.l	d0,d0
	addx.l	d1,d1
	cmp.l	d1,d3
	bhi.b	.lb_5fac
	sub.l	d3,d1
	addq	#1,d0
.lb_5fac	dbf	d2,.lb_5fa0
	move	(a7)+,d2
	move.l	(a7)+,d3
	rts	



******************************************************************************
* Soitamoduuli *
****************

soitamodi_random
	moveq	#1,d5
	moveq	#0,d6
	bra.b	umph
	
soitamodi2
	moveq	#-1,d6
	moveq	#0,d5
	bra.b	umph
soitamodi
	moveq	#0,d6
	moveq	#0,d5
umph	
;	cmp.b	#$7f,do_early(a5)	* early load p��ll�? disable!
;	beq	.ags
	
	tst	d5
	bne.b	.raaps

	cmp.b	#pm_random,playmode(a5)	* onko satunnaissoitto?
	bne.b	.bere
.raaps	bsr.w	satunnaismodi
	moveq	#0,d7
.bere

	add	d7,chosenmodule(a5)
	bpl.b	.e			* meni yli listan alkup��st�?
	move	modamount(a5),d0
	add	d0,chosenmodule(a5)
.e
	move	chosenmodule(a5),d0
	cmp	modamount(a5),d0
	blt.b	.ee
	sub	modamount(a5),d0
	move	d0,chosenmodule(a5)
.ee

	move	chosenmodule(a5),d0
	move	d0,d2
	bsr.w	setrandom		* Merkataan listaan..

;	st	hippoonbox(a5)
	bsr.w	resh


* etsit��n listasta vastaava tiedosto
	lea	listheader(a5),a4
.luuppo
	TSTNODE	a4,a3
	beq.w	.erer
	move.l	a3,a4
	dbf	d0,.luuppo

	cmp.b	#'�',l_filename(a3)	* onko divideri?
	beq.b	umph			* kokeillaan edellist�/seuraavaa/rnd

	cmp	playingmodule(a5),d2	* onko sama kuin juuri soitettava??
	bne.b	.new

* on!



	bsr.w	halt			* soitetaan vaan alusta
	move.l	playerbase(a5),a0
	jsr	p_end(a0)
	move.l	playerbase(a5),a0
	jsr	p_init(a0)
	tst.l	d0
	bne.w	.inierr


	st	playing(a5)		* Ei varmaan tuu initerroria
	bsr.w	inforivit_play
	bsr.w	settimestart
	bsr.w	start_info
.ags	rts
	
.new
	moveq	#0,d7
	tst	playingmodule(a5)	* Oliko soitettavana mit��n?
	bmi.b	.nomod

	tst	d6			* ei fadea jos signalreceivedist�
	bne.b	.hm1

;	tst.b	do_early(a5)	
;	beq.b	.norl
;	tst.b	earlyload(a5)		* onko earlyload?
;	bne.b	.early
;.norl

	move.b	doublebuf(a5),d7	* onko doublebuffering?
	bne.b	.nomod

	bsr.w	fadevolumedown
	move	d0,-(sp)
.hm1

	bsr.w	halt			* Vapautetaan se jos on
	move.l	playerbase(a5),a0
	jsr	p_end(a0)
	bsr.w	freemodule	

	tst	d6
	bne.b	.hm2
	move	(sp)+,mainvolume(a5)
.hm2

.nomod
	move	d2,playingmodule(a5)	* Uusi numero

	lea	l_filename(a3),a0	* Ladataan
	move.l	l_nameaddr(a3),solename(a5)

	move.b	d7,d0
	jsr	loadmodule
	tst.l	d0
	bne.b	.loader


	move.l	playerbase(a5),a0
	jsr	p_init(a0)
	tst.l	d0
	bne.b	.inierr

	bsr.w	settimestart
.reet0	st	playing(a5)
	bsr.w	inforivit_play
	bsr.w	start_info

.erer
;	bsr.w	shownames
	rts

.loader	
	move	#-1,playingmodule(a5)
	rts


.inierr	
	move	#-1,playingmodule(A5)	* initvirhe
	bra.w	init_error
;	rts


*** Early load

;.early
;	move.b	#$7f,do_early(a5)	* Next/Prev/Play soittavat
					* nyt ladatun piisin

* vanhat talteen
;	move.l	moduleaddress(a5),earlymoduleaddress(a5)
;	move.l	modulelength(a5),earlymodulelength(a5)
;	move.l	tfmxsamplesaddr(a5),earlytfmxsamples(a5)
;	move.l	tfmxsampleslen(a5),earlytfmxsamlen(a5)
;	move.b	lod_tfmx(a5),earlylod_tfmx(a5)


;	lea	l_filename(a3),a0	* Ladataan
;	move.l	l_nameaddr(a3),solename(a5)
;	moveq	#MEMF_CHIP,d0
;	lea	moduleaddress(a5),a1
;	lea	modulelength(a5),a2
;	moveq	#0,d1			* kommentti talteen
;	bsr.w	loadfile
;	tst.l	d0
;	beq	.ok

;	bsr	freeearly
;	clr.b	do_early(a5)
;	bra	loaderr

;.ok	bsr	inforivit_play
;	rts	


*******************************************************************************
* Asetataan arvot propgadgeteille
*******
nupit

* volume
	lea	slider1,a0
	move	#65535/64,d0		* 65535/max
	bsr.w	setknob
 ifeq EFEKTI
;	move	#65535*64/64,d0		* 65535*arvo/max
	moveq	#-1,d0
 else
	moveq	#0,d0
 endc
	bsr.w	setknob2

;	lea	slider4,a0
	lea	slider4-slider1(a0),a0
	move.l	gg_SpecialInfo(a0),a1
	move	#65535/1,pi_VertBody(a1)
;	move	#0,pi_VertPot(a1)
	clr	pi_VertPot(a1)

* mixingrate s3m
;	lea	pslider1,a0
	lea	pslider1-slider4(a0),a0
	moveq	#65535/(580-50),d0	* 65535/max
	bsr.w	setknob
	move	#65535*50/(580-50),d0	* 65535*arvo/max
	bsr.w	setknob2

* mixingrate tfmx
;	lea	pslider2,a0
	lea	pslider2-pslider1(a0),a0
	move	#65535/(22-1),d0		* 65535/max
	bsr.w	setknob
	move	#65535*11/21,d0		* 65535*arvo/max
	bsr.w	setknob2

* volumeboost s3m
;	lea	juusto,a0
	lea	juusto-pslider2(a0),a0
	move	#65535/9,d0
	bsr.w	setknob
;	move	#65535/9*0,d0
	moveq	#0,d0
	bsr.w	setknob2

* stereoarvo s3m
;	lea	juust0,a0
	lea	juust0-juusto(a0),a0
	move	#65535/64,d0
	bsr.w	setknob
;	move	#65535/32*0,d0
	moveq	#0,d0
	bsr.w	setknob2

* boxsize
;	lea	meloni,a0
	lea	meloni-juust0(a0),a0
	move	#65535/(51-3),d0		* 65535/max
	bsr.w	setknob
	move	#65535*(8-3)/(51-3),d0		* 65535*arvo/max
	bsr.w	setknob2

* infosize
;	lea	eskimO,a0
	lea	eskimO-meloni(a0),a0
	move	#65535/(50-3),d0		* 65535/max
	bsr.b	setknob
	move	#65535*(16-3)/(50-3),d0		* 65535*arvo/max
	bsr.b	setknob2

* timeout
;	lea	kelloke,a0
	lea	kelloke-eskimO(a0),a0
	move	#65535/1800,d0			* 65535/max
	bsr.b	setknob
;	move	#65535*0/1800,d0		* 65535*arvo/max
	moveq	#0,d0
	bsr.b	setknob2

* alarm
;	lea	kelloke2,a0
	lea	kelloke2-kelloke(a0),a0
	moveq	#65535/1440,d0			* 65535/max
	bsr.b	setknob
;	moveq	#65535*0/1440,d0		* 65535*arvo/max
	moveq	#0,d0
	bsr.b	setknob2

* samplebuffersize
;	lea	sIPULI,a0
	lea	sIPULI-kelloke2(a0),a0
	move	#65535/5,d0		* 65535/max
	bsr.b	setknob
;	move	#65535*0/3,d0		* 65535*arvo/max
	moveq	#0,d0
	bsr.b	setknob2

* sample forced sampling rate
;	lea	sIPULI2,a0
	lea	sIPULI2-sIPULI(a0),a0
	moveq	#65535/600,d0		* 65535/max
	bsr.b	setknob
;	move	#65535*0/600,d0		* 65535*arvo/max
	moveq	#0,d0
	bsr.b	setknob2



* ahi rate
;	lea	ahiG4,a0
	lea	ahiG4-sIPULI2(a0),a0
	moveq	#65535/(580-50),d0	* 65535/max
	bsr.b	setknob
	move	#65535*50/(580-50),d0	* 65535*arvo/max
	bsr.b	setknob2

* ahi mastervol
;	lea	ahiG5,a0
	lea	ahiG5-ahiG4(a0),a0
	moveq	#65535/1000,d0		* 65535/max
	bsr.b	setknob
	moveq	#65535*1/1000,d0	* 65535*arvo/max
	bsr.b	setknob2

* ahi stereolev
;	lea	ahiG6,a0
	lea	ahiG6-ahiG5(a0),a0
	move	#65535/100,d0		* 65535/max
	bsr.b	setknob
;	move	#65535*00,d0		* 65535*arvo/max
	moveq	#0,d0
	bsr.b	setknob2

* MED rate
	lea	nAMISKA5-ahiG6(a0),a0
	moveq	#65535/(580-50),d0	* 65535/max
	bsr.b	setknob
	move	#65535*50/(580-50),d0	* 65535*arvo/max
	bsr.b	setknob2
	rts


* Vert.. Horiz..

setknob	move.l	gg_SpecialInfo(a0),a1
	move	d0,pi_HorizBody(a1)
	rts
setknob2
	move.l	gg_SpecialInfo(a0),a1
	move	d0,pi_HorizPot(a1)
	rts



nappilasku
	move.l	gg_SpecialInfo(a2),a0
	mulu	pi_HorizPot(a0),d0
	add.l	#32767,d0
	divu	#65535,d0
	and.l	#$ffff,d0
	rts




*******************************************************************************
* Nappulaa painettu, tehd��n vastaava (gadgetti) toiminto
*******
* d3 = rawkey
* d4 = iequalifier

nappuloita
	and	#$ff,d3

	tst.b	d3
	bmi.w	returnmsg		* vain jos nappula alhaalla
	movem.l	d0-a6,-(sp)

	and.b	#IEQUALIFIER_LSHIFT!IEQUALIFIER_RSHIFT,d4
	beq.b	.noshifts


	cmp.b	#$17,d3		* i + shift?
	bne.b	.f0
	or.l	#WFLG_ACTIVATE,sflags
	bsr.w	rbutton10b
	bra.b	.ee
.f0
	cmp.b	#$41,d3		* backspace + shift?
	beq.b	.fid
	cmp.b	#$22,d3		* d + shift?
	bne.b	.fi
.fid	bsr.w	rbutton8b
	bra.b	.ee
.fi

	cmp.b	#$39,d3		* onko shift + fast forward?
	beq.b	.if
	cmp.b	#$1f,d3
	bne.b	.no1f
.if	bsr.w	rbutton_kela2_turbo
	bra.b	.ee
.no1f

.noshifts
	cmp.b	#$23,d3		* [F]ind
	bne.b	.not_f
	tst.b	d4
	bne.b	.fi_c
	bsr.w	find_new
	bra.b	.ee
.fi_c	bsr.w	find_continue
	bra.b	.ee

.not_f
	cmp.b	#$50,d3		* Oliko funktion�pp�imi�??
	blo.b	.f1
	cmp.b	#$59,d3
	bhi.b	.f1
	bsr.w	fkeyaction
	bra.b	.ee
.f1


	lea	.nabs(pc),a0	
.checke
	cmp	(a0)+,d3
	beq.b	.jee
	addq.l	#2,a0
	cmp.l	#.nabse,a0
	bne.b	.checke
.ee	movem.l	(sp)+,d0-a6
.sd	bra.w	returnmsg
.jee	
	move	(a0),d0
	add	d0,a0
	jsr	(a0)
	bra.b	.ee


* $13 r 	prefs

* return $44	play
* *, $2b (returnin vieress�) play random module
* ylos $4c	lista ylos
* alas $4d	lista alas

* vas $4f	prev song
* oik $4e	next song
* k $27 	prev 
* l $28		next 

* s $10		add divider

* n $36		new

* d $22		delete module
* backspace $41	delete module
* space $40	stop/cont
* esc $45	exit program
* tab $42	eject module
* < $38		prev pattern -
* > $39		next pattern \kelaus
* a $20		add modules

* v $34		volume down
* b $35		volume up


* help $5f	about etc.
* c $33		clear list
* ~` $0		window shrink/expand
* 7 7	show: time - poslen 0	
* 8 8	show: kello/memory 1
* 9 9	show: name 2
* 0 $a 	show: time/duration - poslen
* i $17		moduleinfo
* f1-f10 $50-$59	Funktio-lataussoitto
* w $11		save modprogram
* o $19	 	load modprogram
* h $25		hide!)
* [ $1a		join modprogram

* m $37		move
* t $14		insert
* s $21		sort

* z $31		scope toggle

* f $23		find module

* o $18		comment file

* g $24		play list repeatedly
* h $25		play mods in random order


********
* numeron�ppis
* [ ] / *
* 7 8 9 -
* 4 5 6 +
* 1 2 3 E
* 000 . E
* 4 - prev song 	$2d
* 6 - next song		$2f
* 8 - select prev	$3e
* 2 - select next	$1e
* 7 - play prev		$3d
* 9 - play next		$3f
* 1 - rewind		$1d
* 3 - fast forward	$1f
* 5 - stop/cont		$2e
* 0 - add mods		$f
* * - random play	$5d
* - - vol down		$4a
* + - vol up		$5e
* enter - return	$43
* . - load program	$3c
* [ - del mod		$5a
* ] - move mod		$5b
* / - insert		$5c


.nabs

	dc	$12
	dr	execuutti


	dc	$13
	dr	rbutton20

	dc	$36
	dr	rbutton11

	dc	$24
	dr	.pm1
	dc	$25
	dr	.pm2	

	dc	$31
	dr	.scopetoggle

	dc	$37
	dr	rmove
	dc	$14
	dr	rinsert
	dc	$21
	dr	rsort

	dc	$11
	dr	rsaveprog
	dc	$19
	dr	rloadprog
	dc	$1a
	dr	rloadprog0

	dc	$27
	dr	rbutton6	* prev
	dc	$28
	dr	rbutton5	* next
	dc	$4f
	dr	.pso		* prev song
	dc	$4e
	dr	.nso		* next song

	dc	7
	dr	.showtime
	dc	8
	dr	.showclock
	dc	9
	dr	.showname
	dc	$a
	dr	.showtime2

	dc	$45
	dr	.qui

	dc	$44
	dr	rbutton1

	dc	$40
	dr	stopcont

	dc	$22
	dr	rbutton8
	dc	$41
	dr	rbutton8

	dc	$42
	dr	rbutton4

	dc	$38
	dr	rbutton_kela1
	dc	$39
	dr	rbutton_kela2

	dc	$4c
	dr	lista_ylos

	dc	$4d
	dr	lista_alas

	dc	$33
	dr	rbutton9

	dc	$20
	dr	rbutton7

	dc	$34
	dr	.voldown
	dc	$35
	dr	.volup

	dc	$5f
	dr	rbutton10
	dc	$17
	dr	.infoo

	dc	0
	dr	.ocl

	dc	$2b
	dr	.rand

	dc	$10
	dr	add_divider

	dc	$18
	dr	comment_file

*** Numeron�ppis


	dc	$2d
	dr	.pso		* prev song
	dc	$2f
	dr	.nso		* next song
	dc	$3e
	dr	lista_ylos	* select prev
	dc	$1e
	dr	lista_alas	* select next
	dc	$3d
	dr	rbutton6	* play prev
	dc	$3f
	dr	rbutton5	* play next
	dc	$1d
	dr	rbutton_kela1	* rewind
	dc	$1f
	dr	rbutton_kela2	* fast forward
	dc	$2e
	dr	stopcont	* stop/cont
	dc	$f
	dr	rbutton7	* add
	dc	$5d
	dr	.rand		* play random mod
	dc	$4a
	dr	.voldown	* volume down
	dc	$5e
	dr	.volup		* volume up
	dc	$43
	dr	rbutton1	* play
	dc	$3c	
	dr	rloadprog	* load program
	dc	$5a
	dr	rbutton8	* del mod
	dc	$5b
	dr	rmove		* move mod
	dc	$5c
	dr	rinsert		* insert mods


.nabse

.pso	move.l	playerbase(a5),a0
	move	p_liput(a0),d0
	btst	#pb_song,d0
	bne.w	rbutton12
	rts

.nso	move.l	playerbase(a5),a0
	move	p_liput(a0),d0
	btst	#pb_song,d0
	bne.w	rbutton13
	rts


.rand	bra.w	soitamodi_random


.qui	st	exitmainprogram(a5)
	rts

.ocl	bra.w	zippowi



.showtime
	clr	lootamoodi(a5)
	bra.w	lootaa
.showclock
	move	#1,lootamoodi(a5)
	bra.w	lootaa
.showname
	move	#2,lootamoodi(a5)
	bra.w	lootaa
.showtime2
	move	#3,lootamoodi(a5)
	bra.w	lootaa


.scopetoggle
	tst	quad_prosessi(a5)	* jos ei ollu, p��lle
	beq.w	start_quad		
	bra.w	sulje_quad		* suljetaan jos oli auki


.pm1	move.b	#pm_repeat,playmode(a5)	* playmode pikan�pp�imet
.pm0	st	hippoonbox(a5)
	bra.w	shownames
.pm2	move.b	#pm_random,playmode(a5)
	bra.b	.pm0

*** Volume nappuloilla c ja v
.volup
	move	mainvolume(a5),d0
	addq	#1,d0
	cmp	#64,d0
	bls.b	.vol
	moveq	#64,d0
	bra.b	.vol
.voldown
	move	mainvolume(a5),d0
	subq	#1,d0
	bpl.b	.vol
	moveq	#0,d0
.vol
	move	slider1+gg_Flags,d1
	and	#GFLG_DISABLED,d1
	beq.b	.vo1
	rts

.vo1	move	d0,mainvolume(a5)
	bne.b	.ere
	moveq	#1,d0
.ere	bra.w	volumerefresh


.infoo
** modinfon infon avaus
	tst	info_prosessi(a5)
	beq.b	.zz
	move.l	infotaz(a5),a0		* jos oli jo modinfo niin suljetaan
	cmp.l	#about_t,a0
	beq.b	.rrz
	bsr.w	sulje_info
	bra.b	.xz
.rrz	bra.w	start_info
.zz	clr.b	infolag(a5)
	bsr.w	rbutton10b
.xz	rts



** stop/continue

stopcont
	tst.b	playing(a5)
	beq.w	rbutton2
	bra.w	rbutton3


lista_ylos				* shiftin kanssa nopeempi!
	moveq	#1,d0
	and	#IEQUALIFIER_LSHIFT!IEQUALIFIER_RSHIFT,d4
	beq.b	.nsh
	tst	boxsize(a5)
	beq.b	.nsh
	move	boxsize(a5),d0
	lsr	#1,d0
.nsh
	sub	d0,chosenmodule(a5)
	bpl.b	.oe
	move	modamount(a5),chosenmodule(a5)
	subq	#1,chosenmodule(a5)
.oe	bra.w	resh

lista_alas
	moveq	#1,d0
	and	#IEQUALIFIER_LSHIFT!IEQUALIFIER_RSHIFT,d4
	beq.b	.nsh
	tst	boxsize(a5)
	beq.b	.nsh
	move	boxsize(a5),d0
	lsr	#1,d0
.nsh
	add	d0,chosenmodule(a5)
	move	modamount(a5),d0
	cmp	chosenmodule(a5),d0
	bhi.b	.ee
	clr	chosenmodule(a5)
.ee	bra.w	resh


********* Window zip

zippowi	tst.b	uusikick(a5)
	bne.b	.newo
	bsr.w	sulje_ikkuna		* Vaihdetaan ikkunan kokoa
	bra.w	avaa_ikkuna
.newo	move.l	windowbase(a5),a0	* Kick2.0+
;	lore	Intui,ZipWindow
	move.l	_IntuiBase(a5),a6
	jmp	_LVOZipWindow(a6)

************************************** Funktion�pp�imet!

fkeyaction
	sub.b	#$50,d3
	ext	d3
	mulu	#120,d3
	lea	fkeys(a5),a0
	add.l	d3,a0
	tst.b	(a0)
	bne.b	.oli
	rts

.oli	move.l	a0,sv_argvArray+4(a5)		* Parametri!
	clr.l	sv_argvArray+8(a5)

	bsr.w	rbutton9		* freelist & shownames
	bsr.w	rbutton4		* EJECT!

	bra.w	komentojono			* tutkitaan komentojono.


*******************************************************************************
* Jotain gadgettia painettu, tehd��n vastaava toiminto
*******



gadgetsup
	tst.b	freezegads(a5)
	bne.w	returnmsg


	movem.l	d0-a6,-(sp)
	move	gg_GadgetID(a2),d0
gups	add	d0,d0
	lea	.gadlist-2(pc,d0),a0
	add	(a0),a0
	jsr	(a0)
	movem.l	(sp)+,d0-a6
	bra.w	returnmsg

.gadlist	
	dr	rbutton1	* play
	dr	modinfoaaa	* modinfo toggle
	dr	stopcont	* stop/continue
	dr	rbutton4	* eject
	dr	rbutton5	* next
	dr	rbutton6	* prev
	dr	rbutton7	* add
	dr	rbutton8	* del
	dr	rslider1	* volume
	dr	rslider4	* fileselector
	dr	rbutton13	* Prev Song
	dr	rbutton12	* Next Song
	dr	rbutton11	* New
	dr	rbutton20	* Prefs
	dr	rbutton_kela1	* Taaksekelaus
	dr	rbutton_kela2	* Eteenkelaus
	dr	rloadprog	* ohjelman lataus
	dr	rmove		* move
	dr	rsort		* sort



** a0 = teksti, d0 = x-koordinaatti
printbox
	tst.b	win(a5)
	beq.b	.q
	tst	boxsize(a5)
	bne.b	.p
.q	rts
.p	pushm	d0/a0
	bsr.w	clearbox		* fileboxi tyhj�ks
	popm	d0/a0
	moveq	#69+WINY,d1	
	move	boxsize(a5),d2
	lsr	#1,d2
	subq	#1,d2
	lsl	#3,d2
	add	d2,d1
	bra.w	print


*******************************************************************************
* Sortti
*******
rsort
	cmp	#2,modamount(a5)
	bhs.b	.so
	rts
.so
	bsr.w	pon1
	addq.b	#1,freezegads(a5)		* gadgetit jumiin!

	lea	.t(pc),a0
	moveq	#102+WINX,d0
	bsr.b	printbox
	bra.b	.d
.t	dc.b	"Sorting...",0
 even


.d

	move	modamount(a5),d0
	mulu	#4+24,d0		* noden osoite ja paino
	addq.l	#8,d0			* tyhj�� per��n
	move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
	bsr.w	getmem
	move.l	d0,sortbuf(a5)
	bne.b	.okr
	lea	memerror_t,a1
	bsr.w	request
	bra.w	.error
.okr

	move.l	d0,a2


** Lasketaan painot jokaiselle
	move	modamount(a5),d7
	subq	#1,d7
	lea	listheader(a5),a3

* paino 24 bytee

	move.l	(a3),a3		* MLH_HEAD
.ploop
	tst.l	(a3)		* Oliko viimeinen
	beq.b	.ep
	move.l	(a3),a4
	move.l	a3,(a2)+	* noden osoite taulukkoon

	push	a2
	move.l	l_nameaddr(a3),a2	
	bsr.w	.getv
	pop	a2
	movem.l	d0-d5,(a2)	* paino talteen
	lea	24(a2),a2

	move.l	a3,a1		* poistetaan node (a1)
	REMOVE
	
	move.l	a4,a3
	bra.b	.ploop
.ep


	move.l	sortbuf(a5),a3

.ml	moveq	#0,d5		* 1. sortattava node
	moveq	#0,d6		* viimeinen sortattava node

	bsr.b	.eka
	bne.b	.loph

	move.l	a3,d5

	bsr.w	.toka

	move.l	a3,d7
	sub.l	d5,d7		* montako nodea sortataan
	divu	#28,d7

;	subq	#1,d7		* 1 pois (listan loppu tai seuraava divideri)
	cmp	#2,d7		* v�h 2 kpl
	blo.b	.ml

	move.l	d5,a2
	bsr.w	.sort
	bra.b	.ml


.loph
	move.l	sortbuf(a5),a3

.er
	tst.l	(a3)
	beq.b	.r
	move.l	(a3),a1

	lea	listheader(a5),a0
	ADDTAIL			* lis�t��n node (a1)

	lea	28(a3),a3
	bra.b	.er
.r

	move.l	sortbuf(a5),a0
	bsr.w	freemem

.error


	bsr.w	clear_random
	tst	playingmodule(a5)
	bmi.b	.npl
	move	#$7fff,playingmodule(a5)
.npl	clr	chosenmodule(a5)
	st	hippoonbox(a5)
	subq.b	#1,freezegads(a5)
	bsr.w	poff1
	bra.w	resh

* a3 = lista
* Hakee ensimm�isen nimen, joka ei ole divideri



.eka
.ploop2
	tst.l	(a3)		* Oliko viimeinen
	beq.b	.ep2
	move.l	(a3),a0
	move.l	l_nameaddr(a0),a0	
	cmp.b	#'�',(a0)		* eka hitti
	bne.b	.jep1
	lea	28(a3),a3
	bra.b	.ploop2

.ep2	moveq	#-1,d0
	rts
.jep1	moveq	#0,d0
	rts

* Hakee dividerin tai listan lopun a3:een

.toka
.ploop3
	tst.l	(a3)		* Oliko viimeinen
	beq.b	.jep1
	move.l	(a3),a0
	move.l	l_nameaddr(a0),a0
	cmp.b	#'�',(a0)		* toka hitti
	beq.b	.jep1
	lea	28(a3),a3
	bra.b	.ploop3


*--------------------

.sort
	pushm	all
	bsr.b	.sort0
	popm	all
	rts

.sort0

	move.l	a2,a0
	ext.l	d7
	moveq	#28,d5
	moveq	#1,d4

; Comb sort the array.

;	Lea.l	List(Pc),a0
;	Move.l	#ListSize,d7	; Number of values

	Move.l	d7,d1		; d1=Gap
.MoreSort
	MoveQ	#0,d0		; d0=Switch
	lsl.l	#8,d1
	Divu.w	#333,d1		; 1.3*256 = 332.8
;	And.l	#$ffff,d1	; gap=gap/1.3
	ext.l	d1

	Cmp.w	d4,d1		; if gap<1 then gap:=1
	Bpl.b	.okgap
	Moveq	#1,d1
.okgap:
	Move.l	d7,d2		; d2=Top
	Sub.l	d1,d2		; D2=NMAX-gap
	Move.l	a0,a1

;	Lea.l	(a1,d1.w*2),a2	; a2=a1+gap
	move	d1,d6
	mulu	d5,d6
	lea	(a1,d6.l),a2

	Subq.w	#1,d2
.Loop:	

	move.l	4(a1),d3
	cmp.l	4(a2),d3
	bne.b	.notokval
	move.l	8(a1),d3
	cmp.l	8(a2),d3
	bne.b	.notokval
	move.l	12(a1),d3
	cmp.l	12(a2),d3
	bne.b	.notokval
	move.l	16(a1),d3
	cmp.l	16(a2),d3
	bne.b	.notokval
	move.l	20(a1),d3
	cmp.l	20(a2),d3
	bne.b	.notokval
	move.l	24(a1),d3
	cmp.l	24(a2),d3
	beq.b	.okval
.notokval
	bmi.b	.okval

;	Move.w	(a1)+,d3
;	Cmp.w	(a2)+,d3
;	Bmi	.okval
;	Beq	.okval

;	Move.w	-2(a1),d3	; swap
;	Move.w	-2(a2),-2(a1)
;	Move.w	d3,-2(a2)


** vaihto

	move.l	(a1),d6
	move.l	(a2),(a1)+
	move.l	d6,(a2)+

	move.l	(a1),d6
	move.l	(a2),(a1)+
	move.l	d6,(a2)+

	move.l	(a1),d6
	move.l	(a2),(a1)+
	move.l	d6,(a2)+

	move.l	(a1),d6
	move.l	(a2),(a1)+
	move.l	d6,(a2)+

	move.l	(a1),d6
	move.l	(a2),(a1)+
	move.l	d6,(a2)+

	move.l	(a1),d6
	move.l	(a2),(a1)+
	move.l	d6,(a2)+

	move.l	(a1),d6
	move.l	(a2),(a1)+
	move.l	d6,(a2)+

	Moveq	#1,d0
	bra.b	.ok1

.okval:
	add.l	d5,a1
	add.l	d5,a2
.ok1

	Dbf	d2,.Loop

	Cmp.w	d4,d1		; gap < 1 ?
	Bne.w	.MoreSort
	Tst.w	d0		; Any entries swapped ?
	Bne.w	.MoreSort
	Rts




*-------------------

.getv	
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2

	cmp.b	#'�',(a2)
	bne.b	.boobo
	rts
.boobo
	move.l	a2,a0
	bsr.w	cut_prefix
	move.l	a0,a2

	bsr.b	.bah2
	move.l	d5,d0
	bsr.b	.bah2
	move.l	d5,d1
	bsr.b	.bah2
	move.l	d5,d2
	bsr.b	.bah2
	move.l	d5,d3
	bsr.b	.bah2
	move.l	d5,d4
;	bsr.b	.bah2
;	rts

.bah2
	moveq	#4-1,d6
.g1	bsr.b	.bah
	move.b	d7,d5
	rol.l	#8,d5
	dbf	d6,.g1
	ror.l	#8,d5
	rts

.bah	tst.b	(a2)
	beq.b	.z
	move.b	(a2)+,d7
	cmp.b	#'a',d7
	blo.b	.j
	cmp.b	#'z',d7
	bhi.b	.j
	and.b	#$df,d7
.j	rts
.z	clr.b	d7
	rts


*******************************************************************************
* Move
*******
rmove
	tst.b	movenode(a5)	* Jos toistamiseen painetaan, menn��n "play"hin
	bne.w	rbutton1

	cmp	#2,modamount(a5)
	blo.b	.qq
	bsr.b	getcurrent
	beq.b	.q
	move.l	a3,nodetomove(a5)
	st	movenode(a5)
	move.l	a3,a1
	lore	Exec,Remove
	subq	#1,modamount(a5)
	bsr.w	clear_random
	tst	playingmodule(a5)
	bmi.b	.q
	move	#$7fff,playingmodule(a5)
.q	st	hippoonbox(a5)
	bsr.w	resh
.qq	rts


*** Chosenmodule node A3:een
getcurrent
	tst	modamount(a5)
	beq.b	.q
	move	chosenmodule(a5),d0
	bpl.b	getcurrent2
.q	moveq	#0,d0
	rts

* d0 = mik� moduuli
getcurrent2

* etsit��n listasta vastaava kohta
	lea	listheader(a5),a4
.luuppo
	TSTNODE	a4,a3
	beq.b	.q
	move.l	a3,a4
	dbf	d0,.luuppo
* a3 = valittu nimi
	moveq	#1,d0
	rts
.q	moveq	#0,d0
	rts



*******************************************************************************
* Comment file
*******

comment_file
	bsr.b	getcurrent
	beq.b	.x
	move.l	a3,a4

** kaapataan vanha kommentti

	moveq	#0,d4
	pushpea	l_filename(a3),d1
	moveq	#ACCESS_READ,d2
	lore	Dos,Lock
	move.l	d0,d4
	beq.b	.ne

	move.l	d4,d1
	pushpea	fileinfoblock(a5),d2
	lob	Examine

	move.l	d4,d1
	beq.b	.ne
	lob	UnLock
.ne

	bsr.w	get_rt
	lea	-90(sp),sp

** initial string
	lea	fileinfoblock+fib_Comment(a5),a0
	move.l	sp,a1
.c	move.b	(a0)+,(a1)+
	bne.b	.c

	move.l	sp,a1
	moveq	#79,d0		* max chars
	sub.l	a3,a3
	lea	ftags(pc),a0
	lea	.ti(pc),a2
	bsr.w	pon1
	lob	rtGetStringA
	tst.l	d0
	beq.b	.xx

	pushpea	l_filename(a4),d1
	move.l	sp,d2
	lore	Dos,SetComment
	
.xx	bsr.w	poff1
	lea	90(sp),sp
.x	rts

.ti	dc.b	"Enter file comment",0
 even

	

*******************************************************************************
* Find module
*******

find_new
	cmp	#3,modamount(a5)
	bhi.b	.ok
	rts
.ok
	bsr.w	get_rt
	lea	findpattern(a5),a1	
	moveq	#27,d0
	sub.l	a3,a3
	lea	ftags(pc),a0
	lea	.ti(pc),a2
	bsr.w	pon1
	lob	rtGetStringA
	bsr.w	poff1
	tst.l	d0
	bne.b	find_continue	
	rts

.ti	dc.b	"Enter search pattern",0
 even

ftags
	dc.l	RTGS_Width,262
	dc.l	RT_TextAttr,text_attr
otag15	dc.l	RT_PubScrName,pubscreen+var_b
	dc.l	TAG_END
	


find_continue
	cmp	#3,modamount(a5)
	bhi.b	.ok
	rts
.ok
	bsr.w	pon1
	pea	poff1(pc)
;	bsr.b	.o
;	bsr.w	poff1
;	rts
;.o
	bsr.w	getcurrent		* a3 => chosen module listnode

	move	chosenmodule(a5),d7
;	subq	#1,d7


	move	#$df,d2

;	lea	listheader(a5),a4
.luuppo
	addq	#1,d7
	TSTNODE	a4,a3
	beq.b	.qq
	move.l	a3,a4
	bsr.b	.find
	bne.b	.luuppo
	rts
.qq
* lista l�pi eik� l�ytyny. k�yd��n alusta l�ht�kohtaan.

	moveq	#-1,d7
	lea	listheader(a5),a4
.luuppo2
	addq	#1,d7
	cmp	chosenmodule(a5),d7
	beq.b	.q
	TSTNODE	a4,a3
	beq.b	.q
	move.l	a3,a4
	bsr.b	.find
	bne.b	.luuppo2

.q	rts


.find
	move.l	l_nameaddr(a3),a0

.flop1	lea	findpattern(a5),a1
	move.b	(a1)+,d0
	and.b	d2,d0

.flop2	move.b	(a0)+,d1
	beq.b	.notfound
	and.b	d2,d1
	cmp.b	d0,d1
	bne.b	.flop2
	
.flop3	move.b	(a1)+,d0
	beq.b	.found
	and.b	d2,d0
	move.b	(a0)+,d1
	beq.b	.notfound
	and.b	d2,d1
	cmp.b	d0,d1
;	bne.b	.flop1
;	beq.b	.f
	beq.b	.flop3
	subq	#1,a0
	bra.b	.flop1

;.f	bra.b	.flop3

.notfound
	moveq	#-1,d0
	rts

.found	
	move	d7,chosenmodule(a5)
	st	hippoonbox(a5)
	bsr.w	resh
	moveq	#0,d0
	rts


*******************************************************************************
* Kelaus
*******
rbutton_kela1
	tst.b	playing(a5)
	beq.b	.e
	tst	playingmodule(a5)
	bmi.b	.e
	move.l	playerbase(a5),a0
	jsr	p_taakse(a0)	
	st	kelattiintaakse(a5)
.e	rts

rbutton_kela2_turbo
	move.b	#1,kelausvauhti(a5)
	tst.b	playing(a5)
	beq.b	.e
	tst	playingmodule(a5)
	bmi.b	.e
	move.l	playerbase(a5),a0
	move	p_liput(a0),d0
	btst	#pb_ciakelaus2,d0
	beq.b	.nr
	not.b	kelausnappi(a5)
	rts

.nr	move.b	#2,kelausvauhti(a5)
	bra.b	rkelr

.e	rts


rbutton_kela2
	move.b	#1,kelausvauhti(a5)
rkelr

	tst.b	playing(a5)
	beq.b	.e
	tst	playingmodule(a5)
	bmi.b	.e
	move.l	playerbase(a5),a0
	move	p_liput(a0),d0
	btst	#pb_ciakelaus,d0
	beq.b	.norm
	not.b	kelausnappi(a5)
	rts

.norm	jmp	p_eteen(a0)	
.e	rts

*******************************************************************************
* New
*******
rbutton11
	st	new(a5)
;	bsr.w	rbutton9		* Clear list
	bra.w	rbutton1		* Play


*******************************************************************************
* P�ivitet��n propgadgetteja, kun liikutaan hiirell�
*******
mousemoving
	movem.l	d0-a6,-(sp)
	lea	slider1,a2
	bsr.w	rslider1
	lea	slider4,a2
	bsr.w	rslider4
	movem.l	(sp)+,d0-a6
	bra.w	returnmsg


*******************************************************************************
* Next
*******
rbutton5
	moveq	#1,d7		* liikutaan eteenp�in listassa
	bra.w	soitamodi

*******************************************************************************
* Prev
*******
rbutton6
	moveq	#-1,d7		* liikutaankin taakkep�in listassa
	bra.w	soitamodi


*******************************************************************************
* Song number <
*******
rbutton12
	moveq	#1,d1		* lis�t��n songnumberia

songo
	clr.b	kelausnappi(a5)

	move.l	playerbase(a5),a0

	move	songnumber(a5),d0	* Numeroita 0:sta eteenp�in
	sub	d1,d0
	bpl.b	.ook
	moveq	#0,d0
.ook	
	cmp	maxsongs(a5),d0
	blo.b	.jep
	move	maxsongs(a5),d0
.jep
	move	d0,songnumber(a5)


	tst	playingmodule(a5)
	bmi.b	.err

	st	kelattiintaakse(a5)
	clr.b	playing(a5)
	jsr	p_song(a0)
	st	playing(a5)
	st	kelattiintaakse(a5)
	bsr.w	settimestart

	bsr	inforivit_play
.err	
	bsr.w	lootaan_aika
.nosong
	rts


*******************************************************************************
* Song number >
*******
rbutton13
	moveq	#-1,d1			* v�hennet��n songnumberia
	bra.b	songo


******************************************************************************
* Stop
*******
rbutton3
	tst	playingmodule(a5)
	bpl.b	.hu
.hehe	rts
.hu	
	clr.b	kelausnappi(a5)

	move.l	playerbase(a5),a0
	moveq	#pf_stop,d0
	and	p_liput(a0),d0
	beq.b	.hehe

	bsr.w	fadevolumedown
	move	d0,-(sp)

	clr.b	playing(a5)
	move.l	playerbase(a5),a0
	jsr	p_stop(a0)

	move	(sp)+,mainvolume(a5)

	bra.w	inforivit_pause
;.hehe	rts

*******************************************************************************
* Cont
*******
rbutton2
	tst	playingmodule(a5)
	bpl.b	.hu
.hehe	rts
.hu	
	clr.b	kelausnappi(a5)

	move.l	playerbase(a5),a0
	moveq	#pf_cont,d0
	and	p_liput(a0),d0
	beq.b	.hehe

	st	playing(a5)
	move.l	playerbase(a5),a0
	jsr	p_cont(a0)

	bsr.w	fadevolumeup

	bra.w	inforivit_play
;	rts
	
*******************************************************************************
* Eject
*******
rbutton4b
	moveq	#1,d0
	bra.b	rbutton4a

rbutton4
	moveq	#0,d0
rbutton4a
	clr.b	kelausnappi(a5)

	tst	playingmodule(a5)
	bpl.b	.hu
	bra.w	freemodule
.hu	
	tst	d0
	bne.b	.nofa

	bsr.w	fadevolumedown

.nofa	move	d0,-(sp)

	bsr.w	halt
	move	#-1,playingmodule(a5)
	move.l	playerbase(a5),a0
	jsr	p_end(a0)

	bsr.w	freemodule
	move	(sp)+,mainvolume(a5)
	clr.b	movenode(a5)

;	bsr	freeearly
	rts


*******************************************************************************
* Tyhjennet��n moduulista
*******
clearlist
rbutton9
	clr.b	movenode(a5)
	bsr.w	freelist
	bra.w	shownames

*******************************************************************************
* Volumegadgetti
*******
rslider1
	move.l	gg_SpecialInfo(a2),a0
	move	pi_HorizPot(a0),d0
	cmp	slider1old(a5),d0
	bne.b	.new
	rts
.new	move	d0,slider1old(a5)
	moveq	#64,d0		* max
	bsr.w	nappilasku
	move	d0,mainvolume(a5)

	tst	playingmodule(a5)
	bmi.b	.ee
	move.l	playerbase(a5),a0
	jsr	p_volume(a0)
.ee	
	rts



*** D0 = volume
*** Uusi volumearvo ja sliderin p�ivitys
volumerefresh
	cmp	#64,d0
	blo.b	.r
	moveq	#64,d0
.r	move	d0,mainvolume(a5)

	mulu	#65535,d0
	divu	#64,d0
	lea	slider1,a0
	move.l	gg_SpecialInfo(a0),a1
	move	d0,d1

	tst.b	win(a5)
	beq.b	.nw

	move	pi_Flags(a1),d0
	move	pi_HorizBody(a1),d3
	moveq	#0,d2
	moveq	#0,d4
	move.l	windowbase(a5),a1
	sub.l	a2,a2
	moveq	#1,d5
	lore	Intui,NewModifyProp
.nw
	tst.b	playing(a5)
	beq.b	.k
	move	mainvolume(a5),d0
	move.l	playerbase(a5),a0
	jsr	p_volume(a0)
.k	rts



*******************************************************************************
* Fileselectorgadgetti
*******
rslider4
	move.l	gg_SpecialInfo(a2),a0
	move	pi_VertPot(a0),d0
	cmp	slider4old(a5),d0
	bne.b	.new
.q	rts
.new	move	d0,slider4old(a5)

	move	modamount(a5),d1
	sub	boxsize(a5),d1
	bpl.b	.e
	moveq	#0,d1
.e	mulu	d1,d0
	add.l	#32767,d0
	divu	#65535,d0

	cmp	firstname(a5),d0
	beq.b	.q
	move	d0,firstname(a5)
	bra.w	shownames2

*******************************************************************************
* Suhteutetaan nuppi tiedostojen m��r��n
* Asetetaan valitun nimen kohdalle
*******

resh	pushm	all
	bsr.w	shownames
	bsr.b	reslider
	popm	all
	rts

reslider
	moveq	#0,d0
	move	modamount(a5),d0
	bne.b	.e
	moveq	#1,d0
.e
	moveq	#0,d1
	move	boxsize(a5),d1
	beq.w	.eiup

	cmp	d1,d0		* v�h boxsize
	bhs.b	.ok
	move	d1,d0
.ok
	lsl.l	#8,d0
	bsr.w	divu_32
 	
	move.l	d0,d1
	move.l	#65535<<8,d0
	bsr.w	divu_32
	move.l	d0,d1
	bsr.w	.ch

	lea	slider4,a0
	move.l	gg_SpecialInfo(a0),a1
	cmp	pi_VertBody(a1),d0
	sne	d2
	lsl	#8,d2
	move	d0,pi_VertBody(a1)

*** Toimii vihdoinkin!
	move	modamount(a5),d1
	sub	boxsize(a5),d1
	beq.b	.pp
	bpl.b	.p
.pp	moveq	#1,d1
.p	ext.l	d1

	move	firstname(a5),d0
	mulu	#65535,d0
	bsr.w	divu_32
	bsr.w	.ch
	move.l	d0,d1

	cmp	pi_VertPot(a1),d1
	sne	d2
	move	d1,pi_VertPot(a1)

	move	gg_Height(a0),d0

	cmp	#8,slimheight
	blo.b	.fea

	cmp	slider4oldheight(a5),d0
	bne.b	.fea

	tst	d2
	beq.b	.eiup

.fea	tst.b	win(a5)
	beq.b	.eiup

	move	d0,slider4oldheight(a5)

	tst.b	uusikick(a5)
	beq.b	.bar

;	move	gg_Height(a0),d0
	mulu	pi_VertBody(a1),d0	* koko pixelein�
	divu	#$ffff,d0
	bne.b	.f
	moveq	#8,d0			* onko < 1? minimiksi 8
.f
	cmp	#8,d0
	bhs.b	.zze
	moveq	#8,d0
.zze
	move	d0,slimheight
	subq	#2+1,d0
	move	d0,d1

	lea	slim,a0
	lea	slim1a,a1
	move	(a1)+,(a0)+
.filf	move	(a1),(a0)+
	dbf	d0,.filf
	addq	#2,a1
	move	(a1)+,(a0)+

	move	(a1)+,(a0)+
.fil	move	(a1),(a0)+
	dbf	d1,.fil
	move	2(a1),(a0)

.bar
	lea	slider4,a0
	move.l	windowbase(a5),a1
	sub.l	a2,a2
	moveq	#1,d0
	lore	Intui,RefreshGList

;	lea	slider4,a0
;	move.l	gg_SpecialInfo(a0),a1
;	movem	(a1),d0/d1/d2/d3/d4    * Flags, HorizPot, VertPot,
				       * HorizBody, VertBody
;	move.l	windowbase(a5),a1
;	moveq	#1,d5
;	sub.l	a2,a2
;	lore	Intui,NewModifyProp
.eiup
	rts


.ch	cmp.l	#$ffff,d0
	bls.b	.ok3
	move.l	#$ffff,d0
.ok3	rts


resetslider
	move.l	a0,-(sp)
	move.l	slider4+gg_SpecialInfo,a0
	clr	pi_VertPot(a0)
	move.l	(sp)+,a0
	rts




*******************************************************************************
* Play module
*******
rbutton1

	tst.b	movenode(a5)
	beq.b	.nomove

**** Onko move p��ll�?
	clr.b	movenode(a5)

	bsr.w	getcurrent
	beq.b	.nomove

	lea	listheader(a5),a0	* Insertoidaan node...
	move.l	nodetomove(a5),a1
	move.l	a3,a2
	lore	Exec,Insert
	addq	#1,modamount(a5)
	addq	#1,chosenmodule(a5)	* valitaan movetettu node
	st	hippoonbox(a5)
	bsr.w	clear_random
	bra.w	resh


.nomove
	check	2		* reg check


	tst.b	new(a5)			* onko New?
	bne.b	.newoe

	tst	modamount(a5)		* onko modeja
	bne.b	.huh

.newoe	;st	new2(a5)
	st	haluttiinuusimodi(a5)
	bra.w	rbutton7		* jos ei, ladataan...

.huh	move	chosenmodule(a5),d0	* onko valittua nime�
	bpl.b	.ere
	moveq	#0,d0			* jos ei, otetaan eka
.ere	move	d0,d2




	;move.b	new2(a5),d1
	;clr.b	new2(a5)

	cmp.b	#pm_random,playmode(a5)
	bne.b	.xa

	move.b	tabularasa(a5),d3
	clr.b	tabularasa(a5)
	tst.b	d3
	bne.w	soitamodi_random

	;tst.b	d1
	;bne.w	soitamodi_random * soita randomi, now 'New' ja randomplay
	;bsr.w	shownames
.xa

	bsr.w	clear_random		* Tyhj�x
	bsr.w	setrandom		* merkit��n...


* etsit��n listasta vastaava tiedosto
	lea	listheader(a5),a4
.luuppo
	TSTNODE	a4,a3
	beq.w	.erer
	move.l	a3,a4
	dbf	d0,.luuppo


.huo	cmp.b	#'�',l_filename(a3)	* onko divideri??
	bne.b	.je
	TSTNODE	a4,a3
	beq.w	.erer			* loppuivatko modit??
	move.l	a3,a4
	addq	#1,chosenmodule(a5)
	bsr.w	resh
	bra.b	.huh
.je


	cmp	playingmodule(a5),d2	* onko sama kuin juuri soitettava??
	bne.b	.new


.early
	bsr.w	fadevolumedown
	move	d0,-(sp)


* Soitetaan vaan alusta
	bsr.w	halt
	move.l	playerbase(a5),a0
	jsr	p_end(a0)
	move	(sp)+,mainvolume(a5)



	move.l	playerbase(a5),a0
	jsr	p_init(a0)
	tst.l	d0
	bne.b	.inierr

	st	playing(a5)		* Ei varmaan tuu initerroria
	bsr.w	settimestart
	bsr.w	inforivit_play
	bra.w	start_info
	;rts

.new	moveq	#0,d7
	tst	playingmodule(a5)	* Onko soitettavana mit��n?
	bmi.b	.nomod

	move.b	doublebuf(a5),d7	* Onko doublebufferinki p��ll�?
	bne.b	.nomod

	bsr.w	fadevolumedown
	move	d0,-(sp)
	bsr.b	halt			* Vapautetaan se jos on
	move.l	playerbase(a5),a0
	jsr	p_end(a0)
	bsr.w	freemodule	
	move	(sp)+,mainvolume(a5)
.nomod

	move	d2,playingmodule(a5)	* Uusi numero

	lea	l_filename(a3),a0	* Ladataan
	move.l	l_nameaddr(a3),solename(a5)
	move.b	d7,d0
	bsr.w	loadmodule
	tst.l	d0
	bne.b	.loader

	move.l	playerbase(a5),a0
	jsr	p_init(a0)
	tst.l	d0
	bne.b	.inierr

	bsr.w	settimestart
.reet0	st	playing(a5)
	bsr.w	inforivit_play
	bsr.w	start_info
.erer
	rts

.loader	
	move	#-1,playingmodule(a5)
	rts

.inierr2
	moveq	#ier_unknown,d0

.inierr	
	move	#-1,playingmodule(A5)	* initvirhe
	bra.w	init_error
;	rts

halt	clr.b	playing(a5)	
;	clr	songnumber(a5)
	clr	pos_nykyinen(a5)
	clr	positionmuutos(a5)
	rts




*******************************************************************************
* Insertti
*******
rinsert
	tst	modamount(a5)
	beq.w	rbutton7
	bsr.b	rinsert2
	bra.w	rbutton7

rinsert2
	move	chosenmodule(a5),d0

* etsit��n listasta vastaava kohta
	lea	listheader(a5),a4
.luuppo
	TSTNODE	a4,a3
	beq.w	rbutton7
	move.l	a3,a4
	dbf	d0,.luuppo
* a3 = valittu nimi
	move.l	a3,fileinsert(a5)

	st	filereqmode(a5)
	rts
	



*******************************************************************************
* Add divider
*******
add_divider
	tst	modamount(a5)
	beq.b	.x
	move	chosenmodule(a5),d0
;	subq	#1,d0			* valitun nimen edellinen node

	lea	listheader(a5),a4
.luuppo	TSTNODE	a4,a3
	beq.b	.x
	move.l	a3,a4
	dbf	d0,.luuppo


	bsr.w	get_rt

	push	a3
	lea	divider(a5),a1	
	moveq	#27-1,d0
	sub.l	a3,a3
	lea	.tags(pc),a0
	lea	.ti(pc),a2
	bsr.w	pon1
	lob	rtGetStringA
	bsr.w	poff1
	pop	a3
	tst.l	d0
	beq.b	.x

	addq	#1,modamount(a5)

	moveq	#l_size+30,d0
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	beq.b	.x
	move.l	d0,a1

	lea	divider(a5),a0
	lea	l_filename(a1),a2
	move.l	a2,l_nameaddr(a1)
	move.b	#'�',(a2)+		* divider merkint�
.fe	move.b	(a0)+,(a2)+
	bne.b	.fe
	

* a1 = insertattava nimi
	lea	listheader(a5),a0
	move.l	a3,a2
	lore	Exec,Insert
	st	hippoonbox(a5)
	bsr.w	resh

.x	rts


.ti	dc.b	"Add divider",0
 even

.tags
	dc.l	RTGS_Width,262
	dc.l	RT_TextAttr,text_attr
otag17	dc.l	RT_PubScrName,pubscreen+var_b
	dc.l	TAG_END
	



*******************************************************************************
* Tiedostojen lis��minen listaan
* Luodaan erillinen prosessi
*******
rbutton7

;	bra	filereq_code

	clr.b	movenode(a5)
	tst	filereq_prosessi(a5)
	beq.b	.ook
	rts
.ook	move.l	_DosBase(a5),a6

	pushpea	fileprocname(pc),d1

	move.l	priority(a5),d2
;	moveq	#0,d2			* pri

	pushpea	filereq_segment(pc),d3
	lsr.l	#2,d3
	move.l	#5000,d4		* saattaa tarvita, kun on rekursiivinen
	lob	CreateProc
	tst.l	d0
	beq.b	.error
	addq	#1,filereq_prosessi(a5)
.error	rts



filereq_code
	lea	var_b,a5
	addq	#1,filereq_prosessi(a5)	* Lippu: prosessi p��ll�
	moveq	#0,d7

	tst	modamount(a5)
	sne	tabularasa(a5)		* pistetaan lippu jos aluks 
					* ei moduuleja. tata kaytetaan
					* randomplayn kanssa, eli katotaan
					* otetaanko eka moduuli taysin 
					* randomilla

	bsr.b	.filer

	move.b	ownsignal6(a5),d1	* Signaali: Valmista tuli..
	bsr.w	signalit
.n	
	clr.b	filereqmode(a5)

	lore	Exec,Forbid
	clr	filereq_prosessi(a5)	* Lippu: prosessi poistettu
	rts
	
* Varsinainen operaatio alkaa t�st�..
.filer
	bsr.w	tokenizepattern

	bsr.w	get_rt
	tst.l	req_file(a5)
	bne.b	.onfi
	moveq	#RT_FILEREQ,D0
	sub.l	a0,a0
	lob	rtAllocRequestA
	move.l	d0,req_file(a5)
.onfi


** BUGI?!?

	tst.b	newdirectory(a5)	* Onko uusi hakemisto?
	beq.b	.eimuut
	clr.b	newdirectory(a5)

	move.l	req_file(a5),a1		* Vaihdetaan hakemistoa...
	lea	newdir_tags(pc),a0
	lea	moduledir(a5),a2
	move.l	a2,4(a0)
	lore	Req,rtChangeReqAttrA

.eimuut

	move.l	req_file(a5),a1		* Match pattern
	lea	matchp_tags(pc),a0
	lore	Req,rtChangeReqAttrA

	st	loading2(a5)

	lea	filereqtags(pc),a0
	move.l	req_file(a5),a1
	lea	filename(a5),a2
	lea	filereqtitle(pc),a3
	lore	Req,rtFileRequestA	* ReqToolsin tiedostovalikko

	move.l	d0,filelistaddr(a5)
	bne.b	.val

	move.b	#$7f,new(a5)		* new-lippu: cancel
	bra.w	.whoops3		* Valittiinko mit��n?
.val

	tst.b	new(a5)			* jos 'new', clearataan lista.
	beq.b	.non1
	bsr.w	clearlist


.non1


 ifne fprog
	bsr	openfilewin
 endc

	bsr.w	parsereqdir		* Tehd��n hakemistopolku..

	move.l	filelistaddr(a5),a4	* Reqtoolsin tiedostolistan osoite

	moveq	#0,d4			* polun pituus
	lea	tempdir(a5),a0
.f	addq.l	#1,d4
	tst.b	(a0)+
	bne.b	.f
;	subq.l	#1,d4			* -1, nolla pois per�st�
;	add.l	#l_size,d4		* listayksik�n koko
	add.l	#l_size-1,d4

	addq.b	#1,freezegads(a5)	* mainwindowin gadgetit pois p��lt�

.buildlist

***** K�sitell��n valitut hakemistot 
	cmp.l	#-1,rtfl_StrLen(a4)	* onko hakemisto?????
	bne.w	.file			* reqtools-listan file

	move.l	rtfl_Name(a4),a0	* hakemiston nimi
	bsr.w	adddivider


* rtfl_Name(a4)	= hakemisto 2
* tempdir(a5) = hakemisto 1
* Koko hakemistonpolku = Hakemisto 1/hakemisto 2
	lea	-200(sp),sp
	move.l	sp,a3
	lea	tempdir(a5),a0
.c0	move.b	(a0)+,(a3)+
	bne.b	.c0
	subq.l	#1,a3
	move.l	rtfl_Name(a4),a0
.c1	move.b	(a0)+,(a3)+
	bne.b	.c1
	subq.l	#1,a3
	move.b	#'/',(a3)+
	clr.b	(a3)
	move.l	a3,d3			* hakemiston pituus
	sub.l	sp,d3
	add.l	#l_size,d3		* listayksik�n koko

* d3 = dir len + l_size
* sp = dir

	move.l	sp,d2
	pushm	all
	bsr.b	.scanni			* rekursiivinen hakemiston tutkimus
	popm	all
	lea	200(sp),sp

	bsr.w	.dirdiv
	bra.w	.skip



.scanni
	move.l	d2,a4		* hakemisto
	moveq	#0,d6

	move.l	#250*4+2,d0	* tilaa 250:lle hakemistolukolle	
	move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1
	bsr.w	getmem
	move.l	d0,d7
	beq.w	.errd

	move.l	a4,d1
	moveq	#ACCESS_READ,d2
	lore	Dos,Lock
	move.l	d0,d6			* d6 = hakemiston lukko
	beq.w	.errd

	move.l	d6,d1
	pushpea	fileinfoblock2(a5),d2
	lob	Examine
	tst.l	d0
	beq.w	.errd


.loopo	cmp	#$3fff,modamount(a5)	* Ei enemp�� kuin ~16000
	bhs.w	.errd

	move.l	d6,d1
	pushpea	fileinfoblock2(a5),d2
	lore	Dos,ExNext
	tst.l	d0
	beq.b	.dodirs
	tst.l	fib_DirEntryType+fileinfoblock2(a5)
	bmi.w	.filetta		* Onko tiedosto vai hakemisto?

	tst.b	uusikick(a5)		* rekursiivinen vain kick2.0+
	beq.b	.loopo



* otetaan kyseisen hakemiston nimi talteen my�hemp�� k�ytt�� varten

	move.l	#200,d0
	move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1
	bsr.w	getmem
	move.l	d0,a1
	tst.l	d0
	beq.b	.lc0

	move.l	a4,a0
.lc	move.b	(a0)+,(a1)+
	bne.b	.lc
	subq	#1,a1
	lea	fib_FileName+fileinfoblock2(a5),a0
.lc2	move.b	(a0)+,(a1)+
	bne.b	.lc2

	move.l	d7,a0
	move	(a0),d1
	addq	#1,(a0)+
	lsl	#2,d1
	move.l	d0,(a0,d1)
.lc0
	bra.b	.loopo


**** skannattuamme yhden hakemiston tutkitaan siin� olleet muut hakemistot


.dodirs

	tst.b	uusikick(a5)		* rekursiivinen vain kick2.0+
	beq.w	.errd

	pushm	all

	move.l	d7,a3
	move	(a3)+,d5
	beq.b	.errd2
	subq	#1,d5

.dodirsl
	move.l	(a3)+,d6

	move.l	d6,d1
	moveq	#ACCESS_READ,d2
	lore	Dos,Lock
	move.l	d0,d4
	beq.b	.porre

	move.l	d4,d1
	pushpea	fileinfoblock2(a5),d2
	lob	Examine

	lea	fib_FileName+fileinfoblock2(a5),a0	* hakemiston nimi
	bsr.w	adddivider

	pushm	all
	lea	-200(sp),sp

	move.l	d4,d1
	move.l	sp,d2
	moveq	#100,d3			* max pituus hakemistolle
	lob	NameFromLock
	push	d0
	
	move.l	d4,d1
	lob	UnLock

	tst.l	(sp)+
	beq.b	.porrer
	move.l	sp,a2
.fe0	tst.b	(a2)+
	bne.b	.fe0

	subq	#1,a2
	cmp.b	#':',-1(a2)
	beq.b	.na0
	move.b	#'/',(a2)+
.na0	clr.b	(a2)

	sub.l	sp,a2
	lea	l_size(a2),a2
	move.l	a2,d3
	move.l	sp,d2
	bsr.w	.scanni

	bsr.w	.dirdiv

.porrer
	lea	200(sp),sp
	popm	all

.porre	dbf	d5,.dodirsl

.errd2	popm	all

	bra.b	.errd





.filetta

** Patternmatchaus
	tst.b	uusikick(a5)
	beq.b	.yas
	pushpea	tokenizedpattern(a5),d1
	pushpea	fib_FileName+fileinfoblock2(a5),d2
	push	a6
	lore	Dos,MatchPatternNoCase
	pop	a6
	tst.l	d0			* kelpaako vaiko eik�?
	beq.w	.loopo
.yas

	lea	fib_FileName+fileinfoblock2(a5),a0	* filename
	move.l	a0,a1
.fie	tst.b	(a1)+
	bne.b	.fie
	sub.l	a0,a1		* nimen pituus

	move.l	d3,d0		* hakemisto + nimi (pituus)
	add.l	a1,d0
	move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1
	bsr.w	getmem
	beq.b	.errd
	move.l	d0,a3		* a3 = listunit

	lea	l_filename(a3),a1
	move.l	a4,a0
.c2	move.b	(a0)+,(a1)+	* kopioidaan hakemisto
	bne.b	.c2
	subq.l	#1,a1
	move.l	a1,l_nameaddr(a3)	* ja tiedosto
	lea	fib_FileName+fileinfoblock2(a5),a0
.c3	move.b	(a0)+,(a1)+
	bne.b	.c3

	bsr.w	addfile
	bra.w	.loopo

.errd	

	move.l	d6,d1
	beq.b	.erde
	lore	Dos,UnLock
.erde	

* vapautetaan lukot hakemiston hakemistoihin
	tst.l	d7
	beq.b	.erde0

	move.l	d7,a3
	move	(a3)+,d3
	beq.b	.erde1
	subq	#1,d3

.erde2	move.l	(a3)+,a0
	bsr.w	freemem
	dbf	d3,.erde2
.erde1
	move.l	d7,a0		
	bsr.w	freemem
.erde0
	rts


************* Reqtoollislta saadut tiedostot
.file
	cmp	#$3fff,modamount(a5)	* Ei enemp�� kuin 16383
	bhs.b	.overload

	move.l	d4,d0			* listunit,polku,nimi pituus
	add.l	rtfl_StrLen(a4),d0

	move.l	#MEMF_CLEAR,d1		* varataan muistia
	bsr.w	getmem
	beq.b	.whoops2	
	move.l	d0,a3

	lea	l_filename(a3),a1
	lea	tempdir(a5),a0
.copy	move.b	(a0)+,(a1)+		* kopioidaan polku
	bne.b	.copy
	subq.l	#1,a1
	move.l	a1,l_nameaddr(a3)	* pelk�n nimen osoite
	movem.l	rtfl_StrLen(a4),d0/a0	* StrLen/Name
	subq	#1,d0
.copy2	move.b	(a0)+,(a1)+		* kopioidaan tiedoston nimi
	dbf	d0,.copy2
	clr.b	(a1)

	bsr.b	addfile



.skip
	move.l	rtfl_Next(a4),d0	* Joko loppui?
	beq.b	.whoops3
	move.l	d0,a4
	bra.w	.buildlist
	

.whoops2
.whoops	
.whoops3	

	tst	chosenmodule(a5)
	bpl.b	.ee
	clr	chosenmodule(a5)	* moduuliksi eka jos ei ennest��n
.ee

	subq.b	#1,freezegads(a5)
	bpl.b	.e
	clr.b	freezegads(a5)
.e
	clr.b	loading2(a5)

 ifne fprog
	bsr	closefilewin
 endc
	rts


.overload
	lea	.t(pc),a1
	bsr.w	request
	bra.b	.whoops


.dirdiv
	lea	.barf(pc),a0
	bra.b	adddivider

.t	dc.b	"My stomach feels content.",0
.barf	dc.b	"/\/\/\/\/\/\/\",0
	even


* addaa/inserttaa listaan a3:ssa olevan noden
addfile	
	cmp	#$3fff,modamount(a5)
	bhs.b	.r

	addq	#1,modamount(a5)
	move.l	(a5),a6
	lea	listheader(a5),a0	* lis�t��n listaan
	move.l	a3,a1
	tst.b	filereqmode(a5)		* onko add vai insert?
	bne.b	.insert


 ifeq fprog
	jmp	_LVOAddTail(a6)
 else
	lob	AddTail
	bra	printfilewin
 endc

.insert	move.l	fileinsert(a5),a2	* mink� filen per��n insertataan
	lob	Insert
.r	rts



*** Lis�t��n divideri hakemistolle
* a0 = hakemiston nimi

adddivider
	pushm	all
	moveq	#0,d7


	tst.b	divdir(a5)
	beq.w	.meek
	move.l	a0,a2

** testataan onko dirdivideri? jos on, pistet��n sen p��lle
	lea	listheader(a5),a3
	move.l	MLH_TAILPRED(a3),d0
	beq.b	.pehe
	move.l	d0,a3

	move.l	l_nameaddr(a3),d0
	beq.b	.pehe
	move.l	d0,a0

	cmp.b	#'�',(a0)
	bne.b	.pehe
	cmp.b	#'/',7(a0)
	bne.b	.pehe
	moveq	#1,d7
	bra.b	.hue
.pehe


	move.l	#l_size+30+2,d0
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	beq.b	.meek

	move.l	d0,a3
.hue	move.l	a2,a0


	lea	l_filename(a3),a2
	move.l	a2,l_nameaddr(a3)
	move.b	#'�',(a2)+		* divider merkint�

					* a0 = hakemiston nimi
	lea	-32(sp),sp
	move.l	sp,a1
	moveq	#21-1,d0
.bar	move.b	(a0)+,(a1)+
	dbeq	d0,.bar
	clr.b	(a1)

	move.l	sp,a0

	move.l	a0,a1
.foo	tst.b	(a1)+
	bne.b	.foo
	subq	#1,a1
	sub.l	a0,a1
	move	a1,d0
	cmp	#27,d0
	bls.b	.ok
	moveq	#27,d0
.ok
	moveq	#27,d1
	sub	d0,d1
	lsr	#1,d1
	subq	#1,d1
	bmi.b	.boo
.fii	move.b	#'*',(a2)+
	dbf	d1,.fii
	move.b	#' ',-1(a2)
.boo

	moveq	#27-1,d0
.fe	move.b	(a0)+,(a2)+
	dbeq	d0,.fe
	tst	d0
	bmi.b	.fo
	subq	#1,a2
	move.b	#' ',(a2)+
	subq	#1,d0
	bmi.b	.fo
.fi	move.b	#'*',(a2)+
	dbf	d0,.fi
.fo
	clr.b	(a2)

	tst	d7
	bne.b	.pad
	bsr.w	addfile
.pad

	lea	32(sp),sp
.meek	popm	all
	rts





** Asetetaan hakemisto requesteriin
newdir_tags
	dc.l	RTFI_Dir
	dc.l	0			* Uuden hakemiston osoite t�h�n
	dc.l	TAG_END


matchp_tags
	dc.l	RTFI_MatchPat,var_b+pattern
	dc.l	TAG_END


* Reqtoolsin tagit
filereqtags
	dc.l	RTFI_Flags
	dc.l	FREQF_MULTISELECT!FREQF_PATGAD!FREQF_SELECTDIRS
;	dc.l	RT_TextAttr,text_attr
otag2	dc.l	RT_PubScrName,pubscreen+var_b
	dc.l	TAG_END
filereqtitle
	dc.b	"Select files & dirs to add",0

 even












 ifne fprog

*********************************
* File add progress indicator

wflags5 = WFLG_SMART_REFRESH!WFLG_BORDERLESS
idcmpflags5 = 0 ;IDCMP_MOUSEBUTTONS!IDCMP_INACTIVEWINDOW

openfilewin
	pushm	all

	move.l	screenaddr(a5),d0
	beq.w	.x
	move.l	d0,a0

	move	sc_MouseX(a0),d6
	move	sc_MouseY(a0),d7

	lea	winfile,a0		* asetetaan pointterin kohdalle
	move	#125,nw_Width(a0)
	move	#15,nw_Height(a0)

	sub	#125/2,d6
	bpl.b	.b
	moveq	#0,d6
.b	move	d6,nw_LeftEdge(a0)

	sub	#15/2,d7
	bpl.b	.ba
	moveq	#0,d7
.ba	move	d7,nw_TopEdge(a0)



	bsr.w	tark_mahtu

	lore	Intui,OpenWindow
	move.l	d0,d5
	beq.w	.x
	move.l	d0,a0
	move.l	wd_RPort(a0),d7		* rastport

	move.l	d5,filewin
	move.l	d7,filerastport

	move.l	d7,a1
	move.l	pen_1(a5),d0
	lore	GFX,SetAPen
	move.l	d7,a1
	move.l	pen_0(a5),d0
	lob	SetBPen

	move.l	d7,a1
	move.l	fontbase(a5),a0
	lob	SetFont	


	move.l	d7,a1
	lea	winfile,a0
	moveq	#0,plx1
	move	nw_Width(a0),plx2
	moveq	#0,ply1
	move	nw_Height(a0),ply2
	subq	#1,ply2
	subq	#1,plx2
	bsr.w	laatikko2

	move	modamount(a5),fileamount


.x	popm	all
	rts


printfilewin
	pushm	d1/d1/a0/a4

	tst.l	filewin
	beq.b	.x

	move	modamount(a5),d0
	sub	fileamount(pc),d0

	lea	.foo(pc),a0
	bsr	putnumber
	clr.b	(a0)

	lea	.goo(pc),a0
	moveq	#7,d0
	moveq	#10,d1

	move.l	filerastport(pc),a4
	bsr.b	.dd

.x	popm	d0/d1/a0/a4
	rts

.dd	pushm	all
	bra	uup


.goo	dc.b	"Entries: "
.foo	dc.b	"       "
 even

filewin		dc.l	0
filerastport	dc.l	0
fileamount	dc	0

closefilewin
	pushm	all
	move.l	filewin(pc),d0
	beq.b	.x
	move.l	d0,a0
	lore	Intui,CloseWindow
.x	popm	all
	rts



winfile
	dc	0,0	* paikka 
	dc	0,0	* koko
	dc.b	0,0	;palkin v�rit
	dc.l	idcmpflags4
	dc.l	wflags4
	dc.l	0
	dc.l	0	
	dc.l	0	; title
	dc.l	0
	dc.l	0	
	dc	0,0
	dc	0,0
	dc	WBENCHSCREEN
	dc.l	enw_tags
 endc











*******************************************************************************
* Vapautetaan tiedostolista
*******
freelist
	tst	modamount(a5)
	beq.b	.endlist

	bsr.w	clear_random
	clr	modamount(a5) 
	move	#-1,chosenmodule(a5)
	tst	playingmodule(a5)
	bmi.b	.ehe
	move	#$7fff,playingmodule(a5)
.ehe
	clr	firstname(a5)
	bsr.w	reslider
.freeloop
	lea	listheader(a5),a0
	lore	Exec,RemTail

	tst.l	d0
	beq.b	.endlist
	move.l	d0,a0
	bsr.w	freemem
	bra.b	.freeloop

.endlist
	rts



*******************************************************************************
* Parsetaan reqtoolsilta saatu hakemistopolku
*******
parsereqdir
	move.l	req_file(a5),a0
parsereqdir3
	lea	tempdir(a5),a1
parsereqdir2
	move.l	16(a0),a0
	tst.b	(a0)
	bne.b	.dij
	clr	(a1)
	rts
.dij	move.b	(a0)+,(a1)+		* tehd��n hakemisto
	bne.b	.dij
	subq.l	#2,a1
	cmp.b	#':',(a1)
	beq.b	.nfo
	addq.l	#1,a1
	move.b	#'/',(a1)
.nfo	clr.b	1(a1)
	rts



*******************************************************************************
* Ladataan/tallennetaan moduuliohjelma
*******

* ladataan PRG joka on d7:ssa
rloadprog2
	bra.b	rlpg


rloadprog0		* LoadProgram joka AddTailaa vanhan listan per��n.
	st	lprgadd(a5)

rloadprog
	moveq	#0,d7

rlpg	tst	filereq_prosessi(a5)
	bne.w	.kex

	bsr.b	.mop
	bra.b	.dd

.mop
	pushm	all
	lea	.t(pc),a0
	moveq	#46+WINX,d0
	bsr.w	printbox
	popm	all
	rts
.t	dc.b	"Loading module program...",0
 even

.dd
	clr.b	movenode(a5)

	tst.l	d7
	bne.b	.loe

	bsr.w	get_rt
	moveq	#RT_FILEREQ,D0
	sub.l	a0,a0
	lob	rtAllocRequestA
	move.l	d0,req_file2(a5)
	beq.w	.kex

	move.l	d0,a1			* Vaihdetaan hakemistoa...
	lea	newdir_tags(pc),a0
	pushpea	prgdir(a5),4(a0)
	lob	rtChangeReqAttrA

	move.l	req_file2(a5),a1	* pattern match
	lea	matchp_tags(pc),a0	
	lob	rtChangeReqAttrA

	lea	.tags(pc),a0
	move.l	req_file2(a5),a1
	lea	filename(a5),a2		* T�nne tiedoston polku ja nimi
	clr.b	(a2)

	lea	filereqtitle2(pc),a3
	lob	rtFileRequestA		* ReqToolsin tiedostovalikko
	tst.l	d0
	beq.w	.kex
	move.l	req_file2(a5),a0
	bsr.w	parsereqdir3

	lea	tempdir(a5),a0		* kopioidaan polku ja nimi yhdeksi
	lea	filename2(a5),a1
.c	move.b	(a0)+,(a1)+
	bne.b	.c
	subq.l	#1,a1
	lea	filename(a5),a0
.a	move.b	(a0)+,(a1)+
	bne.b	.a


.loe	
	tst.b	lprgadd(a5)		* ei putsata jos addataan
	bne.b	.yad
	bsr.w	freelist		* putsataan vanha lista
.yad

	lea	filename2(a5),a0
	tst.l	d7
	beq.b	.ewew
	move.l	d7,a0
.ewew
	moveq	#0,d4
.loadp
	move.b	lprgadd(a5),d7
	clr.b	lprgadd(a5)

***** ladataan proggis

	move.l	a0,.infile

	move.l	_DosBase(a5),a6
	move.l	a0,d1
	move.l	#1005,d2
	lob	Open
	move.l	d0,d6
	beq.w	.openerr

	move.l	d6,d1		* selvitet��n filen pituus
	moveq	#0,d2	
	moveq	#1,d3
	lob	Seek
	move.l	d6,d1
	moveq	#0,d2	
	moveq	#1,d3
	lob	Seek
	move.l	d0,d5		* pituus

	move.l	d6,d1
	moveq	#0,d2
	moveq	#-1,d3
	lob	Seek		* alkuun

	move.l	d5,d0		* muistia listalle
	moveq	#MEMF_PUBLIC,d1
	bsr.w	getmem
	move.l	d0,a3

	move.l	d6,d1		* file
	move.l	a3,d2		* destination
	move.l	d5,d3		* pituus
	lob	Read

	move.l	a3,d1
	add.l	d0,d1
	move.l	d1,.loppu

	push	d0

	move.l	d6,d1
	lob	Close

	cmp.l	(sp)+,d5	* read error?
	bne.w	.x2


** A3:ssa moduulilista

** jos on xpk pakattu, pit�� purkaakkin.

	cmp.l	#"XPKF",(a3)
	bne.w	.nox

	jsr	get_xpk
	beq.w	.what



	cmp.l	#"HiPP",16(a3)	* uusi formaatti?
	bne.b	.nu
	cmp	#"rg",20(a3)
	beq.b	.nyy
.nu
	cmp.l	#"HIPP",16(a3)	* tunnistus, vanha formaatti?
	bne.w	.what
	cmp	#"RO",20(a3)
	bne.w	.what
.nyy

	move.l	a3,a0
	bsr.w	freemem


	lea	.tagz(pc),a0
	clr.l	.len-.tagz(a0)

	lore	XPK,XpkUnpack

	tst.l	d0
	bne.w	.what		* err

	move.l	.addr(pc),a3


	move.l	a3,d0
	add.l	.oiklen(pc),d0
	move.l	d0,.loppu

	bra.b	.noxx

.tagz
		dc.l	XPK_InName
.infile		dc.l	0

		dc.l	XPK_GetOutBuf,.addr
		dc.l	XPK_GetOutBufLen,.len
		dc.l	XPK_GetOutLen,.oiklen

		dc.l	XPK_OutMemType,MEMF_PUBLIC
		dc.l	XPK_PassThru,1
;		dc.l	XPK_GetError,xpkerror+var_b	* virheilmoitus
		dc.l	TAG_END

.len	dc.l	0
.addr	dc.l	0
.oiklen	dc.l	0
.loppu	dc.l	0

.noxx

.nox


***************** ALoitetaan k�sittely

	move.l	a3,d5		* muistialue talteen d5:een

	moveq	#0,d6		* 0 = vanha formaatti


	cmp.l	#"HiPP",(a3)
	bne.b	.rr
	cmp	#"rg",4(a3)
	bne.b	.rr
.r2	cmp.b	#10,(a3)+	* skipataan kaks rivinvaihtoa
	bne.b	.r2
	addq	#1,a3
	moveq	#1,d6		* uusi formaatti
	bra.b	.r1
.rr
	cmp.l	#"HIPP",(a3)+
	bne.w	.what
	cmp	#"RO",(a3)+
	bne.w	.what
	addq	#2,a3		* skip: moduulien m��r�
.r1

	tst.b	d7			* addi??
	bne.b	.yadd
	clr	modamount(a5)
.yadd

	lea	listheader(a5),a4
.ploop

	tst	d6
	bne.b	.new1
	moveq	#0,d0
	move.b	(a3)+,d0	* seuraavan pituus
	lsl	#8,d0
	move.b	(a3)+,d0
	bra.b	.old1
.new1

	move.l	a3,a0
.r23	cmp.b	#10,(a0)+
	bne.b	.r23
	move.l	a0,d0
	sub.l	a3,d0	* pituus

.old1

	add.l	#1+l_size,d0	* nolla nimen per��n ja listayksik�n pituus
	move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
	bsr.w	getmem
	beq.b	.x2
	move.l	d0,a2

	lea	l_filename(a2),a0

	tst	d6
	bne.b	.new2
;	move	(a3)+,d0
	move.b	(a3)+,d0
	lsl	#8,d0
	move.b	(a3)+,d0

	subq	#1,d0
.cy	move.b	(a3)+,(a0)+
	dbf	d0,.cy
	clr.b	(a0)
	bra.b	.old2
.new2
.le	move.b	(a3),(a0)+
	cmp.b	#10,(a3)+
	bne.b	.le
	clr.b	-(a0)
.old2

	lea	l_filename(a2),a1
	cmp.b	#'�',(a1)		* divideri
	bne.b	.nd
	move.l	a1,a0
	bra.b	.di
.nd
	bsr.w	nimenalku
.di	move.l	a0,l_nameaddr(a2)

	cmp	#$3fff,modamount(a5)
	bhs.b	.x2

	move.l	a2,a1
	lea	listheader(a5),a0	* lis�t��n listan per��n
	lore	Exec,AddTail
	addq	#1,modamount(a5)

	cmp.l	.loppu(pc),a3
	blo.w	.ploop


.x2
	tst.l	d5
	beq.b	.xxx

	tst.l	.len
	beq.b	.xx0

	move.l	.len(pc),d0	* xpk puskurin vapautus
	move.l	d5,a1
	lore	Exec,FreeMem
	clr.l	.len
	bra.b	.xxx
.xx0
	move.l	d5,a0
	bsr.w	freemem
.xxx

	sub.l	a4,a4
.x1	
	tst	d4
	bne.b	.ext
	move.l	req_file2(a5),d0
	beq.b	.ex
	move.l	d0,a1
	move.l	_ReqBase(a5),a6
	lob	rtFreeRequest

.ex

	clr	chosenmodule(a5)	* moduuliksi eka
.kex	bsr.w	clear_random
	st	hippoonbox(a5)
	bra.w	resh

.what
	lea	.uerr(pc),a1
	bsr.w	request
	bra.b	.x2

.openerr
	move	#1,a4			* lippu
	lea	openerror_t(pc),a1
	bsr.w	request
	bra.b	.x1





.uerr	dc.b	"Not a module program!",0
 even

.ext
* ladattiin ohjelma komentojonon kautta, soitetaan eka tai satunnainen
* riippuen prefs-s��d�ist�.
* Jos ohjelmaa ei saatu ladattua, niin pistet��n filerequesteri.

	bsr.w	vastomaviesti

	cmp	#1,a4	* avausvirhe? -> ei tehd� mit��n
	bne.b	.r
	moveq	#lod_openerr,d0
	rts

.r	cmp.b	#pm_random,playmode(a5)
	bne.b	.noran
	move	modamount(a5),d0
	cmp	#8192,d0
	bhi.b	.noran
	
	subq	#1,d0
.b	bsr.w	getrandom
	cmp	d0,d1
	bhi.b	.b
		
	move	d1,d0
	bsr.w	setrandom

	move	d1,chosenmodule(a5)
	bra.b	.eh

.noran	clr	chosenmodule(a5)

.eh	st	hippoonbox(a5)
	bsr.w	resh
	bra.w	rbutton1	* Play


.blob	bsr.w	.mop
	bra.w	.loadp

	bra.b	.blob

.tags
	dc.l	RTFI_Flags,FREQF_PATGAD
otag1	dc.l	RT_PubScrName,pubscreen+var_b,0

loadprog
	bra.b	*-22		* bra.b -> bra.b .blob


*** Etsii tiedoston nimest� (polku/nimi) pelk�n tiedoston nimen alun
*** a0 <= loppu
*** a1 <= alku
*** a0 => nimi
nimenalku
.f	move.b	-(a0),d0		* etsit��n pelk�n nimen alku
	cmp.b	#'/',d0
	beq.b	.fo
	cmp.b	#':',d0
	beq.b	.fo
	cmp.l	a1,a0
	bne.b	.f
	bra.b	.fof
.fo	addq.l	#1,a0
.fof	rts



rsaveprog
	clr.b	movenode(a5)

	tst	filereq_prosessi(a5)
	bne.w	.ex

	tst	modamount(a5)
	beq.w	.nomods

	bsr.w	get_rt
	moveq	#RT_FILEREQ,D0
	sub.l	a0,a0
	lob	rtAllocRequestA
	move.l	d0,req_file2(a5)
	beq.w	.ex

	move.l	d0,a1			* Vaihdetaan hakemistoa...
	lea	newdir_tags(pc),a0
	pushpea	prgdir(a5),4(a0)
	lob	rtChangeReqAttrA

.eimuut
	move.l	req_file2(a5),a1	* pattern match
	lea	matchp_tags(pc),a0	
	lob	rtChangeReqAttrA


	lea	.t(pc),a0
	moveq	#50+WINX,d0
	bsr.w	printbox
	bra.b	.d
.t	dc.b	"Saving module program...",0
 even
.d

	lea	.tags(pc),a0
	
	move.l	req_file2(a5),a1
	lea	filename(a5),a2		* T�nne tiedoston polku ja nimi

	lea	filereqtitle3(pc),a3
	lob	rtFileRequestA		* ReqToolsin tiedostovalikko
	tst.l	d0
	beq.w	.ex
	move.l	req_file2(a5),a0
	bsr.w	parsereqdir3

	lea	tempdir(a5),a0		* kopioidaan polku ja nimi yhdeksi
	lea	filename2(a5),a1
.c	move.b	(a0)+,(a1)+
	bne.b	.c
	subq.l	#1,a1
	lea	filename(a5),a0
.a	move.b	(a0)+,(a1)+
	bne.b	.a

	lea	tempdir(a5),a0
	lea	prgdir(a5),a1
.cpe2	move.b	(a0)+,(a1)+
	bne.b	.cpe2

	move.l	_DosBase(a5),a6
	lea	filename2(a5),a0
	move.l	#1006,d2
	move.l	a0,d1
	lob	Open

	move.l	d0,d6
	beq.b	.openerr	

	move.l	d6,d1
	lea	prgheader(pc),a0
	move.l	a0,d2
	moveq	#headere-prgheader,d3
	lob	Write

	move	modamount(a5),d7
	subq	#1,d7
	lea	listheader(a5),a4

.saveloop
	TSTNODE	a4,a3
	beq.b	.loppu			* loppuivatko modit??
	move.l	a3,a4

	lea	-200(sp),sp
	move.l	sp,a1

	lea	l_filename(a3),a0
.co	move.b	(a0)+,(a1)+
	bne.b	.co
	subq	#1,a1
	move.b	#10,(a1)+

	move.l	a1,d3
	sub.l	sp,d3
	move.l	sp,d2
	move.l	d6,d1		* tallennetaan nimi
	lob	Write	

	lea	200(sp),sp

	cmp.l	d3,d0
	bne.b	.ERROR

	dbf	d7,.saveloop

.loppu
	move.l	d6,d1
	beq.b	.x1
	lob	Close

.x1	move.l	req_file2(a5),d0
	beq.b	.ex
	move.l	d0,a1
	move.l	_ReqBase(a5),a6
	lob	rtFreeRequest

.ex
	st	hippoonbox(a5)
	bra.w	resh


.ERROR
	lea	.err(pc),a1
	bsr.w	request
	bra.b	.loppu

	

.openerr
	lea	openerror_t(pc),a1
	bsr.w	request
	bra.b	.x1

.nomods	lea	.lerr(pc),a1
	bra.w	request

.lerr	dc.b	"No program to save!",0
.err	dc.b	"Write error!",0
 even

.tags	dc.l	RTFI_Flags,FREQF_PATGAD
otag16	dc.l	RT_PubScrName,pubscreen+var_b,0


prgheader	dc.b	"HiPPrg",10,10	* headeri
headere


filereqtitle2
	dc.b	"Load module program",0
filereqtitle3
	dc.b	"Save module program",0
 even









*******************************************************************************
* Komentojono
*******

komentojono
	lea	sv_argvArray+4(a5),a3	* ei ekaa
	moveq	#ARGVSLOTS-1-1,d7
	move	modamount(a5),d6	* vanha m��r� talteen

* HIDEst� ja QUITista ei v�litet�!

*** Silmukka
.alp
	move.l	(a3)+,d5
	beq.b	.end

	move.l	d5,a0
	bsr.w	kirjainta4
	cmp.l	#"HIDE",d0
	beq.b	.skip
	cmp.l	#"QUIT",d0
	beq.b	.skip
	cmp.l	#"PRGM",d0
	bne.b	.hmm
	move.l	(a3),a0			* ohjelman nimi
	moveq	#-1,d4			* lippu
	bra.w	loadprog
.hmm


	move.l	d5,a0
.f	tst.b	(a0)+
	bne.b	.f
	move.l	a0,d0
	sub.l	d5,d0			* pituus

	add.l	#l_size,d0		* listayksik�n pituus
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	beq.b	.end
	move.l	d0,a2

	lea	l_filename(a2),a0	* kopioidaan
	move.l	d5,a1
.c	move.b	(a1)+,(a0)+
	bne.b	.c

	lea	l_filename(a2),a1
	bsr.w	nimenalku
	move.l	a0,l_nameaddr(a2)

	move.l	a2,a1
	lea	listheader(a5),a0	* lis�t��n listaan
	lore	Exec,AddTail

	addq	#1,modamount(a5)	* m��r�++

.skip	dbf	d7,.alp

.end
	bsr.w	vastomaviesti

	tst	modamount(a5)
	beq.b	.x
	move	d6,chosenmodule(a5)	* ensimm�inen uusi moduuli valituksi

	st	hippoonbox(a5)
	bsr.w	resh
	bsr.w	rbutton1		* soitetaan 
.x	rts


*************
* Tokenisoidaan file match patterni

tokenizepattern
	pushm	all
	tst.b	uusikick(a5)
	beq.b	.feff
	lea	tokenizedpattern(a5),a0
	move.l	a0,d2
	lea	70*2+2(a0),a1
.f	clr	(a0)+
	cmp.l	a1,a0
	bne.b	.f

	pushpea	pattern(a5),d1
	move.l	#70*2+2,d3
	lore	Dos,ParsePatternNoCase
.feff	popm	all
	rts



*******************************************************************************
* Ladataan/tallennetaan prefs-tiedosto
***************************

loadprefs
	pushpea	prefsfilename(pc),d7

;	move.l	(a5),a0			* Kokeillaan ladata preffsi
;	cmp	#36,LIB_VERSION(a0)	* PROGDIR:ist�
;	blo.b	.nah
;	move.l	#prefsfilename2,d1
;	move.l	d1,d4
;	move.l	#ACCESS_READ,d2
;	lore	Dos,Lock
;	move.l	d0,d1
;	beq.b	.nah
;	lob	UnLock
;	move.l	d4,d7
;.nah


* d7 = tied.nimi
loadprefs2

	push	d7
	move	#200,wbkorkeus(a5)
	move	#640,wbleveys(a5)
	move	#360,windowpos(a5)		* pistet��n ikkunoiden paikat
	move	#23,windowpos+2(a5)
	move	#360,windowpos2(a5)
	move	#23,windowpos2+2(a5)
	move	#42,windowpos_p(a5)
	move	#18,windowpos_p+2(a5)
	move	#259,quadpos(a5)
	move	#157,quadpos+2(a5)
	bsr.w	aseta_vakiot

	pop	d1

	move.l	_DosBase(a5),a6
	move.l	#1005,d2
	lob	Open
	move.l	d0,d4
	beq.w	.nope
	lea	prefsdata(a5),a0
	move.l	a0,d2
	move.l	d0,d1
	move.l	#prefs_size,d3
	lob	Read

	cmp.b	#prefsversio,prefsdata(a5)	* Onko oikea versio?
	beq.b	.q
* Vanha prefssi?
* Laitetaan defaultti archivejutut 
	bsr.w	defarc
.q
	cmp.l	#prefs_size,d0
	bhi.w	.eeee

* Pistet��n ladatut arvot yms. paikoilleen
	lea	prefsdata(a5),a0
	move.l	prefs_s3mrate(a0),mixirate(a5)
	move.b	prefs_play(a0),playmode(a5)
	move.b	prefs_show(a0),lootamoodi+1(a5)
	move.b	prefs_tempo(a0),tempoflag(a5)
	move.b	prefs_tfmxrate(a0),tfmxmixingrate+1(a5)
	move.b	prefs_s3mmode1(a0),s3mmode1(a5)
	move.b	prefs_s3mmode2(a0),s3mmode2(a5)
	move.b	prefs_s3mmode3(a0),s3mmode3(a5)
	move.b	prefs_quadmode(a0),quadmode(a5)
	move.l	prefs_mainpos1(a0),windowpos(a5)
	move.l	prefs_mainpos2(a0),windowpos2(a5)
	move.l	prefs_prefspos(a0),windowpos_p(a5)
	move.l	prefs_quadpos(a0),quadpos(a5)
	move.b	prefs_quadon(a0),quadon(a5)
	move.b	prefs_ptmix(a0),ptmix(a5)
	move.b	prefs_xpkid(a0),xpkid(a5)
	move.b	prefs_fade(a0),fade(a5)
	move.b	prefs_pri(a0),d0
	ext	d0
	ext.l	d0
	move.l	d0,priority(a5)
	move.b	prefs_boxsize(a0),boxsize+1(a5)
	move.b	prefs_boxsize(a0),boxsize0+1(a5)
	move.b	prefs_doubleclick(a0),doubleclick(a5)
	move.b	prefs_startuponoff(a0),startuponoff(a5)
	move	prefs_timeout(a0),timeout(a5)
	move.b	prefs_hotkey(a0),hotkey(a5)
	move.b	prefs_cerr(a0),contonerr(a5)
	move.b	prefs_ps3mb(a0),ps3mb(a5)
	move.b	prefs_timeoutmode(a0),timeoutmode(a5)
	move.b	prefs_filter(a0),filterstatus(a5)
	move.b	prefs_vbtimer(a0),vbtimer(a5)
	move.b	prefs_groupmode(a0),groupmode(a5)
	move	prefs_alarm(a0),alarm(a5)
	move.b	prefs_stereofactor(a0),stereofactor(a5)
	move.b	prefs_div(a0),divdir(a5)
	move.b	prefs_prefix(a0),prefixcut(a5)
	move.b	prefs_early(a0),earlyload(a5)
	move.l	prefs_infopos2(a0),infopos2(a5)
	move.b	prefs_xfd(a0),xfd(a5)
	move	prefs_infosize(a0),infosize(a5)
	bne.b	.rr
	move	#16,infosize(a5)
.rr
	move.b	prefs_infoon(a0),infoon(a5)
	move.b	prefs_ps3msettings(a0),ps3msettings(a5)
	move.b	prefs_prefsivu(a0),prefsivu+1(a5)
	move.b	prefs_samplebufsiz(a0),samplebufsiz0(a5)
	move.b	prefs_cybercalibration(a0),cybercalibration(a5)
	move	prefs_forcerate(a0),sampleforcerate(a5)

	move.b	prefs_samplecyber(a0),samplecyber(a5)
	move.b	prefs_mpegaqua(a0),mpegaqua(a5)
	move.b	prefs_mpegadiv(a0),mpegadiv(a5)
	move.b	prefs_medmode(a0),medmode(a5)
	move	prefs_medrate(a0),medrate(a5)


	tst.b	uusikick(a5)
	beq.b	.odeldo
	move.l	prefs_textattr(a0),text_attr+4		* ysize jne
	pushpea	prefs_fontname+prefsdata(a5),text_attr
.odeldo

	st	newdirectory(a5)		* Lippu: uusi hakemisto

	bsr.b	sliderit
	bsr.w	setprefsbox
	bsr.w	mainpriority

.eee	
	move.l	d4,d1
	lob	Close	
.nope
	rts

.eeee	

	lea	prefsdata(a5),a0
	move	#prefs_size/2-1,d0
.zapit	clr	(a0)+
	dbf	d0,.zapit

	bsr.b	.eee
	bsr.w	aseta_vakiot

	lea	.err(pc),a1
	bra.w	request


.err	dc.b	"Trouble with the prefs file (wrong version?).",0
 even

sliderit
* mixingrate s3m

	move.l	mixirate(a5),d0
	sub.l	#5000,d0
	divu	#100,d0
	mulu	#65535,d0
	divu	#580-50,d0

	lea	pslider1,a0
	bsr.w	setknob2

* mixingrate tfmx
	lea	pslider2-pslider1(a0),a0
	move	tfmxmixingrate(a5),d0
	subq	#1,d0
	mulu	#65535,d0
	divu	#21,d0
	bsr.w	setknob2

* volumeboost ps3m
	lea	juusto-pslider2(a0),a0
	moveq	#0,d0
	move.b	s3mmode3(a5),d0
	mulu	#65535,d0
	divu	#8,d0
	bsr.w	setknob2

* stereoarvo ps3m
	lea	juust0-juusto(a0),a0
	moveq	#0,d0
	move.b	stereofactor(a5),d0
	mulu	#65535,d0
	divu	#64,d0
	bsr.w	setknob2

* timeout
	lea	kelloke-juust0(a0),a0
	move	timeout(a5),d0
	mulu	#65535,d0
	divu	#1800,d0		* 10*60 sekkaa
	bsr.w	setknob2

* alarm
	lea	kelloke2-kelloke(a0),a0
	move	alarm(a5),d1
	moveq	#0,d0
	move.b	d1,d0
	lsr	#8,d1
	mulu	#60,d1
	add	d1,d0

	mulu	#65535,d0
	divu	#1440,d0
	bsr.w	setknob2

* moduleinfo
	lea	eskimO-kelloke2(a0),a0
	move	infosize(a5),d0
	subq	#3,d0
	mulu	#65535,d0
	divu	#50-3,d0
	bsr.w	setknob2


* samplebuffersize
	lea	sIPULI-eskimO(a0),a0
	moveq	#0,d0
	move.b	samplebufsiz0(a5),d0
	mulu	#65535,d0
	divu	#5,d0
	bsr.w	setknob2

* sampleforcerate
	lea	sIPULI2-sIPULI(a0),a0
	moveq	#0,d0
	move	sampleforcerate(a5),d0
	mulu	#65535,d0
	divu	#600-9,d0
	bsr.w	setknob2



* ahi rate
	move.l	ahi_rate(a5),d0
	sub.l	#5000,d0
	divu	#100,d0
	mulu	#65535,d0
	divu	#580-50,d0

	lea	ahiG4-sIPULI2(a0),a0
	bsr.w	setknob2

* ahi master volume
	moveq	#0,d0
	move	ahi_mastervol(a5),d0
	mulu	#65535,d0
	divu	#1000,d0

	lea	ahiG5-ahiG4(a0),a0
	bsr.w	setknob2

* ahi stereo level
	moveq	#0,d0
	move	ahi_stereolev(a5),d0
	mulu	#65535,d0
	divu	#100,d0

	lea	ahiG6-ahiG5(a0),a0
	bsr	setknob2

* mixingrate med

	moveq	#0,d0
	move	medrate(a5),d0
	sub.l	#5000,d0
	divu	#100,d0
	mulu	#65535,d0
	divu	#580-50,d0
	lea	nAMISKA5-ahiG6(a0),a0
	bsr.w	setknob2

	rts


setprefsbox
* boxsize
	lea	meloni,a0
	move	boxsize(a5),d0
	beq.b	.x
	subq	#2,d0
.x	mulu	#65535,d0
	divu	#51-3,d0
	bra.w	setknob2


saveprefs
	move.l	windowbase(a5),d0
	beq.b	.h
	move.l	d0,a0
	tst.b	kokolippu(a5)
	beq.b	.smal
	move.l	4(a0),windowpos(a5)
	bra.b	.h
.smal	move.l	4(a0),windowpos2(a5)

.h	move.l	windowbase2(a5),d0
	beq.b	.g
	move.l	d0,a0
	move.l	4(a0),windowpos_p(a5)
.g	

	clr.b	prefs_quadon+prefsdata(a5)
	tst.b	scopeflag(a5)
	beq.b	.kk
	st	prefs_quadon+prefsdata(a5)
.kk

	tst	info_prosessi(a5)
	sne	prefs_infoon+prefsdata(a5)


	move.l	windowbase3(a5),d0
	beq.b	.k
	move.l	d0,a0
	move.l	4(a0),quadpos(a5)
	st	prefs_quadon+prefsdata(a5)
.k
	move.l	swindowbase(a5),d0
	beq.b	.gg
	move.l	d0,a0
	move.l	4(a0),infopos2(a5)
.gg


* Arvot yms. prefs-tiedostoon
	lea	prefsdata(a5),a0
	move.b	#prefsversio,(a0)
	move.l	mixirate(a5),prefs_s3mrate(a0)
	move.b	playmode(a5),prefs_play(a0)
	move.b	lootamoodi+1(a5),prefs_show(a0)
	move.b	tempoflag(a5),prefs_tempo(a0)
	move.b	tfmxmixingrate+1(a5),prefs_tfmxrate(a0)
	move.b	s3mmode1(a5),prefs_s3mmode1(a0)
	move.b	s3mmode2(a5),prefs_s3mmode2(a0)
	move.b	s3mmode3(a5),prefs_s3mmode3(a0)
	move.b	quadmode(a5),prefs_quadmode(a0)
	move.l	windowpos(a5),prefs_mainpos1(a0)
	move.l	windowpos2(a5),prefs_mainpos2(a0)
	move.l	windowpos_p(a5),prefs_prefspos(a0)
	move.l	quadpos(a5),prefs_quadpos(a0)
	move.b	ptmix(a5),prefs_ptmix(a0)
	move.b	xpkid(a5),prefs_xpkid(a0)
	move.b	fade(a5),prefs_fade(a0)
	move.b	priority+3(a5),prefs_pri(a0)
	move.b	boxsize+1(a5),prefs_boxsize(a0)
	move.b	doubleclick(a5),prefs_doubleclick(a0)
	move.b	startuponoff(a5),prefs_startuponoff(a0)
	move	timeout(a5),prefs_timeout(a0)
	move.b	hotkey(a5),prefs_hotkey(a0)
	move.b	contonerr(a5),prefs_cerr(a0)
	move.b	ps3mb(a5),prefs_ps3mb(a0)
	move.b	timeoutmode(a5),prefs_timeoutmode(a0)
	move.b	filterstatus(a5),prefs_filter(a0)
	move.b	vbtimer(a5),prefs_vbtimer(a0)
	move.b	groupmode(a5),prefs_groupmode(a0)
	move	alarm(a5),prefs_alarm(a0)
	move.b	stereofactor(a5),prefs_stereofactor(a0)
	move.b	divdir(a5),prefs_div(a0)
	move.b	prefixcut(a5),prefs_prefix(a0)
	move.b	earlyload(a5),prefs_early(a0)
	move.l	infopos2(a5),prefs_infopos2(a0)
	move.b	xfd(a5),prefs_xfd(a0)
	move	infosize(a5),prefs_infosize(a0)
	move.b	ps3msettings(a5),prefs_ps3msettings(a0)
	move.b	prefsivu+1(a5),prefs_prefsivu(a0)
	move.b	kokolippu(a5),prefs_kokolippu(a0)
	not.b	prefs_kokolippu(a0)
	move.b	samplebufsiz0(a5),prefs_samplebufsiz(a0)
	move.b	cybercalibration(a5),prefs_cybercalibration(a0)
	move	sampleforcerate(a5),prefs_forcerate(a0)

	move.b	samplecyber(a5),prefs_samplecyber(a0)
	move.b	mpegaqua(a5),prefs_mpegaqua(a0)
	move.b	mpegadiv(a5),prefs_mpegadiv(a0)
	move.b	medmode(a5),prefs_medmode(a0)
	move	medrate(a5),prefs_medrate(a0)


	move.l	text_attr+4,prefs_textattr(a0)
	move.l	text_attr,a1
	lea	prefs_fontname(a0),a2
.cec	move.b	(a1)+,(a2)+
	bne.b	.cec
	

.ohi
	move.l	_DosBase(a5),a6
	pushpea	prefsfilename(pc),d1
	move.l	#1006,d2
	lob	Open
	move.l	d0,d4
	beq.b	.nope
	lea	prefsdata(a5),a0
	move.l	a0,d2
	move.l	d0,d1
	move.l	#prefs_size,d3
	lob	Write
	cmp.l	#prefs_size,d0
	bne.b	.eeef
.clc	move.l	d4,d1
	lob	Close
.nope	rts

.eeef	bsr.b	.clc
	lea	.errr(pc),a1
	bra.w	request

.errr	dc.b	"Couldn't save prefs file!",0

prefsfilename dc.b	"S:HippoPlayer.prefs",0
;prefsfilename2 dc.b	"PROGDIR:HippoPlayer.prefs",0
 even

*******************************************************************************
* Asetetaan vakioarvot yms.

defarc
	lea	.lha(pc),a0
	lea	arclha(a5),a1
	bsr.w	copyb

	lea	.zip(pc),a0
	lea	arczip(a5),a1
	bsr.w	copyb

	lea	.lzx(pc),a0
	lea	arclzx(a5),a1
	bsr.w	copyb

	lea	.arc(pc),a0
	lea	arcdir(a5),a1
	bra.w	copyb
;	rts

.arc	dc.b	"RAM:",0

.lha	dc.b	'c:lha >nil: x -IqmMNQw "%s"',0
* m	no messages for query
* q	be quiet
* M	no autoshow files
* N	no progress indicator
* I	ignore LHAOPTS variable
* Qw	disable wildcards

.zip	dc.b	'c:unzip >nil: -qq "%s"',0
* qq	be very quiet

.lzx	dc.b 'c:lzx >nil: -m -q x "%s"',0
 even
	

aseta_vakiot
	bsr.w	nupit
	move	#64,mainvolume(a5)
	move	#-1,playingmodule(a5)
	move	#-1,chosenmodule(a5)
	move	#12,tfmxmixingrate(a5)
	move.b	#pm_repeat,playmode(a5)		* lippu: toistetaan
	move.l	#10000,mixirate(a5)
	move	#CHECKSUM,textchecksum(a5)
	move	#12,tfmxmixingrate(a5)
	move.b	#2,s3mmode1(a5)
	move.b	#sm_surround,s3mmode2(a5)
	clr.b	s3mmode3(a5)
	move	#8,boxsize(a5)
	move	#8,boxsize0(a5)
	move.b	#2,ps3mb(a5)	* 4,8,16,32,64
	move.b	#32,stereofactor(a5)
	move	#16,infosize(a5)

	move	#8,text_attr+4

	lea	check_keyfile,a2

	lea	.defgroup(pc),a0
	lea	groupname(a5),a1
	bsr.b	copyb
	
	st	newdirectory(a5)
	lea	.defdir1(pc),a0
	lea	moduledir(a5),a1
	bsr.b	copyb

	lea	.defdir1(pc),a0
	lea	prgdir(a5),a1
	bsr.b	copyb

	lea	.defdir2(pc),a0
	lea	arcdir(a5),a1
	bsr.b	copyb

	lea	.wb(pc),a0
	lea	pubscreen(a5),a1
	bsr.b	copyb

	lea	.pat(pc),a0
	lea	pattern(a5),a1
	bsr.b	copyb

	move.l	a2,keycheckroutine(a5)

	bra.w	defarc
;	rts

.defgroup dc.b	"S:HippoPlayer.Group",0
.defdir1 dc.b	"SYS:",0
.defdir2 dc.b	"RAM:",0
.wb	dc.b	"Workbench",0
.pat	dc.b	"~(#?.info|smpl.#?)",0
 even

bcopy
copyb	move.b	(a0)+,(a1)+
	bne.b	copyb
	rts



******************************************************************************
* Lataa PS3M asetustiedoston

loadps3msettings

	move.l	_DosBase(a5),a6

; ifeq asm
;	tst.b	uusikick(a5)
;	beq.b	.old
;	lea	.n2(pc),a0
;	move.b	#"R",.n1-.n2(a0)
;	move.l	a0,d1
;	move.l	#1005,d2
;	lob	Open
;	move.l	d0,d4
;	bne.b	.ok
;.old
; endc

	lea	.n1(pc),a0
;	move.b	#'S',(a0)
	move.l	a0,d1
	move.l	#1005,d2
	lob	Open
	move.l	d0,d4
	beq.b	.xx
.ok
	move.l	d4,d1		* selvitet��n filen pituus
	moveq	#0,d2	
	moveq	#1,d3
	lob	Seek
	move.l	d4,d1
	moveq	#0,d2	
	moveq	#1,d3
	lob	Seek
	move.l	d0,d5

	move.l	d4,d1		* alkuun
	moveq	#0,d2
	moveq	#-1,d3
	lob	Seek

	move.l	d5,d0
	moveq	#MEMF_PUBLIC,d1
	bsr.w	getmem
	move.l	d0,d7
	beq.b	.x

	move.l	d4,d1
	move.l	d7,d2
	move.l	d5,d3
	lob	Read
	cmp.l	d5,d0
	bne.b	.er

	move.l	d7,ps3msettingsfile(a5)
	bra.b	.x
.er
	move.l	d7,a0
	bsr.w	freemem

.x	move.l	d4,d1
	beq.b	.xx
	lob	Close	

.xx	rts


;.n2	dc.b	"PROGDI"
;.n1	dc.b	"R:HippoPlayer.PS3M",0
.n1	dc.b	"S:HippoPlayer.PS3M",0
 even


*********************************************************************
* Ladataan CyberSound 14-bit kalibraatiotiedosto

loadcybersoundcalibration
	tst.b	cybercalibration(a5)
	beq.b	.xx
	tst.l	calibrationaddr(a5)
	bne.b	.xx

	moveq	#0,d7


	move.l	_DosBase(a5),a6
	pushpea	calibrationfile(a5),d1
	move.l	#1005,d2
	lob	Open
	move.l	d0,d4
	bne.b	.ok

.err	lea	.er1(pc),a1
	bsr.w	request
	bra.b	.x
.ok

	move.l	#256,d0
	moveq	#MEMF_PUBLIC,d1
	bsr.w	getmem
	move.l	d0,d7
	beq.b	.err

	move.l	d4,d1
	move.l	d7,d2
	move.l	#256,d3
	lob	Read
	cmp.l	#256,d0
	bne.b	.err

	move.l	d7,calibrationaddr(a5)
	bra.b	.kos

.x
	tst.l	d7
	beq.b	.kos
	move.l	d7,a0
	bsr.w	freemem
.kos
	move.l	d4,d1
	beq.b	.xx
	lob	Close	
.xx	rts

.er1	dc.b	"Unable to load calibration file!",0
 even

******************************************************************************
* Piirt�� tekstuurin ikkunaan

drawtexture
	movem.l	d0-a6,-(sp)
	ext.l	d0
	ext.l	d1
	ext.l	d2
	ext.l	d3
	movem.l	d0-d3,-(sp)

	move.l	rp_AreaPtrn(a2),d6
	move.b	rp_AreaPtSz(a2),d7

	lea	.texture(pc),a0
	move.l	a0,rp_AreaPtrn(a2)
	move.b	#1,rp_AreaPtSz(a2)

	move.l	a2,a1
	move.l	pen_0(a5),d0
	lore	GFX,SetAPen
	move.l	a2,a1

	move.l	pen_3(a5),d0
	lob	SetBPen

	movem.l	(sp)+,d0-d3
	move.l	a2,a1
	add	windowleft(a5),d0
	add	windowtop(a5),d1
	add	windowleft(a5),d2
	add	windowtop(a5),d3
	lob	RectFill

	move.l	a2,a1
	move.l	pen_1(a5),d0
	lob	SetAPen
	move.l	a2,a1
	move.l	pen_0(a5),d0
	lob	SetBPen

	move.l	d6,rp_AreaPtrn(a2)
	move.b	d7,rp_AreaPtSz(a2)
	
	movem.l	(sp)+,d0-a6
	rts

.texture dc	$5555,$aaaa


*******************************************************************************
* Preferences
* Luodaan erillinen prosessi
*******

updateprefs
	pushm	all
	tst	prefs_prosessi(a5)
	beq.b	.x
	move.l	prefs_task(a5),d0
	beq.b	.x
	move.l	d0,a1
	moveq	#0,d0
	move.b	prefs_signal2(a5),d1
	bset	d1,d0
	lore	Exec,Signal
.x	popm	all
	rts

* T�m� aiheutti enforcer-hitin jos ei ollut prefs-taskia!

sulje_prefs
	tst	prefs_prosessi(a5)
	beq.b	.ww
	tst.l	prefs_task(a5)
	beq.b	.ww
	move.l	a6,-(sp)
	moveq	#0,d0			* signaali prefssille lopettamisesta
	move.b	prefs_signal(a5),d1
	bset	d1,d0
	move.l	prefs_task(a5),a1
	lore	Exec,Signal
	move.l	(sp)+,a6
.w	tst	prefs_prosessi(a5)	* odotellaan..
	beq.b	.ww
	bsr.w	dela
	bra.b	.w
.ww	rts

rbutton20
;	bra.b	prefs_code

	tst	prefs_prosessi(a5)	* sammutus jos oli p��ll�
	bne.b	sulje_prefs

.ook	
	movem.l	d0-a6,-(sp)
	move.l	_DosBase(a5),a6
	pushpea	prefsprocname(pc),d1
;	moveq	#0,d2			* pri
	move.l	priority(a5),d2

	pushpea	prefs_segment(pc),d3
	lsr.l	#2,d3
	move.l	#3000,d4
	lob	CreateProc
	tst.l	d0
	beq.b	.error
	addq	#1,prefs_prosessi(a5)
.error	movem.l	(sp)+,d0-a6
	rts


	
prefs_code
	lea	var_b,a5
	addq	#1,prefs_prosessi(a5)	* Lippu: prosessi p��ll�


	clr.b	prefs_exit(a5)		* Lippu

	st	boxsize00(a5)

	move.b	quadmode(a5),scopechanged(a5)

* Arvot yms. v�liaikaismuuttujiin
	move.l	mixirate(a5),mixingrate_new(a5)
	move	tfmxmixingrate(a5),tfmxmixingrate_new(a5)
	move	lootamoodi(a5),lootamoodi_new(a5)
	move.b	tempoflag(a5),tempoflag_new(a5)
	move.b	playmode(a5),playmode_new(a5)
	move.b	newdirectory(a5),newdir_new(a5)
	move.b	s3mmode1(a5),s3mmode1_new(a5)
	move.b	s3mmode2(a5),s3mmode2_new(a5)
	move.b	s3mmode3(a5),s3mmode3_new(a5)
	move.b	quadmode(a5),quadmode_new(a5)
	move.b	ptmix(a5),ptmix_new(a5)
	move.b	xpkid(a5),xpkid_new(a5)
	move.b	fade(a5),fade_new(a5)
	move.b	priority+3(a5),pri_new(a5)
	move.b	doubleclick(a5),dclick_new(a5)
	move.b	startuponoff(a5),startuponoff_new(a5)
	move	boxsize(a5),boxsize_new(a5)
	bsr.w	setprefsbox
	move	timeout(a5),timeout_new(a5)
	move.b	hotkey(a5),hotkey_new(a5)
	move.b	contonerr(a5),cerr_new(a5)
	move.b	doublebuf(a5),dbf_new(a5)
	move.b	nastyaudio(a5),nasty_new(a5)
	move.b	ps3mb(a5),ps3mb_new(a5)
	move.b	timeoutmode(a5),timeoutmode_new(a5)
	move.b	vbtimer(a5),vbtimer_new(a5)
	move.b	groupmode(a5),groupmode_new(a5)
	move	alarm(a5),alarm_new(a5)
	move.b	stereofactor(a5),stereofactor_new(a5)
	move.b	divdir(a5),div_new(a5)
	move.b	prefixcut(a5),prefix_new(a5)
	move.b	earlyload(a5),early_new(a5)
	move.b	xfd(a5),xfd_new(a5)
	move	infosize(a5),infosize_new(a5)
	move.b	ps3msettings(a5),ps3msettings_new(a5)
	move.b	samplebufsiz0(a5),samplebufsiz_new(a5)
	move.b	cybercalibration(a5),cybercalibration_new(a5)
	move	sampleforcerate(a5),sampleforcerate_new(a5)

	move.b	samplecyber(a5),samplecyber_new(a5)
	move.b	mpegaqua(a5),mpegaqua_new(a5)
	move.b	mpegadiv(a5),mpegadiv_new(a5)
	move.b	medmode(a5),medmode_new(a5)
	move	medrate(a5),medrate_new(a5)

	move.l	ahi_rate(a5),ahi_rate_new(a5)
	move	ahi_mastervol(a5),ahi_mastervol_new(a5)
	move.l	ahi_mode(a5),ahi_mode_new(a5)
	move	ahi_stereolev(a5),ahi_stereolev_new(a5)
	move.b	ahi_use(a5),ahi_use_new(a5)
	move.b	ahi_muutpois(a5),ahi_muutpois_new(a5)

	move.b	autosort(a5),autosort_new(a5)


;	move.l	pslider1+gg_SpecialInfo,a0
;	move	pi_HorizPot(a0),s3mmixpot_new(a5)
;	move.l	pslider2+gg_SpecialInfo,a0
;	move	pi_HorizPot(a0),tfmxmixpot_new(a5)
;	move.l	juusto+gg_SpecialInfo,a0
;	move	pi_HorizPot(a0),volumeboostpot_new(a5)
;	move.l	juust0+gg_SpecialInfo,a0
;	move	pi_HorizPot(a0),stereofactorpot_new(a5)
;	move.l	meloni+gg_SpecialInfo,a0
;	move	pi_HorizPot(a0),boxsizepot_new(a5)
;	move.l	kelloke+gg_SpecialInfo,a0
;	move	pi_HorizPot(a0),timeoutpot_new(a5)
;	move.l	kelloke2+gg_SpecialInfo,a0
;	move	pi_HorizPot(a0),alarmpot_new(a5)
;	move.l	eskimO+gg_SpecialInfo,a0
;	move	pi_HorizPot(a0),infosizepot_new(a5)
;	move.l	sIPULI+gg_SpecialInfo,a0
;	move	pi_HorizPot(a0),samplebufsizpot_new(a5)
;	move.l	sIPULI2+gg_SpecialInfo,a0
;	move	pi_HorizPot(a0),sampleforceratepot_new(a5)

	lea	pslider1s+pi_HorizPot,a0
	move	(a0),s3mmixpot_new(a5)
	move	pslider2s-pslider1s(a0),tfmxmixpot_new(a5)
	move	juustos-pslider1s(a0),volumeboostpot_new(a5)
	move	juust0s-pslider1s(a0),stereofactorpot_new(a5)
	move	melonis-pslider1s(a0),boxsizepot_new(a5)
	move	kellokes-pslider1s(a0),timeoutpot_new(a5)
	move	kelloke2s-pslider1s(a0),alarmpot_new(a5)
	move	eskimOs-pslider1s(a0),infosizepot_new(a5)
	move	sIPULIs-pslider1s(a0),samplebufsizpot_new(a5)
	move	sIPULI2s-pslider1s(a0),sampleforceratepot_new(a5)
	move	ahiG4s-pslider1s(a0),ahi_ratepot_new(a5)
	move	ahiG5s-pslider1s(a0),ahi_mastervolpot_new(a5)
	move	ahiG6s-pslider1s(a0),ahi_stereolevpot_new(a5)
	move	nAMISKA5s-pslider1s(a0),medratepot_new(a5)

	lea	fontname_new(a5),a0
	lea	prefs_fontname+prefsdata(a5),a1
.cc	move.b	(a1)+,(a0)+
	bne.b	.cc
		
	lea	ack2,a3
	lea	arclha(a5),a0
	lea	arclha_new(a5),a1
	bsr.w	.copy

	lea	ack3-ack2(a3),a3
	lea	arczip(a5),a0
	lea	arczip_new(a5),a1
	bsr.w	.copy

	lea	ack4-ack3(a3),a3
	lea	arclzx(a5),a0
	lea	arclzx_new(a5),a1
	bsr.b	.copy

	lea	DuU0-ack4(a3),a3
	lea	pattern(a5),a0
	lea	pattern_new(a5),a1
	bsr.b	.copy


	lea	pubscreen_new(a5),a1
	lea	pubscreen(a5),a0
.w	move.b	(a0)+,(a1)+
	bne.b	.w

	lea	groupname(a5),a0
	lea	groupname_new(a5),a1
.ww	move.b	(a0)+,(a1)+
	bne.b	.ww

	lea	moduledir(a5),a0
	lea	moduledir_new(a5),a1
.www	move.b	(a0)+,(a1)+
	bne.b	.www

	lea	prgdir(a5),a0
	lea	prgdir_new(a5),a1
.wwww	move.b	(a0)+,(a1)+
	bne.b	.wwww

	lea	arcdir(a5),a0
	lea	arcdir_new(a5),a1
.wwwww	move.b	(a0)+,(a1)+
	bne.b	.wwwww
	

	lea	startup_new(a5),a1
	lea	startup(a5),a0
	moveq	#120-1,d0
	bsr.b	.cp2

	lea	calibrationfile(a5),a0
	lea	calibrationfile_new(a5),a1
.ww2	move.b	(a0)+,(a1)+
	bne.b	.ww2

	lea	ahi_name(a5),a0
	lea	ahi_name_new(a5),a1
.w32	move.b	(a0)+,(a1)+
	bne.b	.w32


	lea	fkeys_new(a5),a1
	lea	fkeys(a5),a0
	move	#10*120-1,d0
	bsr.b	.cp2

	bra.b	.ohi

.copy	
	move.l	gg_SpecialInfo(a3),a2
	move.l	si_Buffer(a2),a2	* Teksipuskuri

.c	move.b	(a0),(a1)+
	move.b	(a0)+,(a2)+
	bne.b	.c
	rts

.cp2	move.b	(a0)+,(a1)+
	dbf	d0,.cp2
	rts

.ohi


	bsr.w	inittick


	move	#GFLG_DISABLED,d0

	tst.b	uusikick(a5)		* uusi kick?
	bne.b	.uusi
** Disabloidaan screengadgetti!
;	or	d0,gg_Flags+pbutton13
** Disabloidaan ahi-valinta
	or	d0,gg_Flags+VaL6

.uusi
** Disabloidaan Early load
;	or	d0,bUu3+gg_Flags


	move.l	_IntuiBase(a5),a6
	lea	winstruc2,a0
	move	wbkorkeus(a5),d0	* Onko ikkuna liian suuri?
	cmp	nw_Height(a0),d0	* Kutistetaan 200:aan pixeliin
	bhi.b	.ok
	move	d0,nw_Height(a0)
.ok

	move.l	windowpos_p(a5),(a0)	* Paikka

	bsr.w	tark_mahtu

	lob	OpenWindow
	move.l	d0,windowbase2(a5)
	beq.w	exprefs

	move.l	d0,a0
	move.l	wd_RPort(a0),rastport2(a5)
	move.l	wd_UserPort(a0),userport2(a5)

	bsr.w	setscrtitle


	tst.b	uusikick(a5)
	beq.b	.vanaha
	move.l	rastport2(a5),a2
	moveq	#4,d0
	moveq	#11,d1
	move	#452-6,d2
	move	#182-15,d3
	bsr.w	drawtexture

.ohih

* pagenappulot
	lea	VaL1,a0
	bsr.b	.cler2
	lea	VaL2-VaL1(a0),a0
	bsr.b	.cler2
	lea	VaL3-VaL2(a0),a0
	bsr.b	.cler2
	lea	VaL4-VaL3(a0),a0
	bsr.b	.cler2
	lea	VaL5-VaL4(a0),a0
	bsr.b	.cler2
	lea	VaL6-VaL5(a0),a0
	bsr.b	.cler2
	lea	VaL7-VaL6(a0),a0
	bsr.b	.cler2

* saveusecancel-alue
	lea	pbutton14,a0
	bsr.b	.cler2
	lea	pbutton6-pbutton14(a0),a0
	bsr.b	.cler2
	lea	pbutton7-pbutton6(a0),a0
	bsr.b	.cler2
	bra.b	.oru

.cler2
	movem	4(a0),d0/d1/d4/d5
	sub	windowleft(a5),d0
	sub	windowtop(a5),d1
	bra.w	pcler
.oru
.vanaha


	move.l	rastport2(a5),a1
	move.l	fontbase(a5),a0
	lore	GFX,SetFont	




* sitten isket��n gadgetit ikkunaan..
	move.l	windowbase2(a5),a0
	lea	gadgets2,a1
	moveq	#-1,d0
	moveq	#-1,d1
	sub.l	a2,a2
	lore	Intui,AddGList
	lea	gadgets2,a0
	move.l	windowbase2(a5),a1
	sub.l	a2,a2
	lob	RefreshGadgets


	move.l	rastport2(a5),a1
	move.l	pen_1(a5),d0
	lore	GFX,SetAPen
	move.l	pen_0(a5),d0
	move.l	rastport2(a5),a1
	lob	SetBPen


	move.l	(a5),a6
	sub.l	a1,a1
	lob	FindTask
	move.l	d0,prefs_task(a5)

	moveq	#-1,d0
	lob	AllocSignal
	move.b	d0,prefs_signal(a5)
;	bmi.w	exprefs
	moveq	#-1,d0
	lob	AllocSignal
	move.b	d0,prefs_signal2(a5)
;	bmi.w	exprefs

	bsr.w	prefsgads


	moveq	#12,d4			* laatikko
	moveq	#31,d5
	move	#439,d6
	move	#146,d7
	add	windowleft(a5),d4
	add	windowleft(a5),d6
	add	windowtop(a5),d5
	add	windowtop(a5),d7
	move.l	rastport2(a5),a1
	bsr.w	laatikko3


	bra.b	msgloop2
returnmsg2
	bsr.w	flush_messages2
msgloop2
	tst.b	prefs_exit(a5)
	bne.w	exprefs

	move.l	(a5),a6
	moveq	#0,d0
	move.l	userport2(a5),a4
	move.b	MP_SIGBIT(a4),d1	* IDCMP signalibitti
	bset	d1,d0
	move.b	prefs_signal(a5),d1	* oma signaali
	bset	d1,d0
	move.b	prefs_signal2(a5),d1	* oma signaali ikkunan p�ivitykseen
	bset	d1,d0
	lob	Wait			* Odotellaan...

	move.b	prefs_signal(a5),d1	* k�skeek� p��ohjelma lopettamaan?
	btst	d1,d0
	bne.w	exprefs

	move.b	prefs_signal2(a5),d1	* p�ivitys?
	btst	d1,d0
	beq.b	.naa
	pushm	all
	cmp	#4,prefsivu(a5)
	bne.b	.er
	bsr.w	prefsgads
	bra.b	.er2
.er	bsr.w	pupdate
.er2	popm	all
.naa

* Vastataan IDCMP:n viestiin

	move.l	userport2(a5),a4
	move.l	a4,a0
	lob	GetMsg
	tst.l	d0
	beq.b	msgloop2

	move.l	d0,a1
	move.l	im_Class(a1),d2		* luokka	
	move	im_Code(a1),d3		* koodi
	move.l	im_IAddress(a1),a2 	* gadgetin tai olion osoite
	move	im_MouseX(a1),d6	* mousen koordinaatit
	move	im_MouseY(a1),d7

	lob	ReplyMsg

	cmp.l	#IDCMP_RAWKEY,d2
	bne.b	.nr
	tst.b	d3
	bmi.w	returnmsg2
	move	d3,rawkeyinput(a5)
	move.b	ownsignal7(a5),d1
	bsr.w	signalit
	bra.w	returnmsg2
.nr
	cmp.l	#IDCMP_MOUSEMOVE,d2
	beq.w	mousemoving2
	cmp.l	#IDCMP_GADGETUP,d2
	beq.w	gadgetsup2
	cmp.l	#IDCMP_MOUSEBUTTONS,d2
	beq.w	pmousebuttons
	cmp.l	#IDCMP_CLOSEWINDOW,d2
	bne.w	msgloop2

	bsr.w	flush_messages2

exprefs	move.l	_IntuiBase(a5),a6		

	move.l	windowbase2(a5),d0
	beq.b	.eek

	move.l	d0,a0
	move.l	prefsivugads(a5),d0
	beq.b	.hh
	move.l	d0,a1
	moveq	#-1,d0
	moveq	#-1,d1
	sub.l	a2,a2
	lob	RemoveGList
	clr.l	prefsivugads(a5)
.hh
	move.l	windowbase2(a5),a0
	move.l	4(a0),windowpos_p(a5)
	lob	CloseWindow
	clr.l	windowbase2(a5)
.eek
	move.l	(a5),a6

	moveq	#0,d0
	move.b	prefs_signal(a5),d0
	bmi.b	.yyk
	lob	FreeSignal
.yyk	
	moveq	#0,d0
	move.b	prefs_signal2(a5),d0
	bmi.b	.yyk2
	lob	FreeSignal
.yyk2

	bsr.w	freepubwork		* Vapautetaan mahd. pubscreenlocki
	clr.l	pubwork(a5)

	tst.b	prefs_exit(a5)
	beq.w	.cancelled
	cmp.b	#-1,prefs_exit(a5)	* Cancel
	beq.w	.cancelled

** USE

	move.l	mixingrate_new(a5),mixirate(a5)
	move	tfmxmixingrate_new(a5),tfmxmixingrate(a5)
	move	lootamoodi_new(a5),lootamoodi(a5)
	move.b	tempoflag_new(a5),tempoflag(a5)
	move.b	playmode_new(a5),playmode(a5)
	move.b	s3mmode1_new(a5),s3mmode1(a5)
	move.b	s3mmode2_new(a5),s3mmode2(a5)
	move.b	s3mmode3_new(a5),s3mmode3(a5)
	move.b	quadmode_new(a5),quadmode(a5)
	move.b	ptmix_new(a5),ptmix(a5)
	move.b	xpkid_new(a5),xpkid(a5)
	move.b	fade_new(a5),fade(a5)
	move.b	pri_new(a5),d0
	ext	d0
	ext.l	d0
	move.l	d0,priority(a5)
	move	boxsize_new(a5),boxsize(a5)
	move.b	dclick_new(a5),doubleclick(a5)
	move.b	startuponoff_new(a5),startuponoff(a5)
	move	timeout_new(a5),timeout(a5)
	move.b	hotkey_new(a5),hotkey(a5)
	move.b	cerr_new(a5),contonerr(a5)
	move.b	dbf_new(a5),doublebuf(a5)
	move.b	nasty_new(a5),nastyaudio(a5)
	move.b	ps3mb_new(a5),ps3mb(a5)
	move.b	timeoutmode_new(a5),timeoutmode(a5)
	move.b	vbtimer_new(a5),vbtimer(a5)
	move.b	groupmode_new(a5),groupmode(a5)

	move	alarm_new(a5),alarm(a5)
	move.b	stereofactor_new(a5),stereofactor(a5)
	move.b	div_new(a5),divdir(a5)
	move.b	prefix_new(a5),prefixcut(a5)
	move.b	early_new(a5),earlyload(a5)
	move.b	xfd_new(a5),xfd(a5)
	move.b	ps3msettings_new(a5),ps3msettings(a5)
	move.b	samplebufsiz_new(a5),samplebufsiz0(a5)
	move.b	cybercalibration_new(a5),cybercalibration(a5)
	move	sampleforcerate_new(a5),sampleforcerate(a5)

	move.b	samplecyber_new(a5),samplecyber(a5)
	move.b	mpegaqua_new(a5),mpegaqua(a5)
	move.b	mpegadiv_new(a5),mpegadiv(a5)
	move.b	medmode_new(a5),medmode(a5)
	move	medrate_new(a5),medrate(a5)

	move.l	ahi_rate_new(a5),ahi_rate(a5)
	move	ahi_mastervol_new(a5),ahi_mastervol(a5)
	move.l	ahi_mode_new(a5),ahi_mode(a5)
	move	ahi_stereolev_new(a5),ahi_stereolev(a5)
	move.b	ahi_use_new(a5),ahi_use(a5)
	move.b	ahi_muutpois_new(a5),ahi_muutpois(a5)

	move.b	autosort_new(a5),autosort(a5)

;	move	infosize_new(a5),infosize(a5)

	move	infosize(a5),d0
	move	infosize_new(a5),infosize(a5)
	cmp	infosize(a5),d0
	beq.b	.eimu
	tst	info_prosessi(a5)
	beq.b	.eimu
** updatetaan infoikkunaa
	bsr.w	sulje_info
	move.b	oli_infoa(a5),d7
	st	oli_infoa(a5)
	push	d7
	bsr.w	start_info
	pop	d7
	move.b	d7,oli_infoa(a5)

.eimu

** asetetaan fontti
	tst	boxsize00(a5)
	bne.b	.enor
	clr	boxsize0(a5)

	tst.b	uusikick(a5)
	beq.b	.enor
	tst.l	_DiskFontBase(a5)	* lib?
	beq.b	.enor

	lore	Exec,Forbid
	move.l	prefs_textattr+prefsdata(a5),text_attr+4
	pushpea	prefs_fontname+prefsdata(a5),text_attr

	move.l	fontbase(a5),a1
	lore	GFX,CloseFont
	lea	text_attr,a0
	lore	DiskFont,OpenDiskFont
	move.l	d0,fontbase(a5)
	lore	Exec,Permit

	tst	info_prosessi(a5)
	beq.b	.enor
	bsr.w	rbutton10b
	bsr.w	rbutton10b
.enor


	tst.b	newdirectory(a5)
	beq.b	.aaps
	lea	moduledir_new(a5),a0
	lea	moduledir(a5),a1
	bsr.w	.copy
.aaps
	tst.b	newdirectory2(a5)
	beq.b	.aaps2
	lea	prgdir_new(a5),a0
	lea	prgdir(a5),a1
	bsr.w	.copy
.aaps2
	lea	arcdir_new(a5),a0
	lea	arcdir(a5),a1
	bsr.w	.copy

	lea	arclha_new(a5),a0
	lea	arclha(a5),a1
	bsr.w	.copy
	lea	arczip_new(a5),a0
	lea	arczip(a5),a1
	bsr.w	.copy
	lea	arclzx_new(a5),a0
	lea	arclzx(a5),a1
	bsr.w	.copy
	lea	pattern_new(a5),a0
	lea	pattern(a5),a1
	bsr.w	.copy

	lea	pubscreen_new(a5),a0
	lea	pubscreen(a5),a1
	bsr.b	.copy

	lea	groupname_new(a5),a0
	lea	groupname(a5),a1
	bsr.b	.copy

	lea	calibrationfile_new(a5),a0
	lea	calibrationfile(a5),a1
	bsr.b	.copy

	lea	ahi_name_new(a5),a0
	lea	ahi_name(a5),a1
	bsr.b	.copy

	lea	startup_new(a5),a0
	lea	startup(a5),a1
	moveq	#120-1,d0
	bsr.b	.copy2

	lea	fkeys_new(a5),a0
	lea	fkeys(a5),a1
	move	#10*120-1,d0
	bsr.b	.copy2


* ladataan caib fle jos tarpeen

	tst.b	cybercalibration(a5)
	beq.b	.dw
	tst.l	calibrationaddr(a5)
	beq.b	.dw2
	tst.b	newcalibrationfile(a5)
	beq.b	.dw
	move.l	calibrationaddr(a5),a0
	bsr.w	freemem
	clr.l	calibrationaddr(a5)
.dw2	bsr.w	loadcybersoundcalibration
.dw	clr.b	newcalibrationfile(a5)



	cmp.b	#2,prefs_exit(a5)	* Tallennetaanko??
	bne.w	.jee
	bsr.w	saveprefs
	bra.w	.jee

.copy	move.b	(a0)+,(a1)+
	bne.b	.copy
	rts
.copy2	move.b	(a0)+,(a1)+
	dbf	d0,.copy2
	rts

.cancelled
* Pistet��n vanhat asennot propgadgetteihin
;	move.l	pslider1+gg_SpecialInfo,a0
;	move	s3mmixpot_new(a5),pi_HorizPot(a0)
;	move.l	pslider2+gg_SpecialInfo,a0
;	move	tfmxmixpot_new(a5),pi_HorizPot(a0)
;	move.l	juusto+gg_SpecialInfo,a0
;	move	volumeboostpot_new(a5),pi_HorizPot(a0)
;	move.l	juust0+gg_SpecialInfo,a0
;	move	stereofactorpot_new(a5),pi_HorizPot(a0)
;	move.l	meloni+gg_SpecialInfo,a0
;	move	boxsizepot_new(a5),pi_HorizPot(a0)
;	move.l	eskimO+gg_SpecialInfo,a0
;	move	infosizepot_new(a5),pi_HorizPot(a0)
;	move.l	kelloke+gg_SpecialInfo,a0
;	move	timeoutpot_new(a5),pi_HorizPot(a0)
;	move.l	kelloke2+gg_SpecialInfo,a0
;	move	alarmpot_new(a5),pi_HorizPot(a0)
;	move.l	sIPULI+gg_SpecialInfo,a0
;	move	samplebufsizpot_new(a5),pi_HorizPot(a0)
;	move.l	sIPULI2+gg_SpecialInfo,a0
;	move	sampleforceratepot_new(a5),pi_HorizPot(a0)


	lea	pslider1s+pi_HorizPot,a0
	move	s3mmixpot_new(a5),(a0)
	move	tfmxmixpot_new(a5),pslider2s-pslider1s(a0)
	move	volumeboostpot_new(a5),juustos-pslider1s(a0)
	move	stereofactorpot_new(a5),juust0s-pslider1s(a0)
	move	boxsizepot_new(a5),melonis-pslider1s(a0)
	move	infosizepot_new(a5),eskimOs-pslider1s(a0)
	move	timeoutpot_new(a5),kellokes-pslider1s(a0)		
	move	alarmpot_new(a5),kelloke2s-pslider1s(a0)
	move	samplebufsizpot_new(a5),sIPULIs-pslider1s(a0)	
	move	sampleforceratepot_new(a5),sIPULI2s-pslider1s(a0)	
	move	ahi_ratepot_new(a5),ahiG4s-pslider1s(a0)
	move	ahi_mastervolpot_new(a5),ahiG5s-pslider1s(a0)
	move	ahi_stereolevpot_new(a5),ahiG6s-pslider1s(a0)
	move	medratepot_new(a5),nAMISKA5s-pslider1s(a0)


	move.b	newdir_new(a5),newdirectory(a5)

	move.l	text_attr+4,prefs_textattr+prefsdata(a5)
	lea	fontname_new(a5),a0
	lea	prefs_fontname+prefsdata(a5),a1
.cec	move.b	(a0)+,(a1)+
	bne.b	.cec
	move	boxsize(a5),boxsize0(a5)	* ei vaihdettu fonttia..
	

	move.b	s3mmode3(a5),s3mmode3_new(a5)
	bsr.w	updateps3m
	move.b	stereofactor(a5),stereofactor_new(a5)
	bsr.w	updateps3m2

	move	ahi_mastervol(a5),ahi_mastervol_new(a5)
	move	ahi_stereolev(a5),ahi_stereolev_new(a5)
	bsr.w	updateahi

	

	clr.b	newpubscreen2(a5)
.jee	

	lore	Exec,Forbid		* kielletaan muut taskit!

	bsr.w	mainpriority

	move.b	ownsignal2(a5),d1
	bsr.w	signalit		* signaali: poistutaan preffsist�..

	st	prefsexit(a5)

	move.b	newpubscreen2(a5),newpubscreen(a5)
	clr.b	newpubscreen2(a5)
	
	clr.l	prefs_task(a5)
	clr	prefs_prosessi(a5)	* Lippu: prosessi poistettu
	rts

flush_messages2
	move.l	(a5),a6
	move.l	userport2(a5),a0	* flushataan pois kaikki messaget
	lob	GetMsg
	tst.l	d0
	beq.b	.ex
	move.l	d0,a1
	lob	ReplyMsg
	bra.b	flush_messages2
.ex	rts



* d0,d1: x,y
* d4,d5: x-koko,y-koko

pcler	
	push	a0
	move.l	rastport2(a5),a0
	move.l	a0,a1
	add	windowleft(a5),d0
	add	windowtop(a5),d1
	move	d0,d2
	move	d1,d3
	moveq	#$0a,d6
	lore	GFX,ClipBlit
	pop	a0
	rts



****************************************************************
*** T�r�ytet��n ikkunaan oikean sivun gadgetit


prefsgads2
	cmp	prefsivu(a5),d0
	beq.b	.xx
	move	d0,prefsivu(a5)
	bra.b	prefsgads
.xx	rts

prefsgads
** Valinta nappulan 'highlight'

	lea	VaL1,a0
	moveq	#7-1,d0
	moveq	#0,d2
.lup	move.l	pen_1(a5),d1
	cmp	prefsivu(a5),d2
	bne.b	.no
	move.l	pen_2(a5),d1
	tst.b	uusikick(a5)
	bne.b	.no
	move.l	pen_3(a5),d1
.no	move.l	gg_GadgetText(a0),a1
	move.b	d1,it_FrontPen(a1)
	move.l	(a0),a0
	addq	#1,d2
	dbf	d0,.lup
	lea	VaL1,a0
	moveq	#6,d0
	move.l	windowbase2(a5),a1
	sub.l	a2,a2
	lore	Intui,RefreshGList


	moveq	#13,d0		* laatikko
	moveq	#32,d1
	move	#439,d4
	move	#146,d5
	sub	d0,d4
	sub	d1,d5
	bsr.w	pcler

	move.l	windowbase2(a5),a0
	move.l	prefsivugads(a5),d0
	beq.b	.hh
	move.l	d0,a1
	moveq	#-1,d0
	moveq	#-1,d1
	sub.l	a2,a2
	lore	Intui,RemoveGList
.hh

	lea	sivu0,a1
	move	prefsivu(a5),d0
	beq.b	.yy
	lea	sivu1-sivu0(a1),a1
	subq	#1,d0
	beq.b	.yy
	lea	sivu2-sivu1(a1),a1
	subq	#1,d0
	beq.b	.yy
	lea	sivu3-sivu2(a1),a1
	subq	#1,d0
	beq.b	.yy
	lea	sivu4-sivu3(a1),a1
	subq	#1,d0
	beq.b	.yy
	lea	sivu5-sivu4(a1),a1
	subq	#1,d0
	beq.b	.yy
	lea	sivu6-sivu5(a1),a1
.yy

	move.l	a1,prefsivugads(a5)

	move.l	windowbase2(a5),a0
	moveq	#-1,d0
	moveq	#-1,d1
	sub.l	a2,a2
	lore	Intui,AddGList
	lea	gadgets2,a0
	move.l	windowbase2(a5),a1
	sub.l	a2,a2
	lob	RefreshGadgets


;	tst.b	uusikick(a5)
;	beq.w	.loru

*** Gadgettien reunojen vahvistus
	lea	gadgets2,a3
.loloop
	move.l	(a3),d3

;	moveq	#GTYP_GTYPEMASK,d7
;	and	gg_GadgetType(a3),d7	* tyyppi
;	cmp.b	#GTYP_PROPGADGET,d7	* ei kosketa slidereihim
;	beq.b	.sli
;	cmp.b	#GTYP_STRGADGET,d7	* eik� stringeihin
;	beq.b	.nel

	move	gg_GadgetType(a3),d7
	subq.b	#GTYP_PROPGADGET,d7
	beq.b	.sli
	subq.b	#GTYP_STRGADGET-GTYP_PROPGADGET,d7
	beq.b	.nel	

	movem	4(a3),plx1/ply1/plx2/ply2
	add	plx1,plx2
	add	ply1,ply2
	subq	#1,ply2
	subq	#1,plx1
	push	d3
	move.l	rastport2(a5),a1
	bsr.w	laatikko1
	pop	d3


.nel	move.l	d3,a3
	tst.l	d3
	bne.b	.loloop
	bra.b	.loru

.sli
	tst.b	uusikick(a5)
	beq.b	.nel

	movem	4(a3),plx1/ply1/plx2/ply2	* fileslider
	add	plx1,plx2
	add	ply1,ply2
	subq	#2,plx1
	addq	#1,plx2
	subq	#2,ply1
	addq	#1,ply2
	push	d3
	move.l	rastport2(a5),a1
	bsr.w	sliderlaatikko
	pop	d3

	bra.b	.nel


.loru


	move.l	rastport2(a5),a1
	move.l	pen_1(a5),d0
	lore	GFX,SetAPen
	move.l	pen_0(a5),d0
	move.l	rastport2(a5),a1
	lob	SetBPen


	bra.w	pupdate
	


****************** 

mousemoving2			* P�ivitet��n propgadgetteja
	movem.l	d0-a6,-(sp)

	move	prefsivu(a5),d0
	bne.b	.x	
	bsr.w	psup4		* timeout
	bsr.w	purealarm	* alarm
	bra.b	.z
.x
	subq	#1,d0
	bne.b	.2
	bsr.w	pbox		* box size
	bsr.w	pinfosize
	bra.b	.z
.2
	subq	#1,d0
	bne.b	.3
	bra.b	.z
.3
	subq	#2,d0
	bne.b	.4
	
	bsr.w	pupdate7	* ps3m volboost
	bsr.w	pupdate7b	* ps3m stereo
	bsr.w	psup1		* ps3m mixingrate
	bra.b	.z

.4
	subq	#1,d0
	bne.b	.5
	
	bsr.w	pahi4		* ahi mixing rate
	bsr.w	pahi5		* ahi master volume
	bsr.w	pahi6		* ahi stereolev
	bra.b	.z

.5
	bsr.w	psup2		* tfmx mixingrate
	bsr.w	psup2b		* samplebufsiz
	bsr.w	psup2c		* sampleforcerate
	bsr.w	pupmedrate	* med mixing rate
	

.z	movem.l	(sp)+,d0-a6
	bra.w	returnmsg2


*** Oikeata nappulaa painettu. Tutkitaan oliko gadgetin p��ll� jolla on
*** requesteri.
pmousebuttons
	cmp	#MENUDOWN,d3		* oikea nappula
	bne.w	returnmsg2

	pushm	all

	move	prefsivu(a5),d0
	bne.b	.1

	lea	pbutton1,a0		* play
	lea	rpbutton2_req(pc),a2
	bsr.w	.check
	lea	tomaatti,a0		* priority
	lea	rpri_req(pc),a2
	bsr.w	.check
	lea	bUu3,a0
	lea	rearly_req(pc),a2
	bsr.w	.check
	bra.w	.xx

.1	subq	#1,d0
	bne.b	.2

	lea	pbutton2,a0		* show
	lea	rpbutton1_req(pc),a2
	bsr.w	.check
	lea	pout3,a0		* scope type
	lea	rquadm_req(pc),a2
	bsr.w	.check
	lea	bUu2,a0			* prefix cut
	lea	rprefx_req(pc),a2
	bsr.w	.check
	bra.b	.xx

.2	subq	#1,d0
	bne.b	.3

	lea	pout1,a0		* filter control
	lea	rpfilt_req(pc),a2
	bsr.b	.check
	lea	laren1,a0		* pt replayer
	lea	rptmix_req(pc),a2
	bsr.b	.check
	lea	PoU2,a0
	lea	rpgmode_req(pc),a2
	bsr.b	.check
	bra.b	.xx

.3	subq	#2,d0
	bne.b	.4

	lea	smode2,a0		* ps3m playmode
	lea	rsmode1_req(pc),a2	
	bsr.b	.check
	lea	smode1,a0		* ps3m state
	lea	rsmode2_req(pc),a2
	bsr.b	.check
	lea	jommo,a0		* ps3m buffer size
	lea	rps3mb_req(pc),a2
	bsr.b	.check
	bra.b	.xx
	
					* ahi sivun ohi
.4	;nop
	subq	#1,d0
	beq.b	.xx
.5

	lea	nAMISKA2,a0
	lea	rmpegaqua_req(pc),a2	* mpega quality
	bsr.b	.check
	lea	nAMISKA3,a0
	lea	rmpegadiv_req(pc),a2	* mpega freq div
	bsr.b	.check
	lea	nAMISKA4,a0
	lea	rmedmode_req(pc),a2	* med mode
	bsr.b	.check


.xx	popm	all
	bra.w	returnmsg2

.check	movem	4(a0),d0-d3
	subq	#1,d3
	add	d0,d2
	add	d1,d3
	cmp	d0,d6
	blo.b	.x
	cmp	d2,d6
	bhi.b	.x
	cmp	d1,d7
	blo.b	.x
	cmp	d3,d7
	bhi.b	.x
	pushm	a0/d6/d7
	jsr	(a2)
	popm	a0/d6/d7
.x	rts
	




pupdate				* Ikkuna p�ivitys
	pushm	all

	move	prefsivu(a5),d0
	bne.b	.2

	bsr.w	pupdate2		* play
	bsr.w	ppri			* priority
	bsr.w	pdclick			* doubleclick
	bsr.w	pstartuponoff		* startup
	bsr.w	psup4			* timeoutslider
	bsr.w	phot			* hotkey
	bsr.w	perr			* cont on err
	bsr.w	pdiv			* divider dir
	bsr.w	pearly			* early load
	bsr.w	purealarm		* alarm slider
	bsr.w	pautosort		* auto sort
	bra.w	.x

.2	subq	#1,d0
	bne.b	.3

	bsr.w	psup3			* scope mode
	bsr.w	pbox			* box size
	bsr.w	psup0			* scope on/off
	bsr.w	pinfosize		* info size
	bsr.w	pupdate1		* show
	bsr.w	pselscreen		* screen
	bsr.w	pscopebar		* scope bars
	bsr.w	pprefx			* prefix cut
	bsr.w	pfont			* fontti
	bsr.w	pscreen			* screen refresh rates
	bra.w	.x

.3	subq	#1,d0
	bne.b	.4

	bsr.w	pipm			* pt replayer
	bsr.w	pupf			* filter
	bsr.w	pupdate3		* pt tempo
	bsr.w	pvbt			* vblank timer
	bsr.w	pnasty			* nasty audio
	bsr.w	ppgfile			* pgfilename
	bsr.w	ppgmode			* pgmode
	bsr.w	ppgstat			* pgstatus
	bsr.w	pdbf			* volume fade
	bra.b	.x

.4	subq	#1,d0
	bne.b	.5

	bsr.w	pux			* xpk id
	bsr.w	pdbuf			* doublebuffering
	bsr.w	pdup			* mod/prg/arc dirrit
	bsr.w	pxfd			* xfdmaster
	bra.b	.x

.5	subq	#1,d0
	bne.b	.6

	bsr.w	pupdate5		* ps3m priority
	bsr.w	pupdate6		* ps3m playmode
	bsr.w	pupdate7		* ps3m volboost
	bsr.w	psup1			* ps3m mixingrate
	bsr.w	pps3mb			* ps3m buffer
	bsr.w	pupdate7b		* stereo
	bsr.w	psettings		* settings file
	bsr.w	pcyber			* cyber calibration
	bsr.w	pcybername		* cyber calibration file name
	bra.b	.x

.6	subq.b	#1,d0
	bne.b	.7
	
	bsr.w	pahi1			* ahi use
	bsr.w	pahi2			* ahi disable others
	bsr.w	pahi3			* ahi select mod
	bsr.w	pahi4			* ahi mixing rate
	bsr.w	pahi5			* ahi master volume
	bsr.w	pahi6			* ahi stereo level
	bra.b	.x


.7
	bsr.w	psup2			* tfmx mixingrate
	bsr.w	psup2b			* samplebufsize
	bsr.w	psup2c			* sampleforcerate
	bsr.w	pupmedrate		* med mixing rate
	bsr.w	psamplecyber		* sample cyber
	bsr.w	pmpegaqua		* MPEGA quality
	bsr.w	pmpegadiv		* MPEGA freq division
	bsr.w	pmedmode		* med mode


.x	popm	all
	rts




***** Tarkistetaan mahtuuko avattava ikkuna ruudulle
* a0 = ikkuna
tark_mahtu
	move	wbleveys(a5),d0		* WB:n leveys
	move	(a0),d1			* Ikkunan x-paikka
	add	4(a0),d1		* Ikkunan oikea laita
	cmp	d0,d1
	bls.b	.ok1
	sub	4(a0),d0	* Jos ei mahdu ruudulle, laitetaan
	move	d0,(a0)		* mahdollisimman oikealle
.ok1	move	wbkorkeus(a5),d0	* WB:n korkeus
	move	2(a0),d1		* Ikkunan y-paikka
	add	6(a0),d1		* Ikkunan oikea laita
	cmp	d0,d1
	bls.b	.ok2
	sub	6(a0),d0	* Jos ei mahdu ruudulle, laitetaan
	move	d0,2(a0)	* mahdollisimman alas
.ok2	rts




**************************
* Tulostaa teksti� gadgetin sis�lle
* a0 = teksti
* a1 = gadgetti

prunt2
	pushm	all
	moveq	#1,d7		* ei korvaa
	bra.b	pru0

prunt
	pushm	all
	moveq	#0,d7
pru0
	movem.l	a0/a1,-(Sp)			* putsaus
	movem	gg_LeftEdge(a1),d0/d1/d4/d5
	move.l	rastport2(a5),a0
	subq	#3,d4
	subq	#4,d5
	addq	#2,d0
	addq	#2,d1

	move.l	a0,a1
	move	d0,d2
	move	d1,d3
	moveq	#$0a,d6
	lore	GFX,ClipBlit
	popm	a0/a1

	* a1 = gadgetti
	* a0 = teksti
	move.l	a0,a2
.fe	tst.b	(a2)+
	bne.b	.fe
	sub.l	a0,a2
	move	a2,d0
	subq	#1,d0

	lsl	#2,d0
	move	gg_Width(a1),d2
	lsr	#1,d2
	sub	d0,d2

	movem	gg_LeftEdge(a1),d0/d1	* x,y
	add	d2,d0
	bsr.b	.pr

	tst	d7
	bne.b	.nok
	move.l	a1,a0
	bsr.w	printkorva2
.nok
	popm	all
	rts

.pr	pushm	all
	addq	#8,d1
	move.l	rastport2(a5),a4
	bra.w	uup	


** Suoritetaan gadgettia vastaava toiminto
gadgetsup2
	movem.l	d0-a6,-(sp)
	move	gg_GadgetID(a2),d0
	add	d0,d0
	cmp	#20*2,d0
	bhs.b	.pag
	lea	.gadlist-2(pc,d0),a0
.x	add	(a0),a0
	jsr	(a0)
	movem.l	(sp)+,d0-a6
	bra.w	returnmsg2

.pag
;	sub	#10*2,d0
	lea	.s0-20*2(pc,d0),a0
	move	prefsivu(a5),d1
	beq.b	.x
	lea	.s1-20*2(pc,d0),a0
	subq	#1,d1
	beq.b	.x
	lea	.s2-20*2(pc,d0),a0
	subq	#1,d1
	beq.b	.x
	lea	.s3-20*2(pc,d0),a0
	subq	#1,d1
	beq.b	.x
	lea	.s4-20*2(pc,d0),a0
	subq	#1,d1
	beq.b	.x
	lea	.s5-20*2(pc,d0),a0
	subq	#1,d1
	beq.b	.x
	lea	.s6-20*2(pc,d0),a0
	bra.b	.x


.gadlist
*** P��gadgetit
	dr	rpbutton14	* save
	dr	rpbutton6	* use
	dr	rpbutton7	* cancel
	dr	rval0		* sivu0
	dr	rval1		* sivu1
	dr	rval2		* sivu2
	dr	rval3		* sivu3
	dr	rval4		* sivu4
	dr	rval5		* sivu5
	dr	rval6		* sivu6

.s0
*** Sivu0
	dr	rpbutton2	* play		* pbutton1
	dr	rtimeoutmode	* timeoutmoodi
	dr	rtimeoutslider	* timeout
	dr	ralarm		* her�tyskello
	dr	rstartup	* startup
	dr	rstartuponoff	* startup on/off
	dr	rfkeys		* fkeys
	dr	rpri		* prioriteetti
	dr	rhotkey		* hotkey
	dr	rdclick		* doubleclick
	dr	rerr		* continue on error
	dr	rearly		* early load
	dr	rdiv		* divider / dir
	dr	rautosort	* autosort

.s1
*** Sivu1
	dr	rpbutton1	* show		* pbutton2
	dr	rselscreen	* publicscreen
	dr	rbox		* boxsize
	dr	rfont		* font selector
	dr	rquad		* scope on/off
	dr	rquadm		* scopen moodi	* pout3
	dr	rscopebar	* bar mode scopeille
	dr	rprefx		* prefix cut
	dr	rinfosize	* module info size

.s2
*** Sivu2
	dr	rpgfile		* pg file select
	dr	rpgmode		* pg mode
	dr	rpfilt		* filtteri
	dr	rdbf		* fadevolume
	dr	rnasty		* nasty audio
	dr	rvbtimer	* vblank timer
	dr	rptmix		* pt norm/fast/ps3m
	dr	rpbutton3	* pt tempo
;	dr	rpslider2	* tfmx rate
;	dr	rpslider2b	* samplebufsiz
;	dr	rpslider2c	* sampleforcerate

.s3
*** Sivu3
	dr	rpbutton10	* moduledir
	dr	rselprgdir	* prgdir
	dr	rselarcdir	* archive dir
	dr	rarch2		* archiver: lha
	dr	rarch4		* archiver: lzx
	dr	rarch3		* archiver: zip
	dr	rdbuf		* doublebuffering
	dr	rxp		* xpk id on/off
	dr	rxfd		* xfdmaster on/off
	dr	rpattern	* file pattern

.s4
*** Sivu4
	dr	rsmode2		* ps3m playmode
	dr	rsmode1		* ps3m priority
	dr	rps3mb		* ps3m mixbuffersize
	dr	rpslider1	* ps3m mixingrate
	dr	rsmode3		* ps3m volumeboost
	dr	rsmode4		* ps3m stereofactor
	dr	rsettings	* settings file on/off
	dr	rcyber		* cyber calibration
	dr	rcybername	* cyber calibration file name

*** Sivu5
.s5	dr	rahi3		* ahi select mode
	dr	rahi1		* ahi use
	dr	rahi2		* ahi disable others
	dr	rahi4		* ahi mixing rate
	dr	rahi5		* ahi master volume
	dr	rahi6		* ahi stereo level

*** Sivu6
.s6
	dr	rpslider2	* tfmx rate
	dr	rpslider2b	* samplebufsiz
	dr	rpslider2c	* sampleforcerate
	dr	rsamplecyber	* sample cybercalibration
	dr	rmpegaqua	* mpega quality
	dr	rmpegadiv	* mpeda freq division
	dr	rmedmode	* med mode
	dr	rmedrate	* med rate



rval0	moveq	#0,d0
	bra.w	prefsgads2
rval1	moveq	#1,d0
	bra.w	prefsgads2
rval2	moveq	#2,d0
	bra.w	prefsgads2
rval3	moveq	#3,d0
	bra.w	prefsgads2
rval4	moveq	#4,d0
	bra.w	prefsgads2
rval5	moveq	#5,d0
	bra.w	prefsgads2
rval6	moveq	#6,d0
	bra.w	prefsgads2


*** Scope

rquad	
	tst	quad_prosessi(a5)	* jos ei ollu, p��lle
	beq.b	.s
	bsr.w	sulje_quad		* suljetaan jos oli auki
;	bra.b	psup0
	rts

.s	bsr.w	start_quad

psup0
	tst	quad_prosessi(a5)
	sne	d0
	lea	pout2,a0
	bra.w	tickaa


rquadm_req
	lea	ls00(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	quadmode_new(a5),d1
	and.b	#$80,d1
	or.b	d1,d0
	move.b	d0,quadmode_new(a5)
	move.b	d0,quadmode(a5)
	bsr.b	psup3
	bra.w	quadu

.x	rts

rquadm
	move.b	quadmode_new(a5),d0
	move.b	d0,d1
	and.b	#$f,d0
	and.b	#$80,d1

	addq.b	#1,d0
	cmp.b	#4,d0
	ble.b	.k
	clr.b	d0
.k	or.b	d1,d0
	move.b	d0,quadmode_new(a5)
	move.b	d0,quadmode(a5)			* vaikutus suoraan

psup3	
	lea	ls01(pc),a0
	moveq	#$f,d0
	and.b	quadmode_new(a5),d0
	beq.b	.q
	lea	ls02(pc),a0
	subq.b	#1,d0
	beq.b	.q
	lea	ls03(pc),a0
	subq.b	#1,d0
	beq.b	.q
	lea	ls04(pc),a0
	subq.b	#1,d0
	beq.b	.q
	lea	ls05(pc),a0
.q
	lea	pout3,a1
	bsr.w	prunt
	bra.b	quadu


ls00	dc.b	14,5
ls01	dc.b	"Quadrascope",0
ls02	dc.b	"Hipposcope",0
ls03	dc.b	"Freq. analyzer",0
ls04	dc.b	"Patternscope",0
ls05	dc.b	"F. Quadrascope",0
 even

rscopebar
	eor.b	#$80,quadmode_new(a5)
	move.b	quadmode_new(a5),quadmode(a5)

pscopebar
	tst.b	quadmode_new(a5)
	smi	d0
	lea	pout3b,a0
	bsr.w	tickaa

quadu	tst	quad_prosessi(a5)
	beq.b	.noq
	move.b	quadmode_new(a5),quadmode(a5)
	move.b	quadmode(a5),d0
	cmp.b	scopechanged(a5),d0
	beq.b	.noq
	move.b	d0,scopechanged(a5)
	bsr.w	sulje_quad
	bsr.w	start_quad
.noq	rts


** Mixingrate S3M
rpslider1
psup1
	lea	pslider1,a2
	move	#580-050,d0		* max
	bsr.w	nappilasku
	add	#50,d0
	mulu	#100,d0
	move.l	d0,mixingrate_new(a5)

	divu	#1000,d0
	swap	d0
	moveq	#0,d1
	move	d0,d1
	clr	d0
	swap	d0

	lea	info2_t(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
;	movem	pslider1+4,d0/d1
	movem	4(a2),d0/d1
	sub	#65,d0
	addq	#8,d1
	bra.w	print3b

info2_t dc.b	"%2.2ld.%1.1ldkHz",0
 even

***** PS3M buffer

rps3mb_req
	lea	.b(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	d0,ps3mb_new(a5)
	bra.b	pps3mb

.x	rts

.b	dc.b	4,4
	dc.b	"4kB",0
	dc.b	"8kB",0
	dc.b	"16kB",0
	dc.b	"32kB",0


rps3mb
	addq.b	#1,ps3mb_new(a5)
	cmp.b	#3,ps3mb_new(a5)
	bls.b	.ok
	clr.b	ps3mb_new(a5)
.ok

pps3mb
	move.b	ps3mb_new(a5),d1
	moveq	#4,d0
	lsl	d1,d0
	lea	.f(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
	lea	jommo,a1
	bra.w	prunt

.f	dc.b	"%ldkB",0
 even


** Mixingrate TFMX
rpslider2
psup2
	lea	pslider2,a2
	moveq	#22-1,d0		* max
	bsr.w	nappilasku
	addq	#1,d0
	move	d0,tfmxmixingrate_new(a5)
	
	lea	.info3_t(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
;	movem	pslider2+4,d0/d1
	movem	4(a2),d0/d1
	sub	#48,d0
	addq	#8,d1
	bra.w	print3b

.info3_t dc.b	"%2.2ldkHz",0
 even



** Samplebuffersize
rpslider2b
psup2b
	lea	sIPULI,a2
	moveq	#5,d0		* max
	bsr.w	nappilasku
	move.b	d0,samplebufsiz_new(a5)

	move	d0,d1
	moveq	#1,d0
	addq	#2,d1
	lsl	d1,d0

	lea	.t(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
;	movem	sIPULI+4,d0/d1
	movem	4(a2),d0/d1
	sub	#44,d0
	addq	#8,d1

	bra.w	print3b

.t 	dc.b	"%3.3ldkB",0
 even

********** force sample rate

rpslider2c
psup2c
	lea	sIPULI2,a2
	move	#600-9,d0		* max
	bsr.w	nappilasku
	move	d0,sampleforcerate_new(a5)
	bne.b	.m

	lea	.of(pc),a0
	bra.b	.p
.m
	add	#9,d0
	divu	#10,d0
	move.l	d0,d1
	clr	d1
	swap	d1
	ext.l	d0
	
	lea	.t(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
.p	
;	movem	sIPULI2+4,d0/d1
	movem	4(a2),d0/d1
	add	#149,d0
	subq	#6,d1

	bra.w	print3b

.of	dc.b	".....off",0
.t	dc.b	" %2.2ld.%1.1ldkHz",0
	even 



** Archivers: tempdir, lha jne..

rpattern
	move.l	DuU0+gg_SpecialInfo,a0
	lea	pattern_new(a5),a1
	bra.b	acopy

rarch2	move.l	ack2+gg_SpecialInfo,a0
	lea	arclha_new(a5),a1
	bra.b	acopy
rarch3	move.l	ack3+gg_SpecialInfo,a0
	lea	arczip_new(a5),a1
	bra.b	acopy
rarch4	move.l	ack4+gg_SpecialInfo,a0
	lea	arclzx_new(a5),a1

acopy	move.l	si_Buffer(a0),a0	* Teksipuskuri
.c	move.b	(a0)+,(a1)+
	bne.b	.c

;	jsr	flash

	rts

** Save
rpbutton14
	move.b	#2,prefs_exit(a5)
	rts
** Exit
rpbutton6
	move.b	#1,prefs_exit(a5)
	rts
** Cancel
rpbutton7
	st	prefs_exit(a5)
	rts




** Show; Mit� n�ytet��n otsikkopalkissa

rpbutton1_req
	lea	ls1(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move	d0,lootamoodi_new(a5)
	bra.b	pupdate1

.x	rts

rpbutton1
	addq	#1,lootamoodi_new(a5)	* vaihetaan moodia
	cmp	#3,lootamoodi_new(a5)
	ble.b	.ook
	clr	lootamoodi_new(a5)
.ook
	
pupdate1
	lea	ls2(pc),a0
	move	lootamoodi_new(a5),d0
	beq.b	.n
	lea	ls3(pc),a0
	subq	#1,d0
	beq.b	.n
	lea	ls4(pc),a0
	subq	#1,d0
	beq.b	.n
	lea	ls44(pc),a0
.n	

	lea	pbutton2,a1
	bra.w	prunt

ls1	dc.b	22,4	* leveys/korkeus merkkein�
ls2 	dc.b	"Time, pos/len, song",0
ls3 	dc.b	"Clock, free memory",0
ls4	dc.b	"Module name",0
ls44 	dc.b	"Time/duration, pos/len",0
 even




** Play; Soittotapa

rpbutton2_req
	lea	ls50(pc),a0
	bsr.w	listselector
	bmi.b	.x
	addq.b	#1,d0
	move.b	d0,playmode_new(a5)
	bra.b	pupdate2

.x	rts

rpbutton2
	addq.b	#1,playmode_new(a5)
	cmp.b	#pm_max,playmode_new(a5)
	ble.b	pupdate2
	move.b	#1,playmode_new(a5)
	
pupdate2
	move.b	playmode_new(a5),d0
	lea	ls5(pc),a0
	subq.b	#1,d0
	beq.b	.ee
	lea	ls6(pc),a0
	subq.b	#1,d0
	beq.b	.ee
	lea	ls7(pc),a0
	subq.b	#1,d0
	beq.b	.ee
	lea	ls8(pc),a0
	subq.b	#1,d0
	beq.b	.ee
	lea	ls9(pc),a0
.ee	
	lea	pbutton1,a1
	bra.w	prunt 

ls50	dc.b	23,5
ls5 dc.b	"List repeatedly",0
ls6 dc.b	"List once",0
ls7 dc.b	"Module repeatedly",0
ls8 dc.b	"Module once",0
ls9 dc.b	"Modules in random order",0
 even


** Tempomoodi
rpbutton3
	not.b	tempoflag_new(a5)

pupdate3
	tst.b	tempoflag_new(a5)
	seq	d0
	lea	pbutton3,a0
	bra.w	tickaa


** S3M moodit 1,2,3

rsmode1_req
	lea	ls51(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	d0,s3mmode1_new(a5)
	bra.b	pupdate5

.x	rts

rsmode1
	addq.b	#1,s3mmode1_new(a5)
	cmp.b	#5,s3mmode1_new(a5)
	bls.b	pupdate5
	clr.b	s3mmode1_new(a5)

pupdate5
	lea	ls52(pc),a0
	move.b	s3mmode1_new(a5),d0
	beq.b	.e
	lea	ls53(pc),a0
	subq.b	#1,d0
	beq.b	.e
	lea	ls531(pc),a0
	subq.b	#1,d0
	beq.b	.e
	lea	ls532(pc),a0
	subq.b	#1,d0
	beq.b	.e
	lea	ls533(pc),a0
	subq.b	#1,d0
	beq.b	.e
	lea	ls54(pc),a0
.e	
	lea	smode2,a1
	bra.w	prunt

* -10, -3, 0, +3, +10

ls51	dc.b	7,6
ls52	dc.b	"-10",0
ls53	dc.b	"-1",0
ls531	dc.b	"0",0
ls532	dc.b	"+1",0
ls533	dc.b	"+9",0
ls54	dc.b	"Killer",0		* 5
 even


rsmode2_req
	lea	ls10(pc),a0
	bsr.w	listselector
	bmi.b	.x
	addq.b	#1,d0
	move.b	d0,s3mmode2_new(a5)
	bra.b	pupdate6

.x	rts


rsmode2
	addq.b	#1,s3mmode2_new(a5)
	cmp.b	#5,s3mmode2_new(a5)
	ble.b	pupdate6
	move.b	#1,s3mmode2_new(a5)

pupdate6
	lea	ls11(pc),a0
	move.b	s3mmode2_new(a5),d0
	subq.b	#1,d0
	beq.b	.e
	lea	ls12(pc),a0
	subq.b	#1,d0
	beq.b	.e
	lea	ls13(pc),a0
	subq.b	#1,d0
	beq.b	.e
	lea	ls14(pc),a0
	subq.b	#1,d0
	beq.b	.e
	lea	ls15(pc),a0

.e	
	lea	smode1,a1
	bra.w	prunt


ls10	dc.b	13,5
ls11	dc.b	"Surround",0
ls12	dc.b	"Stereo",0
ls13	dc.b	"Mono",0
ls14	dc.b	"Real surround",0
ls15	dc.b	"14-bit stereo",0
 even

** Volboost

rsmode3
pupdate7
	lea	juusto,a2
	moveq	#8,d0			* max
	bsr.w	nappilasku
	move.b	d0,s3mmode3_new(a5)

	bsr.w	updateps3m

	moveq	#0,d0
	move.b	s3mmode3_new(a5),d0
	or.b	#"0",d0

	lea	.sm3_t(pc),a0
	move.b	d0,(a0)
;	movem	juusto+4,d0/d1
	movem	4(a2),d0/d1
	sub	#16,d0
	addq	#8,d1

	bra.w	print3b
.sm3_t	dc.b	" ",0	* 0,1-8


*** Stereo

rsmode4
pupdate7b
	lea	juust0,a2
	moveq	#64,d0			* max
	bsr.w	nappilasku
	move.b	d0,stereofactor_new(a5)

	bsr.b	updateps3m2

	mulu	#100,d0
	lsr.l	#6,d0		* x/64
	lea	.i(pC),a0
	bsr.w	desmsg2


;	movem	juust0+4,d0/d1
	movem	4(a2),d0/d1
	sub	#41+1,d0
	addq	#8,d1
	movem	d0/d1,-(sp)

	lea	.ii(pc),a0
	bsr.w	print3b

	lea	desbuf2(a5),a0
	movem	(sp)+,d0/d1


	bra.w	print3b
.i	dc.b	"%3.3ld%%",0
.ii	dc.b	"  ",0
 even

updateps3m2
	tst.b	ahi_use_nyt(a5)
	bne.b	.nd

	lea	var_b,a5
	tst	playingmodule(a5)
	bmi.b	.nd
	tst.b	playing(a5)
	beq.b	.nd
	cmp	#pt_multi,playertype(a5)
	bne.b	.nd
	cmp.b	#1,s3mmode2(a5)		* onko surround?
	bne.b	.nd
	moveq	#64,d1
	sub.b	stereofactor_new(a5),d1
	move	d1,$dff0c8
	move	d1,$dff0d8
.nd	rts

updateps3m
	tst.b	ahi_use_nyt(a5)
	bne.b	.nd

	tst	playingmodule(a5)
	bmi.b	.nd
	tst.b	playing(a5)
	beq.b	.nd
	cmp	#pt_multi,playertype(a5)
	bne.b	.nd
	pushm	all
	move.b	s3mmode3_new(a5),d0
	jsr	ps3m_boost
	popm	all
.nd
	rts


**** ps3m settings
rsettings
	not.b	ps3msettings_new(a5)
psettings
;	tst.b	ps3msettings_new(a5)
;	sne	d0
	move.b	ps3msettings_new(a5),d0
	lea	Fruit,a0
	bra.w	tickaa




***** cyber calibration nappu
rcyber
	not.b	cybercalibration_new(a5)
pcyber
;	tst.b	cybercalibration_new(a5)
;	sne	d0
	move.b	cybercalibration_new(a5),d0
	lea	bENDER1,a0
	bra.w	tickaa



***** cyber calibration file name
rcybername
	lea	calibrationfile_new(a5),a0
	move.l	a0,a1			* mihin hakemistoon menn��n
	lea	.t(pc),a2
	bsr.w	pgetfile
	st	newcalibrationfile(a5)
	bra.b	pcybername

.t	dc.b	"Select calibration file",0
 even

pcybername
	lea	calibrationfile_new(a5),a0
	move.l	a0,a2
.f	tst.b	(a2)+
	bne.b	.f
	move.l	sp,a1
	lea	-30(sp),sp
	moveq	#20-1,d0
.c	move.b	-(a2),-(a1)
	cmp.l	a0,a2
	beq.b	.cx
	dbf	d0,.c
.cx	
	move.l	a1,a0
	lea	bENDER2,a1
	bsr.w	prunt2	
	lea	30(sp),sp
	rts






** Filtteri
rpfilt_req
	lea	ls16(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	d0,filterstatus(a5)
	bra.b	pupf

.x	rts

rpfilt
	addq.b	#1,filterstatus(a5)
	cmp.b	#2,filterstatus(a5)
	ble.b	pupf
	clr.b	filterstatus(a5)

pupf
	lea	ls17(pc),a0
	move.b	filterstatus(a5),d0
	bne.b	.prp

	bset	#1,$bfe001
	tst.b	modulefilterstate(a5)
	bne.b	.pr
	bclr	#1,$bfe001
	bra.b	.pr
.prp
	lea	ls18(pc),a0
	subq.b	#1,d0
	beq.b	.pr
	lea	ls19(pc),a0
.pr	
	lea	pout1,a1
	bra.w	prunt

ls16	dc.b	6,3
ls17	dc.b	"Module",0
ls18	dc.b	"Off",0
ls19	dc.b	"On",0
 even	

rptmix_req
	lea	ls20(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	d0,ptmix_new(a5)
	bra.b	pipm

.x	rts

rptmix
	addq.b	#1,ptmix_new(a5)
	cmp.b	#2,ptmix_new(a5)
	bls.b	pipm
	clr.b	ptmix_new(a5)
pipm
	lea	ls21(pc),a0
	move.b	ptmix_new(a5),d0
	beq.b	.n
	lea	ls22(pc),a0
	subq.b	#1,d0
	beq.b	.n
	lea	ls23(pc),a0
.n	
	lea	laren1,a1
	bra.w	prunt

ls20	dc.b	7,3
ls21	dc.b	"Normal",0
ls22	dc.b	"Fastram",0
ls23	dc.b	"PS3M",0
 even 

** XPKID
rxp	not.b	xpkid_new(a5)

pux	
	tst.b	xpkid_new(a5)
	seq	d0
	lea	makkara,a0
	bra.w	tickaa

	
**** XFDmaster
rxfd	not.b	xfd_new(a5)
pxfd	;tst.b	xfd_new(a5)
	;sne	d0
	move.b	xfd_new(a5),d0
	lea	nappU2,a0
	bra.w	tickaa


*** volumefade
rdbf	not.b	fade_new(a5)

pdbf	;tst.b	fade_new(a5)
	;sne	d0
	move.b	fade_new(a5),d0
	lea	kinkku,a0
	bra.w	tickaa


**** Prioriteetti
rpri_req
	lea	ls200(pc),a0
	bsr.w	listselector
	bmi.b	.x
	subq.b	#1,d0
	move.b	d0,pri_new(a5)
	bra.b	ppri

.x	rts

rpri
	move.b	pri_new(a5),d0
	addq.b	#2,d0
	cmp.b	#2,d0
	bls.b	.r
	moveq	#0,d0
.r	subq.b	#1,d0
	move.b	d0,pri_new(a5)

ppri
	lea	ls201(pc),a0
	move.b	pri_new(a5),d0
	bmi.b	.0	
	lea	ls202(pc),a0
	beq.b	.0
	lea	ls203(pc),a0

.0	lea	tomaatti,a1
	bra.w	prunt

ls200	dc.b	2,3
ls201	dc.b	"-1",0
ls202	dc.b	"0",0
ls203	dc.b	"+1",0
 even

** Valitaan hakemisto moddir
rpbutton10
	bsr.w	dir_req
	bne.b	.ee
	rts
.ee	
	move.l	d7,a0
	lea	moduledir_new(a5),a1
	bsr.w	parsereqdir2		* Tehd��n hakemistopolku..
	st	newdirectory(a5)

psele	move.l	d7,a1
	lob	rtFreeRequest

* 19 max

pdup
	lea	moduledir_new(a5),a0
	lea	DuU1,a1
	bsr.b	.o
	lea	prgdir_new(a5),a0
	lea	DuU2,a1
	bsr.b	.o
	lea	arcdir_new(a5),a0		* DISABLED!
	lea	DuU3,a1
	bsr.b	.o
	rts

.o	lea	-32(sp),sp
	lea	30(sp),a2
	clr.b	(a2)

	move.l	a0,a3
.u	tst.b	(a0)+
	bne.b	.u

	cmp.b	#'/',-2(a0)
	bne.b	.cy
	subq	#2,a0
.cy


	moveq	#19-1,d0
.c	cmp.l	a3,a0
	beq.b	.cc
	move.b	-(a0),-(a2)
	dbf	d0,.c
.cc	
	move.l	a2,a0
	bsr.w	prunt2
	lea	32(sp),sp
	rts


** Valitaan hakemisto prgdir
rselprgdir
	bsr.b	dir_req
	bne.b	.ee
	rts
.ee	
	move.l	d7,a0
	lea	prgdir_new(a5),a1
	bsr.w	parsereqdir2		* Tehd��n hakemistopolku..
	st	newdirectory2(a5)
	bra.b	psele

** Valitaan hakemisto prgdir
rselarcdir
	bsr.b	dir_req
	bne.b	.ee
	rts
.ee	
	move.l	d7,a0
	lea	arcdir_new(a5),a1
	bsr.w	parsereqdir2		* Tehd��n hakemistopolku..
	bra.w	psele



** Hakemisto requesteri
dir_req	bsr.w	get_rt
	moveq	#RT_FILEREQ,D0
	sub.l	a0,a0
	lob	rtAllocRequestA
	move.l	d0,d7
	beq.b	.eek
	bsr.w	pon2		* waitpointer

	lea	.dirtags(pc),a0
	move.l	d7,a1
	lea	desbuf2(a5),a2		* Kunhan jonnekkin laitetaan..
	lea	.dirreqtitle(pc),a3
	lob	rtFileRequestA		* ReqToolsin tiedostovalikko
	bsr.w	poff2
	tst.l	d0
.eek	rts

.dirreqtitle dc.b "Select directory",0
 even


.dirtags
	dc.l	RTFI_Flags,FREQF_NOFILES
;	dc.l	RT_TextAttr,text_attr
otag4	dc.l	RT_PubScrName,pubscreen+var_b
	dc.l	TAG_END





*** Box size

rbox
pbox
	lea	meloni,a2
	moveq	#51-3,d0		* max
	bsr.w	nappilasku
	beq.b	.fe
	addq	#2,d0

.fe	move	d0,boxsize_new(a5)

	lea	.i(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0

;	movem	meloni+4,d0/d1
	movem	4(a2),d0/d1
	sub	#26,d0
	addq	#8,d1

	bra.w	print3b

.i dc.b	"%-2.2ld",0
 even

rinfosize
pinfosize
	lea	eskimO,a2
	moveq	#50-3,d0		* max
	bsr.w	nappilasku
	addq.l	#3,d0
	move	d0,infosize_new(a5)

	lea	.i(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0

;	movem	eskimO+4,d0/d1
	movem	4(a2),d0/d1
	sub	#26,d0
	addq	#8,d1

	bra.w	print3b

.i dc.b	"%-2.2ld",0
 even


********* Doubleclick
rdclick
	not.b	dclick_new(a5)
pdclick
	;tst.b	dclick_new(a5)
	;sne	d0
	move.b	dclick_new(a5),d0
	lea	eins2,a0
	bra.w	tickaa

********* Autosort
rautosort
	not.b	autosort_new(a5)
pautosort
	;tst.b	autosort_new(a5)
	;sne	d0
	move.b	autosort_new(a5),d0
	lea	bUu22,a0
	bra.w	tickaa



********* Startup on/off
rstartuponoff
	not.b	startuponoff_new(a5)
pstartuponoff
	;tst.b	startuponoff_new(a5)
	;sne	d0
	move.b	startuponoff_new(a5),d0
	lea	salaatti3,a0
	bra.w	tickaa


********* Startup
* a0 = paikka nimelle (jossa vanha nimi)

rstartup
	lea	startup_new(a5),a0
	move.l	a0,a1			* mihin hakemistoon menn��n
	sub.l	a2,a2

pgetfile
	move.l	a2,d4		 * title
	bsr.w	get_rt
	move.l	a0,d6
	move.l	a1,d5
	moveq	#RT_FILEREQ,D0
	sub.l	a0,a0
	lob	rtAllocRequestA
	move.l	d0,req_file3(a5)
	bne.b	.joo
	rts
.joo
	move.l	d5,a0
.f0	tst.b	(a0)+
	bne.b	.f0
	move.l	d5,a1
	bsr.w	nimenalku

	move.l	a0,a2
	lea	desbuf2(a5),a3		* nimi
.c	move.b	(a0)+,(a3)+
	bne.b	.c

	move.b	(a2),d7
	clr.b	(a2)

	move.l	req_file3(a5),a1		* Vaihdetaan hakemistoa...
	lea	newdir_tags(pc),a0
	move.l	d5,4(a0)
	lore	Req,rtChangeReqAttrA

	move.l	req_file3(a5),a1		* Match pattern
	lea	matchp_tags(pc),a0
	lob	rtChangeReqAttrA
	move.b	d7,(a2)


	lea	.tags(pc),a0
	move.l	req_file3(a5),a1
	lea	desbuf2(a5),a2
	lea	.title(pc),a3
	tst.l	d4
	beq.b	.noti
	move.l	d4,a3
.noti

	bsr.w	pon2		* waitpointer

	lore	Req,rtFileRequestA	* ReqToolsin tiedostovalikko
	bsr.w	poff2
	tst.l	d0
	beq.b	.eek


	move.l	req_file3(a5),a0
	move.l	d6,a1
	bsr.w	parsereqdir2

	addq	#1,a1
	lea	desbuf2(a5),a0
.e	move.b	(a0)+,(a1)+
	bne.b	.e

.eek	
	move.l	req_file3(a5),d0
	beq.b	.eek2
	move.l	d0,a1
	lore	Req,rtFreeRequest
.eek2
	rts


.title dc.b "Select module or program",0
 even

.tags
	dc.l	RTFI_Flags,FREQF_PATGAD
otag14	dc.l	RT_PubScrName,pubscreen+var_b,TAG_END

********* Alarm
ralarm
	rts

purealarm
	lea	kelloke2,a2
	move.l	gg_SpecialInfo(a2),a0
	move	pi_HorizPot(a0),d0
	move	#1440,d0		* max
	bsr.w	nappilasku

	divu	#60,d0
	moveq	#0,d1
	move.b	d0,d1
	lsl	#8,d1
	swap	d0
	move.b	d0,d1

	move	d1,alarm_new(a5)
	ext.l	d1
	beq.b	.nl

	moveq	#0,d0
	move	d1,d0
	lsr	#8,d0
	and	#$ff,d1

	lea	.t(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
.r
;	movem	kelloke2+4,d0/d1
	movem	4(a2),d0/d1
	sub	#68,d0
	addq	#8,d1


	bra.b	print3b

.nl
	lea	.nil(pc),a0
	bra.b	.r

.nil	dc.b	".....Off",0
.t	dc.b	"...%02ld:%02ld",0
 even


print3b	pushm	all			* Sit�varten ett� windowtop/left
	move.l	rastport2(a5),a4	* arvoja ei lis�tt�isi kun
	bra.w	uup			* teksti on jo suhteessa gadgettiin


******* FKeys
rfkeys
	lea	-60(sp),sp
	move.l	sp,a4

	lea	fkeys_new(a5),a0
	moveq	#10-1,d0
.lop	move.l	a0,(a4)+
	lea	120(a0),a0
	dbf	d0,.lop
	clr.l	(a4)

	lea	.form(pc),a1
	lea	(sp),a4
	lea	.gad(pc),a2
	lea	.tags(pc),a0
	sub.l	a3,a3
	bsr.w	get_rt
	bsr.w	pon2
	lob	rtEZRequestA
	bsr.w	poff2
	tst.l	d0
	bne.b	.e
	moveq	#11,d0
.e	subq	#1,d0
	lea	60(sp),sp
	tst.b	d0
	beq.b	.x
	subq	#1,d0		* 0-9

	lea	fkeys_new(a5),a0
	mulu	#120,d0
	add.l	d0,a0
	move.l	a0,a1		* jos ei ole ennest��n tiedostoa,
	tst.b	(a1)		* otetaan hakemistoksi oletusmusahakemisto
	bne.b	.jep
	lea	moduledir(a5),a1	
.jep
	sub.l	a2,a2
	bsr.w	pgetfile
	bra.b	rfkeys

.x	rts


.gad	dc.b	"_OK|F_1|F_2|F_3|F_4|F_5|F_6|F_7|F_8|F_9|F1_0",0
.title	dc.b	"Function keys",0

.form
	dc.b	"F1:  %-60.60s",10
	dc.b	"F2:  %-60.60s",10
	dc.b	"F3:  %-60.60s",10
	dc.b	"F4:  %-60.60s",10
	dc.b	"F5:  %-60.60s",10
	dc.b	"F6:  %-60.60s",10
	dc.b	"F7:  %-60.60s",10
	dc.b	"F8:  %-60.60s",10
	dc.b	"F9:  %-60.60s",10
	dc.b	"F10: %-60.60s",0

 even

.tags	dc.l	RTEZ_ReqTitle,.title
	dc.l	RT_Underscore,"_"
	dc.l	RT_TextAttr,text_attr
otag5	dc.l	RT_PubScrName,pubscreen+var_b
	dc.l	TAG_END

*********** Timeout

rtimeoutslider
psup4
	lea	kelloke,a2
	move	#1800,d0		* max
	bsr.w	nappilasku
	move	d0,timeout_new(a5)
	beq.b	.nl

	divu	#60,d0
	move.l	d0,d1
	swap	d1
	ext.l	d1
	ext.l	d0

	lea	.t(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
.r	
;	movem	kelloke+4,d0/d1
	movem	4(a2),d0/d1
	sub	#52,d0
	addq	#8,d1


	bra.w	print3b

.nl
	lea	.nil(pc),a0
	bra.b	.r

.nil	dc.b	"...Off",0
.t	dc.b	" %02ld:%02ld",0
 even


******* timeoutmode
rtimeoutmode
	lea	.gad(pc),a2
	lea	.form(pc),a1
	pea	.1(pc)
	tst.b	timeoutmode_new(a5)
	beq.b	.o
	addq	#4,sp
	pea	.2(pc)
.o	lea	(sp),a4
	bsr.b	pselector2
	seq	timeoutmode_new(a5)
	addq	#4,sp
	rts
.form	dc.b	"Timeout affects %s modules.",0
.gad	dc.b	"_All modules|_Never ending modules",0
.1	dc.b	"all",0
.2	dc.b	"never-ending",0
 even





* Reqtools-valikko
pselector
	sub.l	a4,a4
pselector2
	bsr.w	get_rt
	lea	.tags(pc),a0
	sub.l	a3,a3
	bsr.w	pon2
	lob	rtEZRequestA
	bsr.w	poff2
	tst.l	d0
	rts


.tags	
	dc.l	RTEZ_ReqTitle,reqtitle
	dc.l	RT_Underscore,"_"
	dc.l	RT_TextAttr,text_attr
otag3	dc.l	RT_PubScrName,pubscreen+var_b
	dc.l	TAG_END

pgad5	dc.b	"_1|_2|_3|_4|_5",0
 even


******* Hotkey
rhotkey
	not.b	hotkey_new(a5)
phot
	;tst.b	hotkey_new(a5)
	;sne	d0
	move.b	hotkey_new(a5),d0
	lea	kaktus,a0
	bra.w	tickaa

**** Cont on error
rerr
	not.b	cerr_new(a5)
perr
	;tst.b	cerr_new(a5)
	;sne	d0
	move.b	cerr_new(a5),d0
	lea	luuta,a0
	bra.w	tickaa




**** Select screen

rselscreen
	tst.b	uusikick(a5)
	bne.b	.n
	rts

.n	st	newpubscreen2(a5)
	
	bsr.b	freepubwork

.l	move.l	pubwork(a5),a0
	lea	pubscreen_new(a5),a1
	lore	Intui,NextPubScreen
	tst.l	d0
	bne.b	.fe
	clr.l	pubwork(a5)
	bra.b	.l
.fe
	bsr.b	pselscreen

	lea	pubscreen_new(a5),a0
	lob	LockPubScreen
	move.l	d0,pubwork(a5)
	beq.b	.l
	rts

freepubwork
	move.l	pubwork(a5),d0
	beq.b	.eb
	move.l	d0,a1
	sub.l	a0,a0
	lore	Intui,UnlockPubScreen
.eb	rts
	
pselscreen
	tst.b	uusikick(a5)
	bne.b	.new
	lea	pubscreen_new(a5),a0
	bra.b	.rpo

.new

	lea	pubscreen_new(a5),a2
	lea	desbuf2(a5),a1
	move.l	a1,a0
	moveq	#18-1,d0
.c	move.b	(a2)+,(a1)+
	dbeq	d0,.c
	clr.b	(a1)

.rpo	lea	pbutton13,a1
	bra.w	prunt2
	


**** doublebuffering
rdbuf
	not.b	dbf_new(a5)
pdbuf
	;tst.b	dbf_new(a5)
	;sne	d0
	move.b	dbf_new(a5),d0
	lea	nappu1,a0
	bra.w	tickaa

**** nasty audio
rnasty
	not.b	nasty_new(a5)
pnasty
	;tst.b	nasty_new(a5)
	;sne	d0
	move.b	nasty_new(a5),d0
	lea	nappu2,a0
	bra.w	tickaa


rvbtimer
	not.b	vbtimer_new(a5)
pvbt
	;tst.b	vbtimer_new(a5)
	;sne	d0
	move.b	vbtimer_new(a5),d0
	lea	nApPu,a0	
	bra.w	tickaa


****** FontSelector

pfont
	lea	-20(sp),sp
	move.l	sp,a1
	lea	prefs_fontname+prefsdata(a5),a0
	moveq	#14-1,d0
.c	cmp.b	#'.',(a0)
	beq.b	.cc
	move.b	(a0)+,(a1)+
	dbeq	d0,.c
.cc	clr.b	(a1)
	move.l	sp,a0
	lea	gfonttou,a1
	bsr.w	prunt2
	lea	20(sp),sp
	rts

rfont
	tst.b	uusikick(a5)		* vain kick2.0+
	bne.b	.enw
.x	rts

.enw
	tst.l	_DiskFontBase(a5)
	beq.b	.x

	moveq	#RT_FONTREQ,d0
	lore	Req,rtAllocRequestA
	move.l	d0,d7

	lea	.tit(pc),a3
	lea	fontreqtags(pc),a0
	move.l	d7,a1
	bsr.w	pon2
	lob	rtFontRequestA
	bsr.w	poff2
	tst.l	d0
	beq.b	.ew

	move.l	d7,a0
	lea	rtfo_Attr(a0),a0	* fontin textattr
	cmp	#8,ta_YSize(a0)
	bne.b	.ew
	btst	#FPB_PROPORTIONAL,ta_Flags(a1)	* Onko proportional?
	bne.b	.ew

	lore	DiskFont,OpenDiskFont	* onko leveys 8 pix?
	tst.l	d0
	beq.b	.ew
	move.l	d0,a3
	cmp	#8,tf_XSize(a3)
	sne	d3
	move.l	a3,a1
	lore	GFX,CloseFont
	move.l	a3,a1
	lob	RemFont		* puis muistista

	tst.b	d3
	bne.b	.ew
	
	move.l	d7,a0
	lea	rtfo_Attr(a0),a0
	move.l	4(a0),prefs_textattr+prefsdata(a5) * YSize, Style, Flags talteen
	move.l	(a0),a0				* Fontin nimi
	lea	prefs_fontname+prefsdata(a5),a1
.cec	move.b	(a0)+,(a1)+
	bne.b	.cec
	clr	boxsize00(a5)		* avataan ja suljetaan p��ikkuna


.ew
	move.l	d7,a1
	lore	Req,rtFreeRequest
	bra.w	pfont


.tit	dc.b	"Select font",0
 even

fontreqtags
	dc.l	RTFO_Flags,FREQF_NOBUFFER!FREQF_FIXEDWIDTH
	dc.l	RTFO_SampleHeight,12
	dc.l	RTFO_MaxHeight,8
	dc.l	RTFO_MinHeight,8
	dc.l	RTFO_FilterFunc,.fontfilter
	dc.l	RT_TextAttr,text_attr
	dc.l	RT_PubScrName,pubscreen+var_b
	dc.l	TAG_END

.fontfilter
	ds.b	MLN_SIZE
	dc.l	.hookroutine	* h_Entry
	dc.l	0		* h_SubEntry
	dc.l	0		* h_Data

.hookroutine
* a1 = textattr
	pushm	d1-a6		
	lea	var_b,a5
	moveq	#FALSE,d7
	cmp	#8,ta_YSize(a1)		* 8 pixeli� korkee?
	bne.b	.x
	btst	#FPB_PROPORTIONAL,ta_Flags(a1)	* Onko proportional?
	bne.b	.x	

	move.l	a1,a0			* tutkitaan onko leveys 8 pixeli�
	lore	DiskFont,OpenDiskFont
	tst.l	d0
	beq.b	.x
	move.l	d0,a3
	cmp	#8,tf_XSize(a3)
	bne.b	.no
	moveq	#TRUE,d7
.no	move.l	a3,a1
	lore	GFX,CloseFont
	move.l	a3,a1
	lob	RemFont		* puis muistista
.x	move.l	d7,d0
	popm	d1-a6
	rts



*** Printataan screen refresh ratetkin

pscreen
	tst.b	gfxcard(a5)
	beq.b	.nop
	lea	.dea(pc),a0
	bra.b	.do

.nop
	moveq	#0,d0
	move	vertfreq(a5),d0

	moveq	#0,d1
	move	horizfreq(a5),d1
	divu	#1000,d1
	ext.l	d1

	lea	.de(pc),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0

.do	moveq	#16+16,d0
	moveq	#122,d1
	bra.w	print3b


.de	dc.b	"Screen refresh rate:",10
	dc.b	"    %ldHz, %ldkHz",0
.dea	dc.b	"A gfx card detected.",0
 even


***** Playergroup file

rpgfile
	lea	groupname_new(a5),a0
	move.l	a0,a1			* mihin hakemistoon menn��n
	lea	.tit(pc),a2
	bsr.w	pgetfile
	bra.b	ppgfile

.tit	dc.b	"Select player group file",0
 even

ppgfile
	lea	groupname_new(a5),a0
	move.l	a0,a2
.f	tst.b	(a2)+
	bne.b	.f
	move.l	sp,a1
	lea	-30(sp),sp
	moveq	#23-1,d0
.c	move.b	-(a2),-(a1)
	cmp.l	a0,a2
	beq.b	.cx
	dbf	d0,.c
.cx	
	move.l	a1,a0
	lea	RoU1,a1
	bsr.w	prunt2	
	lea	30(sp),sp
	rts


******** Playergroup mode

rpgmode_req
	lea	ls300(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	d0,groupmode_new(a5)
	bra.b	ppgmode
.x	rts


rpgmode
	move.b	groupmode_new(a5),d0
	addq.b	#1,d0
	cmp.b	#3,d0
	bls.b	.r
	moveq	#0,d0
.r	move.b	d0,groupmode_new(a5)

ppgmode
	lea	ls301(pc),a0
	move.b	groupmode_new(a5),d0
	beq.b	.0
	lea	ls302(pc),a0
	subq.b	#1,d0
	beq.b	.0
	lea	ls303(pc),a0
	subq.b	#1,d0
	beq.b	.0
	lea	ls304(pc),a0
	
.0	lea	PoU2,a1
	bra.w	prunt

ls300	dc.b	14,4
ls301	dc.b	"All on startup",0
ls302	dc.b	"All on demand",0
ls303	dc.b	"Disable",0
ls304	dc.b	"Load single",0
 even


ppgstat
	lea	.2(pc),a0
	tst.l	externalplayers(a5)
	beq.b	.q
	lea	.1(pc),a0
.q

	movem	PoU2+4,d0/d1
	add	#40,d0
	subq	#6,d1
	bra.w	print3b

.2	dc.b	"not loaded",0
.1 	dc.b	"....loaded",0
 even

*********** Divider / dir

rdiv
	not.b	div_new(a5)
pdiv
	;tst.b	div_new(a5)
	;sne	d0
	move.b	div_new(a5),d0
	lea	bUu1,a0
	bra.w	tickaa


**** Prefix cut
rprefx_req
	lea	ls299(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	d0,prefix_new(a5)
	cmp.b	#7,d0
	blo.b	pprefx
	move.b	#6,prefix_new(a5)
	bra.b	pprefx
.x	rts

rprefx
	move.b	prefix_new(a5),d0
	addq.b	#1,d0
	cmp.b	#6,d0
	bls.b	.r
	moveq	#0,d0
.r	move.b	d0,prefix_new(a5)

pprefx
	moveq	#0,d0
	move.b	prefix_new(a5),d0
	add	d0,d0
	lea	ls299+2(pc,d0),a0
	lea	bUu2,a1
	bra.w	prunt

ls299	dc.b	1,7
	dc.b	"0",0
	dc.b	"1",0
	dc.b	"2",0
	dc.b	"3",0
	dc.b	"4",0
	dc.b	"5",0
	dc.b	"6",0
 even

**** Early load
rearly_req
	lea	ls400(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	d0,early_new(a5)
	cmp.b	#11,d0
	blo.b	pearly
	move.b	#10,early_new(a5)
	bra.b	pearly
.x	rts

rearly
	move.b	early_new(a5),d0
	addq.b	#1,d0
	cmp.b	#10,d0
	bls.b	.r
	clr.b	d0
.r	move.b	d0,early_new(a5)
pearly
	moveq	#0,d0
	move.b	early_new(a5),d0
	add	d0,d0
	lea	ls400+2(pc,d0),a0
	lea	bUu3,a1
	bra.w	prunt




ls400	dc.b	2,11
	dc.b	"0",0
	dc.b	"1",0
	dc.b	"2",0
	dc.b	"3",0
	dc.b	"4",0
	dc.b	"5",0
	dc.b	"6",0
	dc.b	"7",0
	dc.b	"8",0
	dc.b	"9",0
	dc.b	"10",0
 even







;samplecyber	rs.b	1
;mpegaqua	rs.b	1
;mpegadiv	rs.b	1
;medmode		rs.b	1
;medrate		rs	1

;samplecyber_new	rs.b	1
;mpegaqua_new	rs.b	1
;mpegadiv_new	rs.b	1
;medmode_new	rs.b	1
;medrate_new	rs	1



*** Sample cybercalibration

rsamplecyber
	not.b	samplecyber_new(a5)
psamplecyber
	move.b	samplecyber_new(a5),d0
	lea	nAMISKA1,a0
	bra.w	tickaa


** MPEGA quality

rmpegaqua_req
	lea	ls500(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	d0,mpegaqua_new(a5)
	bra.b	pmpegaqua
.x	rts
rmpegaqua
	addq.b	#1,mpegaqua_new(a5)
	cmp.b	#3,mpegaqua_new(a5)
	bne.b	pmpegaqua
	clr.b	mpegaqua_new(a5)
pmpegaqua
	moveq	#0,d0
	move.b	mpegaqua_new(a5),d0
	add	d0,d0
	lea	ls501(pc,d0),a0
	lea	nAMISKA2,a1
	bra.w	prunt
ls500	dc.b	2,3
ls501	dc.b	"0",0
ls502	dc.b	"1",0
ls503	dc.b	"2",0
 even




** MPEGA quality

rmpegadiv_req
	lea	ls600(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	d0,mpegadiv_new(a5)
	bra.b	pmpegadiv
.x	rts
rmpegadiv
	addq.b	#1,mpegadiv_new(a5)
	cmp.b	#3,mpegadiv_new(a5)
	bne.b	pmpegadiv
	clr.b	mpegadiv_new(a5)
pmpegadiv
	moveq	#0,d0
	move.b	mpegadiv_new(a5),d0
	add	d0,d0
	lea	ls601(pc,d0),a0
	lea	nAMISKA3,a1
	bra.w	prunt
ls600	dc.b	2,3
ls601	dc.b	"1",0
ls602	dc.b	"2",0
ls603	dc.b	"4",0
 even



** MED mode

rmedmode_req
	lea	ls700(pc),a0
	bsr.w	listselector
	bmi.b	.x
	move.b	d0,medmode_new(a5)
	bra.b	pmedmode
.x	rts
rmedmode
	addq.b	#1,medmode_new(a5)
	cmp.b	#2,medmode_new(a5)
	bne.b	pmedmode
	clr.b	medmode_new(a5)
pmedmode
	moveq	#0,d0
	move.b	medmode_new(a5),d0
	add	d0,d0
	lea	ls701(pc,d0),a0
	lea	nAMISKA4,a1
	bra.w	prunt
ls700	dc.b	2,2
ls701	dc.b	"8",0
ls702	dc.b	"14",0
 even




pupmedrate	
rmedrate
	lea	nAMISKA5,a2
	move	#580-050,d0		* max
	bsr.w	nappilasku
	add	#50,d0
	mulu	#100,d0
	move	d0,medrate_new(a5)

	divu	#1000,d0
	swap	d0
	moveq	#0,d1
	move	d0,d1
	clr	d0
	swap	d0

	lea	info2_t(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
	movem	4(a2),d0/d1
	add	#118,d0
	subq	#6,d1
	bra.w	print3b




***************************************
* AHI valinnat

*** use ahi
rahi1	not.b	ahi_use_new(a5)
pahi1	;tst.b	ahi_use_new(a5)
	;sne	d0
	move.b	ahi_use_new(a5),d0
	lea	ahiG2,a0
	bra.w	tickaa


*** ahi disable muut
rahi2	not.b	ahi_muutpois_new(a5)
pahi2	;tst.b	ahi_muutpois_new(a5)
	;sne	d0
	move.b	ahi_muutpois_new(a5),d0
	lea	ahiG3,a0
	bra.w	tickaa


*** ahi select mode
rahi3
	OPENAHI	1
	move.l	d0,d7
	beq.w	rahi3_e
	move.l	d0,a6

	lea	audioreqtags(pc),a0
	jsr	_LVOAHI_AllocAudioRequestA(a6)
	move.l	d0,d6
	beq.b	.gr

	move.l	d6,a0
	lea	audioreqtags2(pc),a1
	move.l	windowbase2(a5),4(a1)	* parent window

	jsr	_LVOAHI_AudioRequestA(a6)
	tst.l	d0
	beq.b	.gr
	move.l	d6,a0
	move.l	ahiam_AudioID(a0),d0
	move.l	d0,ahi_mode_new(a5)

	lea	-50(sp),sp

	lea	ahi_attrtags(pc),a1
	move.l	sp,ahimodenam-ahi_attrtags(a1)
	jsr	_LVOAHI_GetAudioAttrsA(a6)

	move.l	sp,a0
.f	tst.b	(a0)+
	bne.b	.f
	subq	#1,a0
	move.l	a0,d0
	sub.l	sp,d0
	moveq	#42,d1
	sub	d0,d1
	subq	#1,d1
	bmi.b	.h
.r	move.b	#' ',(a0)+
	dbf	d1,.r
	clr.b	(a0)
.h
	lea	ahi_name_new(a5),a1
	move.l	sp,a0
.c	move.b	(a0)+,(a1)+
	bne.b	.c

	lea	50(sp),sp


.gr
	tst.l	d6
	beq.b	.gr2
	move.l	d6,a0
	jsr	_LVOAHI_FreeAudioRequest(a6)
.gr2


	CLOSEAHI

;	bsr	pahi3
;	rts


pahi3	lea	ahi_name_new(a5),a0
	tst.b	(a0)
	bne.b	.y
	lea	.non(pc),a0
.y	movem	ahiG1+4,d0/d1
	add	#10,d0
	addq	#8,d1
	bra.w	print3b

.non	dc.b	"NONE",0
 even

rahi3_e
	lea	.e(pc),a1
	bra.w	request
.e	dc.b	"Couldn't open AHI device!",0
 even



audioreqtags2
	dc.l	AHIR_Window,0
	dc.l	AHIR_DoDefaultMode,TRUE
	dc.l	AHIR_SleepWindow,TRUE
	dc.l	AHIR_TitleText,ahirt
	dc.l	AHIR_TextAttr,text_attr
audioreqtags
	dc.l	TAG_END

ahirt	dc.b	"Select audio mode",0
 even

ahi_attrtags
	dc.l	AHIDB_BufferLen,39+4
	dc.l	AHIDB_Name,0
ahimodenam = *-4
	dc.l	TAG_END




*** ahi mixing rate
pahi4
rahi4
	lea	ahiG4,a2
	move	#580-050,d0		* max
	bsr.w	nappilasku
	add	#50,d0
	mulu	#100,d0
	move.l	d0,ahi_rate_new(a5)

	divu	#1000,d0
	swap	d0
	moveq	#0,d1
	move	d0,d1
	clr	d0
	swap	d0

	lea	info2_t(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
;	movem	ahiG4+4,d0/d1
	movem	4(a2),d0/d1
	sub	#65,d0
	addq	#8,d1
	bra.w	print3b

*** master volume
pahi5
rahi5	
	lea	ahiG5,a2
	move	#1000,d0		* max
	bsr.w	nappilasku
	move	d0,ahi_mastervol_new(a5)

	lea	.i(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
;	movem	ahiG5+4,d0/d1
	movem	4(a2),d0/d1
	sub	#49,d0
	addq	#8,d1
	bsr.w	print3b
	bra.b	updateahi

.i	dc.b	".%4.4ld",0
 even

*** stereo level
pahi6
rahi6	
	lea	ahiG6,a2
	moveq	#100,d0		* max
	bsr.w	nappilasku
	move	d0,ahi_stereolev_new(a5)

	lea	.i(pC),a0
	bsr.w	desmsg2
	lea	desbuf2(a5),a0
;	movem	ahiG6+4,d0/d1
	movem	4(a2),d0/d1
	sub	#41,d0
	addq	#8,d1
	bsr.w	print3b
	bra.b	updateahi
	

.i	dc.b	"%3.3ld%%",0
 even



updateahi
	pushm	all

	cmp	#pt_digiboosterpro,playertype(a5)
	beq.b	.d

	tst.b	ahi_use_nyt(a5)
	beq.b	.nd

.d	tst	playingmodule(a5)
	bmi.b	.nd
	tst.b	playing(a5)
	beq.b	.nd

	move.l	playerbase(a5),a0
	move	p_liput(a0),d0
	btst	#pb_ahi,d0
	beq.b	.nd

	move	ahi_mastervol_new(a5),d0
	move	ahi_stereolev_new(a5),d1
	jsr	p_ahiupdate(a0)
.nd	popm	all
	rts


 
*********************************
**************** Listselector
********************************

* Mielet�n.

wflags4 = WFLG_SMART_REFRESH!WFLG_ACTIVATE!WFLG_BORDERLESS!WFLG_RMBTRAP
idcmpflags4 = IDCMP_MOUSEBUTTONS!IDCMP_INACTIVEWINDOW

listselector
	pushm	d1-a6
	move.l	a0,a4

* d6/d7 = mouse position

	move.l	windowbase2(a5),a0	* prefs-ikkuna
	add	wd_LeftEdge(a0),d6	* mousepos suhteellinen prefs-ikkunan
	add	wd_TopEdge(a0),d7	* yl�laitaan


	lea	winlistsel,a0		* asetetaan pointterin kohdalle


	moveq	#0,d5
	move.b	(a4),d5
	mulu	#8,d5
	add	#16,d5
	move	d5,nw_Width(a0)

	lsr	#1,d5
	sub	d5,d6
	bpl.b	.oe
	moveq	#0,d6
.oe	move	d6,nw_LeftEdge(a0)

	moveq	#0,d5
	move.b	1(a4),d5
	mulu	#8,d5
	addq	#7,d5
	move	d5,nw_Height(a0)

	lsr	#1,d5
	sub	d5,d7
	bpl.b	.oee
	moveq	#0,d7
.oee	move	d7,nw_TopEdge(a0)

	bsr.w	tark_mahtu

	lore	Intui,OpenWindow
	move.l	d0,d5
	beq.w	.x
	move.l	d0,a0
	move.l	wd_RPort(a0),d7		* rastport
	move.l	wd_UserPort(a0),a3	* userport

	move.l	d7,a1
	move.l	pen_1(a5),d0
	lore	GFX,SetAPen
	move.l	d7,a1
	move.l	pen_0(a5),d0
	lob	SetBPen

	move.l	d7,a1
	move.l	fontbase(a5),a0
	lob	SetFont	


	pushm	all
	
	moveq	#0,d4
	move.b	(a4)+,d4	* max leveys
	lsl	#3,d4

	moveq	#0,d5
	move.b	(a4)+,d5	* vaakarivej�
	subq	#1,d5
	move.l	a4,a0

	moveq	#10,d3
.prl	
	move.l	a0,a1
.fe	tst.b	(a1)+
	bne.b	.fe
	move.l	a1,d1
	sub.l	a0,d1
	subq	#1,d1
	lsl	#3,d1
	move	d4,d0
	sub	d1,d0
	lsr	#1,d0
	addq	#8,d0

	move	d3,d1
	bsr.w	.print
	addq	#8,d3
	move.l	a1,a0
	dbf	d5,.prl

	movem.l	(sp),d0-a6

	move.l	d7,a1
	lea	winlistsel,a0
	moveq	#0,plx1
	move	nw_Width(a0),plx2
	moveq	#0,ply1
	move	nw_Height(a0),ply2
	subq	#1,ply2
	subq	#1,plx2
	bsr.w	laatikko1
	popm	all



.msgloop3
	moveq	#0,d0
	move.b	MP_SIGBIT(a3),d1	* IDCMP signalibitti
	bset	d1,d0
	lore	Exec,Wait			* Odotellaan...

	move.l	a3,a0
	lob	GetMsg
	tst.l	d0
	beq.b	.msgloop3

	move.l	d0,a1
	move.l	im_Class(a1),d2		* luokka	
	move	im_Code(a1),d3		* koodi
;	move.l	im_IAddress(a1),a2 	* gadgetin tai olion osoite
;	move	im_MouseX(a1),d6	* mousen koordinaatit
	move	im_MouseY(a1),d7

	lob	ReplyMsg

	cmp.l	#IDCMP_INACTIVEWINDOW,d2
	bne.b	.noc
.can	moveq	#-1,d7
	bra.b	.ox
.noc
	cmp.l	#IDCMP_MOUSEBUTTONS,d2
	bne.b	.msgloop3
	cmp	#MENUDOWN,d3		* oikea nappula
	beq.b	.can
	cmp	#SELECTDOWN,d3		* vasen nappula
	bne.b	.msgloop3

	subq	#4,d7
	bpl.b	.ok
	moveq	#0,d7
.ok	lsr	#3,d7


.ox
	move.l	d5,d0
	beq.b	.eek
	move.l	d0,a0
	lore	Intui,CloseWindow
.eek
.x
	move	d7,d0
	popm	d1-a6
	rts



.print	pushm	all
	move.l	d7,a4
	bra.w	uup	



*******************************************************************************

*******
* Kirjoitetaan n�kyv�t tiedoston nimet ikkunaan
*******

shownames2
	moveq	#1,d4
	bra.b	shn

clearbox
	tst	boxsize(a5)
	beq.b	.x
	tst.b	win(a5)
	bne.b	.r
.x	rts
.r	moveq	#30+WINX,d0
	moveq	#62+WINY,d1
	move	#251+WINX,d2
	move	#127+WINY,d3
	add	boxy(a5),d3
	bra.w	tyhjays

shownames
	moveq	#0,d4
shn
	tst	boxsize(a5)
	beq.b	.bx
	tst.b	win(a5)		* onko ikkunaa?
	bne.b	.iswin
.bx	rts

.iswin

	pushm	all


	tst	modamount(a5)
	bne.b	.eper

	bsr.b	clearbox

	bsr.w	printhippo1
	st	hippoonbox(a5)		* koko h�sk�n tulostus
	bra.w	.nomods
.eper

	tst	d4		* ei mink��nlaista uudelleensijoitusta
	bne.b	.nob

	move	boxsize(a5),d2
	move	d2,d3
	lsr	#1,d2
	
	moveq	#0,d0
	move	chosenmodule(a5),d0
	sub	d2,d0
	bmi.b	.nok
	move	modamount(a5),d1
	sub	d3,d1
	bmi.b	.nok
	cmp	d1,d0
	blo.b	.ok
	move	d1,d0
	bra.b	.ok
.nok	moveq	#0,d0	
.ok	move	d0,firstname(a5)

.nob
	tst.b	hippoonbox(a5)
	beq.b	.eh
	clr.b	hippoonbox(a5)
	bra.w	.neen
.eh

	

	move	firstname(a5),d0
	move	firstname2(a5),d7
	move	d0,firstname2(a5)
	cmp	d0,d7
	beq.b	.nomods
	sub	d0,d7
	bmi.b	.alas


.ylos	cmp	boxsize(a5),d7
	bhs.b	.all

	bsr.w	.unmark

* siirrytty d7 rivi� yl�sp�in:
* kopioidaan rivit 0 -> d7 (koko: boxsize-d7 r) kohtaan 0 ja printataan
* kohtaan 0 d7 kpl uusia rivej�


	moveq	#63+WINY,d1		* source y
	move	d7,d3
	lsl	#3,d3
	add	#63+WINY,d3		* dest y
	bsr.b	.copy
	move	firstname(a5),d0
	moveq	#0,d1
	move	d7,d2
	bra.b	.rcr


.alas	neg	d7		
	cmp	boxsize(a5),d7
	bhs.b	.all

	bsr.w	.unmark

* siirrytty d7 rivi� alasp�in:
* kopioidaan rivit d7 -> boxsizee (koko: boxsize-d7 r) kohtaan 0 ja printataan
* kohtaan boxsize-d7 d7 kpl uusia rivej�

	move	d7,d1
	lsl	#3,d1
	add	#63+WINY,d1		* source y	
	moveq	#63+WINY,d3	* dest y
	bsr.b	.copy
	move	firstname(a5),d0
	add	boxsize(a5),d0
	sub	d7,d0
	move	boxsize(a5),d1
	sub	d7,d1
	move	d7,d2


.rcr	bsr.b	.donames
	bra.b	.huh2

.nomods	
	bsr.w	.unmark
.huh2
.xx
	move	#-1,markedline(a5)
	move	chosenmodule(a5),d0
	bmi.b	.huh
	sub	firstname(a5),d0
	bmi.b	.huh
	move	d0,markedline(a5)		* merkit��n valittu nimi
	bsr.w	markit
.huh
	move	chosenmodule(a5),chosenmodule2(a5)
	move	firstname(a5),firstname2(a5)
	clr.b	dontmark(a5)

	popm	all
	rts

.all
.neen
	bsr.w	clearbox

	move	firstname(a5),d0
	moveq	#0,d1
	move	boxsize(a5),d2
	bsr.b	.donames
	bra.b	.huh2



.copy	
	move	boxsize(a5),d5	* y size
	sub	d7,d5
	lsl	#3,d5

	moveq	#32+WINX,d0	* source x
	move	d0,d2		* dest x
	move	#27*8+1,d4	* x size

	add	windowleft(a5),d0
	add	windowtop(a5),d1
	add	windowleft(a5),d2
	add	windowtop(a5),d3
	move.l	rastport(a5),a0
	move.l	a0,a1
	move.b	#$c0,d6		* minterm: a->d
	move.l	_GFXBase(a5),a6
	jmp	_LVOClipBlit(a6)
;	lore	GFX,ClipBlit
;	rts




* d0 = alkurivi
* d1 = eka rivi ruudulla
* d2 = printattavien rivien m��r�

.donames
	lea	listheader(a5),a4	
	subq	#1,d0
	bmi.b	.baa
.luuppo
	TSTNODE	a4,a3
	beq.w	.lop
	move.l	a3,a4
	dbf	d0,.luuppo
.baa
	move	d2,d5
	subq	#1,d5

	move	d1,d6
	lsl	#3,d6
	add	#83+WINY-14,d6		* Y

.looppo
	TSTNODE	a4,a3
	beq.w	.lop			* joko loppui
	move.l	a3,a4
	
	move.l	l_nameaddr(a3),a0
	bsr.w	cut_prefix
	move.l	a0,a1

	moveq	#0,d7

	cmp.b	#'�',(a1)
	bne.b	.nodi
	addq	#1,a1
	st	d7

	push	a1
	move.l	pen_2(a5),d0
	move.l	rastport(a5),a1
	lore	GFX,SetBPen
	move.l	pen_3(a5),d0
	move.l	rastport(a5),a1
	lob	SetAPen
	pop	a1
.nodi

	lea	-30(sp),sp
	move.l	sp,a2
	move.l	a2,a0
	moveq	#27-1,d0		* max kirjainten m��r� nimess�
.ff	move.b	(a1)+,(a2)+
	dbeq	d0,.ff
	tst	d0
	bmi.b	.fo
	subq	#1,a2
.fi	move.b	#' ',(a2)+
	dbf	d0,.fi
.fo	clr.b	(a2)


	tst.b	d7
	bne.b	.fu

	cmp.b	#pm_random,playmode(a5)
	bne.b	.fu
	tst.b	l_rplay(a3)
	beq.b	.fu
	move.b	#"�",-1(a2)
.fu



	moveq	#33+WINX,d0
	move.l	d6,d1
	addq.l	#8,d6
	bsr.w	print

	tst.b	d7
	beq.b	.nodiv
	move.l	pen_0(a5),d0
	move.l	rastport(a5),a1
	lore	GFX,SetBPen
	move.l	pen_1(a5),d0
	move.l	rastport(a5),a1
	lob	SetAPen
.nodiv

	lea	30(sp),sp
	dbf	d5,.looppo
.lop	rts
	

.unmark
	tst.b	dontmark(a5)
	bne.b	.huh22

	move	chosenmodule2(a5),d0
	bmi.b	.huh22
	sub	firstname2(a5),d0
	bmi.b	.huh22
	push	d7
	move	chosenmodule(a5),-(sp)
	move	chosenmodule2(a5),chosenmodule(a5)
	bsr.w	unmarkit
	move	(sp)+,chosenmodule(a5)
	pop	d7
.huh22	rts


***** Katkaisee prefixin nimest� a0:ssa

cut_prefix
	cmp.b	#'�',(a0)		* onko divideri?
	beq.b	.xx

	pushm	d0/a1
	move.b	prefixcut(a5),d0
	beq.b	.x
	move.l	a0,a1
	ext	d0
;	subq	#1,d0
.l	cmp.b	#".",(a0)+
	beq.b	.x
	tst.b	-1(a0)
	beq.b	.h
	dbf	d0,.l
.h	move.l	a1,a0
	
.x	popm	d0/a1
.xx	rts


*******************************************************************************
* Deletoidaan yksi tiedosto listasta
*******

hiiridelete
	bsr.w	areyousure_delete
	tst.l	d0
	bne.b	rbutton8b
	rts

rbutton8b
.l	moveq	#1,d7		* DELETE from DISK!
	bsr.b	elete
	tst.b	deleteflag(a5)
	bne.b	.l
	bra.w	resh
;	rts

rbutton8
delete
	moveq	#0,d7
	bsr.b	elete
	bsr.w	resh
	clr.b	deleteflag(a5)
	rts
elete

	clr.b	movenode(a5)
	moveq	#-1,d0
	move	d0,chosenmodule2(a5)
	st	hippoonbox(a5)
	bsr.w	clear_random

	move	chosenmodule(a5),d0
	bmi.w	.erer

	tst	playingmodule(a5)
	bmi.b	.huh	

	cmp	playingmodule(a5),d0	* onko dellattava sama kuin soitettava?
	beq.b	.sama

	subq	#1,playingmodule(a5)
	bpl.b	.huh
.sama	move	#$7fff,playingmodule(a5)

.huh	tst	modamount(a5)
	beq.w	.erer

	lea	listheader(a5),a4

.luuppo	TSTNODE	a4,a3
	beq.w	.erer
	move.l	a3,a4
	dbf	d0,.luuppo
	move.l	a3,d0
	beq.w	.erer

	tst.l	d7
	beq.b	.nmod

	cmp.b	#"�",l_filename(a3)
	bne.b	.de
	not.b	deleteflag(a5)
	beq.w	.nmodo
	bra.b	.ni

.de
	tst.b	deleteflag(a5)
	bne.b	.ni

	pushm	all
	lea	.del(pc),a0
	moveq	#37+WINX,d0
	bsr.w	printbox
	popm	all


	moveq	#-2,d5
	moveq	#0,d6
.noa
	lea	l_filename(a3),a0
	move.l	a0,d1
	lore	Dos,DeleteFile	
	tst.l	d0
	bne.b	.nmod

* ei onnistunu.
	addq	#1,d5
	beq.b	.ni

	tst	d6
	bne.b	.noa

	pushm	d5/d6
	bsr.w	rbutton4	* ejektoidaan ja yritet��n uusiks
	popm	d5/d6
	bra.b	.noa

.ni
** onko toisiks viimenen dellattava?
	move	modamount(a5),d0
	subq	#1,d0
	cmp	chosenmodule(a5),d0
	bne.b	.nmod
	clr.b	deleteflag(a5)

.nmod
	move.l	a3,a1
	lore	Exec,Remove
	move.l	a3,a0
	bsr.w	freemem

	subq	#1,modamount(a5)
	bpl.b	.ak
	bne.b	.ak
	move	#-1,chosenmodule(a5)
	bra.b	.ee
.ak	
	move	modamount(a5),d0
	cmp	chosenmodule(a5),d0
	bne.b	.ee
	subq	#1,d0
	move	d0,chosenmodule(a5)
.ee
.nmodo
	st	hippoonbox(a5)
	bra.w	shownames
;	rts

.erer	clr.b	deleteflag(a5)
	rts

.del	dc.b	"-��>> Deleting file! <<��-",0
 even	



***************************************************************************
*
* Execute file
*

execuutti
	lea	-300(sp),sp
	move.l	sp,a4
	clr.b	(a4)

	bsr.w	get_rt
	moveq	#RT_FILEREQ,D0
	sub.l	a0,a0
	lob	rtAllocRequestA
	move.l	d0,d7
	beq.b	.kex

	tst.b	uusikick(a5)
	beq.b	.ne
	move.l	lockhere(a5),d1
	pushpea	200(sp),d2
	moveq	#100,d3
	lore	Dos,NameFromLock
	lea	.tagz(pc),a0
	move.l	d7,a1
	pushpea	200(sp),4(a0)
	lore	Req,rtChangeReqAttrA
.ne
	lea	otag15(pc),a0
	move.l	d7,a1
	lea	(a4),a2		* tiedoston nimi

	lea	.title(pc),a3
	lob	rtFileRequestA		* ReqToolsin tiedostovalikko
	tst.l	d0
	beq.b	.kex

	move.l	d7,a0
	lea	100(a4),a1
	move.l	#'run ',(a1)+
	bsr.w	parsereqdir2
	addq	#1,a1
.c	move.b	(a4)+,(a1)+
	bne.b	.c

* sp+100 = ajettava komento

	pushpea	100(sp),d1
	moveq	#0,d2			* input
	move.l	nilfile(a5),d3		* output
	lore	Dos,Execute


.kex	lea	300(sp),sp
	rts

.tagz	dc.l	RTFI_Dir,0
	dc.l	TAG_END

.title	dc.b	"Select executable",0
 even

*******************************************************************************
* Kahden ylimm�isen tekstirivin hommat (loota)
*******
* 30 merkki� leve� alue

inforivit_clear
	movem.l	d0-d4,-(sp)
	moveq	#7+WINX,d0
	moveq	#11+WINY,d1
	move	#252+WINX,d2
	moveq	#28+WINY,d3
	bsr.w	tyhjays
	movem.l	(sp)+,d0-d4
	rts

inforivit_killerps3m
	lea	var_b,a5
inforivit_play
	bsr.b	inforivit_clear
	tst	playingmodule(a5)
	bpl.b	.huh
	bra.w	bopb
	
.huh	

	moveq	#0,d2

* Jos S3M, nime� ei tartte siisti�.


	cmp	#pt_multi,playertype(a5)
	bne.w	.eer

	move.l	ps3m_mtype(a5),a0
	cmp	#mtMOD,(a0)		* MODeissa ei konvertointia
	seq	d2

	lea	asciitable,a2		* konvertoidaan PC -> Amiga

	move.l	ps3m_mname(a5),a0
	move.l	(a0),a0
	lea	modulename(a5),a1
	moveq	#28-1,d0
	moveq	#0,d1
.copc	move.b	(a0)+,d1

	tst.b	d2
	beq.b	.htht
	move.b	d1,(a1)+
	bra.b	.hth
.htht	
	move.b	(a2,d1),(a1)+
.hth	dbeq	d0,.copc
	clr.b	(a1)

;	move	numchans,d2		* kanavien m��r�
	move.l	ps3m_numchans(a5),a0
	move	(a0),d2

;	move	mtype,d0
	move.l	ps3m_mtype(a5),a0
	move	(a0),d0
	move	d0,d3

	lea	.1(pc),a0
	subq	#1,d0
	beq.b	.hee

	lea	.2(pc),a0
	subq	#1,d0
	beq.b	.hee2
	lea	.3(pc),a0
	subq	#1,d0
	beq.b	.hee
	lea	.4(pc),a0
.hee	move.l	a0,d1

;	cmp	#mtMOD,mtype
	cmp	#mtMOD,d3
	bne.w	.leer
	pushm	d1/d2
	bsr.w	siisti_nimi
	popm	d1/d2
	bra.b	.leer

.hee2
	lea	modulename(a5),a1
	clr.b	20(a1)
	bra.b	.hee

.1	dc.b	"Screamtracker ]I[",0
.2	dc.b	"Pro/Fasttracker",0
.3	dc.b	"Multitracker",0
.4	dc.b	"Fasttracker ][ XM",0
 even

.eer	bsr.w	siisti_nimi
	move.l	playerbase(a5),a0
	lea	p_name(a0),a0
	move.l	a0,d1

	tst.b	oldst(a5)
 	beq.b	.leer
	pushpea	.oldst(pc),d1
	bra.b	.leer
.oldst	dc.b	"Old Soundtracker",0
 even
.leer

	lea	modulename(a5),a0
	move.l	a0,d0

	lea	tyyppi1_t(pc),a0
	tst	d2
	beq.b	.ic
	lea	tyyppi2_t(pc),a0
.ic	bsr.w	desmsg

	lea	desbuf(a5),a2		* moduletyyppi talteen
	move.l	a2,a0
	lea	moduletype(a5),a1
.ol	cmp.b	#10,(a2)+
	bne.b	.ol
	addq.l	#6,a2
.cep	move.b	(a2)+,(a1)+
	bne.b	.cep
	clr.b	(a1)

bipb	moveq	#18+WINY,d1
bipb2	moveq	#11+WINX,d0
	bsr.w	print
bopb	rts

putinfo
	bsr.w	inforivit_clear
	bra.b	bipb

putinfo2
	moveq	#26+WINY,d1
	bra.b	bipb2	

inforivit_load
	lea	.1(pc),a0
	bra.b	putinfo
.1	dc.b	"Loading to chip memory...",0
 even

inforivit_load2
inforivit_load3
	lea	.1(pc),a0
	bra.b	putinfo
.1	dc.b	"Loading to public memory...",0
 even

 
inforivit_tfmxload
	lea	.1(pc),a0
	bra.b	putinfo
.1	dc.b	"Loading TFMX samples...",0
 even

inforivit_ppload
	lea	.1(pc),a0
	bra.b	putinfo2
.1	dc.b	"PowerPacker file",0
 even

inforivit_pause
	lea	.1(pc),a0
	bra.w	putinfo2
;.1	dc.b	"        *** Paused ***        ",0
.1	dc.b	"-=-=-=-=-=- Paused -=-=-=-=-=-",0
 even

inforivit_xpkload
	lea	.1(pc),a0
	lea	probebuffer+8(a5),a1
	move.l	a1,d0
	bsr.w	desmsg
	lea	desbuf(a5),a0
	bra.w	putinfo2
.1	dc.b	"XPK %4s",0
 even

inforivit_xpkload2
	lea	.1(pc),a0
	bra.w	putinfo
.1	dc.b	"Identifying XPK file...",0
 even

inforivit_fimpload
	lea	.1(pc),a0
	bra.w	putinfo2
.1	dc.b	"FImp file",0
 even

inforivit_fimpdecr
	lea	.1(pc),a0
	bra.w	putinfo
.1	dc.b	"Exploding...",0
 even

inforivit_xfd
	lea	.1(pc),a0
	bsr.w	desmsg	
	lea	desbuf(a5),a0
	bra.w	putinfo
.1	dc.b	"XFD decrunching...",10
	dc.b	"%-30s",0
 even


inforivit_errc
	lea	.1(pc),a0
	bra.w	putinfo
.1	dc.b	"*** ERROR ***",10
	dc.b	"Skipping...",0
 even

inforivit_initerror
	lea	.1(pc),a0
	bra.w	putinfo
.1	dc.b	"Initialization error!",0
 even

inforivit_warn
	lea	.1(pc),a0
	bra.w	putinfo
.1	dc.b	"*** Warning! ***",10
	dc.b	"File was loaded in chip ram! ",0
 even

inforivit_group
	lea	.1(pc),a0
	bra.w	putinfo
.1	dc.b	"Loading player group...",0
 even

inforivit_group2
	lea	.1(pc),a0
	bra.w	putinfo
.1	dc.b	"Loading replayer...",0
 even

inforivit_extracting
	lea	.1(pc),a0
	tst	d6
	beq.b	.q
	lea	.2(pc),a0
	subq	#1,d6
	beq.b	.q
	lea	.3(pc),a0
.q	bra.w	putinfo
.1	dc.b	"LhA extracting...",0
.2	dc.b	"UnZipping...",0
.3	dc.b	"LZX extracting...",0
 even


* Siistit��n moduulin nimi 

siisti_nimi
	lea	modulename-1(a5),a0
	bsr.b	.cap
.loo	addq.l	#1,a0
	tst.b	(a0)
	beq.b	.end
	cmp.b	#' ',(a0)
	beq.b	.jee
	cmp.b	#'-',(a0)
	beq.b	.jee
	cmp.b	#'(',(a0)
	beq.b	.jee
	cmp.b	#')',(a0)
	beq.b	.jee
	cmp.b	#'<',(a0)
	beq.b	.jee
	cmp.b	#'>',(a0)
	beq.b	.jee
	cmp.b	#'_',(a0)
	beq.b	.jee
	bra.b	.loo
.end
	rts


.jee	tst.b	1(a0)
	beq.b	.end
	bsr.b	.cap
	bra.b	.loo

.cap	
	cmp.b	#'a',1(a0)		* Jos mahdollista, muutetaan
	blo.b	.m			* kirjain isoksi.
	cmp.b	#'z',1(a0)
	bhi.b	.m
	and.b	#$df,1(a0)

	cmp.b	#'I',1(a0)
	bne.b	.m
	cmp.b	#'i',2(a0)
	bne.b	.m
	and.b	#$df,2(a0)
	cmp.b	#'i',3(a0)
	bne.b	.m
	and.b	#$df,3(a0)
.m	rts



tyyppi1_t	dc.b	"Name: %.24s",10
		dc.b	"Type: %.24s",0

tyyppi2_t	dc.b	"Name: %.24s",10
		dc.b	"Type: %.24s %ldch",0
typpi
 even

*******************************************************************************
* Loota (otsikkopalkki tiedot)
*******

settimestart
	move.b	ahi_use(a5),ahi_use_nyt(a5)	* ahi:n tila talteen

	pushm	d0/d1/d2/a0/a1/a6
	pushpea	datestamp1(a5),d1
	lore	Dos,DateStamp
	move.l	datestamp1+4(a5),d0
	mulu	#60*50,d0
	add.l	datestamp1+8(a5),d0
	move.l	d0,aika1(a5)

	check	3

	popm	d0/d1/d2/a0/a1/a6
	rts


* 0= 	dc.b	8+4,"Time, pos/len, song",0
* 1= 	dc.b	0,"Time/duration, pos/len",0
* 2= 	dc.b	2*8,"Clock, free memory",0
* 3=		4*8,"Module name",0


lootaa					* p�ivitet��n kaikki

	bsr.w	lootaan_kello
;	bsr.w	lootaan_muisti
	bsr.w	lootaan_nimi
;	bsr.b	lootaan_aika		
;	rts

lootaan_pos

lootaan_song
;	moveq	#1,d0

lootaan_aika
	moveq	#0,d0
	tst	lootamoodi(a5)
	beq.b	.ook
	cmp	#3,lootamoodi(a5)
	beq.b	.ook
	rts
.ook	
	pushm	all
	clr.b	do_alarm(a5)		* sammutetaan her�tys

	clr	lootassa(a5)		

* ajan p�ivitys (datestamp-magic)

	tst	d0			* mit� t�� tekee?
	bne.b	.npa

	move.l	aika2(a5),d3

	pushpea	datestamp2(a5),d1
	lore	Dos,DateStamp
	move.l	datestamp2+4(a5),d0
	mulu	#60*50,d0
	add.l	datestamp2+8(a5),d0
	move.l	d0,aika2(a5)

	cmp	#pt_multi,playertype(a5)
	bne.b	.je
	cmp.b	#5,s3mmode1(a5)		* killer
	beq.b	.not
.je
	tst.b	playing(a5)
	bne.b	.npa

.not

	sub.l	d3,d0
	add.l	d0,aika1(a5)		* erotus samana jos ei soiteta
.npa

	move.l	aika2(a5),d0
	sub.l	aika1(a5),d0

	move.l	d0,hippoport+hip_playtime(a5)

************* t�h�n timeout!
	move	timeout(a5),d1
	beq.b	.ok0
	mulu	#50,d1
	cmp.l	d1,d0
	blo.b	.ok0

	cmp	#1,modamount(a5)	* 0 tai 1 modia -> ei timeouttia
	bls.b	.ok0

	tst.b	timeoutmode(a5)		* timeout-moodi
	beq.b	.all			* -> kaikille modeille

	move.l	playerbase(a5),a0	* vain niille, joilla ei ole
	move	p_liput(a0),d1		* end-detectia.
	btst	#pb_end,d1		* onko end-detect?
	bne.b	.ok0			* -> on
	btst	#pb_poslen,d1		* poslenist� voidaan p��tell� end-detect
	bne.b	.ok0

.all	push	d0			* painetaan 'next'i� :)

	move	#$28,rawkeyinput(a5)	* NEXT!

	move.l	playerbase(a5),a0	
	move	p_liput(a0),d1		
	btst	#pb_song,d1
	beq.b	.nosongs
	move	songnumber(a5),d0
	cmp	maxsongs(a5),d0
	beq.b	.nosongs
	move	#$4e,rawkeyinput(a5)	* next song
.nosongs

	move.b	ownsignal7(a5),d1
	bsr.w	signalit
	pop	d0
.ok0


	move.b	earlyload(a5),d1
	beq.b	.noerl
	tst.b	playing(a5)
	beq.b	.noerl

	tst.b	do_early(a5)		* joko oli p��ll�?
	bne.b	.noerl

	move	pos_maksimi(a5),d2
	sub	pos_nykyinen(a5),d2
	cmp.b	d1,d2
	bhi.b	.noerl

	st	do_early(a5)
	move	#$28,rawkeyinput(a5)
	move.b	ownsignal7(a5),d1
	pushm	all
	bsr.w	signalit
	popm	all
.noerl



	cmp.l	#99*60*50,d0		* onko aika 99:59?
	blo.b	.ok
	bsr.w	settimestart
	moveq	#0,d0
.ok

	divu	#50,d0
	ext.l	d0
	divu	#60,d0
	swap	d0
	moveq	#0,d1
	move	d0,d1
	clr	d0
	swap	d0

	bsr.w	logo
	divu	#10,d0
	add.b	#'0',d0
	move.b	d0,(a0)+
	swap	d0
	add.b	#'0',d0
	move.b	d0,(a0)+
	move.b	#':',(a0)+

	divu	#10,d1
	add.b	#'0',d1
	move.b	d1,(a0)+
	swap	d1
	add.b	#'0',d1
	move.b	d1,(a0)+

******
	cmp	#pt_sample,playertype(a5)
	beq.b	.koa
	cmp	#pt_prot,playertype(a5)
	bne.b	.oai
.koa	cmp	#3,lootamoodi(a5)
	bne.b	.oai
	

	move.b	#'/',(a0)+
	tst.l	kokonaisaika(a5)
	bne.b	.aik
	move.b	#'-',(a0)+
	move.b	#'-',(a0)+
	move.b	#':',(a0)+
	move.b	#'-',(a0)+
	move.b	#'-',(a0)+
	bra.b	.oai
.aik

	moveq	#0,d0
	move	kokonaisaika(a5),d0
	divu	#10,d0
	add.b	#'0',d0
	move.b	d0,(a0)+
	swap	d0
	add.b	#'0',d0
	move.b	d0,(a0)+
	move.b	#':',(a0)+

	moveq	#0,d1
	move	kokonaisaika+2(a5),d1
	divu	#10,d1
	add.b	#'0',d1
	move.b	d1,(a0)+
	swap	d1
	add.b	#'0',d1
	move.b	d1,(a0)+
.oai

*****
	tst	playingmodule(a5)
	bmi.w	.jaa

	move.l	playerbase(a5),a1
	move	p_liput(a1),d0
	btst	#pb_poslen,d0
	beq.b	.lootaan_song

	move.b	#" ",(a0)+
.lootaan_pos
	move	pos_nykyinen(a5),d0
	bsr.w	putnumber
	move.b	#'/',(a0)+
	move	pos_maksimi(a5),d0
	bsr.w	putnumber


.lootaan_song
	move.l	playerbase(a5),a1
	move	p_liput(a1),d0
	btst	#pb_song,d0
	beq.b	.jaa

	cmp	#pt_prot,playertype(a5)
	bne.b	.pot
	cmp	#3,lootamoodi(a5)
	beq.b	.jaa
.pot


	move	songnumber(a5),d0
	addq	#1,d0

	move.b	#' ',(a0)+
	move.b	#'#',(a0)+
	bsr.w	putnumber

	cmp	#pt_prot,playertype(a5)		* ei maxsongeja
	bne.b	.nptr
	cmp.b	#$ff,ptsonglist+1(a5)	* onko enemm�n kuin yksi songi??
	bne.b	.nptr
.ql	cmp.b	#'#',-(a0)		* jos vain yksi, ei songnumberia!
	bne.b	.ql
	bra.b	.jaa
.nptr
	cmp	#pt_sonicarr,playertype(a5)
	beq.b	.jaa

	move.b	#"/",(a0)+
	moveq	#0,d0
	move	maxsongs(a5),d0
	addq	#1,d0
	bsr.w	putnumber


.jaa	

;	tst.b	uusikick(a5)	
;	beq.b	.eisitten

;	cmp.b	#' ',-1(a0)
;	beq.b	.piz
;	move.b	#' ',(a0)+		* tungetaan aina modnimi v�liin
;.piz	lea	modulename(a5),a1
;	moveq	#40-1,d0
;.he	move.b	(a1)+,(a0)+
;	dbeq	d0,.he

;.eisitten	* vanhalla kickill� ei, koska se sotkee gadgetit jos liian pitk�
		* uudella tulee errori amigaguidella scrollailtaessa jos
		* teksti menee reunuksen yli.. kai. 
		

	clr.b	(a0)
	bra.w	lootaus




lootaan_kello
	cmp	#1,lootamoodi(a5)
	beq.b	.ook
	rts
.ook
	pushm	all
	moveq	#0,d7

	lea	-16(sp),sp
	move.l	sp,d1
	lore	Dos,DateStamp
	move.l	4(sp),d1
	lea	16(sp),sp
	cmp	#1,lootassa(a5)
	bne.b	.erp
	cmp	vanhaaika(a5),d1
	bne.b	.erp
	addq	#1,d7

.erp	move	#1,lootassa(a5)

	move	d1,vanhaaika(a5)
	divu	#60,d1			* tunnit/minuutit
	move.l	d1,d2

	move	d1,d3
	lsl	#8,d3			* d3 = alarm-vertaus


	lea	-10(sp),sp
	move.l	sp,a0
	move	d1,d0
	bsr.w	putnumber2
	move.b	#":",(a0)+
	move.l	d2,d0
	swap	d0
	add	d0,d3
	bsr.w	putnumber2
	clr.b	(a0)
	move.l	sp,a3

	cmp.b	#2,do_alarm(a5)
	beq.b	.noal
	cmp	alarm(a5),d3
	bne.b	.noal
	addq.b	#1,do_alarm(a5)
.noal


	moveq	#MEMF_CHIP,d1
	lore	Exec,AvailMem
	move.l	d0,d4
	moveq	#MEMF_FAST,d1
	lob	AvailMem
	move.l	d0,d5

	lsr.l	#8,d4
	lsr.l	#2,d4
	lsr.l	#8,d5
	lsr.l	#2,d5

	cmp	oldchip(a5),d4
	bne.b	.new
	cmp	oldfast(a5),d5
	bne.b	.new
	addq	#1,d7
.new
	move	d4,oldchip(a5)
	move	d5,oldfast(a5)

	cmp	#2,d7
	bne.b	.pr
	lea	10(sp),sp
	bra.w	xloota
.pr

	move.l	a3,d0
	moveq	#0,d1
	moveq	#0,d2
	move	d4,d1
	move	d5,d2
	lea	.form(pc),a0
	bsr.w	desmsg
	lea	10(sp),sp

	bra.b	lootaus

.form	dc.b	"HiP %s c%ld f%ld",0
 even

lootaan_nimi
	cmp	#2,lootamoodi(a5)
	beq.b	.ook
	rts
.ook
	pushm	all
	clr.b	do_alarm(a5)		* sammutetaan her�tys
	move	#2,lootassa(a5)

	bsr.b	logo
	lea	modulename(a5),a1
	moveq	#40-1,d0
.he	move.b	(a1)+,(a0)+
	dbeq	d0,.he
	clr.b	(a0)

lootaus

* Tulostetaan vain jos on muuttunut!

	lea	desbuf(a5),a0
	lea	wintitl(a5),a2
	move.l	a2,a1
.c	move.b	(a0)+,(a2)+
	bne.b	.c

	lea	wintitl2(a5),a0
	move.l	a1,a2

.fpel	move.b	(a0)+,d1
	move.b	(a2)+,d0
	beq.b	.e
	cmp.b	d0,d1
	bne.b	.jep
	bra.b	.fpel
.e	tst.b	d1
	beq.b	xloota

.jep	lea	wintitl2(a5),a0
	move.l	a1,a2
.poa	move.b	(a2)+,(a0)+
	bne.b	.poa

	tst.b	win(a5)
	beq.b	xloota
	move.l	windowbase(a5),a0
	lea	-1.w,a2			* Screentitle (ei ole)
	lore	Intui,SetWindowTitles

xloota	popm	all
	rts	


* titleen mahtuu 23 kirjainta 8*8 fontilla.

;wintitl ds.b	80
;wintitl2 ds.b	80

logo	lea	desbuf(a5),a0
	rts
;	lea	.hip(pc),a1
;.c	move.b	(a1)+,(a0)+
;	bne.b	.c
;	move.b	#' ',-1(a0)
;	rts
;.hip	dc.b	"HiP ",0
; even

* a0 = mihink� laitetaan
* d0 = luku joka k��nnet��n ASCIIksi
putnumber2
	st	d1
	bra.b	putnu
putnumber
	moveq	#0,d1
putnu	ext.l	d0
	divu	#100,d0
	beq.b	.e
	or.b	#'0',d0
	move.b	d0,(a0)+
	st	d1
.e
	clr	d0
	swap	d0
	divu	#10,d0
	bne.b	.b
	tst	d1
	beq.b	.c

.b	or.b	#'0',d0
	move.b	d0,(a0)+

.c	swap	d0
	or.b	#'0',d0
	move.b	d0,(a0)+
	rts


*******************************************************************************
* Hiiren nappuloita painettu, tutkitaan oliko tiedostojen p��ll�
* ja pistet��n palkki
*******

markline
	tst	boxsize(a5)
	bne.b	.m
	rts
.m
	move	mousex(a5),d0
	move	mousey(a5),d1
	sub	windowleft(a5),d0
	sub	windowtop(a5),d1	* suhteutus fonttiin
	
	cmp	#30+WINX,d0		* onko tiedostolistan p��ll�?
	blo.w	.out
	cmp	#251+WINX,d0
	bhi.w	.out
	cmp	#63+WINY,d1
	blo.w	.out
	move	#126+WINY,d2
	add	boxy(a5),d2
	cmp	d2,d1
	bhi.w	.out

	sub	#63+WINY,d1
	lsr	#3,d1

	tst	modamount(a5)
	bne.b	.ona
	moveq	#0,d1		* ei oo modeja, otetaan eka
.ona

	move	d1,d2
	add	firstname(a5),d1
	cmp	chosenmodule(a5),d1
	beq.b	.oo

	cmp	#$7fff,chosenmodule(a5)
	beq.b	.oo
	pushm	d1/d2
	bsr.b	unmarkit
	popm	d1/d2
.u	st	dontmark(a5)
.oo	
	move	d1,chosenmodule(a5)
	move	d2,markedline(a5)

	move	clickmodule(a5),d3
	move	d1,clickmodule(a5)


	cmp	d1,d3
	bne.b	.nodouble
	move	#-1,clickmodule(a5)	

	subq.l	#8,sp
	lea	(sp),a0
	lea	4(sp),a1
	lore	Intui,CurrentTime
	movem.l	(sp)+,d2/d3
	movem.l	clicksecs(a5),d0/d1
	lob	DoubleClick
	tst.l	d0
	beq.b	.double
* Tiedostoa doubleclickattu! Soitetaan...

	tst.b	doubleclick(a5)		* onko sallittua?
	bne.w	rbutton1		* Play!
	rts

.nodouble
	lea	clicksecs(a5),a0	* klikin aika talteen
	lea	clickmicros(a5),a1
	lore	Intui,CurrentTime
.double
	bsr.w	shownames2
	bsr.w	reslider
.out	rts



unmarkit			* pyyhitaan merkkaus pois
markit
	move	markedline(a5),d5
	bmi.b	.outside
	cmp	boxsize(a5),d5
	bhs.b	.outside
	tst.b	win(a5)
	beq.b	.outside

	lea	listheader(a5),a4	
	move	chosenmodule(a5),d0	* etsit��n kohta
.luuppo
	TSTNODE	a4,a3
	beq.b	.nomods
	move.l	a3,a4
	dbf	d0,.luuppo


	move	d5,d1
	lsl	#3,d1		* mulu #8,d1
	add	#63+WINY,d1
	moveq	#33+WINX,d0 
	add	windowleft(a5),d0
	add	windowtop(a5),d1
	move	d0,d2
	move	d1,d3
	move	#216,d4
	moveq	#8,d5
	moveq	#$50,d6		* EOR
	
	move.l	rastport(a5),a1
	move.b	rp_Mask(a1),d7
	move.b	#%11,rp_Mask(a1)	* K�sitell��n kahta alinta bittitasoa.
	move.l	a1,a0
	lore	GFX,ClipBlit

	move.l	rastport(a5),a1
	move.b	d7,rp_Mask(a1)

.nomods
.outside	
	rts




*******************************************************************************
* Lataa keyfilen
*******

loadkeyfile
	pushm	all
	move.l	_DosBase(a5),a6
	pushpea	keyfilename(pc),d1
	moveq	#_LVOOpen*4,d0
	move.l	#400,-(sp)
	add.l	#605,(sp)
	pop	d2
	bsr.b	.nixi	
	move.l	d0,d4
	beq.b	.error

	move.l	d4,d1
	pushpea	keyfile(a5),d2
	moveq	#64,d3
	lob	Read

	move.l	d4,d1
	lob	Close	

.error
	popm	all
	rts


.nixi	asr.l	#2,d0
	jsr	(a6,d0)
	rts




*******************************************************************************
* Module info
*******


sulje_foo
	cmp	#33,info_prosessi(a5)
	shs	oli_infoa(a5)
	rts

*** Sulkee module infon
sulje_info
	cmp	#33,info_prosessi(a5)
	bhs.b	.joo
	clr.b	oli_infoa(a5)
	rts

.joo	
	pushm	d0/d1/a0/a1/a6
	move.l	info_task(a5),a1
	moveq	#0,d0
	move.b	info_signal(a5),d1
	bset	d1,d0
	lore	Exec,Signal	

.t	tst	info_prosessi(a5)	* odotellaan
	beq.b	.tt
	bsr.w	dela
	bra.b	.t
.tt
	popm	d0/d1/a0/a1/a6
	rts


	
start_info
	

	tst.b	oli_infoa(a5)
	bne.b	.j
	tst	info_prosessi(a5)
	beq.b	.x
.j
	tst	info_prosessi(a5)
	beq.b	rbutton10b
	move.l	info_task(a5),a1		* P�ivityspyynt�!
	moveq	#0,d0
	move.b	info_signal2(a5),d1
	bset	d1,d0
	move.l	(a5),a6
	jmp	_LVOSignal(a6)


.x	clr.b	oli_infoa(a5)
	rts


rbutton10b
	tst	info_prosessi(a5)
	bne.b	sulje_info

;	bra	infocode


	movem.l	d0-a6,-(sp)
	move.l	_DosBase(a5),a6
	;pushpea	infoprocname(pc),d1
	move.l	#infoprocname,d1
	move.l	priority(a5),d2

;	pushpea	info_segment(pc),d3
	move.l	#info_segment,d3
	lsr.l	#2,d3
	move.l	#4000,d4
	lob	CreateProc
	tst.l	d0
	beq.b	.n
	addq	#1,info_prosessi(a5)
.n	movem.l	(sp)+,d0-a6
.x	rts


info_code
	lea	var_b,a5
	addq	#1,info_prosessi(a5)

	sub.l	a1,a1
	lore	Exec,FindTask
	move.l	d0,info_task(a5)


	moveq	#-1,d0
	lob	AllocSignal
	move.b	d0,info_signal(a5)
	moveq	#-1,d0
	lob	AllocSignal
	move.b	d0,info_signal2(a5)

	bsr.b	infocode

	move.b	info_signal(a5),d0
	bsr.w	freesignal
	move.b	info_signal2(a5),d0
	bsr.w	freesignal

	lore	Exec,Forbid
	clr	info_prosessi(a5)
	rts





************* Module info

infocode


*** Avataan ikkuna
* 39 kirjainta mahtuu laatikkoon
* Linefeedi ILF joka my�hemmin korvataan 10:ll�. Sit�varten ett� voidaan
* karsia ylim��r�set linefeedit pois.


ILF	=	$83
ILF2	=	$03

swflags set WFLG_SMART_REFRESH!WFLG_NOCAREREFRESH!WFLG_DRAGBAR
swflags set swflags!WFLG_CLOSEGADGET!WFLG_DEPTHGADGET!WFLG_RMBTRAP
sidcmpflags set IDCMP_CLOSEWINDOW!IDCMP_GADGETUP!IDCMP_MOUSEMOVE!IDCMP_RAWKEY
sidcmpflags set sidcmpflags!IDCMP_MOUSEBUTTONS

	tst.b	gotscreeninfo(a5)
	bne.b	.joo
	bsr.w	getscreeninfo
.joo



.urk	lea	swinstruc,a0
	move	nw_Height(a0),oldswinsiz(a5)
	move	gg_Height+gAD1,oldsgadsiz(a5)

	move	infosize(a5),d0
	subq	#3,d0
	lsl	#3,d0
	add	d0,nw_Height(a0)
	add	d0,gg_Height+gAD1

	move	wbkorkeus(a5),d2
.lo	cmp	nw_Height(a0),d2
	bhi.b	.fine

	clr	nw_TopEdge(a0)		* sijoitetaan mahd. yl�s
	subq	#1,infosize(a5)
	subq	#8,nw_Height(a0)


	move	infosize(a5),d0
	subq	#3,d0
	lsl	#3,d0
	add	oldsgadsiz(a5),d0
	move	d0,gg_Height+gAD1
	bra.b	.lo


.fine
	move.l	infopos2(a5),(a0)
	bsr.w	tark_mahtu

	move	#7,slim2height

	lore	Intui,OpenWindow
	move.l	d0,swindowbase(a5)

	and.l	#~WFLG_ACTIVATE,sflags	* clearataan active-flaggi

	move	d7,swinstruc+nw_Height

	tst.l	d0
	bne.b	.koo
	lea	windowerr_t(pc),a1
	bsr.w	request
	bra.w	.sexit
.koo

	move.l	d0,a0
	move.l	wd_RPort(a0),srastport(a5)
	move.l	wd_UserPort(a0),suserport(a5)

	move.l	srastport(a5),a1
	move.l	fontbase(a5),a0
	lore	GFX,SetFont	
	
	move.l	swindowbase(a5),a0
	bsr.w	setscrtitle


	tst.b	uusikick(a5)		* uusi kick?
	beq.b	.vanaha

	move.l	srastport(a5),a2
	moveq	#4,d0
	moveq	#11,d1
	move	#356-5-2+2,d2
	move	#147-13*8-2,d3
	move	infosize(a5),d4
	subq	#3,d4
	lsl	#3,d4
	add	d4,d3
	bsr.w	drawtexture



.vanaha

	lea	gAD1,a3
	tst.b	uusikick(a5)
	beq.b	.nel

	movem	4(a3),plx1/ply1/plx2/ply2	* slider
	add	plx1,plx2
	add	ply1,ply2
	subq	#2,plx1
	addq	#1,plx2
	subq	#2,ply1
	addq	#1,ply2
	move.l	srastport(a5),a1
	bsr.w	sliderlaatikko


.nel

.reprint


	moveq	#29,plx1
	move	#351-3,plx2
	moveq	#13,ply1
	move	#143-13*8,ply2
	move	infosize(a5),d0
	subq	#3,d0
	lsl	#3,d0
	add	d0,ply2
	add	windowleft(a5),plx1
	add	windowleft(a5),plx2
	add	windowtop(a5),ply1
	add	windowtop(a5),ply2
	move.l	srastport(a5),a1


	lea	laatikko2(pc),a0
	tst.b	infolag(a5)
	bne.b	.a
	cmp	#pt_prot,playertype(a5)
	bne.b	.a

	lea	laatikko1(pc),a0
.a	jsr	(a0)



	pushm	all
	lea	gAD1,a0
	move.l	gg_SpecialInfo(a0),a1
	move	pi_Flags(a1),d0
	move.l	swindowbase(a5),a1
	sub.l	a2,a2
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	lore	Intui,ModifyProp

	popm	all


	moveq	#31-2+2,d0		* tyhjennet��n
	moveq	#15-1,d1
	move	#350-31-5+2,d4
	move	#144-15-13*8,d5
	move	infosize(a5),d6
	subq	#3,d6
	lsl	#3,d6
	add	d6,d5
	add	windowleft(a5),d0
	add	windowtop(a5),d1
	move.l	srastport(a5),a0
	move.l	a0,a1
	move	d0,d2
	move	d1,d3
	moveq	#$0a,d6
	lore	GFX,ClipBlit
	st	skokonaan(a5)

	move.b	infolag(a5),d0
	clr.b	infolag(a5)
	tst.b	d0
	beq.b	.modinf

******** About- aiheet
	move	#39,info_prosessi(a5)		* info-lippu
;	lea	about_t(pc),a0
	printt Ugh!
	lea	about_t,a0
	move.l	a0,infotaz(a5)
	tst.b	keycheck(a5)
	bne.w	.nox

	lea	(about_t1-about_t)(a0),a4
	lea	(about_tt-about_t1)(a4),a0
	lea	-200(sp),sp
	move.l	sp,a3

	moveq	#0,d0
	move	modamount(a5),d0
	moveq	#0,d1
	move	divideramount(a5),d1
	sub	d1,d0
	movem.l	d0/d1,-(sp)
	pea	keyfile(a5)
	move.l	sp,a1
	bsr.w	desmsg4
	add	#8+4,sp
	st	eicheck(a5)

	move.l	sp,a0
.c	move.b	(a0)+,(a4)+
	bne.b	.c
	move.b	#'�',-1(a4)

	lea	200(sp),sp

	bra.w	.nox



.modinf


******** Kehitell��n infoa moduulista

	clr	sfirstname(a5)
	clr	sfirstname2(a5)
	clr.l	infotaz(a5)

	tst	playingmodule(a5)
	bpl.b	.bah

	move	#35,info_prosessi(a5)		* lipbub

	moveq	#3,d5
	bsr.w	.allo2
	beq.w	.sexit

	lea	.huhe(pc),a0
	move.l	infotaz(a5),a1
.faz	move.b	(a0)+,(a1)+
	bne.b	.faz
	bra.w	.selvis

.bah



******************* THX

	cmp	#pt_thx,playertype(a5)
	bne.b	.nothx
	move	#33,info_prosessi(a5)


	move.l	moduleaddress(a5),a4
	moveq	#0,d5
	move.b	12(a4),d5
	move	d5,d7
	bsr.w	.allo
	beq.w	.sexit

	move.l	moduleaddress(a5),a4
	move.l	a4,a2
	add.l	modulelength(a5),a2

	add	4(a4),a4
	bsr.b	.fo

	subq	#1,d7
	moveq	#1,d0

.thxb
	lea	-10(sp),sp
	move.l	sp,a1

	move.l	d0,(a1)
	move.l	a4,4(a1)
	lea	.thxform(pc),a0
	bsr.w	desmsg4
	bsr.w	.lloppu
	lea	10(sp),sp
	bsr.b	.fo
	
	addq	#1,d0
	dbf	d7,.thxb

	bra.w	.selvis

.fo	cmp.l	a2,a4
	beq.b	.fox
	tst.b	(a4)+
	bne.b	.fo
.fox	rts

******************* DIGI Booster
.nothx

	cmp	#pt_digibooster,playertype(a5)
	bne.b	.nobooster
	move	#33,info_prosessi(a5)

	moveq	#31,d5
	bsr.w	.allo
	beq.w	.sexit


	move.l	moduleaddress(a5),a0
	lea	176(a0),a2		* lengths
	lea	642(a0),a4		* samplenames

	moveq	#31-1,d7
	moveq	#1,d0

.digib

	lea	-16(sp),sp
	move.l	sp,a1

	move.l	d0,(a1)
	move.l	(a2)+,8(a1)
	move.l	a4,4(a1)

	lea	.medform(pc),a0
	bsr.w	desmsg4

	lea	16(sp),sp
	bsr.w	.lloppu

	lea	30(a4),a4
	
	addq	#1,d0
	dbf	d7,.digib

	bra.w	.selvis


.nobooster


	cmp	#pt_med,playertype(a5)		* MED
	bne.b	.nomed
	move	#33,info_prosessi(a5)		* lipub

***************** MED
	tst.b	medrelocced(a5)		* pit�� olla relokatoitu
	beq.w	.noo

	move.l	moduleaddress(a5),a0
	move.l	32(a0),a1		* MMD0exp
	tst.l	20(a1)
	beq.w	.noo_med
	move.l	20(a1),a2		* MMDInstrInfo (samplenamet)
	move	24(a1),d4		* samplejen m��r�
	move	26(a1),d6		* entry size

	move.l	24(a0),d7		* insthdr

	move	d4,d5
	bsr.w	.allo
	beq.w	.sexit

	move.l	d7,a0

	subq	#1,d4
	moveq	#1,d0
.medl
	move.l	a2,d1
	move.l	(a0)+,d2
	bne.b	.moe
	lea	.zero(pc),a1
	moveq	#0,d2
	bra.b	.moee
.moe
	move.l	d2,a1
	move.l	(a1),d2
.moee

	push	a0
	lea	-16(sp),sp
	move.l	sp,a1
	movem.l	d0/d1/d2,(a1)
	lea	.medform(pc),a0
	bsr.w	desmsg4
	lea	16(sp),sp
	bsr.w	.lloppu
	pop	a0

	add	d6,a2
	addq	#1,d0
	dbf	d4,.medl

	bra.w	.selvis



.nomed
	cmp	#pt_sid,playertype(a5)		* PSID
	bne.w	.nosid

* SID piisista infoa

	move	#33,info_prosessi(a5)		* PSID info-lippu


	lea	-42(sp),sp
	move.l	sp,a1
	pushpea	sidheader+sidh_name(a5),(a1)+
	pushpea	sidheader+sidh_author(a5),(a1)+
	pushpea	sidheader+sidh_copyright(a5),(a1)+
	clr.l	(a1)+
	clr.l	(a1)+
	move	sidheader+sidh_number(a5),-6(a1)
	move	sidheader+sidh_defsong(a5),-2(a1)
	move.l	modulelength(a5),(a1)+
	move.l	moduleaddress(a5),d0
	move.l	d0,(a1)+
	add.l	modulelength(a5),d0
	move.l	d0,(a1)+
	pushpea	filecomment(a5),(a1)+
	clr.l	(a1)

	move.l	sp,a1
	moveq	#11,d5
	bsr.w	.allo2
	bne.b	.jee9
	lea	42(sp),sp
	bra.w	.sexit
.jee9

	lea	.form(pc),a0
	move.l	infotaz(a5),a3
	bsr.w	desmsg4
	lea	42(sp),sp

	bsr.w	.putcomment
	bra.w	.selvis


.form	dc.b	"PSID-module",ILF,ILF2
	dc.b	"�����������",ILF,ILF2
	dc.b	"Name: %-33.33s",ILF,ILF2
	dc.b	"Author: %-31.31s",ILF,ILF2
	dc.b	"Copyright: %-28.28s",ILF,ILF2
	dc.b	"Songs: %ld (default %ld)",ILF,ILF2
	dc.b	"Size: %-7.ld     ($%08.lx-$%08.lx)",ILF,ILF2
	dc.b	"Comment:",ILF,ILF2,0
 even


.huhe	dc.b	ILF,ILF2
	dc.b	"          No info available.",0
.zero = *-1
 even

.nosid



********* module (PT)

	move	#34,info_prosessi(a5)		* show samplenames info-lippu

	

	cmp	#pt_prot,playertype(a5)
	bne.b	.nop
	move.l	#ptheader,d4
	bra.b	.mod
.nop
	cmp	#pt_multi,playertype(a5)
	bne.w	.noo
	move.l	moduleaddress(a5),d4

	move.l	ps3m_mtype(a5),a0
	cmp	#mtMOD,(a0)
	beq.b	.mod
	cmp	#mtS3M,(a0)
	beq.w	.s3m
	cmp	#mtMTM,(a0)
	beq.w	.mtm
	cmp	#mtXM,(a0)
	beq.w	.xm
	bra.w	.noo


.mod	
	moveq	#31,d5
	bsr.w	.allo
	beq.w	.sexit

	moveq	#0,d7
	moveq	#31-1,d6
.loop2	move	d7,d0
	mulu	#30,d0
	move.l	d4,a0
	lea	20(a0,d0),a2		* 22 bytes samplename

** kludge, jos eka char on 0 ja toka ei, se on samplename.
	tst.b	(a2)
	bne.b	.nokl
	tst.b	1(a2)
	beq.b	.nokl
	move.b	#' ',(a2)
.nokl

	lea	-24(sp),sp
	move.l	sp,a0
	move.l	a0,d1			* name, null terminated
	move.l	a2,a1
	moveq	#22-1,d0
.copz	move.b	(a1)+,(a0)+
	dbeq	d0,.copz
	clr.b	(a0)

	moveq	#0,d2
	move	22(a2),d2
	add.l	d2,d2			* length

	move.l	d7,d0
	addq	#1,d0


	lea	-16(sp),sp
	move.l	sp,a1
	movem.l	d0/d1/d2,(a1)
	lea	.form0(pc),a0
	bsr.w	desmsg4
	lea	16(sp),sp
	bsr.w	.lloppu

	lea	24(sp),sp

	addq	#1,d7
	dbf	d6,.loop2
	bra.w	.selvis






******* screamtracker

.s3m
	move.l	d4,a0
	move	insnum(a0),d5
	iword	d5
	bsr.w	.allo
	beq.w	.sexit

* a3 = pointteri tekstipuskuriin

	move.l	d4,a0
	move	insnum(a0),d5
	iword	d5

	moveq	#0,d7

.loop	move	d7,d0
	add	d0,d0

	move.l	ps3m_samples(a5),a2
	move.l	(a2),a2
	move	(a2,d0),d0
	iword	d0
	lsl	#4,d0
	move.l	d4,a0
	lea	(a0,d0),a0
	lea	insname(a0),a1
	move.l	a1,d1
	move.l	inslength(a0),d2
	ilword	d2
	and.l	#$7ffff,d2
	move.l	d7,d0
	addq	#1,d0

	lea	-16(sp),sp
	move.l	sp,a1
	movem.l	d0/d1/d2,(a1)
	lea	.form2(pc),a0
	bsr.w	desmsg4
	lea	16(sp),sp
	bsr.w	.lloppu

	addq	#1,d7
	cmp	d5,d7
	blo.b	.loop
.pois	
	bra.w	.selvis


***** XM

.xm
	move.l	d4,a0
	lea	xmNumInsts(a0),a0
	tword	(a0)+,d5
	bsr.w	.allo
	beq.w	.sexit

	move.l	d4,a0
	move.l	ps3m_xm_insts(a5),a0
	moveq	#0,d7

.loop0	move	d7,d0
	lsl	#2,d0
	move.l	(a0,d0),a2
	moveq	#0,d1
	move.l	a2,a1
	tlword	(a1)+,d0
	move.l	a1,d6			; Name

	lea	xmNumSamples(a2),a1
	tword	(a1)+,d2
	tst	d2
	beq.b	.skip
	lea	xmSmpHdrSize(a2),a1
	tlword	(a1)+,d3
	add.l	d0,a2
	subq	#1,d2
.k0o	move.l	a2,a1
	tlword	(a1)+,d0
	add.l	d0,d1
	add.l	d3,a2
	dbf	d2,.k0o

.skip	
;	move.l	d1,(a4)+	* size



	pushm	d0-a2/a4-a6
	move.l	d1,d2
	and.l	#$7ffff,d2
	move.l	d7,d0
	addq	#1,d0
	move.l	d6,d1
	lea	-16(sp),sp
	move.l	sp,a1
	movem.l	d0/d1/d2,(a1)
	lea	.form2(pc),a0
	bsr.w	desmsg4
	lea	16(sp),sp
	popm	d0-a2/a4-a6
	bsr.w	.lloppu


	addq.l	#1,d7
	cmp	d5,d7
	blo.w	.loop0

	bra.w	.selvis


***** multitracker

.mtm
	move.l	d4,a0
	moveq	#0,d5
	move.b	30(a0),d5
	bsr.w	.allo
	beq.w	.sexit

	moveq	#0,d7
.loop3	move	d7,d0
	mulu	#37,d0
	move.l	d4,a0
	lea	66(a0,d0),a2
	move.l	a2,d1			; Name

	moveq	#0,d2
	move.b	22(a2),d2
	lsl	#8,d2
	move.b	23(a2),d2
	lsl.l	#8,d2
	move.b	24(a2),d2
	lsl.l	#8,d2
	move.b	25(a2),d2
	ilword	d2
;	move.l	d2,(a4)+		* size


	move.l	d7,d0
	addq	#1,d0

	lea	-16(sp),sp
	move.l	sp,a1
	movem.l	d0/d1/d2,(a1)
	lea	.form2(pc),a0
	bsr.w	desmsg4
	lea	16(sp),sp
	bsr.w	.lloppu


	addq.l	#1,d7
	cmp	d5,d7
	blo.b	.loop3
	bra.w	.pois



* PS3M
.form11	dc.b	"Name: %-33.33s",ILF,ILF2
	dc.b	"Type: %-25.25s %2.ld.%1.1ldkHz",ILF,ILF2
	dc.b	"Size: %-7.ld     ($%08.lx-$%08.lx)",ILF,ILF2
	dc.b	"Comment: ",0


* PT
.form1	dc.b	"Name: %-33.33s",ILF,ILF2
	dc.b	"Type: %-33.33s",ILF,ILF2
	dc.b	"Size: %-7.ld     ($%08.lx-$%08.lx)",ILF,ILF2
	dc.b	"Comment: ",0

** PT

.form0	dc.b	'%02ld %-22.22s        %6ld',ILF,ILF2,0

** PS3M

.medform 
.form2	dc.b	`%03ld %-28.28s %6ld`,ILF,ILF2,0

.thxform
 	dc.b	`%03ld %-35.35s`,ILF,ILF2,0

 even



** Joku muu modi

.noo_med
.noo
	move	#35,info_prosessi(a5)

	lea	.form3(pc),a0

	lea	-32(sp),sp
	move.l	sp,a4
	bsr.w	.namtypsizcom

	moveq	#10,d5
	bsr.w	.allo2
	bne.b	.jee9a
	lea	32(sp),sp
	bra.w	.sexit
.jee9a
	move.l	sp,a1
	move.l	infotaz(a5),a3
	bsr.w	desmsg4
	bsr.b	.putcomment
	lea	32(sp),sp
	bra.w	.selvis


.form3	
	dc.b	"Name: %-33.33s",ILF,ILF2
	dc.b	"Type: %-33.33s",ILF,ILF2
	dc.b	"Size: %-9.ld   ($%08.lx-$%08.lx)",ILF,ILF2,ILF,ILF2
	dc.b	"Comment:",ILF,ILF2,0
	
 even


.putcomment
	pushm	d0/d1/a0/a3
	moveq	#39+1,d1
	bra.b	.puct

.putcomment2
	pushm	d0/d1/a0/a3
	moveq	#30+1,d1
.puct
	move.l	infotaz(a5),a3
	bsr.w	.lloppu

	lea	filecomment(a5),a0
	moveq	#0,d0
.com	addq	#1,d0
	cmp	d1,d0
	bne.b	.naga
	moveq	#39,d1
	tst.b	(a0)
	beq.b	.naga
	moveq	#0,d0
	move.b	#ILF,(a3)+
	move.b	#ILF2,(a3)+
.naga	move.b	(a0)+,(a3)+
	bne.b	.com
	popm	d0/d1/a0/a3
	rts
 
*************************************

.namtypsizcom
	pushm	d0/d1

	pushpea	modulename(a5),(a4)+
	pushpea	moduletype(a5),(a4)+

	cmp	#pt_med,playertype(a5)
	bne.b	.lee
	cmp.b	#2,medtype(a5)		* Med 1-64ch?
	bne.b	.lee

	move.l	moduleaddress(a5),a1	* onko samplenimi�?
	move.l	32(a1),a1		* MMD0exp
	tst.l	20(a1)
	bne.b	.rrqq

.lee
	cmp	#pt_multi,playertype(a5)		* mixing rate
	bne.b	.nah

.rrqq	
	move.l	mixirate(a5),d0
	tst.b	ahi_use_nyt(a5)
	beq.b	.psz
	move.l	ahi_rate(a5),d0
.psz
	divu	#1000,d0
	move.l	d0,d1
	clr	d1
	swap	d1
	ext.l	d0
	move.l	d0,(a4)+
	move.l	d1,(a4)+
.nah

	move.l	modulelength(a5),(a4)

	tst.b	lod_xpkfile(a5)		* v�hennet��n xpk:n turvapuskurin koko
	beq.b	.noxp
	sub.l	#256,(a4)
.noxp
	addq.l	#4,a4

	cmp	#pt_sample,playertype(a5)
	beq.b	.jccc
	cmp	#pt_tfmx,playertype(a5)
	beq.b	.jt
	cmp	#pt_tfmx7,playertype(a5)
	bne.b	.jcc

.jt
	move.l	tfmxsampleslen(a5),d0
	add.l	d0,-4(a4)

* tfmx? pistet��n mdat ja smpl alkuosoitteet
	move.l	moduleaddress(a5),(a4)+
	move.l	tfmxsamplesaddr(a5),(a4)+
	bra.b	.xop
.jccc
	clr.l	(a4)+		* sampleilla ei osoitteita
	clr.l	(a4)+
	bra.b	.xop
.jcc


	move.l	moduleaddress(a5),d0
	move.l	d0,(a4)+
	add.l	modulelength(a5),d0
	move.l	d0,(a4)+

.xop

	popm	d0/d1
	rts


.allo
	bsr.b	.allo2
	beq.b	.xiipo

	lea	-32(sp),sp
	move.l	sp,a4
	bsr.w	.namtypsizcom

	lea	.form1(pc),a0

	cmp	#pt_med,playertype(a5)
	bne.b	.nee
	cmp.b	#2,medtype(a5)
	beq.b	.okod
;	move.l	moduleaddress(a5),a0
;	move.l	32(a0),a0		* MMD0exp
;	tst.l	20(a0)			* onko samplenimi�?
;	beq.b	.okod
.nee
	cmp	#pt_multi,playertype(a5)
	bne.b	.bahz
.okod	lea	.form11(pC),a0
.bahz	


	move.l	sp,a1
	move.l	infotaz(a5),a3
	bsr.w	desmsg4
	lea	32(sp),sp

	bsr.w	.putcomment2
	
	move.l	infotaz(a5),a3
	bsr.b	.lloppu

	move.b	#ILF,(a3)+
	move.b	#ILF2,(a3)+
	moveq	#39-1,d0
.ca	move.b	#"�",(a3)+
	dbf	d0,.ca
	move.b	#ILF,(a3)+
	move.b	#ILF2,(a3)+
	clr.b	(a3)

	moveq	#1,d0
.xiipo	rts

.lloppu	tst.b	(a3)+
	bne.b	.lloppu
	subq	#1,a3
	rts
	

.allo2
** Varataan muistia tekstipuskurille
	move	d5,d0
	add	#20,d0		* 20 vararivi� varalle
	mulu	#40,d0
	move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
	bsr.w	getmem
	move.l	d0,infotaz(a5)
	rts
	



.selvis


**  Karsitaan kummat merkit pois
	move.l	infotaz(a5),a2

* sallittu alue: 33-126, 160-255
	lea	asciitable,a0
	moveq	#0,d0
	moveq	#0,d1
	move.b	#'�',d2

.clo	tst.b	(a2)
	beq.b	.nox
	move.b	(a2),d0

	cmp.b	#ILF,d0
	bne.b	.per
	cmp.b	#ILF2,1(a2)
	bne.b	.per
	move.b	#10,(a2)+
	bra.b	.nomu
.per


* charset conversion s3m, xm
* tehd��n vasta ����� rivin j�lkeen

	tst.b	d1
	bne.b	.conve

	cmp.b	d2,d0
	bne.b	.ohic
	cmp.b	1(a2),d2
	bne.b	.ohic
	st	d1

.conve
	cmp	#pt_multi,playertype(a5)
	bne.b	.ohic
	move.l	ps3m_mtype(a5),a1
	cmp	#mtS3M,(a1)
	beq.b	.con
	cmp	#mtMTM,(a1)
	beq.b	.con
	cmp	#mtXM,(a1)
	bne.b	.ohic
.con
	cmp.b	d2,d0
	beq.b	.ohic
	move.b	(a0,d0),d0		* PC -> Amiga
	move.b	d0,(a2)
.ohic

	cmp.b	#10,d0
	beq.b	.mur
	cmp.b	#33,d0
	blo.b	.mur
	cmp.b	#126,d0
	bls.b	.nomu
	cmp.b	#160,d0
	bhs.b	.nomu
.mur	move.b	#' ',(a2)
.nomu	addq	#1,a2
	bra.b	.clo
.nox


	clr	riviamount(a5)
	move.l	infotaz(a5),a0
.fii	tst.b	(a0)
	beq.b	.kii
	cmp.b	#10,(a0)+
	bne.b	.fii

	addq	#1,riviamount(a5)
	bra.b	.fii
.kii


	bsr.w	.print

	clr	sfirstname(a5)
	bsr.w	.reslider


	bra.b	.msgloop
.returnmsg
	bsr.w	.flush_messages
.msgloop	
	moveq	#0,d0			* viestisilmukka
	moveq	#0,d1
	move.l	suserport(a5),a4
	move.b	MP_SIGBIT(a4),d1	* signalibitti
	bset	d1,d0
	move.b	info_signal(a5),d1
	bset	d1,d0
	move.b	info_signal2(a5),d1
	bset	d1,d0
	lore	Exec,Wait

	move.b	info_signal(a5),d1
	btst	d1,d0
	bne.b	.sexit
	move.b	info_signal2(a5),d1
	btst	d1,d0
	beq.b	.xcxc
	bsr.w	.flush_messages
	bsr.w	.fraz
	bra.w	.reprint
.xcxc


	move.l	a4,a0
	lob	GetMsg
	tst.l	d0
	beq.b	.msgloop

	move.l	d0,a1
	move.l	im_Class(a1),d2		* luokka	
	move	im_Code(a1),d3		* koodi
	move.l	im_IAddress(a1),a2 	* gadgetin tai olion osoite
	move	im_Qualifier(a1),d4	* RAWKEY: IEQUALIFIER_?
	move	im_MouseX(a1),d5
	move	im_MouseY(a1),d6

	lob	ReplyMsg


	cmp.l	#IDCMP_RAWKEY,d2
	beq.w	.srawkeyz
	cmp.l	#IDCMP_MOUSEMOVE,d2
	beq.w	.smousemoving
	cmp.l	#IDCMP_GADGETUP,d2
	beq.w	.sgadgetsup
	cmp.l	#IDCMP_MOUSEBUTTONS,d2
	bne.b	.cxc
	cmp	#SELECTDOWN,d3			* vasen
	beq.w	.sampleplay
	cmp	#MENUDOWN,d3			* oikea
	beq.b	.sexit
.cxc	cmp.l	#IDCMP_CLOSEWINDOW,d2
	bne.w	.msgloop
	

.sexit	bsr.b	.flush_messages

	move	oldswinsiz(a5),nw_Height+swinstruc
	move	oldsgadsiz(a5),gg_Height+gAD1

	move.l	_IntuiBase(a5),a6		
	move.l	swindowbase(a5),d0
	beq.b	.uh1
	move.l	d0,a0
	move.l	4(a0),infopos2(a5)
	lob	CloseWindow
	clr.l	swindowbase(a5)
.uh1
	bsr.b	.fraz

	bsr.w	freeinfosample

	moveq	#0,d0
	rts


.fraz	move.l	infotaz(a5),a0
	cmp.l	#about_t,a0
	beq.b	.fr0z
	bsr.w	freemem
.fr0z	clr.l	infotaz(a5)
	rts


.flush_messages
	tst.l	swindowbase(a5)
	bne.b	.fmsgoop
	rts
.fmsgoop	
	move.l	(a5),a6
	move.l	suserport(a5),a0	
	lob	GetMsg
	tst.l	d0
	beq.b	.ex
	move.l	d0,a1
	lob	ReplyMsg
	bra.b	.fmsgoop
.ex	rts




.reslider
	moveq	#0,d0
	move	riviamount(a5),d0
	bne.b	.xe
	moveq	#1,d0
.xe



	moveq	#0,d1
	move	infosize(a5),d1
	beq.w	.eiup
	cmp	d1,d0		* v�h boxsize
	bhs.b	.ok
	move	d1,d0
.ok
	lsl.l	#8,d0
	bsr.w	divu_32
 	
	move.l	d0,d1
	move.l	#65535<<8,d0
	bsr.w	divu_32
	move.l	d0,d1

	lea	gAD1,a0
	move.l	gg_SpecialInfo(a0),a1
	cmp	pi_VertBody(a1),d1
	sne	d2
	lsl	#8,d2
	move	d1,pi_VertBody(a1)

	move	riviamount(a5),d1
	sub	infosize(a5),d1
	beq.b	.pp
	bpl.b	.p
.pp	moveq	#1,d1
.p	ext.l	d1

	move	sfirstname(a5),d0
	mulu	#65535,d0
	bsr.w	divu_32
	cmp	pi_VertPot(a1),d0
	sne	d2
	move	d0,pi_VertPot(a1)

;	tst	d2
;	beq.b	.eiup


	tst.b	uusikick(a5)
	beq.b	.bar

	move	gg_Height(a0),d0
	mulu	pi_VertBody(a1),d0
	divu	#$ffff,d0
	bne.b	.f
	moveq	#8,d0
.f
	cmp	#8,d0
	bhs.b	.zze
	moveq	#8,d0
.zze
	move	d0,slim2height
	subq	#2+1,d0
	move	d0,d1


	lea	slim2,a0
	lea	slim1a,a1
	move	(a1)+,(a0)+
.filf	move	(a1),(a0)+
	dbf	d0,.filf
	addq	#2,a1
	move	(a1)+,(a0)+

	move	(a1)+,(a0)+
.fil	move	(a1),(a0)+
	dbf	d1,.fil
	move	2(a1),(a0)


.bar
	lea	gAD1,a0
	move.l	swindowbase(a5),a1
	sub.l	a2,a2
	moveq	#1,d0
	lore	Intui,RefreshGList
.eiup
	rts





.srawkeyz
* yl�s: $4c
* alas: $4d
	cmp	#$45,d3		* ESC
	beq.w	.sexit

	move	infosize(a5),d0
	cmp	riviamount(a5),d0
	bhi.w	.returnmsg

	moveq	#1,d0
	and	#IEQUALIFIER_LSHIFT!IEQUALIFIER_RSHIFT,d4
	beq.b	.nsh
	move	infosize(a5),d0
	lsr	#1,d0
.nsh
	move	sfirstname(a5),d2

	cmp	#$4d,d3
	beq.b	.alaz
	cmp	#$4c,d3
	bne.w	.returnmsg

	sub	d0,sfirstname(a5)
	bpl.b	.zoo
	clr	sfirstname(a5)
	bra.b	.zoo
.alaz	
	move	sfirstname(a5),d1
	add	d0,d1
	move	riviamount(a5),d0
	sub	infosize(a5),d0
	cmp	d0,d1
	bls.b	.foop
	move	d0,d1
.foop
	move	d1,sfirstname(a5)

.zoo	
	cmp	d2,d1
	beq.w	.returnmsg	
	bsr.w	.reslider
	bsr.b	.print
	bra.w	.returnmsg



.sgadgetsup
	bra.w	.returnmsg
.smousemoving
	lea	gAD1,a2
	move.l	gg_SpecialInfo(a2),a0
	move	pi_VertPot(a0),d0
	cmp	ssliderold(a5),d0
	bne.b	.new
.q	bra.w	.returnmsg
.new	move	d0,ssliderold(a5)


	move	riviamount(a5),d1
	sub	infosize(a5),d1
	bpl.b	.ye
	moveq	#0,d1
.ye	mulu	d1,d0
	add.l	#32767,d0
	divu	#65535,d0

	cmp	sfirstname(a5),d0
	beq.b	.q
	move	d0,sfirstname(a5)

	bsr.b	.print
	bra.w	.returnmsg


.print
	tst.b	skokonaan(a5)
	beq.b	.naht
	clr.b	skokonaan(a5)

	moveq	#0,d0
.all0	moveq	#0,d1
	move	infosize(a5),d2
	bra.w	.print2

.all	move	sfirstname(a5),d0
	bra.b	.all0
	

.naht

	move	sfirstname(a5),d0
	move	sfirstname2(a5),d7
	move	d0,sfirstname2(a5)
	cmp	d0,d7
	beq.b	.xx
	sub	d0,d7
	bmi.b	.alas


.ylos	cmp	infosize(a5),d7
	bhs.b	.all


* siirrytty d7 rivi� yl�sp�in:
* kopioidaan rivit 0 -> d7 (koko: infosize-d7 r) kohtaan 0 ja printataan
* kohtaan 0 d7 kpl uusia rivej�

	moveq	#16-1,d1		* source y

	move	d7,d3
	lsl	#3,d3
	add	#16-1,d3		* dest y

	bsr.b	.copy

	move	sfirstname(a5),d0
	moveq	#0,d1
	move	d7,d2
	bra.b	.print2



.alas	neg	d7		
	cmp	infosize(a5),d7
	bhs.b	.all

* siirrytty d7 rivi� alasp�in:
* kopioidaan rivit d7 -> infosize (koko: infosize-d7 r) kohtaan 0 ja printataan
* kohtaan infosize-d7 d7 kpl uusia rivej�

	move	d7,d1
	lsl	#3,d1
	add	#16-1,d1		* source y	
	moveq	#16-1,d3		* dest y

	bsr.b	.copy

	move	sfirstname(a5),d0
	add	infosize(a5),d0
	sub	d7,d0
	move	infosize(a5),d1
	sub	d7,d1
	move	d7,d2
	bsr.b	.print2

	
.xx
	rts

** kopioidaan 

.copy	

	move	infosize(a5),d5	* y size
	sub	d7,d5
	lsl	#3,d5

	move.b	#$c0,d6		* minterm: a->d
	moveq	#31-2,d0		* source x =
	move.l	d0,d2		* dest x
	move	#39*8+4,d4	* x size
	add	windowleft(a5),d0
	add	windowtop(a5),d1
	add	windowleft(a5),d2
	add	windowtop(a5),d3
	move.l	srastport(a5),a0
	move.l	a0,a1
	move.l	_GFXBase(a5),a6
	jmp	_LVOClipBlit(a6)



* d0 = alkurivi
* d1 = eka rivi ruudulla
* d2 = printattavien rivien m��r�
.print2
	move.l	infotaz(a5),a3
	subq	#1,d0
	bmi.b	.rr
.fle	cmp.b	#10,(a3)+
	bne.b	.fle
	dbf	d0,.fle
.rr	cmp.b	#10,-1(a3)	
	bne.b	.ra
	addq	#1,a3		* skip ILF2
.ra

	move	d1,d7
	lsl	#3,d7
	add	#22-1,d7
	
	move	d2,d6
	subq	#1,d6		* ???

.lorp
	lea	-50(sp),sp
	move.l	sp,a0
	move.l	a0,a1

	move.l	a1,d0

.lorp2	move.b	(a3)+,(a1)+
	beq.b	.xp
	
	cmp.b	#10,-1(a1)
	bne.b	.lorp2
	clr.b	-1(a1)	
	addq	#1,a3		* skipataan ILF2
.xp	subq	#1,a1

	move.l	a1,d1
	sub.l	d0,d1
	moveq	#39,d0
	sub	d1,d0
	subq	#1,d0
	bmi.b	.xo
.pe	move.b	#' ',(a1)+
	dbf	d0,.pe
	clr.b	(a1)
.xo

;	cmp.l	#"----",(a0)
;	bne.b	.xq
;	bsr.b	.palk
;	bra.b	.xw
;.xq

	moveq	#35-2,d0
	move	d7,d1
	bsr.w	sprint

.xw	addq	#8,d7
	lea	50(sp),sp
	tst.b	-1(a3)
	beq.b	.xip

	dbf	d6,.lorp
.xip
	rts
	

* x = 35
* y = d7
* x size = 39*8
* y size = 8
;.palk
;	pushm	all
;	tst.b	uusikick(a5)		* uusi kick?
;	beq.b	.oz

;	push	d7

;	move	d7,ply1
;	subq	#6,ply1
;	moveq	#7,ply2
;	moveq	#35,plx1
;	move.l	#39*8-2,plx2
;	add.l	plx1,plx2
;	add.l	ply1,ply2
;	bsr	.1

;	pop	d7
	
;	move.l	srastport(a5),a2
;	moveq	#35+1,d0
;	subq	#5,d7
;	move	d7,d1
;	move	#39*8+35-3,d2
;	moveq	#5,d3
;	add	d7,d3
;	bsr.w	drawtexture

;.oz	popm	all
;	rts


****** PT sample play

.sampleplay
	sub	windowleft(a5),d5
	sub	windowtop(a5),d6	* suhteutus fonttiin

	cmp	#31,d5
	blo.w	.msgloop
	cmp	#345,d5
	bhi.w	.msgloop
	cmp	#14,d6
	blo.w	.msgloop
	move	infosize(a5),d0
	lsl	#3,d0
	add	#14,d0
	cmp	d0,d6
	bhi.w	.msgloop

	tst.b	ahi_muutpois(a5)
	bne.w	.msgloop

	cmp	#pt_prot,playertype(a5)
	bne.w	.msgloop
	tst	playingmodule(a5)
	bmi.w	.msgloop


* d5/d6 = mouse x/y

	move	d6,d0
	sub	#14+1,d0
	lsr	#3,d0
	add	sfirstname(a5),d0
	subq	#1,d0
	bmi.w	.msgloop

	move.l	infotaz(a5),a0
.ff	cmp.b	#10,(a0)+
	bne.b	.ff
	dbf	d0,.ff

	addq	#1,a0
	cmp.b	#' ',2(a0)
	bne.w	.msgloop

	move.b	(a0)+,d0
	cmp.b	#'0',d0
	blo.w	.msgloop
	cmp.b	#'3',d0
	bhi.w	.msgloop
	and	#$f,d0
	mulu	#10,d0
	move.b	(a0)+,d1
	and	#$f,d1
	add	d1,d0		* d0 = samplenum

	cmp	#$1f,d0
	bhi.w	.msgloop

	move	d0,d7
	subq	#1,d7
	bmi.w	.msgloop
	


	move.l	moduleaddress(a5),a1	* onko chipiss�?
	lore	Exec,TypeOfMem
	btst	#MEMB_CHIP,d0
	beq.w	.msgloop



	move.l	moduleaddress(a5),a1

	lea	952(a1),a0		* tutkitaan patternien m��r�
	moveq	#128-1,d0
	moveq	#0,d1
.k_lop1
	move.b	(a0)+,d2
	cmp.b	d2,d1
	bhi.b	.k_lop2
	move.b	d2,d1
.k_lop2	dbf	d0,.k_lop1
	addq	#1,d1
	mulu	#1024,d1		* Eka sample patternien j�lkeen
	lea	1084(a1),a0
	add.l	d1,a0


	move	d7,d0
	moveq	#0,d1

.l	add.l	d1,a0
	moveq	#0,d1
	move	42(a1),d1	* len
	add.l	d1,d1
	moveq	#0,d2
	move	46(a1),d2	* repeat point
	add.l	d2,d2
	add.l	a0,d2
	move	48(a1),d3	* repeat len
	bne.b	.lw
	moveq	#1,d3
.lw

	lea	30(a1),a1
	dbf	d0,.l

	tst	d1
	beq.w	.msgloop





* a0 = sampleaddr
* d1 = samplelen
* d2 = repeat point
* d3 = repeat len


;	push	d5

*** Onko sample fastissa?
;	bsr	freeinfosample

;	move.l	d1,d6

;	sub.l	a0,d2
	

; ei taida toimia koska lev4 interruptit sotkevat

;	lea	foosample,a1
;	move.l	a1,a2
;.lrr	move.b	(a0)+,(a1)+
;	subq.l	#1,d6
;	bne.b	.lrr

;	move.l	a2,a0
;	add.l	a0,d2	

;	move.l	a0,d5
;	move.l	d1,d6

;	move.l	a0,a1
;	lore	Exec,TypeOfMem
;	btst	#MEMB_CHIP,d0
;	bne.b	.okc

;	move.l	d6,d0
;	moveq	#MEMF_CHIP,d1
;	bsr	getmem

;	sub.l	d5,d2
;	add.l	d0,d2

;	move.l	d5,a0
;	move.l	d0,d5
;	move.l	d0,a1
;	move.l	d6,d0
;	lob	CopyMem

;	move.l	d5,infosample(a5)

;	move.l	#nullsample,d2
;	moveq	#1,d3

.okc
;	move.l	d5,a0
;	move.l	d6,d1

;****
;	pop	d5


	tst.b	playing(a5)
	beq.b	.s1
	pushm	all
	bsr.w	stopcont		* pausetaan
	popm	all
.s1




	lea	$dff096,a3

	move	#$f,(a3)
	move.l	a0,$a0-$96(a3)
	move.l	a0,$b0-$96(a3)
	move.l	a0,$c0-$96(a3)
	move.l	a0,$d0-$96(a3)
	move	mainvolume(a5),d0
	lsr	#1,d0
	move	d0,$a8-$96(a3)
	move	d0,$b8-$96(a3)
	move	d0,$c8-$96(a3)
	move	d0,$d8-$96(a3)

	lsr.l	#1,d1
	move	d1,$a4-$96(a3)
	move	d1,$b4-$96(a3)
	move	d1,$c4-$96(a3)
	move	d1,$d4-$96(a3)

** perioidi mousen x-koordinaatista
	sub	#31,d5			* d5 = 0-315
	mulu	#36,d5
	divu	#315,d5
	add	d5,d5
	move	.periods(pc,d5),d5

	move	d5,$a6-$96(a3)
	move	d5,$b6-$96(a3)
	move	d5,$c6-$96(a3)
	move	d5,$d6-$96(a3)

	lore	GFX,WaitTOF
	move	#$800f,(a3)
	lob	WaitTOF

	move.l	d2,$a0-$96(a3)
	move.l	d2,$b0-$96(a3)
	move.l	d2,$c0-$96(a3)
	move.l	d2,$d0-$96(a3)
	move	d3,$a4-$96(a3)
	move	d3,$b4-$96(a3)
	move	d3,$c4-$96(a3)
	move	d3,$d4-$96(a3)

	bra.w	.msgloop

.periods
	dc	856,808,762,720,678,640,604,570,538,508,480,453
	dc	428,404,381,360,339,320,302,285,269,254,240,226
	dc	214,202,190,180,170,160,151,143,135,127,120,113


freeinfosample
	tst.l	infosample(a5)
	beq.b	.x
	pushm	all
	move.l	infosample(a5),a0
	clr.l	infosample(a5)
	bsr.w	freemem
	popm	all
.x	rts


****************************************************************
* About
**


rbutton10
	movem.l	d0-a6,-(sp)

* lasketaan dividereitten m��r�
	moveq	#0,d5
	lea	listheader(a5),a4
.l	TSTNODE	a4,a3
	beq.b	.e
	move.l	a3,a4
	cmp.b	#'�',l_filename(a3)	* onko divideri??
	bne.b	.l
	addq	#1,d5
	bra.b	.l
.e	move	d5,divideramount(a5)

	st	infolag(a5)

	tst	info_prosessi(a5)
	beq.b	.z

	move.l	infotaz(a5),a0		* jos oli jo aboutti niin suljetaan
	cmp.l	#about_t,a0
	bne.b	.rr
	bsr.w	sulje_info
	bra.b	.x
.rr
	bsr.w	start_info
	bra.b	.x

.z	bsr.w	rbutton10b

.x	movem.l	(sp)+,d0-a6
	rts







*******************************************************************************
* (error) Requesteri
*******
* a1 = teksti

request
	movem.l	d0-a6,-(sp)
	sub.l	a4,a4
request2
	lea	.ok_g(pc),a2
	bsr.b	rawrequest
	movem.l	(sp)+,d0-a6
	tst.l	d0
	rts

.ok_g	dc.b	"OK",0
 even

areyousure_delete
	movem.l	d1-a6,-(sp)
	sub.l	a4,a4
	lea	.z(pc),a1
	lea	.y(pc),a2
	lea	infodefresponse(pc),a4
	move.l	(a4),d7
	clr.l	(a4)
	bsr.b	rawrequest
	move.l	d7,(a4)
	movem.l	(sp)+,d1-a6
	tst.l	d0
	rts

.z	dc.b	"Delete this file?",0
.y	dc.b	"_Yes|_No",0
 even

rawrequest
	jsr	get_rt
	movem.l	a0-a4,-(sp)
	moveq	#RT_REQINFO,D0
	sub.l	a0,a0
;	move.l	_ReqBase+var_b,a6		* ???
	lob	rtAllocRequestA
	move.l	d0,d7
	movem.l	(sp)+,a0-a4
	tst.l	d0
	beq.b	.w
	move.l	d7,a3
	lea	inforeqtags0(pc),a0
	bsr.w	pon1
	lob	rtEZRequestA
	bsr.w	poff1
	move.l	d0,-(sp)
	move.l	d7,a1
	lob	rtFreeRequest
	move.l	(sp)+,d0
	tst.l	d0
.w	rts





inforeqtags0
	dc.l	RTEZ_Flags,EZREQF_CENTERTEXT
	dc.l	RTEZ_ReqTitle,reqtitle

	dc.l	RTEZ_DefaultResponse,1
infodefresponse	=	*-4

	dc.l	RT_Underscore,"_"
	dc.l	RT_TextAttr,text_attr
otag8	dc.l	RT_PubScrName,pubscreen+var_b
	dc.l	TAG_END


init_error
	neg	d0
	add	d0,d0
	lea	.ertab-2(pc,d0),a1
	add	(a1),a1
	bsr.w	request

* vapautetaan moduuli
	bsr.w	freemodule
* printataan infoa
	bra.w	inforivit_initerror


.ertab	dr	ier_error_t
	dr	ier_nochannels_t
	dr	ier_nociaints_t
	dr	ier_noaudints_t
	dr	ier_nomedplayerlib_t
	dr	ier_nomedplayerlib2_t
	dr	ier_mederr_t
	dr	ier_playererr_t
	dr	memerror_t
	dr	ier_nosid_t
	dr	ier_sidicon_t
	dr	ier_sidinit_t
	dr	ier_nopr_t
	dr	nochip_t
	dr	unknown_t
	dr	grouperror_t
	dr	filerr_t
	dr	hardware_t
	dr	ahi_t
	dr	ier_nomled_t
	dr	ier_mlederr_t

ier_error	=	-1
ier_nochannels	=	-2
ier_nociaints	=	-3
ier_noaudints	=	-4
ier_nomedplayerlib =	-5
ier_nomedplayerlib2 =	-6
ier_mederr	=	-7
ier_playererr	=	-8
ier_nomem	=	-9
ier_nosid	=	-10
ier_sidicon	=	-11
ier_sidinit	=	-12
ier_noprocess	=	-13
ier_nochip	=	-14
ier_unknown	=	-15
ier_grouperror	=	-16
ier_filerr	=	-17
ier_hardware	=	-18
ier_ahi		=	-19
ier_nomled	=	-20
ier_mlederr	=	-21

;hardware_t
ier_playererr_t
ier_error_t
	dc.b	"Init error!?",0
ier_nochannels_t
	dc.b	"Couldn't allocate audio channels!",0
ier_nociaints_t
	dc.b	"Couldn't allocate CIA timer(s)!",0
ier_noaudints_t
	dc.b	"Couldn't allocate audio interrupts!",0
ier_nomedplayerlib_t
ier_nomedplayerlib2_t
 dc.b	"Couldn't open medplayer, octaplayer or octamixplayer.library!",0
	
ier_mederr_t
ier_sidinit_t
	dc.b	"Couldn't allocate audio channels or CIA interrupts!",0
ier_nosid_t
	dc.b	"Couldn't open playsid.library!",0
ier_sidicon_t
	dc.b	"Trouble with SID icon!",0
ier_nomled_t
	dc.b	"Couldn't open mled.library!",0
ier_mlederr_t
	dc.b	"MusiclineEditor init error!",0
ier_nopr_t
	dc.b	"Couldn't create process!",0
nochip_t dc.b	"Not enough chip memory!",0
filerr_t	dc.b	"File error!",0
hardware_t	dc.b "68020 or better required!",0
ahi_t	dc.b	"AHI device error!",0

 even


 ifne EFEKTI
efekti
	tst.b	win(a5)		* onko ikkunaa?
	beq.b	.r
	tst.b	kokolippu(a5)	* ikkuna pieni?
	beq.b	.r

	moveq	#.sine-.sin-1,d7
	lea	.sin(pc),a3
.loop
	lore	GFX,WaitTOF
	lob	WaitTOF
	
	lea	slider1,a0
;	move	#65535,d1		* 65535*arvo/max
	moveq	#-1,d1
	moveq	#0,d0
	move.b	(a3)+,d0
	bmi.b	.sk
	mulu	d0,d1
	lsr.l	#6,d1			* uusi HorizPot

	move.l	gg_SpecialInfo(a0),a1
	move	pi_Flags(a1),d0
	move	pi_HorizBody(a1),d3
	moveq	#0,d2
	moveq	#0,d4
	move.l	windowbase(a5),a1
	sub.l	a2,a2
	moveq	#1,d5
	lore	Intui,NewModifyProp


.sk	dbf	d7,.loop
.r
	rts

.sin
	DC.b	0,-1,3,6,$B,$11,$17,$1D,$24
	DC.b	$2A,$30,$36,$3B,$40

	dc.b	$3C,$38,$36
	DC.b	$34,$33,$32,$31,$32,-1,$33,$34
	DC.b	$35,$37,$38,$39,$3B,$3C,$3D,$3F
	DC.b	$40

	dc.b	$3F,$3E,$3D,-1,-1,$3C,-1
	DC.b	-1,$3D,-1,-1,-1,$3E,-1,-1
	DC.b	-1,$3F,$40
.sine

 even

  endc
  
*******************************************************************************
* Keskeytykset
*******

_ciaa	=	$bfe001
_ciab	=	$bfd000

cianame	dc.b	"ciaa.resource",0
 even


 
init_ciaint
	tst.b	ciasaatu(a5)
	bne.b	.hm
.c	moveq	#0,d0
	rts

.hm	clr.b	vbtimeruse(a5)		* k�ytet��n ciaa
	tst.b	vbtimer(a5)		* onko vblank k�yt�ss�?
	beq.b	.ci
	st	vbtimeruse(a5)		* k�ytet��n vblankia
	bra.b	.c
.ci
	pushm	d1-a6

	move	#28419/2,timerhi(a5)

** CIAA
	lea	_ciaa,a3
	lea	ciaserver(pc),a4
	moveq	#0,d6			* timer a
	move.l	ciabasea(a5),d0
	beq.b	.noa
	move.l	d0,a6
	lea	(a4),a1
	move.l	d6,d0
	lob	AddICRVector
	tst.l	d0
	beq.b	.gottimer		* Saatiinko?

	lea	(a4),a1
	moveq	#1,d6			* timer b
	move.l	d6,d0
	lob	AddICRVector
	tst.l	d0
	beq.b	.gottimer
.noa
** CIAB
	lea	_ciab,a3
	lea	ciaserver(pc),a4
	moveq	#0,d6			* timer a
	move.l	ciabaseb(a5),d0
	beq.b	.nob
	move.l	d0,a6
	lea	(a4),a1
	move.l	d6,d0
	lob	AddICRVector
	tst.l	d0
	beq.b	.gottimer		* Saatiinko?

	lea	(a4),a1
	moveq	#1,d6			* timer b
	move.l	d6,d0
	lob	AddICRVector
	tst.l	d0
	beq.b	.gottimer
.nob
	popm	d1-a6
	moveq	#-1,d0			* ERROR! Ei saatu varattua timeri�.
	rts

.gottimer
	move.l	a3,ciaddr(a5)
	move.l	a6,ciabase(a5)
	move.b	d6,whichtimer(a5)	* 0: timer a, 1:timer b

	lea	ciatalo(a3),a2
	tst.b	d6
	beq.b	.timera
	lea	ciatblo(a3),a2
.timera	move.b	timerlo(a5),(a2)
	move.b	timerhi(a5),$100(a2)

	lea	ciacra(a3),a2
	tst.b	d6
	beq.b	.tima
	lea	ciacrb(a3),a2
.tima
	clr.b	ciasaatu(a5)		* saatiin keskeytys

	move.b	#%00010001,(a2)		* Continuous, force load
	popm	d1-a6
	moveq	#0,d0
	rts



rem_ciaint
	tst.b	ciasaatu(a5)
	beq.b	.hm
	rts

.hm	pushm	all
	move.l	ciaddr(a5),a3

	moveq	#0,d0
	move.b	whichtimer(a5),d0	* RemICRVector
	bne.b	.b
	move.b	#%00000000,ciacra(a3)
	bra.b	.a
.b	move.b	#%00000000,ciacrb(a3)
.a
	move.l	ciabase(a5),a6
	lea	ciaserver(pc),a1
	lob	RemICRVector

	st	ciasaatu(a5)		* ei keskeytyst�!
	popm	all
	rts



*** VBlank keskeytys

intserver
	dc.l	0,0
	dc.b	2
	dc.b	0	* prioriteetti
	dc.l	.intname
	dc.l	var_b		* is_Data
	dc.l	.vbinterrupt


.intname dc.b	"HiP-VBlank",0
 even

.vbinterrupt
;	movem.l	d2-d7/a0/a2-a4/a6,-(sp)
	pushm	d2-d7/a2-a6
	move.l	a1,a5			* a1 = is_Data = var_b

	tst.b	playing(a5)
	beq.b	.huh
;	beq	.eee


*** Kutsutaan soittorutinin cia-rutiinia jos ajastus on vblankilla
	push	a5
	tst.b	vbtimeruse(a5)
	beq.b	.novb
	move.l	playerbase(a5),a0
	jsr	p_ciaroutine(a0)
	move.l	(sp),a5
.novb
*** Kutsutaan soittorutinin vb-rutiinia

	move.l	playerbase(a5),a0
	jsr	p_vblankroutine(a0)
	pop	a5

	bsr.w	scopeinterrupt


*** Asetetaan filtteri
	move.b	filterstatus(a5),d0
	bne.b	.oop
	btst	#1,$bfe001
	sne	modulefilterstate(a5)
	bra.b	.uup
.oop	subq.b	#1,d0
	bne.b	.eep
.peep	bset	#1,$bfe001
	bra.b	.uup
.eep	bclr	#1,$bfe001
.uup
		



	tst.b	songover(a5)
	beq.b	.huh
.umb	clr.b	songover(a5)
* Jos kappale on soinut l�pi, l�hetet��n signaali Wait()ille.
	tst	loading(a5)	* ei songenddi� jos lataus kesken
	bne.b	.huh
	move.b	ownsignal1(a5),d1
	bsr.w	signalit

.huh
	tst.b	playing(a5)
	beq.b	.eee


	move	pos_nykyinen(a5),d0	* onko position muuttunut?
	move	positionmuutos(a5),d1
	cmp	d1,d0
	beq.b	.eee
	move	d0,positionmuutos(a5)

	tst.b	kelattiintaakse(a5)	* taaksep�inkelauksesta ei vaikutusta
	beq.b	.jeh
	clr.b	kelattiintaakse(a5)
	bra.b	.pee
.jeh

	sub	d1,d0
	bmi.b	.umb
.pee
	move.b	ownsignal2(a5),d1
	bsr.w	signalit
.eee


* Soitto p��ll�: p�ivityspyynt� joka 10/50 sekuntti
* Ei soittoa: joka 50/50 sekuntti.

	moveq	#0,d0
	move	vertfreq(a5),d0
	tst.b	playing(a5)
	beq.b	.npl
	divu	#3,d0
.npl


;	moveq	#50,d0
;	tst.b	playing(a5)
;	beq.b	.npl
;	moveq	#10,d0
;.npl
	addq	#1,ticktack(a5)		* signaaloidaan p�ivityspyynt�
	cmp	ticktack(a5),d0
	bhi.b	.nope
	clr	ticktack(a5)
	move.b	ownsignal3(a5),d1
	bsr.w	signalit
.nope


	tst.b	playing(a5)	
	beq.w	.eirr
	tst.b	vbtimeruse(a5)
	bne.b	.eir

	move.l	playerbase(a5),a0	* Kelaus CIA-ajastimella
	move	p_liput(a0),d0
	btst	#pb_ciakelaus,d0
	bne.b	.joog
	btst	#pb_ciakelaus2,d0
	beq.b	.eir

	cmp	#pt_prot,playertype(a5)		* ProTracker??
	bne.b	.joog
	lea	kplbase(a5),a0
	move	k_timerhi(a0),d0
	move.b	k_whichtimer(a0),d1
	tst.b	kelausnappi(a5)
	beq.b	.bb
	lsr	#1,d0
.bb	move.l	k_cia(a0),a0
	lea	ciatalo(a0),a0
	tst.b	d1
	beq.b	.aap
	lea	$200(a0),a0
.aap	bra.b	.aa


.joog
	move	timerhi(a5),d0
	tst.b	kelausnappi(a5)		* onko painettu kelausnappia?
	beq.b	.kel
	move.b	kelausvauhti(a5),d1
	lsr	d1,d0
.kel
	move.l	ciaddr(a5),a0
	lea	ciatalo(a0),a0
	tst.b	whichtimer(a5)
	beq.b	.aa
	lea	$200(a0),a0
.aa
	move.b	d0,(a0)
	ror	#8,d0
	move.b	d0,$100(a0)
.eir



*** Sys�t��n kamaa porttiin
	move.b	mainvolume+1(a5),hippoport+hip_mainvolume(a5)
	move.b	playertype+1(a5),hippoport+hip_playertype(a5)

	cmp	#pt_multi,playertype(a5)
	bne.b	.por

	move.l	ps3m_buff1(a5),a0
	move.l	(a0),hippoport+hip_ps3mleft(a5)
	move.l	ps3m_buff2(a5),a0
	move.l	(a0),hippoport+hip_ps3mright(a5)
	move.l	ps3m_playpos(a5),a0
	move.l	(a0),d0
	lsr.l	#8,d0
	move.l	d0,hippoport+hip_ps3moffs(a5)
	move.l	ps3m_buffSizeMask(a5),a0
	move.l	(a0),hippoport+hip_ps3mmaxoffs(a5)

.por

.nop

.eirr
	move.b	playing(a5),hippoport+hip_play(a5)

;	popm	d1-a6
;	movem.l	(sp)+,d2-d7/a0/a2-a4
	popm	d2-d7/a2-a6
	moveq	#0,d0
	rts




* d1 = p��taskille l�hetett�v� signaali
signalit
	move.l	owntask+var_b,a1
	moveq	#0,d0
	bset	d1,d0
	move.l	4.w,a6			
	jmp	_LVOSignal(a6)


dummyserver
	dc.l	0,0
	dc.b	2,0
	dc.l	0
	dc.l	0
	dc.l	0


ciaserver
	dc.l	0,0
	dc.b	2
	dc.b	0	* prioriteetti
	dc.l	intname2
	dc.l	softserver		* is_Data
	dc.l	ciainterrupt

intname2 dc.b	"HiP-CIA",0
 even

;ciainterrupt			 * Potkaistaan SOFTINT liikkeelle.
;	lob	Cause
;dummyr	moveq	#0,d0
;	rts


* cdtv-yhteensopiva

ciainterrupt			 * Potkaistaan SOFTINT liikkeelle.
	push	a6
;	move.l	4.w,a6
	move.l	exeksi(pc),a6
	lob	Cause
	pop	a6
dummyr	moveq	#0,d0
	rts


exeksi	dc.l	0

softserver
	dc.l	0,0
	dc.b	2
	dc.b	0	* prioriteetti
	dc.l	0
	dc.l	var_b		* is_Data
	dc.l	softint

softint	
	tst.b	playing(a1)
	beq.b	.huh
	pushm	d2-d7/a0/a2-a4/a6
	move.l	a1,a5
	move.l	playerbase(a5),a0	* Kutsutaan CIA soittorutiinia
					* jos se on ei-AHI rutiini tai
					* AHI ei ole p��ll�
	tst.b	ahi_use_nyt(a5)
	beq.b	.eiahi
	
	move	p_liput(a0),d0
;	btst	#pb_ahi,d0
	and	#pf_ahi,d0
	bne.b	.aa
.eiahi
	jsr	p_play(a0)
.aa	popm	d2-d7/a0/a2-a4/a6
.huh	moveq	#0,d0
	rts


*******************************************************************************
* Scoperutiinit
*******

* K�ynnistys

start_quad
	st	scopeflag(a5)
start_quad2
;	bra	quad_code

	move.l	a6,-(sp)
	move.l	_DosBase(a5),a6
	pushpea	.prn(pc),d1
	moveq	#0,d2			* pri
	move.l	#quad_segment,d3
	lsr.l	#2,d3
	move.l	#3000,d4
	lob	CreateProc
	tst.l	d0
	beq.b	.error
	addq	#1,quad_prosessi(a5)

	bsr.w	updateprefs

.error	move.l	(sp)+,a6
	rts

.prn	dc.b	"HiP-Scope",0
 even
 
* Sammutus

sulje_quad
	clr.b	scopeflag(a5)
sulje_quad2
	push	a6
	tst	quad_prosessi(a5)
	beq.b	.tt	

	move.l	quad_task(a5),a1
	moveq	#0,d0
	lore	Exec,SetTaskPri
	st	tapa_quad(a5)		* lippu: poistu!
.t	tst	quad_prosessi(a5)	* odotellaan
	beq.b	.tt
	jsr	dela
	bra.b	.t
.tt	clr.b	tapa_quad(a5)
	pop	a6
	rts




******************************************************************************
*
* ARexx-toiminnot
*
******************************************************************************

rexxmessage
	pushm	all

	lea	rexxport(a5),a0
	lore	Exec,GetMsg
	move.l	d0,rexxmsg(a5)
	beq.b	.nomsg

	move.l	rexxmsg(a5),a1
	clr.l	rm_Result1(a5)
	clr.l	rm_Result2(a5)
	clr.l	rexxresult(a5)

	lea	rm_Args(a1),a4
	tst.l	(a4)
	beq.b	.end
	lea	.komennot-4(pc),a3
.loop	addq.l	#4,a3
	tst	(a3)
	beq.b	.end
	move.l	a3,a2
	add	(a2),a2
	move.l	a2,a0
	lore	Rexx,Strlen
	move.l	d0,d3
	move.l	a2,a0
	move.l	(a4),a1
	lob	StrcmpN
	tst.l	d0
	bne.b	.loop
	move.l	(a4),a1
	add.l	d3,a1
	cmp.b	#' ',(a1)+	* Onko komennon j�lkeen SPACE?
	seq	d0		* Lippu p��lle jos on.
	move.l	a3,a0
	addq	#2,a0
	add	(a0),a0
	pushm	all
	jsr	(a0)
	popm	all
.end

	move.l	rexxmsg(a5),a1
	move.l	rexxresult(a5),rm_Result2(a1)
	lore	Exec,ReplyMsg
.nomsg
	popm	all
	jmp	returnmsg

.komennot
	dr	.playt,.playr
	dr	.cleart,clearlist
	dr	.contt,rbutton2
	dr	.stopt,rbutton3
	dr	.ejectt,rbutton4
	dr	.lprgt,.loadprg
	dr	.addt,.add
	dr	.delt,rbutton8
	dr	.volt,.volume
	dr	.rewt,rbutton_kela1
	dr	.ffwdt,rbutton_kela2
	dr	.movet,.move
	dr	.sortt,rsort
	dr	.insertt,.insert
	dr	.quitt,.quit
	dr	.chooset,.choose
	dr	.psongt,.playsong
	dr	.gett,.get
	dr	.randt,.playrand
	dr	.hidet,.hide
	dr	.sizet,.size
	dr	.pbsct,.setpubscreen
	dr	.toutt,.timeout
	dr	.ps3m1,.ps3mmode
	dr	.ps3m2,.ps3mboost
	dr	.ps3m3,.ps3mrate
	dr	.loadp,.loadprefs
	dr	.sampt,rbutton10b
	dc	0

.playt	dc.b	"PLAY",0
.cleart	dc.b	"CLEAR",0
.contt	dc.b	"CONT",0
.stopt	dc.b	"STOP",0
.ejectt	dc.b	"EJECT",0
.lprgt	dc.b	"LOADPRG",0
.addt	dc.b	"ADD",0
.delt	dc.b	"DEL",0
.volt	dc.b	"VOLUME",0
.rewt	dc.b	"REW",0
.ffwdt	dc.b	"FFWD",0
.movet	dc.b	"MOVE",0
.sortt	dc.b	"SORT",0
.insertt dc.b	"INSERT",0
.quitt	dc.b	"QUIT",0
.chooset dc.b	"CHOOSE",0
.psongt	dc.b	"SONGPLAY",0
.gett	dc.b	"GET",0
.randt	dc.b	"RANDPLAY",0
.hidet	dc.b	"HIDE",0
.sizet	dc.b	"ZIP",0
.pbsct	dc.b	"PUBSCREEN",0
.toutt	dc.b	"TIMEOUT",0
.ps3m1	dc.b	"PS3MMODE",0
.ps3m2	dc.b	"PS3MBOOST",0
.ps3m3	dc.b	"PS3MRATE",0
.loadp	dc.b	"LOADPREFS",0
.sampt	dc.b	"SAMPLES",0
 even


*** PLAY
.playr	
	tst.b	d0
	beq.w	rbutton1
	move.l	a1,sv_argvArray+4(a5)
	clr.l	sv_argvArray+8(a5)
	bsr.w	clearlist
	bra.w	komentojono

*** LOADPRG
.loadprg
	tst.b	d0
	beq.w	rloadprog
	move.l	a1,d7
	bra.w	rloadprog2

*** QUIT
.quit	st	exitmainprogram(a5)
.exit	rts


*** ADD	
.add	tst.b	d0
	beq.w	rbutton7

.add2	cmp	#$3fff,modamount(a5)	* Ei enemp�� kuin ~16000
	bhs.b	.exit

	move.l	a1,a2
.fe	tst.b	(a2)+
	bne.b	.fe
	sub.l	a1,a2
	add	#l_size,a2
	move.l	a2,d0			* nimen pituus

	move.l	#MEMF_CLEAR,d1		* varataan muistia
	bsr.w	getmem
	beq.b	.exit
	move.l	d0,a3

	lea	l_filename(a3),a2
	move.l	a2,a0
.cp1	move.b	(a1)+,(a2)+
	bne.b	.cp1

	move.l	a0,a1
	move.l	a2,a0
	bsr.w	nimenalku
	move.l	a0,l_nameaddr(a3)	* pelk�n nimen osoite

	bsr.w	addfile
	bsr.w	clear_random
	st	hippoonbox(a5)
	tst	chosenmodule(a5)
	bpl.b	.ee
	clr	chosenmodule(a5)	* moduuliksi eka jos ei ennest��n
.ee	bra.w	resh



*** INSERT
.insert
	tst.b	d0
	beq.w	rinsert
	bsr.w	rinsert2
	bsr.b	.add2
	clr.b	filereqmode(a5)
	rts


*** MOVE
.move
	bsr.w	a2i
	move	d0,-(sp)
	bsr.w	rmove
	move	(sp)+,d0
	subq	#1,d0
	bsr.b	.choo
	bra.w	rmove	


*** CHOOSE
.choose
	bsr.w	a2i
	subq	#1,d0
	bsr.b	.choo
	bra.w	resh

*** valitaan d0:ssa olevan numeron tiedosto
.choo	move	d0,chosenmodule(a5)
	cmp	modamount(a5),d0
	blo.b	.em
	move	modamount(a5),chosenmodule(a5)
	subq	#1,chosenmodule(a5)
.em	rts

*** VOLUME
.volume
	bsr.w	a2i
	bra.w	volumerefresh


*** PLAYSONG
.playsong
	bsr.w	a2i
	subq	#1,d0
	move	d0,songnumber(a5)
	moveq	#0,d1
	bra.w	songo
	
	

*** PLAYRAND
.playrand
	bra.w	soitamodi_random
	

*** HIDE
.hide
	bsr.w	a2i		* d0 = 0 tai 1
	tst.b	d0
	beq.b	.hide_hide
	tst.b	win(a5)
	beq.b	.hide1
	rts
.hide_hide
	tst.b	win(a5)
	bne.b	.hide1
	rts
.hide1	move	#$25,rawkeyinput(a5)
.hide2
	move.b	ownsignal7(a5),d1
	bra.w	signalit


*** SIZE

;	move.l	windowbase(a5),a0	* Kick2.0+
;	lore	Intui,ZipWindow
	
.size
	bsr.w	a2i
	tst.b	d0
	beq.b	.size_small
	tst.b	kokolippu(a5)
	beq.b	.size1
	rts
.size_small
	tst.b	kokolippu(a5)
	bne.b	.size1
	rts
.size1	
	tst.b	uusikick(a5)
	beq.b	.oldk
	move.l	windowbase(a5),a0	* Kick2.0+
;	lore	Intui,ZipWindow
	move.l	_IntuiBase(a5),a6
	jmp	_LVOZipWindow(a6)

.oldk	jsr	sulje_ikkuna		* kick1.2+
;	bra.w	avaa_ikkuna
	jmp	avaa_ikkuna


*** PUBSCREEN
.setpubscreen
	tst.b	uusikick(a5)
	bne.b	.nwkd
	rts

.nwkd	bsr.b	.prefspo
	lea	pubscreen(a5),a0
.c123	move.b	(a1)+,(a0)+
	bne.b	.c123
	st	newpubscreen(a5)
	move.b	ownsignal2(a5),d1
	bra.w	signalit

*** TIMEOUT
.timeout
	bsr.b	.prefspo
	bsr.w	a2i
	cmp	#600,d0
	bls.b	.ok32
	move	#600,d0
.ok32	move	d0,timeout(a5)
	bra.w	sliderit

*** PS3M
.ps3mmode
	bsr.b	.prefspo
	bsr.w	a2i
	move.b	d0,s3mmode2(a5)
	rts

.ps3mboost
	bsr.b	.prefspo
	bsr.w	a2i
	cmp.b	#8,d0
	bls.b	.ok12
	moveq	#8,d0
.ok12	move.b	d0,s3mmode3(a5)
	bra.w	sliderit

.ps3mrate
	bsr.b	.prefspo
	bsr.w	a2i
	cmp.l	#5000,d0
	bhs.b	.ok55
	move.l	#5000,d0
.ok55	cmp.l	#58000,d0
	bls.b	.ok76
	move.l	#58000,d0
.ok76	move.l	d0,mixirate(a5)
	bra.w	sliderit

.prefspo
	push	a1
	bsr.w	sulje_prefs
	pop	a1
	rts



**** LOADPREFS
.loadprefs
	push	a1
	bsr.w	rbutton4		* eject
	bsr.w	clearlist
	bsr.w	sulje_quad
	bsr.b	.prefspo
	jsr	sulje_ikkuna
	jsr	rem_inputhandler
	pop	d7
	bsr.w	loadprefs2
	jsr	setboxy
	jsr	init_inputhandler
	tst.b	quadon(a5)			* avataanko scope?
	beq.b	.q
	bsr.w	start_quad
.q	not.b	kokolippu(a5)
	jmp	avaa_ikkuna


* GET:
* 	current song
* 	chosenmodule
*	subsongs
*	play on/off
*	num files
*	current songpos
*	max songpos
*	playingmodule
*	modulename
*	moduletype
*	duration
*	hide status


.get	move.b	(a1)+,d0
	lsl.l	#8,d0
	move.b	(a1)+,d0
	lsl.l	#8,d0
	move.b	(a1)+,d0
	lsl.l	#8,d0
	move.b	(a1)+,d0

	lea	.getlist-2(pC),a1
.getloop
	addq.l	#2,a1
	tst.l	(a1)
	beq.b	.getx
	cmp.l	(a1)+,d0
	bne.b	.getloop
	add	(a1),a1
	jsr	(a1)
.getx	rts

.getlist
	dc.l	"PLAY"
	dr	.getplay
	dc.l	"CFIL"
	dr	.getcfil
	dc.l	"NFIL"
	dr	.getnfil
	dc.l	"CSNG"
	dr	.getcsng
	dc.l	"NSNG"
	dr	.getnsng
	dc.l	"CSPO"
	dr	.getcspo
	dc.l	"MSPO"
	dr	.getmspo
	dc.l	"CURR"
	dr	.getcurrent
	dc.l	"NAME"
	dr	.getname
	dc.l	"TYPE"
	dr	.gettype
	dc.l	"CNAM"
	dr	.currname
	dc.l	"FNAM"
	dr	.fullname
	dc.l	"COMM"
	dr	.getcomment
	dc.l	"SIZE"
	dr	.getsize
	dc.l	"HIDS"
	dr	.hidestatus
	dc.l	"DURA"
	dr	.duration
	dc.l	"FILT"
	dr	.filter
	dc.l	0

.getplay
	moveq	#1,d0
	and.b	playing(a5),d0
	bra.w	i2amsg

.getcfil
	move	chosenmodule(a5),d0
	bmi.b	.getcfil0
	cmp	#$7fff,d0
	beq.b	.getcfil0
	addq	#1,d0
	bra.w	i2amsg
.getcfil0
	moveq	#0,d0
	bra.w	i2amsg

.getnfil
	move	modamount(a5),d0
	bra.w	i2amsg

.getcsng
	move	songnumber(a5),d0
	addq	#1,d0
	bra.w	i2amsg

.getnsng
	move	maxsongs(a5),d0
	addq	#1,d0
	bra.w	i2amsg

.getcspo
	move	pos_nykyinen(a5),d0
	bra.w	i2amsg

.getmspo
	move	pos_maksimi(a5),d0
	bra.w	i2amsg

.getname
	lea	modulename(a5),a2
	bra.w	str2msg

.gettype
	lea	moduletype(a5),a2
	bra.w	str2msg

.getcurrent
	move	playingmodule(a5),d0
	bmi.b	.getc0
	addq	#1,d0
	cmp	#$7fff+1,d0
	bne.w	i2amsg
.getc0	moveq	#0,d0
	bra.w	i2amsg

.currname
	bsr.w	getcurrent
	bne.b	.curr0
	lea	.empty(pc),a2
	bra.w	str2msg
.curr0	lea	l_filename(a3),a2
	bra.w	str2msg

.fullname
	move	playingmodule(a5),d0
	bmi.b	.curr1
	cmp	#$7fff,d0
	bne.b	.curr2
.curr1	lea	.empty(pc),a2
	bra.w	str2msg	
.curr2	bsr.w	getcurrent2
	lea	l_filename(a3),a2
	bra.b	str2msg

.getcomment
	lea	filecomment(a5),a2
	bra.b	str2msg

.getsize
	move.l	modulelength(a5),d0
	add.l	tfmxsampleslen(a5),d0
	bra.b	i2amsg2

.duration
	cmp	#pt_prot,playertype(a5)
	beq.b	.d9	
	moveq	#0,d0
	bra.b	i2amsg2
.d9
	move	kokonaisaika(a5),d0
	mulu	#60,d0
	add	kokonaisaika+2(a5),d0
	bra.b	i2amsg2

.hidestatus
	moveq	#1,d0
	and.b	win(a5),d0
	eor.b	#1,d0
	bra.b	i2amsg

.filter
	btst	#1,$bfe001
	seq	d0
	and.l	#%1,d0
	bra.b	i2amsg



.empty	dc	0

** a1:ssa oleva ascii-luku D0:aan
a2i	pushm	d1/a0/a6
	move.l	a1,a0
	lore	Rexx,CVa2i
	popm	d1/a0/a6
	rts

*** d0:ssa oleva luku rexxviestiksi
i2amsg	ext.l	d0
i2amsg2	pushm	d0/d1/a0/a1/a6
	moveq	#3,d1
	lore	Rexx,CVi2arg
	move.l	d0,rexxresult(a5)
	popm	d0/d1/a0/a1/a6
	rts

** a2:ssa oleva tekstinp�tk� rexxviestiksi
str2msg	pushm	d0/d1/a0/a1/a6
	move.l	a2,a0
	lore	Rexx,Strlen
	move.l	a2,a0
	lob	CreateArgstring
	move.l	d0,rexxresult(a5)
	popm	d0/d1/a0/a1/a6
	rts




;	move.l	rm_Args(a1),a0	; test for different commands here!
;	bsr.w	CLI_Write	; you must parse the parameters yourself

;	move.l	_RexxSysLibBase(pc),a6
;	lea	ret_string(pc),a0
;	move.l	a0,a1
;.len	tst.b	(a1)+
;	bne.s	.len
;	move.l	a1,d0
;	sub.l	a0,d0
;	subq.l	#1,d0
;	jsr	_LVOCreateArgstring(a6)

;	move.l	4.w,a6
;	move.l	RexxMsg_Ptr,a1
;	clr.l	rm_Result1(a1)		; result1 (Include:rexx/error.i)
;				; reselt1=rc (a global arexx var)
;	clr.l	rm_Result2(a1)		; result2 (0 for no return argstring)
;	move.l	d0,rm_Result2(a1)	; result2 (result=your string)
				; result only accept if arexx contains
				; Options Results
;	jsr	_LVOReplyMsg(a6)




*******************************************************************************
* Scoperutiinit
*******************************************************************************
wflags3 set WFLG_SMART_REFRESH!WFLG_DRAGBAR!WFLG_CLOSEGADGET!WFLG_DEPTHGADGET
wflags3 set wflags3!WFLG_RMBTRAP
idcmpflags3 = IDCMP_CLOSEWINDOW!IDCMP_MOUSEBUTTONS

quad_code
	lea	var_b,a5
	clr.l	mtab(a5)
	clr.l	buffer0(a5)
	clr.l	deltab1(a5)

	sub.l	a1,a1
	lore	Exec,FindTask
	move.l	d0,quad_task(a5)

	addq	#1,quad_prosessi(a5)	* Lippu: prosessi p��ll�

	lea	ch1(a5),a0
	lea	4*ns_size(a0),a1
.cl	clr	(a0)+
	cmp.l	a1,a0
	bne.b	.cl

	move.b	quadmode(a5),d0
	move.b	d0,d1
	and	#$f,d1
	add.b	d1,d1
	tst.b	d0
	bpl.b	.e
	addq.b	#1,d1
.e	move.b	d1,quadmode2(a5)	* 0-9



	moveq	#0,d0
	move.b	quadmode2(a5),d0
	lsl	#2,d0
	jmp	.t(pc,d0)

.t	jmp	.1(pc)		* quadrascope
	jmp	.3(pc)		* quadrascope bars
	jmp	.2(pc)		* hipposcope 
	jmp	.4(pc)		* hipposcope bars
	jmp	.5(pc)		* freq. analyzer
	jmp	.6(pc)		* freq. analyzer bars
	jmp	.cont(pc)	* patternscope
	jmp	.cont(pc)	* patternscope bars (ei oo!)
	jmp	.7(pc)		* filled quadrascope
	jmp	.8(pc)		* filled quadrascope & bars


.7	moveq	#-1,d7
	bra.b	.11
.8	moveq	#-1,d7
	bra.b	.33

* Quadrascope
.1	moveq	#0,d7
.11	move.l	#64*256*2,d0	* volumetaulukko
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	move.l	d0,mtab(a5)
	beq.w	.memer
	bsr.w	voltab
	bra.w	.cont

* Hipposcope
.2
	move.l	#64*256*2,d0
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	move.l	d0,mtab(a5)
	beq.w	.memer
	bsr.w	voltab2
	bra.w	.cont


.3	moveq	#0,d7
.33	move.l	#64*256*2,d0	* volumetaulukko
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	move.l	d0,mtab(a5)
	beq.w	.memer
	bsr.w	voltab
.wo	move.l	#512,d0		* palkkitaulu
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	move.l	d0,wotta(a5)
	beq.w	.memer
	bsr.w	mwotta		* tehd��n palkkitaulu
	bra.w	.cont


.4	move.l	#64*256*2,d0	* volumetaulukko
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	move.l	d0,mtab(a5)
	beq.w	.memer
	bsr.w	voltab2
	bra.b	.wo

.5	move.l	#64*256,d0	* volumetaulukko
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	move.l	d0,mtab(a5)
	beq.w	.memer
	bsr.w	voltab3
	bsr.b	.delt
	beq.w	.memer
	bra.b	.cont

.delt	move.l	#(256+32)*4,d0
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	move.l	d0,deltab1(a5)
	beq.b	.r
	add.l	#256+32,d0
	move.l	d0,deltab2(a5)
	add.l	#256+32,d0
	move.l	d0,deltab3(a5)
	add.l	#256+32,d0
	move.l	d0,deltab4(a5)
.r	rts


.6	move.l	#64*256,d0	* volumetaulukko
	move.l	#MEMF_CLEAR,d1
	bsr.w	getmem
	move.l	d0,mtab(a5)
	beq.w	.memer
	bsr.w	voltab3
	bsr.b	.delt
	beq.b	.memer
	bra.w	.wo

.cont
	
;	lea	ls01(pc),a0
;	move.b	quadmode2(a5),d0
;	lsr.b	#1,d0
;	beq.b	.ti
;	lea	ls02(pc),a0
;	subq.b	#1,d0
;	beq.b	.ti
;	lea	ls03(pc),a0
;	subq.b	#1,d0
;	beq.b	.ti
;	lea	ls04(pc),a0	
;	subq.b	#1,d0
;	beq.b	.ti
;	lea	ls05(pc),a0	
;.ti	move.l	a0,quadtitl

	


* Piirtoalueet
	move.l	#320/8*72*2,d0
	move.l	#MEMF_CHIP!MEMF_CLEAR,d1
	bsr.w	getmem
	beq.b	.me
	move.l	d0,buffer0(a5)
	add.l	#320/8*2,d0		* yl��lle 2 vararivi�
	move.l	d0,buffer1(a5)
	add.l	#320/8*70,d0
	move.l	d0,buffer2(a5)		* alaalle 4 


.gurgle

	move.l	_IntuiBase(a5),a6
	lea	winstruc3,a0
	move.l	quadpos(a5),(a0)

	move	wbleveys(a5),d0		* WB:n leveys
	move	(a0),d1			* Ikkunan x-paikka
	add	4(a0),d1		* Ikkunan oikea laita
	cmp	d0,d1
	bls.b	.ok1
	sub	4(a0),d0	* Jos ei mahdu ruudulle, laitetaan
	move	d0,(a0)		* mahdollisimman oikealle
.ok1	move	wbkorkeus(a5),d0	* WB:n korkeus
	move	2(a0),d1		* Ikkunan y-paikka
	add	6(a0),d1		* Ikkunan oikea laita
	cmp	d0,d1
	bls.b	.ok2
	sub	6(a0),d0	* Jos ei mahdu ruudulle, laitetaan
	move	d0,2(a0)	* mahdollisimman alas
.ok2

	lob	OpenWindow
	move.l	d0,windowbase3(a5)
	bne.b	.ok3
	lea	windowerr_t(pc),a1
.me	bsr.w	request
	bra.w	qexit

.memer	lea	memerror_t(pc),a1
	bra.b	.me

.ok3
	move.l	d0,a0
	move.l	wd_RPort(a0),rastport3(a5)
	move.l	wd_UserPort(a0),userport3(a5)

	jsr	setscrtitle


	move.l	_GFXBase(a5),a6
	move.l	rastport3(a5),a1
	move.l	pen_1(a5),d0
	lob	SetAPen

	tst.b	uusikick(a5)		* uusi kick?
	beq.b	.vanaha

	move.l	rastport3(a5),a2
	moveq	#4,d0
	moveq	#11,d1
	move	#335,d2
	moveq	#82,d3
	bsr.w	drawtexture

	moveq	#8,d0
	moveq	#13,d1
	move	#323,d4
	moveq	#67,d5
	moveq	#$0a,d6
	move.l	rastport3(a5),a0
	move.l	a0,a1
	add	windowleft(a5),d0
	add	windowtop(a5),d1
	move.l	d0,d2
	move.l	d1,d3
	lob	ClipBlit
.vanaha


*** Initialisoidaan oma bitmappi

	lea	omabitmap(a5),a0
	moveq	#1,d0
	move	#320,d1
	moveq	#66,d2
	lore	GFX,InitBitMap
	move.l	buffer1(a5),omabitmap+bm_Planes(a5)
 
	moveq	#7,plx1
	move	#332,plx2
	moveq	#13,ply1
	moveq	#80,ply2
	add	windowleft(a5),plx1
	add	windowleft(a5),plx2
	add	windowtop(a5),ply1
	add	windowtop(a5),ply2
	move.l	rastport3(a5),a1
	jsr	laatikko2

	move.l	buffer1(a5),draw1(a5)
	move.l	buffer2(a5),draw2(a5)
	moveq	#3*40,d0
	add.l	d0,draw1(a5)
	add.l	d0,draw2(a5)


	moveq	#0,d7
	move	playertype(a5),d6
	jsr	printhippo2	


	move.l	quad_task(a5),a1
	moveq	#-30,d0				* Prioriteetti 0:sta -30:een
	lore	Exec,SetTaskPri



qloop
	move.l	_GFXBase(a5),a6
	lob	WaitTOF

	tst.b	tapa_quad(a5)		* pit��k� poistua?
	bne.w	qexit

	move.l	_IntuiBase(a5),a1
	move.l	ib_FirstScreen(a1),a1
	move.l	windowbase3(a5),a0	* ollaanko p��llimm�isen�?
	cmp.l	wd_WScreen(a0),a1
	beq.b	.joo
	tst	sc_TopEdge(a1)
	beq.w	.m
.joo

** jos AHI, ei scopeja

	cmp	#pt_prot,playertype(a5)		 * pelitt�� vain PT modeilla.
	bne.b	.nnq
.nna	tst.b	ahi_use_nyt(a5)
	bne.b	.n
	bra.b	.nn

.nnq	cmp	#pt_sample,playertype(a5)	 * ja sampleplayerill�
;	beq.b	.nn
	beq.b	.nna
	cmp	#pt_multi,playertype(a5) 	* ja PS3M:ll�
	bne.b	.n

	tst.b	ahi_use_nyt(a5)
	bne.b	.n

	cmp.b	#5,s3mmode1(a5)		* killer
	beq.b	.n

	
.nn	tst.b	playing(a5)
	beq.b	.n
	tst.b	d7
	bne.b	.je
	bsr.b	.clear

.je
	cmp	playertype(a5),d6
	beq.b	.noen
	move	playertype(a5),d6
	bsr.b	.clear
.noen	pushm	d6/d7
	bsr.w	dung
	popm	d6/d7
	moveq	#-1,d7
	bra.b	.m
.n	
	tst.b	d7
	beq.b	.m
	moveq	#0,d7

;	cmp	#pt_prot,playertype(a5)
;	bne.b	.nm
;	cmp.b	#6,quadmode2(a5)	* patternscope, j�tet��n n�kyviin
;	beq.b	.m

.nm	bsr.b	.clear
	jsr	printhippo2
	bra.b	.m

.clear
	move.l	rastport3(a5),a1
	move.l	pen_0(a5),d0
	lore	GFX,SetAPen
	move.l	rastport3(a5),a1
	moveq	#10,d0
	moveq	#14,d1
	move	#330,d2
	moveq	#79,d3
	add	windowleft(a5),d0
	add	windowleft(a5),d2
	add	windowtop(a5),d1
	add	windowtop(a5),d3
	jmp	_LVORectFill(a6)

.m
	move.l	(a5),a6
	move.l	userport3(a5),a0
	lob	GetMsg
	tst.l	d0
	beq.w	qloop
	move.l	d0,a1

	move.l	im_Class(a1),d2		* luokka	
	move	im_Code(a1),d3
	lob	ReplyMsg
	cmp.l	#IDCMP_MOUSEBUTTONS,d2
	bne.b	.qx
	cmp	#MENUDOWN,d3
	beq.b	.xq
.qx	cmp.l	#IDCMP_CLOSEWINDOW,d2
	bne.w	qloop

.xq	clr.b	scopeflag(a5)
	
qexit	bsr.b	qflush_messages


	move.l	mtab(a5),a0
	jsr	freemem
	move.l	buffer0(a5),a0
	jsr	freemem
	move.l	deltab1(a5),a0
	jsr	freemem
	clr.l	mtab(a5)
	clr.l	buffer0(a5)
	clr.l	deltab1(a5)

	move.l	_IntuiBase(a5),a6		
	move.l	windowbase3(a5),d0
	beq.b	.uh1
	move.l	d0,a0
	move.l	4(a0),quadpos(a5)	* koordinaatit talteen
	lob	CloseWindow
	clr.l	windowbase3(a5)
.uh1


	lore	Exec,Forbid

	cmp	#1,prefsivu(a5)		* display prefssivu?
	bne.b	.reer
	bsr.w	updateprefs
.reer


	clr	quad_prosessi(a5)	* lippu: lopetettiin
	rts



qflush_messages
	tst.l	windowbase3(a5)
	beq.b	.ex
.m	move.l	(a5),a6
	move.l	userport3(a5),a0	* flushataan pois kaikki messaget
	lob	GetMsg
	tst.l	d0
	beq.b	.ex
	move.l	d0,a1
	lob	ReplyMsg
	bra.b	.m
.ex	rts



***** Scopen oma keskeytys, p�ivitt�� protrackerin sampleinfoja
scopeinterrupt				* a5 = var_b
	cmp	#pt_prot,playertype(a5)
	bne.w	.n

	lea	kplbase(a5),a0
	moveq	#0,d0
	move.b	k_usertrig(a0),d0
	move.b	d0,omatrigger(a5)
	clr.b	k_usertrig(a0)

	lea	k_chan1temp(a0),a2
	lea	ch1(a1),a0
	lea	hippoport+hip_PTtrigger1(a5),a3
	moveq	#4-1,d1
.setscope
	ror.b	#1,d0
	bpl.b	.e
	addq.b	#1,(a3)
	move.l	n_start(a2),ns_start(a0)
	move	n_length(a2),ns_length(a0)
	move.l	n_loopstart(a2),ns_loopstart(a0)
	move	n_replen(a2),ns_replen(a0)
.e	move	n_period(a2),ns_period(a0)
	move	n_tempvol(a2),ns_tempvol2(a0)
	addq	#1,a3

	cmp.b	#6,quadmode2(a5)	* Patternscope?
	beq.b	.eq
	cmp.b	#7,quadmode2(a5)	* Patternscope??
	beq.b	.eq

	move	n_tempvol(a2),ns_tempvol(a0)

.eq	lea	n_sizeof(a2),a2
	lea	ns_size(a0),a0
	dbf	d1,.setscope

	moveq	#4-1,d1
	lea	ch1(a5),a0

.le	moveq	#0,d0
	tst	ns_period(a0)
	beq.b	.noe
	move.l	colordiv(a5),d0		* colorclock/vbtaajuus
	divu	ns_period(a0),d0
.noe	ext.l	d0
	add.l	d0,ns_start(a0)
	lsr	#1,d0
	sub	d0,ns_length(a0)
	bpl.b	.plu
	move	ns_replen(a0),ns_length(a0)
	move.l	ns_loopstart(a0),ns_start(a0)
.plu	
	lea	ns_size(a0),a0
	dbf	d1,.le
	rts
.n
	cmp	#pt_sample,playertype(a5)
	bne.b	.nn
	move.l	sampleadd(a5),d0
	move.l	samplefollow(a5),a0
	add.l	d0,(a0)
.nn
	rts
	



******* Quadrascopelle 
voltab
	move.l	mtab(a5),a0
	moveq	#$40-1,d3
	moveq	#0,d2

	tst	d7
	bne.b	.voltab_fill

.olp2	moveq	#0,d0
	move	#256-1,d4
.olp1	move	d0,d1
	ext	d1
	muls	d2,d1
	asr	#8,d1
	add	#32,d1
	mulu	#40,d1
	add	#39,d1
	move	d1,(a0)+
	addq	#1,d0
	dbf	d4,.olp1
	addq	#1,d2
	dbf	d3,.olp2
	rts

******* Filled quadrascope

.voltab_fill
;	lea	mtab(a5),a0
;	moveq	#$40-1,d3
;	moveq	#0,d2
.olp2q	moveq	#0,d0
	move	#256-1,d4
.olp1q	move	d0,d1
	ext	d1
	muls	d2,d1
	asr	#8,d1
	tst	d1
	bmi.b	.mee
	moveq	#31,d5
	sub	d1,d5
	move	d5,d1
	sub	#32,d1
.mee	add	#32,d1
	mulu	#40,d1
	add	#39,d1
	move	d1,(a0)+
	addq	#1,d0
	dbf	d4,.olp1q
	addq	#1,d2
	dbf	d3,.olp2q
	rts



******* Hipposcopelle
voltab2
	move.l	mtab(a5),a0

	moveq	#$40-1,d3
	moveq	#0,d2
.op2
	moveq	#0,d0
	move	#256-1,d4
.op1
	move	d0,d1
	ext	d1
	muls	d2,d1
	asr	#8,d1
	add.b	#$80,d1
	move.b	d1,(a0)+

	addq	#1,d0
	dbf	d4,.op1

	addq	#1,d2
	dbf	d3,.op2


	moveq	#$40-1,d3
	moveq	#0,d2
.olp2a
	moveq	#0,d0
	move	#256-1,d4
.olp1a
	move	d0,d1
	ext	d1
	muls	d2,d1
	asr	#7,d1
	muls	#80,d1		* x-alue: 0-80
	divs	#127,d1
	add.b	#$80,d1
	move.b	d1,(a0)+

	addq	#1,d0
	dbf	d4,.olp1a

	addq	#1,d2
	dbf	d3,.olp2a
	
	rts



***************** Freqscopelle
voltab3
	move.l	mtab(a5),a0
	moveq	#$40-1,d3
	moveq	#0,d2
.olp2	moveq	#0,d0
	move	#256-1,d4
.olp1	move	d0,d1
	ext	d1
	muls	d2,d1
	asr	#6,d1
	move.b	d1,(a0)+
	addq	#1,d0
	dbf	d4,.olp1
	addq	#1,d2
	dbf	d3,.olp2
	rts


***************** Piirret��n
dung

	move.l	_GFXBase(a5),a6
	lob	OwnBlitter
	lob	WaitBlit

	lea	$dff058,a0
	move.l	draw2(a5),$54-$58(a0)	* tyhjennet��n piirtoalue
	move	#0,$66-$58(a0)
	move.l	#$01000000,$40-$58(a0)
	move	#64*64+20,(a0)

	lob	DisownBlitter

	cmp	#pt_sample,playertype(a5)
	bne.b	.toot
	cmp.b	#8,quadmode2(a5)	* filled? 8 tai 9
	bhs.b	.fil
	bsr.w	samplescope
	bra.w	.cont
.fil
	bsr.w	samplescopefilled
	bsr.w	mirrorfill

	bra.w	.cont
.toot


	moveq	#0,d0
	move.b	quadmode2(a5),d0
	add	d0,d0
	cmp	#pt_multi,playertype(a5)
	beq.b	.ttt
	jmp	.t(pc,d0)

.t	bra.b	.1
	bra.b	.3
	bra.b	.2
	bra.b	.4
	bra.b	.5
	bra.b	.6
	bra.b	.7
	bra.b	.7
	bra.b	.8
	bra.b	.9


.1	bsr.w	quadrascope
	bra.w	.cont
.2	bsr.w	hipposcope
	bra.w	.cont
.3	bsr.w	lever
	bsr.w	quadrascope
	bra.b	.cont
.4	bsr.w	lever
	bsr.w	hipposcope
	bra.b	.cont
.5	bsr.w	freqscope
	bra.b	.cont
.6	pushm	all
	bsr.w	freqscope
	bsr.w	lever2
	popm	all
	bra.b	.cont
.7	bsr.w	notescroller
	bra.b	.cont

.8	bsr.w	quadrascope
	bsr.w	mirrorfill
	bra.b	.cont
.9	bsr.w	quadrascope
	bsr.w	mirrorfill2
	lob	WaitBlit
	lob	DisownBlitter
	bsr.w	lever
	bra.b	.cont

.ttt	jmp	.tt(pc,d0)
.tt	bra.b	.11
	bra.b	.11
	bra.b	.22
	bra.b	.22
	bra.b	.33
	bra.b	.33
	bra.b	.11
	bra.b	.11
	bra.b	.44
	bra.b	.44

.22	bsr.w	multihipposcope
	bra.b	.cont
.11	bsr.w	multiscope
	bra.b	.cont
.33	bsr.w	freqscope
	bra.b	.cont
.44	bsr.w	multiscopefilled
	bsr.b	mirrorfill
.cont

	move.l	draw1(a5),d0
	move.l	draw2(a5),d1
	move.l	d1,draw1(a5)
	move.l	d0,draw2(a5)

	lea	omabitmap(a5),a0
	move.l	d0,bm_Planes(a0)

	move.l	_GFXBase(a5),a6	* kopioidaan kamat ikkunaan
	move.l	rastport3(a5),a1
	moveq	#0,d0		* l�hde x,y
	moveq	#0,d1
	moveq	#10,d2		* kohde x,y
	moveq	#15,d3
	add	windowleft(a5),d2
	add	windowtop(a5),d3
	move	#$c0,d6		* minterm, suora kopio a->d
	move	#320,d4		* x-koko
	moveq	#64,d5		* y-koko


	cmp	#pt_sample,playertype(a5)
	beq.b	.joa

	cmp	#pt_multi,playertype(a5)
	bne.b	.jaa
	cmp.b	#1,quadmode2(a5)
	bls.b	.joa
	cmp.b	#6,quadmode2(a5)
	blo.b	.jaa
.joa	addq	#4,d0
	subq	#4,d4
	bra.b	.jaow
.jaa


	cmp.b	#8,quadmode2(a5)
	bhs.b	.jaoww
	cmp.b	#6,quadmode2(a5)
	blo.b	.jaow
.jaoww	addq	#1,d2
	subq	#1,d4
.jaow

	lob	BltBitMapRastPort
.skippi
	rts


;STRUCTURE   BitMap,0
;WORD    bm_BytesPerRow
;WORD    bm_Rows
;BYTE    bm_Flags
;BYTE    bm_Depth
;WORD    bm_Pad
;STRUCT  bm_Planes,8*4
;LABEL   bm_SIZEOF


mirrorfill2
	moveq	#0,d7
	bra.b	mirrorfill0

mirrorfill
	moveq	#1,d7

mirrorfill0
	lore	GFX,OwnBlitter
	lob	WaitBlit

	move.l	draw1(a5),a0
	lea	$dff058,a2

	move.l	a0,$50-$58(a2)	* A
	lea	40(a0),a1
	move.l	a1,$48-$58(a2)	* C
	move.l	a1,$54-$58(a2)	* D
	moveq	#0,d0
	move	d0,$60-$58(a2)	* C
	move	d0,$64-$58(a2)	* A
	move	d0,$66-$58(a2)	* D
	moveq	#-1,d0
	move.l	d0,$44-$58(a2)
	move.l	#$0b5a0000,$40-$58(a2)	* D = A not C
	move	#31*64+20,(a2)	

	lea	63*40(a0),a1		* kopioidaan
	lob	WaitBlit
	movem.l	a0/a1,$50-$58(a2)
	move	#-80,$66-$58(a2) 	* D
	move.l	#$09f00000,$40-$58(a2)
	move	#32*64+20,(a2)	

	tst.b	d7
	beq.b	.x
	lob	DisownBlitter
.x	rts


quadrascope
	lea	ch1(a5),a3
	move.l	draw1(a5),a0
	lea	-30(a0),a0
	bsr.b	.scope
	lea	ch2(a5),a3
	move.l	draw1(a5),a0
	lea	-20(a0),a0
	bsr.b	.scope
	lea	ch3(a5),a3
	move.l	draw1(a5),a0
	lea	-10(a0),a0
	bsr.b	.scope
	lea	ch4(a5),a3
	move.l	draw1(a5),a0
;	bsr.b	.scope
;	rts

.scope
	move.l	ns_loopstart(a3),d0
	beq.b	.halt
	move.l	ns_start(a3),d1
	bne.b	.jolt
.halt	rts

.jolt	
	move.l	d0,a4
	move.l	d1,a1

	move	ns_length(a3),d5
	move	ns_replen(a3),d4


	move	ns_tempvol(a3),d1
	mulu	k_mastervolume+kplbase(a5),d1
	lsr	#6,d1

	tst	d1
	bne.b	.heee
	moveq	#1,d1
.heee	subq	#1,d1
	add	d1,d1
	lsl.l	#8,d1
	move.l	mtab(a5),a2
	add.l	d1,a2

	lea	-40(a0),a3

	cmp.b	#8,quadmode2(a5)
	beq.b	.iik
	cmp.b	#9,quadmode2(a5)
	bne.b	.ook
.iik	move.l	a0,a3
.ook

	moveq	#0,d1
	moveq	#80/8-1,d7
	moveq	#1,d0
	moveq	#0,d6

	
drlo	

sco	macro
	move	d6,d2
	move.b	(a1)+,d2
	add	d2,d2
	move	(a2,d2),d3
	or.b	d0,(a3,d3)
	or.b	d0,(a0,d3)

	ifne	\2
	add.b	d0,d0
	endc
	
	ifne	\1
	subq	#2,d5
	bpl.b	hm\2	* $6a04
	move	d4,d5
	move.l	a4,a1
hm\2
	endc
	endm

	sco	0,1
	sco	1,2
	sco	0,3
	sco	1,4
	sco	0,5
	sco	1,6
	sco	0,7
	sco	1,0

	moveq	#1,d0
	sub	d0,a0
	sub	d0,a3
	dbf	d7,drlo
	rts

hipposcope
	lea	ch1(a5),a3
	move.l	draw1(a5),a6
	lea	-20-95*40(a6),a6
	bsr.b	.twirl

	lea	ch2(a5),a3
	move.l	draw1(a5),a6
	lea	-10-95*40(a6),a6
	bsr.b	.twirl

	lea	ch3(a5),a3
	move.l	draw1(a5),a6
	lea	0-95*40(a6),a6
	bsr.b	.twirl

	lea	ch4(a5),a3
	move.l	draw1(a5),a6
	lea	10-95*40(a6),a6
;	bsr.b	.twirl
;	rts


.twirl
	move.l	mtab(a5),a0
	move	ns_tempvol(a3),d0
	muls	k_mastervolume+kplbase(a5),d0
	lsr	#6,d0
	subq	#1,d0
	bpl.b	.e
	moveq	#0,d0
.e	lsl	#8,d0
	lea	(a0,d0),a2
	lea	64*256(a2),a4


	move.l	ns_loopstart(a3),d6
	beq.b	.halt
	move.l	ns_start(a3),d1
	bne.b	.jolt
.halt	rts
.jolt	
	move.l	d1,a1

	move	ns_length(a3),d4
;	move.l	ns_start(a3),a1
	move	ns_replen(a3),d5

	lea	multab(a5),a0
	moveq	#108/4-1,d0

	moveq	#0,d1

lir	macro
	move.b	(a1)+,d1
	move.b	(a4,d1),d1

	moveq	#0,d2
	move.b	5(a1),d2
	move.b	(a2,d2),d2

	add	d2,d2
	move	(a0,d2),d3

	move	d1,d2
	lsr	#3,d2
	sub	d2,d3
	bset	d1,(a6,d3)

 ifne \2
	subq	#2,d4
	bpl.b	.h\1
	move	d5,d4
	move.l	d6,a1
.h\1	
 endc
	endm

.d
	lir	0,0
	lir	1,1
	lir	2,0
	lir	3,1

	dbf	d0,.d

	rts



**** Taajuusanalysaattori

yip	macro
	move.b	(a0)+,d0
	not.b	d0
	add.b	d0,d0
	and	d5,d0
	move	(a2,d0),d0
	or.b	d6,(a1,d0)
	ror.b	#1,d6
	bpl.b	.b\1
	addq	#1,a1
.b\1
 	endm

piup	macro
	move.b	(a1)+,d0
	sub.b	(a1),d0
	bpl.b	.e\1
	neg.b	d0
.e\1	addq.b	#1,(a0,d0)
	subq.l	#1,d5
	bpl.b	.l\1
	cmp	d3,d4
	beq	.break
	move.l	d4,d5
	move.l	a4,a1
.l\1	
	endm

freqscope
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move.l	deltab1(a5),a0
	lea	(256+32)*4(a0),a1
.clr	movem.l	d0-d7,-(a1)
	movem.l	d0-d7,-(a1)
	cmp.l	a0,a1
	bne.b	.clr


*** PS3M freqscope

	cmp	#pt_multi,playertype(a5)
	bne.b	.protr

;	move.l	buff1,a1
	move.l	ps3m_buff1(a5),a1
	move.l	(a1),a1

	move.l	deltab1(a5),a0
	bsr.w	.tutps3m

;	move.l	buff2,a1
	move.l	ps3m_buff2(a5),a1
	move.l	(a1),a1

	move.l	deltab2(a5),a0
	bsr.w	.tutps3m

	bra.b	.drl

.protr

	lea	ch1(a5),a3
	move.l	deltab1(a5),a0
	bsr.w	.tut
	lea	ch4(a5),a3
	move.l	deltab4(a5),a0
	bsr.w	.tut

	lea	ch2(a5),a3
	move.l	deltab2(a5),a0
	bsr.w	.tut
	lea	ch3(a5),a3
	move.l	deltab3(a5),a0
	bsr.w	.tut

	move	ns_tempvol+ch1(a5),d1
	move	ns_tempvol+ch4(a5),d2
	move.l	deltab1(a5),a0
	move.l	deltab4(a5),a1
	bsr.w	.pre

	move	ns_tempvol+ch2(a5),d1
	move	ns_tempvol+ch3(a5),d2
	move.l	deltab2(a5),a0
	move.l	deltab3(a5),a1
	bsr.b	.pre

.drl	move.l	deltab1(a5),a0
	move.l	draw1(a5),a1
	addq	#3,a1
	bsr.w	.dr

	move.l	deltab2(a5),a0
	move.l	draw1(a5),a1
	lea	21(a1),a1
	bsr.w	.dr

* Pystyfillaus
	lore	GFX,OwnBlitter

	move.l	draw1(a5),a0
	addq	#2,a0
	moveq	#2,d0
	lea	40(a0),a1
	lea	$dff000,a2

	lob	WaitBlit
	move.l	a0,$50(a2)	* A
	move.l	a1,$48(a2)	* C
	move.l	a1,$54(a2)	* D
	move	d0,$60(a2)	* C
	move	d0,$64(a2)	* A
	move	d0,$66(a2)	* D
	move.l	#-1,$44(a2)
	move.l	#$0b5a0000,$40(a2)	* D = A not C
	move	#65*64+19,$58(a2)

	lob	WaitBlit
	jmp	_LVODisownBlitter(a6)


.pre
	mulu	k_mastervolume+kplbase(a5),d1
	lsr	#6,d1
	bne.b	.1
	moveq	#1,d1
.1	subq	#1,d1
	lsl.l	#8,d1
	move.l	mtab(a5),a2
	add.l	d1,a2

	mulu	k_mastervolume+kplbase(a5),d2
	lsr	#6,d2
	bne.b	.2
	moveq	#1,d2
.2	subq	#1,d2
	lsl.l	#8,d2
	move.l	mtab(a5),a3
	add.l	d2,a3

	moveq	#128/4-1,d0
	moveq	#0,d3
	moveq	#0,d4
.volm	
 rept 4
	move.b	(a0),d3
	move.b	(a1)+,d4
	move.b	(a2,d3),d3
	add.b	(a3,d4),d3
	move.b	d3,(a0)+
 endr
	dbf	d0,.volm
	rts
	


.dr
	clr.b	(a0)
;	lea	1*40(a1),a1
	lea	multab(a5),a2
	moveq	#128/8-1,d7
	move.b	#$80,d6
	move	#%01111110,d5
.dloop
	yip	0
	yip	1
	yip	2
	yip	3
	yip	4
	yip	5
	yip	6
	yip	7
	dbf	d7,.dloop
	rts


.tut	
	move	ns_tempvol(a3),d4
	mulu	k_mastervolume+kplbase(a5),d4
	lsr	#6,d4
	bne.b	.h
	moveq	#1,d4
.h



	move.l	ns_loopstart(a3),d0
	beq.b	.halt
	move.l	ns_start(a3),d1
	bne.b	.jolt
.halt	rts

.jolt	
	move.l	d0,a4
	move.l	d1,a1

	moveq	#0,d4
	move	ns_replen(a3),d4
	add.l	d4,d4
	moveq	#0,d5
	move	ns_length(a3),d5
	add.l	d5,d5

	move	ns_period(a3),d0
	bne.b	.noe
	rts

.noe	move.l	colordiv(a5),d7		* colorclock/vbtaajuus
	divu	d0,d7			* d7.w = bytes per 1/50s
	mulu	#11,d7		* tutkitaan 11/15 osa framesta (73%)
	divu	#15,d7

	move	d7,d6
	lsr	#3,d7
	subq	#1,d7
	moveq	#0,d0
	moveq	#2,d3


.loop1
	piup	0
	piup	1
	piup	2
	piup	3
	piup	00
	piup	11
	piup	22
	piup	33
	dbf	d7,.loop1	

	and	#%111,d6
	beq.b	.n
	subq	#1,d6
.loop2	piup	4
	dbf	d6,.loop2
.n
.break
	rts



.tutps3m
;	move.l	mixingperiod,d0
	push	a0
	move.l	ps3m_mixingperiod(a5),a0
	move.l	(a0),d0
	pop	a0
	bne.b	.oe
	rts

.oe	move.l	colordiv(a5),d7		* colorclock/vbtaajuus
	divu	d0,d7			* d7.w = bytes per 1/50s
	mulu	#11,d7		* tutkitaan 11/15 osa framesta (73%)
	divu	#15,d7

	lsr	#2,d7
	subq	#1,d7
	moveq	#0,d0

;	move.l	playpos,d5
	push	a0
	move.l	ps3m_playpos(a5),a0
	move.l	(a0),d5
	pop	a0
		
	lsr.l	#8,d5
	bsr.w	getps3mb

piup2	macro
	move.b	(a1,d5.l),d0
	sub.b	1(a1,d5.l),d0
	bpl.b	.w\1
	neg.b	d0
.w\1	addq.b	#1,(a0,d0)
	addq	#1,d5
	and	d4,d5
	endm

.loop11	piup2	0
	piup2	1
	piup2	2
	piup2	3
	dbf	d7,.loop11

	rts

*********** Scopet PS3M
*** stereoscope

multiscope

	move.l	ps3m_buff1(a5),a1
	move.l	(a1),a1

	move.l	draw1(a5),a0
	lea	19(a0),a0
	bsr.b	.h

	move.l	ps3m_buff2(a5),a1
	move.l	(a1),a1
	move.l	draw1(a5),a0
	lea	39(a0),a0
.h

	move.l	ps3m_playpos(a5),a2
	move.l	(a2),d5
	lsr.l	#8,d5
	lea	multab(a5),a2
		
	moveq	#160/8-1-1,d7
	moveq	#1,d0
	move	#$80,d6
	bsr.w	getps3mb

multiscope0

.drlo	
 
 rept 8
 	move	d6,d2
	add.b	(a1,d5.l),d2
	lsr.b	#2,d2
	add	d2,d2
	move	(a2,d2),d2
	or.b	d0,-40(a0,d2)
	or.b	d0,(a0,d2)
	add.b	d0,d0

	addq.l	#1,d5
;	and.l	d4,d5
	cmp.l	d4,d5
	bne.b	*+4
	moveq	#0,d5
 endr
	
	moveq	#1,d0
	sub	d0,a0
	dbf	d7,.drlo
	rts




multiscopefilled

	move.l	ps3m_buff1(a5),a1
	move.l	(a1),a1

	move.l	draw1(a5),a0
	lea	19(a0),a0
	bsr.b	.h

	move.l	ps3m_buff2(a5),a1
	move.l	(a1),a1
	move.l	draw1(a5),a0
	lea	39(a0),a0
.h

	move.l	ps3m_playpos(a5),a2
	move.l	(a2),d5
	lsr.l	#8,d5
	lea	multab(a5),a2
		
	moveq	#160/8-1-1,d7
	moveq	#1,d0
	move	#$80,d6
	bsr.w	getps3mb

multiscopefilled0

hurl	macro 
	move	d6,d2
	add.b	(a1,d5.l),d2
	bpl.b	.ok\1
	not.b	d2
.ok\1
	lsr.b	#2,d2
	add	d2,d2
	move	(a2,d2),d2
	or.b	d0,(a0,d2)
	add.b	d0,d0
	addq.l	#1,d5

;	and.l	d4,d5
	cmp.l	d4,d5
	bne.b	*+4
	moveq	#0,d5
	endm

.drlo	
	hurl	1
	hurl	2
	hurl	3
	hurl	4
	hurl	5
	hurl	6
	hurl	7
	hurl	8

	moveq	#1,d0
	sub	d0,a0
	dbf	d7,.drlo
	rts




***** hipposcope ps3m:lle

multihipposcope
;	move.l	buff1,a1
	move.l	ps3m_buff1(a5),a1
	move.l	(a1),a1

	move	#240,d0
	bsr.b	.1
;	move.l	buff2,a1
	move.l	ps3m_buff2(a5),a1
	move.l	(a1),a1
	moveq	#88,d0
	
.1

	move.l	ps3m_playpos(a5),a2
	move.l	(a2),d5
;	move.l	playpos,d5
	lsr.l	#8,d5

	lea	multab(a5),a2
	move.l	draw1(a5),a3
	bsr.w	getps3mb
	moveq	#32,d6
	moveq	#120/4-1,d7

;	tst.b	scopeboost(a5)
;	beq.b	.d
;	moveq	#240/4-1,d7
.d

 rept 4
	move.b	(a1,d5),d1
	asr.b	#1,d1
	ext	d1
	add	d0,d1

	move.b	5(a1,d5),d2
	asr.b	#2,d2
	ext	d2
	add	d6,d2
	add	d2,d2
	move	(a2,d2),d3

	move	d1,d2
	lsr	#3,d2
	sub	d2,d3
	bset	d1,39(a3,d3)

	add	d2,d3			* toinen pixeli viereen
	addq	#1,d1
	move	d1,d2
	lsr	#3,d2
	sub	d2,d3
	bset	d1,39(a3,d3)

	addq	#1,d5
	and	d4,d5
 endr

	dbf	d7,.d

	rts


getps3mb
	push	a0
;	move.l	buffSizeMask,d4
	move.l	ps3m_buffSizeMask(a5),a0
	move.l	(a0),d4
	pop	a0
	rts






*******************************
* NoteScroller (ProTracker)
*

notescroller
	pushm	all
	bsr.w	.notescr

*** viiva
	move.l	draw1(a5),a0
	lea	7*40+2*8*40(a0),a0
	moveq	#19-1,d0
.raita	or	#$aaaa,(a0)+
	or	#$aaaa,8*40-2(a0)
	dbf	d0,.raita


	lea	kplbase(a5),a0
	moveq	#0,d0
	move.b	omatrigger(a5),d0
	clr.b	omatrigger(a5)

	lea	k_chan1temp(a0),a1
	lea	ch1(a5),a0
	moveq	#4-1,d1
.setscope
	ror.b	#1,d0
	bpl.b	.e
	move	n_tempvol(a1),ns_tempvol(a0)
.e	lea	ns_size(a0),a0
	lea	n_sizeof(a1),a1
	dbf	d1,.setscope


	move	ch1+ns_tempvol(a5),d0	
;	move.l	ch1+ns_start(a5),a0
	moveq	#2,d1
	bsr.b	.palkki
	move	ch2+ns_tempvol(a5),d0	
;	move.l	ch2+ns_start(a5),a0
	moveq	#11,d1
	bsr.b	.palkki
	move	ch3+ns_tempvol(a5),d0	
;	move.l	ch3+ns_start(a5),a0
	moveq	#20,d1
	bsr.b	.palkki
	move	ch4+ns_tempvol(a5),d0	
;	move.l	ch4+ns_start(a5),a0
	moveq	#29,d1
	bsr.b	.palkki

	lea	ch1(a5),a3
	move.b	#%11100000,d2
	moveq	#38,d1
	bsr.b	.palkki2
	lea	ch2(a5),a3
	moveq	#%1110,d2
	moveq	#38,d1
	bsr.b	.palkki2
	lea	ch3(a5),a3
	moveq	#39,d1
	move.b	#%11100000,d2
	bsr.b	.palkki2
	lea	ch4(a5),a3
	moveq	#%1110,d2
	moveq	#39,d1
	bsr.b	.palkki2

.ohi
	lea	ch1(a5),a0
	moveq	#4-1,d0
.orl	tst	ns_tempvol(a0)
	beq.b	.urh
	subq	#1,ns_tempvol(a0)
.urh	lea	ns_size(a0),a0
	dbf	d0,.orl


	popm	all
	rts


***** Volumepalkgi

.palkki
;	move.b	(a0),d0
;	sub.b	#$80,d0
;	and	#$ff,d0
;	mulu	kplbase+k_mastervolume(a5),d0
;	lsr	#8,d0

	mulu	kplbase+k_mastervolume(a5),d0
	lsr	#6,d0

	move.l	draw1(a5),a0
	lea	64*40(a0),a0
	add	d1,a0
	lea	.paldata(pC),a1

	moveq	#-2,d2
	subq	#1,d0
	bmi.b	.yg
.purl	and.b	d2,(a0)
	move.b	-(a1),d1
	or.b	d1,(a0)
	lea	-40(a0),a0
	dbf	d0,.purl	
.yg	rts



**** Periodpalkki
	
.palkki2
	cmp	#2,ns_length(a3)
	bls.b	.h
	moveq	#0,d0
	move	ns_period(a3),d0
	beq.b	.h
	sub	#108,d0
	lsl	#1,d0
	divu	#27,d0		* lukualueeksi 0-59

	move.l	draw1(a5),a0
	lea	multab(a5),a1
	add	d0,d0
	move	(a1,d0),d0
	add	d0,a0
	add	d1,a0

	or.b	d2,(a0)
	or.b	d2,40(a0)
	or.b	d2,80(a0)
	or.b	d2,120(a0)

.h	rts




* 8x64
	DC.B	$FC,$FC,$FC,$FC
	DC.B	$FC,$DC,$FC,$7C
	DC.B	$FC,$DC,$FC,$54
	DC.B	$FC,$5C,$FC,$54
	DC.B	$FC,$54,$FC,$54
	DC.B	$B8,$54,$FC,$54
	DC.B	$B8,$54,$AC,$54
	DC.B	$B8,$54,$A8,$54
	DC.B	$A8,$54,$A8,$54
	DC.B	$88,$54,$28,$54
	DC.B	$88,$54,$00,$54
	DC.B	$88,$54,$00,$54
	DC.B	$00,$54,$00,$54
	DC.B	$00,$10,$00,$54
	DC.B	$00,$10,$00,$00
	DC.B	$00,$10,$00,$00
.paldata



**************** Piirret��n patterndata

.notescr

	lea	kplbase(a5),a0
	move.l	k_songdataptr(a0),a3
	moveq	#0,d0
	move	k_songpos(a0),d0
	move.b	(a3,d0),d0
	lsl	#6,d0
	add	k_patternpos(a0),d0
	lsl.l	#4,d0
	add.l	d0,a3
	lea	1084-952(a3),a3

	move.l	draw1(a5),a4
	addq	#3,a4

	moveq	#8-1,d7
	move	k_patternpos(a0),d6	* eka rivi?

	move	d6,d0
	subq	#4,d0
	bpl.b	.ok
	neg	d0
	sub	d0,d7

	moveq	#4,d1
	sub	d0,d1
	sub	d1,d6
	lsl	#4,d1
	sub	d1,a3

	mulu	#8*40,d0
	add.l	d0,a4

	bra.b	.ok2
.ok
	lea	-4*16(a3),a3
	subq	#4,d6
.ok2



.plorl
	lea	.pos(pc),a0		* rivinumero
	move	d6,d0
	divu	#10,d0
	or.b	#'0',d0
	move.b	d0,(a0)
	swap	d0
	or.b	#'0',d0
	move.b	d0,1(a0)

	move.l	a4,a1
	subq	#3,a1
	moveq	#2-1,d1
	bsr.w	.print

	moveq	#4-1,d5
.plorl2

	lea	.note(pc),a2

	moveq	#0,d0
	move.b	2(a3),d0
	bne.b	.jee
	move.b	#' ',(a2)+
	move.b	#' ',(a2)+
	move.b	#' ',(a2)+
	bra.b	.nonote
.jee
	subq	#1,d0
	divu	#12*2,d0
	addq	#1,d0
	or.b	#'0',d0
	move.b	d0,2(a2)
	swap	d0
	lea	.notes(pc),a1
	lea	(a1,d0),a0
	move.b	(a0)+,(a2)+		* Nuotti
	move.b	(a0)+,(a2)+
	addq	#1,a2
.nonote

	moveq	#0,d0			* samplenumero
	move.b	3(a3),d0
	bne.b	.onh
	move.b	#' ',(a2)+
	move.b	#' ',(a2)+
	bra.b	.eihn
.onh

	lsr	#2,d0
	divu	#$10,d0
	bne.b	.onh2
	move.b	#' ',(a2)+
	bra.b	.eihn2
.onh2	or.b	#'0',d0
	move.b	d0,(a2)+
.eihn2	swap	d0
	bsr.b	.hegs
.eihn

	move.b	(a3),d0			* komento
	lsr.b	#2,d0
	bsr.b	.hegs
	moveq	#0,d0
	move.b	1(a3),d0
	divu	#$10,d0
	bsr.b	.hegs
	swap	d0
	bsr.b	.hegs


	move.l	a4,a1
	lea	.note(pc),a0
	moveq	#8-1,d1
	bsr.b	.print


	addq	#4,a3
	add	#9,a4
	dbf	d5,.plorl2

	add	#8*40-4*9,a4
	addq	#1,d6
	cmp	#64,d6
	beq.b	.lorl
	dbf	d7,.plorl
.lorl
	rts


.hegs	cmp.b	#9,d0
	bhi.b	.high1
	or.b	#'0',d0
	bra.b	.hge
.high1	sub.b	#10,d0
	add.b	#'A',d0
.hge	move.b	d0,(a2)+
	rts

.notes	dc.b	"C-"
	dc.b	"C#"
	dc.b	"D-"
	dc.b	"D#"
	dc.b	"E-"
	dc.b	"F-"
	dc.b	"F#"
	dc.b	"G-"
	dc.b	"G#"
	dc.b	"A-"
	dc.b	"A#"
	dc.b	"B-"

.note	dc.b	"00000000"
.pos	dc.b	"00"
 even

.print
	pushm	a3-a4
	move.l	topazbase(a5),a2
	;move.l	fontbase(a5),a2
	move	38(a2),d2		* font modulo
	move.l	34(a2),a2		* data

	moveq	#40,d4
	
.ooe	moveq	#0,d0
	move.b	(a0)+,d0
	cmp.b	#$20,d0
	beq.b	.space
	lea	-$20(a2,d0),a3
	move.l	a1,a4

	moveq	#8-1,d3
.lin	move.b	(a3),(a4)	
	add	d2,a3
	add	d4,a4
	dbf	d3,.lin

.space	addq	#1,a1
	dbf	d1,.ooe
	popm	a3-a4
	rts

	




***************************************************************************
* a0 = bitmap
* a1 = (playsidbase+50)
* d0 = kanava


;SIDscope
;	move.l	draw1(a5),a0
;	moveq	#0,d0
;	bsr.b	.1
;	bsr.b	.1
;	bsr.w	.1

;.1	bsr.b	.2
;	add	#10,a0
;	addq	#1,d0
;	rts

;.2	movem.l	d0-a6,-(sp)
;	move.l	_SIDBase(a5),a1
;	move.l	50(a1),a1
;	lea	multab(a5),a6

;	add.w	d0,d0
;	move.w	d0,d1
;	add.w	d0,d0
;	move.l	0(a1,d0.w),a3
;	add.w	d0,d0
;	lea	lbl006b58,a2
;	lea	lbl006950,a4
;	lsl.w	#4,d0
;	add.w	d0,a4
;	lea	lbl006b50,a5
;	moveq	#64-1,d3
;	move.w	#32*40,d4
;	move.w	$20(a1,d1.w),d6
;	bne.s	.lbc006706

;.lbc0066f8	move.w	d4,(a4)+
;	dbra	d3,.lbc0066f8

;	lea	-$80(a4),a4
;	bra.b	.lbc006752

;.lbc006706	cmp.w	#$7a,$18(a1,d1.w)
;	bls.s	.lbc0066f8

;	moveq	#0,d4
;	move.l	#$7b0000,d5
;	divu	$18(a1,d1.w),d5
;	move.w	$10(a1,d1.w),d7
;	move.w	0(a5,d1.w),d2
;.lbc006722	add.w	d5,0(a2,d1.w)
;	addx.w	d4,d2
;.lbc006728	cmp.w	d7,d2
;	blt.s	.lbc006730

;	sub.w	d7,d2
;	bra.s	.lbc006728

;.lbc006730	
;	move.b	0(a3,d2.w),d0
;	ext	d0
;	muls	d6,d0
;	asr	#8,d0
;;	asr	#1,d0
;	add	#32,d0
;	add	d0,d0
;	move	(a6,d0),(a4)+
;	dbra	d3,.lbc006722

;	lea	-$80(a4),a4
;	move.w	d2,0(a5,d1.w)
;.lbc006752
;;	move.w	#$3e0,d0
;;.lbc006756
;;	clr.l	0(a0,d0.w)
;;	clr.l	4(a0,d0.w)
;;	sub.w	#$20,d0
;;	bpl.s	.lbc006756

;	moveq	#31-1,d0
;	move.l	#$80000000,d1
;	move.l	#$40000000,d4
;	moveq	#40,d6
;.lbc006774
;	move.w	(a4)+,d2
;	move.w	(a4),d3
;	or.l	d1,0(a0,d2.w)
;	or.l	d4,0(a0,d3.w)
;	cmp.w	d3,d2
;	beq.s	.lbc0067b6

;	bhi.s	.lbc00679e

;.lbc006786	move.w	d3,d5
;	sub.w	d2,d5
;	cmp.w	d6,d5
;	bls.s	.lbc0067b6

;	add.w	d6,d2
;	sub.w	d6,d3
;	or.l	d1,0(a0,d2.w)
;	or.l	d4,0(a0,d3.w)
;	bra.b	.lbc006786

;.lbc00679e	move.w	d2,d5
;	sub.w	d3,d5
;	cmp.w	d6,d5
;	bls.s	.lbc0067b6

;	add.w	d6,d3
;	sub.w	d6,d2
;	or.l	d1,0(a0,d2.w)
;	or.l	d4,0(a0,d3.w)
;	bra.b	.lbc00679e

;.lbc0067b6	ror.l	#1,d1
;	ror.l	#1,d4
;	dbra	d0,.lbc006774

;	move.w	(a4)+,d2
;	move.w	(a4),d3
;	or.l	d1,0(a0,d2.w)
;	or.l	d4,4(a0,d3.w)
;	cmp.w	d3,d2
;	beq.s	.lbc006800

;	bhi.s	.lbc0067e8

;.lbc0067d0	move.w	d3,d5
;	sub.w	d2,d5
;	cmp.w	d6,d5
;	bls.s	.lbc006800

;	add.w	d6,d2
;	sub.w	d6,d3
;	or.l	d1,0(a0,d2.w)
;	or.l	d4,4(a0,d3.w)
;	bra.b	.lbc0067d0

;.lbc0067e8	move.w	d2,d5
;	sub.w	d3,d5
;	cmp.w	d6,d5
;	bls.s	.lbc006800

;	add.w	d6,d3
;	sub.w	d6,d2
;	or.l	d1,0(a0,d2.w)
;	or.l	d4,4(a0,d3.w)
;	bra.b	.lbc0067e8

;.lbc006800	ror.l	#1,d1
;	ror.l	#1,d4
;	moveq	#31-1,d0
;.lbc006806	move.w	(a4)+,d2
;	move.w	(a4),d3
;	or.l	d1,4(a0,d2.w)
;	or.l	d4,4(a0,d3.w)
;	cmp.w	d3,d2
;	beq.s	.lbc006848

;	bhi.s	.lbc006830

;.lbc006818	move.w	d3,d5
;	sub.w	d2,d5
;	cmp.w	d6,d5
;	bls.s	.lbc006848

;	add.w	d6,d2
;	sub.w	d6,d3
;	or.l	d1,4(a0,d2.w)
;	or.l	d4,4(a0,d3.w)
;	bra.b	.lbc006818

;.lbc006830	move.w	d2,d5
;	sub.w	d3,d5
;	cmp.w	d6,d5
;	bls.s	.lbc006848

;	add.w	d6,d3
;	sub.w	d6,d2
;	or.l	d1,4(a0,d2.w)
;	or.l	d4,4(a0,d3.w)
;	bra.b	.lbc006830

;.lbc006848	ror.l	#1,d1
;	ror.l	#1,d4
;	dbra	d0,.lbc006806

;	movem.l	(sp)+,d0-a6
;	rts


*******************************************************************


********** Palkit
lever2
	lea	ch1(a5),a3
	move.l	draw1(a5),a0
	bsr.b	dlever
	lea	ch4(a5),a3
	move.l	draw1(a5),a0
	lea	10(a0),a0
	bsr.b	dlever
	lea	ch2(a5),a3
	move.l	draw1(a5),a0
	lea	20(a0),a0
	bsr.b	dlever
	lea	ch3(a5),a3
	move.l	draw1(a5),a0
	lea	30(a0),a0
	bsr.b	dlever
	rts

lever
	lea	ch1(a5),a3
	moveq	#4-1,d2
	moveq	#0,d3
	move.l	draw1(a5),a2
.l	move.l	a2,a0
	bsr.b	dlever
	lea	10(a2),a2
	lea	ch2-ch1(a3),a3
	dbf	d2,.l
	rts
	

* 907-108
dlever
	cmp	#2,ns_length(a3)
	bls.b	.h
	moveq	#0,d1
	move	ns_period(a3),d1
	beq.b	.h
	sub	#108,d1
	lsl	#1,d1
	divu	#27,d1		* lukualueeksi 0-59

	lea	multab(a5),a1
	add	d1,d1
	add	(a1,d1),a0


	move	ns_tempvol(a3),d0
	mulu	k_mastervolume+kplbase(a5),d0
	lsr	#6,d0
	bne.b	.pad
	moveq	#1,d0
.pad	
	lsl	#3,d0
	subq	#8,d0
	bpl.b	.ojdo
	moveq	#0,d0
.ojdo
	move.l	wotta(a5),a1
	movem.l	(a1,d0),d0/d1

	pushm	d2/d3

	move.l	#$55555555,d3
	and.l	d3,d0
	and.l	d3,d1

	move.l	d0,d2
	move.l	d1,d3
	roxl.l	#1,d3
	roxl.l	#1,d2

	or.l	d0,(a0)+
	or.l	d1,(a0)
	or.l	d2,40-4(a0)
	or.l	d3,40(a0)
	or.l	d0,80-4(a0)
	or.l	d1,80(a0)
	or.l	d2,120-4(a0)
	or.l	d3,120(a0)

	popm	d2/d3
.h	rts


****** taulukkoon 1-64 pix leveit� palkkeja

mwotta	
	move.l	wotta(a5),a0
	moveq	#64-1,d0
	moveq	#0,d1
	moveq	#0,d2
.l	roxr.l	#1,d1
	roxr.l	#1,d2
	bset	#31,d1
	move.l	d1,(a0)+
	move.l	d2,(a0)+
	dbf	d0,.l
	rts




*** Sample IFF 8SVX scope


samplescope
	bsr.b	samples0
	move.l	samplepointer(a5),a1
	move.l	(a1),a1
	tst.b	samplestereo(a5)
	bne.b	.st
	lea	39(a0),a0
	moveq	#39-1,d7
	bra.w	multiscope0
.st	
	lea	19(a0),a0
	moveq	#19-1,d7
	bsr.w	multiscope0
	bsr.b	samples0
	lea	39(a0),a0
	move.l	samplepointer2(a5),a1
	move.l	(a1),a1
	moveq	#19-1,d7
	bra.w	multiscope0

samplescopefilled
	bsr.b	samples0
	move.l	samplepointer(a5),a1
	move.l	(a1),a1
	tst.b	samplestereo(a5)
	bne.b	.st
	lea	39(a0),a0
	moveq	#39-1,d7
	bra.w	multiscopefilled0
.st	
	lea	19(a0),a0
	moveq	#19-1,d7
	bsr.w	multiscopefilled0
	bsr.b	samples0
	lea	39(a0),a0
	move.l	samplepointer2(a5),a1
	move.l	(a1),a1
	moveq	#19-1,d7
	bra.w	multiscopefilled0


samples0
	move.l	samplefollow(a5),a0
	move.l	(a0),d5
;	move.l	samplefollow(a5),d5

	move.l	samplebufsiz(a5),d4
	subq.l	#1,d4
	moveq	#1,d0
	move	#$80,d6

	lea	multab(a5),a2
	move.l	draw1(a5),a0
	rts
	




 
*******************************************************************************

*******
* Moduulin lataus
*******


loadmodule
	st	loading(a5)
	move.l	(a5),tempexec(a5)

	move.b	d0,d7
	beq.w	.nodbf

	move.l	a0,modulefilename(a5)

	lea	-40(sp),sp

	lea	(sp),a2
	move.l	modulelength(a5),(a2)+
	move.l	tfmxsamplesaddr(a5),(a2)+
	move.l	tfmxsampleslen(a5),(a2)+
	move.b	lod_tfmx(a5),(a2)

;	move.l	modulefilename(a5),a0
	moveq	#MEMF_CHIP,d0
	lea	moduleaddress2(a5),a1
	lea	modulelength(a5),a2
	moveq	#0,d1			* kommentti talteen
	bsr.w	loadfile
	move.l	d0,d7


	clr.b	loading(a5)		* lataus loppu

	clr	songnumber(a5)
	clr	pos_maksimi(a5)
	clr	pos_nykyinen(a5)


	lea	20(sp),a2
	move.l	modulelength(a5),(a2)+
	move.l	tfmxsamplesaddr(a5),(a2)+
	move.l	tfmxsampleslen(a5),(a2)+
	move.b	lod_tfmx(a5),(a2)

	lea	(sp),a2
	move.l	(a2)+,modulelength(a5)
	move.l	(a2)+,tfmxsamplesaddr(a5)
	move.l	(a2)+,tfmxsampleslen(a5)
	move.b	(a2),lod_tfmx(a5)

	push	d7

	jsr	fadevolumedown
	move	d0,-(sp)
	bsr.w	halt			* Vapautetaan se jos on

	move.l	modulefilename(a5),a0

	move.l	playerbase(a5),a0
	jsr	p_end(a0)

	move.l	modulefilename(a5),a0


	jsr	freemodule	
	move	(sp)+,mainvolume(a5)

	pop	d7


	lea	20(sp),a2
;	move.l	(a2)+,moduleaddress(a5)
	move.l	moduleaddress2(a5),moduleaddress(a5)
	move.l	(a2)+,modulelength(a5)
	move.l	(a2)+,tfmxsamplesaddr(a5)
	move.l	(a2)+,tfmxsampleslen(a5)
	move.b	(a2),lod_tfmx(a5)

	tst.l	d7
	beq.b	.nay
* errori? putsataan tfmx osotteet
	clr.l	tfmxsamplesaddr(a5)
	clr.l	tfmxsampleslen(a5)
.nay

	lea	40(sp),sp

	cmp	#XPKERR_NOMEM,lod_xpkerror(a5)
	beq.b	.nomemdbf
	cmp	#XPKERR_SMALLBUF,lod_xpkerror(a5)
	beq.b	.nomemdbf
	cmp	#lod_nomemory,d7	* tuliko out of memory?
	beq.b	.nomemdbf		* uusi yritys, kun edellinen modi
	cmp	#lod_nomemoryf,d7	* ei enaa oo muistissa
	beq.b	.nomemdbf

	move.l	d7,-(sp)
	bra.b	.diddbf

.nomemdbf
	move.l	modulefilename(a5),a0

.nodbf
	jsr	freemodule		* Varmistetaan

	clr	songnumber(a5)
	clr	pos_maksimi(a5)
	clr	pos_nykyinen(a5)
	move.l	a0,modulefilename(a5)

;	move.l	modulefilename(a5),a0
	moveq	#MEMF_CHIP,d0
	lea	moduleaddress(a5),a1
	lea	modulelength(a5),a2
	moveq	#0,d1			* kommentti talteen
	bsr.w	loadfile
	move.l	d0,-(sp)
	clr.b	loading(a5)		* lataus loppu

	clr.b	songover(a5)	* varmistuksia, h�lm�o

	DEBU	PAH1


.diddbf	bsr.w	inforivit_clear
	jsr	reslider

	move.l	(sp)+,d0
	tst	d0
	bne.w	.err			* virhe lataamisessa

	tst.b	sampleinit(a5)
	bne.b	.nip

	move.l	moduleaddress(a5),a0	* Oliko moduleprogram??
	cmp.l	#"HiPP",(a0)
	bne.b	.nipz
	cmp	#"rg",4(a0)
	beq.b	.nipa
.nipz
	cmp.l	#"HIPP",(a0)
	bne.b	.nip
	cmp	#"RO",4(a0)
	bne.b	.nip

.nipa
	lea	-150(sp),sp
	move.l	sp,a3
	move.l	modulefilename(a5),a0
.cop	move.b	(a0)+,(a3)+
	bne.b	.cop

	jsr	freemodule
	jsr	rbutton9		* lista tyhj�ks
	move	#-1,playingmodule(a5)

	move.l	sp,a0			* ohjelman nimi
	moveq	#-1,d4			* lippu
	bsr.w	loadprog		* ladataan moduuliohjelma
	lea	150+4(sp),sp
;	addq	#4,sp			* ei palata samaan aliohjelmaan!
	rts
.nip

	DEBU	PAH2

	bsr.w	tutki_moduuli
	tst.l	d0
	bne.b	.unk_err		* ep�m��r�inen tiedosto

	clr.b	contonerr_laskuri(a5)	* nollataan virhelaskuri
	rts	

**** Virhe, ja pit�isi ladata toinen moduuli.
.iik
	cmp	#1,modamount(a5)
	beq.b	loaderr

	addq.b	#1,contonerr_laskuri(a5) 	* jos sattuu viisi per�kk�ist� 
	cmp.b	#5,contonerr_laskuri(a5) 	* virhett�, keskeytet��n
	bne.b	.iik2				* contonerror-toiminto
	clr.b	contonerr_laskuri(a5)
	bra.b	loaderr
.iik2

	bsr.w	inforivit_errc		* Skipping -teksti
	moveq	#50,d1
	lore	Dos,Delay

	move	#-1,playingmodule(a5)
	moveq	#1,d7			* seuraava piisi!
	jsr	soitamodi
	addq	#4,sp			* ei samaan paluuosoitteeseen!
	rts


.unk_err
	move.l	d0,-(sp)
	jsr	freemodule
	move.l	(sp)+,d0

.err	
	tst.b	contonerr(a5)		* Continue on error?
	bne.b	.iik
loaderr
	cmp	#lod_xpkerr,d0
	beq.w	xpkvirhe
	cmp	#lod_xfderr,d0
	beq.w	xfdvirhe
	cmp	#lod_tuntematon,d0
	beq.w	tuntematonvirhe

	move	d0,d1
	neg	d1
	add	d1,d1
	lea	.ertab2-2(pc,d1),a1
	add	(a1),a1
	bra.w	request			* requesteri

.ertab2	dr	openerror_t
	dr	readerror_t
	dr	memerror_t
	dr	cryptederror_t
	dr	error_t
	dr	unknownpperror_t
	dr	grouperror_t
	dr	noxpkerror_t
	dr	nopperror_t
	dr	error_t		* xpk errori muualla
	dr	unknown_t
	dr	nofast_t
	dr	execerr_t
	dr	lockerr_t
	dr	notafile_t
	dr	openerror_t
	dr	error_t
	dr	extract_t

cryptederror_t
;	dc.b	"File is encrypted!",0
unknownpperror_t
;	dc.b	"Unknown PowerPacker format!",0

error_t
	dc.b	"Error!?",0
openerror_t
	dc.b	"Error opening file!",0
readerror_t
	dc.b	"Read error!",0
noxpkerror_t
	dc.b	"No xpkmaster.library!",0
nopperror_t
	dc.b	"No powerpacker.library!",0
unknown_t
	dc.b	"Unknown file format!",0
nofast_t
memerror_t	
	dc.b	"Not enough memory!",0
;nofast_t dc.b	"Not enough fast memory!",0
execerr_t dc.b	"External error!",0
lockerr_t dc.b	"Can't lock on file!",0
notafile_t dc.b	"Not a file!",0
grouperror_t dc.b "Trouble with the player group!",0

windowerr_t	dc.b	"Couldn't to open window!",0
;extract_t	dc.b	"Extraction error!",0
extract_t	dc.b	"Extraction error!",10
		dc.b	"No known files found in archive.",0
 even	



xpkvirhe			* N�ytet��n XPK:n oma virheilmoitus.
	movem.l	d0-a6,-(sp)
	lea	.x(pc),a1
	lea	xarray(pc),a4
	pushpea	xpkerror(a5),(a4)
	bra.w	request2

.x	dc.b	"XPK error:",10
	dc.b	"%s",0
 even

xarray	dc.l	0

xfdvirhe			* N�ytet��n XFD:n oma virheilmoitus.
	movem.l	d0-a6,-(sp)
	move	lod_xfderror(a5),d0
	lore	XFD,xfdGetErrorText
	lea	.x(pc),a1
	lea	xarray(pc),a4
	move.l	d0,(a4)
	bra.w	request2

.x	dc.b	"XFD error:",10
	dc.b	"%s",0
 even


** Moduuli oli tuntematon!
* Poistetaanko listasta??

tuntematonvirhe
	movem.l	d0-a6,-(sp)
	lea	unknown_t(pc),a1
	lea	.g(pc),a2
	bsr.w	rawrequest
	tst.l	d0
	beq.b	.w	
	bsr.w	delete
.w	movem.l	(sp)+,d0-a6
	rts

.g	dc.b	"_Delete from list|_OK",0
 even

*******************************************************************************
* Ladataan tiedosto, jos pakattu - FImp, XPK, PP, LhA, Zip, LZX - puretaan
****
* a0 <= nimi
* d0 <= muistin tyyppi
* a1 <= mihin pistet��n alkuosoite
* a2 <= mihin pistet��n pituus
* d0 => 0 tai virhe

* Virheet (d0:ssa):
lod_openerr	=	-1
lod_readerr	=	-2
lod_nomemory	=	-3
lod_crypted	=	-4	; ( vain PP )
lod_unknownpp	=	-6	; ( vain PP )
lod_grouperror	=	-7
lod_noxpk	=	-8
lod_nopp	=	-9
lod_xpkerr	=	-10
lod_tuntematon	=	-11
lod_nomemoryf	=	-12
lod_execerr	=	-13
lod_lockerr	=	-14
lod_notafile	=	-15
lod_openerr2	=	-16
lod_xfderr	=	-17
lod_extract	=	-18

loadfile
	movem.l	d1-a6,-(sp)

	jsr	pon1

	lea	lod_a(a5),a3
	lea	lod_b(a5),a4
.clr	clr	(a3)+
	cmp.l	a4,a3
	bne.b	.clr

	move.l	d0,lod_memtype(a5)	
	move.b	d1,lod_kommentti(a5)
	move.l	a0,lod_filename(a5)
	move.l	a1,lod_start(a5)
	move.l	a2,lod_len(a5)
	clr.l	(a1)
	clr.l	(a2)

	move.l	lod_filename(a5),a0	* tutkitaan nimen liite
	move.l	a0,a2
.fe	tst.b	(a0)+
	bne.b	.fe
	subq	#1,a0


** Archiven purku

	move.b	-(a0),d0
	ror.l	#8,d0
	move.b	-(a0),d0
	ror.l	#8,d0
	move.b	-(a0),d0
	ror.l	#8,d0
	move.b	-(a0),d0

	and.l	#$dfdfdfff,d0	
	cmp.l	#'LHA.',d0
	beq.b	.lha
	cmp.l	#'LZH.',d0
	beq.b	.lha
	cmp.l	#'LZX.',d0
	beq.b	.lzx
	cmp.l	#'ZIP.',d0
	beq.b	.zip
	bra.w	.nope

.lha	lea	arclha(a5),a0
	moveq	#0,d6
	bra.b	.unp
.zip	lea	arczip(a5),a0
	moveq	#1,d6
	bra.b	.unp
.lzx	lea	arclzx(a5),a0
	moveq	#2,d6

.unp	

	pushm	all
	bsr.w	inforivit_extracting
	bsr.w	remarctemp	* varmuuden vuoksi poistetan tempdirri jos on
	popm	all

	move.l	lod_filename(a5),d0
	lea	lod_buf(a5),a3
	jsr	desmsg3

	st	lod_archive(a5)		* lippu!!

* SP = RAM:�HiP�

	lea	-160(sp),sp
	move.l	sp,a1
	lea	arcdir(a5),a0
	bsr.w	copyb
	subq	#1,a1
	cmp.b	#':',-1(a1)
	beq.b	.na
	move.b	#'/',(a1)+
.na	
	lea	tdir(pc),a0
	bsr.w	copyb


** vanha kick: kopioidaan parametrin per��n RAM:�HiP�/
	tst.b	uusikick(a5)
	bne.b	.nu
	lea	lod_buf(a5),a1
.barf	tst.b	(a1)+
	bne.b	.barf
	subq	#1,a1
	move.b	#' ',(a1)+
	lea	(sp),a0
	bsr.w	copyb
	subq	#1,a1
	cmp.b	#':',-1(a1)
	beq.b	.na0
	move.b	#'/',(a1)+
.na0	clr.b	(a1)

.nu



	move.l	sp,a4

	moveq	#0,d6
	moveq	#0,d5

*** Luodaan dirri

	move.l	a4,d1
	lore	Dos,CreateDir
	tst.l	d0
	beq.b	.onjo
	move.l	d0,d1
	lob	UnLock


.onjo
*** Lockki dirriin
	move.l	a4,d1
	moveq	#ACCESS_READ,d2
	lob	Lock

	move.l	d0,d7
	beq.w	.x

*** CD dirriin

	move.l	d0,d1
	lob	CurrentDir
	move.l	d0,d6

*** Ajetaan kamat


	pushpea	lod_buf(a5),d1
	moveq	#0,d2			* input
	move.l	nilfile(a5),d3		* output
	lob	Execute

	move.l	d7,d1
	lob	CurrentDir


*** Skannataan dirrin fil�t

	move.l	d7,d1
	pushpea	fileinfoblock(a5),d2
	lob	Examine
	tst.l	d0
	beq.w	 .x
	
.loop	
	move.l	d7,d1
	lob	ExNext
	tst.l	d0
	beq.w	.x

	pushm	all

	pushpea	fib_FileName+fileinfoblock(a5),d1
	move.l	#MODE_OLDFILE,d2
	lob	Open
	move.l	d0,d4
	beq.w	.bah

	move.l	d4,d1

	lea	probebuffer(a5),a0
	move.l	a0,d2

	move.l	#2048/4-1,d0	* tyhj�ks
.clear	clr.l	(a0)+
	dbf	d0,.clear

	move.l	#2048,d3
	lob	Read
	move.l	d0,d7
	cmp.l	#100,d0
	bls.w	.nah

*** Tsekataan tyyppi�

	lea	probebuffer(a5),a0

** Tutkaillaan moduulia tarkistusrutiineilla

	pushm	d4/a4
	move.l	a0,a4
	bsr.w	id_protracker
	beq.w	.on

	bsr.w	id_ps3m		
	tst.l	d0
	beq.w	.on

	bsr.w	id_med
	beq.w	.on

	bsr.w	id_hippel
	beq.w	.on

	bsr.w	id_futurecomposer13
	beq.w	.on

	bsr.w	id_futurecomposer14
	beq.w	.on

	bsr.w	id_oktalyzer
	beq.w	.on

	bsr.w	id_tfmxunion
	beq.w	.on

	bsr.w	id_TFMX_PRO
	tst	d0
	beq.w	.on

	bsr.w	id_TFMX7V
	tst	d0
	beq.w	.on

	bsr.w	id_tfmx
	beq.w	.on

	bsr.w	id_hippelcoso
	beq.w	.on

	bsr.w	id_soundmon
	beq.w	.on

	bsr.w	id_soundmon3
	beq.w	.on

	bsr.w	id_musicassembler
	beq.b	.on

	bsr.w	id_sid1
	beq.b	.on

	bsr.w	id_sonic
	beq.b	.on

	bsr.w	id_fred			* Fred
	beq.b	.on

	bsr.w	id_sidmon1		* Sidmon1
	beq.b	.on

	bsr.w	id_deltamusic
	beq.b	.on

	bsr.w	id_markii
	beq.b	.on

	bsr.w	id_maniacsofnoise
	beq.b	.on
	
	bsr.w	id_davidwhittaker
	beq.b	.on

	bsr.w	id_jamcracker
	beq.b	.on

	bsr.w	id_digibooster
	beq.b	.on

	bsr.w	id_thx
	beq.b	.on

	bsr.w	id_mline
	beq.b	.on

	bsr.w	id_aon
	beq.b	.on

	bsr.w	id_player
	beq.b	.on

	move.l	fileinfoblock+8(a5),d0	* Tied.nimen 4 ekaa kirjainta
	bsr.w	id_player2
	beq.b	.on

	cmp.l   #"XPKF",(a4)             * pakatut kelpaavat!
	beq.b   .on
	cmp.l   #"IMP!",(a4)
	beq.b   .on
	cmp.l   #"PP20",(a4)
	beq.b	.on

;	bsr.w	id_oldst		* oldst tunnistus viimeiseksi
;	beq.b	.on

	moveq	#-1,d0
	bra.b	.ei

.on	moveq	#0,d0
.ei	popm	d4/a4
	
	tst	d0
	bne.b	.nah

.joo

* juhuu! kopioidaan tied. nimi talteen

	lea	lod_buf(a5),a1
	move.l	a1,lod_filename(a5)
	move.l	a4,a0
	bsr.w	bcopy
	subq	#1,a1
	move.b	#'/',(a1)+
	lea	fib_FileName+fileinfoblock(a5),a0
	push	a0
	bsr.w	bcopy
	pop	a0		* tfmx?

	move.l	(a0),d0
	and.l	#$dfdfdfdf,d0
	cmp.l	#"MDAT",d0
	bne.b	.now
	st	lod_tfmx(a5)	* lippu: archive = tfmx
.now
	
	move.l	d4,d1
	lob	Close
	popm	all
	st	d5
	bra.b	.x
.nah

	move.l	d4,d1
	lob	Close
.bah
	popm	all
	bra.w	.loop

.x
	move.l	d6,d1
	lob	CurrentDir

	move.l	d7,d1
	beq.b	.xx
	lob	UnLock
.xx

	lea	160(sp),sp

	tst	d5
	bne.b	.nope

* oliko sopivaa file�?
	move	#lod_extract,lod_error(a5)
	bra.w	.exit



.nope


	move.l	_DosBase(a5),a6
	move.l	lod_filename(a5),d1
	moveq	#ACCESS_READ,d2
	lob	Lock			
	move.l	d0,d3
	beq.w	.open_error
	move.l	d0,d1
	lea	fileinfoblock(a5),a3
	move.l	a3,d2
	lob	Examine
	move.l	d3,d1
	lob	UnLock

	tst.l	fib_DirEntryType(a3)	* onko tiedosto vai hakemisto?
	bpl.w	.nofile_err

	move.l	124(a3),lod_length(a5)	* tiedoston pituus
	beq.w	.open_error		* jos 0 -> errori

	tst.b	lod_kommentti(a5)
	bne.b	.noc
	lea	fileinfoblock+144(a5),a0	* kopioidaan kommentti talteen
	lea	filecomment(a5),a1
	moveq	#80-1,d0
.cece	move.b	(a0)+,(a1)+
	dbeq	d0,.cece
	clr.b	(a1)
.noc


	move.l	#1005,d2
	move.l	lod_filename(a5),d1
	lob	Open
	move.l	d0,lod_filehandle(a5)
	beq.w	.open_error

	move.l	lod_filehandle(a5),d1
	lea	probebuffer(a5),a0
	move.l	a0,d2
	move.l	#1084,d3
	lob	Read
;	cmp.l	#1084,d0
;	bne.w	.read_error

*** onko lha, lzx, zip?

	cmp	#'PK',probebuffer(a5)
	bne.b	.nozip
	cmp.b	#$20,2+probebuffer(a5)
	bhs.b	.nozip
	cmp.b	#$20,3+probebuffer(a5)
	bhs.b	.nozip

	bsr.w	.closeit
	clr.l	lod_filehandle(a5)
	bra.w	.zip
.nozip

	cmp.l	#"LZX"<<8,probebuffer(a5)
	bne.b	.nolzx

	bsr.w	.closeit
	clr.l	lod_filehandle(a5)
	bra.w	.lzx
.nolzx

	cmp	#'-l',2+probebuffer(a5)
	bne.b	.nolha
	move.l	4+probebuffer(a5),d0
* d0 = "h5-v"
	and.l	#$ff00ff00,d0
	cmp.l	#$68002d00,d0
	bne.b	.nolha

	bsr.w	.closeit
	clr.l	lod_filehandle(a5)
	bra.w	.lha

.nolha

	


** Jos havaitaan file sampleks, ei ladata enemp��
	lea	probebuffer(a5),a0
	clr.b	sampleinit(a5)
	bsr.w	.samplecheck
	bne.b	.nosa
	st	sampleinit(a5)
	bra.w	.exit

.nosa	clr.b	sampleformat(a5)





	lea	probebuffer(a5),a0	* Kannattaako ladata fastiin??
	bsr.w	.checkm

;.nocheck

	cmp.l	#"XPKF",probebuffer(a5)
	bne.w	.wasnt_xpk


	bsr.w	get_xpk
	beq.w	.lib_error1



** file on xpk, katsotaan jos se on sample:
	lea	probebuffer+16(a5),a0
	clr.b	sampleinit(a5)
	bsr.w	.samplecheck
	bne.b	.nosa2
	st	sampleinit(a5)
	bra.w	.exit

.nosa2	clr.b	sampleformat(a5)





	st	lod_xpkfile(a5)	* lippu: xpk file

* Ladataan eka XPK-hunkki tiedostosta ja katsotaan voidaanko se
* ladata fastiin.

	tst.b	xpkid(a5)	* Oliko XPK id p��ll�?
	bne.w	.noid


	bsr.w	inforivit_xpkload2

	lea	.xpktags2(pc),a1
	move.l	lod_filename(a5),.in2-.xpktags2(a1)
	lea	.xfhpointerp(pc),a0
	lore	XPK,XpkOpen
 	tst.l	d0
	bne.w	.xpk_error

	move.l	.xfhpointerp(pc),a0	* Varataan ekalle hunkille muistia.
	move.l	xf_NLen(a0),d0
	moveq	#MEMF_PUBLIC,d1
	jsr	getmem
	move.l	d0,d4
	bne.b	.ok

	move.l	.xfhpointerp(pc),a0
	lob	XpkClose
	bra.w	.nomem_error
.ok


	move.l	.xfhpointerp(pc),a0
	move.l	xf_NLen(a0),d0
	move.l	d4,a1
	lob	XpkRead
	tst.l	d0
	bpl.b	.oka

	push	d0
	move.l	.xfhpointerp(pc),a0
	lob	XpkClose
	move.l	d4,a0
	jsr	freemem
	pop	d0
	bra.w	.xpk_error
.oka

	move.l	.xfhpointerp(pc),a0
	lob	XpkClose

	move.l	lod_length(a5),-(sp)
	move.l	12+probebuffer(a5),lod_length(a5)	* unXPKed length

	move.l	d4,a0
	bsr.w	.checkm
	move.l	(sp)+,lod_length(a5)

	move.l	d4,a0
	jsr	freemem
	bra.b	.oo

.xpktags2
	dc.l	XPK_InName
.in2	dc.l	0

	dc.l	XPK_GetError
	dc.l	xpkerror+var_b	* virheilmoitus
	dc.l	TAG_END

.xfhpointerp dc.l	0


.oo
.noid

	bsr.w	.infor
	bsr.w	inforivit_xpkload

	tst.b	win(a5)
	beq.b	.eilo
	moveq	#81+WINX-1,plx1
	move	#245+WINX+2,plx2
	moveq	#21+WINY,ply1
	moveq	#27+WINY,ply2
	add	windowleft(a5),plx1
	add	windowleft(a5),plx2
	add	windowtop(a5),ply1
	add	windowtop(a5),ply2
	move.l	rastport(a5),a1
	jsr	laatikko2
.eilo

	lea	.xpktags(pc),a0
	lea	lod_address(a5),a1
	move.l	a1,.xpkaddr-.xpktags(a0)
	lea	lod_length(a5),a1
	move.l	a1,.xpklen1-.xpktags(a0)

	move.l	lod_filename(a5),.xpkfile-.xpktags(a0)
	move.l	lod_memtype(a5),.xpkmem-.xpktags(a0)
	move.l	_XPKBase(a5),a6
	lob	XpkUnpack
	tst.l	d0
	bne.w	.xpk_error
	bra.w	.exit

.xpktags
		dc.l	XPK_InName
.xpkfile	dc.l	0

		dc.l	XPK_GetOutBuf
.xpkaddr	dc.l	0

		dc.l	XPK_GetOutBufLen
.xpklen1	dc.l	0

		dc.l	XPK_OutMemType
.xpkmem		dc.l	2		* muistin tyyppi

		dc.l	XPK_PassThru
		dc.l	1

		dc.l	XPK_GetError
		dc.l	xpkerror+var_b	* virheilmoitus

		dc.l	XPK_ChunkHook
		dc.l	.hook
		dc.l	TAG_END



.hook	ds.b	MLN_SIZE
	dc.l	.hookroutine	* h_Entry
	dc.l	0		* h_SubEntry
	dc.l	0		* h_Data



** Printataan infoa ladattaessa xpk filett�
.hookroutine
* a1 = progress report structure
	pushm	d1-d7/a0/a1/a5/a6
	lea	var_b,a5
	tst.b	win(a5)
	beq.b	.xxx

	moveq	#$7f,d4
	and.l	xp_Done(a1),d4
	cmp	#100,d4
	bls.b	.h0
	moveq	#100,d4
.h0

        move.l  rastport(a5),a0
        move.l  a0,a1

        move.b  rp_Mask(a0),d7
        move.b	#%11,rp_Mask(a0)

        moveq   #82+WINX,d0
        moveq   #22+WINY,d1
        add     windowleft(a5),d0
        add     windowtop(a5),d1

        move.l  d0,d2
        move.l  d1,d3
        mulu    #163,d4
        divu    #100,d4

        moveq   #5,d5
        move    #$f0,d6
        lore    GFX,ClipBlit

        move.l  rastport(a5),a0
        move.b  d7,rp_Mask(a0)

.xxx	popm	d1-d7/a0/a1/a5/a6
	moveq	#0,d0		* ei breakkia!	
	rts



.wasnt_xpk

	cmp.l	#"PP20",probebuffer(a5)
	bne.b	.wasnt_pp

	bsr.w	inforivit_load
	bsr.w	inforivit_ppload

	bsr.w	get_pp
	beq.w	.lib_error2

	move.l	d0,a6
	move.l	lod_filename(a5),a0		* filename
	moveq	#4,d0		* col
	move.l	lod_memtype(a5),d1
	lea	lod_address(a5),a1
	lea	lod_length(a5),a2
	sub.l	a3,a3
	lob	ppLoadData
	tst.l	d0
	beq.w	.exit
	bra.w	.pp_error	
.wasnt_pp

	cmp.l	#"IMP!",probebuffer(a5)
	bne.b	.wasnt_fimp

	bsr.w	inforivit_load
	bsr.w	inforivit_fimpload

	move.l	lod_length(a5),d4
	move.l	4+probebuffer(a5),lod_length(a5)

	bsr.w	.alloc
	move.l	d0,lod_address(a5)
	beq.w	.fimp_error

	bsr.w	.seekstart

	move.l	_DosBase(a5),a6
	move.l	lod_filehandle(a5),d1
	move.l	lod_address(a5),d2
	move.l	d4,d3
	lob	Read
	cmp.l	d4,d0
	bne.w	.fimp_error2

	bsr.w	inforivit_fimpdecr

	move.l	lod_address(a5),a0
	bsr.w	fimp_decr	
	bra.w	.exit

.wasnt_fimp

********* Lataus XFDmaster.libill�
	tst.b	xfd(a5)
	beq.w	.wasnt_xfd

	bsr.w	get_xfd
	beq.w	.wasnt_xfd

** Tavallinen lataus t�ss� v�liss�

	bsr.w	.alloc
	move.l	d0,lod_address(a5)
	beq.w	.error

	bsr.w	.infor
	bsr.w	.seekstart

	move.l	lod_filehandle(a5),d1
	move.l	lod_address(a5),d2
	move.l	lod_length(a5),d3
	move.l	_DosBase(a5),a6
	lob	Read
	cmp.l	lod_length(a5),d0
	bne.w	.error2

	lore	XFD,xfdAllocBufferInfo	
	move.l	d0,a3	
	tst.l	d0
	beq.w	.exit		* Error: menee tavallisena filen�

	move.l	lod_address(a5),xfdbi_SourceBuffer(a3)
	move.l	lod_length(a5),xfdbi_SourceBufLen(a3)
	move.l	a3,a0
	lob	xfdRecogBuffer
	tst.l	d0
	bne.b	.xok1		* Error: tavallisena filen�

.xok0	move.l	a3,a1
	lob	xfdFreeBufferInfo
	bra.w	.exit
.xok1
	move.l	xfdbi_PackerName(a3),d0
	bsr.w	inforivit_xfd

	move	xfdbi_PackerFlags(a3),d0
	and	#XFDPFF_PASSWORD!XFDPFF_RELOC!XFDPFF_ADDR,d0
	beq.b	.xok2		* Pakkerityyppi v��r�.. Ei kelpaa!
	move	#lod_tuntematon,lod_error(a5)
	bra.b	.xok0
.xok2

	moveq	#MEMF_CHIP,d0
	move.l	d0,xfdbi_TargetBufMemType(a3)
	move.l	a3,a0
	lob	xfdDecrunchBuffer
	tst.l	d0
	bne.b	.xok3
	move	xfdbi_Error(a3),lod_xfderror(a5) * error numba talteen
	move	#lod_xfderr,lod_error(a5)
	bsr.w	.free			* Vapautetaan pakattu file
	bra.b	.xok0
.xok3
	bsr.w	.free			* Vapautetaan pakattu file

	move.l	xfdbi_TargetBuffer(a3),lod_address(a5)	* Puretun tiedot
	move.l	xfdbi_TargetBufLen(a3),lod_length(a5)

	move.l	a3,a1
	lore	XFD,xfdFreeBufferInfo
** OK!
	bra.w	.exit


****** Ihan Tavallinen Lataus

.wasnt_xfd

	bsr.w	.alloc
	move.l	d0,lod_address(a5)
	beq.w	.error

	bsr.w	.infor

	bsr.w	.seekstart



 ifeq floadpr
	move.l	lod_filehandle(a5),d1
	move.l	lod_address(a5),d2
	move.l	lod_length(a5),d3
	move.l	_DosBase(a5),a6
	lob	Read
	cmp.l	lod_length(a5),d0
	bne.w	.error2
 else

*** laatukko file load progress indicator blabh

	tst.b	win(a5)
	beq.b	.eilox
	moveq	#15+WINX,plx1
	move	#245+WINX,plx2
	moveq	#21+WINY,ply1
	moveq	#27+WINY,ply2
	add	windowleft(a5),plx1
	add	windowleft(a5),plx2
	add	windowtop(a5),ply1
	add	windowtop(a5),ply2
	move.l	rastport(a5),a1
	jsr	laatikko3
.eilox


	move.l	lod_length(a5),d4
	move.l	lod_address(a5),d5

.loadloop
	move.l	lod_filehandle(a5),d1
	move.l	d5,d2
;	move.l	#$4000,d3
	move.l	#$2000,d3
;	move.l	#$1000,d3
;	move.l	#512,d3
	lore	Dos,Read

	sub.l	d0,d4
	bmi.w	.error2
	beq.b	.don

	add.l	d0,d5

	bsr.b	.lood

	bra.b	.loadloop


.lood
	tst.b	win(a5)
	beq.b	.wxx
	pushm	d4/d5

	move.l	lod_length(a5),d5
	move.l	d5,d3
	lsr.l	#8,d3
	sub.l	d4,d5
	lsr.l	#8,d5

	mulu	#229,d5
	divu	d3,d5
	move	d5,d4

        move.l  rastport(a5),a0
        move.l  a0,a1

        move.b  rp_Mask(a0),d7
        move.b	#%11,rp_Mask(a0)

        moveq   #16+WINX,d0
        moveq   #22+WINY,d1
        add     windowleft(a5),d0
        add     windowtop(a5),d1

        move.l  d0,d2
        move.l  d1,d3

        moveq   #5,d5
        move    #$f0,d6
        lore    GFX,ClipBlit

        move.l  rastport(a5),a0
        move.b  d7,rp_Mask(a0)

	popm	d4/d5
.wxx
	rts
.don


 endc

	



.exit	

	bsr.b	.closeit

	tst.b	lod_archive(a5)		* dellataan archivetempfile
	beq.b	.eiarc
	tst.b	lod_tfmx(a5)		* jos oli tfmx, ei dellata
	bne.b	.eiarc
	bsr.w	remarctemp
.eiarc

	tst	lod_error(a5)
	beq.b	.okk


	bsr.w	.free

;	tst.l	lod_address(a5)
;	beq.b	.noko
;	bsr	freemodule
	bra.b	.noko
.okk
	move.l	lod_start(a5),a0
	move.l	lod_address(a5),(a0)
	move.l	lod_len(a5),a0
	move.l	lod_length(a5),(a0)



.noko

	jsr	poff1

	move	lod_error(a5),d0
	ext.l	d0
	movem.l	(sp)+,d1-a6
	tst.l	d0
	rts



.seekstart
	move.l	lod_filehandle(a5),d1		* tiedoston alkuun
	moveq	#0,d2
	moveq	#-1,d3
	move.l	_DosBase(a5),a6
	;lob	Seek	
	jmp	_LVOSeek(a6)

.closeit
	move.l	lod_filehandle(a5),d1
	beq.b	.em
	move.l	_DosBase(a5),a6
	lob	Close
.em	rts



.checkm
        bsr.w   tutki_moduuli2
	cmp.b	#2,d0
	beq.w	.ptfoo
        cmp.b   #-1,d0
        beq.b   .nofast

.publl  moveq   #MEMF_PUBLIC,d0

.osd    move.l  d0,lod_memtype(a5)
.nofast rts

.nofas	moveq	#MEMF_CHIP,d0
	bra.b	.osd



***** tutkaillaan onko sample
.samplecheck
** IFF
	move.b	#1,sampleformat(a5)
	cmp.l	#"FORM",(a0)
	bne.b	.nosa0
	cmp.l	#"8SVX",8(a0)
	beq.b	.sampl
** AIFF
	move.b	#2,sampleformat(a5)
	cmp.l	#"AIFF",8(a0)
	beq.b	.sampl

.nosa0
** RIFF WAVE
	move.b	#3,sampleformat(a5)
	cmp.l	#"RIFF",(a0)
	bne.b	.nosaa
	cmp.l	#"WAVE",8(a0)
	beq.b	.sampl
.nosaa
** MPEG
	move.b	#4,sampleformat(a5)

	move.l	modulefilename(a5),a0
.zu	tst.b	(a0)+
	bne.b	.zu
	subq.l	#1,a0
	move.b	-(a0),d0
	ror.l	#8,d0
	move.b	-(a0),d0
	ror.l	#8,d0
	move.b	-(a0),d0
	ror.l	#8,d0
	move.b	-(a0),d0
	ror.l	#8,d0
	and.l	#$ffdfdfff,d0
	cmp.l	#".MP1",d0
	beq.b	.sampl
	cmp.l	#".MP2",d0
	beq.b	.sampl
	cmp.l	#".MP3",d0


.sampl	rts
	

** Ladataan PT file fastiin jos ei mahdu chipppppiin
.ptfoo
	tst.b	ahi_use(a5)		* AHI? -> public
	bne.w	.publl
	cmp.b	#2,ptmix(a5)		* PS3M? -> public
	beq.w	.publl

	pushm	all
	move.l	#MEMF_LARGEST!MEMF_CHIP,d1
	lore	Exec,AvailMem
	cmp.l	lod_length(a5),d0
	popm	all
	blo.w	.publl
	rts



.infor	moveq	#MEMF_PUBLIC,d0
	cmp.l	lod_memtype(a5),d0
	beq.w	inforivit_load2
	bra.w	inforivit_load


.nofile_err
	move	#lod_notafile,lod_error(a5)
	bra.w	.exit

.open_error
	move	#lod_openerr,lod_error(a5)
	bra.w	.exit
.error
.nomem_error
.fimp_error
	move	#lod_nomemory,lod_error(a5)
	bra.w	.exit

.fimp_error2
.error2	
	bsr.b	.free
.read_error
	move	#lod_readerr,lod_error(a5)
	bra.w	.exit
.lib_error1
	move	#lod_noxpk,lod_error(a5)
	bra.w	.exit
.lib_error2
	move	#lod_nopp,lod_error(a5)
	bra.w	.exit
.xpk_error
	move	#lod_xpkerr,lod_error(a5)
	move	d0,lod_xpkerror(a5)
;	bra.w	.exit
	bra.w	.noko	

.pp_error
	move	d0,lod_error(a5)	* PP:n virhekoodi (yhteensopiva)
	bra.w	.exit


.alloc	
	move.l	lod_length(a5),d0
	move.l	lod_memtype(a5),d1
	move.l	(a5),a6
	lob	AllocMem
	tst.l	d0
	rts

.free	move.l	lod_address(a5),d0
	beq.b	.eee
	move.l	d0,a1
	move.l	lod_length(a5),d0
	move.l	(a5),a6
	lob	FreeMem
.eee	rts


remarctemp
	pushm	all
	lea	-200(sp),sp
	move.l	sp,a1
	lea	.del1(pc),a0
	bsr.w	copyb
	subq	#1,a1

	lea	arcdir(a5),a0
	bsr.w	copyb
	subq	#1,a1
	cmp.b	#':',-1(a1)
	beq.b	.nar
	move.b	#'/',(a1)+
.nar	
	lea	tdir(pc),a0
	bsr.w	copyb
	subq	#1,a1
	lea	.del2(pc),a0
	bsr.w	copyb

	move.l	sp,d1
	moveq	#0,d2
	move.l	nilfile(a5),d3
	lore	Dos,Execute
	lea	200(sp),sp
	popm	all
	rts

.del1	dc.b	"c:delete ",0
.del2	dc.b	" ALL QUIET",0 ;FORCE

tdir	dc.b	"�HiP�",0
 even


get_xpk	move.l	_XPKBase(a5),d0
	beq.b	.noep
	rts
.noep	lea 	xpkname(pc),a1		
	move.l	a6,-(sp)
	move.l	(a5),a6
	lob	OldOpenLibrary
	move.l	(sp)+,a6
	move.l	d0,_XPKBase(a5)
	rts

get_pp	move.l	_PPBase(a5),d0
	beq.b	.noep
	rts
.noep	lea 	ppname(pc),a1		
	move.l	a6,-(sp)
	move.l	(a5),a6
	lob	OldOpenLibrary
	move.l	(sp)+,a6
	move.l	d0,_PPBase(a5)
	rts

get_sid	move.l	_SIDBase(a5),d0
	beq.b	.noep
	rts
.noep	lea 	sidname(pc),a1		
	move.l	a6,-(sp)
	move.l	(a5),a6
	lob	OldOpenLibrary
	move.l	(sp)+,a6
	move.l	d0,_SIDBase(a5)
	beq.b	.q
	bsr.w	init_sidpatch
	moveq	#1,d0
.q	rts

get_xfd
	move.l	_XFDBase(a5),d0
	beq.b	.x
	rts
.x	lea	xfdname(pc),a1
	push	a6
	lore	Exec,OldOpenLibrary
	pop	a6
	move.l	d0,_XFDBase(a5)
	rts

get_med1
	move.l	_MedPlayerBase1(a5),d0
	beq.b	.q
	rts
.q	lea	medplayername1(pc),a1
;	moveq	#6,d0
	push	a6
;	lore	Exec,OpenLibrary
	lore	Exec,OldOpenLibrary
	pop	a6
	move.l	d0,_MedPlayerBase1(a5)
	rts	

get_med2
	move.l	_MedPlayerBase2(a5),d0
	beq.b	.q
	rts
.q	lea	medplayername2(pc),a1
;	moveq	#6,d0
	push	a6
;	lore	Exec,OpenLibrary
	lore	Exec,OldOpenLibrary
	pop	a6
	move.l	d0,_MedPlayerBase2(a5)
	rts	

get_med3
	move.l	_MedPlayerBase3(a5),d0
	beq.b	.q
	rts
.q	lea	medplayername3(pc),a1
;	moveq	#7,d0
	push	a6
;	lore	Exec,OpenLibrary
	lore	Exec,OldOpenLibrary
	pop	a6
	move.l	d0,_MedPlayerBase3(a5)
	rts	


get_mline
	move.l	_MlineBase(a5),d0
	beq.b	.q
	rts
.q	lea	mlinename(pc),a1
	push	a6
	lore	Exec,OldOpenLibrary
	pop	a6
	move.l	d0,_MlineBase(a5)
	rts	






*******************************************************************************
* Analysoidaan tiedosto
*******************************************************************************


*******
* Search
*******
* a1 = etsitt�v�
* a4 = mist� etsit��n
* d0 = etsitt�v�n pituus
* d7 = modin pituus

search
	move.l	#2048,d2
	cmp.l	d7,d2
	blo.b	sea
	move.l	d7,d2		
sea	lea	(a4,d2.l),a3	 * Etsit��n kaksi kilotavua tai modin pituus

	move	d0,d2
	subq	#2,d2
	move.l	a4,a0
	move.b	(a1)+,d0
.moh	move.l	a1,a2
.findi	
	cmp.l	a3,a0
	bhs.b	.eieh
	cmp.b	(a0)+,d0
	bne.b	.findi

	move	d2,d1
.fid	cmpm.b	(a2)+,(a0)+
	dbne	d1,.fid
	beq.b	.yeah

.fof	cmp.l	a3,a0
	blo.b	.moh
.eieh	moveq	#-1,d0
	rts
.yeah	moveq	#0,d0
	rts



*******
* Analysoidaan moduuli
*******
* Tutkitaan, onko moduuli sellanen jonka vois ladata fastiin.
* a0 = moduuli, 1084 bytee

tutki_moduuli2

* ptmix -> 0: chip, 1: fast, 2: ps3m


	tst.b	ahi_use(a5)
	bne.b	.er

	tst.b	ptmix(a5)
	beq.b	.er

	cmp.b	#2,ptmix(a5)
	beq.b	.er

	bsr.w	.ptch		* fast
	beq.w	.rf
	bra.b	.nom

.er	bsr.w	.ptch		* 
	beq.w	.ff

.nom
	cmp.l	#'SCRM',44(a0)		* Screamtracker ]I[
	beq.w	.f
	cmp.l	#"OCTA",1080(a0)	* Fasttracker
	beq.w	.f

	cmp.l	#`Exte`,(a0)		* Fasttracker ][ XM
	bne.b	.kala
	cmp.l	#`nded`,4(a0)
	bne.b	.kala
	cmp.l	#` Mod`,8(a0)
	bne.b	.kala
	cmp.l	#`ule:`,12(a0)
	beq.w	.f

.kala	move.l	1080(a0),d0
	and.l	#$ffffff,d0		* fast
	cmp.l	#"CHN",d0
	beq.w	.f
	cmp	#"CH",1082(a0)		* fast
	beq.w	.f
	move.l	(a0),d0
	lsr.l	#8,d0
	cmp.l	#'MTM',d0		* multi
	beq.w	.f
	move.l	1080(a0),d0
	lsr.l	#8,d0
	cmp.l	#"TDZ",d0		* take
	beq.w	.f


* tfmx?
	cmp.l	#"TFMX",(a0)
	beq.w	.f
	cmp.l	#"tfmx",(a0)
	beq.w	.f

	cmp.l	#'OKTA',(a0)		* Oktalyzer
	bne.b	.m
	cmp.l	#'SONG',4(a0)
	bne.b	.m
	cmp.l	#$00010001,$10(a0)	* Onko 8 kanavaa?
	bne.b	.m
	cmp.l	#$00010001,$10+4(a0)
	beq.b	.f
.m
	cmp.l	#'PSID',(a0)		* PSID-tiedosto
	beq.b	.f

	move.l	(a0),d0			* THX
	lsr.l	#8,d0
	cmp.l	#"THX",d0
	beq.b	.f

	cmp.l	#"MLED",(a0)		* MusicLine Editor?
	bne.b	.ndd
	cmp.l	#"MODL",4(a0)	
	beq.b	.f
.ndd

** OctaMed SoundStudio mixattavat moduulit

	move.l	(a0),d0
	lsr.l	#8,d0
	cmp.l	#'MMD',d0
	bne.b	.nome
	btst	#0,20(a0)		* mmdflags, MMD_LOADTOFASTMEM
	bne.b	.f

;	move.l	8(a0),a1		* MMD0song *song
;	add.l	a0,a1			* reloc
;	btst	#7,768(a1)		* flags2; miksaus?
;	bne.b	.f


.nome
	cmp.l	#'DIGI',(a0)		* digi booster
	bne.b	.nd
	cmp.l	#' Boo',4(a0)
	bne.b	.nd
	cmp.l	#'ster',8(a0)
	beq.b	.f

.nd
	cmp.l	#'DBM0',(a0)		* digi booster pro
	beq.b	.f


	tst.b	ahi_use(a5)
	bne.b	.ahitun


.nf	moveq	#-1,d0		* chip
	rts
.f	moveq	#0,d0		* public
	rts
.ff	moveq	#2,d0		* Protracker file
	rts
.rf	moveq	#1,d0		* fast
	rts
 

.ptch	cmp.l	#"M.K.",1080(a0)
	beq.b	.petc
	cmp.l	#"M!K!",1080(a0)
	beq.b	.petc
	cmp.l	#"FLT4",1080(a0)
.petc	rts

.ahitun
	pushm	all

	move.l	a0,a4
	bsr.w	id_hippelcoso
	beq.b	.ok
	moveq	#-1,d0

.ok	popm	all
	beq.b	.f
	bra.b	.nf



tutki_moduuli

 ifne PILA

	lea	keyfile(a5),a4
	push	a4

	lea	.aag_id(pc),a1		 * onko AAG'97 keyfile?
	moveq	#4,d0
	moveq	#40,d7
	bsr.w	search
	pop	a0
	beq.b	.screw

	move.l	#$20202020,d0	
	or.l	(a0),d0
	cmp.l	#"wrec",d0		* wREC oF zYMOSIS?
	bne.b	.nwr
	move.l	(a5),a0
	btst	#AFB_68060,AttnFlags+1(a0)	* 68060?
	bne.b	.nwr
.screw	
	moveq	#-128,d1		* odotellaan
	ror.l	#7,d1
	lore	Dos,Delay
.nwr


 endc


	move.l	moduleaddress(a5),a4
	move.l	modulelength(a5),d7


	tst.b	keyfile+49(a5)	* datan v�lilt� 38-50 pit�� olla nollia
	beq.b	.zz
	move.l	(a5),a2
	addq.l	#1,IVSOFTINT+IV_CODE(a2)
.zz

	tst.b	ahi_use(a5)
	bne.b	.ohi
	cmp.b	#2,ptmix(a5)	* Normaali vai miksaava PT replayeri?
	beq.b	.ohi
	bsr.w	id_protracker
	beq.w	.pro

.ohi


	clr.b	external(a5)		* Lippu: ei tartte player grouppia 

	tst.b	sampleinit(a5)
	bne.b	.noop

	tst.b	ahi_muutpois(a5)	
	bne.b	.noop

	bsr.w	id_med
	beq.w	.med

	bsr.w	id_mline
	beq.w	.mline

	bsr.w	id_musicassembler
	beq.w	.musicassembler

	bsr.w	id_sonic
	beq.w	.sonicarranger

	bsr.w	id_fred			* Fred
	beq.w	.fred

	bsr.w	id_sidmon1		* Sidmon1
	beq.w	.sidmon1

	bsr.w	id_deltamusic
	beq.w	.deltamusic

	bsr.w	id_markii
	beq.w	.markii

	bsr.w	id_maniacsofnoise
	beq.w	.mon

	bsr.w	id_davidwhittaker
	beq.w	.dw

	bsr.w	id_hippel
	beq.w	.hippel

	tst.l	externalplayers(a5)
	bne.b	.noop

	bsr.w	id_sid
	beq.w	.sid

	bsr.w	id_oldst
	beq.w	.oldst
.noop



	tst.l	externalplayers(a5)	* ladataan playerit
	bne.b	.rite
	cmp.b	#2,groupmode(a5)	* onko disabled
	beq.w	.nopl

	cmp.b	#3,groupmode(a5)	* tarpeen vaatiessa 1 replayeri?
	bne.b	.rote
	st	external(a5)		* Lippu!
	bra.b	.rite
.rote
	bsr.w	loadplayergroup
	move.l	d0,externalplayers(a5)
	bne.b	.rite
	moveq	#lod_grouperror,d0
	rts

.aag_id	dc.b	"AAG9"
 even

.rite

	tst.b	ahi_muutpois(a5)
	beq.b	.mpa

** AHIa tukevat replayerit
	bsr.w	id_hippelcoso
	beq.w	.hippelcoso

	bra.w	.mp
.mpa

	tst.b	sampleinit(a5)		* sample??
	bne.w	.sample

	bsr.w	id_jamcracker
	beq.w	.jam

	bsr.w	id_futurecomposer13
	beq.w	.future13

	bsr.w	id_futurecomposer14
	beq.w	.future14

	bsr.w	id_oktalyzer
	beq.w	.oktalyzer

	bsr.w	id_tfmxunion
	beq.w	.tfmxunion

	bsr.w	id_TFMX_PRO
	tst	d0
	beq.w	.tfmx

	bsr.w	id_TFMX7V
	tst	d0
	beq.w	.tfmx7

	bsr.w	id_tfmx
	beq.w	.tfmx

	bsr.w	id_hippelcoso
	beq.w	.hippelcoso

	bsr.w	id_soundmon
	beq.w	.soundmon

	bsr.w	id_soundmon3
	beq.w	.soundmon3

	bsr.w	id_digibooster
	beq.w	.digibooster

	bsr.w	id_digiboosterpro
	beq.w	.digiboosterpro

	bsr.w	id_thx
	beq.w	.thx

	bsr.w	id_aon
	beq.w	.aon

	bsr.w	id_player
	beq.w	.player

	move.l	fileinfoblock+8(a5),d0	* Tied.nimen 4 ekaa kirjainta
	bsr.w	id_player2
	beq.w	.player	
	
.mp
	bsr.w	id_ps3m		
	tst.l	d0
	beq.b	.multi

	clr.b	external(a5)
.nope
.nopl

	tst.b	ahi_muutpois(a5)
	bne.b	.er

	bsr.w	id_sid
	beq.w	.sid

	bsr.w	id_oldst
	beq.b	.oldst


.er	moveq	#lod_tuntematon,d0
	rts	

.ex	bsr.w	tee_modnimi
.ex2	
	cmp	#pt_prot,playertype(a5)
	beq.b	.wew
	cmp	#pt_med,playertype(a5)
	beq.b	.wew
	bsr.w	whatgadgets
.wew	moveq	#0,d0
	rts


.nimitalteen
	move.l	moduleaddress(a5),a1
.nimitalteen2
	lea	modulename(a5),a0
.co	move.b	(a1)+,(a0)+
	dbeq	d0,.co
	clr.b	(a0)
	bra.b	.ex2

.oldst	st	oldst(a5)
	bsr.w	convert_oldst
	bra.b	.pro0


.pro	clr.b	oldst(a5)
.pro0	pushpea	p_protracker(pc),playerbase(a5)
	move	#pt_prot,playertype(a5)
	moveq	#20-1,d0
	bra.b	.nimitalteen


.multi	pushpea	p_multi(pc),playerbase(a5)
	move	#pt_multi,playertype(a5)
	bsr.w	siirra_moduuli2		* siirret��n fastiin jos mahdollista

	move.l	moduleaddress(a5),a1	* tutkaillaan onko miss� muistissa
	lore	Exec,TypeOfMem
	and.l	#MEMF_CHIP,d0
	beq.b	.ex2

** Arf! Ladattiin chippiin!
** Onko vehkeess� fastia laisinkaan? Jos on, pistet��n warn-tekstinp�tk�.

	moveq	#MEMF_FAST,d1
	lob	AvailMem
	tst.l	d0
	beq.b	.ex2

	bsr.w	inforivit_warn
	moveq	#65,d1
	lore	Dos,Delay
	bra.w	.ex2



.sid	pushpea	p_sid(pc),playerbase(a5)
	move	#pt_sid,playertype(a5)
	bsr.w	siirra_moduuli2		* siirret��n fastiin jos mahdollista
	bra.w	.ex2



.jam	pushpea	p_jamcracker(pC),playerbase(a5)
	move	#pt_jamcracker,playertype(a5)
	bra.w	.ex

.soundmon
	pushpea	p_soundmon(pc),playerbase(a5)
	move	#pt_soundmon2,playertype(a5)
	moveq	#25-1,d0
	bra.w	.nimitalteen

.soundmon3
	pushpea	p_soundmon3(pc),playerbase(a5)
	move	#pt_soundmon3,playertype(a5)
	moveq	#25-1,d0
	bra.w	.nimitalteen


.future13
	pushpea	p_futurecomposer13(pc),playerbase(a5)
	move	#pt_future10,playertype(a5)
	bra.w	.ex

.future14
	pushpea	p_futurecomposer14(pc),playerbase(a5)
	move	#pt_future14,playertype(a5)
	bra.w	.ex

.deltamusic
	pushpea	p_deltamusic(pc),playerbase(a5)
	move	#pt_delta2,playertype(a5)
	bra.w	.ex

.musicassembler
	pushpea	p_musicassembler(pc),playerbase(a5)
	move	#pt_musicass,playertype(a5)
	bra.w	.ex

.fred	
	move	d5,maxsongs(a5)
	pushpea	p_fred(pc),playerbase(a5)
	move	#pt_fred,playertype(a5)
	bra.w	.ex

.sonicarranger
	pushpea	p_sonicarranger(pc),playerbase(a5)
	move	#pt_sonicarr,playertype(a5)
	bra.w	.ex

.sidmon1
	movem.l	d1/d2,sid10init
	pushpea	p_sidmon1(pC),playerbase(a5)
	move	#pt_sidmon1,playertype(a5)
	bra.w	.ex

.player
	pushpea	p_player(pc),playerbase(a5)
	move	#pt_player,playertype(a5)
	bra.w	.ex

.oktalyzer
	pushpea	p_oktalyzer(pc),playerbase(a5)
	move	#pt_oktalyzer,playertype(a5)
	bra.w	.ex


.med	pushpea	p_med(pc),playerbase(a5)
	move	#pt_med,playertype(a5)
	clr.b	medrelocced(a5)
	bra.w	.ex

.markii	pushpea	p_markii(pc),playerbase(a5)
	move	#pt_markii,playertype(a5)
	bra.w	.ex
	

.mon	move	d5,maxsongs(a5)
	pushpea	p_mon(pc),playerbase(a5)
	move	#pt_mon,playertype(a5)
	bra.w	.ex

.dw	move	d5,maxsongs(a5)
	move.l	d6,whittaker_end
	pushpea	p_dw(pc),playerbase(a5)
	move	#pt_dw,playertype(a5)
	bra.w	.ex

.hippelcoso
	move	d5,maxsongs(a5)
	pushpea	p_hippelcoso(pc),playerbase(a5)
	move	#pt_hippelcoso,playertype(a5)
	bra.w	.ex

.hippel
	move	d5,maxsongs(a5)
	move.l	d4,hippelmusic
	pushpea	p_hippel(pc),playerbase(a5)
	move	#pt_hippel,playertype(a5)
	bra.w	.ex


.digibooster
	pushpea	p_digibooster(pc),playerbase(a5)
	move	#pt_digibooster,playertype(a5)
	bsr.w	siirra_moduuli2		* siirret��n fastiin jos mahdollista
	lea	610(a4),a1
	moveq	#30-1,d0
	bra.w	.nimitalteen2


.digiboosterpro
	pushpea	p_digiboosterpro(pc),playerbase(a5)
	move	#pt_digiboosterpro,playertype(a5)
	bsr.w	siirra_moduuli2		* siirret��n fastiin jos mahdollista
	lea	16(a4),a1
	moveq	#42-1,d0
	bra.w	.nimitalteen2


.thx
	pushpea	p_thx(pc),playerbase(a5)
	move	#pt_thx,playertype(a5)
	bsr.w	siirra_moduuli2		* siirret��n fastiin jos mahdollista

	move.l	moduleaddress(a5),a1
	add	4(a1),a1		* modulename
	moveq	#25-1,d0
	bra.w	.nimitalteen2

.mline
	pushpea	p_mline(pc),playerbase(a5)
	move	#pt_mline,playertype(a5)
	bra.w	.ex

.aon
	pushpea	p_aon(pc),playerbase(a5)
	move	#pt_aon,playertype(a5)
	bra.w	.ex



**** Oliko  sample??
.sample
	pushpea	p_sample(pC),playerbase(a5)
	move	#pt_sample,playertype(a5)
	bra.w	.ex



** Yhdistetty TFMX formaatti

.tfmxunion
	moveq	#0,d7
	moveq	#$7f,d0
	and.b	8(a4),d0		*  tyyppi
	cmp.b	#3,d0
	beq.b	.t7
	moveq	#1,d7
.t7	bra.w	.ok



* TFMX onkin hankalampi homma..

.tfmx7	moveq	#0,d7
	bra.b	.t	

.tfmx	moveq	#1,d7
.t	
	moveq	#0,d0

	lea	fileinfoblock+8(a5),a0		* tied.nimi: mdat.*
	cmp.l	#'MDAT',(a0)
	beq.b	.uq
	cmp.l	#'mdat',(a0)
	bne.b	.qo
.uq	cmp.b	#'.',4(a0)
	beq.b	.ook


.qo	tst.b	(a0)+			* tied.nimi: *.mdat
	bne.b	.qo
	subq	#1,a0
	moveq	#0,d0
	move.b	-(a0),d0
	rol.l	#8,d0
	move.b	-(a0),d0
	rol.l	#8,d0
	move.b	-(a0),d0
	rol.l	#8,d0
	move.b	-(a0),d0
	and.l	#$dfdfdfdf,d0
	cmp.l	#'TADM',d0	* MDAT nurinp�i
	bne	.er
	cmp.b	#'.',-(a0)
	bne	.er

.ook
	
	lea	-150(sp),sp		* tied nimi stackkiin
	move.l	sp,a1

	tst.b	lod_archive(a5)		* archivesta?
	beq.b	.pin
	lea	lod_buf(a5),a0
	bra.b	.cop

.pin	move.l	modulefilename(a5),a0
.cop	move.b	(a0)+,(a1)+
	bne.b	.cop

	lea	(sp),a0
.leep	lea	.tfmxid(pc),a1			* Etsit��n nimest� 'mdat'
.luup	move.b	(a1)+,d1
	beq.b	.olioikea
	move.b	(a0)+,d0
	beq.w	.er
	bset	#5,d0			* pieneksi kirjaimeksi	
	cmp.b	d1,d0
	bne.b	.leep
	bra.b	.luup
.olioikea

	;subq.l	#1,a0			* muunnetaan 'smpl'
	move.b	#'l',-(a0)
	move.b	#'p',-(a0)
	move.b	#'m',-(a0)
	move.b	#'s',-(a0)

	lea	(sp),a1
* KPK 2016: removed debug requester when loading
* TFMX module
*	bsr	request		

	bsr.w	inforivit_tfmxload

	clr.b	lod_tfmx(a5)

	move.b	lod_archive(a5),d6


	lea	(sp),a0
	moveq	#MEMF_CHIP,d0
	lea	tfmxsamplesaddr(a5),a1
	lea	tfmxsampleslen(a5),a2
	moveq	#1,d1			* Ei oteta filen kommenttia talteen
	move.b	xpkid(a5),d4		* ei XPK ID:t� samplefileille
	st	xpkid(a5)
	bsr.w	loadfile
	move.b	d4,xpkid(a5)
	move.l	d0,-(sp)

;	tst.b	lod_archive(a5)
	tst.b	d6
	beq.b	.bar
	bsr.w	remarctemp
.bar

	bsr.w	inforivit_clear

	move.l	(sp)+,d0
	lea	150(sp),sp
	tst.l	d0
	beq.b	.ok
	rts
	
.ok	pushpea	p_tfmx(pc),playerbase(a5)
	move	#pt_tfmx,playertype(a5)
	tst	d7
	bne.w	.ex
	pushpea	p_tfmx7(pc),playerbase(a5)
	move	#pt_tfmx7,playertype(a5)
	bra.w	.ex

;.tfmxid	dc.b	"mdat.",0
.tfmxid		dc.b	"mdat",0
 even

*******************************************************************
* Formaattien tunnistusrutiinit
*
* Parametrit: 
* D7 <= moduulin pituus (tai tutkittavan alueen pituus)
* A4 <= moduulin osoite (tutkittavan alueen osoite)
*
*
* Tulos:
* D0 => 0 jos moduuli on tunnettu
* D0 => -1 jos moduuli ei tunnetti
* 
* Jotkut palauttavat my�s muuta informaatiota rekistereiss�,
* kuten D5 => maxsong
*
 



id_med	move.l	(a4),d0			* MED
	lsr.l	#8,d0
	cmp.l	#'MMD',d0

idtest	beq.b	.y
	moveq	#-1,d0
	rts
.y	moveq	#0,d0
	rts

id_musicassembler
	lea	.muass_id(pc),a1	* Music Assembler
	moveq	#.muassend-.muass_id,d0
	bsr.w	search
	bra.b	idtest


.muass_id
	dc.b	"usa-team 89"
.muassend
 even

id_sonic
	lea	.sonicid(pc),a1		* SonicArranger
	moveq	#.sonice-.sonicid,d0
	bsr.w	search
	bra.b	idtest


.sonicid
	dc.b	"musicirq",0
.sonice
 even


id_deltamusic
	lea	.delta_id(pc),a1	* Delta Music 2
	moveq	#.delend-.delta_id,d0
	bsr.w	search
	bra.b	idtest

.delta_id
	dc.b	"DELTA MUSIC"
.delend
 even


id_jamcracker
	cmp.l	#'BeEp',(a4)		* JamCracker
	bra.b	idtest

id_futurecomposer13
	cmp.l	#'SMOD',(a4)		* Futurecomposer 1.0-1.3
	bra.b	idtest

id_futurecomposer14
	cmp.l	#'FC14',(a4)		* Futurecomposer 1.4
	bra.b	idtest

id_oktalyzer
	cmp.l	#'OKTA',(a4)		* Oktalyzer
	bne.b	.nok
	cmp.l	#'SONG',4(a4)
	bra.b	idtest

.nok	moveq	#-1,d0
	rts


id_tfmxunion
	cmp.l	#'TFHD',(a4)		* Yhdistetty TFMX formaatti
	bra.w	idtest


id_tfmx
	cmp.l	#"TFMX",(a4)
	beq.b	.y
	cmp.l	#"tfmx",(a4)
	bra.w	idtest

.y	moveq	#0,d0
	rts
	

id_soundmon
	move.l	26(a4),d0		* Soundmon
	lsr.l	#8,d0
	cmp.l	#'V.2',d0
	bra.w	idtest


id_soundmon3
	move.l	26(a4),d0		* Soundmon
	lsr.l	#8,d0
	cmp.l	#'V.3',d0
	beq.b	.y
	cmp.l	#'BPS',d0
	bra.w	idtest

.y	moveq	#0,d0
	rts


id_digibooster
	cmp.l	#'DIGI',(a4)
	bne.b	.nd
	cmp.l	#' Boo',4(a4)
	bne.b	.nd
	cmp.l	#'ster',8(a4)
	bra.w	idtest

.nd	moveq	#-1,d0
	rts

id_digiboosterpro
	cmp.l	#'DBM0',(a4)
	bra.w	idtest

id_thx
	move.l	(a4),d0			* THX
	lsr.l	#8,d0
	cmp.l	#"THX",d0
	bra.w	idtest

id_aon
	cmp.l	#"AON4",(a4)		* aon 4 channel
	bra.w	idtest

id_mline
	cmp.l	#"MLED",(a4)		* musicline editor
	bne.b	.nd
	cmp.l	#"MODL",4(a4)
	bra.w	idtest

.nd	moveq	#-1,d0
	rts
	


id_player
 	cmp.l	#'P61A',(a4)		* The player 6.1a
	bra.w	idtest

id_player2				* filename <= D0
	and.l	#$dfffffff,d0
	cmp.l	#'P61.',d0
	bra.w	idtest
	


id_protracker
	cmp.l	#'M.K.',1080(a4)	* Protracker
	beq.b	.p	
	cmp.l	#'M!K!',1080(a4)	* Protracker 100 patterns
	beq.b	.p	
	cmp.l	#'FLT4',1080(a4)	* Startrekker
	bra.w	idtest

.p	moveq	#0,d0
	rts


id_fred
* d5 => maxsongs
	move.l	a4,a0
	moveq	#-1,d0				; Modul nicht erkannt (default)
	cmpi.w	#$4efa,(a0)
	bne.s	.ChkEnd
	cmpi.w	#$4efa,$04(a0)
	bne.s	.ChkEnd
	cmpi.w	#$4efa,$08(a0)
	bne.s	.ChkEnd
	cmpi.w	#$4efa,$0c(a0)
	bne.s	.ChkEnd
	add.w	2(a0),a0
	moveq	#4-1,d1
.ChkLoop cmpi.w	#$123a,2(a0)
	bne.s	.ChkNext
	cmpi.w	#$b001,6(a0)
	beq.s	.ChkSong
.ChkNext addq.l	#2,a0
	dbra	d1,.ChkLoop
	bra.s	.ChkEnd				; Modul nicht erkannt
.ChkSong add.w	4(a0),a0
	moveq	#0,d5
	move.b	4(a0),d5
	moveq	#0,d0				; Modul erkannt
.ChkEnd	tst.l	d0
	rts




id_sidmon1
* d1 => sid10init
* d2 => sid10music

	move.l	a4,a0

	moveq	#-$01,d0
	cmpi.l	#$08f90001,(a0)
	bne.b	.l_f218
	cmpi.l	#$00bfe001,$0004(a0)
.l_f1f6	bne.b	.l_f218
	cmpi.w	#$4e75,$025c(a0)
	beq.b	.l_f20e
	cmpi.w	#$4ef9,$025c(a0)
	bne.b	.l_f218
	move.w	#$4e75,$025c(a0)
.l_f20e	moveq	#$2c,d1
	move.l	#$0000016a,d2
	bra.b	.l_f266
.l_f218	cmpi.w	#$41fa,(a0)
	bne.b	.l_f278
	cmpi.w	#$d1e8,$0004(a0)
	bne.b	.l_f278
	cmpi.w	#$4e75,$0230(a0)
	beq.b	.l_f23e
	cmpi.w	#$4ef9,$0230(a0)
	bne.b	.l_f248
	move.w	#$4e75,$0230(a0)
.l_f23e	moveq	#$00,d1
	move.l	#$0000013e,d2
	bra.b	.l_f266
.l_f248	cmpi.w	#$4e75,$029c(a0)
	beq.b	.l_f25e
	cmpi.w	#$4ef9,$029c(a0)
	bne.b	.l_f278
	move.w	#$4e75,$029c(a0)
.l_f25e	moveq	#$00,d1
	move.l	#$0000016a,d2
.l_f266	moveq	#$00,d0
	add.l	a0,d1		* init
	add.l	a0,d2		* music
;	movem.l	d1/d2,sid10init
.l_f278	tst.l	d0
	rts	


id_markii
	moveq.l	#-1,d0

	cmp	#$48e7,(a4)
	bne.b	.eim
	cmp	#$41fa,4(a4)	
	bne.b	.eim
	cmp	#$4cd8,8(a4)
	bne.b	.eim
	cmp.l	#$0c0000ff,12(a4)
	beq.b	.joom
.eim

	lea	.lbw000106(pc),a1
.lbc0000ea
	move.w	(a1)+,d1
	beq.s	.lbc000104
	cmp.l	#$2e5a4144,$0000(a4,d1.w)
	bne.s	.lbc0000ea
	cmp.l	#$5338392e,$0004(a4,d1.w)
	bne.s	.lbc0000ea
.joom	moveq.l	#0,d0
.lbc000104
	tst.l	d0
	rts	
.lbw000106	dc.w	$02a0,$033c,$0348,0


id_maniacsofnoise
* d5 => max songs

	move.l	a4,a0
;	move.l	modulelength(a5),d1
	move.l	d7,d1

	moveq.l	#-1,d0
	cmp.w	#$4efa,(a0)
	bne.s	.o0001a8
	cmp.w	#$4efa,4(a0)
	bne.s	.o0001a8
	cmp.w	#$4efa,8(a0)
	bne.s	.o0001a8
	cmp.w	#$4efa,12(a0)
	beq.s	.o0001a8
.o00015e	cmp.w	#$4bfa,0(a0)
	bne.s	.o000182
	cmp.w	#$0280,4(a0)
	bne.s	.o000182
	cmp.l	#$000000ff,6(a0)
	bne.s	.o000182
	cmp.l	#$5300b02d,$0014(a0)
	beq.s	.o00018a
.o000182	addq.l	#2,a0
	subq.l	#2,d1
	bpl.s	.o00015e
	bra.s	.o0001a8
 
.o00018a	move.w	2(a0),d1
	lea	0(a0,d1.w),a1
	move.w	$0018(a0),d1
	lea	0(a1,d1.w),a1
	moveq.l	#0,d0
	move.b	2(a1),d0
	subq	#1,d0
	move.w	d0,d5
	moveq.l	#0,d0
.o0001a8
	tst.l	d0
	rts	


id_davidwhittaker
* d5 => maxsongs
* d6 => whittaker_end

	move.l	a4,a0
;	move.l	moduleaddress(a5),d0
	move.l	a0,d0

	cmp.w	#$48e7,(a0)
	bne.s	.wc000130
	cmp.w	#$6100,4(a0)
	bne.s	.wc000130
	cmp.w	#$4cdf,8(a0)
	bne.s	.wc000130
	cmp.w	#$4e75,12(a0)
	bne.s	.wc000130
	cmp.w	#$48e7,14(a0)
	bne.s	.wc000130
	cmp.w	#$6100,$0012(a0)
	bne.s	.wc000130
	cmp.w	#$4cdf,$0016(a0)
	bne.s	.wc000130
	cmp.w	#$4e75,$001a(a0)
	beq.s	.wc000136
.wc000130	moveq.l	#-1,d0
	bra.w	.wc0001de
 
.wc000136	moveq.l	#$1c,d1
	add.l	d1,a0
	sub.l	d1,d0
.wc00013c	cmp.w	#$43fa,(a0)
	bne.s	.wc000154
	cmp.l	#$4880c0fc,4(a0)
	bne.s	.wc000154
	cmp.w	#$41fa,10(a0)
	beq.s	.wc00015c
.wc000154	addq.l	#2,a0
	subq.l	#2,d0
	bpl.s	.wc00013c
	bra.s	.wc000130
 
.wc00015c	move.l	a0,a1
	move.l	d0,d1
.wc000160	cmp.w	#$47fa,(a1)
	bne.s	.wc000186
	cmp.w	#$51eb,4(a1)
	bne.s	.wc000186
	cmp.w	#$51eb,8(a1)
	beq.s	.wc00018e
	cmp.w	#$33fc,8(a1)
	beq.s	.wc00018e
	cmp.w	#$426b,8(a1)
	beq.s	.wc00018e
.wc000186	addq.l	#2,a1
	subq.l	#2,d1
	bpl.s	.wc000160
	bra.s	.wc000130
 
.wc00018e	move.l	a1,d6
	move.w	2(a1),d1
	lea	-10(a1,d1.w),a1
	move.l	a0,d1
	sub.l	a1,d1
	move.w	12(a0),d2
	moveq.l	#0,d3
	move.w	#$7fff,d4
	moveq.l	#-1,d5
.wc0001ac	move.w	8(a0),d0
	lsr.w	#1,d0
	subq.w	#1,d0
	addq.w	#2,d2
.wc0001b6	move.w	12(a0,d2.w),d3
	btst	#0,d3
	bne.s	.wc0001d6
	sub.w	d1,d3
	cmp.w	d4,d3
	bge.s	.wc0001c8
	move.w	d3,d4
.wc0001c8	cmp.w	d4,d2
	bge.s	.wc0001d6
	addq.w	#2,d2
	subq.w	#1,d0
	bne.s	.wc0001b6
	addq.l	#1,d5
	bra.s	.wc0001ac
 
.wc0001d6	
	;move.w	d5,maxsongs(a5)	* songit
	moveq.l	#0,d0
.wc0001de
	tst.l	d0
	rts	
 



; Testet, ob es sich um ein Hippel-COSO-Modul handelt

id_hippelcoso
* d5 => max songs

;	move.l	dtg_ChkData(a5),a0		; ^module
	move.l	a4,a0

	cmpi.l	#"COSO",$00(a0)			; test ID
	bne.b	.ChkFail
	cmpi.l	#"TFMX",$20(a0)			; test ID
	bne.s	.ChkFail

	move.l	$1c(a0),d0
	sub.l	$18(a0),d0
	bmi.s	.ChkFail				; table corrupt !
	divu	#10,d0
	swap	d0
	tst.w	d0				; multiple of 10 ?
	bne.s	.ChkFail				; no !
	swap	d0
	subq.w	#1,d0
	beq.s	.ChkFail				; sampletable is empty !
	move.l	a0,a1
	add.l	$18(a0),a1			; ^sampletable
	move.l	a1,a2
	moveq	#0,d2
.Chkoop move.l	(a1),d1				; ^samplestart
	cmp.l	d2,d1
	ble.b	.Chkext
	move.l	d1,d2
	move.l	a1,a2
.Chkext add.w	#10,a1				; next sample
	subq.l	#1,d0
	bne.s	.Chkoop

	move.l	$1c(a0),d0			; ^samples
	move.l	d0,d1
	add.l	(a2)+,d1			; get samplestart
	moveq	#0,d2
	move.w	(a2)+,d2			; get samplelength
	add.l	d2,d2
	add.l	d2,d1
	addq.l	#4,d1				; 4 bytes null-sample


;	move.l	modulelength(a5),d2

;	cmp.l	d1,d2
;;	slt	LoadSamp			; set load-samples flag
;	blt.b	.ChkFail		* ei hyv�ksyt� modeja joissa erilliset samplet


;	add.l	#1024,d1
;	cmp.l	d0,d2				; test size of module
;	blt.s	.ChkFail				; too small
;	cmp.l	d1,d2				; test size of module
;	bgt.s	.ChkFail				; too big

	move.l	$18(a4),d0
	sub.l	$14(a4),d0
	divu	#6,d0
	subq.w	#2,d0
	move.w	d0,d5				; store MaxSong
	moveq	#0,d0				; Modul erkannt

	bra.s	.Chknd
.ChkFail
	moveq	#-1,d0				; Modul nicht erkannt
.Chknd
	tst.l	d0
	rts


id_hippel
* d7 <= modlen
* a4 <= mod
* d4 => hippel music 
* d5 => max songs
	move.l	d7,d0

	cmp.l	#100,d0
	blo.w	.lbC000288

	move.l	a4,a0
	move.l	a4,a1
	add.l	d0,a1
	lea	$10(a0),a0
.loop	addq	#1,a0	
	cmp.l	a0,a1
	beq.w	.ChkFail
	cmp.b	#"T",(a0)
	bne.b	.loop
	cmp.b	#"F",1(a0)
	bne.b	.loop
	cmp.b	#"M",2(a0)
	bne.b	.loop
	cmp.b	#"X",3(a0)
	bne.b	.loop

	move.l	a4,a1
	move.l	a1,a0
	move.l	d7,d0

	cmp.w	#$6000,(a1)
	bne.s	.lbC000156
	addq.w	#2,a1
	move.w	(a1),d1
	bmi.s	.lbC0001B6
	btst	#0,d1
	bne.s	.lbC0001B6
	add.w	d1,a1
	bra.s	.lbC00016E
 
.lbC000156	cmp.b	#$60,(a1)
	bne.s	.lbC0001B6
	move.b	1(a1),d1
	ext.w	d1
	bmi.s	.lbC0001B6
	btst	#0,d1
	bne.s	.lbC0001B6
	add.w	d1,a1
	addq.w	#2,a1
.lbC00016E	addq.w	#4,a1
	cmp.w	#$6100,(a1)
	bne.s	.lbC000186
	addq.w	#2,a1
	move.w	(a1),d1
	bmi.s	.lbC0001B6
	btst	#0,d1
	bne.s	.lbC0001B6
	add.w	d1,a1
	bra.s	.lbC00018E
 
.lbC000186	cmp.w	#$41FA,(a1)
	bne.s	.lbC0001B6
	addq.w	#4,a1
.lbC00018E	addq.w	#2,a1
	cmp.w	#$6100,(a1)+
	bne.s	.lbC0001B6
	move.w	(a1),d1
	bmi.s	.lbC0001B6
	btst	#0,d1
	bne.s	.lbC0001B6
	add.w	d1,a1
	cmp.w	#$41FA,(a1)+
	bne.s	.lbC0001B6
	move.w	(a1),d1
	bmi.s	.lbC0001B6
	btst	#0,d1
	bne.s	.lbC0001B6
	add.w	d1,a1
	clr.w	(a1)
.lbC0001B6	cmp.b	#$60,(a0)
	bne.s	.lbC0001D0
	cmp.b	#$60,2(a0)
	bne.s	.lbC0001D0
	cmp.w	#$48E7,4(a0)
	bne.s	.lbC0001D0
	addq.l	#2,a0
	bra.s	.lbC00022C
 
.lbC0001D0	cmp.b	#$60,(a0)
	bne.s	.lbC0001EA
	cmp.b	#$60,2(a0)
	bne.s	.lbC0001EA
	cmp.w	#$41FA,4(a0)
	bne.s	.lbC0001EA
	addq.l	#2,a0
	bra.s	.lbC00022C
 
.lbC0001EA	cmp.w	#$6000,(a0)
	bne.s	.lbC000204
	cmp.w	#$6000,4(a0)
	bne.s	.lbC000204
	cmp.w	#$48E7,8(a0)
	bne.s	.lbC000204
	addq.l	#4,a0
	bra.s	.lbC00022C
 
.lbC000204	cmp.w	#$6000,(a0)
	bne.s	.lbC000288
	cmp.w	#$6000,4(a0)
	bne.s	.lbC000288
	cmp.w	#$6000,8(a0)
	bne.s	.lbC000288
	cmp.w	#$6000,12(a0)
	bne.s	.lbC000288
	cmp.w	#$48E7,$0010(a0)
	bne.s	.lbC000288
	addq.l	#4,a0
.lbC00022C	move.l	a0,d4
	move.w	#$007F,d1
.lbC000236	cmp.w	#$41FA,(a0)+
	bne.s	.lbC00026C
	move.w	(a0),d2
	bmi.s	.lbC00026C
	btst	#0,d2
	bne.s	.lbC00026C
	cmp.w	#$4000,d2
	bcc.s	.lbC00026C
	cmp.l	#'TFMX',$0000(a0,d2.w)
	bne.s	.lbC00025C
	move.w	$0010(a0,d2.w),d3
	bra.s	.lbC000274
 
.lbC00025C	cmp.l	#'COSO',$0000(a0,d2.w)
	bne.s	.lbC00026C
	move.w	#$00FF,d3
	bra.s	.lbC000274
 
.lbC00026C	subq.l	#2,d0
	dbmi	d1,.lbC000236
	bra.s	.lbC000288
 
.lbC000274
	subq.b	#1,d3
	move.w	d3,d5
	moveq	#0,d0
	rts	

.lbC000288
.ChkFail
	moveq.l	#-1,d0
	rts	




id_TFMX_PRO	
	move.l	a4,a1
	lea	TFMX_IDs(pc),a0
.id_loop
	tst.b	(a0)
	beq.b	.Not_TFMX_PRO
	move.l	a4,a1		;Module
.strloop
	tst.b	(a0)
	beq.s	.found
	cmpm.b	(a0)+,(a1)+
	beq.s	.strloop
.skiploop
	tst.b	(a0)+
	bne.s	.skiploop
	bra.s	.id_loop
.found
	move.l	a4,a0	;Module
	move.w	$100(a0),d0
	move.l	$1D0(a0),d1
	bne.s	.valid
	move.l	#$800,d1
.valid
	add.l	d1,a0	;Channel table
	moveq	#0,d1
	moveq	#0,d3	;Start as TFMX Pro
.chanloop
	move.w	d0,d2	;Channel number
	lsl.w	#4,d2
	move.l	a0,a2
	add.w	d2,a2	;Channel pointer
	move.w	(a2)+,d2	;Channel number
	cmp.w	#$EFFE,d2	;End mark
	bne.s	.done
	move.w	(a2)+,d2	;Channel type
	add.w	d2,d2
	cmp.w	#10,d2
	blo.s	.notover10
	moveq	#0,d2
	moveq	#0,d3	;Is TFMX Pro
.notover10
	jmp	.JTab(pc,d2.w)
.JTab
	bra.s	.done
	bra.s	.test
	bra.s	.next
	bra.s	.probably_not
	bra.s	.next
.test
	tst.w	d1	;Flip-flop?
	beq.s	.start
	bmi.s	.channum
	bra.s	.chan
.start
	move.w	#$FFFF,d1
	addq.w	#1,d0	;Next channel
	bra.s	.chanloop
.channum
	move.w	2(a2),d1
.chan
	subq.w	#1,d1
	move.w	(a2),d0	;Paired channel?
	bra.s	.chanloop
.probably_not
	moveq	#-1,d3
.next
	addq.w	#1,d0	;Next Channel
	bra.s	.chanloop
.done
	tst.l	d3
	bne.s	.Not_TFMX_PRO
	moveq	#0,d0	;Identified!
	bra.s	.exit
.Not_TFMX_PRO
	moveq	#-1,d0
.exit
	rts

TFMX_IDs
	dc.b	'tfmxsong',0
	dc.b	'TFMX-SONG',0
	dc.b	'TFMX_SONG',0,0



id_TFMX7V
	move.l	a4,a1
	lea	TFMX_IDs(pc),a0
.idloop
	tst.b	(a0)
	beq.b	.Not_TFMX7V
	move.l	a4,a1
.strloop
	tst.b	(a0)
	beq.s	.validID
	cmpm.b	(a0)+,(a1)+
	beq.s	.strloop
.skiploop
	tst.b	(a0)+
	bne.s	.skiploop
	bra.s	.idloop
.validID
	move.l	a4,a0
	move.w	$100(a0),d0
	move.l	$1D0(a0),d1
	bne.s	.valid
	move.l	#$800,d1
.valid
	add.l	d1,a0
	moveq	#0,d1
	moveq	#0,d3
.chanloop
	move.w	d0,d2
	lsl.w	#4,d2
	move.l	a0,a2
	add.w	d2,a2
	move.w	(a2)+,d2
	cmp.w	#$EFFE,d2
	bne.s	.done
	move.w	(a2)+,d2
	add.w	d2,d2
	cmp.w	#10,d2
	blo.s	.intable
	moveq	#0,d2
	moveq	#0,d3
.intable
	jmp	.JTab(pc,d2.w)
.JTab
	bra.s	.done
	bra.s	.check
	bra.s	.next
	bra.s	.probably_not
	bra.s	.next
.check
	tst.w	d1
	beq.s	.norm
	bmi.s	.paired
	bra.s	.chan
.norm
	move.w	#$FFFF,d1
	addq.w	#1,d0
	bra.s	.chanloop
.paired
	move.w	2(a2),d1
.chan
	subq.w	#1,d1
	move.w	(a2),d0
	bra.s	.chanloop
.probably_not
	moveq	#-1,d3
.next
	addq.w	#1,d0
	bra.s	.chanloop
.done
	tst.l	d3
	beq.s	.Not_TFMX7V
	moveq	#0,d0	;Identified!
	bra.s	.exit
.Not_TFMX7V
	moveq	#-1,d0
.exit
	rts



keyfilename	dc.b	"L:HippoPlayer.Key",0
 even

*******
* Tunnistetaan SID piisit
*******

id_sid1
	cmp.l	#"PSID",(a4)
	beq.b	.q
	moveq	#-1,d0
	rts
.q	moveq	#0,d0
	rts

id_sid
	bsr.b	id_sid1
	beq.w	.yea

	move.l	modulefilename(a5),a0
	lea	desbuf(a5),a1
	move.l	a1,a2
.c	move.b	(a0)+,(a1)+
	bne.b	.c
	subq.l	#1,a1
	move.b	#'.',(a1)+
	move.b	#'i',(a1)+
	move.b	#'n',(a1)+
	move.b	#'f',(a1)+
	move.b	#'o',(a1)+
	clr.b	(a1)

	move.l	a2,d1			* avataan_ikoni
	move.l	#1005,d2
	lore	Dos,Open
	move.l	d0,d5
	beq.b	.no

	lea	probebuffer(a5),a0	* luetaan ikoni
	move.l	a0,d2
	move.l	#1000,d3			* 1000 bytee
	move.l	d5,d1
	lob	Read
	move.l	d5,d1
	lob	Close

* tutkitaan onko playsidin ikoni.

	lea	probebuffer(a5),a0
	move	#1000,d2

.leep	lea	.id1(pc),a1
.luup	move.b	(a1)+,d1
	beq.b	.yea
	move.b	(a0)+,d0
	subq	#1,d2
	beq.b	.no
	btst	#5,d1
	beq.b	.cl
	bset	#5,d0
	bra.b	.cll
.cl	bclr	#5,d0
.cll	cmp.b	d1,d0
	bne.b	.leep
	bra.b	.luup

.no	moveq	#-1,d0
	rts
.yea	moveq	#0,d0
	rts

.id1	dc.b	"PLAYSID",0
.ide1
 even


*******
* Tunnistetaan Old Soundtracker piisit (15 samplea). Tarttee n. 1700 byte�
*******
id_oldst

*** Tarkistetaan onko samplejen arvot moduulille sopivat
	lea	20(a4),a0
	moveq	#0,d0
	move	#$7fff,d2
	moveq	#15-1,d1
.l1
	cmp	22(a0),d2	* samplelen
	blo.w	.fail
	cmp	#1,22(a0)
	bhi.b	.f0
	addq	#1,d0
.f0
	cmp.b	#64,25(a0)	* volume
	bhi.w	.fail	
	cmp	26(a0),d2	* repeat point
	blo.b	.fail
	cmp	28(a0),d2	* repeat length
	blo.b	.fail
	lea	30(a0),a0
	dbf	d1,.l1
	
	cmp	#15,d0
	beq.b	.fail


* a0 = songlen
	tst.b	(a0)
	beq.b	.fail
	cmp.b	#$7f,(a0)
	bhi.b	.fail
	addq	#2,a0	

***** Ovatko postablen arvot oikeita (0-63)?

	moveq	#128-1,d0
	moveq	#0,d1
.l2	tst.b	(a0)
	beq.b	.l22
	addq	#1,d1
.l22	cmp.b	#63,(a0)+
	bhi.b	.fail
	dbf	d0,.l2

	tst	d1
	beq.b	.fail


* a0 = patterndata

*** Tarkistetaan eka patterni

	move	#4*64-1,d3
.l3
	move	(a0)+,d0
	move	(a0)+,d1

	move	d0,d2
	and	#$f000,d2		* pit�s olla tyhj��
	bne.b	.fail

	move	d1,d2			* tutkaillaan komentoa
	and	#$0f00,d2		* sallittuja: 0-4, a-f
	cmp	#$0400,d2
	bls.b	.oks
	cmp	#$0a00,d2
	blo.b	.fail

.oks

	move	d1,d2			* onko samplea?
	and	#$f000,d2
	beq.b	.noper


	and	#$fff,d0		* period
	beq.b	.noper
	cmp	#856,d0
	bhi.b	.fail
	cmp	#113,d0
	blo.b	.fail	
.noper
	dbf	d3,.l3

	moveq	#0,d0
	rts

.fail	moveq	#-1,d0
	rts

convert_oldst

*******
* Muutetaan PT-formaattiin
* a4 <= moduuli

	move.l	modulelength(a5),d0
	add.l	#484,d0
	move.l	#MEMF_CHIP!MEMF_CLEAR,d1
	lore	Exec,AllocMem
	tst.l	d0
	beq.b	.fail
	move.l	d0,a3

	lea	(a4),a0
	lea	(a3),a1
	move	#470/2-1,d0
.c1	move	(a0)+,(a1)+
	dbf	d0,.c1

	lea	16*30(a1),a1		* 16 tyhj�� samplee

	moveq	#(128+1+1)/2-1,d0
.c2	move	(a0)+,(a1)+
	dbf	d0,.c2
	move.l	#"M.K.",(a1)+

	move.l	a4,a2
	add.l	modulelength(a5),a2
.c3	move.b	(a0)+,(a1)+
	cmp.l	a2,a0
	bne.b	.c3

	move.b	#$7f,951(a3)

	lea	20(a3),a0		* repeat pointer jaetaan kahdella
	moveq	#$f-1,d0
.f	lsr	#1,26(a0)
	lea	30(a0),a0
	dbf	d0,.f

	move.l	moduleaddress(a5),a1
	move.l	modulelength(a5),d0
	lore	Exec,FreeMem

	move.l	a3,moduleaddress(a5)
	add.l	#484,modulelength(a5)

	moveq	#0,d0			* on oikee moduuli
	rts

.fail	moveq	#-1,d0
	rts






*******
* Virittelee nimen tied.nimest�
*******
tee_modnimi
	lea	modulename(a5),a1

	tst.b	lod_archive(a5)		* Paketista purettuna
	beq.b	.eiarc			* otetaan pelkk� filename
	move.l	solename(a5),a0
	bra.b	.copy

.eiarc
	lea	8+fileinfoblock(a5),a0
	move.l	a0,a2
.loop	move.b	(a0)+,d0
	beq.b	.ee
	cmp.b	#'.',d0
	bne.b	.loop
	move.l	a0,d1
	sub.l	a2,d1
	cmp	#4+1,d1
	bhi.b	.ee		* onko etuliite pitempi kuin 4 merkki�

.copy	move.b	(a0)+,(a1)+
	bne.b	.copy
	rts
.ee	move.l	a2,a0
	bra.b	.copy



*******************************************************************************
* Lataa ulkoisen soittorutiinirykelm�n
*******

loadplayergroup
	pushm	d1-a6

	bsr.w	inforivit_group

	moveq	#0,d7

	move.l	_DosBase(a5),a6
	pushpea	groupname(a5),d1
	move.l	#1005,d2
	lob	Open
	move.l	d0,d4
	beq.b	.error

	move.l	d4,d1		* selvitet��n filen pituus
	moveq	#0,d2	
	moveq	#1,d3
	lob	Seek
	move.l	d4,d1
	moveq	#0,d2	
	moveq	#1,d3
	lob	Seek
	move.l	d0,d5

	move.l	d4,d1		* alkuun
	moveq	#0,d2
	moveq	#-1,d3
	lob	Seek

	move.l	d5,d0
	moveq	#MEMF_PUBLIC,d1
	jsr	getmem
	move.l	d0,d7
	beq.b	.error

	move.l	d4,d1
	move.l	d7,d2
	move.l	d5,d3
	lob	Read
	cmp.l	d5,d0
	bne.b	.er

	move.l	d7,a0
	cmp.l	#"HiPx",(a0)
	beq.b	.x

.er
	move.l	d7,a0
	jsr	freemem
	bra.b	.error

.x	move.l	d4,d1
	beq.b	.xx
	lob	Close	

	move.l	d7,a0		* onko oikee versio??

	cmp.b	#xpl_versio,4+3(a0)
	bhs.b	.xx

	move.l	d7,a0
	jsr	freemem
	moveq	#0,d7

.xx	
	bsr.w	inforivit_clear

	move.l	d7,d0
	popm	d1-a6
	rts

.error	moveq	#0,d7
	bra.b	.x


* lataa yksitt�isen replayerin playergroupista
* d1 = muistin tyyppi

loadreplayer
	pushm	d1-d6/a0/a2-a6
	move.l	d6,a4				* muistin tyyppi!

	move.l	externalplayers(a5),a0		* grouppi poies
	jsr	freemem
	clr.l	externalplayers(a5)

	move	playertype(a5),d0		* onko jo sama ladattuna?
	cmp.b	xtype(a5),d0
	bne.b	.jou
	move.l	xplayer(a5),a1			* osoite a1:een
	move.l	xlen(a5),d7
	moveq	#1,d0
	popm	d1-d6/a0/a2-a6
	rts

.jou
	move.b	d0,xtype(a5)
	
	move.l	xplayer(a5),a0			* vapautetaan vanha 
	jsr	freemem
	clr.l	xplayer(a5)

	bsr.w	inforivit_group2

	move.l	_DosBase(a5),a6
	pushpea	groupname(a5),d1
	move.l	#1005,d2
	lob	Open
	move.l	d0,d4
	beq.w	.error

	move.l	d4,d1
;	move.l	#probebuffer+var_b,d2
	pushpea	probebuffer+1024(a5),d2
	move.l	#450,d3
	lob	Read
	cmp.l	#450,d0
	bne.w	.error	

	cmp.b	#xpl_versio,7+probebuffer+1024(a5)
	blo.w	.error

	lea	probebuffer+8+1024(a5),a0
	move	playertype(a5),d0
	sub	#xpl_offs,d0
	move	d0,d1
	add	d1,d1
	
	lsl	#3,d0

	movem.l	(a0,d0),d2/d6	* player offset, length
	tst.l	d2
	beq.b	.error		* Onko koko playeri� filess�?

* d3k0dez!
	sub.l	#$a370,d2
	swap	d2
	rol.l	d1,d2	
	addq	#1,d1
	sub.l	#$a370,d6
	swap	d6	
	rol.l	d1,d6

	addq	#8,d2		* headerin ohi

	move.l	d6,xlen(a5)	* pituus talteen

	move.l	d4,d1		* hyp�t��n oikeaan kohtaan
	moveq	#-1,d3
	lob	Seek

	move.l	d6,d0
	move.l	a4,d1
	jsr	getmem
	move.l	d0,xplayer(a5)	* muistia playerille
	beq.b	.error

	move.l	d4,d1		* file
	move.l	xplayer(a5),d2	* buffer
	move.l	d6,d3		* length
	lob	Read
	cmp.l	d6,d0
	beq.b	.ox

	move.l	d7,a0
	jsr	freemem
	bra.b	.error

.ox	moveq	#1,d7

.x	move.l	d4,d1
	beq.b	.xx
	lob	Close	


.xx	
	bsr.w	inforivit_clear

	move.l	d7,d0
	move.l	xplayer(a5),a1
	move.l	d6,d7
	tst.l	d0

	popm	d1-d6/a0/a2-a6
	rts

.error	moveq	#0,d7
	clr.b	xtype(a5)
	bra.b	.x



*******************************************************************************
* Enabloidaan k�ytetyt gadgetit ja disabloidaan k�ytt�m�tt�m�t
* Scope kanssa
*******

whatgadgets2
	moveq	#0,d0
	bra.b	whag

whatgadgets
	moveq	#1,d0
whag	tst.b	win(a5)
	bne.b	.w
.ww	rts
.w

	tst.l	playerbase(a5)
	beq.b	.ww

	pushm	all

	tst	d0
	beq.b	.c
	
	move.l	playerbase(a5),a0
	move	p_liput(a0),d7

* if usescope=1 then open scope if flag=1
* else
* if scope=open then close scope and set flag=1
* else
* clear flag

	tst.b	scopeflag(a5)
	beq.b	.c
	btst	#pb_scope,d7
	beq.b	.notopen
	tst	quad_prosessi(a5)
	bne.b	.c
	bsr.w	start_quad2
	bra.b	.c
.notopen
	tst	quad_prosessi(a5)
	beq.b	.c
	bsr.w	sulje_quad2
.c

	tst.l	keyfile+40(a5)	* datan v�lilt� 38-50 pit�� olla nollia
	beq.b	.zz
	move.l	tempexec(a5),a1
	addq.l	#1,IVVERTB+IV_DATA(a1)
;	jsr	flash
.zz


	cmp	#pt_prot,playertype(a5)
	bne.b	.rep
	cmp.b	#$ff,ptsonglist+1(a5)	* jos vain yksi PT songi, sammutetaan 
	bne.b	.rep			* song-gadgetit!
	and	#~pf_song,d7
.rep
	lea	gadstate(pc),a4

	ror	#1,d7		* ei v�litet� ekasta (joskus oli cont)

	moveq	#5-1,d6
.loop
	addq.l	#4,a4
	move.l	(a4)+,a0
	move.l	windowbase(a5),a1
	sub.l	a2,a2

	ror	#1,d7
	bpl.b	.off

	tst.b	-8(a4)		* oliko ennest��n p��ll�?
	bne.b	.on

	move.l	a0,a3

	movem	4(a3),d0/d1	* putsataan gadgetin alue..
	move	d0,d2
	move	d1,d3
	movem	8(a3),d4/d5
	move.l	rastport(a5),a0
	move.l	a0,a1
	push	d6
	moveq	#$0a,d6
	lore	GFX,ClipBlit
	pop	d6


	move.l	a3,a0
	move.l	windowbase(a5),a1
	sub.l	a2,a2

	and	#~GFLG_DISABLED,gg_Flags(a3)
	moveq	#1,d0
	lore	Intui,RefreshGList
	bsr.b	.keh

	lea	kela2,a0
	cmp.l	a0,a3
	bne.b	.nokela
;	lea	kela2,a0		* >, forward
	jsr	printkorva
.nokela

	st	-8(a4)
	bra.b	.on

.off	tst.b	-8(a4)		* oliko pois p��lt�?
	beq.b	.on
	clr.b	-8(a4)
	move.l	a0,a3
	or	#GFLG_DISABLED,gg_Flags(a3)
	moveq	#1,d0
	lore	Intui,RefreshGList
	bsr.b	.keh

.on
	tst	2(a4)		* enemm�n kuin yksi kerrallaan?
	bne.b	.l
	rol	#1,d7
	bra.w	.loop
.l
	dbf	d6,.loop

	popm	all
	rts


.keh	

	pushm	all				* varjostus kuntoon taas
	movem	4(a3),plx1/ply1/plx2/ply2
	cmp.l	#slider1,a3
	beq.b	.kex
	add	plx1,plx2
	add	ply1,ply2
	subq	#1,ply2
	subq	#1,plx1
	move.l	rastport(a5),a1
	jsr	laatikko1
.kex	popm	all

	rts



gadstate
	dc.l	$ff000001,button3	* stop/cont
	dc.l	$ff000001,button13	* prevsong
	dc.l	$ff000000,button12	* nextsong
	dc.l	$ff000001,kela2		* forwardd
	dc.l	$ff000001,kela1		* backward
	dc.l	$ff000001,slider1	* volume



*******************************************************************************
* Varaa/vapauttaa ��nikanavat
*******
varaa_kanavat
	tst.b	kanavatvarattu+var_b
	beq.b	.jee
	moveq	#0,d0
	rts
.jee	
	movem.l	d1-a6,-(sp)
	lea	var_b,a5

	move.l	playerbase(a5),a0
	move	p_liput(a0),d0
	btst	#pb_ahi,d0
	beq.b	.naa
	tst.b	ahi_use_nyt(a5)
	bne.b	.na
.naa

	bsr.w	createport
	bsr.w	createio

	lea	iorequest(a5),a1
	lea	.adname(pc),a0
	moveq	#0,d0
	moveq	#0,d1
	moveq	#100,d7
	tst.b	nastyaudio(a5)
	beq.b	.nona
	moveq	#127,d7
.nona	move.b	d7,LN_PRI(a1)
	lea	.allocmap(pc),a2
	move.l	a2,ioa_Data(a1)
* d2 = kanavalistan pituus
	moveq	#1,d2			* vain yksi vaihtoehto
	move.l	d2,ioa_Length(a1)
	move.l	(a5),a6
	lob	OpenDevice
	move.l	d0,d5
	move.l	d5,acou_deviceerr(a5)
	bne.b	acouscl
	st	kanavatvarattu(a5)
.na	movem.l	(sp)+,d1-a6
	moveq	#0,d0
	rts

.adname		dc.b	"audio.device",0
.allocmap	dc.b	$0f
 even

acouscl
	movem.l	(sp)+,d1-a6
	bsr.b	vapauta_kanavat
	moveq	#-1,d0
	rts

vapauta_kanavat	
	tst.b	kanavatvarattu+var_b
	bne.b	.eeo
	rts
.eeo	movem.l	d0-a6,-(sp)
	lea	var_b,a5

	tst.l	acou_deviceerr(a5)
	bne.b	acouscll
	lea	iorequest(a5),a1
	lore	Exec,CloseDevice
acouscll
	clr.l	acou_deviceerr(a5)
	clr.b	kanavatvarattu(a5)
	movem.l	(sp)+,d0-a6
	rts



*******************************************************************************
* CreatePort
*******
createport
	movem.l	a0-a2,-(sp)
	lea	audioport(a5),a0
	move.l	a0,a2
	lea	MP_SIZE(a0),a1
.clr	clr	(a0)+
	cmp.l	a1,a0
	bne.b	.clr
	move.l	owntask(a5),MP_SIGTASK(a2)
	move.b	ownsignal5(a5),MP_SIGBIT(a2)
	move.b	#NT_MSGPORT,LN_TYPE(a2)
	clr.l	LN_NAME(a2)
	move.b	#PA_SIGNAL,MP_FLAGS(a2)
	lea	MP_MSGLIST(a2),a0
	NEWLIST	a0
	movem.l	(sp)+,a0-a2
	rts

*******
* CreateIO
*******
createio
	movem.l	a0-a2,-(sp)
	lea	iorequest(a5),a0
	move.l	a0,a2
	lea	ioa_SIZEOF(a0),a1
.clr	clr	(a2)+
	cmp.l	a1,a2
	bne.b	.clr
	lea	audioport(a5),a1
	move.l	a1,MN_REPLYPORT(a0)
	move.b	#NT_MESSAGE,LN_TYPE(a0)
	move	#ioa_SIZEOF,MN_LENGTH(a0)
	movem.l	(sp)+,a0-a2
	rts



*******************************************************************************
*                                Soittorutiinit
*******************************************************************************

**********************************************
* Varaa muistia ja purkaa soittorutiinin
* a0 = osoitin paikkaan mihin laitetaan osoite



allocreplayer2
	pushm	d1-a6
	moveq	#MEMF_CHIP,d6
	bra.b	are

allocreplayer
	pushm	d1-a6
	moveq	#MEMF_PUBLIC,d6
are	

	tst.l	(a0)			* onko jo ennest��n?
	bne.w	.vanha

	cmp.b	#3,groupmode(a5)
	bne.b	.nah

** Ladataan yksi kipale replayereit� groupista
	bsr.w	loadreplayer
* a1 = replayeri pakattuna
* d7 = pakatun pituus
	bne.b	.contti
.xab	popm	d1-a6
	moveq	#ier_grouperror,d0
	rts

.nah

	move	playertype(a5),d0
	sub	#xpl_offs,d0
	move	d0,d1
	add	d1,d1
	
	move.l	externalplayers(a5),a4
	addq	#8,a4
	lsl	#3,d0
	movem.l (a4,d0),d0/d7		* offset, length
	tst.l	d0			* onko playeri�?
	beq.b	.xab

* d3k0dez!
	sub.l	#$a370,d0
	swap	d0
	rol.l	d1,d0
	addq	#1,d1
	sub.l	#$a370,d7
	swap	d7
	rol.l	d1,d7


	lea     (a4,d0.l),a1

.contti

	move.l	a1,a4
	move.l	a0,a3
	move.l	4(a4),d0
	sub.l	#$5371a26,d0
	move.l	d6,d1			* mem type
	jsr	getmem
	move.l	d0,(a3)
	bne.b	.ok2
	popm	d1-a6
	moveq	#ier_nomem,d0
	rts

.ok2	move.l	d0,a1
	move.l	a4,a0
	move.l	d7,d0
	lore	Exec,CopyMem	
	move.l	(a3),a0
	move.l	#$5371a26,d0
	add.l	d0,(a0)
	sub.l	d0,4(a0)
	bsr.w	fimp_decr

	move.l	(a3),a0
	cmp.l	#$000003f3,(a0)
	bne.b	.ok
	bsr.b	reloc

.ok
	move.l	(a5),a6
	cmp	#37,LIB_VERSION(a6)
	blo.b	.vanha
	lob	CacheClearU	* cachet tyhjix, ei gurua 68040:ll�!
.vanha
	popm	d1-a6
	moveq	#0,d0
	rts

**
* Reloc rutiini ilmeisesti pelk�lle ajettavalle code_hunkille
**
* a0 = hunkki
reloc	pushm	d0-d2/a0/a1
	lea	28(a0),a0
	move.l	(a0)+,d2
	lsl.l	#2,d2	
	move.l	a0,a1
	move.l	a0,d1
	lea	4(a0,d2.l),a0
	move.l	(a0)+,d2
	subq.l	#1,d2
	bmi.b	.024c
	addq.w	#4,a0
.0242	move.l	(a0)+,d0
	add.l	d1,(a1,d0.l)
	dbf	d2,.0242
.024c	addq.w	#8,a0
	popm	d0-d2/a0/a1
	rts	



***********************************
* Vapauttaa soittorutiinin muistista
* a0 = osoitin soittorutiinin osoittimeen
freereplayer
	tst.l	(a0)
	beq.b	.x
	push	a0
	move.l	(a0),a0
	jsr	freemem
	pop	a0
	clr.l	(a0)
.x
	cmp.b	#2,groupmode(a5)	* jos playerfile disabloitu,
	blo.b	.xx			* vapautetaan se ejectin yhteydess�
					* tai load single moodina
	move.l	externalplayers(a5),a0		
	clr.l	externalplayers(a5)
	jsr	freemem
.xx	rts

*************
* Tarkistaa onko moduuli fastissa. Jos on, siirt�� sen chippiin

siirra_moduuli
	pushm	d1-a6

	move.l	moduleaddress(a5),a3

	move.l	a3,a1
	lore	Exec,TypeOfMem
	btst	#MEMB_CHIP,d0
	bne.b	sirchip

	moveq	#MEMF_CHIP,d1
sirmo	move.l	modulelength(a5),d0
	lob	AllocMem
	tst.l	d0
	beq.b	sirerro
	move.l	d0,moduleaddress(a5)

	move.l	a3,a0
	move.l	d0,a1
	move.l	modulelength(a5),d0
	lob	CopyMem

	move.l	a3,a1
	move.l	modulelength(a5),d0
	lob	FreeMem

sirchip	moveq	#0,d0
sirx	popm	d1-a6
	rts

sirerro	moveq	#ier_nomem,d0
	bra.b	sirx


*************
* Tarkistaa onko moduuli chipiss�. Jos on, siirt�� sen fastiin (jos on).

siirra_moduuli2
	pushm	d1-a6

	move.l	moduleaddress(a5),a3

	move.l	a3,a1
	lore	Exec,TypeOfMem
	btst	#MEMB_FAST,d0
	bne.b	sirx

	moveq	#MEMF_FAST,d1
	bra.b	sirmo
	
;	move.l	modulelength(a5),d0
;	lob	AllocMem
;	tst.l	d0
;	beq.b	.x

;	move.l	d0,moduleaddress(a5)

;	move.l	a3,a0
;	move.l	d0,a1
;	move.l	modulelength(a5),d0
;	lob	CopyMem

;	move.l	a3,a1
;	move.l	modulelength(a5),d0
;	lob	FreeMem

;.fast	moveq	#0,d0
;.x	popm	d1-a6
;	rts

	

*************

dmawait
	pushm	d0/d1
	moveq	#12-1,d1
.d	move.b	$dff006,d0
.k	cmp.b	$dff006,d0
	beq.b	.k
	dbf	d1,.d
	popm	d0/d1
	rts

;	pushm	d0/a0
;	moveq	#8-1,d0
;	lea.l	$bfe001,a0
;.e 	rept	23
;	tst.b	(a0)
;	endr
;	dbf	d0,.e
;	popm	d0/a0
;	rts


clearsound
	pushm	d0/a0
	lea	$dff096,a0
	move	#$f,(a0)
	moveq	#0,d0
	move	d0,$a8-$96(a0)
	move	d0,$b8-$96(a0)
	move	d0,$c8-$96(a0)
	move	d0,$d8-$96(a0)
	popm	d0/a0
	rts


******************************************************************************
* Protracker
******************************************************************************

p_protracker
	jmp	.proinit(pc)
	dc.l	$4e754e75
	jmp	.provb(pc)
	jmp	.proend(pc)
	jmp	.prostop(pc)
	jmp	.procont(pc)
	jmp	.provolume(pc)
	jmp	.prosong(pc)		* Song
	jmp	.eteen(pc)
	jmp	.taakse(pc)
	dc.l	$4e754e75
.flags	
 dc pf_cont!pf_stop!pf_volume!pf_song!pf_kelaus!pf_poslen!pf_end!pf_scope!pf_ciakelaus2

	dc.b	"Protracker",0
 even


.proinit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	movem.l	d1-d2/a0/a1,-(sp)

	move.l	moduleaddress(a5),a0	* Onko konvertattu?

	tst.b	950(a0)			* song len v�h. 1
	bne.b	.ce
	move.b	#1,950(a0)
.ce
	cmp.b	#"K",951(a0)
	beq.b	.c
	move	#950/2-1,d0
	lea	ptheader,a1
.cl	move	(a0)+,(a1)+
	dbf	d0,.cl
.c


	bsr.w	.getsongs
	bsr.w	whatgadgets

	lea	kplbase(a5),a0
	move.l	moduleaddress(a5),a1

	moveq	#0,d0
	move.b	950(a1),d0
	move	d0,pos_maksimi(a5)

	bsr.b	.init

	cmp	#-1,d0
	beq.b	.eok
	cmp	#-2,d0
	beq.b	.eok3
	bsr.w	.provolume
	moveq	#0,d0
.eok2	movem.l	(sp)+,d1-d2/a0/a1
	rts

.eok	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	bra.b	.eok2
.eok3	bsr.w	vapauta_kanavat
	moveq	#ier_nomem,d0
	bra.b	.eok2


.init
	moveq	#0,d0
.init1
	moveq	#1,d1			* cia
	move.b	vbtimer(a5),vbtimeruse(a5)
	beq.b	.cuse
	moveq	#0,d1			* vb
.cuse

	moveq	#0,d2

	tst.b	oldst(a5)		* onko old st?
	bne.b	.s
	tst.b	tempoflag(a5)
	bne.b	.s
	bset	#0,d2			* tempo flag
.s	
	movem.l	d0/d1/a0/a1/a6,-(sp)	* oobko modi tosiaan fastissa?
	move.l	moduleaddress(a5),a1
	lore	Exec,TypeOfMem
	btst	#MEMB_CHIP,d0	
	movem.l	(sp)+,d0/d1/a0/a1/a6
	bne.b	.ss
	bset	#1,d2			* fast flag
.ss
	lea	kplbase(a5),a0
	bra.w	kplayer+kp_init
;	rts
	

.proend	move.l	d0,-(sp)
	bsr.w	kplayer+kp_end
	move.l	(sp)+,d0
	bra.w	vapauta_kanavat
;	rts

.prostop
	move.l	d0,-(Sp)
	moveq	#1,d0
	bsr.w	kplayer+kp_playstop
	bsr.w	kplayer+kp_clear
	move.l	(sp)+,d0
	rts

.procont
	move.l	d0,-(Sp)
	moveq	#0,d0
	bsr.w	kplayer+kp_playstop
	move.l	(sp)+,d0
	rts	

.provolume
	move.l	d0,-(sp)
	move	mainvolume(a5),d0
	bsr.w	kplayer+kp_setmaster
	move.l	(sp)+,d0
	rts

* ei soittoa, tutkitaan vain onko kappale loppunut
.provb
	tst.b	vbtimeruse(a5)
	beq.b	.cus
	bsr.w	kplayer+kp_music
.cus
	move	kplbase+k_songpos(a5),pos_nykyinen(a5)
	tst.b	kplbase+k_songover(a5)
	sne	songover(a5)
	clr.b	kplbase+k_songover(a5)
	rts

.eteen
	movem.l	d0/d1/a0,-(sp)
	move.l	moduleaddress(a5),a0
	moveq	#0,d0
	move.b	950(a0),d0		* songlength
	move	kplbase+k_songpos(a5),d1
	addq	#1,d1
	cmp	d0,d1
	blo.b	.a
	clr	d1
.a	move	d1,kplbase+k_songpos(a5)
	clr	kplbase+k_patternpos(a5)
	move	d1,pos_nykyinen(a5)
	movem.l	(sp)+,d0/d1/a0
	rts
.taakse
	move.l	d0,-(sp)
	move	kplbase+k_songpos(a5),d0
	subq	#1,d0
	bpl.b	.b
	clr	d0
.b	move	d0,kplbase+k_songpos(a5)
	clr	kplbase+k_patternpos(a5)
	move	d0,pos_nykyinen(a5)
	move.l	(sp)+,d0
.yee	rts


* Tutkii koko songin, ja kattoo jos olisi erillisi� songeja.
.getsongs
	move.l	moduleaddress(a5),a0
	cmp.b	#'K',951(a0)
	beq.b	.yee

	clr.l	kokonaisaika(a5)
	cmp	#3,lootamoodi(a5)
	bne.b	.la
	pushm	d2-a6
	move.l	moduleaddress(a5),a0
	move.b	tempoflag(a5),d0
	not.b	d0
	bsr.w	modlen		* moduulin kesto ajallisesti
	popm	d2-a6
	move	d0,kokonaisaika(a5)	* mins
	move	d1,kokonaisaika+2(a5)	* secs
.la

	move.l	a6,-(sp)

	move	#$0fff,d3
	moveq	#0,d0
	move.b	950(a0),d0		* songlength
	move	d0,a6
	subq	#1,d0
	moveq	#0,d1
	lea	1084(a0),a2		* eka patterni
	lea	952(a0),a3		* position-lista

	lea	ptsonglist(a5),a4
	moveq	#64-1,d2
.cc	move.b	#$ff,(a4)+
	dbf	d2,.cc
	lea	ptsonglist(a5),a4
	clr.b	(a4)+

.check
	moveq	#0,d2
	move.b	(a3)+,d2
	lsl.l	#5,d2			* d2*1024
	lsl.l	#5,d2	
	lea	(a2,d2.l),a1

************************ OPT
	printt	 Opti!

	moveq	#1024/4/4-1,d2
.look	
	movem.l	(a1)+,d4-d7
	and	d3,d4
	rol	#8,d4
	and	d3,d5
	rol	#8,d5
	and	d3,d6
	rol	#8,d6
	and	d3,d7
	rol	#8,d7

	cmp.b	#$b,d4
	beq.b	.jump1
	cmp.b	#$b,d5
	beq.b	.jump2
	cmp.b	#$b,d6
	beq.b	.jump3
	cmp.b	#$b,d7
	beq.b	.jump4
	cmp.b	#$d,d4
	beq.b	.next
	cmp.b	#$d,d5
	beq.b	.next
	cmp.b	#$d,d6
	beq.b	.next
	cmp.b	#$d,d7
	beq.b	.next

	dbf	d2,.look

.next	addq	#1,d1
	dbf	d0,.check

	move.b	#-1,(a4)
	lea	ptsonglist(a5),a0
	move.l	a0,a1
.f	cmp.b	#-1,(a0)+
	bne.b	.f
	sub.l	a1,a0
	subq	#1,a0
	move	a0,d0
	subq.b	#1,d0
	move.b	d0,maxsongs+1(a5)

	move.l	(sp)+,a6
	rts

.jump4	move	d7,d4
	bra.b	.jump
.jump3	move	d6,d4
	bra.b	.jump
.jump2	move	d5,d4
.jump1	
.jump	rol	#8,d4
	cmp.b	d1,d4
	bhs.b	.next

	moveq	#1,d4
	add.b	d1,d4

	cmp	a6,d4
	blo.b	.eoe
	moveq	#-1,d4			* Moduulin alkuun
.eoe	move.b	d4,(a4)+
	bra.b	.next


.prosong
	movem.l	d0-a1,-(Sp)

	lea	ptsonglist(a5),a0
	cmp.b	#-1,1(a0)
	beq.b	.nosong

	move	songnumber(a5),d7
	move.b	(a0,d7),d7
	bmi.b	.nosong

	bsr.w	kplayer+kp_end
	
	lea	kplbase(a5),a0
	move.l	moduleaddress(a5),a1
	move.l	d7,d0

	bsr.w	.init1
	bsr.w	.provolume

.nosong	movem.l	(sp)+,d0-a1
	rts




nl_note		EQU	0  ; W
nl_cmd		EQU	2  ; W
nl_cmdlo	EQU	3  ; B
nl_pattpos	EQU	4 ; B
nl_loopcount	EQU	6	 ; B
nl_ts		=	8	* channeltempsize



modlen

	basereg	modlen,a5
	lea	modlen(pc),a5

	lea	.datastart(a5),a1
	lea	.dataend(a5),a2
.lfe	clr.b	(a1)+
	cmp.l	a1,a2
	bne.b	.lfe

	MOVE.L	A0,.mt_SongDataPtr(a5)
	move.b	d0,.tempoflag(a5)

	move	#125,.Tempo(a5)
	move.b	#6,.mt_speed(a5)

;	CLR.B	.mt_counter(a5)
;	CLR.B	.mt_SongPos(a5)
;	CLR.W	.mt_PatternPos(a5)

	move.l	#1773447,d0
	divu	.Tempo(a5),d0
	move	d0,.tempoval(a5)

.loop	bsr.b	.mt_music
	tst	.songend(a5)
	beq.b	.loop

	cmp.b	#1,.songend(a5)
	bne.b	.nod
	moveq	#0,d0
	moveq	#0,d1
	rts
.nod


	move.l	.time(a5),d0
	move.l	#709379,d1	* PAL

;	move.l	(a5),a0
;	cmp.b	#60,PowerSupplyFrequency(a0)
;	bne.b	.pal
;	move.l	#715909,d1	* NTSC
;.pal
	jsr	divu_32
				* d0 = kesto sekunteina

	divu	#60,d0
	move.l	d0,d1
	swap	d1
	rts


.mt_music
	lea	modlen(pc),a5
	addq	#1,.varmistus(a5)
;	cmp	#512,.varmistus(a5)
;	cmp	#2048,.varmistus(a5)
	cmp	#4096,.varmistus(a5)
	blo.b	.noy
	clr	.mt_PatternPos(a5)
	CLR.B	.mt_PBreakPos(a5)
	CLR.B	.mt_PosJumpFlag(a5)
	clr.b	.mt_PattDelTime(a5)
	clr.b	.mt_PattDelTime2(a5)
	clr.b	.mt_counter(a5)
	move	#1024,.mt_PatternPos(a5)
	bra.b	.mt_GetNewNote
.noy

	moveq	#0,d0
	move	.tempoval(a5),d0
	add.l	d0,.time(a5)

	ADDQ.B	#1,.mt_counter(a5)
	MOVE.B	.mt_counter(a5),D0
	CMP.B	.mt_speed(a5),D0
	BLO.S	.mt_NoNewNote
	CLR.B	.mt_counter(a5)
	TST.B	.mt_PattDelTime2(a5)
	BEQ.S	.mt_GetNewNote
	BSR.S	.mt_NoNewAllChannels
	BRA.B	.mt_dskip

.mt_NoNewNote
	pea	.mt_NoNewPosYet(a5)

.mt_NoNewAllChannels
	LEA	.mt_chan1temp(a5),A6
	BSR.B	.mt_CheckEfx
	addq	#nl_ts,a6
	BSR.B	.mt_CheckEfx
	addq	#nl_ts,a6
	BSR.B	.mt_CheckEfx
	addq	#nl_ts,a6

.mt_CheckEfx
	moveq	#$f,d0
	and.b	nl_cmd(A6),D0
	CMP.B	#$E,D0
	BEQ.W	.mt_E_Commands
.mt_Return
	RTS


.mt_GetNewNote

	MOVE.L	.mt_SongDataPtr(a5),A0
	LEA	12(A0),A3
	LEA	952(A0),A2	;pattpo
	LEA	1084(A0),A0	;patterndata
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	mOVE.B	.mt_SongPos(a5),D0
	MOVE.B	(A2,D0.W),D1
	ASL.L	#8,D1
	ASL.L	#2,D1
	ADD.W	.mt_PatternPos(a5),D1

	LEA	.mt_chan1temp(a5),A6
	BSR.S	.mt_PlayVoice
	addq	#nl_ts,a6
	BSR.S	.mt_PlayVoice
	addq	#nl_ts,a6
	BSR.S	.mt_PlayVoice
	addq	#nl_ts,a6
	pea	.mt_SetDMA(pc)

;	BSR.S	.mt_PlayVoice
;	BRA.B	.mt_SetDMA


.mt_PlayVoice
	MOVE.L	(A0,D1.L),(A6)
	ADDQ.L	#4,D1
	Bra.w	.mt_CheckMoreEfx


.mt_SetDMA
.mt_dskip
	tst.b	.songend(a5)
	bne.w	.mt_exit

	ADD.W	#16,.mt_PatternPos(a5)
	MOVE.B	.mt_PattDelTime(a5),D0
	BEQ.S	.mt_dskc
	MOVE.B	D0,.mt_PattDelTime2(a5)
	CLR.B	.mt_PattDelTime(a5)
.mt_dskc	TST.B	.mt_PattDelTime2(a5)
	BEQ.S	.mt_dska
	SUBQ.B	#1,.mt_PattDelTime2(a5)
	BEQ.S	.mt_dska
	SUB.W	#16,.mt_PatternPos(a5)
.mt_dska	TST.B	.mt_PBreakFlag(a5)
	BEQ.S	.mt_nnpysk
	SF	.mt_PBreakFlag(a5)
	MOVEQ	#0,D0
	MOVE.B	.mt_PBreakPos(a5),D0
	CLR.B	.mt_PBreakPos(a5)
	LSL.W	#4,D0
	MOVE.W	D0,.mt_PatternPos(a5)
.mt_nnpysk
	CMP.W	#1024,.mt_PatternPos(a5)
	BLO.S	.mt_NoNewPosYet
.mt_NextPosition	
	clr	.varmistus(a5)

	MOVEQ	#0,D0
	MOVE.B	.mt_PBreakPos(a5),D0
	LSL.W	#4,D0
	MOVE.W	D0,.mt_PatternPos(a5)
	CLR.B	.mt_PBreakPos(a5)
	CLR.B	.mt_PosJumpFlag(a5)
	ADDQ.B	#1,.mt_SongPos(a5)
	bpl.b	.jo
	st	.songend(a5)
.jo
	AND.B	#$7F,.mt_SongPos(a5)
	MOVE.B	.mt_SongPos(a5),D1

	MOVE.L	.mt_SongDataPtr(a5),A0
	CMP.B	950(A0),D1
	BLO.S	.mt_NoNewPosYet
	CLR.B	.mt_SongPos(a5)
	st	.songend(a5)

.mt_NoNewPosYet	
	TST.B	.mt_PosJumpFlag(a5)
	BNE.S	.mt_NextPosition
.mt_exit	
	RTS



.mt_PositionJump
	push	d1
	MOVE.B	.mt_SongPos(a5),D1		* hyv�ksyt��n jos jumppi
	addq.b	#1,d1				* viimeisess� patternissa
	MOVE.L	.mt_SongDataPtr(a5),a0
	cmp.b	950(a0),d1
	bne.b	.nre
	st	.songend(a5)
	pop	d1
	bra.b	.fine

.nre	pop	d1
	move.b	#1,.songend(a5)

.fine
	SUBQ.B	#1,D0
	MOVE.B	D0,.mt_SongPos(a5)

.mt_pj2	CLR.B	.mt_PBreakPos(a5)
	ST 	.mt_PosJumpFlag(a5)
	RTS


.mt_PatternBreak
	MOVEQ	#0,D0
	MOVE.B	nl_cmdlo(A6),D0
	MOVE.L	D0,D2
	LSR.B	#4,D0
	MULU	#10,D0
	AND.B	#$0F,D2
	ADD.B	D2,D0
	CMP.B	#63,D0
	BHI.S	.mt_pj2
	MOVE.B	D0,.mt_PBreakPos(a5)
	ST	.mt_PosJumpFlag(a5)
	RTS

.mt_SetSpeed
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	Bne.b	.no0
	moveq	#31,d0
.no0
	tst	.tempoflag(a5)
	beq.b	.notempo
	CMP.B	#32,D0
	BHS.B	.SetTempo
.notempo
	CLR.B	.mt_counter(a5)
	MOVE.B	D0,.mt_speed(a5)
	RTS

.SetTempo
	move	d0,.Tempo(a5)

	move.l	#1773447,d0
	divu	.Tempo(a5),d0
	move	d0,.tempoval(a5)
	rts


.mt_CheckMoreEfx
	moveq	#$f,d0
	and.b	2(a6),d0
	CMP.B	#$B,D0
	BEQ.W	.mt_PositionJump
	CMP.B	#$D,D0
	BEQ.S	.mt_PatternBreak
	CMP.B	#$E,D0
	BEQ.S	.mt_E_Commands
	CMP.B	#$F,D0
	BEQ.S	.mt_SetSpeed
	rts

.mt_E_Commands
	MOVE.B	nl_cmdlo(A6),D0
	AND.B	#$F0,D0
	CMP.B	#$60,D0
	BEQ.B	.mt_JumpLoop
	CMP.B	#$E0,D0
	BEQ.B	.mt_PatternDelay
	RTS


.mt_JumpLoop
	TST.B	.mt_counter(a5)
	BNE.W	.mt_Return
	moveq	#$f,d0
	and.b	nl_cmdlo(A6),D0
	BEQ.S	.mt_SetLoop
	TST.B	nl_loopcount(A6)
	BEQ.S	.mt_jumpcnt
	SUBQ.B	#1,nl_loopcount(A6)
	BEQ.W	.mt_Return
.mt_jmploop	MOVE.B	nl_pattpos(A6),.mt_PBreakPos(a5)
	ST	.mt_PBreakFlag(a5)
	RTS

.mt_jumpcnt
	MOVE.B	D0,nl_loopcount(A6)
	BRA.S	.mt_jmploop

.mt_SetLoop
	MOVE.W	.mt_PatternPos(a5),D0
	LSR.W	#4,D0
	MOVE.B	D0,nl_pattpos(A6)
	RTS


.mt_PatternDelay
	TST.B	.mt_counter(a5)
	BNE.W	.mt_Return
	MOVEQ	#$f,D0
	and.b	nl_cmdlo(A6),D0
	TST.B	.mt_PattDelTime2(a5)
	BNE.W	.mt_Return
	ADDQ.B	#1,D0
	MOVE.B	D0,.mt_PattDelTime(a5)
.qq	RTS


.datastart	

.songend	dc	0
.Tempo		dc	125
.tempoval	dc	0
.tempoflag	dc	0
.time		dc.l	0

.mt_chan1temp	ds.b	8
.mt_chan2temp	ds.b	8
.mt_chan3temp	ds.b	8
.mt_chan4temp	ds.b	8
 even

.mt_SongDataPtr	dc.l 0
.mt_speed	dc.b 6
 even
.mt_counter	dc.b 0
 even
.mt_SongPos	dc.b 0
 even
.mt_PBreakPos	dc.b 0
 even
.mt_PosJumpFlag	dc.b 0
 even
.mt_PBreakFlag	dc.b 0
 even
.mt_PattDelTime	dc.b 0
 even
.mt_PattDelTime2 dc.b 0
 even
.mt_PatternPos	dc.w 0
 even
.varmistus	dc	0

 even

.dataend

 endb	a5




******************************************************************************
* SID
******************************************************************************

p_sid	jmp	.init(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.end(pc)
	jmp	.stop(pc)
	jmp	.cont(pc)
	dc.l	$4e754e75
	jmp	.song(pc)
	jmp	.eteen(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_song!pf_kelauseteen
	dc.b	"PSID",0
.flag	dc.b	0
 even

.init
	bsr.w	get_sid
	bne.b	.ok
	moveq	#ier_nosid,d0
	rts

.ok
	movem.l	d1-a6,-(sp)


	move.l	_SIDBase(a5),a6

	tst.b	.flag
	bne.b	.plo

;	moveq	#1,d0
;	lob	SetDisplayEnable

	lob	AllocEmulResource
	tst.l	d0
	bne.w	.error1

	move.l	moduleaddress(a5),a0
	cmp.l	#"PSID",(a0)
	bne.b	.noheader

	lea	sidheader(a5),a1
	moveq	#sidh_sizeof-1,d0
.co	move.b	(a0)+,(a1)+
	dbf	d0,.co
	bra.b	.h2

.noheader
	move.l	modulefilename(a5),a0
	lea	sidheader(a5),a1
	lob	ReadIcon	
	tst.l	d0
	bne.b	.error2

.h2
	lea	sidheader(a5),a0
	move.l	moduleaddress(a5),a1
	move.l	modulelength(a5),d0
	lob	SetModule


	lea	sidheader+sidh_name(a5),a0	* kappaleen nimi paikalleen
	moveq	#32-1,d0
	lea	modulename(a5),a1
.c	move.b	(a0)+,(a1)+
	dbeq	d0,.c

	st	.flag			* piisi initattu
	move	sidheader+sidh_number(a5),maxsongs(a5)
	subq	#1,maxsongs(a5)

	tst.b	sidflag(a5)
	bne.b	.plo
	st	sidflag(a5)
	move	sidh_defsong+sidheader(a5),songnumber(a5)
	subq	#1,songnumber(a5)
.plo

	bsr.b	.sanko
	tst.l	d0
	bne.b	.error3	

	bset	#1,$bfe001
	moveq	#0,d0
.er	movem.l	(sp)+,d1-a6
	rts


.error1
;	bsr.b	.closl
	moveq	#ier_nomem,d0
	bra.b	.er

.error2	bsr.b	.free
;	bsr.b	.closl
	moveq	#ier_sidicon,d0
	bra.b	.er

.error3
	bsr.b	.free
;	bsr.b	.closl
	moveq	#ier_sidinit,d0
	bra.b	.er


.free	lob	FreeEmulResource
	clr.b	.flag
	rts

.sanko	moveq	#0,d1
	move	songnumber(a5),d1
	addq	#1,d1
	move.l	sidh_speed+sidheader(a5),d2
	moveq	#50,d0
	btst	d1,d2
	beq.b	.ok2
	moveq	#60,d0
.ok2	lore	SID,SetVertFreq

	moveq	#0,d0
	move	songnumber(a5),d0
	addq	#1,d0
	lob	StartSong
	rts

.song	movem.l	d0/d1/a0/a1/a6,-(sp)
	bsr.b	.sanko
	movem.l	(sp)+,d0/d1/a0/a1/a6
	rts	

.end
	movem.l	d0/d1/a0/a1/a6,-(sp)
	lore	SID,StopSong
	bsr.b	.free
;	bsr.b	.closl
	movem.l	(sp)+,d0/d1/a0/a1/a6
	rts

;.closl	
;	bsr.b	rem_sidpatch
;	move.l	_SIDBase(a5),a1
;	lore	Exec,CloseLibrary
;	clr.l	_SIDBase(a5)
;	rts


.stop	movem.l	d0/d1/a0/a1/a6,-(sp)
	lore	SID,PauseSong
	movem.l	(sp)+,d0/d1/a0/a1/a6
	rts

.cont	movem.l	d0/d1/a0/a1/a6,-(sp)
	lore	SID,ContinueSong
	movem.l	(sp)+,d0/d1/a0/a1/a6
	rts

.eteen
	movem.l	d0/d1/a0/a1/a6,-(sp)
;	moveq	#4,d0
	moveq	#6,d0
	lore	SID,ForwardSong
	movem.l	(sp)+,d0/d1/a0/a1/a6
	rts

*** Killeri viritys kick1.3:lle, jotta playsid.library toimisi


rem_sidpatch
	move.l	(a5),a0
	cmp	#34,LIB_VERSION(a0)
	bhi.b	.q
	move.l	_SIDBase(a5),a6
	cmp	#1,LIB_VERSION(a6)
	bne.b	.q
	cmp	#1,LIB_REVISION(a6)
	bne.b	.q
	move.l	_LVOStartSong+2(a6),a4
	move.l	12714+2(a4),a0
	move.l	12714+2+6(a4),a1
	move.l	sidlibstore2(a5),86(a0)
	move.l	sidlibstore2+4(a5),4+86(a0)
	move.l	sidlibstore1(a5),14(a1)
	move.l	sidlibstore1+4(a5),4+14(a1)
.q	rts

init_sidpatch
	move.l	(a5),a0
	cmp	#34,LIB_VERSION(a0)
	bhi.b	.q
	move.l	_SIDBase(a5),a6
	cmp	#1,LIB_VERSION(a6)
	bne.b	.q
	cmp	#1,LIB_REVISION(a6)
	bne.b	.q

	move.l	_LVOStartSong+2(a6),a4
	move.l	12714+2(a4),a0
	move.l	12714+2+6(a4),a1

* a1+14
*	move.l	4.w,a6		* ei saa tuhota
*	jsr	-$29a(a6)	* saa tuhota

* a0+86 
*	move.l	4.w,a6		* saa tuhota
*	jsr	-$2a0(a6)	* saa tuhota

	move.l	14(a1),sidlibstore1(a5)
	move.l	4+14(a1),sidlibstore1+4(a5)
	move.l	86(a0),sidlibstore2(a5)
	move.l	4+86(a0),sidlibstore2+4(a5)

	move.l	.sidp1(pc),14(a1)
	move.l	.sidp1+4(pc),4+14(a1)
	move.l	.sidp2(pc),86(a0)
	move.l	.sidp2+4(pc),4+86(a0)
.q	rts

.sidp1	jsr	.sidpatch1
	nop
.sidp2	jsr	.sidpatch2
	nop

.sidpatch1
	move.l	4.w,a6

* -$29a	CreateMsgPort
.LB_090C MOVEQ	#$22,D0
 	MOVE.L	#$00010001,D1
	JSR	-$00C6(A6)
	MOVE.L	D0,-(A7)
	BEQ.B	.LB_094A
	MOVEQ	#-$01,D0
	JSR	-$014A(A6)
	MOVE.L	(A7),A0
	MOVE.B	#$04,$0008(A0)
;	MOVE.B	#$00,$000E(A0)
	clr.b	$e(a0)
	MOVE.B	D0,$000F(A0)
	BMI.B	.LB_094E
	MOVE.L	$0114(A6),$0010(A0)
	LEA	$0014(A0),A1
	MOVE.L	A1,$0008(A1)
	ADDQ.L	#4,A1
	CLR.L	(A1)
	MOVE.L	A1,-(A1)
.LB_094A MOVE.L	(A7)+,D0
	RTS	
.LB_094E MOVEQ	#$22,D0
	MOVE.L	A0,A1
	JSR	-$00D2(A6)
	CLR.L	(A7)
	BRA.B	.LB_094A


.sidpatch2
	move.l	4.w,a6

* -$2a0	DeleteMsgPort
.LB_095A mOVE.L	A0,-(A7)
	BEQ.B	.LB_0978
	MOVEQ	#$00,D0
	MOVE.B	$000F(A0),D0
	JSR	-$0150(A6)
	MOVE.L	(A7),A1
	MOVEQ	#-$01,D0
	MOVE.L	D0,$0014(A1)
	MOVE.L	D0,(A1)
	MOVEQ	#$22,D0
	JSR	-$00D2(A6)
.LB_0978 ADDQ.L	#4,A7
	RTS	


* T�nne v�liin h�m��v�sti

*******************************************************************************
* Tarkistaa keyfilen. Muuttaa rekister�ij�n nimen tekstiksi ja palauttaa
* keycheck(a5):ss� nollan, jos aito.
*******

check_keyfile
	tst.b	keyfilechecked(a5)
	beq.b	.not
	rts
.not	st	keyfilechecked(a5)

	lea	keyfile(a5),a4
	move.l	56(a4),d0
	swap	d0
	lsr.l	#1,d0
	divu	#1005,d0
	moveq	#0,d4

	move.l	a4,a0
	moveq	#38-1,d2
	moveq	#0,d1
.k	sub.b	(a0)+,d1
	dbf	d2,.k

	sub.l	d1,d0
	add.b	d0,d4

	move.l	a4,a0
	move	30(a0),d0		* %111
	lsr	#1,d0

	moveq	#0,d1			* %111
	move	34(a0),d1
	move	d1,d2
	subq.b	#1,d1
	lsl	#3,d1
	or.l	d1,d0

	moveq	#0,d1			* %11111
	move.b	32(a0),d1
	sub	d2,d1
	lsl.l	#6,d1
	or.l	d1,d0

	moveq	#0,d1
	move.b	36(a0),d1
	lsl.l	#8,d1
	lsl.l	#2,d1
	or.l	d1,d0

	clr.b	36(a0)
	clr.b	32(a0)
	clr	34(a0)
	clr	30(a0)

	move.l	a4,a0
	moveq	#32-1,d3
	moveq	#0,d2
.cle	moveq	#0,d1
	move.b	(a0)+,d1
	add	d1,d2
	dbf	d3,.cle

	sub.l	d2,d0
	add.b	d0,d4

	bra.b	.l
.ll	move.b	-2(a4),d0
	sub.b	d0,-1(a4)
.l	tst.b	(a4)+
	bne.b	.ll

	or.b	d4,keycheck(a5)
	bne.b	.hot

	lea	wreg1,a0
	clr.b	(a0)
	clr.b	wreg2-wreg1(a0)
	clr.b	wreg3-wreg1(a0)
.hot	rts	




******************************************************************************
* Delta music
******************************************************************************
p_deltamusic
	jmp	.deltainit(pc)
	jmp	.deltaplay(pc)
	dc.l	$4e754e75
	jmp	.deltaend(pc)
	jmp	.deltastop(pc)
	dc.l	$4e754e75
	jmp	.deltavolume(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_volume!pf_ciakelaus
	dc.b	"Delta Music v2.0",0
 even


.deltainit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2
	movem.l	d0-a6,-(sp)
	moveq	#1,d0
.delt	move.l	moduleaddress(a5),a0
	jsr	(a0)
	movem.l	(sp)+,d0-a6
	moveq	#0,d0
	rts	

.deltaplay
	movem.l	d0-a6,-(sp)
	moveq	#0,d0	
	bra.b	.delt

.deltaend
	bsr.w	rem_ciaint
	bsr.w	clearsound
	bra.w	vapauta_kanavat
.deltastop
	bra.w	clearsound

.deltavolume
	movem.l	d0-a6,-(sp)
	move	mainvolume(a5),d1
	subq	#1,d1
	bpl.b	.err
	moveq	#0,d1
.err	moveq	#2,d0
	bra.b	.delt


******************************************************************************
* Future Composer 1.0 - 1.3
******************************************************************************

p_futurecomposer13
	jmp	.fc10init(pc)
	jmp	.fc10play(pc)
	dc.l	$4e754e75
	jmp	.fc10end(pc)
	jmp	.fc10stop(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_volume!pf_end!pf_ciakelaus
	dc.b	"Future Composer v1.0-1.3",0
 even

.fc10init
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2
	lea	fc10routines(a5),a0
	bsr.w	allocreplayer2
	beq.b	.ok3
	bsr.w	rem_ciaint
	bra.w	vapauta_kanavat
;	rts

.ok3
	movem.l	d0-a6,-(sp)
	move.l	moduleaddress(a5),a0
	lea	mainvolume(a5),a1
	lea	songover(a5),a2
	move.l	fc10routines(a5),a3
	jsr	$20(a3)
	movem.l	(sp)+,d0-a6
	moveq	#0,d0
	rts
.fc10play
	move.l	fc10routines(a5),a0
	jmp	$20+436(a0)

.fc10end
	bsr.w	rem_ciaint
	bsr.w	clearsound
	bra.w	vapauta_kanavat
.fc10stop
	bra.w	clearsound


******************************************************************************
* Future Composer 1.4
******************************************************************************


p_futurecomposer14
	jmp	.fc10init(pc)
	jmp	.fc10play(pc)
	dc.l	$4e754e75
	jmp	.fc10end(pc)
	jmp	.fc10stop(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_volume!pf_end!pf_ciakelaus
	dc.b	"Future Composer v1.4",0
 even

.fc10init
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2
	lea	fc14routines(a5),a0
	bsr.w	allocreplayer2
	beq.b	.ok3
	bsr.w	rem_ciaint
	bra.w	vapauta_kanavat
;	rts

.ok3	
	movem.l	d0-a6,-(sp)
	move.l	moduleaddress(a5),a0
	lea	mainvolume(a5),a1
	lea	songover(a5),a2
	move.l	fc14routines(a5),a3
	jsr	$20(a3)
	movem.l	(sp)+,d0-a6
	moveq	#0,d0
	rts
.fc10play
	move.l	fc14routines(a5),a0
	jmp	$20+466(a0)

.fc10end
	bsr.w	rem_ciaint
	bsr.w	clearsound
	bra.w	vapauta_kanavat
.fc10stop
	bra.w	clearsound




******************************************************************************
* SoundMon
******************************************************************************

p_soundmon
	jmp	.bpsminit(pc)
	jmp	.bpsmplay(pc)
	dc.l	$4e754e75
	jmp	.bpsmend(pc)
	jmp	.bpsmstop(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.eteen(pc)
	jmp	.taakse(pc)
	dc.l	$4e754e75
 dc	pf_cont!pf_stop!pf_poslen!pf_kelaus!pf_volume!pf_end!pf_ciakelaus2
	dc.b	"SoundMon v2.0",0
 even

.bpsminit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2
	lea	bpsmroutines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok3
	bsr.w	rem_ciaint
	bra.w	vapauta_kanavat
;	rts
.ok3


	move.l	moduleaddress(a5),a0
	lea	songover(a5),a1
	lea	pos_nykyinen(a5),a2
	lea	nullsample,a3
	clr.l	(a3)
	lea	mainvolume(a5),a4
	pushpea	dmawait(pc),d0

	push	a6
	move.l	bpsmroutines(a5),a6
	jsr	(a6)
	pop	a6

	moveq	#0,d0
	rts
.bpsmplay
	move.l	bpsmroutines(a5),a0
	jmp	300(a0)
.bpsmend
	bsr.w	rem_ciaint
	bsr.w	clearsound
	bra.w	vapauta_kanavat

.bpsmstop
	bra.w	clearsound

.eteen
	move.l	bpsmroutines(a5),a0
	jmp	2180(a0)

.taakse
	move.l	bpsmroutines(a5),a0
	jmp	2158(a0)


******************************************************************************
* SoundMon 3
******************************************************************************

p_soundmon3
	jmp	.bpsminit(pc)
	jmp	.bpsmplay(pc)
	dc.l	$4e754e75
	jmp	.bpsmend(pc)
	jmp	.bpsmstop(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.eteen(pc)
	jmp	.taakse(pc)
	dc.l	$4e754e75
 dc	pf_cont!pf_stop!pf_poslen!pf_kelaus!pf_volume!pf_end!pf_ciakelaus2
	dc.b	"SoundMon v3.0",0
 even

.bpsminit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2

	lea	bpsmroutines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok3
	bsr.w	rem_ciaint
	bra.w	vapauta_kanavat
;	rts
.ok3


	move.l	moduleaddress(a5),a0
	lea	songover(a5),a1
	lea	pos_nykyinen(a5),a2
	lea	nullsample,a3
	clr.l	(a3)
	lea	mainvolume(a5),a4
	pushpea	dmawait(pc),d0

	push	a6
	move.l	bpsmroutines(a5),a6
	jsr	$20(a6)
	pop	a6

	moveq	#0,d0
	rts
.bpsmplay
	move.l	bpsmroutines(a5),a0
	jmp	$20+4(a0)
.bpsmend
	bsr.w	rem_ciaint
	bsr.w	clearsound
	bra.w	vapauta_kanavat

.bpsmstop
	bra.w	clearsound

.taakse
	move.l	bpsmroutines(a5),a0
	jmp	12+$20(a0)

.eteen
	move.l	bpsmroutines(a5),a0
	jmp	8+$20(a0)


******************************************************************************
* Jamcracker
******************************************************************************

p_jamcracker
	jmp	.jaminit(pc)
	jmp	.jamplay(pc)
	dc.l	$4e754e75
	jmp	.jamend(pc)
	jmp	.jamstop(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_end!pf_ciakelaus
	dc.b	"JamCracker",0
 even

.jaminit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2
	lea	jamroutines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok3
	bsr.w	rem_ciaint
	bra.w	vapauta_kanavat
;	rts

.ok3	
	move.l	moduleaddress(a5),a0
	lea	dmawait(pc),a1
	lea	songover(a5),a2
	move.l	jamroutines(a5),a3
	jsr	(a3)
	moveq	#0,d0
	rts	

.jamplay
	move.l	jamroutines(a5),a0
	jmp	304(a0)

.jamend
	bsr.w	rem_ciaint
	bsr.w	clearsound
	bra.w	vapauta_kanavat

.jamstop
	bra.w	clearsound


******************************************************************************
* Music Assembler
******************************************************************************

p_musicassembler
	jmp	.massinit(pc)
	jmp	.massplay(pc)
	dc.l	$4e754e75
	jmp	.massend(pc)
	jmp	.massstop(pc)
	dc.l	$4e754e75
	jmp	.massvolume(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_volume!pf_ciakelaus
	dc.b	"Music Assembler",0
 even

.massinit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2

	moveq	#0,d0
.minit	move.l	moduleaddress(a5),a0
	jsr	(a0)
	bsr.b	.massvolume
	moveq	#0,d0
	rts	

.massplay
	move.l	moduleaddress(a5),a0
	jmp	12(a0)

.massend
	bsr.w	rem_ciaint
	pushm	all
	move.l	moduleaddress(a5),a0
	jsr	4(a0)
	popm	all
	bra.w	vapauta_kanavat

.massstop
	bra.w	clearsound


.massvolume
	move	mainvolume(a5),d0
	moveq	#$f,d1
	move.l	moduleaddress(a5),a0
	jmp	8(a0)

;.masssong
;	move.l	moduleaddress(a5),a0
;	jsr	4(a0)		* end
;	moveq	#0,d0
;	move	songnumber(a5),d0
;	bra.b	.minit


******************************************************************************
* Fred
******************************************************************************

p_fred
	jmp	.fredinit(pc)
	jmp	.fredplay(pc)
	dc.l	$4e754e75
	jmp	.fredend(pc)
	jmp	.fredstop(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.fredsong(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_song!pf_ciakelaus
	dc.b	"Fred",0
 even

.fredinit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2
	movem.l	d0-a6,-(sp)
	moveq	#0,d0
	bset	#1,$bfe001
.finit	move.l	moduleaddress(a5),a0
	jsr	(a0)
	movem.l	(sp)+,d0-a6
	moveq	#0,d0
	rts	

.fredplay
	move.l	moduleaddress(a5),a0
	jmp	4(a0)

.fredend
	bsr.w	rem_ciaint
	movem.l	d0-a6,-(sp)
	move.l	moduleaddress(a5),a0
	jsr	8(a0)
	movem.l	(sp)+,d0-a6
	bra.w	vapauta_kanavat

.fredstop
	bra.w	clearsound


.fredsong
	movem.l	d0-a6,-(sp)
	move.l	moduleaddress(a5),a0
	jsr	8(a0)		* end
	moveq	#0,d0
	move	songnumber(a5),d0
	bra.b	.finit


******************************************************************************
* SonicArranger
******************************************************************************

p_sonicarranger
	jmp	.soninit(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.sonend(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.sonsong(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_song
	dc.b	"Sonic Arranger",0
 even

.soninit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	movem.l	d0-a6,-(sp)
	move.l	moduleaddress(a5),a0
	jsr	(a0)
	move.l	moduleaddress(a5),a0
	jsr	4(a0)
	moveq	#0,d0
	move	songnumber(a5),d0
	move.l	moduleaddress(a5),a0
	jsr	12(a0)	
	move	#10,maxsongs(a5)
	movem.l	(sp)+,d0-a6
	moveq	#0,d0
	rts	

.sonend
	movem.l	d0-a6,-(sp)
	move.l	moduleaddress(a5),a0
	jsr	16(a0)
	move.l	moduleaddress(a5),a0
	jsr	8(a0)
	movem.l	(sp)+,d0-a6
	bra.w	vapauta_kanavat

.sonsong
	bsr.b	.sonend	
	bra.b	.soninit

******************************************************************************
* SidMon 1.0
******************************************************************************

p_sidmon1
	jmp	.sm10init(pc)
	jmp	.sm10play(pc)
	dc.l	$4e754e75
	jmp	.sm10end(pc)
	jmp	.sm10stop(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_stop!pf_cont!pf_ciakelaus
	dc.b	"SIDMon v1.0",0
 even

.sm10init
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2
	movem.l	d0-a6,-(sp)
	move.l	sid10init(pc),a0
	jsr	(a0)
	movem.l	(sp)+,d0-a6
	moveq	#0,d0
	rts	

.sm10play
	move.l	sid10music(pc),a0
	jmp	(a0)

.sm10end
	bsr.w	rem_ciaint
	bsr.w	clearsound
	bra.w	vapauta_kanavat
.sm10stop
	bra.w	clearsound

sid10init	dc.l	0
sid10music	dc.l	0




******************************************************************************
* Oktalyzer (v1.56)
******************************************************************************

p_oktalyzer
	jmp	.okinit(pc)
	jmp	.okplay(pc)
	dc.l	$4e754e75
	jmp	.okend(pc)
	jmp	.okstop(pc)
	dc.l	$4e754e75
	jmp	.okvolume(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_volume!pf_end
	dc.b	"Oktalyzer",0
 even

.okstop	st	playing(a5)	* ei sallita pys�yttelemist�
	rts

.okinit	
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2

	lea	oktaroutines(a5),a0
	bsr.w	allocreplayer2		* chippiin
	beq.b	.ok3
	bsr.w	rem_ciaint
	bra.w	vapauta_kanavat
;	rts

.ok3	
	move.l	moduleaddress(a5),a0
	lea	songover(a5),a1
	move.l	oktaroutines(a5),a2
	jsr	$20(a2)
	tst	d0
	beq.b	.ee
	bsr.b	.oke
	bsr.w	rem_ciaint
	moveq	#ier_nomem,d0
	rts

.ee	bsr.b	.okvolume
	moveq	#0,d0
	rts

.okplay	
	move.l	oktaroutines(a5),a0
	jmp	526+$20(a0)

.okend	
	bsr.w	rem_ciaint
	pushm	all
	move.l	oktaroutines(a5),a0
	jsr	52+$20(a0)
	popm	all
.oke	bra.w	vapauta_kanavat

.okvolume
	moveq	#0,d0
	move	mainvolume(a5),d0
	move.l	oktaroutines(a5),a0
	jmp	4096+$20(a0)


******************************************************************************
* TFMX
******************************************************************************

p_tfmx
	jmp	.tfmxinit(pc)
	dc.l	$4e754e75
	jmp	.tfmxvb(pc)
	jmp	.tfmxend(pc)
	jmp	.tfmxstop(pc)
	jmp	.tfmxcont(pc)
	jmp	.tfmxvolume(pc)
	jmp	.tfmxsong(pc)
	jmp	.eteen(pc)
	jmp	.taakse(pc)
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_song!pf_volume!pf_kelaus!pf_poslen!pf_end
	dc.b	"TFMX",0
 even



.eteen
	pushm	d0/a0
	move.l	tfmxroutines(a5),a0
	move	7196(a0),d0
	addq	#2,d0
	cmp	7194(a0),d0
	bhi.b	.og
	subq	#1,d0
	move	d0,7196(a0)
.og	popm	d0/a0
	rts

.taakse
	push	a0
	move.l	tfmxroutines(a5),a0
	subq	#1,7196(a0)
	bpl.b	.gog
	clr	7196(a0)
.gog	pop	a0
	rts

.tfmxvb
	push	a0
	move.l	tfmxroutines(a5),a0
	move	7194(a0),pos_maksimi(a5)
	move	7196(a0),pos_nykyinen(a5)
	pop	a0
	rts

.tfmxinit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok
	lea	tfmxroutines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok2
	bra.w	vapauta_kanavat
;	rts
.ok2
	move.l	tfmxroutines(a5),a0
	lea	5788(a0),a1
	lea	tfmxi1(pc),a2
;	move.l	a1,tfmxi1
	move.l	a1,(a2)
	lea	2092(a0),a0
;	move.l	a0,tfmxi2
;	move.l	a0,tfmxi3
;	move.l	a0,tfmxi4
;	move.l	a0,tfmxi5
	move.l	a0,tfmxi2-tfmxi1(a2)
	move.l	a0,tfmxi3-tfmxi1(a2)
	move.l	a0,tfmxi4-tfmxi1(a2)
	move.l	a0,tfmxi5-tfmxi1(a2)

	bsr.w	tfmx_varaa
	beq.b	.ok3
;	move.l	tfmxroutines(a5),a0
;	bsr.w	freereplayer
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts

.ok3
	bsr.w	gettfmxsongs
	move	d0,maxsongs(a5)


	move.l	moduleaddress(a5),a0
	cmp.l	#"TFHD",(a0)
	bne.b	.noo

	move.l	a0,d0
	add.l	4(a0),d0		* MDAT
	move.l	d0,d1
	add.l	10(a0),d1		* SMPL
	btst	#0,d1		* onko parittomassa osoitteessa?
	beq.b	.un
	addq.l	#1,d1		* on, v��nnet��n se parilliseksi
	move.l	d1,a0
	clr.l	(a0)		* alusta nollaa tyhj�ks
	bra.b	.un
.noo


	move.l	moduleaddress(a5),d0
	move.l	tfmxsamplesaddr(a5),d1

.un
	move.l	tfmxroutines(a5),A0
	jsr	$14(A0)
	moveq	#0,d0			* song number
	move	songnumber(a5),d0
	move.l	tfmxroutines(a5),A0
	jsr	12(A0)


	bsr.b	.tfmxvolume
	bsr.b	.tfmxcont
	moveq	#0,d0
	rts

.tfmxcont
	bset	#0,$bfdf00
	rts

.tfmxstop
	bclr	#0,$bfdf00
	bra.w	clearsound


.tfmxsong
	bsr.b	.tfmxe
	bra.b	.ok3

.tfmxvolume
	moveq	#0,d0
	move	mainvolume(a5),d0
	move.l	tfmxroutines(a5),A0
	jmp	$28(A0)

.tfmxend
	pushm	all
	bsr.w	tfmx_vapauta
	bsr.b	.tfmxe
	popm	all
	bra.w	vapauta_kanavat
	
.tfmxe	bsr.b	.tfmxstop
	move.l	tfmxroutines(a5),A0
	jsr	$1C(A0)
	moveq	#0,D0
	move.l	tfmxroutines(a5),A0
	jsr	$20(A0)
	moveq	#1,D0
	move.l	tfmxroutines(a5),A0
	jsr	$20(A0)
	moveq	#2,D0
	move.l	tfmxroutines(a5),A0
	jsr	$20(A0)
	moveq	#3,D0
	move.l	tfmxroutines(a5),A0
	jsr	$20(A0)
	rts



tfmx_varaa
	move.l	a6,-(sp)
	moveq	#7,D0
	lea	tfmx_L000106(PC),A1
	move.l	(a5),A6
	jsr	-$A2(A6)
	move.l	D0,tfmx_L0000E0(a5)
	moveq	#8,D0
	lea	tfmx_L00011C(PC),A1
	jsr	-$A2(A6)
	move.l	D0,tfmx_L0000E4(a5)
	moveq	#9,D0
	lea	tfmx_L000132(PC),A1
	jsr	-$A2(A6)
	move.l	D0,tfmx_L0000E8(a5)
	moveq	#10,D0
	lea	tfmx_L000148(PC),A1
	jsr	-$A2(A6)
	move.l	D0,tfmx_L0000EC(a5)
	lea	.n(pc),A1
	jsr	-$1F2(A6)
	move.l	D0,tfmx_L0000DC(a5)
	beq.b	tfmx_C000338
	moveq	#1,D0
	lea	tfmx_L0000F0(PC),A1
	move.l	tfmx_L0000DC(a5),A6
	jsr	-6(A6)
	tst.l	D0
	bne.b	tfmx_C000338
	moveq	#0,D0
	move.l	(sp)+,a6
	rts

.n	dc.b	"ciab.resource",0
 even

* vapautetaan kaikki
tfmx_vapauta
	move.l	a6,-(sp)
	moveq	#1,D0
	lea	tfmx_L0000F0(PC),A1
	move.l	tfmx_L0000DC(a5),A6
	jsr	-12(A6)
tfmx_C000338	moveq	#10,D0
	move.l	tfmx_L0000EC(a5),A1
	move.l	(a5),A6
	jsr	-$A2(A6)
	moveq	#9,D0
	move.l	tfmx_L0000E8(a5),A1
	jsr	-$A2(A6)
	moveq	#8,D0
	move.l	tfmx_L0000E4(a5),A1
	jsr	-$A2(A6)
	moveq	#7,D0
	move.l	tfmx_L0000E0(a5),A1
	jsr	-$A2(A6)
	move.l	(sp)+,a6
	rts


tfmx_L0000F0	dcb.l	$2,0
	dc.b	2,1			* nt_interrupt, prioriteetti 1
	dc.l	TFMX_Pro.MSG0
	dcb.w	$2,0
tfmxi1	dc.l	0
tfmx_L000106	dcb.l	$2,0
	dc.b	2,100
	dc.l	TFMX_Pro.MSG0
	dcb.w	$2,0
tfmxi2	dc.l	0
tfmx_L00011C	dcb.l	$2,0
	dc.b	2,100
	dc.l	TFMX_Pro.MSG0
	dcb.w	$2,0
tfmxi3	dc.l	0
tfmx_L000132	dcb.l	$2,0
	dc.b	2,100
	dc.l	TFMX_Pro.MSG0
	dcb.w	$2,0
tfmxi4	dc.l	0
tfmx_L000148	dcb.l	$2,0
	dc.b	2,100
	dc.l	TFMX_Pro.MSG0
	dcb.w	$2,0
tfmxi5	dc.l	0
TFMX_Pro.MSG0 dc.b "TFMX",0
 even


* palauttaa songien m��r�n d0:ssa
gettfmxsongs
	move.l	moduleaddress(a5),a0
	lea	$0100(a0),a0
	moveq.l	#-2,d0
	moveq.l	#2,d1
	moveq.l	#$1e,d2
.35a	addq.l	#1,d0
	tst.w	(a0)+
	bne.s	.362
	subq.l	#1,d1
.362	dbeq	d2,.35a
	rts	


******************************************************************************
* TFMX 7 channels
******************************************************************************



p_tfmx7
	jmp	.tfmxinit(pc)
	dc.l	$4e754e75

	jmp	.vb(pc)
;	dc.l	$4e754e75

	jmp	.tfmxend(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.tfmxvol(pc)
	jmp	.tfmxsong(pc)
	jmp	.eteen(pc)
	jmp	.taakse(pc)
	dc.l	$4e754e75
	dc	pf_volume!pf_song!pf_poslen!pf_kelaus!pf_end
	dc.b	"TFMX 7ch",0
 even


.eteen
	pushm	d0/a0
	move.l	tfmx7routines(a5),a0
	move	6246(a0),d0
	addq	#2,d0
	cmp	6244(a0),d0
	bhi.b	.og
	subq	#1,d0
	move	d0,6246(a0)
.og	popm	d0/a0
	rts

.taakse
	push	a0
	move.l	tfmx7routines(a5),a0
	subq	#1,6246(a0)
	bpl.b	.gog
	clr	6246(a0)
.gog	pop	a0
	rts

.vb	push	a0
	move.l	tfmx7routines(a5),a0
	move	6244(a0),pos_maksimi(a5)
	move	6246(a0),pos_nykyinen(a5)
	pop	a0
	rts

.tfmxend
	tst.l	tfmx7routines(a5)
	beq.b	.e
	move.l	tfmx7routines(a5),a4
	pushm	all
	jsr	4(a4)
	popm	all
	bsr.w	vapauta_kanavat
	move.l	.tfmxbuf(pc),a0
	jsr	freemem
	clr.l	.tfmxbuf
.e	rts

.tfmxsong
	bsr.b	.tfmxend
;	bra.w	.tfmxinit

.tfmxinit
	bsr.w	varaa_kanavat
	beq.b	.okk
	moveq	#ier_nochannels,d0
	rts
.okk
	movem.l	d1-a6,-(sp)
	bsr.b	.eh
	movem.l	(sp)+,d1-a6
	rts

.eh
	lea	tfmx7routines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok
	rts
.ok
	move.l	#4096+1024,d0	* +turva-alue
	move.l	#MEMF_CHIP!MEMF_CLEAR,d1
	jsr	getmem
	move.l	d0,.tfmxbuf
	bne.b	.ok2
;	lea	tfmx7routines(a5),a0
;	bsr.w	freereplayer
	moveq	#ier_nomem,d0
	rts
.ok2	

	bsr.w	gettfmxsongs
	move	d0,maxsongs(a5)


	move.l	moduleaddress(a5),a0
	cmp.l	#"TFHD",(a0)
	bne.b	.noo

	move.l	a0,d0
	add.l	4(a0),d0		* MDAT
	move.l	d0,d1
	add.l	10(a0),d1		* SMPL
	bra.b	.un
.noo
	move.l	moduleaddress(a5),d0
	move.l	tfmxsamplesaddr(a5),d1

.un
	move.l	tfmxroutines(a5),a4
	moveq	#0,d3
	move	songnumber(a5),d3
	moveq	#0,d2
	move	tfmxmixingrate(a5),d2
	move.l	.tfmxbuf(pc),d4
	move.l	a5,-(sp)
	jsr	(a4)
	move.l	(sp)+,a5
	bsr.b	.tfmxvol
	moveq	#0,d0
	rts


.tfmxbuf dc.l	0	* koko 4096

.tfmxvol
	move	mainvolume(a5),d0
	move.l	tfmx7routines(a5),a4
	move.l	a5,-(sp)
	jsr	8(a4)
	move.l	(sp)+,a5
	rts



******************************************************************************
* MED
******************************************************************************

p_med	jmp	.medinit(pc)
	dc.l	$4e754e75
	jmp	.medvb(pc)
	jmp	.medend(pc)
	jmp	.medstop(pc)
	jmp	.medcont(pc)
	dc.l	$4e754e75
	jmp	.medsong(pc)
	jmp	.eteen(pc)
	jmp	.taakse(pc)
	dc.l	$4e754e75
.flgs	dc	pf_stop!pf_cont!pf_poslen!pf_kelaus!pf_song
	dc.b	"MED "
.nam1	dc.b	"     "
.nam2	dc.b	"      ",0

.pahk1  dc.b	"4ch",0
.pahk2  dc.b	"5-8ch",0
.pahk3	dc.b	"1-64ch",0

 even
 
.medvb
	move.l	moduleaddress(a5),a0
	move	46(a0),pos_nykyinen(a5)
	move.l	8(a0),a0
	move	506(a0),pos_maksimi(a5)
	rts

.eteen
	movem.l	d0/d1/a0,-(sp)
	move.l	moduleaddress(a5),a0
	move	pos_maksimi(a5),d0
	move	46(a0),d1
	addq	#1,d1
	cmp	d0,d1
	blo.b	.a
	clr	d1
.a	move	d1,46(a0)
;	clr	44(a0)
;	clr	48(a0)
;	clr.b	50(a0)
	move	d1,pos_nykyinen(a5)
	movem.l	(sp)+,d0/d1/a0
	rts
.taakse
	movem.l	d0/a0,-(sp)
	move.l	moduleaddress(a5),a0
	move	46(a0),d0
	subq	#1,d0
	bpl.b	.b
	clr	d0
.b	move	d0,46(a0)
;	clr	44(a0)
	move	d0,pos_nykyinen(a5)
	movem.l	(sp)+,d0/a0
.yee	rts



.medinit
	movem.l	d1-a6,-(sp)

	move.l	_MedPlayerBase(a5),d0
	bne.w	.ook

;	move	#30,maxsongs(a5)


	lea	.flgs(pc),a1
	or	#pf_song!pf_kelaus!pf_poslen,(a1)
	move.l	moduleaddress(a5),a0
	move.l	(a0),.nam1
	cmp.l	#"MMD2",(a0)		* onko mmd2+? poistetaan kelaus..
	blo.b	.olde
	and	#~pf_kelaus!pf_poslen,(a1)
.olde
	bsr.w	whatgadgets

	move.l	moduleaddress(a5),a0
	moveq	#0,d0
	move.b	51(a0),d0
	move	d0,maxsongs(a5)

	tst.b	medrelocced(a5)		* oliko jo relokatoitu??
	bne.w	.yeep


	move.l	moduleaddress(a5),a0
	move.l	32(a0),a1		* MMD0exp
	add.l	a0,a1
	move.l	44(a1),d0		* songname
	beq.b	.nonam
	add.l	d0,a0	

	lea	modulename(a5),a1	* nimi talteen
	moveq	#40-1,d0
.co	move.b	(a0)+,(a1)+
	dbeq	d0,.co
	clr.b	(a1)
	bsr.w	lootaan_nimi	
.nonam
	

	move.l	moduleaddress(a5),a0
	move	506(a1),pos_maksimi(a5)

	move.l	8(a0),a1		* MMD0song *song
	add.l	a0,a1			* reloc

	btst	#6,767(a1)		* flags; 5-8 kanavaa?
	sne	d0
	btst	#7,768(a1)		* flags2; miksaus?
	sne	d1
	and	#%01,d0
	and	#%10,d1
	or	d1,d0
	move.b	d0,medtype(a5)

	cmp.b	#3,d0
	bhs.b	.error2

* d0:
* 0 = 4ch   medplayer
* 1 = 5-8ch octaplayer
* 2 = 1-64ch octamixplayer
* 3 = 1-64ch octamixplayer?


** katotaan onko midisampleja.
* a0 = 63 samplestructuree, 8 bytee kukin
	moveq	#63-1,d1
	moveq	#0,d7
.chmi	tst.b	4(a0)		* midich, 0 jos ei midi
	beq.b	.jep
	addq	#1,d7
;	jsr	flash
.jep	addq	#8,a0	
	dbf	d1,.chmi


	lea	.nam2(pc),a0
	lea	.pahk1(pc),a1
	tst.b	d0
	beq.b	.di
	lea	.pahk2(pc),a1
	subq.b	#1,d0
	beq.b	.di
	lea	.pahk3(pc),a1
.di	move.b	(a1)+,(a0)+
	bne.b	.di


;	cmp.b	#2,medtype(a5)
;	bne.b	.yeep

	move.l	moduleaddress(a5),a0	* pistet��nk� fastiin?
	btst	#0,20(a0)		* mmdflags; MMD_LOADTOFASTMEM
	beq.b	.yeep

** jos on octamixplayerill� soitettava ja sijaitsee chipiss�, koitetaan
** siirt�� fastiin:
	bsr.w	siirra_moduuli2


.yeep
	
	lea	get_med1(pc),a0		* medplayer
	move.b	medtype(a5),d0
	beq.b	.do
	lea	get_med2(pc),a0		* octaplayer
	subq.b	#1,d0
	beq.b	.do
	lea	get_med3(pc),a0		* octamixplayer
.do	jsr	(a0)
	
	move.l	d0,_MedPlayerBase(a5)
	bne.b	.ook
	moveq	#ier_nomedplayerlib,d0
.ee	movem.l	(sp)+,d1-a6
	rts

.error2
	moveq	#ier_mederr,d0
	bra.b	.ee


.ook
	move.l	d0,a6

	tst	d7
	beq.b	.nomidi		* onko midisampleja?

	moveq	#1,d0		* saadaanko seriali?
	bsr.b	.getplayer
	tst.l	d0
	beq.b	.gotserial
.nomidi	moveq	#0,d0		* jos ei, kokeillaan ilman.
	bsr.b	.getplayer
	tst.l	d0
	bne.b	.error2
.gotserial
	tst.b	medrelocced(a5)
	bne.b	.eek
	st	medrelocced(a5)
	move.l	moduleaddress(a5),a0
	bsr.b	.relocmodule
.eek	
	moveq	#0,d0
	move	songnumber(a5),d0
	bsr.b	.setmodnum
	move.l	moduleaddress(a5),a0
 	bsr.b	.playmodule
	movem.l	(sp)+,d1-a6
	moveq	#0,d0
	rts

.getplayer
	jsr	dela
	bsr.b	.G
	jmp	dela

.G
	moveq	#_LVOMEDGetPlayer,d7
	move.b	medtype(a5),d6
	beq.b	.do2
	moveq	#_LVOMEDGetPlayer8,d7
	subq.b	#1,d6
	beq.b	.do2
	moveq	#_LVOMEDGetPlayerM,d7
.do2	jmp	(a6,d7)

.relocmodule
	moveq	#_LVOMEDRelocModule,d7
	move.b	medtype(a5),d6
	beq.b	.do3
	moveq	#_LVOMEDRelocModule8,d7
	subq.b	#1,d6
	beq.b	.do3
	moveq	#_LVOMEDRelocModuleM,d7
.do3	jmp	(a6,d7)

.setmodnum
	moveq	#_LVOMEDSetModnum,d7
	move.b	medtype(a5),d6
	beq.b	.do4
	moveq	#_LVOMEDSetModnum8,d7
	subq.b	#1,d6
	beq.b	.do4
	moveq	#_LVOMEDSetModnumM,d7
.do4	jmp	(a6,d7)


.playmodule
	jsr	dela
	bsr.b	.P
	jmp	dela
.P

	moveq	#_LVOMEDPlayModule,d7
	move.b	medtype(a5),d6
	beq.b	.do5
	moveq	#_LVOMEDPlayModule8,d7
	subq.b	#1,d6
	beq.b	.do5a

** octamixplayer
	moveq	#0,d0			* 8-bit
	move.b	medmode(a5),d0		* 1: 14-bit
	lob	MEDSet14BitMode
	moveq	#0,d0
	move	medrate(a5),d0		* mixingrate
	lob	MEDSetMixingFrequency

	moveq	#_LVOMEDPlayModuleM,d7
.do5	jmp	(a6,d7)


** octaplayer. asetetaan SetHQ() jos tarvis
.do5a
	moveq	#0,d0
	move.b	medmode(a5),d0
	lob	MEDSetHQ
	bra.b	.do5


.medend
	jsr	dela
	bsr.b	.E
	jmp	dela
.E
	movem.l	d0/d1/a0/a1/a6,-(sp)
	move.l	_MedPlayerBase(a5),a6

	moveq	#_LVOMEDFreePlayer,d0
	move.b	medtype(a5),d1
	beq.b	.do6
	moveq	#_LVOMEDFreePlayer8,d0
	subq.b	#1,d1
	beq.b	.do6
	moveq	#_LVOMEDFreePlayerM,d0
.do6	jsr	(a6,d0)

	move.l	a6,d0
	jsr	closel
	clr.l	_MedPlayerBase(a5)

	movem.l	(sp)+,d0/d1/a0/a1/a6
	rts

.medstop
	movem.l	d0/d1/a0/a1/a6,-(sp)
	move.l	_MedPlayerBase(a5),a6

	moveq	#_LVOMEDStopPlayer,d0
	move.b	medtype(a5),d1
	beq.b	.do7
	moveq	#_LVOMEDStopPlayer8,d0
	subq.b	#1,d1
	beq.b	.do7
	moveq	#_LVOMEDStopPlayerM,d0
.do7	jsr	(a6,d0)

	movem.l	(sp)+,d0/d1/a0/a1/a6
	rts

.medcont
	movem.l	d0/d1/a0/a1/a6,-(sp)
	move.l	_MedPlayerBase(a5),a6
	move.l	moduleaddress(a5),a0

	moveq	#_LVOMEDContModule,d0
	move.b	medtype(a5),d1
	beq.b	.do8
	moveq	#_LVOMEDContModule8,d0
	subq.b	#1,d1
	beq.b	.do8
	moveq	#_LVOMEDContModuleM,d0
.do8	jsr	(a6,d0)

	movem.l	(sp)+,d0/d1/a0/a1/a6
	rts


.medsong
	bsr.w	.medend
	bra.w	.medinit




******************************************************************************
* The Player v6.1a
******************************************************************************
 
p_player
	jmp	.p60init(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.p60end(pc)
	jmp	.p60stop(pc)
	jmp	.p60cont(pc)
	jmp	.p60volume(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_stop!pf_cont!pf_volume
	dc.b	"The Player 6.1A",0
 even

.p60end
	movem.l	d0-a6,-(sp)
	lea	$dff000,a6
	move.l	p60routines(a5),a0
	jsr	P61_EndOffset(a0)

	bsr.b	.frees

	movem.l	(sp)+,d0-a6
	rts


.frees	move.l	player60samples(a5),d0
	beq.b	.eee
	move.l	d0,a0
	jsr	freemem
	clr.l	player60samples(a5)
.eee	rts

.p60stop
	move.l	p60routines(a5),a0
	clr	P61_PlayFlag(a0)
	bra.w	clearsound
.p60cont
	move.l	p60routines(a5),a0
	st	P61_PlayFlag+1(a0)
	rts

.p60volume
	push	a0
	move.l	p60routines(a5),a0
	move	mainvolume(a5),P61_MasterVolume(a0)
	pop	a0
	rts

.p60init
	lea	p60routines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok
	rts
.ok
	movem.l	d1-a6,-(sp)
	move.l	moduleaddress(a5),a0
	cmp.l	#'P61A',(a0)
	bne.b	.ee
	addq.l	#4,a0
.ee
	btst	#6,3(a0)
	beq.b	.nopacked

	tst.l	player60samples(a5)	* ei uusiks
	bne.b	.nopacked
	move.l	4(a0),d0
	addq.l	#8,d0
	moveq	#MEMF_CHIP,d1
	jsr	getmem
	move.l	d0,player60samples(a5)
	beq.b	.memerr
.nopacked

	move.l	p60routines(a5),a0
	move.b	tempoflag(a5),d0
	not.b	d0
	move.b	d0,P61_UseTempo+1(a0)
	st	P61_PlayFlag+1(a0)
	bsr.b	.p60volume

	move.l	moduleaddress(a5),a0
	moveq	#0,d0
	sub.l	a1,a1
	move.l	player60samples(a5),a2
	lea	$dff000,a6
	move.l	p60routines(a5),a3
	jsr	P61_InitOffset(a3)
	tst	d0
	beq.b	.ok2
;	lea	p60routines(a5),a0
;	bsr.w	freereplayer
	bsr.w	.frees
	moveq	#ier_playererr,d0
.ok2	movem.l	(sp)+,d1-a6
	rts

.memerr	
;	lea	p60routines(a5),a0
;	bsr.w	freereplayer
	moveq	#ier_nomem,d0
	bra.b	.ok2



******************************************************************************
* Mark II
******************************************************************************



p_markii
	jmp	.markinit(pc)
	jmp	.markmusic(pc)
	dc.l	$4e754e75
	jmp	.markend(pc)
	jmp	clearsound(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_stop!pf_cont!pf_ciakelaus
	dc.b	"Mark II",0
 even

.markinit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2

	pushm	all
	move.l	moduleaddress(a5),a0
	moveq.l	#-1,d0
	jsr	(a0)
	popm	all
	moveq	#0,d0
	rts	

.markmusic
	move.l	moduleaddress(a5),a0
	moveq.l	#0,d0
	moveq.l	#1,d1
	jmp	(a0)

.markend
	pushm	all
	move.l	moduleaddress(a5),a0
	moveq.l	#1,d0
	moveq.l	#1,d1
	jsr	(a0)
	bsr.w	rem_ciaint
	bsr.w	clearsound
	bsr.w	vapauta_kanavat
	popm	all
	rts



******************************************************************************
* Maniacs of Noise
******************************************************************************


p_mon	jmp	.moninit(pc)
	jmp	.monmusic(pc)
	dc.l	$4e754e75
	jmp	.monend(pc)
	jmp	clearsound(pc)
	dc.l	$4e754e75
	jmp	.monvol(pc)
	jmp	.monsong(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_stop!pf_cont!pf_song!pf_volume!pf_ciakelaus
	dc.b	"Maniacs of Noise",0

 even

.moninit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2

.init	pushm	all
	moveq.l	#0,d0
	moveq	#0,d1
	move.l	moduleaddress(a5),a0
	push	a5
	jsr	(a0)
	pop	a5
	move.l	a1,.volu
	move	songnumber(a5),d0
	addq	#1,d0
	moveq.l	#0,d1
	move.l	moduleaddress(a5),a0
	push	a5
	jsr	8(a0)
	pop	a5
	bsr.b	.monvol
	popm	all
	moveq	#0,d0 
	rts	

.monvol	move.l	.volu(pc),a0
	move	mainvolume+var_b,(a0)
	rts

.volu	dc.l	0

.monmusic
	move.l	moduleaddress(a5),a0
	jmp	4(a0)

.monend	bsr.w	rem_ciaint
	bsr.w	clearsound
	bra.w	vapauta_kanavat


.monsong
	bsr.w	clearsound
	bra.b	.init




******************************************************************************
* David Whittaker
******************************************************************************

p_dw	jmp	.dwinit(pc)
	jmp	.dwmusic(pc)
	dc.l	$4e754e75
	jmp	.dwend(pc)
	jmp	clearsound(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.dwsong(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_stop!pf_cont!pf_song!pf_ciakelaus
	dc.b	"David Whittaker",0

 even

.dwinit
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2

.init	
	moveq.l	#0,d0
	move	songnumber(a5),d0
	move.l	moduleaddress(a5),a0
	jsr	(a0)
	moveq	#0,d0
	rts	


.dwmusic
	move.l	moduleaddress(a5),a0
	moveq	#0,d0
	jmp	14(a0)


.dwsong	bsr.b	.dend
	bra.b	.init

.dwend	bsr.w	rem_ciaint
	pushm	all
	bsr.b	.dend
	popm	all
	bra.w	vapauta_kanavat


.dend	move.l	whittaker_end(pc),a0
	moveq.l	#0,d0
	jmp	(a0)



whittaker_end	dc.l	0



******************************************************************************
* Hippel-COSO
******************************************************************************


;	jmp	ini(pc)
;	jmp	Int(pc)
;	jmp	end(pc)
;	jmp	SetVol(pc)
;	jmp	ahi_update(pc)
;	jmp	ahi_pause(pc)

p_hippelcoso
	jmp	.init(pc)
	jmp	.play(pc)
	dc.l	$4e754e75
	jmp	.end(pc)
	jmp	.stop(pc)
	jmp	.cont(pc)
	jmp	.volume(pc)
	jmp	.song(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.ahiupdate(pc)
.liput	dc pf_cont!pf_stop!pf_end!pf_volume!pf_song!pf_ciakelaus!pf_ahi
	dc.b	"Hippel-COSO",0
 even

.stop
	tst.b	ahi_use_nyt(a5)
	beq.w	clearsound

.a	move.l	hippelcosoroutines(a5),a0
	jmp	$20+20(a0)

.cont
	tst.b	ahi_use_nyt(a5)
	bne.b	.a
	rts

.init
	tst.b	ahi_use(a5)
	bne.b	.ahi

	or	#pf_ciakelaus,.liput

	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2
	lea	hippelcosoroutines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok3
.gog	bsr.w	rem_ciaint
	bra.w	vapauta_kanavat
;	rts

.ahi	and	#~pf_ciakelaus,.liput

	lea	hippelcosoroutines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok4
	rts

.ok3	
	bsr.w	siirra_moduuli
	bne.b	.gog
.ok4

	move.l	moduleaddress(a5),a0
	lea	songover(a5),a1
	moveq	#0,d0
	move	songnumber(a5),d0
	addq	#1,d0
	lea	dmawait(pc),a2

	move.l	modulelength(a5),d1
	move.b	ahi_use(a5),d2
	move.l	ahi_mode(a5),d3
	move.l	ahi_rate(a5),d4

* d0 = songnumber
* d1 = modulelength
* d2 = use ahi
* d3 = ahi mode
* d4 = ahi rate
* a0 = module
* a1 = songend
* a2 = dmawait

	move.l	hippelcosoroutines(a5),a3
	jsr	$20+0(a3)
	tst.l	d0
	bne.b	.ER

	bsr.b	.volume
	moveq	#0,d0
.ER	rts	


.play	move.l	hippelcosoroutines(a5),a0
	jmp	$20+4(a0)

.end
	tst.b	ahi_use_nyt(a5)
	bne.b	.ahien

	bsr.w	rem_ciaint
	pushm	all
	move.l	hippelcosoroutines(a5),a0
	jsr	$20+8(a0)
	popm	all
	bsr.w	clearsound
	bra.w	vapauta_kanavat

.ahien	move.l	hippelcosoroutines(a5),a0
	jmp	$20+8(a0)

.volume
	moveq	#64,d0
	sub	mainvolume(a5),d0
	move.l	hippelcosoroutines(a5),a0
	jmp	$20+12(a0)
	
.song
	move.l	hippelcosoroutines(a5),a0
	jsr	$20+8(a0)
	tst.b	ahi_use_nyt(a5)
	bne.b	.sa
	bsr.w	clearsound
.sa	bra.w	.ok3



.ahiupdate
	move.l	hippelcosoroutines(a5),a0
	jmp	$20+16(a0)




******************************************************************************
* Hippel
******************************************************************************

p_hippel
	jmp	.init(pc)
	jmp	.play(pc)
	dc.l	$4e754e75
	jmp	.end(pc)
	jmp	clearsound(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.song(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_song!pf_ciakelaus
	dc.b	"Hippel",0
 even

.init
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	
	bsr.w	init_ciaint
	beq.b	.ok2
	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	rts
.ok2

	move	songnumber(a5),d0
	addq	#1,d0
	move.l	moduleaddress(a5),a0
	jsr	(a0)
	moveq	#0,d0
	rts	


.play	
	move.l	hippelmusic(pc),a0
	jmp	(a0)

.end
	bsr.w	rem_ciaint
	bsr.w	clearsound
	bra.w	vapauta_kanavat



.song
	bsr.w	clearsound
	bra.b	.ok2


hippelmusic	dc.l	0





******************************************************************************
* Digibooster
******************************************************************************


p_digibooster
	jmp	.init(pc)
	dc.l	$4e754e75
	jmp	.vb(pc)
	jmp	.end(pc)
	jmp	.stop(pc)
	jmp	.cont(pc)
	jmp	.volu(pc)
	dc.l	$4e754e75
	jmp	.eteen(pc)
	jmp	.taakse(pc)
	dc.l	$4e754e75
	dc	pf_poslen!pf_kelaus!pf_volume!pf_stop!pf_cont!pf_end
	dc.b	"DIGI Booster",0
 even

.stop
	clr.b	.stopcont
	move	#$f,$dff096
	rts

.cont
	st	.stopcont
	move	#$800f,$dff096
	rts


.volu
	move.l	.vol(pc),a0
	move	mainvolume(a5),(a0)
	rts

.vb
	move.l	.pos(pc),a0
	move.b	(a0),pos_nykyinen+1(a5)
	move.l	.maxpos(pc),a0
	move.b	(a0),pos_maksimi+1(a5)
	rts



.eteen
	move	pos_maksimi(a5),d0
	move	pos_nykyinen(a5),d1
	addq	#1,d1
	cmp	d0,d1
	blo.b	.a
	clr	d1
.a
	move.l	.pos(pc),a0
	move.b	d1,(a0)
	move.l	.pattpos(pc),a0
	clr.b	(a0)

	rts
.taakse
	move.l	.pos(pc),a0
	move.b	(a0),d0
	subq.b	#1,d0
	bpl.b	.b
	clr.b	d0
.b	move.b	d0,(a0)
	move.l	.pattpos(pc),a0
	clr.b	(a0)
	move.b	d0,pos_nykyinen+1(a5)
	rts




.init
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	

	lea	digiboosterroutines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok3
	bra.w	vapauta_kanavat
;	rts

.ok3	

	push	a5
	move.l	moduleaddress(a5),a0
	lea	songover(a5),a1
	lea	.stopcont(pc),a2
	st	(a2)

	move.l	digiboosterroutines(a5),a3
	jsr	$20+0(a3)
	tst.l	d0
	popm	a5
	bne.b	.er


;	lea	songpos(pc),a0
;	move.l	moddigi(pc),a1
;	lea	ordnum(a1),a1
;	lea	pattpos(pc),a2
* 	a3 = vol

	movem.l	a0-a3,.pos
	bsr.w	.volu

	moveq	#0,d0
	rts	

.stopcont dc	0
.pos	dc.l	0
.maxpos	dc.l	0
.pattpos dc.l	0
.vol	dc.l	0



; d7 =  0  all right
; d7 = -1  not enough memory for mixbuffers
; d7 = -2  cant alloc cia timers


.er	bsr.w	vapauta_kanavat

	addq	#1,d0
	bne.b	.cia
	moveq	#ier_nomem,d0
	rts

.cia	moveq	#ier_nociaints,d0
	rts



.end	pushm	all
	move.l	digiboosterroutines(a5),a0
	jsr	$20+4(a0)
	popm	all
	bra.w	vapauta_kanavat




******************************************************************************
* Digibooster PRO
******************************************************************************


p_digiboosterpro
	jmp	.init(pc)
	dc.l	$4e754e75
	jmp	.vb(pc)
	jmp	.end(pc)
	jmp	.stop(pc)
	jmp	.cont(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.eteen(pc)
	jmp	.taakse(pc)
	jmp	.ahiupdate(pc)
	dc	pf_volume!pf_stop!pf_cont!pf_ahi!pf_poslen!pf_kelaus!pf_end
	dc.b	"DIGI Booster Pro",0
 even

.stop
.cont
	move.l	digiboosterproroutines(a5),a0
	jmp	8+$20(a0)

.ahiupdate
	rts	* omat pannaukset ja autoboostit
	
;	move.l	digiboosterproroutines(a5),a0
;	jmp	12+$20(a0)

.vb

	move.l	.songp(pc),a0
	move	(a0),pos_nykyinen(a5)
	move.l	.ordn(pc),a0
	move	(a0),pos_maksimi(a5)
	rts


.init
	move.l	(a5),a0
	btst	#AFB_68020,AttnFlags+1(a0)
	bne.b	.okk
	moveq	#ier_hardware,d0
	rts
.okk


	lea	digiboosterproroutines(a5),a0
	bsr.w	allocreplayer
	bne.b	.x

	move.l	moduleaddress(a5),a0
	move.l	modulelength(a5),d4
	
	move.l	ahi_rate(a5),d0
	move	ahi_mastervol(a5),d1
	move	ahi_stereolev(a5),d2
	move.l	ahi_mode(a5),d3
	move.l	digiboosterproroutines(a5),a1
	lea	mainvolume(a5),a2
	lea	songover(a5),a3

	st	ahi_use_nyt(a5)

	pushm	d1-a6
	jsr	$20+0(a1)

	movem.l	a0/a1/a2,.songp

	popm	d1-a6

	
	tst.l	d0
	beq.b	.x
	moveq	#ier_error,d0

;	moveq	#0,d0
.x	rts	

.end
	pushm	all
	clr.b	ahi_use_nyt(a5)
	move.l	digiboosterproroutines(a5),a1
	jsr	$20+4(a1)
	popm	all
	rts




.eteen
	move	pos_maksimi(a5),d0
	move	pos_nykyinen(a5),d1
	addq	#1,d1
	cmp	d0,d1
	blo.b	.a
	clr	d1
.a
	move.l	.songp(pc),a0
	move	d1,(a0)
	move.l	.pattpos(pc),a0
	clr	(a0)

	rts
.taakse
	move.l	.songp(pc),a0
	move	(a0),d0
	subq	#1,d0
	bpl.b	.b
	clr	d0
.b	move	d0,(a0)
	move.l	.pattpos(pc),a0
	clr	(a0)
	move	d0,pos_nykyinen(a5)
	rts




.songp	dc.l	0
.ordn	dc.l	0
.pattpos dc.l	0


******************************************************************************
* THX
******************************************************************************


p_thx
	jmp	.init(pc)
	jmp	.play(pc)
	jmp	.vb(pc)
	jmp	.end(pc)
	jmp	.stop(pc)
	jmp	.cont(pc)
	jmp	.volu(pc)
	jmp	.song(pc)
	jmp	.eteen(pc)
	jmp	.taakse(pc)
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_volume!pf_end!pf_song!pf_kelaus!pf_poslen
	dc.b	"AHX Sound System",0
 even



.ahxInitCIA          = 0*4
.ahxInitPlayer       = 1*4
.ahxInitModule       = 2*4
.ahxInitSubSong      = 3*4
.ahxInterrupt        = 4*4
.ahxStopSong         = 5*4
.ahxKillPlayer       = 6*4
.ahxKillCIA          = 7*4
.ahxNextPattern      = 8*4       ;implemented, although no-one requested it :-)
.ahxPrevPattern      = 9*4       ;implemented, although no-one requested it :-)

.ahxBSS_P            = 10*4      ;pointer to ahx's public (fast) memory block
.ahxBSS_C            = 11*4      ;pointer to ahx's explicit chip memory block
.ahxBSS_Psize        = 12*4      ;size of public memory (intern use only!)
.ahxBSS_Csize        = 13*4      ;size of chip memory (intern use only!)
.ahxModule           = 14*4      ;pointer to ahxModule after InitModule
.ahxIsCIA            = 15*4      ;byte flag (using ANY (intern/own) cia?)
.ahxTempo            = 16*4      ;word to cia tempo (normally NOT needed to xs)

.ahx_pExternalTiming = 0         ;byte, offset to public memory block
.ahx_pMainVolume     = 1         ;byte, offset to public memory block
.ahx_pSubsongs       = 2         ;byte, offset to public memory block
.ahx_pSongEnd        = 3         ;flag, offset to public memory block
.ahx_pPlaying        = 4         ;flag, offset to public memory block
.ahx_pVoice0Temp     = 14        ;struct, current Voice 0 values
.ahx_pVoice1Temp     = 246       ;struct, current Voice 1 values
.ahx_pVoice2Temp     = 478       ;struct, current Voice 2 values
.ahx_pVoice3Temp     = 710       ;struct, current Voice 3 values

.ahx_pvtTrack        = 0         ;byte          (relative to ahx_pVoiceXTemp!)
.ahx_pvtTranspose    = 1         ;byte          (relative to ahx_pVoiceXTemp!)
.ahx_pvtNextTrack    = 2         ;byte          (relative to ahx_pVoiceXTemp!)
.ahx_pvtNextTranspose= 3         ;byte          (relative to ahx_pVoiceXTemp!)
.ahx_pvtADSRVolume   = 4         ;word, 0..64:8 (relative to ahx_pVoiceXTemp!)
.ahx_pvtAudioPointer = 92        ;pointer       (relative to ahx_pVoiceXTemp!)
.ahx_pvtAudioPeriod  = 100       ;word          (relative to ahx_pVoiceXTemp!)
.ahx_pvtAudioVolume  = 102       ;word          (relative to ahx_pVoiceXTemp!)

; current ADSR Volume (0..64) = ahx_pvtADSR.w >> 8        (I use 24:8 32-Bit)
; ahx_pvtAudioXXX are the REAL Values passed to the hardware!



.eteen	move.l	thxroutines(a5),a0
	jmp	.ahxNextPattern(a0)

.taakse	move.l	thxroutines(a5),a0
	jmp	.ahxPrevPattern(a0)


.stop
	move	#$f,$dff096
	bra.b	.sc

.cont	move	#$800f,$dff096
.sc	move.l	thxroutines(a5),a0
	move.l	.ahxBSS_P(a0),a0
	not.b	.ahx_pPlaying(a0)
	rts

	

.volu	move.l	thxroutines(a5),a0
	move.l	.ahxBSS_P(a0),a0
	move.b	mainvolume+1(a5),.ahx_pMainVolume(a0)
	rts

.vb	move.l	thxroutines(a5),a0
	move.l	.ahxBSS_P(a0),a0

	move	$448+4(a0),pos_nykyinen(a5)
	move	$44c+4(a0),pos_maksimi(a5)

	tst.b	.ahx_pSongEnd(a0)
	beq.b	.x
	clr.b	.ahx_pSongEnd(a0)
	st	songover(a5)
.x	rts




.init

;	bsr.w	varaa_kanavat
;	beq.b	.ok
;	moveq	#ier_nochannels,d0
;	rts
;.ok	

	lea	thxroutines(a5),a0
	bsr.w	allocreplayer
;	bne.w	vapauta_kanavat
	beq	.ok3
	rts

;	beq.b	.ok3
;	bra.w	vapauta_kanavat
;;	rts

.ok3	

	pushm	d1-a6


	lea	.ahxCIAInterrupt(pc),a0
	moveq	#0,d0
	move.l	thxroutines(a5),a2
	jsr	.ahxInitCIA(a2)
	tst	d0
	bne.b	.thxInitFailed2


	moveq	#0,d0	* loadwavesfile if possible
	moveq	#0,d1	* calculate filters (ei thx v 1.xx!!)

	move.l	moduleaddress(a5),a0
	tst.b	3(a0)
	bne.b	.new
	moveq	#1,d1	* ei filttereit�!
.new

	sub.l   a0,a0	* auto alloc fast mem
	sub.l   a1,a1	* auto alloc chip
	move.l	thxroutines(a5),a2
	jsr	.ahxInitPlayer(a2)
	tst	d0
	beq.b	.ok4

	move.l	thxroutines(a5),a2
	jsr	.ahxKillCIA(a2)
;	bsr.w	vapauta_kanavat
	moveq	#ier_nomem,d0
	bra.b	.xxx
.ok4
	
	moveq	#0,d0			* normal speed
	move.l	moduleaddress(a5),a0
	jsr	.ahxInitModule(a2)
	tst	d0
	bne.b	.thxInitFailed


	move.l	.ahxBSS_P(a2),a0
	clr	maxsongs(a5)
	move.b	.ahx_pSubsongs(a0),maxsongs+1(a5)

	moveq	#0,d0
	move	songnumber(a5),d0
	moveq   #0,d1
	jsr	.ahxInitSubSong(a2)


	bsr.w	.volu
	popm	d1-a6

	moveq	#0,d0
	rts	

.thxInitFailed
	move.l	thxroutines(a5),a2
	jsr	.ahxKillCIA(a2)
.thxInitFailed2

;	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
.xxx
	popm	d1-a6
	rts


.ahxCIAInterrupt
.play
	move.l	thxroutines+var_b,a0
	jmp	.ahxInterrupt(a0)

.end	bsr.b	.halt
;	bra.w	vapauta_kanavat
	rts

.song	bsr.b	.halt
	bra.w	.ok3


.halt	
	pushm	all
	move.l	thxroutines(a5),a2
	jsr	.ahxKillCIA(a2)
	popm	all
.halt2	move.l	thxroutines(a5),a2
	jsr	.ahxStopSong(a2)
	jsr	.ahxKillPlayer(a2)
	
	bra.w	clearsound





******************************************************************************
* MusiclineEditor
******************************************************************************

p_mline
	jmp	.init(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.end(pc)
	jmp	.stop(pc)
	jmp	.cont(pc)
	jmp	.volume(pc)
	jmp	.song(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_volume!pf_song
	dc.b	"MusiclineEditor",0
 even

._LVOInitPlayer		=	-30
._LVOEndPlayer		=	-36
._LVOStartPlay		=	-42
._LVOStopPlay		=	-48
._LVOInitTune		=	-54
._LVOMasterVol		=	-60
._LVOSubTuneRange	=	-66
._LVOSelectTune		=	-72
._LVONextTune		=	-78
._LVOPrevTune		=	-84
._LVOCheckModule	=	-90


.init
	lea	-200(sp),sp
	move.l	sp,a4

	lea	arcdir(a5),a0
	move.l	a4,a1
.c	move.b	(a0)+,(a1)+
	bne.b	.c
	subq	#1,a1
	cmp.b	#':',-1(a1)
	beq.b	.cc
	cmp.b	#'/',-1(a1)
	beq.b	.cc
	move.b	#'/',(a1)+
.cc
	lea	.foo(pc),a0
.c2	move.b	(a0)+,(a1)+
	bne.b	.c2


	move.l	a4,d1
	move.l	#MODE_NEWFILE,d2
	lore	Dos,Open
	move.l	d0,d7
	beq.b	.orr

	move.l	d7,d1
	move.l	moduleaddress(a5),d2
	move.l	modulelength(a5),d3
	lob	Write
	move.l	d7,d1
	lob	Close

	bsr.w	get_mline
	bne.b	.ok0
	lea	200(sp),sp
	moveq	#ier_nomled,d0
	rts
.ok0
	move.l	a4,a0
	move.l	_MlineBase(a5),a6
	jsr	._LVOInitPlayer(a6)
	tst.l	d0
	beq.b	.ok

	bsr.b	.del
.orr	lea	200(sp),sp
	moveq	#ier_mlederr,d0
	rts
.ok
	jsr	._LVOSubTuneRange(a6)
	move	d1,maxsongs(a5)

	jsr	._LVOInitTune(a6)
	jsr	._LVOStartPlay(a6)
	bsr.b	.volume

	bsr.b	.del

	lea	200(sp),sp
	moveq	#0,d0
	rts

.del	move.l	a4,d1
	move.l	_DosBase(a5),a6
	jmp	_LVODeleteFile(a6)

.end
	move.l	_MlineBase(a5),a6
	jmp	._LVOEndPlayer(a6)

.cont
	move.l	_MlineBase(a5),a6
	jmp	._LVOStartPlay(a6)
	
.stop
	move.l	_MlineBase(a5),a6
	jmp	._LVOStopPlay(a6)

.volume
	moveq	#0,d0
	move	mainvolume(a5),d0
	move.l	_MlineBase(a5),a6
	jmp	._LVOMasterVol(a6)

.song
	moveq	#0,d0
	move	songnumber(a5),d0
	move.l	_MlineBase(a5),a6
	jmp	._LVOSelectTune(a6)

.foo	dc.b	"��HiP-MLine",0
 even





******************************************************************************
* Artofnoise
******************************************************************************

p_aon
	jmp	.init(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	jmp	.end(pc)
	jmp	.stop(pc)
	jmp	.cont(pc)
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc.l	$4e754e75
	dc	pf_cont!pf_stop!pf_volume
	dc.b	"Art Of Noise 4ch",0
 even

.init
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	

	lea	aonroutines(a5),a0
	bsr.w	allocreplayer
	bne.w	vapauta_kanavat

.ok3	
	pushm	d1-a6

	move.l	moduleaddress(a5),a0
	lea	mainvolume(a5),a1
	moveq	#0,d0
	move.l	aonroutines(a5),a2
	jsr	(a2)
	tst.l	d0
	bne.b	.cia

.x	popm	d1-a6
	rts

.cia	bsr.w	vapauta_kanavat
	moveq	#ier_nociaints,d0
	bra.b	.x


.end	move.l	aonroutines(a5),a0
	jsr	4(a0)
	bsr.w	clearsound
	bra.w	vapauta_kanavat


.stop
	move	#$f,$dff096
	bclr	#0,$bfdf00
	rts

.cont	
	move	#$800f,$dff096
	bset	#0,$bfdf00	; Timer start, stop
	rts


******************************************************************************
* PS3M
******************************************************************************


	rsset	14+32
init1j		rs.l	1
init2j		rs.l	1
init0j		rs.l	1
poslenj		rs.l	1
endj		rs.l	1
stopj		rs.l	1
contj		rs.l	1
eteenj		rs.l	1
taaksej		rs.l	1
volj		rs.l	1
boostj		rs.l	1

p_multi	jmp	.s3init(pc)
	dc.l	$4e754e75		* CIA
	jmp	.s3poslen(pc)		* VB
	jmp	.s3end(pc)
	jmp	.s3stop(pc)
	jmp	.s3cont(pc)
	jmp	.s3vol(pc)
	dc.l	$4e754e75		* Song
	jmp	.eteen(pc)
	jmp	.taakse(pc)
	jmp	ps3m_boost(pc)		* ahiupdate
 dc pf_cont!pf_stop!pf_volume!pf_kelaus!pf_poslen!pf_end!pf_scope!pf_ahi
	dc.b	"PS3M",0
 even



;init1j	jmp	init1r(pc)
;init2j	jmp	init2r(pc)
;init0j	jmp	s3init(pc)
;poslenj	jmp	s3poslen(pc)
;endj	jmp	s3end(pc)
;stopj	jmp	s3stop(pc)
;contj	jmp	s3cont(pc)
;eteenj	jmp	eteen(pc)
;taaksej	jmp	taakse(pc)


.s3init
	bsr.w	varaa_kanavat
	beq.b	.ok
	moveq	#ier_nochannels,d0
	rts
.ok	bsr.w	vapauta_kanavat

	bsr.w	init_ciaint
	beq.b	.ok2
	moveq	#ier_nociaints,d0
	rts
.ok2	bsr.w	rem_ciaint


	lea	ps3mroutines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok3
	rts

.ok3	
	pushm	d1-a6
	addq	#1,ps3minitcount

	move	mixirate+2(a5),hip_ps3mrate+hippoport(a5)


* v�litet��n tietoa ps3m:lle ja hankitaan sit� silt�

	move.b	cybercalibration(a5),d0
	move.l	calibrationaddr(a5),d1

	move.b	ahi_use(a5),d2
	move.l	ahi_rate(a5),d3
	move	ahi_mastervol(a5),d4
	move	ahi_stereolev(a5),d5
	move.l	ahi_mode(a5),d6
	move.l	modulelength(a5),d7

	lea	ps3m_mname(a5),a0
	lea	ps3m_numchans(a5),a1
	lea	ps3m_mtype(a5),a2
	lea	ps3m_samples(a5),a3
	lea	ps3m_xm_insts(a5),a4
	move.l	ps3mroutines(a5),a6
	jsr	init1j(a6)

	pushpea	CHECKSTART,d0		* tarkistussummaa varten
	lea	ps3m_buff1(a5),a0
	lea	ps3m_buff2(a5),a1
	lea	ps3m_mixingperiod(a5),a2
	lea	ps3m_playpos(a5),a3
	lea	ps3m_buffSizeMask(a5),a4
	move.l	ps3mroutines(a5),a6
	jsr	init2j(a6)
	move.l	d0,ps3mchannels(a5)



	move.l	mixirate(a5),d0	
	move.b	s3mmode3(a5),d1		* volumeboost
	moveq	#0,d3
	move.b	s3mmode2(a5),d3		* mono/stereo/surround
	move.b	s3mmode1(a5),d4		* priority/killer

	move.l	moduleaddress(a5),d2	* moduuli

	move.b	ps3mb(a5),d5		* mixing buffer size
	lea	playing(a5),a0		* stop/cont-lippu
	lea	inforivit_killerps3m,a1	* killer ps3m viesti
	lea	mainvolume(a5),a2	* voluumi
	move.l	_DosBase(a5),a3
	lea	songover(a5),a4		* kappale loppuu-lippu
	move.l	_GFXBase(a5),a6
	pushpea	pos_nykyinen(a5),d6	* songpos -osoite
	pushpea	.adjustroutine(pc),d7	* asetusten s��t�rutiini
	move.l	ps3mroutines(a5),a5
	pea	.updateps3m3(pc)	* updaterutiini, surroundin stereo
	jsr	init0j(a5)
	addq	#4,sp

	popm	d1-a6
	cmp	#333,d0		* killermoden koodi
	bne.b	.e
	addq	#4,sp		* killer: hyp�t��n play-aliohjelman 'ohi'
.e	rts


.updateps3m3
	pushm	d1/a5
	lea	var_b,a5
	cmp.b	#1,s3mmode2(a5)		* onko surround?
	bne.b	.nd
	moveq	#64,d1
	sub.b	stereofactor(a5),d1
	move	d1,$dff0c8
	move	d1,$dff0d8
.nd	popm	d1/a5
	rts


.s3poslen
	move.l	ps3mroutines(a5),a0
	jmp	poslenj(a0)

.s3end	move.l	ps3mroutines(a5),a0
	jmp	endj(a0)

.s3stop	move.l	ps3mroutines(a5),a0
	jmp	stopj(a0)

.s3cont	move.l	ps3mroutines(a5),a0
	jmp	contj(a0)

.s3vol	move.l	ps3mroutines(a5),a0
	jmp	volj(a0)

.eteen	move.l	ps3mroutines(a5),a0
	jmp	eteenj(a0)

.taakse	move.l	ps3mroutines(a5),a0
	jmp	taaksej(a0)


******** Asetukset kanavam��r�n mukaan
* t�nne hyp�t��n initin j�lkeen. d0:ssa on kanavien m��r�.

.adjustroutine
	pushm	d2/d6-a6
	lea	var_b,a5
	moveq	#0,d6			* -1: vaikuttaa, 0: ei vaikuta
	cmp	#1,ps3minitcount	* asetustiedosto vaikuttaa vain
	bne.w	.xei			* ensimm�iseen inittiin latauksen
					* j�lkeen

	tst.b	ps3msettings(a5)	* k�ytet��nk� vai ei?
	beq.w	.xei

	move	d0,d7			* kanavien m��r�

	move.l	ps3msettingsfile(a5),d0
	beq.w	.xei
	move.l	d0,a0
	bsr.w	.tah

	moveq	#-1,d6

	lea	32*13(a0),a1		* file asetukset t��ll�

	move	d7,d0			* ensin asetukset kanavataulukosta
	subq	#1,d0
	mulu	#13,d0
	add	d0,a0
	addq	#3,a0
	bsr.w	.gets

	move.l	a1,a0			* t�htirivien ohi
	bsr.w	.tah

	move.l	solename(a5),a1
.fine	tst.b	(a1)+
	bne.b	.fine
	sub.l	solename(a5),a1
	subq	#1,a1
	move	a1,d2

.filel
	addq	#1,a0
	cmp.b	#'�',(a0)		* loppumerkki?
	beq.b	.golly
	move	d2,d5
	subq	#1,d5

	move.l	solename(a5),a1
.fid	cmpm.b	(a0)+,(a1)+
	bne.b	.fe
	dbf	d5,.fid
	addq	#2,a0
	bsr.b	.gets
	bra.b	.golly

.fe	cmp.b	#10,(a0)+
	bne.b	.fe
	bra.b	.filel

.golly



***** nappulat prefsiss�
	pushm	all
	move.l	mixirate(a5),d0
	sub.l	#5000,d0
	divu	#100,d0
	mulu	#65535,d0
	divu	#580-50,d0
	lea	pslider1,a0
	jsr	setknob2
	lea	juusto,a0
	moveq	#0,d0
	move.b	s3mmode3(a5),d0
	mulu	#65535,d0
	divu	#8,d0
	jsr	setknob2
	popm	all


	move.l	mixirate(a5),d0		* mixingrate
	move.b	s3mmode3(a5),d1		* volumeboost
	moveq	#0,d3
	move.b	s3mmode2(a5),d3		* mono/stereo/surround/jne..
	move.b	s3mmode1(a5),d4		* pri/killer

.xei	tst.l	d6
	popm	d2/d6-a6
	rts

.find0	cmp.b	#10,(a0)+
	bne.b	.find0

.tah
.f0
	cmp.b	#'"',(a0)
	beq.b	.ofk
	cmp.b	#'0',(a0)
	bne.b	.find0	
.ofk	rts


.gets	move.b	(a0),d0
	cmp.b	#'?',d0
	beq.b	.sk0
	and	#$f,d0
	move.b	d0,s3mmode1(a5)	
	move.b	d0,s3mmode1_new(a5)
.sk0
	move.b	2(a0),d0
	cmp.b	#'?',d0
	beq.b	.sk1
	and	#$f,d0
	move.b	d0,s3mmode2(a5)
	move.b	d0,s3mmode2_new(a5)
.sk1
	move.b	4(a0),d0
	cmp.b	#'?',d0
	beq.b	.sk2
	and	#$f,d0
	move.b	d0,s3mmode3(a5)
	move.b	d0,s3mmode3_new(a5)
.sk2

	moveq	#0,d0
	move.b	6(a0),d1
	cmp.b	#'?',d1
	beq.b	.sk3
	and	#$f,d1
	mulu	#10000,d1
	add.l	d1,d0
	move.b	7(a0),d1
	and	#$f,d1
	mulu	#1000,d1
	add.l	d1,d0
	move.b	8(a0),d1
	and	#$f,d1
	mulu	#100,d1
	add.l	d1,d0
	move.l	d0,mixirate(a5)
	move.l	d0,mixingrate_new(a5)
.sk3
	cmp	#4,prefsivu(a5)
	bne.b	.re
	jsr	updateprefs
.re	rts



ps3m_boost
.ahiupdate
	move.l	ps3mroutines(a5),a0
	jmp	boostj(a0)




mtS3M = 1
mtMOD = 2
mtMTM = 3
mtXM  = 4



* Initti vaihe 1. Jos d0<>0, moduuli ei kelpaa.
id_ps3m		pushm	d1-a6
;	clr	PS3M_reinit
;	clr	ps3minitcount

	move.l	a4,a0
;	move.l	moduleaddress(a5),a0

	cmp.l	#`SCRM`,44(a0)
	beq.b	.s3m

	move.l	(a0),d0
	lsr.l	#8,d0
	cmp.l	#`MTM`,d0
	beq.b	.mtm

	move.l	a0,a1
	lea	.xmsign(pc),a2
	moveq	#3,d0
.l	cmpm.l	(a1)+,(a2)+
	bne.b	.j
	dbf	d0,.l
	bra.b	.xm

.j	move.l	1080(a0),d0
	cmp.l	#`OCTA`,d0
	beq.b	.fast8
	cmp.l	#`M.K.`,d0
	beq.b	.pro4
	cmp.l	#`M!K!`,d0
	beq.b	.pro4
	cmp.l	#`FLT4`,d0
	beq.b	.pro4

	move.l	d0,d1
	and.l	#$ffffff,d1
	cmp.l	#`CHN`,d1
	beq.b	.chn

	and.l	#$ffff,d1
	cmp.l	#`CH`,d1
	beq.b	.ch

	move.l	d0,d1
	and.l	#$ffffff00,d1
	cmp.l	#`TDZ<<8`,d1
	beq.b	.tdz
	moveq	#1,d0
	bra.b	.init

.xm	cmp	#$401,xmVersion(a0)		; Kool turbo-optimizin'...
	bne.b	.j
.chn
.ch
.tdz
.fast8
.pro4
.mtm
.s3m	moveq	#0,d0

.init	tst.l	d0
	popm	d1-a6
	rts


.xmsign		dc.b	`Extended Module:`
 even
ps3minitcount	dc	0






******************************************************************************
* Sampleplayer
******************************************************************************

p_sample
	jmp	.init(pc)
	dc.l	$4e754e75		* CIA
	dc.l	$4e754e75		* VB
	jmp	.end(pc)		* end
	jmp	.dostop(pc)		* Stop
	jmp	.docont(pc)		* Cont
	jmp	.vol(pc)		* volume
	dc.l	$4e754e75		* Song
	dc.l	$4e754e75		* Eteen
	dc.l	$4e754e75		* Taakse
	jmp	.ahiup(pc)		* AHI Update
	dc	pf_volume!pf_scope!pf_stop!pf_cont!pf_end!pf_ahi
.name	dc.b	"                        ",0
 even

	rsset	$20
.s_init		rs.l	1
.s_end		rs.l	1
.s_stop		rs.l	1
.s_cont		rs.l	1
.s_vol		rs.l	1
.s_ahiup	rs.l	1
.s_ahinfo	rs.l	1
	
.init
	lea	sampleroutines(a5),a0
	bsr.w	allocreplayer
	beq.b	.ok
	rts
.ok
	pushm	a5/a6

** v�litet��n infoa

	move.b	ahi_use(a5),d0
	move.l	ahi_rate(a5),d1
	move	ahi_mastervol(a5),d2
	move	ahi_stereolev(a5),d3
	move.l	ahi_mode(a5),d4
	move.l	sampleroutines(a5),a0

*** lis���
	move.b	mpegaqua(a5),d5
	move.b	mpegadiv(a5),d6

	jsr	.s_ahinfo(a0)


** lis��
	moveq	#0,d0
	cmp	#16000,horizfreq(a5)
	slo	d0
	move	d0,-(sp)
	pea	songover(a5)
	move.l	colordiv(a5),-(sp)
	move.l	_XPKBase(a5),-(sp)

	move.b	samplebufsiz0(a5),d0
	move.b	sampleformat(a5),d1

	move.l	_DosBase(a5),a1
	move.l	_GFXBase(a5),a2
	lea	.name(pc),a3
	move.l	modulefilename(a5),a4

	pushpea	varaa_kanavat(pc),d2
	pushpea	vapauta_kanavat(pc),d3
;	pushpea	probebuffer(a5),d4
	pushpea	kokonaisaika(a5),d5

	move.b	samplecyber(a5),d7
;	move.b	cybercalibration(a5),d6
	move.l	calibrationaddr(a5),d7

	move	sampleforcerate(a5),a6

	move.l	sampleroutines(a5),a0
	jsr	.s_init(a0)

	add	#14,sp

	popm	a5/a6

	move.l	d1,sampleadd(a5)
	move.l	a0,samplefollow(a5)
	move.l	a1,samplepointer(a5)
	move.l	a2,samplepointer2(a5)
	move.b	d2,samplestereo(a5)
	move.l	d3,samplebufsiz(a5)

	tst	d0
	bne.b	.x

	bsr.b	.vol
	moveq	#0,d0
.x	rts

.end	move.l	sampleroutines(a5),a0
	jmp	.s_end(a0)

.dostop	move.l	sampleroutines(a5),a0
	jmp	.s_stop(a0)

.docont	move.l	sampleroutines(a5),a0
	jmp	.s_cont(a0)

.vol	move	mainvolume(a5),d0
	move.l	sampleroutines(a5),a0
	jmp	.s_vol(a0)

.ahiup	move.l	sampleroutines(a5),a0
	jmp	.s_ahiup(a0)

*******************************************************************************
* Playereit�


		incdir
kplayer		incbin	kpl
		;incdir	asm:player/pl/


fimp_decr	incbin	fimp_dec.bin



xpkname		dc.b	"xpkmaster.library",0
ppname		dc.b	"powerpacker.library",0
medplayername1	dc.b	"medplayer.library",0
medplayername2	dc.b	"octaplayer.library",0
medplayername3	dc.b	"octamixplayer.library",0
sidname		dc.b	"playsid.library",0
mlinename	dc.b	"mline.library",0
xfdname		dc.b	"xfdmaster.library",0

	section	plrs,data


*******
* Fontti, ikkuna ja gadgetit
*******
text_attr
	dc.l	topaz		* ta_Name
	dc	8		* ta_YSize
	dc.b	0		* ta_Style
	dc.b	0		* ta_Flags

topaz	dc.b	"topaz.font",0
 even




* p��-ikkuna
winstruc
	dc	360	;vas.yl�k.x-koord.
	dc	23	;---""--- y-koord
wsizex	dc	0	* sizex
wsizey	dc	0	* 181+25 ja 11
colors	dc.b	2,1	;palkin v�rit
idcmpmw	dc.l	idcmpflags
	dc.l	wflags
 	dc.l	0		* gadgets
	dc.l	0	
	dc.l	windowname1
	dc.l	0	;screen struc
	dc.l	0	;bitmap struc
	dc	0,0		* min x,y
	dc	1000,1000	* max x,y
	dc	WBENCHSCREEN
	dc.l	.t

*** Kick2.0+ window extension
* pubscreen, zip window

.t	dc.l	WA_PubScreenName,pubscreen+var_b	
	dc.l	WA_PubScreenFallBack,TRUE
	dc.l	WA_Zoom,windowpos2+var_b
	dc.l	TAG_END



gadgets
	incdir
;	include	gadgets/gadgets16_new2.s
	include	gadgets/gadgets16_new3.s



* prefs-ikkuna
winstruc2
	dc	0,0
prefssiz
	dc	452,170
colors2	dc.b	2,1
	dc.l	idcmpflags2
	dc.l	wflags2
 	dc.l	0		* gadgets
	dc.l	0	
	dc.l	.w
	dc.l	0	;screen struc
	dc.l	0	;bitmap struc
	dc	0,0	* min x,y
	dc	1000,1000 * max x,y
	dc	WBENCHSCREEN
	dc.l	enw_tags

.w	dc.b	"HippoPrefs"
wreg2
 ifne ANNOY
	dc.b	" - Unregistered version!",0
 else
	dc.b	0
 endif

 even

* quadrascope-ikkuna
winstruc3
	dc	259
	dc	157
quadsiz	dc	340,85
	dc.b	2,1	;palkin v�rit
	dc.l	idcmpflags3
	dc.l	wflags3
	dc.l	0
	dc.l	0	
quadtitl dc.l	.t
	dc.l	0
	dc.l	0	
	dc	0,0	* min x,y
	dc	1000,1000 * max x,y
	dc	WBENCHSCREEN
	dc.l	enw_tags

.t	dc.b	"HippoScope"
wreg3
 ifne ANNOY
	dc.b	" - Unregistered version!",0
 else
 	dc.b	0
 endif
 even


* prefs selector -ikkuna
winlistsel
	dc	0,0	* paikka 
winlistsiz
	dc	0,0	* koko
;	dc.b	2,1	;palkin v�rit
	dc.b	0,0	;palkin v�rit
	dc.l	idcmpflags4
	dc.l	wflags4
	dc.l	0
	dc.l	0	
	dc.l	0	; title
	dc.l	0
	dc.l	0	
	dc	0,0	 * min x,y
	dc	1000,1000 * max x,y
	dc	WBENCHSCREEN
	dc.l	enw_tags


gadgets2	include gadgets/prefs_main2.s
sivu0		include	gadgets/prefs_sivu0.s
sivu1		include	gadgets/prefs_sivu1.s
sivu2		include	gadgets/prefs_sivu2.s

 
sivu3		include	gadgets/prefs_sivu3.s
sivu4		include	gadgets/prefs_sivu4.s
sivu5		include	gadgets/prefs_sivu5.s

sivu6		include	gadgets/prefs_sivu6.s


*** Samplename ikkuna

swinstruc
	dc	0	;vas.yl�k.x-koord.
	dc	0	;---""--- y-koord
swinsiz	dc	361-5,150-13*8-2
colors3	dc.b	2,1	;palkin v�rit
	dc.l	sidcmpflags
sflags	dc.l	swflags
	dc.l	gAD1	;1. gadgetti
	dc.l	0	
	dc.l	.w
	dc.l	0	;screen struc
	dc.l	0	
	dc	0,0,0,0,WBENCHSCREEN
	dc.l	enw_tags

.w	dc.b	"HippoInfo"
wreg1
 ifne ANNOY
	dc.b	" - Unregistered version!",0
 else
 	dc.b	0
 endif

 even

gAD1	dc.l 0
	dc.w 9,14,16,127-13*8,GFLG_GADGHNONE,9,3
	dc.l gAD1gr,0,0,0,gAD1s
	dc.w 0
	dc.l 0
gAD1gr	dc.w 0,0,6,4,0
	dc.l 0
	dc.b 0,0
	dc.l 0
gAD1s	dc.w 5,65535,0,0,0
	dc.w 0,0,0,0,0,0




*** Kick2.0+ window extension
* Asetetaan pubscreen

enw_tags
	dc.l	WA_PubScreenName,pubscreen+var_b	
	dc.l	WA_PubScreenFallBack,TRUE
	dc.l	TAG_END
	


*** file ja infoslider imagestruktuurit


slimage		dc	0	* leftedge
		dc	0	* topedge
		dc	16	* width
slimheight	dc	8	* heigh
		dc	2	* depth
		dc.l	slim	* data
		dc.b	%11	* planepick
		dc.b	0	* planeon/onff
		dc.l	0	* nextimage

slimage2	dc	0	* leftedge
		dc	0	* topedge
		dc	16	* width
slim2height	dc	8	* heigh
		dc	2	* depth
		dc.l	slim2	* data
		dc.b	%11	* planepick
		dc.b	0	* planeon/onff
		dc.l	0	* nextimage



slim1a	dc	%0000000000000000
slim2a	dc	%0000000000000001
slim3a	dc	%0111111111111111
slim1b	dc	%1111111111111110
slim2b	dc	%1000000000000000
slim3b	dc	%0000000000000000


** PC -> Amiga taulukko, jonkinlainen

asciitable
	DC.B	$00,$01,$02,$03,$04,$05,$06,$07
	DC.B	$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
	DC.B	$3E,$3C,$12,$21,$B6,$A7,$2D,$17
	DC.B	$18,$19,$1A,$1B,$60,$2D,$1E,$1F
	DC.B	$20,$21,$22,$23,$24,$25,$26,$27
	DC.B	$28,$29,$2A,$2B,$2C,$2D,$2E,$2F
	DC.B	$30,$31,$32,$33,$34,$35,$36,$37
	DC.B	$38,$39,$3A,$3B,$3C,$3D,$3E,$3F
	DC.B	$40,$41,$42,$43,$44,$45,$46,$47
	DC.B	$48,$49,$4A,$4B,$4C,$4D,$4E,$4F
	DC.B	$50,$51,$52,$53,$54,$55,$56,$57
	DC.B	$58,$59,$5A,$5B,$5C,$5D,$5E,$5F
	DC.B	$60,$61,$62,$63,$64,$65,$66,$67
	DC.B	$68,$69,$6A,$6B,$6C,$6D,$6E,$6F
	DC.B	$70,$71,$72,$73,$74,$75,$76,$77
	DC.B	$78,$79,$7A,$7B,$7C,$7D,$7E,$7F
	DC.B	$C7,$DC,$E9,$E2,$E4,$E0,$E5,$E7
	DC.B	$EA,$EB,$E8,$CF,$CE,$CC,$C4,$C5
	DC.B	$C8,$E6,$C6,$D4,$F6,$D2,$FB,$F9
	DC.B	$FF,$D6,$DC,$E7,$A3,$D8,$52,$66
	DC.B	$E1,$CD,$D3,$DA,$D1,$D1,$AA,$AA
	DC.B	$BF,$2E,$2E,$BD,$BC,$A1,$AB,$BB
	DC.B	$AA,$AE,$D1,$7C,$7C,$7C,$7C,$2E
	DC.B	$2E,$7C,$7C,$2E,$27,$27,$27,$2E
	DC.B	$60,$5E,$2E,$7C,$2D,$7C,$7C,$7C
	DC.B	$60,$2E,$5E,$2E,$7C,$3D,$7C,$5E
	DC.B	$5E,$2E,$2E,$60,$60,$2E,$2E,$7C
	DC.B	$7C,$27,$2E,$D8,$5F,$7C,$7C,$AF
	DC.B	$61,$DF,$72,$6E,$45,$D3,$B5,$74
	DC.B	$FE,$D8,$4F,$F0,$2D,$F8,$C9,$6E
	DC.B	$3D,$B1,$3E,$3C,$66,$4A,$F7,$3D
	DC.B	$B0,$B7,$B7,$56,$6E,$B2,$B7,$20




	section	mini,data_c

hippohead	incbin	gfx/hip.raw
tickdata	dc	$001c,$0030,$0060,$70c0,$3980,$1f00,$0e00


* 16x4 pixeli�

* %00 = tausta
* %10 = musta
* %01 = valkoinen
* %11 = sininen

korvadata
	dc.b	%01000000,%00000000	* 1 bpl
	dc.b	%10100000,%00000000     
	dc.b	%10010000,%00000000
	dc.b	%11111000,%00000000

	dc.b	%10000000,%00000000	* 2 bpl
	dc.b	%01000000,%00000000
	dc.b	%01100000,%00000000
	dc.b	%00000000,%00000000

* Sininen patterni mukana
korvadata2
	dc.b	%01010101,%00000000	* 1 bpl
	dc.b	%10101010,%00000000
	dc.b	%10010101,%00000000
	dc.b	%11111010,%00000000

	dc.b	%10010101,%00000000	* 2 bpl
	dc.b	%01001010,%00000000
	dc.b	%01100101,%00000000
	dc.b	%00000010,%00000000



*** Slider2im
juustoim	
juust0im	
meloniim	
eskimOim
kellokeim
kelloke2im
pslider1im
pslider2im
sIPULIim
sIPULI2im
slider1im
ahiG4im
ahiG5im
ahiG6im
nAMISKA5im
	dc.l $00000020,$00200020,$00200020,$00200020,$7FE0FFC0,$80008000
	dc.l $80008000,$80008000,$80000000,$00000000


button1im	
	dc	%1100000000000000				
	dc	%1111000000000000				
	dc	%1111110000000000				
	dc	%1111111000000000				
	dc	%1111110000000000				
	dc	%1111000000000000				
	dc	%1110000000000000				
	dc	%0000000000000000				

button2im
	dc	%0111000000000000				
	dc	%0111000000000000				
	dc	%0000000000000000				
	dc	%1111000000000000				
	dc	%0111000000000000				
	dc	%0111000000000000				
	dc	%0111000000000000				
	dc	%0111000000000000				
	dc	%1111110000000000				

button3im
	dc	%1111001111000000				
	dc	%1111001111000000				
	dc	%1111001111000000				
	dc	%1111001111000000				
	dc	%1111001111000000				
	dc	%1111001111000000				
	dc	%1111001111000000				
	dc	%0000000000000000				

button4im
	dc	%0000011000000000				
	dc	%0001111110000000
	dc	%0111111111100000				
	dc	%1111111111110000				
	dc	%0000000000000000				
	dc	%1111111111110000				
	dc	%1111111111110000				
	dc	%0000000000000000				

button5im
	dc	%1100000110000011
	dc	%1111000111100011
	dc	%1111110111111011
	dc	%1111111111111111
	dc	%1111110111111011
	dc	%1111000111100011
	dc	%1100000110000011
	dc	%0000000000000000				
	
button6im
	dc	%1100000110000011
	dc	%1100011110001111
	dc	%1101111110111111
	dc	%1111111111111111
	dc	%1101111110111111
	dc	%1100011110001111
	dc	%1100000110000011
	dc	%0000000000000000				
		
button12im
	dc	%1100000110000000
	dc	%1111000110000000
	dc	%1111110110000000
	dc	%1111111110000000
	dc	%1111110110000000
	dc	%1111000110000000
	dc	%1100000110000000
	dc	%0000000000000000
	
button13im
	dc	%1100000110000000
	dc	%1100011110000000
	dc	%1101111110000000
	dc	%1111111110000000
	dc	%1101111110000000
	dc	%1100011110000000
	dc	%1100000110000000
	dc	%0000000000000000				


kela1im
	dc	%0000011000001100
	dc	%0001111000111100
	dc	%0111111011111100
	dc	%1111111111111100
	dc	%0111111011111100
	dc	%0001111000111100
	dc	%0000011000001100
	dc	%0000000000000000				

kela2im	
	dc	%1100000110000000
	dc	%1111000111100000
	dc	%1111110111111000
	dc	%1111111111111100
	dc	%1111110111111000
	dc	%1111000111100000
	dc	%1100000110000000
	dc	%0000000000000000				

	section	mah,bss_c

* Tyhj� sample PS3M:lle ja BPSoundMon2.0:lle.
ps3memptysample
nullsample	ds.l	1

* tilaa filebox-sliderin imagelle
slim	ds	410*2

* sampleinfo-slideri
slim2	ds	410*2


	section	udnm,bss_p

var_b		ds.b	size_var
ptheader	ds.b	950


 end
