
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

_bcd_to_decimal:

;tiempo_ds3231.c,46 :: 		unsigned char bcd_to_decimal(unsigned char number){
;tiempo_ds3231.c,47 :: 		return ( (number >> 4) * 10 + (number & 0x0F) );
	ZE	W10, W0
	LSR	W0, #4, W0
	ZE	W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W2
	ZE	W10, W0
	AND	W0, #15, W0
	ADD	W2, W0, W0
;tiempo_ds3231.c,48 :: 		}
L_end_bcd_to_decimal:
	RETURN
; end of _bcd_to_decimal

_decimal_to_bcd:
	LNK	#2

;tiempo_ds3231.c,51 :: 		unsigned char decimal_to_bcd(unsigned char number){
;tiempo_ds3231.c,52 :: 		return ( ((number / 10) << 4) + (number % 10) );
	ZE	W10, W0
	MOV	#10, W2
	REPEAT	#17
	DIV.S	W0, W2
	SL	W0, #4, W0
	MOV	W0, [W14+0]
	ZE	W10, W0
	MOV	#10, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	[W14+0], W0
	ADD	W0, W1, W0
;tiempo_ds3231.c,53 :: 		}
L_end_decimal_to_bcd:
	ULNK
	RETURN
; end of _decimal_to_bcd

_RTC_Write_Reg:

;tiempo_ds3231.c,56 :: 		void RTC_Write_Reg(unsigned char reg_address, unsigned char reg_value){
;tiempo_ds3231.c,57 :: 		RTC_I2C_START();
	PUSH	W10
	CALL	_Soft_I2C_Start
;tiempo_ds3231.c,58 :: 		RTC_I2C_WRITE(DS3231_ADDRESS);
	PUSH	W10
	MOV.B	#208, W10
	CALL	_Soft_I2C_Write
	POP	W10
;tiempo_ds3231.c,59 :: 		RTC_I2C_WRITE(reg_address);
	CALL	_Soft_I2C_Write
;tiempo_ds3231.c,60 :: 		RTC_I2C_WRITE(reg_value);
	MOV.B	W11, W10
	CALL	_Soft_I2C_Write
;tiempo_ds3231.c,61 :: 		RTC_I2C_STOP();
	CALL	_Soft_I2C_Stop
;tiempo_ds3231.c,62 :: 		}
L_end_RTC_Write_Reg:
	POP	W10
	RETURN
; end of _RTC_Write_Reg

_RTC_Read_Reg:

;tiempo_ds3231.c,65 :: 		unsigned char RTC_Read_Reg(unsigned char reg_address){
;tiempo_ds3231.c,67 :: 		RTC_I2C_START();
	PUSH	W10
	CALL	_Soft_I2C_Start
;tiempo_ds3231.c,68 :: 		RTC_I2C_WRITE(DS3231_ADDRESS);
	PUSH	W10
	MOV.B	#208, W10
	CALL	_Soft_I2C_Write
	POP	W10
;tiempo_ds3231.c,69 :: 		RTC_I2C_WRITE(reg_address);
	CALL	_Soft_I2C_Write
;tiempo_ds3231.c,70 :: 		RTC_I2C_RESTART();
	CALL	_Soft_I2C_Start
;tiempo_ds3231.c,71 :: 		RTC_I2C_WRITE(DS3231_ADDRESS | 0x01);
	MOV.B	#209, W10
	CALL	_Soft_I2C_Write
;tiempo_ds3231.c,72 :: 		reg_data = RTC_I2C_READ(0);
	CLR	W10
	CALL	_Soft_I2C_Read
; reg_data start address is: 2 (W1)
	MOV.B	W0, W1
;tiempo_ds3231.c,73 :: 		RTC_I2C_STOP();
	CALL	_Soft_I2C_Stop
;tiempo_ds3231.c,74 :: 		return reg_data;
	MOV.B	W1, W0
; reg_data end address is: 2 (W1)
;tiempo_ds3231.c,75 :: 		}
;tiempo_ds3231.c,74 :: 		return reg_data;
;tiempo_ds3231.c,75 :: 		}
L_end_RTC_Read_Reg:
	POP	W10
	RETURN
; end of _RTC_Read_Reg

_DS3231_init:

;tiempo_ds3231.c,78 :: 		void DS3231_init(){
;tiempo_ds3231.c,79 :: 		RTC_Write_Reg(DS3231_REG_CONTROL, 0x20);
	PUSH	W10
	PUSH	W11
	MOV.B	#32, W11
	MOV.B	#14, W10
	CALL	_RTC_Write_Reg
;tiempo_ds3231.c,80 :: 		}
L_end_DS3231_init:
	POP	W11
	POP	W10
	RETURN
; end of _DS3231_init

_DS3231_setTime:
	LNK	#14

;tiempo_ds3231.c,83 :: 		void DS3231_setTime(unsigned long longHora, unsigned long longFecha){
;tiempo_ds3231.c,93 :: 		hora = (char)(longHora / 3600);
	PUSH	W10
	PUSH	W11
	PUSH.D	W12
	PUSH.D	W10
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	MOV.B	W0, [W14+0]
;tiempo_ds3231.c,94 :: 		minuto = (char)((longHora%3600) / 60);
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
	MOV.B	W0, [W14+1]
;tiempo_ds3231.c,95 :: 		segundo = (char)((longHora%3600) % 60);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W12
	MOV.B	W0, [W14+2]
;tiempo_ds3231.c,98 :: 		dia = (char)(longFecha / 10000);
	PUSH.D	W12
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W12
	MOV.B	W0, [W14+3]
;tiempo_ds3231.c,99 :: 		mes = (char)((longFecha%10000) / 100);
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
	MOV.B	W0, [W14+4]
;tiempo_ds3231.c,100 :: 		anio = (char)((longFecha%10000) % 100);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
; anio start address is: 6 (W3)
	MOV.B	W0, W3
;tiempo_ds3231.c,103 :: 		segundo = decimal_to_bcd(segundo);
	MOV.B	[W14+2], W10
	CALL	_decimal_to_bcd
	MOV.B	W0, [W14+2]
;tiempo_ds3231.c,104 :: 		minuto = decimal_to_bcd(minuto);
	MOV.B	[W14+1], W10
	CALL	_decimal_to_bcd
	MOV.B	W0, [W14+1]
;tiempo_ds3231.c,105 :: 		hora = decimal_to_bcd(hora);
	MOV.B	[W14+0], W10
	CALL	_decimal_to_bcd
	MOV.B	W0, [W14+0]
;tiempo_ds3231.c,106 :: 		dia = decimal_to_bcd(dia);
	MOV.B	[W14+3], W10
	CALL	_decimal_to_bcd
	MOV.B	W0, [W14+3]
;tiempo_ds3231.c,107 :: 		mes = decimal_to_bcd(mes);
	MOV.B	[W14+4], W10
	CALL	_decimal_to_bcd
	MOV.B	W0, [W14+4]
;tiempo_ds3231.c,108 :: 		anio = decimal_to_bcd(anio);
	MOV.B	W3, W10
; anio end address is: 6 (W3)
	CALL	_decimal_to_bcd
; anio start address is: 4 (W2)
	MOV.B	W0, W2
;tiempo_ds3231.c,111 :: 		RTC_Write_Reg(DS3231_REG_SEGUNDOS,segundo);
	MOV.B	[W14+2], W11
	CLR	W10
	CALL	_RTC_Write_Reg
;tiempo_ds3231.c,112 :: 		RTC_Write_Reg(DS3231_REG_MINUTOS,minuto);
	MOV.B	[W14+1], W11
	MOV.B	#1, W10
	CALL	_RTC_Write_Reg
;tiempo_ds3231.c,113 :: 		RTC_Write_Reg(DS3231_REG_HORAS,hora);
	MOV.B	[W14+0], W11
	MOV.B	#2, W10
	CALL	_RTC_Write_Reg
;tiempo_ds3231.c,114 :: 		RTC_Write_Reg(DS3231_REG_DIA,dia);
	MOV.B	[W14+3], W11
	MOV.B	#4, W10
	CALL	_RTC_Write_Reg
;tiempo_ds3231.c,115 :: 		RTC_Write_Reg(DS3231_REG_MES,mes);
	MOV.B	[W14+4], W11
	MOV.B	#5, W10
	CALL	_RTC_Write_Reg
;tiempo_ds3231.c,116 :: 		RTC_Write_Reg(DS3231_REG_ANIO,anio);
	MOV.B	W2, W11
; anio end address is: 4 (W2)
	MOV.B	#6, W10
	CALL	_RTC_Write_Reg
;tiempo_ds3231.c,118 :: 		}
L_end_DS3231_setTime:
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _DS3231_setTime

_DS3231_getHour:
	LNK	#20

;tiempo_ds3231.c,121 :: 		unsigned long DS3231_getHour(){
;tiempo_ds3231.c,129 :: 		valueRead = RTC_Read_Reg(DS3231_REG_SEGUNDOS);
	PUSH	W10
	CLR	W10
	CALL	_RTC_Read_Reg
;tiempo_ds3231.c,130 :: 		valueRead = bcd_to_decimal(valueRead);
	MOV.B	W0, W10
	CALL	_bcd_to_decimal
;tiempo_ds3231.c,131 :: 		segundo = (long)valueRead;
	ZE	W0, W0
	CLR	W1
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
;tiempo_ds3231.c,132 :: 		valueRead = RTC_Read_Reg(DS3231_REG_MINUTOS);
	MOV.B	#1, W10
	CALL	_RTC_Read_Reg
;tiempo_ds3231.c,133 :: 		valueRead = bcd_to_decimal(valueRead);
	MOV.B	W0, W10
	CALL	_bcd_to_decimal
;tiempo_ds3231.c,134 :: 		minuto = (long)valueRead;
	ZE	W0, W0
	CLR	W1
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;tiempo_ds3231.c,135 :: 		valueRead = RTC_Read_Reg(DS3231_REG_HORAS);
	MOV.B	#2, W10
	CALL	_RTC_Read_Reg
;tiempo_ds3231.c,136 :: 		valueRead = bcd_to_decimal(valueRead);
	MOV.B	W0, W10
	CALL	_bcd_to_decimal
;tiempo_ds3231.c,137 :: 		hora = (long)valueRead;
	ZE	W0, W0
	CLR	W1
;tiempo_ds3231.c,139 :: 		horaRTC = (hora*3600)+(minuto*60)+(segundo);                               //Calcula el segundo actual = hh*3600 + mm*60 + ss
	MOV	#3600, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, [W14+16]
	MOV	W1, [W14+18]
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+16], W2
	MOV	[W14+18], W3
	ADD	W2, W0, W4
	ADDC	W3, W1, W5
	ADD	W14, #4, W2
	ADD	W4, [W2++], W0
	ADDC	W5, [W2--], W1
