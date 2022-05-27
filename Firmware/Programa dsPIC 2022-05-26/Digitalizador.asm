
_PasarHoraToSegundos:

;gestiontiempo.c,21 :: 		unsigned long PasarHoraToSegundos(unsigned char horas, unsigned char minutos, unsigned char segundos) {
;gestiontiempo.c,25 :: 		horaEnSegundos = (horas*3600) + (minutos*60) + (segundos);
	ZE	W10, W1
	MOV	#3600, W0
	MUL.SS	W1, W0, W2
	ZE	W11, W1
	MOV	#60, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W1
	ZE	W12, W0
	ADD	W1, W0, W0
; horaEnSegundos start address is: 4 (W2)
	MOV	W0, W2
	ASR	W2, #15, W3
;gestiontiempo.c,26 :: 		return horaEnSegundos;
	MOV.D	W2, W0
; horaEnSegundos end address is: 4 (W2)
;gestiontiempo.c,27 :: 		}
L_end_PasarHoraToSegundos:
	RETURN
; end of _PasarHoraToSegundos

_PasarTiempoToVector:
	LNK	#14

;gestiontiempo.c,40 :: 		void PasarTiempoToVector (unsigned long longHora, unsigned long longFecha, unsigned char *tramaTiempoSistema) {
	MOV	[W14-8], W0
	MOV	W0, [W14-8]
;gestiontiempo.c,45 :: 		hora = longHora / 3600;
	PUSH.D	W12
	PUSH.D	W10
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	MOV.B	W0, [W14+2]
;gestiontiempo.c,46 :: 		minuto = (longHora%3600) / 60;
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Modulus_32x32
	MOV	W0, [W14+10]
	MOV	W1, [W14+12]
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	MOV.B	W0, [W14+3]
;gestiontiempo.c,47 :: 		segundo = (longHora%3600) % 60;
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W12
	MOV.B	W0, [W14+4]
;gestiontiempo.c,50 :: 		anio = longFecha / 10000;
	PUSH.D	W12
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W12
	MOV.B	W0, [W14+0]
;gestiontiempo.c,51 :: 		mes = (longFecha%10000) / 100;
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Modulus_32x32
	MOV	W0, [W14+10]
	MOV	W1, [W14+12]
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	MOV.B	W0, [W14+1]
;gestiontiempo.c,52 :: 		dia = (longFecha%10000) % 100;
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
; dia start address is: 4 (W2)
	MOV.B	W0, W2
;gestiontiempo.c,55 :: 		tramaTiempoSistema[0] = anio;
	MOV	[W14-8], W1
	MOV.B	[W14+0], W0
	MOV.B	W0, [W1]
;gestiontiempo.c,56 :: 		tramaTiempoSistema[1] = mes;
	MOV	[W14-8], W0
	ADD	W0, #1, W1
	MOV.B	[W14+1], W0
	MOV.B	W0, [W1]
;gestiontiempo.c,57 :: 		tramaTiempoSistema[2] = dia;
	MOV	[W14-8], W0
	INC2	W0
	MOV.B	W2, [W0]
; dia end address is: 4 (W2)
;gestiontiempo.c,58 :: 		tramaTiempoSistema[3] = hora;
	MOV	[W14-8], W0
	ADD	W0, #3, W1
	MOV.B	[W14+2], W0
	MOV.B	W0, [W1]
;gestiontiempo.c,59 :: 		tramaTiempoSistema[4] = minuto;
	MOV	[W14-8], W0
	ADD	W0, #4, W1
	MOV.B	[W14+3], W0
	MOV.B	W0, [W1]
;gestiontiempo.c,60 :: 		tramaTiempoSistema[5] = segundo;
	MOV	[W14-8], W0
	ADD	W0, #5, W1
	MOV.B	[W14+4], W0
	MOV.B	W0, [W1]
;gestiontiempo.c,61 :: 		}
L_end_PasarTiempoToVector:
	ULNK
	RETURN
; end of _PasarTiempoToVector

_RecuperarFechaGPS:
	LNK	#28

;gestiontiempo.c,71 :: 		unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS) {
;gestiontiempo.c,80 :: 		char *ptrDatoStringF = &datoStringF;
	PUSH	W10
	ADD	W14, #16, W4
	MOV	W4, [W14+26]
; ptrDatoStringF start address is: 12 (W6)
	MOV	W4, W6
;gestiontiempo.c,81 :: 		datoStringF[2] = '\0';
	ADD	W4, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;gestiontiempo.c,82 :: 		tramaFecha[3] = '\0';
	ADD	W14, #0, W3
	MOV	W3, [W14+24]
	ADD	W3, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;gestiontiempo.c,85 :: 		datoStringF[0] = tramaDatosGPS[6];
	ADD	W10, #6, W0
	MOV.B	[W0], [W4]
;gestiontiempo.c,86 :: 		datoStringF[1] = tramaDatosGPS[7];
	ADD	W4, #1, W1
	ADD	W10, #7, W0
	MOV.B	[W0], [W1]
;gestiontiempo.c,87 :: 		tramaFecha[0] =  atoi(ptrDatoStringF);
	MOV	W3, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;gestiontiempo.c,90 :: 		datoStringF[0] = tramaDatosGPS[8];
	ADD	W10, #8, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;gestiontiempo.c,91 :: 		datoStringF[1] = tramaDatosGPS[9];
	ADD	W0, #1, W1
	ADD	W10, #9, W0
	MOV.B	[W0], [W1]
;gestiontiempo.c,92 :: 		tramaFecha[1] = atoi(ptrDatoStringF);
	MOV	[W14+24], W0
	ADD	W0, #4, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;gestiontiempo.c,95 :: 		datoStringF[0] = tramaDatosGPS[10];
	ADD	W10, #10, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;gestiontiempo.c,96 :: 		datoStringF[1] = tramaDatosGPS[11];
	ADD	W0, #1, W1
	ADD	W10, #11, W0
	MOV.B	[W0], [W1]
;gestiontiempo.c,97 :: 		tramaFecha[2] = atoi(ptrDatoStringF);
	MOV	[W14+24], W0
	ADD	W0, #8, W0
	MOV	W0, [W14+20]
	MOV	W6, W10
; ptrDatoStringF end address is: 12 (W6)
	CALL	_atoi
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;gestiontiempo.c,100 :: 		fechaGPS = (tramaFecha[2]*10000) + (tramaFecha[1]*100) +  (tramaFecha[0]);
	MOV	[W14+24], W0
	ADD	W0, #8, W2
	MOV.D	[W2], W0
	MOV	#10000, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+24], W2
	MOV	W0, [W14+20]
	MOV	W1, [W14+22]
	ADD	W2, #4, W2
	MOV.D	[W2], W0
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+20], W2
	MOV	[W14+22], W3
	ADD	W2, W0, W4
	ADDC	W3, W1, W5
	MOV	[W14+24], W2
	ADD	W4, [W2++], W0
	ADDC	W5, [W2--], W1
;gestiontiempo.c,102 :: 		return fechaGPS;
;gestiontiempo.c,103 :: 		}
;gestiontiempo.c,102 :: 		return fechaGPS;
;gestiontiempo.c,103 :: 		}
L_end_RecuperarFechaGPS:
	POP	W10
	ULNK
	RETURN
; end of _RecuperarFechaGPS

_RecuperarHoraGPS:
	LNK	#28

;gestiontiempo.c,110 :: 		unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS) {
;gestiontiempo.c,119 :: 		char *ptrDatoString = &datoString;
	PUSH	W10
	ADD	W14, #16, W4
	MOV	W4, [W14+26]
; ptrDatoString start address is: 12 (W6)
	MOV	W4, W6
;gestiontiempo.c,120 :: 		datoString[2] = '\0';
	ADD	W4, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;gestiontiempo.c,121 :: 		tramaTiempo[3] = '\0';
	ADD	W14, #0, W3
	MOV	W3, [W14+24]
	ADD	W3, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;gestiontiempo.c,124 :: 		datoString[0] = tramaDatosGPS[0];
	MOV.B	[W10], [W4]
;gestiontiempo.c,125 :: 		datoString[1] = tramaDatosGPS[1];
	ADD	W4, #1, W1
	ADD	W10, #1, W0
	MOV.B	[W0], [W1]
;gestiontiempo.c,127 :: 		tramaTiempo[0] = atoi(ptrDatoString);
	MOV	W3, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;gestiontiempo.c,130 :: 		datoString[0] = tramaDatosGPS[2];
	ADD	W10, #2, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;gestiontiempo.c,131 :: 		datoString[1] = tramaDatosGPS[3];
	ADD	W0, #1, W1
	ADD	W10, #3, W0
	MOV.B	[W0], [W1]
;gestiontiempo.c,133 :: 		tramaTiempo[1] = atoi(ptrDatoString);
	MOV	[W14+24], W0
	ADD	W0, #4, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;gestiontiempo.c,136 :: 		datoString[0] = tramaDatosGPS[4];
	ADD	W10, #4, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;gestiontiempo.c,137 :: 		datoString[1] = tramaDatosGPS[5];
	ADD	W0, #1, W1
	ADD	W10, #5, W0
	MOV.B	[W0], [W1]
;gestiontiempo.c,139 :: 		tramaTiempo[2] = atoi(ptrDatoString);
	MOV	[W14+24], W0
	ADD	W0, #8, W0
	MOV	W0, [W14+20]
	MOV	W6, W10
; ptrDatoString end address is: 12 (W6)
	CALL	_atoi
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;gestiontiempo.c,142 :: 		horaGPS = (tramaTiempo[0]*3600) + (tramaTiempo[1]*60) + (tramaTiempo[2]);
	MOV	[W14+24], W2
	MOV.D	[W2], W0
	MOV	#3600, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+24], W2
	MOV	W0, [W14+20]
	MOV	W1, [W14+22]
	ADD	W2, #4, W2
	MOV.D	[W2], W0
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+20], W2
	MOV	[W14+22], W3
	ADD	W2, W0, W4
	ADDC	W3, W1, W5
	MOV	[W14+24], W0
	ADD	W0, #8, W2
	ADD	W4, [W2++], W0
	ADDC	W5, [W2--], W1
;gestiontiempo.c,143 :: 		return horaGPS;
;gestiontiempo.c,144 :: 		}
;gestiontiempo.c,143 :: 		return horaGPS;
;gestiontiempo.c,144 :: 		}
L_end_RecuperarHoraGPS:
	POP	W10
	ULNK
	RETURN
; end of _RecuperarHoraGPS

_DS1307SetDir:

;ds1307_functions.c,17 :: 		void DS1307SetDir( unsigned short dir )
;ds1307_functions.c,19 :: 		Soft_I2C_Start();
	CALL	_Soft_I2C_Start
;ds1307_functions.c,20 :: 		Soft_I2C_Write(0xD0);
	PUSH	W10
	MOV.B	#208, W10
	CALL	_Soft_I2C_Write
	POP	W10
;ds1307_functions.c,21 :: 		Soft_I2C_Write(dir);
	CALL	_Soft_I2C_Write
;ds1307_functions.c,22 :: 		}
L_end_DS1307SetDir:
	RETURN
; end of _DS1307SetDir

_BcdToShort:

;ds1307_functions.c,24 :: 		unsigned short BcdToShort( unsigned short bcd )
;ds1307_functions.c,27 :: 		LV = bcd&0x0F;
; LV start address is: 8 (W4)
	AND.B	W10, #15, W4
;ds1307_functions.c,28 :: 		HV = (bcd>>4)&0x0F;
	ZE	W10, W0
	LSR	W0, #4, W0
	ZE	W0, W0
	AND	W0, #15, W0
;ds1307_functions.c,29 :: 		return LV + HV*10;
	ZE	W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W2
	ZE	W4, W0
; LV end address is: 8 (W4)
	ADD	W0, W2, W0
;ds1307_functions.c,30 :: 		}
L_end_BcdToShort:
	RETURN
; end of _BcdToShort

_ShortToBcd:

;ds1307_functions.c,32 :: 		unsigned short ShortToBcd( unsigned short valor )
;ds1307_functions.c,35 :: 		HV = valor/10;
	ZE	W10, W0
	MOV	#10, W2
	REPEAT	#17
	DIV.S	W0, W2
; HV start address is: 10 (W5)
	MOV.B	W0, W5
;ds1307_functions.c,36 :: 		LV = valor - HV*10;
	ZE	W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W2
	ZE	W10, W0
	SUB	W0, W2, W4
;ds1307_functions.c,37 :: 		return LV + HV*16;
	ZE	W5, W0
; HV end address is: 10 (W5)
	SL	W0, #4, W1
	ZE	W4, W0
	ADD	W0, W1, W0
;ds1307_functions.c,38 :: 		}
L_end_ShortToBcd:
	RETURN
; end of _ShortToBcd

_DS1307Inicio:
	LNK	#12

;ds1307_functions.c,40 :: 		void DS1307Inicio( void )
;ds1307_functions.c,43 :: 		Soft_I2C_Init(); //Inicio del bus I2C.
	PUSH	W10
	CALL	_Soft_I2C_Init
;ds1307_functions.c,44 :: 		delay_ms(50); //Retardo.
	MOV	#8, W8
	MOV	#41249, W7
L_DS1307Inicio0:
	DEC	W7
	BRA NZ	L_DS1307Inicio0
	DEC	W8
	BRA NZ	L_DS1307Inicio0
	NOP
;ds1307_functions.c,46 :: 		DS1307SetDir(0);
	CLR	W10
	CALL	_DS1307SetDir
;ds1307_functions.c,47 :: 		Soft_I2C_Start();
	CALL	_Soft_I2C_Start
