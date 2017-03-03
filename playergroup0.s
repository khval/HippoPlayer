;APS0000003F0000003F0000003F0000003F0000003F0000003F0000003F0000003F0000003F0000003F

	auto	j\
	auto	wb ram:HippoPlayer.group\
	auto	a0\
	auto	a1\
	
	lea	start(pc),a0
	lea	pend,a1

	sub.l	#$5371a26,tfmxdata
	add.l	#$5371a26,tfmxdata+4

	sub.l	#$5371a26,tfmx7data
	add.l	#$5371a26,tfmx7data+4

	sub.l	#$5371a26,jamdata
	add.l	#$5371a26,jamdata+4

	sub.l	#$5371a26,fc10data
	add.l	#$5371a26,fc10data+4

	sub.l	#$5371a26,fc14data
	add.l	#$5371a26,fc14data+4

	sub.l	#$5371a26,bpsmdata
	add.l	#$5371a26,bpsmdata+4

	sub.l	#$5371a26,soundmon3data
	add.l	#$5371a26,soundmon3data+4

	sub.l	#$5371a26,oktadata
	add.l	#$5371a26,oktadata+4

	sub.l	#$5371a26,p60data
	add.l	#$5371a26,p60data+4

	sub.l	#$5371a26,ps3mdata
	add.l	#$5371a26,ps3mdata+4

	sub.l	#$5371a26,hippelcosodata
	add.l	#$5371a26,hippelcosodata+4

	sub.l	#$5371a26,digidata
	add.l	#$5371a26,digidata+4

	sub.l	#$5371a26,thxdata
	add.l	#$5371a26,thxdata+4

	sub.l	#$5371a26,sampledata
	add.l	#$5371a26,sampledata+4

	sub.l	#$5371a26,aondata
	add.l	#$5371a26,aondata+4

	sub.l	#$5371a26,dbprodata
	add.l	#$5371a26,dbprodata+4

	moveq	#0,d3

	lea	main(pc),a2
	lea	maine(pc),a3

; this looks like a encryption routine, you don't make it easy do you :-) LOL

; Do { 

f		move.l	(a2),d2		; get value from the A2 table
		beq.b	.bah			; ok but we don't know the sate of flag before payergroup0.s do we?

;		If ( A2 != A3)			; for etch unsigned long the data is shifted 1 bit more.
;		{
			ror.l	d3,d2
			swap	d2		; data is swaped so number is hard to read.
			add.l	#$a370,d2	; then some constat is added to d2
;		}

.bah		move.l	d2,(a2)+		; encrped version of D2 is then saved into (A2), A2++
		addq	#1,d3

; } while (A2 < A3);

	cmp.l	a3,a2
	bne.b	f

; --- exit rts ---

	rts


; 


	incdir	pl/

start	dc.b	"HiPxPla",20	* Tunnistus ja versio

; start of main

main	
	dc.l	ps3mdata-main,tfmxdata-ps3mdata
	dc.l	tfmxdata-main,tfmx7data-tfmxdata
	dc.l	tfmx7data-main,jamdata-tfmx7data
	dc.l	jamdata-main,fc10data-jamdata
	dc.l	fc10data-main,fc14data-fc10data
	dc.l	fc14data-main,bpsmdata-fc14data
	dc.l	bpsmdata-main,soundmon3data-bpsmdata
	dc.l	soundmon3data-main,oktadata-soundmon3data
	dc.l	oktadata-main,p60data-oktadata
	dc.l	p60data-main,hippelcosodata-p60data
	dc.l	hippelcosodata-main,digidata-hippelcosodata
	dc.l	digidata-main,thxdata-digidata
	dc.l	thxdata-main,sampledata-thxdata
	dc.l	sampledata-main,aondata-sampledata
	dc.l	aondata-main,dbprodata-aondata
	dc.l	dbprodata-main,pend-dbprodata

;	ds.l	20*2		* Tilaa 20:lle uudelle


* Hämäystä

mulu_32	movem.l	d2/d3,-(sp)
	move.l	d0,d2
	move.l	d1,d3
	swap	d2
	swap	d3
;	mulu	d1,d2
;	mulu	d0,d3
;	mulu	d1,d0
;	add	d3,d2
;	swap	d2
;	clr	d2
;	add.l	d2,d0
;	movem.l	(sp)+,d2/d3
;	rts	


maine		; So this is the end of main

	dc.b	"$VER: 20",0
	even
	
ps3mdata	incbin	ps3m.im
tfmxdata	incbin	tfmx.im
tfmx7data	incbin	tfmx7c.im
jamdata		incbin	jamc.im
fc10data	incbin	fc10.im
fc14data	incbin	fc14.im
bpsmdata	incbin	bpsm.im
soundmon3data	incbin	soundmon3.im
oktadata	incbin	okta.im
p60data		incbin	p61a.im
hippelcosodata	incbin	hippelcoso.im
digidata	incbin	digi.im
thxdata		incbin	thx.im
sampledata	incbin	sampleplay.im
aondata		incbin	aon4.im
dbprodata	incbin	dbpro.im
pend