;tiempo_ds3231.c,141 :: 		return horaRTC;
;tiempo_ds3231.c,143 :: 		}
;tiempo_ds3231.c,141 :: 		return horaRTC;
;tiempo_ds3231.c,143 :: 		}
L_end_DS3231_getHour:
	POP	W10
	ULNK
	RETURN
; end of _DS3231_getHour

_DS3231_getDate:
	LNK	#20

;tiempo_ds3231.c,146 :: 		unsigned long DS3231_getDate(){
;tiempo_ds3231.c,154 :: 		valueRead = RTC_Read_Reg(DS3231_REG_DIA);
	PUSH	W10
	MOV.B	#4, W10
	CALL	_RTC_Read_Reg
;tiempo_ds3231.c,155 :: 		valueRead = bcd_to_decimal(valueRead);
	MOV.B	W0, W10
	CALL	_bcd_to_decimal
;tiempo_ds3231.c,156 :: 		dia = (long)valueRead;
	ZE	W0, W0
	CLR	W1
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;tiempo_ds3231.c,157 :: 		valueRead = RTC_Read_Reg(DS3231_REG_MES);
	MOV.B	#5, W10
	CALL	_RTC_Read_Reg
;tiempo_ds3231.c,158 :: 		valueRead = bcd_to_decimal(valueRead);
	MOV.B	W0, W10
	CALL	_bcd_to_decimal
;tiempo_ds3231.c,159 :: 		mes = (long)valueRead;
	ZE	W0, W0
	CLR	W1
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
;tiempo_ds3231.c,160 :: 		valueRead = RTC_Read_Reg(DS3231_REG_ANIO);
	MOV.B	#6, W10
	CALL	_RTC_Read_Reg
;tiempo_ds3231.c,161 :: 		valueRead = bcd_to_decimal(valueRead);
	MOV.B	W0, W10
	CALL	_bcd_to_decimal
;tiempo_ds3231.c,162 :: 		anio = (long)valueRead;
	ZE	W0, W0
	CLR	W1
;tiempo_ds3231.c,164 :: 		fechaRTC = (anio*10000)+(mes*100)+(dia);                                   //10000*aa + 100*mm + dd
	MOV	#10000, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, [W14+16]
	MOV	W1, [W14+18]
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+16], W2
	MOV	[W14+18], W3
	ADD	W2, W0, W4
	ADDC	W3, W1, W5
	ADD	W14, #0, W2
	ADD	W4, [W2++], W0
	ADDC	W5, [W2--], W1
;tiempo_ds3231.c,166 :: 		return fechaRTC;
;tiempo_ds3231.c,168 :: 		}
;tiempo_ds3231.c,166 :: 		return fechaRTC;
;tiempo_ds3231.c,168 :: 		}
L_end_DS3231_getDate:
	POP	W10
	ULNK
	RETURN