;ds1307_functions.c,48 :: 		Soft_I2C_Write(0xD1);
	MOV.B	#209, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,49 :: 		VAL[0] = Soft_I2C_Read(1);
	ADD	W14, #0, W0
	MOV	W0, [W14+10]
	MOV	W0, [W14+8]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+8], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,50 :: 		VAL[1] = Soft_I2C_Read(1);
	MOV	[W14+10], W0
	INC	W0
	MOV	W0, [W14+8]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+8], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,51 :: 		VAL[2] = Soft_I2C_Read(1);
	MOV	[W14+10], W0
	INC2	W0
	MOV	W0, [W14+8]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+8], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,52 :: 		VAL[3] = Soft_I2C_Read(1);
	MOV	[W14+10], W0
	ADD	W0, #3, W0
	MOV	W0, [W14+8]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+8], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,53 :: 		VAL[4] = Soft_I2C_Read(1);
	MOV	[W14+10], W0
	ADD	W0, #4, W0
	MOV	W0, [W14+8]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+8], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,54 :: 		VAL[5] = Soft_I2C_Read(1);
	MOV	[W14+10], W0
	ADD	W0, #5, W0
	MOV	W0, [W14+8]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+8], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,55 :: 		VAL[6] = Soft_I2C_Read(0);
	MOV	[W14+10], W0
	ADD	W0, #6, W0
	MOV	W0, [W14+8]
	CLR	W10
	CALL	_Soft_I2C_Read
	MOV	[W14+8], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,56 :: 		Soft_I2C_Stop();
	CALL	_Soft_I2C_Stop
;ds1307_functions.c,57 :: 		delay_ms(50); //Retardo.
	MOV	#8, W8
	MOV	#41249, W7
L_DS1307Inicio2:
	DEC	W7
	BRA NZ	L_DS1307Inicio2
	DEC	W8
	BRA NZ	L_DS1307Inicio2
	NOP
;ds1307_functions.c,60 :: 		DATO = BcdToShort( VAL[0] );
	ADD	W14, #0, W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
;ds1307_functions.c,61 :: 		if( DATO > 59 )VAL[0]=0;
	MOV.B	#59, W1
	CP.B	W0, W1
	BRA GTU	L__DS1307Inicio206
	GOTO	L_DS1307Inicio4
L__DS1307Inicio206:
	ADD	W14, #0, W1
	CLR	W0
	MOV.B	W0, [W1]
L_DS1307Inicio4:
;ds1307_functions.c,62 :: 		DATO = BcdToShort( VAL[1] );
	ADD	W14, #0, W0
	INC	W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
;ds1307_functions.c,63 :: 		if( DATO>59 )VAL[1]=0;
	MOV.B	#59, W1
	CP.B	W0, W1
	BRA GTU	L__DS1307Inicio207
	GOTO	L_DS1307Inicio5
L__DS1307Inicio207:
	ADD	W14, #0, W0
	ADD	W0, #1, W1
	CLR	W0
	MOV.B	W0, [W1]
L_DS1307Inicio5:
;ds1307_functions.c,64 :: 		DATO = BcdToShort( VAL[2] );
	ADD	W14, #0, W0
	INC2	W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
;ds1307_functions.c,65 :: 		if( DATO>23 )VAL[2]=0;
	CP.B	W0, #23
	BRA GTU	L__DS1307Inicio208
	GOTO	L_DS1307Inicio6
L__DS1307Inicio208:
	ADD	W14, #0, W0
	ADD	W0, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
L_DS1307Inicio6:
;ds1307_functions.c,66 :: 		DATO = BcdToShort( VAL[3] );
	ADD	W14, #0, W0
	ADD	W0, #3, W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
; DATO start address is: 2 (W1)
	MOV.B	W0, W1
;ds1307_functions.c,67 :: 		if( DATO>7 || DATO==0 )VAL[3]=1;
	CP.B	W0, #7
	BRA LEU	L__DS1307Inicio209
	GOTO	L__DS1307Inicio152
L__DS1307Inicio209:
	CP.B	W1, #0
	BRA NZ	L__DS1307Inicio210
	GOTO	L__DS1307Inicio151
L__DS1307Inicio210:
; DATO end address is: 2 (W1)
	GOTO	L_DS1307Inicio9
L__DS1307Inicio152:
L__DS1307Inicio151:
	ADD	W14, #0, W0
	ADD	W0, #3, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
L_DS1307Inicio9:
;ds1307_functions.c,68 :: 		DATO = BcdToShort( VAL[4] );
	ADD	W14, #0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
; DATO start address is: 2 (W1)
	MOV.B	W0, W1
;ds1307_functions.c,69 :: 		if( DATO>31 || DATO==0 )VAL[4]=1;
	CP.B	W0, #31
	BRA LEU	L__DS1307Inicio211
	GOTO	L__DS1307Inicio154
L__DS1307Inicio211:
	CP.B	W1, #0
	BRA NZ	L__DS1307Inicio212
	GOTO	L__DS1307Inicio153
L__DS1307Inicio212:
; DATO end address is: 2 (W1)
	GOTO	L_DS1307Inicio12
L__DS1307Inicio154:
L__DS1307Inicio153:
	ADD	W14, #0, W0
	ADD	W0, #4, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
L_DS1307Inicio12:
;ds1307_functions.c,70 :: 		DATO = BcdToShort( VAL[5] );
	ADD	W14, #0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
; DATO start address is: 2 (W1)
	MOV.B	W0, W1
;ds1307_functions.c,71 :: 		if( DATO>12 || DATO==0 )VAL[5]=1;
	CP.B	W0, #12
	BRA LEU	L__DS1307Inicio213
	GOTO	L__DS1307Inicio156
L__DS1307Inicio213:
	CP.B	W1, #0
	BRA NZ	L__DS1307Inicio214
	GOTO	L__DS1307Inicio155
L__DS1307Inicio214:
; DATO end address is: 2 (W1)
	GOTO	L_DS1307Inicio15
L__DS1307Inicio156:
L__DS1307Inicio155:
	ADD	W14, #0, W0
	ADD	W0, #5, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
L_DS1307Inicio15:
;ds1307_functions.c,72 :: 		DATO = BcdToShort( VAL[6] );
	ADD	W14, #0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
;ds1307_functions.c,73 :: 		if( DATO>99 )VAL[6]=0;
	MOV.B	#99, W1
	CP.B	W0, W1
	BRA GTU	L__DS1307Inicio215
	GOTO	L_DS1307Inicio16
L__DS1307Inicio215:
	ADD	W14, #0, W0
	ADD	W0, #6, W1
	CLR	W0
	MOV.B	W0, [W1]
L_DS1307Inicio16:
;ds1307_functions.c,75 :: 		DS1307SetDir(0);
	CLR	W10
	CALL	_DS1307SetDir
;ds1307_functions.c,76 :: 		Soft_I2C_Write(VAL[0]);
	ADD	W14, #0, W0
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,77 :: 		Soft_I2C_Write(VAL[1]);
	ADD	W14, #0, W0
	INC	W0
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,78 :: 		Soft_I2C_Write(VAL[2]);
	ADD	W14, #0, W0
	INC2	W0
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,79 :: 		Soft_I2C_Write(VAL[3]);
	ADD	W14, #0, W0
	ADD	W0, #3, W0
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,80 :: 		Soft_I2C_Write(VAL[4]);
	ADD	W14, #0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,81 :: 		Soft_I2C_Write(VAL[5]);
	ADD	W14, #0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,82 :: 		Soft_I2C_Write(VAL[6]);
	ADD	W14, #0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,83 :: 		Soft_I2C_Write(0x10); //Se activa la salida oscilante 1Hz.
	MOV.B	#16, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,84 :: 		Soft_I2C_Stop();
	CALL	_Soft_I2C_Stop
;ds1307_functions.c,85 :: 		delay_ms(50); //Retardo.
	MOV	#8, W8
	MOV	#41249, W7
L_DS1307Inicio17:
	DEC	W7
	BRA NZ	L_DS1307Inicio17
	DEC	W8
	BRA NZ	L_DS1307Inicio17
	NOP
;ds1307_functions.c,86 :: 		}
L_end_DS1307Inicio:
	POP	W10
	ULNK
	RETURN
; end of _DS1307Inicio

_DS1307SetHora:
	LNK	#0

;ds1307_functions.c,88 :: 		void DS1307SetHora( Hora h )
;ds1307_functions.c,90 :: 		DS1307SetDir(0);
	PUSH	W10
	CLR	W10
	CALL	_DS1307SetDir
;ds1307_functions.c,91 :: 		Soft_I2C_Write( ShortToBcd(h.Seg) );
	MOV.B	[W14-8], W10
	CALL	_ShortToBcd
	MOV.B	W0, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,92 :: 		Soft_I2C_Write( ShortToBcd(h.Min) );
	MOV.B	[W14-9], W10
	CALL	_ShortToBcd
	MOV.B	W0, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,93 :: 		Soft_I2C_Write( ShortToBcd(h.Hor) );
	MOV.B	[W14-10], W10
	CALL	_ShortToBcd
	MOV.B	W0, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,94 :: 		Soft_I2C_Stop();
	CALL	_Soft_I2C_Stop
;ds1307_functions.c,95 :: 		}
L_end_DS1307SetHora:
	POP	W10
	ULNK
	RETURN
; end of _DS1307SetHora

_DS1307SetFecha:
	LNK	#0

;ds1307_functions.c,97 :: 		void DS1307SetFecha( Fecha f )
;ds1307_functions.c,99 :: 		DS1307SetDir(3);
	PUSH	W10
	MOV.B	#3, W10
	CALL	_DS1307SetDir
;ds1307_functions.c,100 :: 		Soft_I2C_Write( ShortToBcd(f.Dia) );
	MOV.B	[W14-10], W10
	CALL	_ShortToBcd
	MOV.B	W0, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,101 :: 		Soft_I2C_Write( ShortToBcd(f.Fec) );
	MOV.B	[W14-9], W10
	CALL	_ShortToBcd
	MOV.B	W0, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,102 :: 		Soft_I2C_Write( ShortToBcd(f.Mes) );
	MOV.B	[W14-8], W10
	CALL	_ShortToBcd
	MOV.B	W0, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,103 :: 		Soft_I2C_Write( ShortToBcd(f.Ano) );
	MOV.B	[W14-7], W10
	CALL	_ShortToBcd
	MOV.B	W0, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,104 :: 		Soft_I2C_Stop();
	CALL	_Soft_I2C_Stop
;ds1307_functions.c,105 :: 		}
L_end_DS1307SetFecha:
	POP	W10
	ULNK
	RETURN
; end of _DS1307SetFecha

_DS1307GetHora:
	LNK	#12

;ds1307_functions.c,107 :: 		Hora DS1307GetHora( void )
;ds1307_functions.c,111 :: 		DS1307SetDir(0);
	PUSH	W10
	CLR	W10
	CALL	_DS1307SetDir
;ds1307_functions.c,112 :: 		Soft_I2C_Start();
	CALL	_Soft_I2C_Start
;ds1307_functions.c,113 :: 		Soft_I2C_Write(0xD1);
	MOV.B	#209, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,114 :: 		VAL[0] = Soft_I2C_Read(1);
	ADD	W14, #5, W0
	MOV	W0, [W14+10]
	MOV	W0, [W14+8]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+8], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,115 :: 		VAL[1] = Soft_I2C_Read(1);
	MOV	[W14+10], W0
	INC	W0
	MOV	W0, [W14+8]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+8], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,116 :: 		VAL[2] = Soft_I2C_Read(0);
	MOV	[W14+10], W0
	INC2	W0
	MOV	W0, [W14+8]
	CLR	W10
	CALL	_Soft_I2C_Read
	MOV	[W14+8], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,117 :: 		Soft_I2C_Stop();
	CALL	_Soft_I2C_Stop
;ds1307_functions.c,118 :: 		H.Seg = BcdToShort( VAL[0] );
	ADD	W14, #5, W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
	MOV.B	W0, [W14+4]
;ds1307_functions.c,119 :: 		H.Min = BcdToShort( VAL[1] );
	ADD	W14, #5, W0
	INC	W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
	MOV.B	W0, [W14+3]
;ds1307_functions.c,120 :: 		H.Hor = BcdToShort( VAL[2] );
	ADD	W14, #5, W0
	INC2	W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
	MOV.B	W0, [W14+2]
;ds1307_functions.c,121 :: 		return H;
	ADD	W14, #2, W1
	MOV	[W14+0], W0
	REPEAT	#2
	MOV.B	[W1++], [W0++]
;ds1307_functions.c,122 :: 		}
;ds1307_functions.c,121 :: 		return H;
;ds1307_functions.c,122 :: 		}
L_end_DS1307GetHora:
	POP	W10
	ULNK
	RETURN
; end of _DS1307GetHora

_DS1307GetFecha:
	LNK	#14

;ds1307_functions.c,124 :: 		Fecha DS1307GetFecha( void )
;ds1307_functions.c,128 :: 		DS1307SetDir(3);
	PUSH	W10
	MOV.B	#3, W10
	CALL	_DS1307SetDir
;ds1307_functions.c,129 :: 		Soft_I2C_Start();
	CALL	_Soft_I2C_Start
;ds1307_functions.c,130 :: 		Soft_I2C_Write(0xD1);
	MOV.B	#209, W10
	CALL	_Soft_I2C_Write
