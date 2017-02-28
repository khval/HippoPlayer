
; trying to make standard API for paula, so it be easier to replace it.

AUD0LCH	EQU	$A0
AUD1LCH	EQU	$B0
AUD2LCH	EQU	$C0
AUD3LCH	EQU	$D0

AUD0LCL	EQU	$A2
AUD1LCL	EQU	$B2
AUD2LCL	EQU	$C2
AUD3LCL	EQU	$D2

AUD0LEN	EQU	$A4
AUD1LEN	EQU	$A4
AUD2LEN	EQU	$B4
AUD3LEN	EQU	$C4

AUD0VOL	EQU	$A8
AUD1VOL	EQU	$B8
AUD2VOL	EQU	$C8
AUD3VOL	EQU	$D8


 ifne hardware_poking_enabled 

paula_mute
		clr	CUSTOM+AUD0VOL
		clr	CUSTOM+AUD1VOL
		clr	CUSTOM+AUD2VOL
		clr	CUSTOM+AUD3VOL
		rts
 else

paula_mute
		rts

 endif