; end of _DS3231_getDate

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;Digitalizador.c,238 :: 		void main() {
;Digitalizador.c,242 :: 		Setup();
	PUSH	W10
	CALL	_Setup
;Digitalizador.c,243 :: 		Delay_ms(500);
	MOV	#77, W8
	MOV	#19288, W7
L_main0:
	DEC	W7
	BRA NZ	L_main0
	DEC	W8
	BRA NZ	L_main0
	NOP
;Digitalizador.c,247 :: 		GenerarInterrupcionRPi(DSPIC_CONEC);
	MOV.B	#180, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,250 :: 		Delay_ms(100);
	MOV	#16, W8
	MOV	#16964, W7
L_main2:
	DEC	W7
	BRA NZ	L_main2
	DEC	W8
	BRA NZ	L_main2
;Digitalizador.c,252 :: 		while (1) {
L_main4:
;Digitalizador.c,256 :: 		contadorWDT ++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contadorWDT), W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,257 :: 		CheckWatchDog();
	CALL	_CheckWatchDog
;Digitalizador.c,264 :: 		if (isEnviarGPSOk == true) {
	MOV	#lo_addr(_isEnviarGPSOk), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main181
	GOTO	L_main6
L__main181:
;Digitalizador.c,265 :: 		isEnviarGPSOk = false;
	MOV	#lo_addr(_isEnviarGPSOk), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,267 :: 		GenerarInterrupcionRPi(GPS_OK);
	MOV.B	#181, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,270 :: 		} else if (isPrimeraVezMuestreo == true) {
	GOTO	L_main7
L_main6:
	MOV	#lo_addr(_isPrimeraVezMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main182
	GOTO	L_main8
L__main182:
;Digitalizador.c,271 :: 		isPrimeraVezMuestreo = false;
	MOV	#lo_addr(_isPrimeraVezMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,273 :: 		GenerarInterrupcionRPi(ENV_TIME_SIS);
	MOV.B	#179, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,274 :: 		}
L_main8:
L_main7:
;Digitalizador.c,286 :: 		}
	GOTO	L_main4
;Digitalizador.c,287 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_Setup:

;Digitalizador.c,289 :: 		void Setup () {
;Digitalizador.c,294 :: 		ADPCFG = 0XFFFF;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;Digitalizador.c,297 :: 		PCFG_11_bit = 0;    PCFG_10_bit = 0;       PCFG_9_bit = 0;
	BCLR	PCFG_11_bit, BitPos(PCFG_11_bit+0)
	BCLR	PCFG_10_bit, BitPos(PCFG_10_bit+0)
	BCLR	PCFG_9_bit, BitPos(PCFG_9_bit+0)
;Digitalizador.c,299 :: 		PCFG_12_bit = 0;
	BCLR	PCFG_12_bit, BitPos(PCFG_12_bit+0)
;Digitalizador.c,302 :: 		TRISB11_bit = 1;   TRISB10_bit = 1;       TRISB9_bit = 1;
	BSET	TRISB11_bit, BitPos(TRISB11_bit+0)
	BSET	TRISB10_bit, BitPos(TRISB10_bit+0)
	BSET	TRISB9_bit, BitPos(TRISB9_bit+0)
;Digitalizador.c,304 :: 		TRISB12_bit = 1;
	BSET	TRISB12_bit, BitPos(TRISB12_bit+0)
;Digitalizador.c,307 :: 		TRISB3_bit = 0;     TRISB4_bit = 0;
	BCLR	TRISB3_bit, BitPos(TRISB3_bit+0)
	BCLR	TRISB4_bit, BitPos(TRISB4_bit+0)
;Digitalizador.c,308 :: 		TRISB5_bit = 0;     TRISB6_bit = 0;
	BCLR	TRISB5_bit, BitPos(TRISB5_bit+0)
	BCLR	TRISB6_bit, BitPos(TRISB6_bit+0)
;Digitalizador.c,311 :: 		LATB = (LATB & 0b1110000111) | (0b0001111000 & (ganancia  << 3));
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
;Digitalizador.c,314 :: 		InitTimer3();
	CALL	_InitTimer3
;Digitalizador.c,317 :: 		LED_DIRECTION = 0;
	BCLR	TRISB0_bit, BitPos(TRISB0_bit+0)
;Digitalizador.c,318 :: 		LED_2_DIRECTION = 0;
	BCLR	TRISD0_bit, BitPos(TRISD0_bit+0)
;Digitalizador.c,319 :: 		LED_3_DIRECTION = 0;
	BCLR	TRISD1_bit, BitPos(TRISD1_bit+0)
;Digitalizador.c,320 :: 		LED_4_DIRECTION = 0;
	BCLR	TRISB8_bit, BitPos(TRISB8_bit+0)
;Digitalizador.c,322 :: 		LED = 1;
	BSET	LATB0_bit, BitPos(LATB0_bit+0)
;Digitalizador.c,323 :: 		LED_2 = 1;
	BSET	LATD0_bit, BitPos(LATD0_bit+0)
;Digitalizador.c,324 :: 		LED_3 = 1;
	BSET	LATD1_bit, BitPos(LATD1_bit+0)
;Digitalizador.c,325 :: 		LED_4 = 1;
	BSET	LATB8_bit, BitPos(LATB8_bit+0)
;Digitalizador.c,326 :: 		Delay_ms(300);
	MOV	#46, W8
	MOV	#50894, W7
L_Setup9:
	DEC	W7
	BRA NZ	L_Setup9
	DEC	W8
	BRA NZ	L_Setup9
;Digitalizador.c,327 :: 		LED = 0;
	BCLR	LATB0_bit, BitPos(LATB0_bit+0)
;Digitalizador.c,328 :: 		LED_2 = 0;
	BCLR	LATD0_bit, BitPos(LATD0_bit+0)
;Digitalizador.c,329 :: 		Delay_ms(300);
	MOV	#46, W8
	MOV	#50894, W7
L_Setup11:
	DEC	W7
	BRA NZ	L_Setup11
	DEC	W8
	BRA NZ	L_Setup11
;Digitalizador.c,330 :: 		LED = 1;
	BSET	LATB0_bit, BitPos(LATB0_bit+0)
;Digitalizador.c,331 :: 		LED_2 = 1;
	BSET	LATD0_bit, BitPos(LATD0_bit+0)
;Digitalizador.c,339 :: 		PIN_RPi = 0;
	BCLR	LATF1_bit, BitPos(LATF1_bit+0)
;Digitalizador.c,340 :: 		PIN_RPi_DIRECTION = 0;
	BCLR	TRISF1_bit, BitPos(TRISF1_bit+0)
;Digitalizador.c,343 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,345 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,347 :: 		indice_gps = 0;
	CLR	W0
	MOV	W0, _indice_gps
;Digitalizador.c,353 :: 		SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
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
;Digitalizador.c,357 :: 		SPI1IE_bit = 1;
	BSET	SPI1IE_bit, BitPos(SPI1IE_bit+0)
;Digitalizador.c,359 :: 		SPI1IF_bit = 0;
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Digitalizador.c,361 :: 		IPC2bits.SPI1IP = 7;
	MOV	#lo_addr(IPC2bits), W0
	MOV.B	[W0], W0
	IOR.B	W0, #7, W1
	MOV	#lo_addr(IPC2bits), W0
	MOV.B	W1, [W0]
;Digitalizador.c,363 :: 		SPIROV_bit = 0;
	BCLR	SPIROV_bit, BitPos(SPIROV_bit+0)
;Digitalizador.c,365 :: 		SPI1STAT.SPIEN = 1;
	BSET	SPI1STAT, #15
;Digitalizador.c,374 :: 		UART1_Init(9600);
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;Digitalizador.c,377 :: 		LATD3_bit = 1;
	BSET	LATD3_bit, BitPos(LATD3_bit+0)
;Digitalizador.c,378 :: 		TRISD3_bit = 0;
	BCLR	TRISD3_bit, BitPos(TRISD3_bit+0)
;Digitalizador.c,380 :: 		ALTIO_bit = 1;
	BSET	ALTIO_bit, BitPos(ALTIO_bit+0)
;Digitalizador.c,381 :: 		Delay_ms(100);
	MOV	#16, W8
	MOV	#16964, W7
L_Setup13:
	DEC	W7
	BRA NZ	L_Setup13
	DEC	W8
	BRA NZ	L_Setup13
;Digitalizador.c,383 :: 		CN1PUE_bit = 1;
	BSET	CN1PUE_bit, BitPos(CN1PUE_bit+0)
;Digitalizador.c,386 :: 		U1RXIE_bit = 1;
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,388 :: 		U1RXIF_bit = 0;
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;Digitalizador.c,390 :: 		IPC2bits.U1RXIP = 0x04;
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
;Digitalizador.c,391 :: 		U1STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;Digitalizador.c,397 :: 		UART1_Write_Text("$PMTK220,1000*1F\r\n");
	MOV	#lo_addr(?lstr1_Digitalizador), W10
	CALL	_UART1_Write_Text
;Digitalizador.c,399 :: 		Delay_ms(1000);
	MOV	#153, W8
	MOV	#38577, W7
L_Setup15:
	DEC	W7
	BRA NZ	L_Setup15
	DEC	W8
	BRA NZ	L_Setup15
	NOP
	NOP
;Digitalizador.c,404 :: 		UART1_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n");
	MOV	#lo_addr(?lstr2_Digitalizador), W10
	CALL	_UART1_Write_Text
;Digitalizador.c,405 :: 		Delay_ms(1000);
	MOV	#153, W8
	MOV	#38577, W7
L_Setup17:
	DEC	W7
	BRA NZ	L_Setup17
	DEC	W8
	BRA NZ	L_Setup17
	NOP
	NOP
;Digitalizador.c,408 :: 		TRISA11_bit = 1;
	BSET	TRISA11_bit, BitPos(TRISA11_bit+0)
;Digitalizador.c,409 :: 		RA11_bit = 0;
	BCLR	RA11_bit, BitPos(RA11_bit+0)
;Digitalizador.c,414 :: 		INT0EP_bit = 0;
	BCLR	INT0EP_bit, BitPos(INT0EP_bit+0)
;Digitalizador.c,416 :: 		INT0IE_bit = 1;
	BSET	INT0IE_bit, BitPos(INT0IE_bit+0)
;Digitalizador.c,418 :: 		INT0IF_bit = 0;
	BCLR	INT0IF_bit, BitPos(INT0IF_bit+0)
;Digitalizador.c,421 :: 		INT0IP_2_bit = 1;
	BSET	INT0IP_2_bit, BitPos(INT0IP_2_bit+0)
;Digitalizador.c,422 :: 		INT0IP_1_bit = 0;
	BCLR	INT0IP_1_bit, BitPos(INT0IP_1_bit+0)
;Digitalizador.c,423 :: 		INT0IP_0_bit = 0;
	BCLR	INT0IP_0_bit, BitPos(INT0IP_0_bit+0)
;Digitalizador.c,432 :: 		DS3231_init();
	CALL	_DS3231_init
;Digitalizador.c,435 :: 		TRISD9_bit = 1;         // Como entrada la señal del reloj
	BSET	TRISD9_bit, BitPos(TRISD9_bit+0)
;Digitalizador.c,436 :: 		INT2IE_bit = 1;         // Habilita la interrupcion INT2
	BSET	INT2IE_bit, BitPos(INT2IE_bit+0)
;Digitalizador.c,437 :: 		INT2IF_bit = 0;         // Limpia la bandera de interrupcion de INT2
	BCLR	INT2IF_bit, BitPos(INT2IF_bit+0)
;Digitalizador.c,440 :: 		INT2EP_bit = 1;
	BSET	INT2EP_bit, BitPos(INT2EP_bit+0)
;Digitalizador.c,443 :: 		INT2IP_2_bit = 1;
	BSET	INT2IP_2_bit, BitPos(INT2IP_2_bit+0)
;Digitalizador.c,444 :: 		INT2IP_1_bit = 0;
	BCLR	INT2IP_1_bit, BitPos(INT2IP_1_bit+0)
;Digitalizador.c,445 :: 		INT2IP_0_bit = 0;
	BCLR	INT2IP_0_bit, BitPos(INT2IP_0_bit+0)
;Digitalizador.c,451 :: 		Delay_ms(500);
	MOV	#77, W8
	MOV	#19288, W7
L_Setup19:
	DEC	W7
	BRA NZ	L_Setup19
	DEC	W8
	BRA NZ	L_Setup19
	NOP
;Digitalizador.c,453 :: 		}
L_end_Setup:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Setup

_CheckWatchDog:

;Digitalizador.c,458 :: 		bool CheckWatchDog () {
;Digitalizador.c,459 :: 		if (contadorWDT >= 2){
	MOV	#lo_addr(_contadorWDT), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA GEU	L__CheckWatchDog186
	GOTO	L_CheckWatchDog21
L__CheckWatchDog186:
;Digitalizador.c,460 :: 		contadorWDT = 0;
	MOV	#lo_addr(_contadorWDT), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,461 :: 		asm clrwdt;
	CLRWDT
;Digitalizador.c,462 :: 		return true;
	MOV.B	#1, W0
	GOTO	L_end_CheckWatchDog
;Digitalizador.c,463 :: 		} else {
L_CheckWatchDog21:
;Digitalizador.c,464 :: 		return false;
	CLR	W0
;Digitalizador.c,466 :: 		}
L_end_CheckWatchDog:
	RETURN
; end of _CheckWatchDog

_InitTimer3:

;Digitalizador.c,478 :: 		void InitTimer3() {
;Digitalizador.c,481 :: 		T3CON = 0x0010;
	MOV	#16, W0
	MOV	WREG, T3CON
;Digitalizador.c,484 :: 		T3IE_bit = 1;
	BSET	T3IE_bit, BitPos(T3IE_bit+0)
;Digitalizador.c,485 :: 		T3IF_bit = 0;
	BCLR	T3IF_bit, BitPos(T3IF_bit+0)
;Digitalizador.c,488 :: 		TMR3 = 0;
	CLR	TMR3
;Digitalizador.c,491 :: 		T3IP_2_bit = 1;
	BSET	T3IP_2_bit, BitPos(T3IP_2_bit+0)
;Digitalizador.c,492 :: 		T3IP_1_bit = 1;
	BSET	T3IP_1_bit, BitPos(T3IP_1_bit+0)
;Digitalizador.c,493 :: 		T3IP_0_bit = 1;
	BSET	T3IP_0_bit, BitPos(T3IP_0_bit+0)
;Digitalizador.c,496 :: 		PR3 = 37500;
	MOV	#37500, W0
	MOV	WREG, PR3
;Digitalizador.c,497 :: 		}
L_end_InitTimer3:
	RETURN
; end of _InitTimer3

_GenerarInterrupcionRPi:

;Digitalizador.c,507 :: 		void GenerarInterrupcionRPi(unsigned short operacion){
;Digitalizador.c,519 :: 		bandOperacion = 0; bandTimeFromRPi = 0; bandTimeFromDSPIC = 0;
	MOV	#lo_addr(_bandOperacion), W1
	CLR	W0
	MOV.B	W0, [W1]
	MOV	#lo_addr(_bandTimeFromRPi), W1
	CLR	W0
	MOV.B	W0, [W1]
	MOV	#lo_addr(_bandTimeFromDSPIC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,524 :: 		bandTramaRecBytesPorMuestra = 0; bandTramaInitMues = 0;
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W1
	CLR	W0
	MOV.B	W0, [W1]
	MOV	#lo_addr(_bandTramaInitMues), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,527 :: 		tipoOperacion = operacion;
	MOV	#lo_addr(_tipoOperacion), W0
	MOV.B	W10, [W0]
;Digitalizador.c,529 :: 		LED_4 = ~LED_4;
	BTG	LATB8_bit, BitPos(LATB8_bit+0)
;Digitalizador.c,532 :: 		if (SPIROV_bit == 1) {
	BTSS	SPIROV_bit, BitPos(SPIROV_bit+0)
	GOTO	L_GenerarInterrupcionRPi23
;Digitalizador.c,534 :: 		LED_3 = ~LED_3;
	BTG	LATD1_bit, BitPos(LATD1_bit+0)
;Digitalizador.c,537 :: 		SPIROV_bit = 0;
	BCLR	SPIROV_bit, BitPos(SPIROV_bit+0)
;Digitalizador.c,541 :: 		if (SPI1IF_bit == 1) {
	BTSS	SPI1IF_bit, BitPos(SPI1IF_bit+0)
	GOTO	L_GenerarInterrupcionRPi24
;Digitalizador.c,542 :: 		SPI1IF_bit = 0;
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Digitalizador.c,543 :: 		}
L_GenerarInterrupcionRPi24:
;Digitalizador.c,544 :: 		}
L_GenerarInterrupcionRPi23:
;Digitalizador.c,549 :: 		PIN_RPi = 1;
	BSET	LATF1_bit, BitPos(LATF1_bit+0)
;Digitalizador.c,551 :: 		Delay_us(40);
	MOV	#400, W7
L_GenerarInterrupcionRPi25:
	DEC	W7
	BRA NZ	L_GenerarInterrupcionRPi25
;Digitalizador.c,552 :: 		PIN_RPi = 0;
	BCLR	LATF1_bit, BitPos(LATF1_bit+0)
;Digitalizador.c,553 :: 		}
L_end_GenerarInterrupcionRPi:
	RETURN
; end of _GenerarInterrupcionRPi

_LeerCanalADC:

;Digitalizador.c,565 :: 		unsigned int LeerCanalADC (unsigned int canal) {
;Digitalizador.c,570 :: 		ADCON1 = 0b0000000011100000;
	MOV	#224, W0
	MOV	WREG, ADCON1
;Digitalizador.c,573 :: 		ADCHS = 0X0000 | canal;
	MOV	W10, ADCHS
;Digitalizador.c,588 :: 		ADCON3 = 0b0000000100101000; //SAMC<4:0> = 1*TAD ... SI ADCS<5:0> = 40 ... si 30 MIPS :: Tcy = 33ns y TAD = 677nsec ... TiempoConversion: 15*TAD = 15*683.33ns = 10.249 us
	MOV	#296, W0
	MOV	WREG, ADCON3
;Digitalizador.c,591 :: 		ADON_bit = 1;
	BSET	ADON_bit, BitPos(ADON_bit+0)
;Digitalizador.c,595 :: 		SAMP_bit = 1;
	BSET	SAMP_bit, BitPos(SAMP_bit+0)
;Digitalizador.c,598 :: 		while (DONE_bit == 0) {
L_LeerCanalADC27:
	BTSC	DONE_bit, BitPos(DONE_bit+0)
	GOTO	L_LeerCanalADC28
;Digitalizador.c,599 :: 		asm nop;
	NOP
;Digitalizador.c,600 :: 		}
	GOTO	L_LeerCanalADC27
L_LeerCanalADC28:
;Digitalizador.c,602 :: 		valADCleido = ADCBUF0;
; valADCleido start address is: 2 (W1)
	MOV	ADCBUF0, W1
;Digitalizador.c,604 :: 		ADON_bit = 0;
	BCLR	ADON_bit, BitPos(ADON_bit+0)
;Digitalizador.c,606 :: 		return valADCleido;
	MOV	W1, W0
; valADCleido end address is: 2 (W1)
;Digitalizador.c,607 :: 		}
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

;Digitalizador.c,618 :: 		void Timer3Interrupt() iv IVT_ADDR_T3INTERRUPT{
;Digitalizador.c,636 :: 		T3IF_bit = 0;
	PUSH	W10
	BCLR	T3IF_bit, BitPos(T3IF_bit+0)
;Digitalizador.c,641 :: 		contadorFsample ++;
	MOV	#1, W1
	MOV	#lo_addr(Timer3Interrupt_contadorFsample_L0), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,644 :: 		valADC_canal_1 = LeerCanalADC(11);
	MOV	#11, W10
	CALL	_LeerCanalADC
	MOV	W0, [W14+0]
;Digitalizador.c,645 :: 		valADC_canal_2 = LeerCanalADC(10);
	MOV	#10, W10
	CALL	_LeerCanalADC
	MOV	W0, [W14+2]
;Digitalizador.c,646 :: 		valADC_canal_3 = LeerCanalADC(9);
	MOV	#9, W10
	CALL	_LeerCanalADC
	MOV	W0, [W14+4]
;Digitalizador.c,649 :: 		punteroValADC_1 = &valADC_canal_1;
	ADD	W14, #0, W2
; punteroValADC_1 start address is: 8 (W4)
	MOV	W2, W4
;Digitalizador.c,650 :: 		punteroValADC_2 = &valADC_canal_2;
	ADD	W14, #2, W0
; punteroValADC_2 start address is: 10 (W5)
	MOV	W0, W5
;Digitalizador.c,651 :: 		punteroValADC_3 = &valADC_canal_3;
	ADD	W14, #4, W0
; punteroValADC_3 start address is: 12 (W6)
	MOV	W0, W6
;Digitalizador.c,657 :: 		vectorDatos[0] = (ganancia << 4) | *(punteroValADC_1 + 1);
	ADD	W14, #6, W3
	MOV	#lo_addr(_ganancia), W0
	ZE	[W0], W0
	SL	W0, #4, W1
	ADD	W2, #1, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV.B	W0, [W3]
;Digitalizador.c,659 :: 		vectorDatos[1] = *punteroValADC_1;
	ADD	W3, #1, W0
	MOV.B	[W4], [W0]
; punteroValADC_1 end address is: 8 (W4)
;Digitalizador.c,661 :: 		vectorDatos[2] = (*(punteroValADC_2 + 1) << 4) | *(punteroValADC_3 + 1);
	ADD	W3, #2, W2
	ADD	W5, #1, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #4, W1
	ADD	W6, #1, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV.B	W0, [W2]
;Digitalizador.c,663 :: 		vectorDatos[3] = *punteroValADC_2;
	ADD	W3, #3, W0
	MOV.B	[W5], [W0]
; punteroValADC_2 end address is: 10 (W5)
;Digitalizador.c,664 :: 		vectorDatos[4] = *punteroValADC_3;
	ADD	W3, #4, W0
	MOV.B	[W6], [W0]
; punteroValADC_3 end address is: 12 (W6)
;Digitalizador.c,667 :: 		for (indiceForTimer3 = 0; indiceForTimer3 < numBytesPorMuestra; indiceForTimer3 ++) {
; indiceForTimer3 start address is: 6 (W3)
	CLR	W3
; indiceForTimer3 end address is: 6 (W3)
L_Timer3Interrupt29:
; indiceForTimer3 start address is: 6 (W3)
	CP.B	W3, #5
	BRA LTU	L__Timer3Interrupt191
	GOTO	L_Timer3Interrupt30
L__Timer3Interrupt191:
;Digitalizador.c,668 :: 		vectorData[contadorMuestras + indiceForTimer3] = vectorDatos[indiceForTimer3];
	ZE	W3, W1
	MOV	#lo_addr(_contadorMuestras), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_vectorData), W0
	ADD	W0, W1, W2
	ADD	W14, #6, W1
	ZE	W3, W0
	ADD	W1, W0, W0
	MOV.B	[W0], [W2]
;Digitalizador.c,667 :: 		for (indiceForTimer3 = 0; indiceForTimer3 < numBytesPorMuestra; indiceForTimer3 ++) {
	INC.B	W3
;Digitalizador.c,669 :: 		}
; indiceForTimer3 end address is: 6 (W3)
	GOTO	L_Timer3Interrupt29
L_Timer3Interrupt30:
;Digitalizador.c,670 :: 		contadorMuestras = contadorMuestras + numBytesPorMuestra;
	MOV	_contadorMuestras, W0
	ADD	W0, #5, W1
	MOV	W1, _contadorMuestras
;Digitalizador.c,676 :: 		if (contadorMuestras >= numMuestrasEnvio) {
	MOV	#250, W0
	CP	W1, W0
	BRA GEU	L__Timer3Interrupt192
	GOTO	L_Timer3Interrupt32
L__Timer3Interrupt192:
;Digitalizador.c,684 :: 		if (contadorFsample >= fsample) {
	MOV	#lo_addr(_fsample), W0
	ZE	[W0], W1
	MOV	#lo_addr(Timer3Interrupt_contadorFsample_L0), W0
	CP	W1, [W0]
	BRA LEU	L__Timer3Interrupt193
	GOTO	L_Timer3Interrupt33
L__Timer3Interrupt193:
;Digitalizador.c,686 :: 		contadorFsample = 0;
	CLR	W0
	MOV	W0, Timer3Interrupt_contadorFsample_L0
;Digitalizador.c,688 :: 		TON_T3CON_bit = 0;
	BCLR	TON_T3CON_bit, BitPos(TON_T3CON_bit+0)
;Digitalizador.c,689 :: 		}
L_Timer3Interrupt33:
;Digitalizador.c,691 :: 		if (isEnviarHoraToRPi == true) {
	MOV	#lo_addr(_isEnviarHoraToRPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Timer3Interrupt194
	GOTO	L_Timer3Interrupt34
L__Timer3Interrupt194:
;Digitalizador.c,699 :: 		punteroLong = &horaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_horaLongSistema), W2
;Digitalizador.c,701 :: 		vectorData[numMuestrasEnvio] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+250), W0
	MOV.B	W1, [W0]
;Digitalizador.c,702 :: 		vectorData[numMuestrasEnvio + 1] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+251), W0
	MOV.B	W1, [W0]
;Digitalizador.c,703 :: 		vectorData[numMuestrasEnvio + 2] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorData+252), W0
	MOV.B	W1, [W0]
;Digitalizador.c,705 :: 		punteroLong = &fechaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_fechaLongSistema), W2
;Digitalizador.c,707 :: 		vectorData[numMuestrasEnvio + 3] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+253), W0
	MOV.B	W1, [W0]