;ds1307_functions.c,131 :: 		VAL[0] = Soft_I2C_Read(1);
	ADD	W14, #6, W0
	MOV	W0, [W14+12]
	MOV	W0, [W14+10]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+10], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,132 :: 		VAL[1] = Soft_I2C_Read(1);
	MOV	[W14+12], W0
	INC	W0
	MOV	W0, [W14+10]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+10], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,133 :: 		VAL[2] = Soft_I2C_Read(1);
	MOV	[W14+12], W0
	INC2	W0
	MOV	W0, [W14+10]
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	[W14+10], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,134 :: 		VAL[3] = Soft_I2C_Read(0);
	MOV	[W14+12], W0
	ADD	W0, #3, W0
	MOV	W0, [W14+10]
	CLR	W10
	CALL	_Soft_I2C_Read
	MOV	[W14+10], W1
	MOV.B	W0, [W1]
;ds1307_functions.c,135 :: 		Soft_I2C_Stop();
	CALL	_Soft_I2C_Stop
;ds1307_functions.c,136 :: 		F.Dia = BcdToShort( VAL[0] );
	ADD	W14, #6, W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
	MOV.B	W0, [W14+2]
;ds1307_functions.c,137 :: 		F.Fec = BcdToShort( VAL[1] );
	ADD	W14, #6, W0
	INC	W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
	MOV.B	W0, [W14+3]
;ds1307_functions.c,138 :: 		F.Mes = BcdToShort( VAL[2] );
	ADD	W14, #6, W0
	INC2	W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
	MOV.B	W0, [W14+4]
;ds1307_functions.c,139 :: 		F.Ano = BcdToShort( VAL[3] );
	ADD	W14, #6, W0
	ADD	W0, #3, W0
	MOV.B	[W0], W10
	CALL	_BcdToShort
	MOV.B	W0, [W14+5]
;ds1307_functions.c,140 :: 		return F;
	ADD	W14, #2, W1
	MOV	[W14+0], W0
	REPEAT	#3
	MOV.B	[W1++], [W0++]
;ds1307_functions.c,141 :: 		}
;ds1307_functions.c,140 :: 		return F;
;ds1307_functions.c,141 :: 		}
L_end_DS1307GetFecha:
	POP	W10
	ULNK
	RETURN
; end of _DS1307GetFecha

_DS1307GetHoras:
	LNK	#8

;ds1307_functions.c,144 :: 		unsigned short DS1307GetHoras( void )
;ds1307_functions.c,147 :: 		h=DS1307GetHora();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetHora
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#2
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,148 :: 		return h.Hor;
	MOV.B	[W14+0], W0
;ds1307_functions.c,149 :: 		}
L_end_DS1307GetHoras:
	ULNK
	RETURN
; end of _DS1307GetHoras

_DS1307GetMinutos:
	LNK	#8

;ds1307_functions.c,151 :: 		unsigned short DS1307GetMinutos( void )
;ds1307_functions.c,154 :: 		h=DS1307GetHora();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetHora
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#2
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,155 :: 		return h.Min;
	MOV.B	[W14+1], W0
;ds1307_functions.c,156 :: 		}
L_end_DS1307GetMinutos:
	ULNK
	RETURN
; end of _DS1307GetMinutos

_DS1307GetSegundos:
	LNK	#8

;ds1307_functions.c,158 :: 		unsigned short DS1307GetSegundos( void )
;ds1307_functions.c,161 :: 		h=DS1307GetHora();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetHora
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#2
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,162 :: 		return h.Seg;
	MOV.B	[W14+2], W0
;ds1307_functions.c,163 :: 		}
L_end_DS1307GetSegundos:
	ULNK
	RETURN
; end of _DS1307GetSegundos

_DS1307SetHoras:
	LNK	#8

;ds1307_functions.c,165 :: 		void DS1307SetHoras( unsigned short ho )
;ds1307_functions.c,168 :: 		h=DS1307GetHora();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetHora
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#2
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,169 :: 		h.Hor = ho;
	MOV.B	W10, [W14+0]
;ds1307_functions.c,170 :: 		DS1307SetHora( h );
	ADD	W14, #0, W0
	REPEAT	#1
	PUSH	[W0++]
	CALL	_DS1307SetHora
	SUB	#4, W15
;ds1307_functions.c,171 :: 		}
L_end_DS1307SetHoras:
	ULNK
	RETURN
; end of _DS1307SetHoras

_DS1307SetMinutos:
	LNK	#8

;ds1307_functions.c,173 :: 		void DS1307SetMinutos( unsigned short mi )
;ds1307_functions.c,176 :: 		h=DS1307GetHora();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetHora
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#2
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,177 :: 		h.Min = mi;
	MOV.B	W10, [W14+1]
;ds1307_functions.c,178 :: 		DS1307SetHora( h );
	ADD	W14, #0, W0
	REPEAT	#1
	PUSH	[W0++]
	CALL	_DS1307SetHora
	SUB	#4, W15
;ds1307_functions.c,179 :: 		}
L_end_DS1307SetMinutos:
	ULNK
	RETURN
; end of _DS1307SetMinutos

_DS1307SetSegundos:
	LNK	#8

;ds1307_functions.c,181 :: 		void DS1307SetSegundos( unsigned short se )
;ds1307_functions.c,184 :: 		h=DS1307GetHora();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetHora
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#2
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,185 :: 		h.Seg = se;
	MOV.B	W10, [W14+2]
;ds1307_functions.c,186 :: 		DS1307SetHora( h );
	ADD	W14, #0, W0
	REPEAT	#1
	PUSH	[W0++]
	CALL	_DS1307SetHora
	SUB	#4, W15
;ds1307_functions.c,187 :: 		}
L_end_DS1307SetSegundos:
	ULNK
	RETURN
; end of _DS1307SetSegundos

_DS1307GetDias:
	LNK	#8

;ds1307_functions.c,189 :: 		unsigned short DS1307GetDias( void )
;ds1307_functions.c,192 :: 		f=DS1307GetFecha();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetFecha
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#3
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,193 :: 		return f.Dia;
	MOV.B	[W14+0], W0
;ds1307_functions.c,194 :: 		}
L_end_DS1307GetDias:
	ULNK
	RETURN
; end of _DS1307GetDias

_DS1307GetFechas:
	LNK	#8

;ds1307_functions.c,196 :: 		unsigned short DS1307GetFechas( void )
;ds1307_functions.c,199 :: 		f=DS1307GetFecha();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetFecha
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#3
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,200 :: 		return f.Fec;
	MOV.B	[W14+1], W0
;ds1307_functions.c,201 :: 		}
L_end_DS1307GetFechas:
	ULNK
	RETURN
; end of _DS1307GetFechas

_DS1307GetMeses:
	LNK	#8

;ds1307_functions.c,203 :: 		unsigned short DS1307GetMeses( void )
;ds1307_functions.c,206 :: 		f=DS1307GetFecha();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetFecha
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#3
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,207 :: 		return f.Mes;
	MOV.B	[W14+2], W0
;ds1307_functions.c,208 :: 		}
L_end_DS1307GetMeses:
	ULNK
	RETURN
; end of _DS1307GetMeses

_DS1307GetAnos:
	LNK	#8

;ds1307_functions.c,210 :: 		unsigned short DS1307GetAnos( void )
;ds1307_functions.c,213 :: 		f=DS1307GetFecha();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetFecha
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#3
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,214 :: 		return f.Ano;
	MOV.B	[W14+3], W0
;ds1307_functions.c,215 :: 		}
L_end_DS1307GetAnos:
	ULNK
	RETURN
; end of _DS1307GetAnos

_DS1307SetDias:
	LNK	#8

;ds1307_functions.c,217 :: 		void DS1307SetDias( unsigned short di )
;ds1307_functions.c,220 :: 		f=DS1307GetFecha();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetFecha
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#3
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,221 :: 		f.Dia = di;
	MOV.B	W10, [W14+0]
;ds1307_functions.c,222 :: 		DS1307SetFecha(f);
	ADD	W14, #0, W0
	REPEAT	#1
	PUSH	[W0++]
	CALL	_DS1307SetFecha
	SUB	#4, W15
;ds1307_functions.c,223 :: 		}
L_end_DS1307SetDias:
	ULNK
	RETURN
; end of _DS1307SetDias

_DS1307SetFechas:
	LNK	#8

;ds1307_functions.c,225 :: 		void DS1307SetFechas( unsigned short fe )
;ds1307_functions.c,228 :: 		f=DS1307GetFecha();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetFecha
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#3
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,229 :: 		f.Fec = fe;
	MOV.B	W10, [W14+1]
;ds1307_functions.c,230 :: 		DS1307SetFecha(f);
	ADD	W14, #0, W0
	REPEAT	#1
	PUSH	[W0++]
	CALL	_DS1307SetFecha
	SUB	#4, W15
;ds1307_functions.c,231 :: 		}
L_end_DS1307SetFechas:
	ULNK
	RETURN
; end of _DS1307SetFechas

_DS1307SetMeses:
	LNK	#8

;ds1307_functions.c,233 :: 		void DS1307SetMeses( unsigned short me )
;ds1307_functions.c,236 :: 		f=DS1307GetFecha();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetFecha
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#3
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,237 :: 		f.Mes = me;
	MOV.B	W10, [W14+2]
;ds1307_functions.c,238 :: 		DS1307SetFecha(f);
	ADD	W14, #0, W0
	REPEAT	#1
	PUSH	[W0++]
	CALL	_DS1307SetFecha
	SUB	#4, W15
;ds1307_functions.c,239 :: 		}
L_end_DS1307SetMeses:
	ULNK
	RETURN
; end of _DS1307SetMeses

_DS1307SetAnos:
	LNK	#8

;ds1307_functions.c,241 :: 		void DS1307SetAnos( unsigned short an )
;ds1307_functions.c,244 :: 		f=DS1307GetFecha();
	ADD	W14, #4, W0
	MOV	W0, [W15+6]
	CALL	_DS1307GetFecha
	ADD	W14, #0, W1
	ADD	W14, #4, W0
	REPEAT	#3
	MOV.B	[W0++], [W1++]
;ds1307_functions.c,245 :: 		f.Ano = an;
	MOV.B	W10, [W14+3]
;ds1307_functions.c,246 :: 		DS1307SetFecha(f);
	ADD	W14, #0, W0
	REPEAT	#1
	PUSH	[W0++]
	CALL	_DS1307SetFecha
	SUB	#4, W15
;ds1307_functions.c,247 :: 		}
L_end_DS1307SetAnos:
	ULNK
	RETURN
