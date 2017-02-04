Push	macro
	ifc	"\1","All"
	movem.l	d0-a6,-(sp)
	else	
	movem.l	\1,-(sp)
	endc
	endm

Pull	macro
	ifc	"\1","All"
	movem.l	(sp)+,d0-a6
	else	
	movem.l	(sp)+,\1
	endc
	endm

CALL	macro
	jsr	_LVO\1(a6)
	endm

CLIB	macro
	ifc	"\1","Exec"
	move.l	4.w,a6
	else
	move.l	_\1Base,a6
	endc
	jsr	_LVO\2(a6)
	endm

CPLIB	macro
	ifc	"\1","Exec"
	move.l	4.w,a6
	else
	move.l	_\1Base(pc),a6
	endc
	jsr	_LVO\2(a6)
	endm

C5LIB	macro
	ifc	"\1","Exec"
	move.l	4.w,a6
	else
	move.l	_\1Base(a5),a6
	endc
	jsr	_LVO\2(a6)
	endm

OLIB	macro	;*LIB_ID,CLEANUP	openlib Dos, cleanup
D\1	set	1
	move.l	4.w,a6
	lea	_\1Lib(pc),a1
	moveq	#0,d0
	jsr	_LVOOpenLibrary(a6)
	ifd	RELATIVE
	move.l	d0,_\1Base(a5)
	endc
	ifnd	RELATIVE
	move.l	d0,_\1Base
	endc
	ifnc	'\2',''
	beq	\2
	endc
	endm

CLLIB	macro	;*LIB_ID		closlib Dos
	ifd	RELATIVE
	move.l	_\1Base(a5),a1
	endc
	ifnd	RELATIVE
	move.l	_\1Base(pc),a1
	endc
	move.l	a1,d0
	beq	cLIB\@
	move.l	4,a6
	jsr	_LVOCloseLibrary(a6)
cLIB\@		
	ifd	RELATIVE
	clr.l	_\1Base(a5)
	endc
	ifnd	RELATIVE
	clr.l	_\1Base
	endc
	endm

libnames	macro
		ifd	DClist
_ClistLib	dc.b	'clist.library',0
		cnop	0,2
		ifnd	_ClistBase
_ClistBase	dc.l	0
		endc
		endc

		ifd	DGFX
_GFXLib		dc.b	'graphics.library',0
		cnop	0,2
		ifnd	_GFXBase
_GFXBase	dc.l	0
		endc
		endc

		ifd	DLayers
_LayersLib	dc.b	'layers.library',0
		cnop	0,2
		ifnd	_LayersBase
_LayersBase	dc.l	0
		endc
		endc
		endm