;Digitalizador.c,708 :: 		vectorData[numMuestrasEnvio + 4] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+254), W0
	MOV.B	W1, [W0]
;Digitalizador.c,709 :: 		vectorData[numMuestrasEnvio + 5] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorData+255), W0
	MOV.B	W1, [W0]
;Digitalizador.c,713 :: 		isLibreVectorData = false;
	MOV	#lo_addr(_isLibreVectorData), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,715 :: 		contadorMuestras = 0;
	CLR	W0
	MOV	W0, _contadorMuestras
;Digitalizador.c,722 :: 		GenerarInterrupcionRPi(ENV_MUESTRAS_TIME);
	MOV.B	#178, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,726 :: 		} else {
	GOTO	L_Timer3Interrupt35
L_Timer3Interrupt34:
;Digitalizador.c,728 :: 		isLibreVectorData = false;
	MOV	#lo_addr(_isLibreVectorData), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,729 :: 		contadorMuestras = 0;
	CLR	W0
	MOV	W0, _contadorMuestras
;Digitalizador.c,735 :: 		GenerarInterrupcionRPi(ENV_MUESTRAS);
	MOV.B	#177, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,736 :: 		}
L_Timer3Interrupt35:
;Digitalizador.c,737 :: 		}
L_Timer3Interrupt32:
;Digitalizador.c,738 :: 		}
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