; end of _DS1307SetAnos

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;Digitalizador.c,236 :: 		void main() {
;Digitalizador.c,240 :: 		Setup();
	PUSH	W10
	CALL	_Setup
;Digitalizador.c,241 :: 		Delay_ms(500);
	MOV	#77, W8
	MOV	#19288, W7
L_main19:
	DEC	W7
	BRA NZ	L_main19
	DEC	W8
	BRA NZ	L_main19
	NOP
;Digitalizador.c,245 :: 		GenerarInterrupcionRPi(DSPIC_CONEC);
	MOV.B	#180, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,248 :: 		Delay_ms(100);
	MOV	#16, W8
	MOV	#16964, W7
L_main21:
	DEC	W7
	BRA NZ	L_main21
	DEC	W8
	BRA NZ	L_main21
;Digitalizador.c,250 :: 		while (1) {
L_main23:
;Digitalizador.c,254 :: 		contadorWDT ++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contadorWDT), W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,255 :: 		CheckWatchDog();
	CALL	_CheckWatchDog
;Digitalizador.c,261 :: 		if (isEnviarGPSOk == true) {
	MOV	#lo_addr(_isEnviarGPSOk), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main235
	GOTO	L_main25
L__main235:
;Digitalizador.c,262 :: 		isEnviarGPSOk = false;
	MOV	#lo_addr(_isEnviarGPSOk), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,264 :: 		GenerarInterrupcionRPi(GPS_OK);
	MOV.B	#181, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,267 :: 		} else if (isPrimeraVezMuestreo == true) {
	GOTO	L_main26
L_main25:
	MOV	#lo_addr(_isPrimeraVezMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main236
	GOTO	L_main27
L__main236:
;Digitalizador.c,268 :: 		isPrimeraVezMuestreo = false;
	MOV	#lo_addr(_isPrimeraVezMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,270 :: 		GenerarInterrupcionRPi(ENV_TIME_SIS);
	MOV.B	#179, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,271 :: 		}
L_main27:
L_main26:
;Digitalizador.c,276 :: 		Delay_ms(1);
	MOV	#10000, W7
L_main28:
	DEC	W7
	BRA NZ	L_main28
;Digitalizador.c,277 :: 		}
	GOTO	L_main23
;Digitalizador.c,278 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_Setup:

;Digitalizador.c,280 :: 		void Setup () {
;Digitalizador.c,285 :: 		ADPCFG = 0XFFFF;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;Digitalizador.c,288 :: 		PCFG_11_bit = 0;    PCFG_10_bit = 0;       PCFG_9_bit = 0;
	BCLR	PCFG_11_bit, BitPos(PCFG_11_bit+0)
	BCLR	PCFG_10_bit, BitPos(PCFG_10_bit+0)
	BCLR	PCFG_9_bit, BitPos(PCFG_9_bit+0)
;Digitalizador.c,290 :: 		PCFG_12_bit = 0;
	BCLR	PCFG_12_bit, BitPos(PCFG_12_bit+0)
;Digitalizador.c,293 :: 		TRISB11_bit = 1;   TRISB10_bit = 1;       TRISB9_bit = 1;
	BSET	TRISB11_bit, BitPos(TRISB11_bit+0)
	BSET	TRISB10_bit, BitPos(TRISB10_bit+0)
	BSET	TRISB9_bit, BitPos(TRISB9_bit+0)
;Digitalizador.c,295 :: 		TRISB12_bit = 1;
	BSET	TRISB12_bit, BitPos(TRISB12_bit+0)
;Digitalizador.c,298 :: 		TRISB3_bit = 0;     TRISB4_bit = 0;
	BCLR	TRISB3_bit, BitPos(TRISB3_bit+0)
	BCLR	TRISB4_bit, BitPos(TRISB4_bit+0)
;Digitalizador.c,299 :: 		TRISB5_bit = 0;     TRISB6_bit = 0;
	BCLR	TRISB5_bit, BitPos(TRISB5_bit+0)
	BCLR	TRISB6_bit, BitPos(TRISB6_bit+0)
;Digitalizador.c,302 :: 		LATB = (LATB & 0b1110000111) | (0b0001111000 & (ganancia  << 3));
	MOV	LATB, W1
	MOV	#903, W0
	AND	W1, W0, W2
	MOV	#lo_addr(_ganancia), W0
	ZE	[W0], W0
	SL	W0, #3, W1
	MOV	#120, W0
	AND	W0, W1, W1
	MOV	#lo_addr(LATB), W0
	IOR	W2, W1, [W0]
;Digitalizador.c,305 :: 		InitTimer3();
	CALL	_InitTimer3
;Digitalizador.c,308 :: 		LED_DIRECTION = 0;
	BCLR	TRISB0_bit, BitPos(TRISB0_bit+0)
;Digitalizador.c,309 :: 		LED_2_DIRECTION = 0;
	BCLR	TRISD0_bit, BitPos(TRISD0_bit+0)
;Digitalizador.c,310 :: 		LED_3_DIRECTION = 0;
	BCLR	TRISD1_bit, BitPos(TRISD1_bit+0)
;Digitalizador.c,311 :: 		LED_4_DIRECTION = 0;
	BCLR	TRISB8_bit, BitPos(TRISB8_bit+0)
;Digitalizador.c,313 :: 		LED = 1;
	BSET	LATB0_bit, BitPos(LATB0_bit+0)
;Digitalizador.c,314 :: 		LED_2 = 1;
	BSET	LATD0_bit, BitPos(LATD0_bit+0)
;Digitalizador.c,315 :: 		LED_3 = 1;
	BSET	LATD1_bit, BitPos(LATD1_bit+0)
;Digitalizador.c,316 :: 		LED_4 = 1;
	BSET	LATB8_bit, BitPos(LATB8_bit+0)
;Digitalizador.c,317 :: 		Delay_ms(300);
	MOV	#46, W8
	MOV	#50894, W7
L_Setup30:
	DEC	W7
	BRA NZ	L_Setup30
	DEC	W8
	BRA NZ	L_Setup30
;Digitalizador.c,318 :: 		LED = 0;
	BCLR	LATB0_bit, BitPos(LATB0_bit+0)
;Digitalizador.c,319 :: 		LED_2 = 0;
	BCLR	LATD0_bit, BitPos(LATD0_bit+0)
;Digitalizador.c,320 :: 		Delay_ms(300);
	MOV	#46, W8
	MOV	#50894, W7
L_Setup32:
	DEC	W7
	BRA NZ	L_Setup32
	DEC	W8
	BRA NZ	L_Setup32
;Digitalizador.c,321 :: 		LED = 1;
	BSET	LATB0_bit, BitPos(LATB0_bit+0)
;Digitalizador.c,322 :: 		LED_2 = 1;
	BSET	LATD0_bit, BitPos(LATD0_bit+0)
;Digitalizador.c,330 :: 		PIN_RPi = 0;
	BCLR	LATF1_bit, BitPos(LATF1_bit+0)
;Digitalizador.c,331 :: 		PIN_RPi_DIRECTION = 0;
	BCLR	TRISF1_bit, BitPos(TRISF1_bit+0)
;Digitalizador.c,334 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,336 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,338 :: 		indice_gps = 0;
	CLR	W0
	MOV	W0, _indice_gps
;Digitalizador.c,344 :: 		SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
	MOV	#3, W13
	MOV	#28, W12
	CLR	W11
	CLR	W10
	CLR	W0
	PUSH	W0
	MOV	#64, W0
	PUSH	W0
	MOV	#512, W0
	PUSH	W0
	MOV	#128, W0
	PUSH	W0
	CALL	_SPI1_Init_Advanced
	SUB	#8, W15
;Digitalizador.c,348 :: 		SPI1IE_bit = 1;
	BSET	SPI1IE_bit, BitPos(SPI1IE_bit+0)
;Digitalizador.c,350 :: 		SPI1IF_bit = 0;
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Digitalizador.c,352 :: 		IPC2bits.SPI1IP = 7;
	MOV	#lo_addr(IPC2bits), W0
	MOV.B	[W0], W0
	IOR.B	W0, #7, W1
	MOV	#lo_addr(IPC2bits), W0
	MOV.B	W1, [W0]
;Digitalizador.c,354 :: 		SPIROV_bit = 0;
	BCLR	SPIROV_bit, BitPos(SPIROV_bit+0)
;Digitalizador.c,356 :: 		SPI1STAT.SPIEN = 1;
	BSET	SPI1STAT, #15
;Digitalizador.c,365 :: 		UART1_Init(9600);
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;Digitalizador.c,368 :: 		LATD3_bit = 1;
	BSET	LATD3_bit, BitPos(LATD3_bit+0)
;Digitalizador.c,369 :: 		TRISD3_bit = 0;
	BCLR	TRISD3_bit, BitPos(TRISD3_bit+0)
;Digitalizador.c,371 :: 		ALTIO_bit = 1;
	BSET	ALTIO_bit, BitPos(ALTIO_bit+0)
;Digitalizador.c,372 :: 		Delay_ms(100);
	MOV	#16, W8
	MOV	#16964, W7
L_Setup34:
	DEC	W7
	BRA NZ	L_Setup34
	DEC	W8
	BRA NZ	L_Setup34
;Digitalizador.c,374 :: 		CN1PUE_bit = 1;
	BSET	CN1PUE_bit, BitPos(CN1PUE_bit+0)
;Digitalizador.c,377 :: 		U1RXIE_bit = 1;
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,379 :: 		U1RXIF_bit = 0;
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;Digitalizador.c,381 :: 		IPC2bits.U1RXIP = 0x04;
	MOV.B	#64, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#112, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC2bits), W0
	MOV.B	W1, [W0]
;Digitalizador.c,382 :: 		U1STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;Digitalizador.c,388 :: 		UART1_Write_Text("$PMTK220,1000*1F\r\n");
	MOV	#lo_addr(?lstr1_Digitalizador), W10
	CALL	_UART1_Write_Text
;Digitalizador.c,390 :: 		Delay_ms(1000);
	MOV	#153, W8
	MOV	#38577, W7
L_Setup36:
	DEC	W7
	BRA NZ	L_Setup36
	DEC	W8
	BRA NZ	L_Setup36
	NOP
	NOP
;Digitalizador.c,395 :: 		UART1_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n");
	MOV	#lo_addr(?lstr2_Digitalizador), W10
	CALL	_UART1_Write_Text
;Digitalizador.c,396 :: 		Delay_ms(1000);
	MOV	#153, W8
	MOV	#38577, W7
L_Setup38:
	DEC	W7
	BRA NZ	L_Setup38
	DEC	W8
	BRA NZ	L_Setup38
	NOP
	NOP
;Digitalizador.c,399 :: 		TRISA11_bit = 1;
	BSET	TRISA11_bit, BitPos(TRISA11_bit+0)
;Digitalizador.c,400 :: 		RA11_bit = 0;
	BCLR	RA11_bit, BitPos(RA11_bit+0)
;Digitalizador.c,405 :: 		INT0EP_bit = 0;
	BCLR	INT0EP_bit, BitPos(INT0EP_bit+0)
;Digitalizador.c,407 :: 		INT0IE_bit = 1;
	BSET	INT0IE_bit, BitPos(INT0IE_bit+0)
;Digitalizador.c,409 :: 		INT0IF_bit = 0;
	BCLR	INT0IF_bit, BitPos(INT0IF_bit+0)
;Digitalizador.c,412 :: 		INT0IP_2_bit = 1;
	BSET	INT0IP_2_bit, BitPos(INT0IP_2_bit+0)
;Digitalizador.c,413 :: 		INT0IP_1_bit = 0;
	BCLR	INT0IP_1_bit, BitPos(INT0IP_1_bit+0)
;Digitalizador.c,414 :: 		INT0IP_0_bit = 0;
	BCLR	INT0IP_0_bit, BitPos(INT0IP_0_bit+0)
;Digitalizador.c,423 :: 		DS1307Inicio();
	CALL	_DS1307Inicio
;Digitalizador.c,426 :: 		TRISD9_bit = 1;         // Como entrada la señal del reloj
	BSET	TRISD9_bit, BitPos(TRISD9_bit+0)
;Digitalizador.c,427 :: 		INT2IE_bit = 1;         // Habilita la interrupcion INT2
	BSET	INT2IE_bit, BitPos(INT2IE_bit+0)
;Digitalizador.c,428 :: 		INT2IF_bit = 0;         // Limpia la bandera de interrupcion de INT2
	BCLR	INT2IF_bit, BitPos(INT2IF_bit+0)
;Digitalizador.c,431 :: 		INT2EP_bit = 1;
	BSET	INT2EP_bit, BitPos(INT2EP_bit+0)
;Digitalizador.c,434 :: 		INT2IP_2_bit = 1;
	BSET	INT2IP_2_bit, BitPos(INT2IP_2_bit+0)
;Digitalizador.c,435 :: 		INT2IP_1_bit = 0;
	BCLR	INT2IP_1_bit, BitPos(INT2IP_1_bit+0)
;Digitalizador.c,436 :: 		INT2IP_0_bit = 0;
	BCLR	INT2IP_0_bit, BitPos(INT2IP_0_bit+0)
;Digitalizador.c,442 :: 		Delay_ms(500);
	MOV	#77, W8
	MOV	#19288, W7
L_Setup40:
	DEC	W7
	BRA NZ	L_Setup40
	DEC	W8
	BRA NZ	L_Setup40
	NOP
;Digitalizador.c,444 :: 		}
L_end_Setup:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Setup

_CheckWatchDog:

;Digitalizador.c,449 :: 		bool CheckWatchDog () {
;Digitalizador.c,450 :: 		if (contadorWDT >= 2){
	MOV	#lo_addr(_contadorWDT), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA GEU	L__CheckWatchDog240
	GOTO	L_CheckWatchDog42
L__CheckWatchDog240:
;Digitalizador.c,451 :: 		contadorWDT = 0;
	MOV	#lo_addr(_contadorWDT), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,452 :: 		asm clrwdt;
	CLRWDT
;Digitalizador.c,453 :: 		return true;
	MOV.B	#1, W0
	GOTO	L_end_CheckWatchDog
;Digitalizador.c,454 :: 		} else {
L_CheckWatchDog42:
;Digitalizador.c,455 :: 		return false;
	CLR	W0
;Digitalizador.c,457 :: 		}
L_end_CheckWatchDog:
	RETURN
; end of _CheckWatchDog

_InitTimer3:

;Digitalizador.c,469 :: 		void InitTimer3() {
;Digitalizador.c,472 :: 		T3CON = 0x0010;
	MOV	#16, W0
	MOV	WREG, T3CON
;Digitalizador.c,475 :: 		T3IE_bit = 1;
	BSET	T3IE_bit, BitPos(T3IE_bit+0)
;Digitalizador.c,476 :: 		T3IF_bit = 0;
	BCLR	T3IF_bit, BitPos(T3IF_bit+0)
;Digitalizador.c,479 :: 		TMR3 = 0;
	CLR	TMR3
;Digitalizador.c,482 :: 		T3IP_2_bit = 1;
	BSET	T3IP_2_bit, BitPos(T3IP_2_bit+0)
;Digitalizador.c,483 :: 		T3IP_1_bit = 1;
	BSET	T3IP_1_bit, BitPos(T3IP_1_bit+0)
;Digitalizador.c,484 :: 		T3IP_0_bit = 1;
	BSET	T3IP_0_bit, BitPos(T3IP_0_bit+0)
;Digitalizador.c,487 :: 		PR3 = 37500;
	MOV	#37500, W0
	MOV	WREG, PR3
;Digitalizador.c,488 :: 		}
L_end_InitTimer3:
	RETURN
; end of _InitTimer3

_GenerarInterrupcionRPi:

;Digitalizador.c,498 :: 		void GenerarInterrupcionRPi(unsigned short operacion){
;Digitalizador.c,510 :: 		bandOperacion = 0; bandTimeFromRPi = 0; bandTimeFromDSPIC = 0;
	MOV	#lo_addr(_bandOperacion), W1
	CLR	W0
	MOV.B	W0, [W1]
	MOV	#lo_addr(_bandTimeFromRPi), W1
	CLR	W0
	MOV.B	W0, [W1]
	MOV	#lo_addr(_bandTimeFromDSPIC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,515 :: 		bandTramaRecBytesPorMuestra = 0; bandTramaInitMues = 0;
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W1
	CLR	W0
	MOV.B	W0, [W1]
	MOV	#lo_addr(_bandTramaInitMues), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,518 :: 		tipoOperacion = operacion;
	MOV	#lo_addr(_tipoOperacion), W0
	MOV.B	W10, [W0]
;Digitalizador.c,520 :: 		LED_4 = ~LED_4;
	BTG	LATB8_bit, BitPos(LATB8_bit+0)
;Digitalizador.c,523 :: 		if (SPIROV_bit == 1) {
	BTSS	SPIROV_bit, BitPos(SPIROV_bit+0)
	GOTO	L_GenerarInterrupcionRPi44
;Digitalizador.c,525 :: 		LED_3 = ~LED_3;
	BTG	LATD1_bit, BitPos(LATD1_bit+0)
;Digitalizador.c,528 :: 		SPIROV_bit = 0;
	BCLR	SPIROV_bit, BitPos(SPIROV_bit+0)
;Digitalizador.c,532 :: 		if (SPI1IF_bit == 1) {
	BTSS	SPI1IF_bit, BitPos(SPI1IF_bit+0)
	GOTO	L_GenerarInterrupcionRPi45
;Digitalizador.c,533 :: 		SPI1IF_bit = 0;
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Digitalizador.c,534 :: 		}
L_GenerarInterrupcionRPi45:
;Digitalizador.c,535 :: 		}
L_GenerarInterrupcionRPi44:
;Digitalizador.c,540 :: 		PIN_RPi = 1;
	BSET	LATF1_bit, BitPos(LATF1_bit+0)
;Digitalizador.c,542 :: 		Delay_us(40);
	MOV	#400, W7
L_GenerarInterrupcionRPi46:
	DEC	W7
	BRA NZ	L_GenerarInterrupcionRPi46
;Digitalizador.c,543 :: 		PIN_RPi = 0;
	BCLR	LATF1_bit, BitPos(LATF1_bit+0)
;Digitalizador.c,544 :: 		}
L_end_GenerarInterrupcionRPi:
	RETURN
; end of _GenerarInterrupcionRPi

_LeerCanalADC:

;Digitalizador.c,556 :: 		unsigned int LeerCanalADC (unsigned int canal) {
;Digitalizador.c,561 :: 		ADCON1 = 0b0000000011100000;
	MOV	#224, W0
	MOV	WREG, ADCON1
;Digitalizador.c,564 :: 		ADCHS = 0X0000 | canal;
	MOV	W10, ADCHS
;Digitalizador.c,579 :: 		ADCON3 = 0b0000000100101000; //SAMC<4:0> = 1*TAD ... SI ADCS<5:0> = 40 ... si 30 MIPS :: Tcy = 33ns y TAD = 677nsec ... TiempoConversion: 15*TAD = 15*683.33ns = 10.249 us
	MOV	#296, W0
	MOV	WREG, ADCON3
;Digitalizador.c,582 :: 		ADON_bit = 1;
	BSET	ADON_bit, BitPos(ADON_bit+0)
;Digitalizador.c,586 :: 		SAMP_bit = 1;
	BSET	SAMP_bit, BitPos(SAMP_bit+0)
;Digitalizador.c,589 :: 		while (DONE_bit == 0) {
L_LeerCanalADC48:
	BTSC	DONE_bit, BitPos(DONE_bit+0)
	GOTO	L_LeerCanalADC49
;Digitalizador.c,590 :: 		asm nop;
	NOP
;Digitalizador.c,591 :: 		}
	GOTO	L_LeerCanalADC48
L_LeerCanalADC49:
;Digitalizador.c,593 :: 		valADCleido = ADCBUF0;
; valADCleido start address is: 2 (W1)
	MOV	ADCBUF0, W1
;Digitalizador.c,595 :: 		ADON_bit = 0;
	BCLR	ADON_bit, BitPos(ADON_bit+0)
;Digitalizador.c,597 :: 		return valADCleido;
	MOV	W1, W0
; valADCleido end address is: 2 (W1)
;Digitalizador.c,598 :: 		}
L_end_LeerCanalADC:
	RETURN
; end of _LeerCanalADC

_Timer3Interrupt:
	LNK	#12
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Digitalizador.c,609 :: 		void Timer3Interrupt() iv IVT_ADDR_T3INTERRUPT{
;Digitalizador.c,627 :: 		T3IF_bit = 0;
	PUSH	W10
	BCLR	T3IF_bit, BitPos(T3IF_bit+0)
;Digitalizador.c,632 :: 		contadorFsample ++;
	MOV	#1, W1
	MOV	#lo_addr(Timer3Interrupt_contadorFsample_L0), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,635 :: 		valADC_canal_1 = LeerCanalADC(11);
	MOV	#11, W10
	CALL	_LeerCanalADC
	MOV	W0, [W14+0]
;Digitalizador.c,636 :: 		valADC_canal_2 = LeerCanalADC(10);
	MOV	#10, W10
	CALL	_LeerCanalADC
	MOV	W0, [W14+2]
;Digitalizador.c,637 :: 		valADC_canal_3 = LeerCanalADC(9);
	MOV	#9, W10
	CALL	_LeerCanalADC
	MOV	W0, [W14+4]
;Digitalizador.c,640 :: 		punteroValADC_1 = &valADC_canal_1;
	ADD	W14, #0, W2
; punteroValADC_1 start address is: 8 (W4)
	MOV	W2, W4
;Digitalizador.c,641 :: 		punteroValADC_2 = &valADC_canal_2;
	ADD	W14, #2, W0
; punteroValADC_2 start address is: 10 (W5)
	MOV	W0, W5
;Digitalizador.c,642 :: 		punteroValADC_3 = &valADC_canal_3;
	ADD	W14, #4, W0
; punteroValADC_3 start address is: 12 (W6)
	MOV	W0, W6
;Digitalizador.c,648 :: 		vectorDatos[0] = (ganancia << 4) | *(punteroValADC_1 + 1);
	ADD	W14, #6, W3
	MOV	#lo_addr(_ganancia), W0
	ZE	[W0], W0
	SL	W0, #4, W1
	ADD	W2, #1, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV.B	W0, [W3]
;Digitalizador.c,650 :: 		vectorDatos[1] = *punteroValADC_1;
	ADD	W3, #1, W0
	MOV.B	[W4], [W0]
; punteroValADC_1 end address is: 8 (W4)
;Digitalizador.c,652 :: 		vectorDatos[2] = (*(punteroValADC_2 + 1) << 4) | *(punteroValADC_3 + 1);
	ADD	W3, #2, W2
	ADD	W5, #1, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #4, W1
	ADD	W6, #1, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV.B	W0, [W2]
;Digitalizador.c,654 :: 		vectorDatos[3] = *punteroValADC_2;
	ADD	W3, #3, W0
	MOV.B	[W5], [W0]
; punteroValADC_2 end address is: 10 (W5)
;Digitalizador.c,655 :: 		vectorDatos[4] = *punteroValADC_3;
	ADD	W3, #4, W0
	MOV.B	[W6], [W0]
; punteroValADC_3 end address is: 12 (W6)
;Digitalizador.c,658 :: 		for (indiceForTimer3 = 0; indiceForTimer3 < numBytesPorMuestra; indiceForTimer3 ++) {
; indiceForTimer3 start address is: 6 (W3)
	CLR	W3
; indiceForTimer3 end address is: 6 (W3)
L_Timer3Interrupt50:
; indiceForTimer3 start address is: 6 (W3)
	CP.B	W3, #5
	BRA LTU	L__Timer3Interrupt245
	GOTO	L_Timer3Interrupt51
L__Timer3Interrupt245:
;Digitalizador.c,659 :: 		vectorData[contadorMuestras + indiceForTimer3] = vectorDatos[indiceForTimer3];
	ZE	W3, W1
	MOV	#lo_addr(_contadorMuestras), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_vectorData), W0
	ADD	W0, W1, W2
	ADD	W14, #6, W1
	ZE	W3, W0
	ADD	W1, W0, W0
	MOV.B	[W0], [W2]
;Digitalizador.c,658 :: 		for (indiceForTimer3 = 0; indiceForTimer3 < numBytesPorMuestra; indiceForTimer3 ++) {
	INC.B	W3
;Digitalizador.c,660 :: 		}
; indiceForTimer3 end address is: 6 (W3)
	GOTO	L_Timer3Interrupt50
L_Timer3Interrupt51:
;Digitalizador.c,661 :: 		contadorMuestras = contadorMuestras + numBytesPorMuestra;
	MOV	_contadorMuestras, W0
	ADD	W0, #5, W1
	MOV	W1, _contadorMuestras
;Digitalizador.c,667 :: 		if (contadorMuestras >= numMuestrasEnvio) {
	MOV	#250, W0
	CP	W1, W0
	BRA GEU	L__Timer3Interrupt246
	GOTO	L_Timer3Interrupt53
L__Timer3Interrupt246:
;Digitalizador.c,675 :: 		if (contadorFsample >= fsample) {
	MOV	#lo_addr(_fsample), W0
	ZE	[W0], W1
	MOV	#lo_addr(Timer3Interrupt_contadorFsample_L0), W0
	CP	W1, [W0]
	BRA LEU	L__Timer3Interrupt247
	GOTO	L_Timer3Interrupt54
L__Timer3Interrupt247:
;Digitalizador.c,677 :: 		contadorFsample = 0;
	CLR	W0
	MOV	W0, Timer3Interrupt_contadorFsample_L0
;Digitalizador.c,679 :: 		TON_T3CON_bit = 0;
	BCLR	TON_T3CON_bit, BitPos(TON_T3CON_bit+0)
;Digitalizador.c,680 :: 		}
L_Timer3Interrupt54:
;Digitalizador.c,682 :: 		if (isEnviarHoraToRPi == true) {
	MOV	#lo_addr(_isEnviarHoraToRPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Timer3Interrupt248
	GOTO	L_Timer3Interrupt55
L__Timer3Interrupt248:
;Digitalizador.c,690 :: 		punteroLong = &horaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_horaLongSistema), W2
;Digitalizador.c,692 :: 		vectorData[numMuestrasEnvio] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+250), W0
	MOV.B	W1, [W0]
;Digitalizador.c,693 :: 		vectorData[numMuestrasEnvio + 1] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+251), W0
	MOV.B	W1, [W0]
;Digitalizador.c,694 :: 		vectorData[numMuestrasEnvio + 2] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorData+252), W0
	MOV.B	W1, [W0]
;Digitalizador.c,696 :: 		punteroLong = &fechaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_fechaLongSistema), W2
;Digitalizador.c,698 :: 		vectorData[numMuestrasEnvio + 3] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+253), W0
	MOV.B	W1, [W0]
;Digitalizador.c,699 :: 		vectorData[numMuestrasEnvio + 4] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+254), W0
	MOV.B	W1, [W0]
;Digitalizador.c,700 :: 		vectorData[numMuestrasEnvio + 5] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorData+255), W0
	MOV.B	W1, [W0]
;Digitalizador.c,704 :: 		isLibreVectorData = false;
	MOV	#lo_addr(_isLibreVectorData), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,706 :: 		contadorMuestras = 0;
	CLR	W0
	MOV	W0, _contadorMuestras
;Digitalizador.c,713 :: 		GenerarInterrupcionRPi(ENV_MUESTRAS_TIME);
	MOV.B	#178, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,717 :: 		} else {
	GOTO	L_Timer3Interrupt56
L_Timer3Interrupt55:
;Digitalizador.c,719 :: 		isLibreVectorData = false;
	MOV	#lo_addr(_isLibreVectorData), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,720 :: 		contadorMuestras = 0;
	CLR	W0
	MOV	W0, _contadorMuestras
;Digitalizador.c,726 :: 		GenerarInterrupcionRPi(ENV_MUESTRAS);
	MOV.B	#177, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,727 :: 		}
L_Timer3Interrupt56:
;Digitalizador.c,728 :: 		}
L_Timer3Interrupt53:
;Digitalizador.c,729 :: 		}
L_end_Timer3Interrupt:
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	ULNK
	RETFIE
; end of _Timer3Interrupt