;Digitalizador.c,748 :: 		void interruptSPI1 () org  IVT_ADDR_SPI1INTERRUPT {
;Digitalizador.c,765 :: 		SPI1IF_bit = 0;
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Digitalizador.c,767 :: 		dataSPI = SPI1BUF;
; dataSPI start address is: 4 (W2)
	MOV	SPI1BUF, W2
;Digitalizador.c,773 :: 		if (bandOperacion == 0 && dataSPI == INI_OBT_OPE) {
	MOV	#lo_addr(_bandOperacion), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1196
	GOTO	L__interruptSPI1134
L__interruptSPI1196:
	MOV.B	#160, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1197
	GOTO	L__interruptSPI1133
L__interruptSPI1197:
; dataSPI end address is: 4 (W2)
L__interruptSPI1132:
;Digitalizador.c,776 :: 		bandOperacion = 1;
	MOV	#lo_addr(_bandOperacion), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,778 :: 		SPI1BUF = tipoOperacion;
	MOV	#lo_addr(_tipoOperacion), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,781 :: 		} else if (bandOperacion == 1 && dataSPI == FIN_OBT_OPE) {
	GOTO	L_interruptSPI139
;Digitalizador.c,773 :: 		if (bandOperacion == 0 && dataSPI == INI_OBT_OPE) {
L__interruptSPI1134:
; dataSPI start address is: 4 (W2)
L__interruptSPI1133:
;Digitalizador.c,781 :: 		} else if (bandOperacion == 1 && dataSPI == FIN_OBT_OPE) {
	MOV	#lo_addr(_bandOperacion), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1198
	GOTO	L__interruptSPI1136
L__interruptSPI1198:
	MOV.B	#240, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1199
	GOTO	L__interruptSPI1135
L__interruptSPI1199:
; dataSPI end address is: 4 (W2)
L__interruptSPI1131:
;Digitalizador.c,782 :: 		bandOperacion = 0;
	MOV	#lo_addr(_bandOperacion), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,783 :: 		tipoOperacion = 0;
	MOV	#lo_addr(_tipoOperacion), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,784 :: 		}
	GOTO	L_interruptSPI143
;Digitalizador.c,781 :: 		} else if (bandOperacion == 1 && dataSPI == FIN_OBT_OPE) {
L__interruptSPI1136:
; dataSPI start address is: 4 (W2)
L__interruptSPI1135:
;Digitalizador.c,790 :: 		else if (bandTramaRecBytesPorMuestra == 0 && dataSPI == INI_REC_MUES) {
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1200
	GOTO	L__interruptSPI1138
L__interruptSPI1200:
	MOV.B	#163, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1201
	GOTO	L__interruptSPI1137
L__interruptSPI1201:
; dataSPI end address is: 4 (W2)
L__interruptSPI1130:
;Digitalizador.c,792 :: 		bandTramaRecBytesPorMuestra = 1;
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,794 :: 		indiceBytesPorMuestra = 0;
	CLR	W0
	MOV	W0, interruptSPI1_indiceBytesPorMuestra_L0
;Digitalizador.c,798 :: 		if (isLibreVectorData == false) {
	MOV	#lo_addr(_isLibreVectorData), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1202
	GOTO	L_interruptSPI147
L__interruptSPI1202:
;Digitalizador.c,799 :: 		SPI1BUF = vectorData[indiceBytesPorMuestra];
	MOV	#lo_addr(_vectorData), W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,800 :: 		indiceBytesPorMuestra ++;
	MOV	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,801 :: 		}
L_interruptSPI147:
;Digitalizador.c,804 :: 		} else if (bandTramaRecBytesPorMuestra == 1) {
	GOTO	L_interruptSPI148
;Digitalizador.c,790 :: 		else if (bandTramaRecBytesPorMuestra == 0 && dataSPI == INI_REC_MUES) {
L__interruptSPI1138:
; dataSPI start address is: 4 (W2)
L__interruptSPI1137:
;Digitalizador.c,804 :: 		} else if (bandTramaRecBytesPorMuestra == 1) {
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1203
	GOTO	L_interruptSPI149
L__interruptSPI1203:
;Digitalizador.c,806 :: 		if (dataSPI == DUMMY_BYTE) {
	CP.B	W2, #0
	BRA Z	L__interruptSPI1204
	GOTO	L_interruptSPI150
L__interruptSPI1204:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,808 :: 		if (isLibreVectorData == false) {
	MOV	#lo_addr(_isLibreVectorData), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1205
	GOTO	L_interruptSPI151
L__interruptSPI1205:
;Digitalizador.c,809 :: 		SPI1BUF = vectorData[indiceBytesPorMuestra];
	MOV	#lo_addr(_vectorData), W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,810 :: 		indiceBytesPorMuestra ++;
	MOV	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,811 :: 		}
L_interruptSPI151:
;Digitalizador.c,813 :: 		} else if (dataSPI == FIN_REC_MUES) {
	GOTO	L_interruptSPI152
L_interruptSPI150:
; dataSPI start address is: 4 (W2)
	MOV.B	#243, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1206
	GOTO	L_interruptSPI153
L__interruptSPI1206:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,820 :: 		if (indiceBytesPorMuestra > numMuestrasEnvio) {
	MOV	#250, W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	CP	W1, [W0]
	BRA LTU	L__interruptSPI1207
	GOTO	L_interruptSPI154
L__interruptSPI1207:
;Digitalizador.c,821 :: 		isEnviarHoraToRPi = false;
	MOV	#lo_addr(_isEnviarHoraToRPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,822 :: 		}
L_interruptSPI154:
;Digitalizador.c,825 :: 		bandTramaRecBytesPorMuestra = 0;
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,827 :: 		if (isLibreVectorData == false) {
	MOV	#lo_addr(_isLibreVectorData), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1208
	GOTO	L_interruptSPI155
L__interruptSPI1208:
;Digitalizador.c,828 :: 		isLibreVectorData = true;
	MOV	#lo_addr(_isLibreVectorData), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,829 :: 		}
L_interruptSPI155:
;Digitalizador.c,830 :: 		}
L_interruptSPI153:
L_interruptSPI152:
;Digitalizador.c,831 :: 		}
	GOTO	L_interruptSPI156
L_interruptSPI149:
;Digitalizador.c,836 :: 		else if (bandTimeFromRPi == 0 && dataSPI == INI_TIME_FROM_RPI) {
; dataSPI start address is: 4 (W2)
	MOV	#lo_addr(_bandTimeFromRPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1209
	GOTO	L__interruptSPI1140
L__interruptSPI1209:
	MOV.B	#164, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1210
	GOTO	L__interruptSPI1139
L__interruptSPI1210:
; dataSPI end address is: 4 (W2)
L__interruptSPI1129:
;Digitalizador.c,838 :: 		bandTimeFromRPi = 1;
	MOV	#lo_addr(_bandTimeFromRPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,840 :: 		indiceTimeFromRPi = 0;
	MOV	#lo_addr(interruptSPI1_indiceTimeFromRPi_L0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,843 :: 		} else if (bandTimeFromRPi == 1) {
	GOTO	L_interruptSPI160
;Digitalizador.c,836 :: 		else if (bandTimeFromRPi == 0 && dataSPI == INI_TIME_FROM_RPI) {
L__interruptSPI1140:
; dataSPI start address is: 4 (W2)
L__interruptSPI1139:
;Digitalizador.c,843 :: 		} else if (bandTimeFromRPi == 1) {
	MOV	#lo_addr(_bandTimeFromRPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1211
	GOTO	L_interruptSPI161
L__interruptSPI1211:
;Digitalizador.c,846 :: 		if (dataSPI != FIN_TIME_FROM_RPI) {
	MOV.B	#244, W0
	CP.B	W2, W0
	BRA NZ	L__interruptSPI1212
	GOTO	L_interruptSPI162
L__interruptSPI1212:
;Digitalizador.c,847 :: 		vectorBytesTimeRPi[indiceTimeFromRPi] = dataSPI;
	MOV	#lo_addr(interruptSPI1_indiceTimeFromRPi_L0), W0
	ZE	[W0], W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0), W0
	ADD	W0, W1, W0
	MOV.B	W2, [W0]
; dataSPI end address is: 4 (W2)
;Digitalizador.c,848 :: 		indiceTimeFromRPi ++;
	MOV.B	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceTimeFromRPi_L0), W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,850 :: 		} else {
	GOTO	L_interruptSPI163
L_interruptSPI162:
;Digitalizador.c,852 :: 		bandTimeFromRPi = 0;
	MOV	#lo_addr(_bandTimeFromRPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,856 :: 		punteroLong = &fechaLongRPi;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_fechaLongRPi), W2
;Digitalizador.c,858 :: 		*(punteroLong + 3) = vectorBytesTimeRPi[0];
	ADD	W2, #3, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,859 :: 		*(punteroLong + 2) = vectorBytesTimeRPi[1];
	ADD	W2, #2, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+1), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,860 :: 		*(punteroLong + 1) = vectorBytesTimeRPi[2];
	ADD	W2, #1, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+2), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,861 :: 		*(punteroLong) = vectorBytesTimeRPi[3];
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+3), W0
	MOV.B	[W0], [W2]
;Digitalizador.c,865 :: 		punteroLong = &horaLongRPi;
	MOV	#lo_addr(_horaLongRPi), W2
;Digitalizador.c,867 :: 		*(punteroLong + 3) = vectorBytesTimeRPi[4];
	ADD	W2, #3, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+4), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,868 :: 		*(punteroLong + 2) = vectorBytesTimeRPi[5];
	ADD	W2, #2, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+5), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,869 :: 		*(punteroLong + 1) = vectorBytesTimeRPi[6];
	ADD	W2, #1, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+6), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,870 :: 		*(punteroLong) = vectorBytesTimeRPi[7];
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+7), W0
	MOV.B	[W0], [W2]
; punteroLong end address is: 4 (W2)
;Digitalizador.c,874 :: 		if (isGPS_Connected == false) {
	MOV	#lo_addr(_isGPS_Connected), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1213
	GOTO	L_interruptSPI164
L__interruptSPI1213:
;Digitalizador.c,876 :: 		fechaLongSistema = fechaLongRPi;
	MOV	_fechaLongRPi, W0
	MOV	_fechaLongRPi+2, W1
	MOV	W0, _fechaLongSistema
	MOV	W1, _fechaLongSistema+2
;Digitalizador.c,877 :: 		horaLongSistema = horaLongRPi;
	MOV	_horaLongRPi, W0
	MOV	_horaLongRPi+2, W1
	MOV	W0, _horaLongSistema
	MOV	W1, _horaLongSistema+2
;Digitalizador.c,879 :: 		fechaLongRTC = fechaLongRPi;
	MOV	_fechaLongRPi, W0
	MOV	_fechaLongRPi+2, W1
	MOV	W0, _fechaLongRTC
	MOV	W1, _fechaLongRTC+2
;Digitalizador.c,880 :: 		horaLongRTC = horaLongRPi;
	MOV	_horaLongRPi, W0
	MOV	_horaLongRPi+2, W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,882 :: 		isActualizarRTC = true;
	MOV	#lo_addr(_isActualizarRTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,884 :: 		fuenteTiempoSistema = FUENTE_TIME_RTC;
	MOV	#lo_addr(_fuenteTiempoSistema), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Digitalizador.c,885 :: 		}
L_interruptSPI164:
;Digitalizador.c,886 :: 		}
L_interruptSPI163:
;Digitalizador.c,887 :: 		}
	GOTO	L_interruptSPI165
L_interruptSPI161:
;Digitalizador.c,892 :: 		else if (bandTimeFromDSPIC == 0 && dataSPI == INI_TIME_FROM_DSPIC) {
; dataSPI start address is: 4 (W2)
	MOV	#lo_addr(_bandTimeFromDSPIC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1214
	GOTO	L__interruptSPI1142
L__interruptSPI1214:
	MOV.B	#165, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1215
	GOTO	L__interruptSPI1141
L__interruptSPI1215:
; dataSPI end address is: 4 (W2)
L__interruptSPI1128:
;Digitalizador.c,895 :: 		bandTimeFromDSPIC = 1;
	MOV	#lo_addr(_bandTimeFromDSPIC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,897 :: 		indiceTimeFromDSPIC = 0;
	MOV	#lo_addr(interruptSPI1_indiceTimeFromDSPIC_L0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,899 :: 		SPI1BUF = fuenteTiempoSistema;
	MOV	#lo_addr(_fuenteTiempoSistema), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,902 :: 		punteroLong = &fechaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_fechaLongSistema), W2
;Digitalizador.c,904 :: 		vectorTiempoSistema[0] = *(punteroLong + 3);
	ADD	W2, #3, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema), W0
	MOV.B	W1, [W0]
;Digitalizador.c,905 :: 		vectorTiempoSistema[1] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+1), W0
	MOV.B	W1, [W0]
;Digitalizador.c,906 :: 		vectorTiempoSistema[2] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+2), W0
	MOV.B	W1, [W0]
;Digitalizador.c,907 :: 		vectorTiempoSistema[3] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorTiempoSistema+3), W0
	MOV.B	W1, [W0]
;Digitalizador.c,910 :: 		punteroLong = &horaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_horaLongSistema), W2
;Digitalizador.c,911 :: 		vectorTiempoSistema[4] = *(punteroLong + 3);
	ADD	W2, #3, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+4), W0
	MOV.B	W1, [W0]
;Digitalizador.c,912 :: 		vectorTiempoSistema[5] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+5), W0
	MOV.B	W1, [W0]
;Digitalizador.c,913 :: 		vectorTiempoSistema[6] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+6), W0
	MOV.B	W1, [W0]
;Digitalizador.c,914 :: 		vectorTiempoSistema[7] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorTiempoSistema+7), W0
	MOV.B	W1, [W0]
;Digitalizador.c,917 :: 		} else if (bandTimeFromDSPIC == 1) {
	GOTO	L_interruptSPI169
;Digitalizador.c,892 :: 		else if (bandTimeFromDSPIC == 0 && dataSPI == INI_TIME_FROM_DSPIC) {
L__interruptSPI1142:
; dataSPI start address is: 4 (W2)
L__interruptSPI1141:
;Digitalizador.c,917 :: 		} else if (bandTimeFromDSPIC == 1) {
	MOV	#lo_addr(_bandTimeFromDSPIC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1216
	GOTO	L_interruptSPI170
L__interruptSPI1216:
;Digitalizador.c,919 :: 		if (dataSPI == DUMMY_BYTE) {
	CP.B	W2, #0
	BRA Z	L__interruptSPI1217
	GOTO	L_interruptSPI171
L__interruptSPI1217:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,920 :: 		SPI1BUF = vectorTiempoSistema[indiceTimeFromDSPIC];
	MOV	#lo_addr(interruptSPI1_indiceTimeFromDSPIC_L0), W0
	ZE	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,921 :: 		indiceTimeFromDSPIC ++;
	MOV.B	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceTimeFromDSPIC_L0), W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,923 :: 		} else if (dataSPI == FIN_TIME_FROM_DSPIC) {
	GOTO	L_interruptSPI172
L_interruptSPI171:
; dataSPI start address is: 4 (W2)
	MOV.B	#245, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1218
	GOTO	L_interruptSPI173
L__interruptSPI1218:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,924 :: 		bandTimeFromDSPIC = 0;
	MOV	#lo_addr(_bandTimeFromDSPIC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,925 :: 		}
L_interruptSPI173:
L_interruptSPI172:
;Digitalizador.c,926 :: 		}
	GOTO	L_interruptSPI174
L_interruptSPI170:
;Digitalizador.c,931 :: 		else if (bandTramaInitMues == 0 && dataSPI == INI_INIT_MUES) {
; dataSPI start address is: 4 (W2)
	MOV	#lo_addr(_bandTramaInitMues), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1219
	GOTO	L__interruptSPI1144
L__interruptSPI1219:
	MOV.B	#161, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1220
	GOTO	L__interruptSPI1143
L__interruptSPI1220:
; dataSPI end address is: 4 (W2)
L__interruptSPI1127:
;Digitalizador.c,933 :: 		bandTramaInitMues = 1;
	MOV	#lo_addr(_bandTramaInitMues), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,936 :: 		isComienzoMuestreo = true;
	MOV	#lo_addr(_isComienzoMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,939 :: 		} else if (bandTramaInitMues == 1) {
	GOTO	L_interruptSPI178
;Digitalizador.c,931 :: 		else if (bandTramaInitMues == 0 && dataSPI == INI_INIT_MUES) {
L__interruptSPI1144:
L__interruptSPI1143:
;Digitalizador.c,939 :: 		} else if (bandTramaInitMues == 1) {
	MOV	#lo_addr(_bandTramaInitMues), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1221
	GOTO	L_interruptSPI179
L__interruptSPI1221:
;Digitalizador.c,940 :: 		bandTramaInitMues = 0;
	MOV	#lo_addr(_bandTramaInitMues), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,941 :: 		}
L_interruptSPI179:
L_interruptSPI178:
L_interruptSPI174:
L_interruptSPI169:
L_interruptSPI165:
L_interruptSPI160:
L_interruptSPI156:
L_interruptSPI148:
L_interruptSPI143:
L_interruptSPI139:
;Digitalizador.c,943 :: 		}
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

;Digitalizador.c,954 :: 		void ExternalInterrupt0_GPS() org IVT_ADDR_INT0INTERRUPT{
;Digitalizador.c,956 :: 		INT0IF_bit = 0;
	BCLR	INT0IF_bit, BitPos(INT0IF_bit+0)
;Digitalizador.c,960 :: 		if (isPPS_GPS == false) {
	MOV	#lo_addr(_isPPS_GPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt0_GPS223
	GOTO	L_ExternalInterrupt0_GPS80
L__ExternalInterrupt0_GPS223:
;Digitalizador.c,961 :: 		isPPS_GPS = true;
	MOV	#lo_addr(_isPPS_GPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,964 :: 		if (isGPS_Connected == false && isComuGPS == true) {
	MOV	#lo_addr(_isGPS_Connected), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt0_GPS224
	GOTO	L__ExternalInterrupt0_GPS147
L__ExternalInterrupt0_GPS224:
	MOV	#lo_addr(_isComuGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt0_GPS225
	GOTO	L__ExternalInterrupt0_GPS146
L__ExternalInterrupt0_GPS225:
L__ExternalInterrupt0_GPS145:
;Digitalizador.c,965 :: 		isGPS_Connected = true;
	MOV	#lo_addr(_isGPS_Connected), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,967 :: 		isEnviarGPSOk = true;
	MOV	#lo_addr(_isEnviarGPSOk), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,969 :: 		fuenteTiempoSistema = FUENTE_TIME_GPS;
	MOV	#lo_addr(_fuenteTiempoSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,964 :: 		if (isGPS_Connected == false && isComuGPS == true) {
L__ExternalInterrupt0_GPS147:
L__ExternalInterrupt0_GPS146:
;Digitalizador.c,971 :: 		}
L_ExternalInterrupt0_GPS80:
;Digitalizador.c,977 :: 		if (isRecTiempoGPS == true) {
	MOV	#lo_addr(_isRecTiempoGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt0_GPS226
	GOTO	L_ExternalInterrupt0_GPS84
L__ExternalInterrupt0_GPS226:
;Digitalizador.c,979 :: 		isRecTiempoGPS = false;
	MOV	#lo_addr(_isRecTiempoGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,982 :: 		horaLongSistema = horaLongGPS;
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	MOV	W0, _horaLongSistema
	MOV	W1, _horaLongSistema+2
;Digitalizador.c,983 :: 		fechaLongSistema = fechaLongGPS;
	MOV	_fechaLongGPS, W0
	MOV	_fechaLongGPS+2, W1
	MOV	W0, _fechaLongSistema
	MOV	W1, _fechaLongSistema+2
;Digitalizador.c,985 :: 		fuenteTiempoSistema = FUENTE_TIME_GPS;
	MOV	#lo_addr(_fuenteTiempoSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,988 :: 		} else {
	GOTO	L_ExternalInterrupt0_GPS85
L_ExternalInterrupt0_GPS84:
;Digitalizador.c,990 :: 		horaLongGPS ++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaLongGPS), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;Digitalizador.c,991 :: 		}
L_ExternalInterrupt0_GPS85:
;Digitalizador.c,994 :: 		if (horaLongGPS == 86400) {
	MOV	_horaLongGPS, W2
	MOV	_horaLongGPS+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__ExternalInterrupt0_GPS227
	GOTO	L_ExternalInterrupt0_GPS86
L__ExternalInterrupt0_GPS227:
;Digitalizador.c,995 :: 		horaLongGPS = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaLongGPS
	MOV	W1, _horaLongGPS+2
;Digitalizador.c,996 :: 		}
L_ExternalInterrupt0_GPS86:
;Digitalizador.c,997 :: 		}
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

;Digitalizador.c,1009 :: 		void ExternalInterrupt2_RTC() org IVT_ADDR_INT2INTERRUPT{
;Digitalizador.c,1011 :: 		INT2IF_bit = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT2IF_bit, BitPos(INT2IF_bit+0)
;Digitalizador.c,1013 :: 		LED_2 = ~LED_2;
	BTG	LATD0_bit, BitPos(LATD0_bit+0)
;Digitalizador.c,1018 :: 		if (isActualizarRTC == true) {
	MOV	#lo_addr(_isActualizarRTC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC229
	GOTO	L_ExternalInterrupt2_RTC87
L__ExternalInterrupt2_RTC229:
;Digitalizador.c,1019 :: 		isActualizarRTC = false;
	MOV	#lo_addr(_isActualizarRTC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1022 :: 		PasarTiempoToVector(horaLongRTC, fechaLongRTC, vectorTiempoRTC);
	MOV	_fechaLongRTC, W12
	MOV	_fechaLongRTC+2, W13
	MOV	_horaLongRTC, W10
	MOV	_horaLongRTC+2, W11
	MOV	#lo_addr(_vectorTiempoRTC), W0
	PUSH	W0
	CALL	_PasarTiempoToVector
	SUB	#2, W15
;Digitalizador.c,1033 :: 		} else {
	GOTO	L_ExternalInterrupt2_RTC88
L_ExternalInterrupt2_RTC87:
;Digitalizador.c,1035 :: 		horaLongRTC ++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaLongRTC), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;Digitalizador.c,1036 :: 		}
L_ExternalInterrupt2_RTC88:
;Digitalizador.c,1039 :: 		if (horaLongRTC == 86400) {
	MOV	_horaLongRTC, W2
	MOV	_horaLongRTC+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__ExternalInterrupt2_RTC230
	GOTO	L_ExternalInterrupt2_RTC89
L__ExternalInterrupt2_RTC230:
;Digitalizador.c,1040 :: 		horaLongRTC = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,1041 :: 		}
L_ExternalInterrupt2_RTC89:
;Digitalizador.c,1048 :: 		if (horaLongGPS == 86390 && fuenteTiempoSistema == FUENTE_TIME_GPS) {
	MOV	_horaLongGPS, W2
	MOV	_horaLongGPS+2, W3
	MOV	#20854, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__ExternalInterrupt2_RTC231
	GOTO	L__ExternalInterrupt2_RTC152
L__ExternalInterrupt2_RTC231:
	MOV	#lo_addr(_fuenteTiempoSistema), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC232
	GOTO	L__ExternalInterrupt2_RTC151
L__ExternalInterrupt2_RTC232:
L__ExternalInterrupt2_RTC150:
;Digitalizador.c,1050 :: 		U1RXIE_bit = 1;
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,1048 :: 		if (horaLongGPS == 86390 && fuenteTiempoSistema == FUENTE_TIME_GPS) {
L__ExternalInterrupt2_RTC152:
L__ExternalInterrupt2_RTC151:
;Digitalizador.c,1054 :: 		horaLongSistema = horaLongRTC;
	MOV	_horaLongRTC, W0
	MOV	_horaLongRTC+2, W1
	MOV	W0, _horaLongSistema
	MOV	W1, _horaLongSistema+2
;Digitalizador.c,1057 :: 		if (isComienzoMuestreo == true) {
	MOV	#lo_addr(_isComienzoMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC233
	GOTO	L_ExternalInterrupt2_RTC93
L__ExternalInterrupt2_RTC233:
;Digitalizador.c,1059 :: 		if (isMuestreando == false && (horaLongRTC % 60) == 0) {
	MOV	#lo_addr(_isMuestreando), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt2_RTC234
	GOTO	L__ExternalInterrupt2_RTC154
L__ExternalInterrupt2_RTC234:
	MOV	#60, W2
	MOV	#0, W3
	MOV	_horaLongRTC, W0
	MOV	_horaLongRTC+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__ExternalInterrupt2_RTC235
	GOTO	L__ExternalInterrupt2_RTC153
L__ExternalInterrupt2_RTC235:
L__ExternalInterrupt2_RTC149:
;Digitalizador.c,1060 :: 		isMuestreando = true;
	MOV	#lo_addr(_isMuestreando), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1062 :: 		isComienzoMuestreo = false;
	MOV	#lo_addr(_isComienzoMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1065 :: 		isPrimeraVezMuestreo = true;
	MOV	#lo_addr(_isPrimeraVezMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1059 :: 		if (isMuestreando == false && (horaLongRTC % 60) == 0) {
L__ExternalInterrupt2_RTC154:
L__ExternalInterrupt2_RTC153:
;Digitalizador.c,1067 :: 		}
L_ExternalInterrupt2_RTC93:
;Digitalizador.c,1070 :: 		if (isMuestreando == true) {
	MOV	#lo_addr(_isMuestreando), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC236
	GOTO	L_ExternalInterrupt2_RTC97
L__ExternalInterrupt2_RTC236:
;Digitalizador.c,1073 :: 		if ((horaLongRTC % 60) == 0 && isPrimeraVezMuestreo == false) {
	MOV	#60, W2
	MOV	#0, W3
	MOV	_horaLongRTC, W0
	MOV	_horaLongRTC+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__ExternalInterrupt2_RTC237
	GOTO	L__ExternalInterrupt2_RTC156
L__ExternalInterrupt2_RTC237:
	MOV	#lo_addr(_isPrimeraVezMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt2_RTC238
	GOTO	L__ExternalInterrupt2_RTC155
L__ExternalInterrupt2_RTC238:
L__ExternalInterrupt2_RTC148:
;Digitalizador.c,1074 :: 		isEnviarHoraToRPi = true;
	MOV	#lo_addr(_isEnviarHoraToRPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1073 :: 		if ((horaLongRTC % 60) == 0 && isPrimeraVezMuestreo == false) {
L__ExternalInterrupt2_RTC156:
L__ExternalInterrupt2_RTC155:
;Digitalizador.c,1081 :: 		if (TON_T3CON_bit == 0) {
	BTSC	TON_T3CON_bit, BitPos(TON_T3CON_bit+0)
	GOTO	L_ExternalInterrupt2_RTC101
;Digitalizador.c,1082 :: 		TON_T3CON_bit = 1;
	BSET	TON_T3CON_bit, BitPos(TON_T3CON_bit+0)
;Digitalizador.c,1083 :: 		}
L_ExternalInterrupt2_RTC101:
;Digitalizador.c,1085 :: 		TMR3 = 0;
	CLR	TMR3
;Digitalizador.c,1088 :: 		T3IF_bit = 1;
	BSET	T3IF_bit, BitPos(T3IF_bit+0)
;Digitalizador.c,1089 :: 		}
L_ExternalInterrupt2_RTC97:
;Digitalizador.c,1090 :: 		}
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

;Digitalizador.c,1099 :: 		void interruptU1RX() iv IVT_ADDR_U1RXINTERRUPT {
;Digitalizador.c,1103 :: 		U1RXIF_bit = 0;
	PUSH	W10
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;Digitalizador.c,1105 :: 		byteGPS = U1RXREG;                                                                                                                                                                                                                                       //Lee el byte de la trama enviada por el GPS
; byteGPS start address is: 4 (W2)
	MOV	U1RXREG, W2
;Digitalizador.c,1107 :: 		OERR_bit = 0;
	BCLR	OERR_bit, BitPos(OERR_bit+0)
;Digitalizador.c,1109 :: 		if (banTIGPS == 0){
	MOV	#lo_addr(_banTIGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptU1RX240
	GOTO	L_interruptU1RX102
L__interruptU1RX240:
;Digitalizador.c,1112 :: 		if ((byteGPS == 0x24) && (indice_gps == 0)){
	MOV.B	#36, W0
	CP.B	W2, W0
	BRA Z	L__interruptU1RX241
	GOTO	L__interruptU1RX160
L__interruptU1RX241:
	MOV	_indice_gps, W0
	CP	W0, #0
	BRA Z	L__interruptU1RX242
	GOTO	L__interruptU1RX159
L__interruptU1RX242:
L__interruptU1RX158:
;Digitalizador.c,1114 :: 		banTIGPS = 1;
	MOV	#lo_addr(_banTIGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1112 :: 		if ((byteGPS == 0x24) && (indice_gps == 0)){
L__interruptU1RX160:
L__interruptU1RX159:
;Digitalizador.c,1116 :: 		}
L_interruptU1RX102:
;Digitalizador.c,1118 :: 		if (banTIGPS == 1){
	MOV	#lo_addr(_banTIGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptU1RX243
	GOTO	L_interruptU1RX106
L__interruptU1RX243:
;Digitalizador.c,1121 :: 		if (byteGPS != 0x2A){
	MOV.B	#42, W0
	CP.B	W2, W0
	BRA NZ	L__interruptU1RX244
	GOTO	L_interruptU1RX107
L__interruptU1RX244:
;Digitalizador.c,1123 :: 		tramaGPS[indice_gps] = byteGPS;
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_indice_gps), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
; byteGPS end address is: 4 (W2)
;Digitalizador.c,1125 :: 		if (indice_gps < 70){
	MOV	#70, W1
	MOV	#lo_addr(_indice_gps), W0
	CP	W1, [W0]
	BRA GTU	L__interruptU1RX245
	GOTO	L_interruptU1RX108
L__interruptU1RX245:
;Digitalizador.c,1126 :: 		indice_gps ++;
	MOV	#1, W1
	MOV	#lo_addr(_indice_gps), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,1127 :: 		}
L_interruptU1RX108:
;Digitalizador.c,1132 :: 		if ((indice_gps > 5) && (tramaGPS[1] != 0x47) && (tramaGPS[2] != 0x50)  && (tramaGPS[3] != 0x52)  && (tramaGPS[4] != 0x4D)  && (tramaGPS[5] != 0x43)) {
	MOV	_indice_gps, W0
	CP	W0, #5
	BRA GTU	L__interruptU1RX246
	GOTO	L__interruptU1RX166
L__interruptU1RX246:
	MOV	#lo_addr(_tramaGPS+1), W0
	MOV.B	[W0], W1
	MOV.B	#71, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX247
	GOTO	L__interruptU1RX165
L__interruptU1RX247:
	MOV	#lo_addr(_tramaGPS+2), W0
	MOV.B	[W0], W1
	MOV.B	#80, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX248
	GOTO	L__interruptU1RX164
L__interruptU1RX248:
	MOV	#lo_addr(_tramaGPS+3), W0
	MOV.B	[W0], W1
	MOV.B	#82, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX249
	GOTO	L__interruptU1RX163
L__interruptU1RX249:
	MOV	#lo_addr(_tramaGPS+4), W0
	MOV.B	[W0], W1
	MOV.B	#77, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX250
	GOTO	L__interruptU1RX162
L__interruptU1RX250:
	MOV	#lo_addr(_tramaGPS+5), W0
	MOV.B	[W0], W1
	MOV.B	#67, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX251
	GOTO	L__interruptU1RX161
L__interruptU1RX251:
L__interruptU1RX157:
;Digitalizador.c,1134 :: 		indice_gps = 0;
	CLR	W0
	MOV	W0, _indice_gps
;Digitalizador.c,1136 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1138 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1132 :: 		if ((indice_gps > 5) && (tramaGPS[1] != 0x47) && (tramaGPS[2] != 0x50)  && (tramaGPS[3] != 0x52)  && (tramaGPS[4] != 0x4D)  && (tramaGPS[5] != 0x43)) {
L__interruptU1RX166:
L__interruptU1RX165:
L__interruptU1RX164:
L__interruptU1RX163:
L__interruptU1RX162:
L__interruptU1RX161:
;Digitalizador.c,1141 :: 		} else {
	GOTO	L_interruptU1RX112
L_interruptU1RX107:
;Digitalizador.c,1142 :: 		tramaGPS[indice_gps] = byteGPS;
; byteGPS start address is: 4 (W2)
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_indice_gps), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
; byteGPS end address is: 4 (W2)
;Digitalizador.c,1145 :: 		banTIGPS = 2;
	MOV	#lo_addr(_banTIGPS), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1147 :: 		banTCGPS = 1;
	MOV	#lo_addr(_banTCGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1148 :: 		}
L_interruptU1RX112:
;Digitalizador.c,1149 :: 		}
L_interruptU1RX106:
;Digitalizador.c,1153 :: 		if (banTCGPS == 1) {
	MOV	#lo_addr(_banTCGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptU1RX252
	GOTO	L_interruptU1RX113
L__interruptU1RX252:
;Digitalizador.c,1156 :: 		if (tramaGPS[18] == 0x41) {
	MOV	#lo_addr(_tramaGPS+18), W0
	MOV.B	[W0], W1
	MOV.B	#65, W0
	CP.B	W1, W0
	BRA Z	L__interruptU1RX253
	GOTO	L_interruptU1RX114
L__interruptU1RX253:
;Digitalizador.c,1161 :: 		for (indiceU1RX_1 = 0; indiceU1RX_1 < 6; indiceU1RX_1++){
; indiceU1RX_1 start address is: 6 (W3)
	CLR	W3
; indiceU1RX_1 end address is: 6 (W3)
L_interruptU1RX115:
; indiceU1RX_1 start address is: 6 (W3)
	CP.B	W3, #6
	BRA LTU	L__interruptU1RX254
	GOTO	L_interruptU1RX116
L__interruptU1RX254:
;Digitalizador.c,1163 :: 		datosGPS[indiceU1RX_1] = tramaGPS[7+indiceU1RX_1];
	ZE	W3, W1
	MOV	#lo_addr(_datosGPS), W0
	ADD	W0, W1, W2
	ZE	W3, W0
	ADD	W0, #7, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Digitalizador.c,1161 :: 		for (indiceU1RX_1 = 0; indiceU1RX_1 < 6; indiceU1RX_1++){
	INC.B	W3
;Digitalizador.c,1164 :: 		}
; indiceU1RX_1 end address is: 6 (W3)
	GOTO	L_interruptU1RX115
L_interruptU1RX116:
;Digitalizador.c,1166 :: 		for (indiceU1RX_1 = 50; indiceU1RX_1 < 60; indiceU1RX_1++){
; indiceU1RX_1 start address is: 6 (W3)
	MOV.B	#50, W3
; indiceU1RX_1 end address is: 6 (W3)
L_interruptU1RX118:
; indiceU1RX_1 start address is: 6 (W3)
	MOV.B	#60, W0
	CP.B	W3, W0
	BRA LTU	L__interruptU1RX255
	GOTO	L_interruptU1RX119
L__interruptU1RX255:
;Digitalizador.c,1169 :: 		if (tramaGPS[indiceU1RX_1] == 0x2C){
	ZE	W3, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#44, W0
	CP.B	W1, W0
	BRA Z	L__interruptU1RX256
	GOTO	L__interruptU1RX167
L__interruptU1RX256:
;Digitalizador.c,1171 :: 		for (indiceU1RX_2 = 0; indiceU1RX_2 < 6; indiceU1RX_2++){
	CLR	W0
	MOV.B	W0, [W14+0]
; indiceU1RX_1 end address is: 6 (W3)
L_interruptU1RX122:
; indiceU1RX_1 start address is: 6 (W3)
	MOV.B	[W14+0], W0
	CP.B	W0, #6
	BRA LTU	L__interruptU1RX257
	GOTO	L_interruptU1RX123
L__interruptU1RX257:
;Digitalizador.c,1172 :: 		datosGPS[6 + indiceU1RX_2] = tramaGPS[indiceU1RX_1 + indiceU1RX_2 + 1];
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
;Digitalizador.c,1171 :: 		for (indiceU1RX_2 = 0; indiceU1RX_2 < 6; indiceU1RX_2++){
	MOV.B	#1, W1
	ADD	W14, #0, W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,1173 :: 		}
	GOTO	L_interruptU1RX122
L_interruptU1RX123:
;Digitalizador.c,1174 :: 		}
	MOV.B	W3, W0
	GOTO	L_interruptU1RX121
; indiceU1RX_1 end address is: 6 (W3)
L__interruptU1RX167:
;Digitalizador.c,1169 :: 		if (tramaGPS[indiceU1RX_1] == 0x2C){
	MOV.B	W3, W0
;Digitalizador.c,1174 :: 		}
L_interruptU1RX121:
;Digitalizador.c,1166 :: 		for (indiceU1RX_1 = 50; indiceU1RX_1 < 60; indiceU1RX_1++){
; indiceU1RX_1 start address is: 0 (W0)
; indiceU1RX_1 start address is: 6 (W3)
	ADD.B	W0, #1, W3
; indiceU1RX_1 end address is: 0 (W0)
;Digitalizador.c,1175 :: 		}
; indiceU1RX_1 end address is: 6 (W3)
	GOTO	L_interruptU1RX118
L_interruptU1RX119:
;Digitalizador.c,1178 :: 		horaLongGPS = RecuperarHoraGPS(datosGPS);
	MOV	#lo_addr(_datosGPS), W10
	CALL	_RecuperarHoraGPS
	MOV	W0, _horaLongGPS
	MOV	W1, _horaLongGPS+2
;Digitalizador.c,1179 :: 		fechaLongGPS = RecuperarFechaGPS(datosGPS);
	MOV	#lo_addr(_datosGPS), W10
	CALL	_RecuperarFechaGPS
	MOV	W0, _fechaLongGPS
	MOV	W1, _fechaLongGPS+2
;Digitalizador.c,1183 :: 		if (isComuGPS == false) {
	MOV	#lo_addr(_isComuGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptU1RX258
	GOTO	L_interruptU1RX125
L__interruptU1RX258:
;Digitalizador.c,1184 :: 		isComuGPS = true;
	MOV	#lo_addr(_isComuGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1189 :: 		isRecTiempoGPS = true;
	MOV	#lo_addr(_isRecTiempoGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1207 :: 		horaLongRTC = horaLongGPS;
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,1208 :: 		fechaLongRTC = fechaLongGPS;
	MOV	_fechaLongGPS, W0
	MOV	_fechaLongGPS+2, W1
	MOV	W0, _fechaLongRTC
	MOV	W1, _fechaLongRTC+2
;Digitalizador.c,1209 :: 		isActualizarRTC = true;
	MOV	#lo_addr(_isActualizarRTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1212 :: 		U1RXIE_bit = 0;
	BCLR	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,1213 :: 		}
L_interruptU1RX125:
;Digitalizador.c,1217 :: 		if ((horaLongGPS % 3600) == 0) {
	MOV	#3600, W2
	MOV	#0, W3
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__interruptU1RX259
	GOTO	L_interruptU1RX126
L__interruptU1RX259:
;Digitalizador.c,1218 :: 		LED = ~LED;
	BTG	LATB0_bit, BitPos(LATB0_bit+0)
;Digitalizador.c,1223 :: 		isRecTiempoGPS = true;
	MOV	#lo_addr(_isRecTiempoGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1234 :: 		horaLongRTC = horaLongGPS;
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,1235 :: 		fechaLongRTC = fechaLongGPS;
	MOV	_fechaLongGPS, W0
	MOV	_fechaLongGPS+2, W1
	MOV	W0, _fechaLongRTC
	MOV	W1, _fechaLongRTC+2
;Digitalizador.c,1236 :: 		isActualizarRTC = true;
	MOV	#lo_addr(_isActualizarRTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1239 :: 		U1RXIE_bit = 0;
	BCLR	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,1240 :: 		}
L_interruptU1RX126:
;Digitalizador.c,1241 :: 		}
L_interruptU1RX114:
;Digitalizador.c,1244 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1245 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1246 :: 		indice_gps = 0;
	CLR	W0
	MOV	W0, _indice_gps
;Digitalizador.c,1247 :: 		}
L_interruptU1RX113:
;Digitalizador.c,1248 :: 		}
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