_interruptSPI1:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Digitalizador.c,739 :: 		void interruptSPI1 () org  IVT_ADDR_SPI1INTERRUPT {
;Digitalizador.c,756 :: 		SPI1IF_bit = 0;
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Digitalizador.c,758 :: 		dataSPI = SPI1BUF;
; dataSPI start address is: 4 (W2)
	MOV	SPI1BUF, W2
;Digitalizador.c,764 :: 		if (bandOperacion == 0 && dataSPI == INI_OBT_OPE) {
	MOV	#lo_addr(_bandOperacion), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1250
	GOTO	L__interruptSPI1164
L__interruptSPI1250:
	MOV.B	#160, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1251
	GOTO	L__interruptSPI1163
L__interruptSPI1251:
; dataSPI end address is: 4 (W2)
L__interruptSPI1162:
;Digitalizador.c,767 :: 		bandOperacion = 1;
	MOV	#lo_addr(_bandOperacion), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,769 :: 		SPI1BUF = tipoOperacion;
	MOV	#lo_addr(_tipoOperacion), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,772 :: 		} else if (bandOperacion == 1 && dataSPI == FIN_OBT_OPE) {
	GOTO	L_interruptSPI160
;Digitalizador.c,764 :: 		if (bandOperacion == 0 && dataSPI == INI_OBT_OPE) {
L__interruptSPI1164:
; dataSPI start address is: 4 (W2)
L__interruptSPI1163:
;Digitalizador.c,772 :: 		} else if (bandOperacion == 1 && dataSPI == FIN_OBT_OPE) {
	MOV	#lo_addr(_bandOperacion), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1252
	GOTO	L__interruptSPI1166
L__interruptSPI1252:
	MOV.B	#240, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1253
	GOTO	L__interruptSPI1165
L__interruptSPI1253:
; dataSPI end address is: 4 (W2)
L__interruptSPI1161:
;Digitalizador.c,773 :: 		bandOperacion = 0;
	MOV	#lo_addr(_bandOperacion), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,774 :: 		tipoOperacion = 0;
	MOV	#lo_addr(_tipoOperacion), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,775 :: 		}
	GOTO	L_interruptSPI164
;Digitalizador.c,772 :: 		} else if (bandOperacion == 1 && dataSPI == FIN_OBT_OPE) {
L__interruptSPI1166:
; dataSPI start address is: 4 (W2)
L__interruptSPI1165:
;Digitalizador.c,781 :: 		else if (bandTramaRecBytesPorMuestra == 0 && dataSPI == INI_REC_MUES) {
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1254
	GOTO	L__interruptSPI1168
L__interruptSPI1254:
	MOV.B	#163, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1255
	GOTO	L__interruptSPI1167
L__interruptSPI1255:
; dataSPI end address is: 4 (W2)
L__interruptSPI1160:
;Digitalizador.c,783 :: 		bandTramaRecBytesPorMuestra = 1;
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,785 :: 		indiceBytesPorMuestra = 0;
	CLR	W0
	MOV	W0, interruptSPI1_indiceBytesPorMuestra_L0
;Digitalizador.c,789 :: 		if (isLibreVectorData == false) {
	MOV	#lo_addr(_isLibreVectorData), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1256
	GOTO	L_interruptSPI168
L__interruptSPI1256:
;Digitalizador.c,790 :: 		SPI1BUF = vectorData[indiceBytesPorMuestra];
	MOV	#lo_addr(_vectorData), W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,791 :: 		indiceBytesPorMuestra ++;
	MOV	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,792 :: 		}
L_interruptSPI168:
;Digitalizador.c,795 :: 		} else if (bandTramaRecBytesPorMuestra == 1) {
	GOTO	L_interruptSPI169
;Digitalizador.c,781 :: 		else if (bandTramaRecBytesPorMuestra == 0 && dataSPI == INI_REC_MUES) {
L__interruptSPI1168:
; dataSPI start address is: 4 (W2)
L__interruptSPI1167:
;Digitalizador.c,795 :: 		} else if (bandTramaRecBytesPorMuestra == 1) {
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1257
	GOTO	L_interruptSPI170
L__interruptSPI1257:
;Digitalizador.c,797 :: 		if (dataSPI == DUMMY_BYTE) {
	CP.B	W2, #0
	BRA Z	L__interruptSPI1258
	GOTO	L_interruptSPI171
L__interruptSPI1258:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,799 :: 		if (isLibreVectorData == false) {
	MOV	#lo_addr(_isLibreVectorData), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1259
	GOTO	L_interruptSPI172
L__interruptSPI1259:
;Digitalizador.c,800 :: 		SPI1BUF = vectorData[indiceBytesPorMuestra];
	MOV	#lo_addr(_vectorData), W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,801 :: 		indiceBytesPorMuestra ++;
	MOV	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,802 :: 		}
L_interruptSPI172:
;Digitalizador.c,804 :: 		} else if (dataSPI == FIN_REC_MUES) {
	GOTO	L_interruptSPI173
L_interruptSPI171:
; dataSPI start address is: 4 (W2)
	MOV.B	#243, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1260
	GOTO	L_interruptSPI174
L__interruptSPI1260:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,811 :: 		if (indiceBytesPorMuestra > numMuestrasEnvio) {
	MOV	#250, W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	CP	W1, [W0]
	BRA LTU	L__interruptSPI1261
	GOTO	L_interruptSPI175
L__interruptSPI1261:
;Digitalizador.c,812 :: 		isEnviarHoraToRPi = false;
	MOV	#lo_addr(_isEnviarHoraToRPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,813 :: 		}
L_interruptSPI175:
;Digitalizador.c,816 :: 		bandTramaRecBytesPorMuestra = 0;
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,818 :: 		if (isLibreVectorData == false) {
	MOV	#lo_addr(_isLibreVectorData), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1262
	GOTO	L_interruptSPI176
L__interruptSPI1262:
;Digitalizador.c,819 :: 		isLibreVectorData = true;
	MOV	#lo_addr(_isLibreVectorData), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,820 :: 		}
L_interruptSPI176:
;Digitalizador.c,821 :: 		}
L_interruptSPI174:
L_interruptSPI173:
;Digitalizador.c,822 :: 		}
	GOTO	L_interruptSPI177
L_interruptSPI170:
;Digitalizador.c,827 :: 		else if (bandTimeFromRPi == 0 && dataSPI == INI_TIME_FROM_RPI) {
; dataSPI start address is: 4 (W2)
	MOV	#lo_addr(_bandTimeFromRPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1263
	GOTO	L__interruptSPI1170
L__interruptSPI1263:
	MOV.B	#164, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1264
	GOTO	L__interruptSPI1169
L__interruptSPI1264:
; dataSPI end address is: 4 (W2)
L__interruptSPI1159:
;Digitalizador.c,829 :: 		bandTimeFromRPi = 1;
	MOV	#lo_addr(_bandTimeFromRPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,831 :: 		indiceTimeFromRPi = 0;
	MOV	#lo_addr(interruptSPI1_indiceTimeFromRPi_L0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,834 :: 		} else if (bandTimeFromRPi == 1) {
	GOTO	L_interruptSPI181
;Digitalizador.c,827 :: 		else if (bandTimeFromRPi == 0 && dataSPI == INI_TIME_FROM_RPI) {
L__interruptSPI1170:
; dataSPI start address is: 4 (W2)
L__interruptSPI1169:
;Digitalizador.c,834 :: 		} else if (bandTimeFromRPi == 1) {
	MOV	#lo_addr(_bandTimeFromRPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1265
	GOTO	L_interruptSPI182
L__interruptSPI1265:
;Digitalizador.c,837 :: 		if (dataSPI != FIN_TIME_FROM_RPI) {
	MOV.B	#244, W0
	CP.B	W2, W0
	BRA NZ	L__interruptSPI1266
	GOTO	L_interruptSPI183
L__interruptSPI1266:
;Digitalizador.c,838 :: 		vectorBytesTimeRPi[indiceTimeFromRPi] = dataSPI;
	MOV	#lo_addr(interruptSPI1_indiceTimeFromRPi_L0), W0
	ZE	[W0], W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0), W0
	ADD	W0, W1, W0
	MOV.B	W2, [W0]
; dataSPI end address is: 4 (W2)
;Digitalizador.c,839 :: 		indiceTimeFromRPi ++;
	MOV.B	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceTimeFromRPi_L0), W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,841 :: 		} else {
	GOTO	L_interruptSPI184
L_interruptSPI183:
;Digitalizador.c,843 :: 		bandTimeFromRPi = 0;
	MOV	#lo_addr(_bandTimeFromRPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,847 :: 		punteroLong = &fechaLongRPi;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_fechaLongRPi), W2
;Digitalizador.c,849 :: 		*(punteroLong + 3) = vectorBytesTimeRPi[0];
	ADD	W2, #3, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,850 :: 		*(punteroLong + 2) = vectorBytesTimeRPi[1];
	ADD	W2, #2, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+1), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,851 :: 		*(punteroLong + 1) = vectorBytesTimeRPi[2];
	ADD	W2, #1, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+2), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,852 :: 		*(punteroLong) = vectorBytesTimeRPi[3];
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+3), W0
	MOV.B	[W0], [W2]
;Digitalizador.c,856 :: 		punteroLong = &horaLongRPi;
	MOV	#lo_addr(_horaLongRPi), W2
;Digitalizador.c,858 :: 		*(punteroLong + 3) = vectorBytesTimeRPi[4];
	ADD	W2, #3, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+4), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,859 :: 		*(punteroLong + 2) = vectorBytesTimeRPi[5];
	ADD	W2, #2, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+5), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,860 :: 		*(punteroLong + 1) = vectorBytesTimeRPi[6];
	ADD	W2, #1, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+6), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,861 :: 		*(punteroLong) = vectorBytesTimeRPi[7];
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+7), W0
	MOV.B	[W0], [W2]
; punteroLong end address is: 4 (W2)
;Digitalizador.c,865 :: 		if (isGPS_Connected == false) {
	MOV	#lo_addr(_isGPS_Connected), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1267
	GOTO	L_interruptSPI185
L__interruptSPI1267:
;Digitalizador.c,867 :: 		fechaLongSistema = fechaLongRPi;
	MOV	_fechaLongRPi, W0
	MOV	_fechaLongRPi+2, W1
	MOV	W0, _fechaLongSistema
	MOV	W1, _fechaLongSistema+2
;Digitalizador.c,868 :: 		horaLongSistema = horaLongRPi;
	MOV	_horaLongRPi, W0
	MOV	_horaLongRPi+2, W1
	MOV	W0, _horaLongSistema
	MOV	W1, _horaLongSistema+2
;Digitalizador.c,870 :: 		fechaLongRTC = fechaLongRPi;
	MOV	_fechaLongRPi, W0
	MOV	_fechaLongRPi+2, W1
	MOV	W0, _fechaLongRTC
	MOV	W1, _fechaLongRTC+2
;Digitalizador.c,871 :: 		horaLongRTC = horaLongRPi;
	MOV	_horaLongRPi, W0
	MOV	_horaLongRPi+2, W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,873 :: 		isActualizarRTC = true;
	MOV	#lo_addr(_isActualizarRTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,875 :: 		fuenteTiempoSistema = FUENTE_TIME_RTC;
	MOV	#lo_addr(_fuenteTiempoSistema), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Digitalizador.c,876 :: 		}
L_interruptSPI185:
;Digitalizador.c,877 :: 		}
L_interruptSPI184:
;Digitalizador.c,878 :: 		}
	GOTO	L_interruptSPI186
L_interruptSPI182:
;Digitalizador.c,883 :: 		else if (bandTimeFromDSPIC == 0 && dataSPI == INI_TIME_FROM_DSPIC) {
; dataSPI start address is: 4 (W2)
	MOV	#lo_addr(_bandTimeFromDSPIC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1268
	GOTO	L__interruptSPI1172
L__interruptSPI1268:
	MOV.B	#165, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1269
	GOTO	L__interruptSPI1171
L__interruptSPI1269:
; dataSPI end address is: 4 (W2)
L__interruptSPI1158:
;Digitalizador.c,886 :: 		bandTimeFromDSPIC = 1;
	MOV	#lo_addr(_bandTimeFromDSPIC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,888 :: 		indiceTimeFromDSPIC = 0;
	MOV	#lo_addr(interruptSPI1_indiceTimeFromDSPIC_L0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,890 :: 		SPI1BUF = fuenteTiempoSistema;
	MOV	#lo_addr(_fuenteTiempoSistema), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,893 :: 		punteroLong = &fechaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_fechaLongSistema), W2
;Digitalizador.c,895 :: 		vectorTiempoSistema[0] = *(punteroLong + 3);
	ADD	W2, #3, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema), W0
	MOV.B	W1, [W0]
;Digitalizador.c,896 :: 		vectorTiempoSistema[1] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+1), W0
	MOV.B	W1, [W0]
;Digitalizador.c,897 :: 		vectorTiempoSistema[2] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+2), W0
	MOV.B	W1, [W0]
;Digitalizador.c,898 :: 		vectorTiempoSistema[3] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorTiempoSistema+3), W0
	MOV.B	W1, [W0]
;Digitalizador.c,901 :: 		punteroLong = &horaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_horaLongSistema), W2
;Digitalizador.c,902 :: 		vectorTiempoSistema[4] = *(punteroLong + 3);
	ADD	W2, #3, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+4), W0
	MOV.B	W1, [W0]
;Digitalizador.c,903 :: 		vectorTiempoSistema[5] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+5), W0
	MOV.B	W1, [W0]
;Digitalizador.c,904 :: 		vectorTiempoSistema[6] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+6), W0
	MOV.B	W1, [W0]
;Digitalizador.c,905 :: 		vectorTiempoSistema[7] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorTiempoSistema+7), W0
	MOV.B	W1, [W0]
;Digitalizador.c,908 :: 		} else if (bandTimeFromDSPIC == 1) {
	GOTO	L_interruptSPI190
;Digitalizador.c,883 :: 		else if (bandTimeFromDSPIC == 0 && dataSPI == INI_TIME_FROM_DSPIC) {
L__interruptSPI1172:
; dataSPI start address is: 4 (W2)
L__interruptSPI1171:
;Digitalizador.c,908 :: 		} else if (bandTimeFromDSPIC == 1) {
	MOV	#lo_addr(_bandTimeFromDSPIC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1270
	GOTO	L_interruptSPI191
L__interruptSPI1270:
;Digitalizador.c,910 :: 		if (dataSPI == DUMMY_BYTE) {
	CP.B	W2, #0
	BRA Z	L__interruptSPI1271
	GOTO	L_interruptSPI192
L__interruptSPI1271:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,911 :: 		SPI1BUF = vectorTiempoSistema[indiceTimeFromDSPIC];
	MOV	#lo_addr(interruptSPI1_indiceTimeFromDSPIC_L0), W0
	ZE	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,912 :: 		indiceTimeFromDSPIC ++;
	MOV.B	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceTimeFromDSPIC_L0), W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,914 :: 		} else if (dataSPI == FIN_TIME_FROM_DSPIC) {
	GOTO	L_interruptSPI193
L_interruptSPI192:
; dataSPI start address is: 4 (W2)
	MOV.B	#245, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1272
	GOTO	L_interruptSPI194
L__interruptSPI1272:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,915 :: 		bandTimeFromDSPIC = 0;
	MOV	#lo_addr(_bandTimeFromDSPIC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,916 :: 		}
L_interruptSPI194:
L_interruptSPI193:
;Digitalizador.c,917 :: 		}
	GOTO	L_interruptSPI195
L_interruptSPI191:
;Digitalizador.c,922 :: 		else if (bandTramaInitMues == 0 && dataSPI == INI_INIT_MUES) {
; dataSPI start address is: 4 (W2)
	MOV	#lo_addr(_bandTramaInitMues), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1273
	GOTO	L__interruptSPI1174
L__interruptSPI1273:
	MOV.B	#161, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1274
	GOTO	L__interruptSPI1173
L__interruptSPI1274:
; dataSPI end address is: 4 (W2)
L__interruptSPI1157:
;Digitalizador.c,924 :: 		bandTramaInitMues = 1;
	MOV	#lo_addr(_bandTramaInitMues), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,927 :: 		isComienzoMuestreo = true;
	MOV	#lo_addr(_isComienzoMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,930 :: 		} else if (bandTramaInitMues == 1) {
	GOTO	L_interruptSPI199
;Digitalizador.c,922 :: 		else if (bandTramaInitMues == 0 && dataSPI == INI_INIT_MUES) {
L__interruptSPI1174:
L__interruptSPI1173:
;Digitalizador.c,930 :: 		} else if (bandTramaInitMues == 1) {
	MOV	#lo_addr(_bandTramaInitMues), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1275
	GOTO	L_interruptSPI1100
L__interruptSPI1275:
;Digitalizador.c,931 :: 		bandTramaInitMues = 0;
	MOV	#lo_addr(_bandTramaInitMues), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,932 :: 		}
L_interruptSPI1100:
L_interruptSPI199:
L_interruptSPI195:
L_interruptSPI190:
L_interruptSPI186:
L_interruptSPI181:
L_interruptSPI177:
L_interruptSPI169:
L_interruptSPI164:
L_interruptSPI160:
;Digitalizador.c,934 :: 		}
L_end_interruptSPI1:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _interruptSPI1

_ExternalInterrupt0_GPS:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Digitalizador.c,945 :: 		void ExternalInterrupt0_GPS() org IVT_ADDR_INT0INTERRUPT{
;Digitalizador.c,947 :: 		INT0IF_bit = 0;
	BCLR	INT0IF_bit, BitPos(INT0IF_bit+0)
;Digitalizador.c,951 :: 		if (isPPS_GPS == false) {
	MOV	#lo_addr(_isPPS_GPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt0_GPS277
	GOTO	L_ExternalInterrupt0_GPS101
L__ExternalInterrupt0_GPS277:
;Digitalizador.c,952 :: 		isPPS_GPS = true;
	MOV	#lo_addr(_isPPS_GPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,955 :: 		if (isGPS_Connected == false && isComuGPS == true) {
	MOV	#lo_addr(_isGPS_Connected), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt0_GPS278
	GOTO	L__ExternalInterrupt0_GPS177
L__ExternalInterrupt0_GPS278:
	MOV	#lo_addr(_isComuGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt0_GPS279
	GOTO	L__ExternalInterrupt0_GPS176
L__ExternalInterrupt0_GPS279:
L__ExternalInterrupt0_GPS175:
;Digitalizador.c,956 :: 		isGPS_Connected = true;
	MOV	#lo_addr(_isGPS_Connected), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,958 :: 		isEnviarGPSOk = true;
	MOV	#lo_addr(_isEnviarGPSOk), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,960 :: 		fuenteTiempoSistema = FUENTE_TIME_GPS;
	MOV	#lo_addr(_fuenteTiempoSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,955 :: 		if (isGPS_Connected == false && isComuGPS == true) {
L__ExternalInterrupt0_GPS177:
L__ExternalInterrupt0_GPS176:
;Digitalizador.c,962 :: 		}
L_ExternalInterrupt0_GPS101:
;Digitalizador.c,968 :: 		if (isRecTiempoGPS == true) {
	MOV	#lo_addr(_isRecTiempoGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt0_GPS280
	GOTO	L_ExternalInterrupt0_GPS105
L__ExternalInterrupt0_GPS280:
;Digitalizador.c,970 :: 		isRecTiempoGPS = false;
	MOV	#lo_addr(_isRecTiempoGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,973 :: 		horaLongSistema = horaLongGPS;
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	MOV	W0, _horaLongSistema
	MOV	W1, _horaLongSistema+2
;Digitalizador.c,974 :: 		fechaLongSistema = fechaLongGPS;
	MOV	_fechaLongGPS, W0
	MOV	_fechaLongGPS+2, W1
	MOV	W0, _fechaLongSistema
	MOV	W1, _fechaLongSistema+2
;Digitalizador.c,976 :: 		fuenteTiempoSistema = FUENTE_TIME_GPS;
	MOV	#lo_addr(_fuenteTiempoSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,979 :: 		} else {
	GOTO	L_ExternalInterrupt0_GPS106
L_ExternalInterrupt0_GPS105:
;Digitalizador.c,981 :: 		horaLongGPS ++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaLongGPS), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;Digitalizador.c,982 :: 		}
L_ExternalInterrupt0_GPS106:
;Digitalizador.c,985 :: 		if (horaLongGPS == 86400) {
	MOV	_horaLongGPS, W2
	MOV	_horaLongGPS+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__ExternalInterrupt0_GPS281
	GOTO	L_ExternalInterrupt0_GPS107
L__ExternalInterrupt0_GPS281:
;Digitalizador.c,986 :: 		horaLongGPS = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaLongGPS
	MOV	W1, _horaLongGPS+2
;Digitalizador.c,987 :: 		}
L_ExternalInterrupt0_GPS107:
;Digitalizador.c,988 :: 		}
L_end_ExternalInterrupt0_GPS:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _ExternalInterrupt0_GPS

_ExternalInterrupt2_RTC:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Digitalizador.c,1000 :: 		void ExternalInterrupt2_RTC() org IVT_ADDR_INT2INTERRUPT{
;Digitalizador.c,1002 :: 		INT2IF_bit = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT2IF_bit, BitPos(INT2IF_bit+0)
;Digitalizador.c,1004 :: 		LED_2 = ~LED_2;
	BTG	LATD0_bit, BitPos(LATD0_bit+0)
;Digitalizador.c,1009 :: 		if (isActualizarRTC == true) {
	MOV	#lo_addr(_isActualizarRTC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC283
	GOTO	L_ExternalInterrupt2_RTC108
L__ExternalInterrupt2_RTC283:
;Digitalizador.c,1010 :: 		isActualizarRTC = false;
	MOV	#lo_addr(_isActualizarRTC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1013 :: 		PasarTiempoToVector(horaLongRTC, fechaLongRTC, vectorTiempoRTC);
	MOV	_fechaLongRTC, W12
	MOV	_fechaLongRTC+2, W13
	MOV	_horaLongRTC, W10
	MOV	_horaLongRTC+2, W11
	MOV	#lo_addr(_vectorTiempoRTC), W0
	PUSH	W0
	CALL	_PasarTiempoToVector
	SUB	#2, W15
;Digitalizador.c,1015 :: 		DS1307SetAnos(vectorTiempoRTC[0]);
	MOV	#lo_addr(_vectorTiempoRTC), W0
	MOV.B	[W0], W10
	CALL	_DS1307SetAnos
;Digitalizador.c,1016 :: 		DS1307SetMeses(vectorTiempoRTC[1]);
	MOV	#lo_addr(_vectorTiempoRTC+1), W0
	MOV.B	[W0], W10
	CALL	_DS1307SetMeses
;Digitalizador.c,1017 :: 		DS1307SetFechas(vectorTiempoRTC[2]);
	MOV	#lo_addr(_vectorTiempoRTC+2), W0
	MOV.B	[W0], W10
	CALL	_DS1307SetFechas
;Digitalizador.c,1018 :: 		DS1307SetHoras(vectorTiempoRTC[3]);
	MOV	#lo_addr(_vectorTiempoRTC+3), W0
	MOV.B	[W0], W10
	CALL	_DS1307SetHoras
;Digitalizador.c,1019 :: 		DS1307SetMinutos(vectorTiempoRTC[4]);
	MOV	#lo_addr(_vectorTiempoRTC+4), W0
	MOV.B	[W0], W10
	CALL	_DS1307SetMinutos
;Digitalizador.c,1020 :: 		DS1307SetSegundos(vectorTiempoRTC[5]);
	MOV	#lo_addr(_vectorTiempoRTC+5), W0
	MOV.B	[W0], W10
	CALL	_DS1307SetSegundos
;Digitalizador.c,1022 :: 		} else {
	GOTO	L_ExternalInterrupt2_RTC109
L_ExternalInterrupt2_RTC108:
;Digitalizador.c,1024 :: 		horaLongRTC ++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaLongRTC), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;Digitalizador.c,1025 :: 		}
L_ExternalInterrupt2_RTC109:
;Digitalizador.c,1028 :: 		if (horaLongRTC == 86400) {
	MOV	_horaLongRTC, W2
	MOV	_horaLongRTC+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__ExternalInterrupt2_RTC284
	GOTO	L_ExternalInterrupt2_RTC110
L__ExternalInterrupt2_RTC284:
;Digitalizador.c,1029 :: 		horaLongRTC = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,1030 :: 		}
L_ExternalInterrupt2_RTC110:
;Digitalizador.c,1037 :: 		if (horaLongGPS == 86390 && fuenteTiempoSistema == FUENTE_TIME_GPS) {
	MOV	_horaLongGPS, W2
	MOV	_horaLongGPS+2, W3
	MOV	#20854, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__ExternalInterrupt2_RTC285
	GOTO	L__ExternalInterrupt2_RTC182
L__ExternalInterrupt2_RTC285:
	MOV	#lo_addr(_fuenteTiempoSistema), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC286
	GOTO	L__ExternalInterrupt2_RTC181
L__ExternalInterrupt2_RTC286:
L__ExternalInterrupt2_RTC180:
;Digitalizador.c,1039 :: 		U1RXIE_bit = 1;
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,1037 :: 		if (horaLongGPS == 86390 && fuenteTiempoSistema == FUENTE_TIME_GPS) {
L__ExternalInterrupt2_RTC182:
L__ExternalInterrupt2_RTC181:
;Digitalizador.c,1043 :: 		horaLongSistema = horaLongRTC;
	MOV	_horaLongRTC, W0
	MOV	_horaLongRTC+2, W1
	MOV	W0, _horaLongSistema
	MOV	W1, _horaLongSistema+2
;Digitalizador.c,1046 :: 		if (isComienzoMuestreo == true) {
	MOV	#lo_addr(_isComienzoMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC287
	GOTO	L_ExternalInterrupt2_RTC114
L__ExternalInterrupt2_RTC287:
;Digitalizador.c,1048 :: 		if (isMuestreando == false && (horaLongRTC % 60) == 0) {
	MOV	#lo_addr(_isMuestreando), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt2_RTC288
	GOTO	L__ExternalInterrupt2_RTC184
L__ExternalInterrupt2_RTC288:
	MOV	#60, W2
	MOV	#0, W3
	MOV	_horaLongRTC, W0
	MOV	_horaLongRTC+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__ExternalInterrupt2_RTC289
	GOTO	L__ExternalInterrupt2_RTC183
L__ExternalInterrupt2_RTC289:
L__ExternalInterrupt2_RTC179:
;Digitalizador.c,1049 :: 		isMuestreando = true;
	MOV	#lo_addr(_isMuestreando), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1051 :: 		isComienzoMuestreo = false;
	MOV	#lo_addr(_isComienzoMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1054 :: 		isPrimeraVezMuestreo = true;
	MOV	#lo_addr(_isPrimeraVezMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1048 :: 		if (isMuestreando == false && (horaLongRTC % 60) == 0) {
L__ExternalInterrupt2_RTC184:
L__ExternalInterrupt2_RTC183:
;Digitalizador.c,1056 :: 		}
L_ExternalInterrupt2_RTC114:
;Digitalizador.c,1059 :: 		if (isMuestreando == true) {
	MOV	#lo_addr(_isMuestreando), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC290
	GOTO	L_ExternalInterrupt2_RTC118
L__ExternalInterrupt2_RTC290:
;Digitalizador.c,1062 :: 		if ((horaLongRTC % 60) == 0 && isPrimeraVezMuestreo == false) {
	MOV	#60, W2
	MOV	#0, W3
	MOV	_horaLongRTC, W0
	MOV	_horaLongRTC+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__ExternalInterrupt2_RTC291
	GOTO	L__ExternalInterrupt2_RTC186
L__ExternalInterrupt2_RTC291:
	MOV	#lo_addr(_isPrimeraVezMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt2_RTC292
	GOTO	L__ExternalInterrupt2_RTC185
L__ExternalInterrupt2_RTC292:
L__ExternalInterrupt2_RTC178:
;Digitalizador.c,1063 :: 		isEnviarHoraToRPi = true;
	MOV	#lo_addr(_isEnviarHoraToRPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1062 :: 		if ((horaLongRTC % 60) == 0 && isPrimeraVezMuestreo == false) {
L__ExternalInterrupt2_RTC186:
L__ExternalInterrupt2_RTC185:
;Digitalizador.c,1070 :: 		if (TON_T3CON_bit == 0) {
	BTSC	TON_T3CON_bit, BitPos(TON_T3CON_bit+0)
	GOTO	L_ExternalInterrupt2_RTC122
;Digitalizador.c,1071 :: 		TON_T3CON_bit = 1;
	BSET	TON_T3CON_bit, BitPos(TON_T3CON_bit+0)
;Digitalizador.c,1072 :: 		}
L_ExternalInterrupt2_RTC122:
;Digitalizador.c,1074 :: 		TMR3 = 0;
	CLR	TMR3
;Digitalizador.c,1077 :: 		T3IF_bit = 1;
	BSET	T3IF_bit, BitPos(T3IF_bit+0)
;Digitalizador.c,1078 :: 		}
L_ExternalInterrupt2_RTC118:
;Digitalizador.c,1079 :: 		}
L_end_ExternalInterrupt2_RTC:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _ExternalInterrupt2_RTC

_interruptU1RX:
	LNK	#2
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Digitalizador.c,1088 :: 		void interruptU1RX() iv IVT_ADDR_U1RXINTERRUPT {
;Digitalizador.c,1092 :: 		U1RXIF_bit = 0;
	PUSH	W10
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;Digitalizador.c,1094 :: 		byteGPS = U1RXREG;                                                                                                                                                                                                                                       //Lee el byte de la trama enviada por el GPS
; byteGPS start address is: 4 (W2)
	MOV	U1RXREG, W2
;Digitalizador.c,1096 :: 		OERR_bit = 0;
	BCLR	OERR_bit, BitPos(OERR_bit+0)
;Digitalizador.c,1098 :: 		if (banTIGPS == 0){
	MOV	#lo_addr(_banTIGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptU1RX294
	GOTO	L_interruptU1RX123
L__interruptU1RX294:
;Digitalizador.c,1101 :: 		if ((byteGPS == 0x24) && (indice_gps == 0)){
	MOV.B	#36, W0
	CP.B	W2, W0
	BRA Z	L__interruptU1RX295
	GOTO	L__interruptU1RX190
L__interruptU1RX295:
	MOV	_indice_gps, W0
	CP	W0, #0
	BRA Z	L__interruptU1RX296
	GOTO	L__interruptU1RX189
L__interruptU1RX296:
L__interruptU1RX188:
;Digitalizador.c,1103 :: 		banTIGPS = 1;
	MOV	#lo_addr(_banTIGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1101 :: 		if ((byteGPS == 0x24) && (indice_gps == 0)){
L__interruptU1RX190:
L__interruptU1RX189:
;Digitalizador.c,1105 :: 		}
L_interruptU1RX123:
;Digitalizador.c,1107 :: 		if (banTIGPS == 1){
	MOV	#lo_addr(_banTIGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptU1RX297
	GOTO	L_interruptU1RX127
L__interruptU1RX297:
;Digitalizador.c,1110 :: 		if (byteGPS != 0x2A){
	MOV.B	#42, W0
	CP.B	W2, W0
	BRA NZ	L__interruptU1RX298
	GOTO	L_interruptU1RX128
L__interruptU1RX298:
;Digitalizador.c,1112 :: 		tramaGPS[indice_gps] = byteGPS;
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_indice_gps), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
; byteGPS end address is: 4 (W2)
;Digitalizador.c,1114 :: 		if (indice_gps < 70){
	MOV	#70, W1
	MOV	#lo_addr(_indice_gps), W0
	CP	W1, [W0]
	BRA GTU	L__interruptU1RX299
	GOTO	L_interruptU1RX129
L__interruptU1RX299:
;Digitalizador.c,1115 :: 		indice_gps ++;
	MOV	#1, W1
	MOV	#lo_addr(_indice_gps), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,1116 :: 		}
L_interruptU1RX129:
;Digitalizador.c,1121 :: 		if ((indice_gps > 5) && (tramaGPS[1] != 0x47) && (tramaGPS[2] != 0x50)  && (tramaGPS[3] != 0x52)  && (tramaGPS[4] != 0x4D)  && (tramaGPS[5] != 0x43)) {
	MOV	_indice_gps, W0
	CP	W0, #5
	BRA GTU	L__interruptU1RX300
	GOTO	L__interruptU1RX196
L__interruptU1RX300:
	MOV	#lo_addr(_tramaGPS+1), W0
	MOV.B	[W0], W1
	MOV.B	#71, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX301
	GOTO	L__interruptU1RX195
L__interruptU1RX301:
	MOV	#lo_addr(_tramaGPS+2), W0
	MOV.B	[W0], W1
	MOV.B	#80, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX302
	GOTO	L__interruptU1RX194
L__interruptU1RX302:
	MOV	#lo_addr(_tramaGPS+3), W0
	MOV.B	[W0], W1
	MOV.B	#82, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX303
	GOTO	L__interruptU1RX193
L__interruptU1RX303:
	MOV	#lo_addr(_tramaGPS+4), W0
	MOV.B	[W0], W1
	MOV.B	#77, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX304
	GOTO	L__interruptU1RX192
L__interruptU1RX304:
	MOV	#lo_addr(_tramaGPS+5), W0
	MOV.B	[W0], W1
	MOV.B	#67, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX305
	GOTO	L__interruptU1RX191
L__interruptU1RX305:
L__interruptU1RX187:
;Digitalizador.c,1123 :: 		indice_gps = 0;
	CLR	W0
	MOV	W0, _indice_gps
;Digitalizador.c,1125 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1127 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1121 :: 		if ((indice_gps > 5) && (tramaGPS[1] != 0x47) && (tramaGPS[2] != 0x50)  && (tramaGPS[3] != 0x52)  && (tramaGPS[4] != 0x4D)  && (tramaGPS[5] != 0x43)) {
L__interruptU1RX196:
L__interruptU1RX195:
L__interruptU1RX194:
L__interruptU1RX193:
L__interruptU1RX192:
L__interruptU1RX191:
;Digitalizador.c,1130 :: 		} else {
	GOTO	L_interruptU1RX133
L_interruptU1RX128:
;Digitalizador.c,1131 :: 		tramaGPS[indice_gps] = byteGPS;
; byteGPS start address is: 4 (W2)
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_indice_gps), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
; byteGPS end address is: 4 (W2)
;Digitalizador.c,1134 :: 		banTIGPS = 2;
	MOV	#lo_addr(_banTIGPS), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1136 :: 		banTCGPS = 1;
	MOV	#lo_addr(_banTCGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1137 :: 		}
L_interruptU1RX133:
;Digitalizador.c,1138 :: 		}
L_interruptU1RX127:
;Digitalizador.c,1142 :: 		if (banTCGPS == 1) {
	MOV	#lo_addr(_banTCGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptU1RX306
	GOTO	L_interruptU1RX134
L__interruptU1RX306:
;Digitalizador.c,1145 :: 		if (tramaGPS[18] == 0x41) {
	MOV	#lo_addr(_tramaGPS+18), W0
	MOV.B	[W0], W1
	MOV.B	#65, W0
	CP.B	W1, W0
	BRA Z	L__interruptU1RX307
	GOTO	L_interruptU1RX135
L__interruptU1RX307:
;Digitalizador.c,1150 :: 		for (indiceU1RX_1 = 0; indiceU1RX_1 < 6; indiceU1RX_1++){
; indiceU1RX_1 start address is: 6 (W3)
	CLR	W3
; indiceU1RX_1 end address is: 6 (W3)
L_interruptU1RX136:
; indiceU1RX_1 start address is: 6 (W3)
	CP.B	W3, #6
	BRA LTU	L__interruptU1RX308
	GOTO	L_interruptU1RX137
L__interruptU1RX308:
;Digitalizador.c,1152 :: 		datosGPS[indiceU1RX_1] = tramaGPS[7+indiceU1RX_1];
	ZE	W3, W1
	MOV	#lo_addr(_datosGPS), W0
	ADD	W0, W1, W2
	ZE	W3, W0
	ADD	W0, #7, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Digitalizador.c,1150 :: 		for (indiceU1RX_1 = 0; indiceU1RX_1 < 6; indiceU1RX_1++){
	INC.B	W3
;Digitalizador.c,1153 :: 		}
; indiceU1RX_1 end address is: 6 (W3)
	GOTO	L_interruptU1RX136
L_interruptU1RX137:
;Digitalizador.c,1155 :: 		for (indiceU1RX_1 = 50; indiceU1RX_1 < 60; indiceU1RX_1++){
; indiceU1RX_1 start address is: 6 (W3)
	MOV.B	#50, W3
; indiceU1RX_1 end address is: 6 (W3)
L_interruptU1RX139:
; indiceU1RX_1 start address is: 6 (W3)
	MOV.B	#60, W0
	CP.B	W3, W0
	BRA LTU	L__interruptU1RX309
	GOTO	L_interruptU1RX140
L__interruptU1RX309:
;Digitalizador.c,1158 :: 		if (tramaGPS[indiceU1RX_1] == 0x2C){
	ZE	W3, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#44, W0
	CP.B	W1, W0
	BRA Z	L__interruptU1RX310
	GOTO	L__interruptU1RX197
L__interruptU1RX310:
;Digitalizador.c,1160 :: 		for (indiceU1RX_2 = 0; indiceU1RX_2 < 6; indiceU1RX_2++){
	CLR	W0
	MOV.B	W0, [W14+0]
; indiceU1RX_1 end address is: 6 (W3)
L_interruptU1RX143:
; indiceU1RX_1 start address is: 6 (W3)
	MOV.B	[W14+0], W0
	CP.B	W0, #6
	BRA LTU	L__interruptU1RX311
	GOTO	L_interruptU1RX144
L__interruptU1RX311:
;Digitalizador.c,1161 :: 		datosGPS[6 + indiceU1RX_2] = tramaGPS[indiceU1RX_1 + indiceU1RX_2 + 1];
	ADD	W14, #0, W0
	ZE	[W0], W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_datosGPS), W0
	ADD	W0, W1, W2
	ZE	W3, W1
	ADD	W14, #0, W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Digitalizador.c,1160 :: 		for (indiceU1RX_2 = 0; indiceU1RX_2 < 6; indiceU1RX_2++){
	MOV.B	#1, W1
	ADD	W14, #0, W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,1162 :: 		}
	GOTO	L_interruptU1RX143
L_interruptU1RX144:
;Digitalizador.c,1163 :: 		}
	MOV.B	W3, W0
	GOTO	L_interruptU1RX142
; indiceU1RX_1 end address is: 6 (W3)
L__interruptU1RX197:
;Digitalizador.c,1158 :: 		if (tramaGPS[indiceU1RX_1] == 0x2C){
	MOV.B	W3, W0
;Digitalizador.c,1163 :: 		}
L_interruptU1RX142:
;Digitalizador.c,1155 :: 		for (indiceU1RX_1 = 50; indiceU1RX_1 < 60; indiceU1RX_1++){
; indiceU1RX_1 start address is: 0 (W0)
; indiceU1RX_1 start address is: 6 (W3)
	ADD.B	W0, #1, W3
; indiceU1RX_1 end address is: 0 (W0)
;Digitalizador.c,1164 :: 		}
; indiceU1RX_1 end address is: 6 (W3)
	GOTO	L_interruptU1RX139
L_interruptU1RX140:
;Digitalizador.c,1167 :: 		horaLongGPS = RecuperarHoraGPS(datosGPS);
	MOV	#lo_addr(_datosGPS), W10
	CALL	_RecuperarHoraGPS
	MOV	W0, _horaLongGPS
	MOV	W1, _horaLongGPS+2
;Digitalizador.c,1168 :: 		fechaLongGPS = RecuperarFechaGPS(datosGPS);
	MOV	#lo_addr(_datosGPS), W10
	CALL	_RecuperarFechaGPS
	MOV	W0, _fechaLongGPS
	MOV	W1, _fechaLongGPS+2
;Digitalizador.c,1172 :: 		if (isComuGPS == false) {
	MOV	#lo_addr(_isComuGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptU1RX312
	GOTO	L_interruptU1RX146
L__interruptU1RX312:
;Digitalizador.c,1173 :: 		isComuGPS = true;
	MOV	#lo_addr(_isComuGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1178 :: 		isRecTiempoGPS = true;
	MOV	#lo_addr(_isRecTiempoGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1196 :: 		horaLongRTC = horaLongGPS;
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,1197 :: 		fechaLongRTC = fechaLongGPS;
	MOV	_fechaLongGPS, W0
	MOV	_fechaLongGPS+2, W1
	MOV	W0, _fechaLongRTC
	MOV	W1, _fechaLongRTC+2
;Digitalizador.c,1198 :: 		isActualizarRTC = true;
	MOV	#lo_addr(_isActualizarRTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1201 :: 		U1RXIE_bit = 0;
	BCLR	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,1202 :: 		}
L_interruptU1RX146:
;Digitalizador.c,1206 :: 		if ((horaLongGPS % 3600) == 0) {
	MOV	#3600, W2
	MOV	#0, W3
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__interruptU1RX313
	GOTO	L_interruptU1RX147
L__interruptU1RX313:
;Digitalizador.c,1207 :: 		LED = ~LED;
	BTG	LATB0_bit, BitPos(LATB0_bit+0)
;Digitalizador.c,1212 :: 		isRecTiempoGPS = true;
	MOV	#lo_addr(_isRecTiempoGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1223 :: 		horaLongRTC = horaLongGPS;
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,1224 :: 		fechaLongRTC = fechaLongGPS;
	MOV	_fechaLongGPS, W0
	MOV	_fechaLongGPS+2, W1
	MOV	W0, _fechaLongRTC
	MOV	W1, _fechaLongRTC+2
;Digitalizador.c,1225 :: 		isActualizarRTC = true;
	MOV	#lo_addr(_isActualizarRTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1228 :: 		U1RXIE_bit = 0;
	BCLR	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,1229 :: 		}
L_interruptU1RX147:
;Digitalizador.c,1230 :: 		}
L_interruptU1RX135:
;Digitalizador.c,1233 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1234 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1235 :: 		indice_gps = 0;
	CLR	W0
	MOV	W0, _indice_gps
;Digitalizador.c,1236 :: 		}
L_interruptU1RX134:
;Digitalizador.c,1237 :: 		}
L_end_interruptU1RX:
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	ULNK
	RETFIE
; end of _interruptU1RX
