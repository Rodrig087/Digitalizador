
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

;ds3231_functions.c,122 :: 		uint8_t bcd_to_decimal(uint8_t number)
;ds3231_functions.c,124 :: 		return ( (number >> 4) * 10 + (number & 0x0F) );
	ZE	W10, W0
	LSR	W0, #4, W0
	ZE	W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W2
	ZE	W10, W0
	AND	W0, #15, W0
	ADD	W2, W0, W0
;ds3231_functions.c,125 :: 		}
L_end_bcd_to_decimal:
	RETURN
; end of _bcd_to_decimal

_decimal_to_bcd:
	LNK	#2

;ds3231_functions.c,128 :: 		uint8_t decimal_to_bcd(uint8_t number)
;ds3231_functions.c,130 :: 		return ( ((number / 10) << 4) + (number % 10) );
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
;ds3231_functions.c,131 :: 		}
L_end_decimal_to_bcd:
	ULNK
	RETURN
; end of _decimal_to_bcd

_RTC_Set:
	LNK	#2

;ds3231_functions.c,134 :: 		void RTC_Set(RTC_Time *time_t)
;ds3231_functions.c,137 :: 		time_t->day     = decimal_to_bcd(time_t->day);
	PUSH	W10
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_decimal_to_bcd
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;ds3231_functions.c,138 :: 		time_t->month   = decimal_to_bcd(time_t->month);
	ADD	W10, #5, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_decimal_to_bcd
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;ds3231_functions.c,139 :: 		time_t->year    = decimal_to_bcd(time_t->year);
	ADD	W10, #6, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_decimal_to_bcd
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;ds3231_functions.c,140 :: 		time_t->hours   = decimal_to_bcd(time_t->hours);
	ADD	W10, #2, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_decimal_to_bcd
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;ds3231_functions.c,141 :: 		time_t->minutes = decimal_to_bcd(time_t->minutes);
	ADD	W10, #1, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_decimal_to_bcd
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;ds3231_functions.c,142 :: 		time_t->seconds = decimal_to_bcd(time_t->seconds);
	MOV	W10, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV.B	[W10], W10
	CALL	_decimal_to_bcd
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;ds3231_functions.c,146 :: 		RTC_I2C_START();
	CALL	_Soft_I2C_Start
;ds3231_functions.c,147 :: 		RTC_I2C_WRITE(DS3231_ADDRESS);
	PUSH	W10
	MOV.B	#208, W10
	CALL	_Soft_I2C_Write
;ds3231_functions.c,148 :: 		RTC_I2C_WRITE(DS3231_REG_SECONDS);
	CLR	W10
	CALL	_Soft_I2C_Write
	POP	W10
;ds3231_functions.c,149 :: 		RTC_I2C_WRITE(time_t->seconds);
	PUSH	W10
	MOV.B	[W10], W10
	CALL	_Soft_I2C_Write
	POP	W10
;ds3231_functions.c,150 :: 		RTC_I2C_WRITE(time_t->minutes);
	ADD	W10, #1, W0
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
	POP	W10
;ds3231_functions.c,151 :: 		RTC_I2C_WRITE(time_t->hours);
	ADD	W10, #2, W0
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
	POP	W10
;ds3231_functions.c,152 :: 		RTC_I2C_WRITE(time_t->dow);
	ADD	W10, #3, W0
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
	POP	W10
;ds3231_functions.c,153 :: 		RTC_I2C_WRITE(time_t->day);
	ADD	W10, #4, W0
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
	POP	W10
;ds3231_functions.c,154 :: 		RTC_I2C_WRITE(time_t->month);
	ADD	W10, #5, W0
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
	POP	W10
;ds3231_functions.c,155 :: 		RTC_I2C_WRITE(time_t->year);
	ADD	W10, #6, W0
	MOV.B	[W0], W10
	CALL	_Soft_I2C_Write
;ds3231_functions.c,156 :: 		RTC_I2C_STOP();
	CALL	_Soft_I2C_Stop
;ds3231_functions.c,157 :: 		}
L_end_RTC_Set:
	POP	W10
	ULNK
	RETURN
; end of _RTC_Set

_RTC_Get:

;ds3231_functions.c,160 :: 		RTC_Time *RTC_Get()
;ds3231_functions.c,162 :: 		RTC_I2C_START();
	PUSH	W10
	CALL	_Soft_I2C_Start
;ds3231_functions.c,163 :: 		RTC_I2C_WRITE(DS3231_ADDRESS);
	MOV.B	#208, W10
	CALL	_Soft_I2C_Write
;ds3231_functions.c,164 :: 		RTC_I2C_WRITE(DS3231_REG_SECONDS);
	CLR	W10
	CALL	_Soft_I2C_Write
;ds3231_functions.c,165 :: 		RTC_I2C_RESTART();
	CALL	_Soft_I2C_Start
;ds3231_functions.c,166 :: 		RTC_I2C_WRITE(DS3231_ADDRESS | 0x01);
	MOV.B	#209, W10
	CALL	_Soft_I2C_Write
;ds3231_functions.c,167 :: 		c_time.seconds = RTC_I2C_READ(1);
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	#lo_addr(_c_time), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,168 :: 		c_time.minutes = RTC_I2C_READ(1);
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	#lo_addr(_c_time+1), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,169 :: 		c_time.hours   = RTC_I2C_READ(1);
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	#lo_addr(_c_time+2), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,170 :: 		c_time.dow   = RTC_I2C_READ(1);
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	#lo_addr(_c_time+3), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,171 :: 		c_time.day   = RTC_I2C_READ(1);
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	#lo_addr(_c_time+4), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,172 :: 		c_time.month = RTC_I2C_READ(1);
	MOV	#1, W10
	CALL	_Soft_I2C_Read
	MOV	#lo_addr(_c_time+5), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,173 :: 		c_time.year  = RTC_I2C_READ(0);
	CLR	W10
	CALL	_Soft_I2C_Read
	MOV	#lo_addr(_c_time+6), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,174 :: 		RTC_I2C_STOP();
	CALL	_Soft_I2C_Stop
;ds3231_functions.c,177 :: 		c_time.seconds = bcd_to_decimal(c_time.seconds);
	MOV	#lo_addr(_c_time), W0
	MOV.B	[W0], W10
	CALL	_bcd_to_decimal
	MOV	#lo_addr(_c_time), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,178 :: 		c_time.minutes = bcd_to_decimal(c_time.minutes);
	MOV	#lo_addr(_c_time+1), W0
	MOV.B	[W0], W10
	CALL	_bcd_to_decimal
	MOV	#lo_addr(_c_time+1), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,179 :: 		c_time.hours   = bcd_to_decimal(c_time.hours);
	MOV	#lo_addr(_c_time+2), W0
	MOV.B	[W0], W10
	CALL	_bcd_to_decimal
	MOV	#lo_addr(_c_time+2), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,180 :: 		c_time.day     = bcd_to_decimal(c_time.day);
	MOV	#lo_addr(_c_time+4), W0
	MOV.B	[W0], W10
	CALL	_bcd_to_decimal
	MOV	#lo_addr(_c_time+4), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,181 :: 		c_time.month   = bcd_to_decimal(c_time.month);
	MOV	#lo_addr(_c_time+5), W0
	MOV.B	[W0], W10
	CALL	_bcd_to_decimal
	MOV	#lo_addr(_c_time+5), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,182 :: 		c_time.year    = bcd_to_decimal(c_time.year);
	MOV	#lo_addr(_c_time+6), W0
	MOV.B	[W0], W10
	CALL	_bcd_to_decimal
	MOV	#lo_addr(_c_time+6), W1
	MOV.B	W0, [W1]
;ds3231_functions.c,185 :: 		return &c_time;
	MOV	#lo_addr(_c_time), W0
;ds3231_functions.c,186 :: 		}
;ds3231_functions.c,185 :: 		return &c_time;
;ds3231_functions.c,186 :: 		}
L_end_RTC_Get:
	POP	W10
	RETURN
; end of _RTC_Get

_RTC_Write_Reg:

;ds3231_functions.c,190 :: 		void RTC_Write_Reg(uint8_t reg_address, uint8_t reg_value)
;ds3231_functions.c,192 :: 		RTC_I2C_START();
	PUSH	W10
	CALL	_Soft_I2C_Start
;ds3231_functions.c,193 :: 		RTC_I2C_WRITE(DS3231_ADDRESS);
	PUSH	W10
	MOV.B	#208, W10
	CALL	_Soft_I2C_Write
	POP	W10
;ds3231_functions.c,194 :: 		RTC_I2C_WRITE(reg_address);
	CALL	_Soft_I2C_Write
;ds3231_functions.c,195 :: 		RTC_I2C_WRITE(reg_value);
	MOV.B	W11, W10
	CALL	_Soft_I2C_Write
;ds3231_functions.c,196 :: 		RTC_I2C_STOP();
	CALL	_Soft_I2C_Stop
;ds3231_functions.c,197 :: 		}
L_end_RTC_Write_Reg:
	POP	W10
	RETURN
; end of _RTC_Write_Reg

_RTC_Read_Reg:

;ds3231_functions.c,200 :: 		uint8_t RTC_Read_Reg(uint8_t reg_address)
;ds3231_functions.c,204 :: 		RTC_I2C_START();
	PUSH	W10
	CALL	_Soft_I2C_Start
;ds3231_functions.c,205 :: 		RTC_I2C_WRITE(DS3231_ADDRESS);
	PUSH	W10
	MOV.B	#208, W10
	CALL	_Soft_I2C_Write
	POP	W10
;ds3231_functions.c,206 :: 		RTC_I2C_WRITE(reg_address);
	CALL	_Soft_I2C_Write
;ds3231_functions.c,207 :: 		RTC_I2C_RESTART();
	CALL	_Soft_I2C_Start
;ds3231_functions.c,208 :: 		RTC_I2C_WRITE(DS3231_ADDRESS | 0x01);
	MOV.B	#209, W10
	CALL	_Soft_I2C_Write
;ds3231_functions.c,209 :: 		reg_data = RTC_I2C_READ(0);
	CLR	W10
	CALL	_Soft_I2C_Read
; reg_data start address is: 2 (W1)
	MOV.B	W0, W1
;ds3231_functions.c,210 :: 		RTC_I2C_STOP();
	CALL	_Soft_I2C_Stop
;ds3231_functions.c,212 :: 		return reg_data;
	MOV.B	W1, W0
; reg_data end address is: 2 (W1)
;ds3231_functions.c,213 :: 		}
;ds3231_functions.c,212 :: 		return reg_data;
;ds3231_functions.c,213 :: 		}
L_end_RTC_Read_Reg:
	POP	W10
	RETURN
; end of _RTC_Read_Reg

_IntSqw_Set:

;ds3231_functions.c,216 :: 		void IntSqw_Set(INT_SQW _config)
;ds3231_functions.c,218 :: 		uint8_t ctrl_reg = RTC_Read_Reg(DS3231_REG_CONTROL);
	PUSH	W10
	PUSH	W11
	PUSH	W10
	MOV.B	#14, W10
	CALL	_RTC_Read_Reg
	POP	W10
;ds3231_functions.c,219 :: 		ctrl_reg &= 0xA3;
	ZE	W0, W1
	MOV	#163, W0
	AND	W1, W0, W0
;ds3231_functions.c,220 :: 		ctrl_reg |= _config;
	ZE	W0, W1
	ZE	W10, W0
	IOR	W1, W0, W0
;ds3231_functions.c,221 :: 		RTC_Write_Reg(DS3231_REG_CONTROL, ctrl_reg);
	MOV.B	W0, W11
	MOV.B	#14, W10
	CALL	_RTC_Write_Reg
;ds3231_functions.c,222 :: 		}
L_end_IntSqw_Set:
	POP	W11
	POP	W10
	RETURN
; end of _IntSqw_Set

_Enable_32kHZ:

;ds3231_functions.c,225 :: 		void Enable_32kHZ()
;ds3231_functions.c,227 :: 		uint8_t stat_reg = RTC_Read_Reg(DS3231_REG_STATUS);
	PUSH	W10
	PUSH	W11
	MOV.B	#15, W10
	CALL	_RTC_Read_Reg
;ds3231_functions.c,228 :: 		stat_reg |= 0x08;
	ZE	W0, W0
	IOR	W0, #8, W0
;ds3231_functions.c,229 :: 		RTC_Write_Reg(DS3231_REG_STATUS, stat_reg);
	MOV.B	W0, W11
	MOV.B	#15, W10
	CALL	_RTC_Write_Reg
;ds3231_functions.c,230 :: 		}
L_end_Enable_32kHZ:
	POP	W11
	POP	W10
	RETURN
; end of _Enable_32kHZ

_Disable_32kHZ:

;ds3231_functions.c,233 :: 		void Disable_32kHZ()
;ds3231_functions.c,235 :: 		uint8_t stat_reg = RTC_Read_Reg(DS3231_REG_STATUS);
	PUSH	W10
	PUSH	W11
	MOV.B	#15, W10
	CALL	_RTC_Read_Reg
;ds3231_functions.c,236 :: 		stat_reg &= 0xF7;
	ZE	W0, W1
	MOV	#247, W0
	AND	W1, W0, W0
;ds3231_functions.c,237 :: 		RTC_Write_Reg(DS3231_REG_STATUS, stat_reg);
	MOV.B	W0, W11
	MOV.B	#15, W10
	CALL	_RTC_Write_Reg
;ds3231_functions.c,238 :: 		}
L_end_Disable_32kHZ:
	POP	W11
	POP	W10
	RETURN
; end of _Disable_32kHZ

_OSC_Start:

;ds3231_functions.c,241 :: 		void OSC_Start()
;ds3231_functions.c,243 :: 		uint8_t ctrl_reg = RTC_Read_Reg(DS3231_REG_CONTROL);
	PUSH	W10
	PUSH	W11
	MOV.B	#14, W10
	CALL	_RTC_Read_Reg
;ds3231_functions.c,244 :: 		ctrl_reg &= 0x7F;
	ZE	W0, W1
	MOV	#127, W0
	AND	W1, W0, W0
;ds3231_functions.c,245 :: 		RTC_Write_Reg(DS3231_REG_CONTROL, ctrl_reg);
	MOV.B	W0, W11
	MOV.B	#14, W10
	CALL	_RTC_Write_Reg
;ds3231_functions.c,246 :: 		}
L_end_OSC_Start:
	POP	W11
	POP	W10
	RETURN
; end of _OSC_Start

_OSC_Stop:

;ds3231_functions.c,249 :: 		void OSC_Stop()
;ds3231_functions.c,251 :: 		uint8_t ctrl_reg = RTC_Read_Reg(DS3231_REG_CONTROL);
	PUSH	W10
	PUSH	W11
	MOV.B	#14, W10
	CALL	_RTC_Read_Reg
;ds3231_functions.c,252 :: 		ctrl_reg |= 0x80;
	ZE	W0, W1
	MOV	#128, W0
	IOR	W1, W0, W0
;ds3231_functions.c,253 :: 		RTC_Write_Reg(DS3231_REG_CONTROL, ctrl_reg);
	MOV.B	W0, W11
	MOV.B	#14, W10
	CALL	_RTC_Write_Reg
;ds3231_functions.c,254 :: 		}
L_end_OSC_Stop:
	POP	W11
	POP	W10
	RETURN
; end of _OSC_Stop

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
	BRA Z	L__main184
	GOTO	L_main6
L__main184:
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
	BRA Z	L__main185
	GOTO	L_main8
L__main185:
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
;Digitalizador.c,436 :: 		IntSqw_Set(OUT_1Hz);
	MOV.B	#64, W10
	CALL	_IntSqw_Set
;Digitalizador.c,439 :: 		TRISD9_bit = 1;         // Como entrada la señal del reloj
	BSET	TRISD9_bit, BitPos(TRISD9_bit+0)
;Digitalizador.c,440 :: 		INT2IE_bit = 1;         // Habilita la interrupcion INT2
	BSET	INT2IE_bit, BitPos(INT2IE_bit+0)
;Digitalizador.c,441 :: 		INT2IF_bit = 0;         // Limpia la bandera de interrupcion de INT2
	BCLR	INT2IF_bit, BitPos(INT2IF_bit+0)
;Digitalizador.c,444 :: 		INT2EP_bit = 1;
	BSET	INT2EP_bit, BitPos(INT2EP_bit+0)
;Digitalizador.c,447 :: 		INT2IP_2_bit = 1;
	BSET	INT2IP_2_bit, BitPos(INT2IP_2_bit+0)
;Digitalizador.c,448 :: 		INT2IP_1_bit = 0;
	BCLR	INT2IP_1_bit, BitPos(INT2IP_1_bit+0)
;Digitalizador.c,449 :: 		INT2IP_0_bit = 0;
	BCLR	INT2IP_0_bit, BitPos(INT2IP_0_bit+0)
;Digitalizador.c,455 :: 		Delay_ms(500);
	MOV	#77, W8
	MOV	#19288, W7
L_Setup19:
	DEC	W7
	BRA NZ	L_Setup19
	DEC	W8
	BRA NZ	L_Setup19
	NOP
;Digitalizador.c,457 :: 		}
L_end_Setup:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Setup

_CheckWatchDog:

;Digitalizador.c,462 :: 		bool CheckWatchDog () {
;Digitalizador.c,463 :: 		if (contadorWDT >= 2){
	MOV	#lo_addr(_contadorWDT), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA GEU	L__CheckWatchDog189
	GOTO	L_CheckWatchDog21
L__CheckWatchDog189:
;Digitalizador.c,464 :: 		contadorWDT = 0;
	MOV	#lo_addr(_contadorWDT), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,465 :: 		asm clrwdt;
	CLRWDT
;Digitalizador.c,466 :: 		return true;
	MOV.B	#1, W0
	GOTO	L_end_CheckWatchDog
;Digitalizador.c,467 :: 		} else {
L_CheckWatchDog21:
;Digitalizador.c,468 :: 		return false;
	CLR	W0
;Digitalizador.c,470 :: 		}
L_end_CheckWatchDog:
	RETURN
; end of _CheckWatchDog

_InitTimer3:

;Digitalizador.c,482 :: 		void InitTimer3() {
;Digitalizador.c,485 :: 		T3CON = 0x0010;
	MOV	#16, W0
	MOV	WREG, T3CON
;Digitalizador.c,488 :: 		T3IE_bit = 1;
	BSET	T3IE_bit, BitPos(T3IE_bit+0)
;Digitalizador.c,489 :: 		T3IF_bit = 0;
	BCLR	T3IF_bit, BitPos(T3IF_bit+0)
;Digitalizador.c,492 :: 		TMR3 = 0;
	CLR	TMR3
;Digitalizador.c,495 :: 		T3IP_2_bit = 1;
	BSET	T3IP_2_bit, BitPos(T3IP_2_bit+0)
;Digitalizador.c,496 :: 		T3IP_1_bit = 1;
	BSET	T3IP_1_bit, BitPos(T3IP_1_bit+0)
;Digitalizador.c,497 :: 		T3IP_0_bit = 1;
	BSET	T3IP_0_bit, BitPos(T3IP_0_bit+0)
;Digitalizador.c,500 :: 		PR3 = 37500;
	MOV	#37500, W0
	MOV	WREG, PR3
;Digitalizador.c,501 :: 		}
L_end_InitTimer3:
	RETURN
; end of _InitTimer3

_GenerarInterrupcionRPi:

;Digitalizador.c,511 :: 		void GenerarInterrupcionRPi(unsigned short operacion){
;Digitalizador.c,523 :: 		bandOperacion = 0; bandTimeFromRPi = 0; bandTimeFromDSPIC = 0;
	MOV	#lo_addr(_bandOperacion), W1
	CLR	W0
	MOV.B	W0, [W1]
	MOV	#lo_addr(_bandTimeFromRPi), W1
	CLR	W0
	MOV.B	W0, [W1]
	MOV	#lo_addr(_bandTimeFromDSPIC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,528 :: 		bandTramaRecBytesPorMuestra = 0; bandTramaInitMues = 0;
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W1
	CLR	W0
	MOV.B	W0, [W1]
	MOV	#lo_addr(_bandTramaInitMues), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,531 :: 		tipoOperacion = operacion;
	MOV	#lo_addr(_tipoOperacion), W0
	MOV.B	W10, [W0]
;Digitalizador.c,533 :: 		LED_4 = ~LED_4;
	BTG	LATB8_bit, BitPos(LATB8_bit+0)
;Digitalizador.c,536 :: 		if (SPIROV_bit == 1) {
	BTSS	SPIROV_bit, BitPos(SPIROV_bit+0)
	GOTO	L_GenerarInterrupcionRPi23
;Digitalizador.c,538 :: 		LED_3 = ~LED_3;
	BTG	LATD1_bit, BitPos(LATD1_bit+0)
;Digitalizador.c,541 :: 		SPIROV_bit = 0;
	BCLR	SPIROV_bit, BitPos(SPIROV_bit+0)
;Digitalizador.c,545 :: 		if (SPI1IF_bit == 1) {
	BTSS	SPI1IF_bit, BitPos(SPI1IF_bit+0)
	GOTO	L_GenerarInterrupcionRPi24
;Digitalizador.c,546 :: 		SPI1IF_bit = 0;
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Digitalizador.c,547 :: 		}
L_GenerarInterrupcionRPi24:
;Digitalizador.c,548 :: 		}
L_GenerarInterrupcionRPi23:
;Digitalizador.c,553 :: 		PIN_RPi = 1;
	BSET	LATF1_bit, BitPos(LATF1_bit+0)
;Digitalizador.c,555 :: 		Delay_us(40);
	MOV	#400, W7
L_GenerarInterrupcionRPi25:
	DEC	W7
	BRA NZ	L_GenerarInterrupcionRPi25
;Digitalizador.c,556 :: 		PIN_RPi = 0;
	BCLR	LATF1_bit, BitPos(LATF1_bit+0)
;Digitalizador.c,557 :: 		}
L_end_GenerarInterrupcionRPi:
	RETURN
; end of _GenerarInterrupcionRPi

_LeerCanalADC:

;Digitalizador.c,569 :: 		unsigned int LeerCanalADC (unsigned int canal) {
;Digitalizador.c,574 :: 		ADCON1 = 0b0000000011100000;
	MOV	#224, W0
	MOV	WREG, ADCON1
;Digitalizador.c,577 :: 		ADCHS = 0X0000 | canal;
	MOV	W10, ADCHS
;Digitalizador.c,592 :: 		ADCON3 = 0b0000000100101000; //SAMC<4:0> = 1*TAD ... SI ADCS<5:0> = 40 ... si 30 MIPS :: Tcy = 33ns y TAD = 677nsec ... TiempoConversion: 15*TAD = 15*683.33ns = 10.249 us
	MOV	#296, W0
	MOV	WREG, ADCON3
;Digitalizador.c,595 :: 		ADON_bit = 1;
	BSET	ADON_bit, BitPos(ADON_bit+0)
;Digitalizador.c,599 :: 		SAMP_bit = 1;
	BSET	SAMP_bit, BitPos(SAMP_bit+0)
;Digitalizador.c,602 :: 		while (DONE_bit == 0) {
L_LeerCanalADC27:
	BTSC	DONE_bit, BitPos(DONE_bit+0)
	GOTO	L_LeerCanalADC28
;Digitalizador.c,603 :: 		asm nop;
	NOP
;Digitalizador.c,604 :: 		}
	GOTO	L_LeerCanalADC27
L_LeerCanalADC28:
;Digitalizador.c,606 :: 		valADCleido = ADCBUF0;
; valADCleido start address is: 2 (W1)
	MOV	ADCBUF0, W1
;Digitalizador.c,608 :: 		ADON_bit = 0;
	BCLR	ADON_bit, BitPos(ADON_bit+0)
;Digitalizador.c,610 :: 		return valADCleido;
	MOV	W1, W0
; valADCleido end address is: 2 (W1)
;Digitalizador.c,611 :: 		}
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

;Digitalizador.c,622 :: 		void Timer3Interrupt() iv IVT_ADDR_T3INTERRUPT{
;Digitalizador.c,640 :: 		T3IF_bit = 0;
	PUSH	W10
	BCLR	T3IF_bit, BitPos(T3IF_bit+0)
;Digitalizador.c,645 :: 		contadorFsample ++;
	MOV	#1, W1
	MOV	#lo_addr(Timer3Interrupt_contadorFsample_L0), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,648 :: 		valADC_canal_1 = LeerCanalADC(11);
	MOV	#11, W10
	CALL	_LeerCanalADC
	MOV	W0, [W14+0]
;Digitalizador.c,649 :: 		valADC_canal_2 = LeerCanalADC(10);
	MOV	#10, W10
	CALL	_LeerCanalADC
	MOV	W0, [W14+2]
;Digitalizador.c,650 :: 		valADC_canal_3 = LeerCanalADC(9);
	MOV	#9, W10
	CALL	_LeerCanalADC
	MOV	W0, [W14+4]
;Digitalizador.c,653 :: 		punteroValADC_1 = &valADC_canal_1;
	ADD	W14, #0, W2
; punteroValADC_1 start address is: 8 (W4)
	MOV	W2, W4
;Digitalizador.c,654 :: 		punteroValADC_2 = &valADC_canal_2;
	ADD	W14, #2, W0
; punteroValADC_2 start address is: 10 (W5)
	MOV	W0, W5
;Digitalizador.c,655 :: 		punteroValADC_3 = &valADC_canal_3;
	ADD	W14, #4, W0
; punteroValADC_3 start address is: 12 (W6)
	MOV	W0, W6
;Digitalizador.c,661 :: 		vectorDatos[0] = (ganancia << 4) | *(punteroValADC_1 + 1);
	ADD	W14, #6, W3
	MOV	#lo_addr(_ganancia), W0
	ZE	[W0], W0
	SL	W0, #4, W1
	ADD	W2, #1, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV.B	W0, [W3]
;Digitalizador.c,663 :: 		vectorDatos[1] = *punteroValADC_1;
	ADD	W3, #1, W0
	MOV.B	[W4], [W0]
; punteroValADC_1 end address is: 8 (W4)
;Digitalizador.c,665 :: 		vectorDatos[2] = (*(punteroValADC_2 + 1) << 4) | *(punteroValADC_3 + 1);
	ADD	W3, #2, W2
	ADD	W5, #1, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #4, W1
	ADD	W6, #1, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV.B	W0, [W2]
;Digitalizador.c,667 :: 		vectorDatos[3] = *punteroValADC_2;
	ADD	W3, #3, W0
	MOV.B	[W5], [W0]
; punteroValADC_2 end address is: 10 (W5)
;Digitalizador.c,668 :: 		vectorDatos[4] = *punteroValADC_3;
	ADD	W3, #4, W0
	MOV.B	[W6], [W0]
; punteroValADC_3 end address is: 12 (W6)
;Digitalizador.c,671 :: 		for (indiceForTimer3 = 0; indiceForTimer3 < numBytesPorMuestra; indiceForTimer3 ++) {
; indiceForTimer3 start address is: 6 (W3)
	CLR	W3
; indiceForTimer3 end address is: 6 (W3)
L_Timer3Interrupt29:
; indiceForTimer3 start address is: 6 (W3)
	CP.B	W3, #5
	BRA LTU	L__Timer3Interrupt194
	GOTO	L_Timer3Interrupt30
L__Timer3Interrupt194:
;Digitalizador.c,672 :: 		vectorData[contadorMuestras + indiceForTimer3] = vectorDatos[indiceForTimer3];
	ZE	W3, W1
	MOV	#lo_addr(_contadorMuestras), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_vectorData), W0
	ADD	W0, W1, W2
	ADD	W14, #6, W1
	ZE	W3, W0
	ADD	W1, W0, W0
	MOV.B	[W0], [W2]
;Digitalizador.c,671 :: 		for (indiceForTimer3 = 0; indiceForTimer3 < numBytesPorMuestra; indiceForTimer3 ++) {
	INC.B	W3
;Digitalizador.c,673 :: 		}
; indiceForTimer3 end address is: 6 (W3)
	GOTO	L_Timer3Interrupt29
L_Timer3Interrupt30:
;Digitalizador.c,674 :: 		contadorMuestras = contadorMuestras + numBytesPorMuestra;
	MOV	_contadorMuestras, W0
	ADD	W0, #5, W1
	MOV	W1, _contadorMuestras
;Digitalizador.c,680 :: 		if (contadorMuestras >= numMuestrasEnvio) {
	MOV	#250, W0
	CP	W1, W0
	BRA GEU	L__Timer3Interrupt195
	GOTO	L_Timer3Interrupt32
L__Timer3Interrupt195:
;Digitalizador.c,688 :: 		if (contadorFsample >= fsample) {
	MOV	#lo_addr(_fsample), W0
	ZE	[W0], W1
	MOV	#lo_addr(Timer3Interrupt_contadorFsample_L0), W0
	CP	W1, [W0]
	BRA LEU	L__Timer3Interrupt196
	GOTO	L_Timer3Interrupt33
L__Timer3Interrupt196:
;Digitalizador.c,690 :: 		contadorFsample = 0;
	CLR	W0
	MOV	W0, Timer3Interrupt_contadorFsample_L0
;Digitalizador.c,692 :: 		TON_T3CON_bit = 0;
	BCLR	TON_T3CON_bit, BitPos(TON_T3CON_bit+0)
;Digitalizador.c,693 :: 		}
L_Timer3Interrupt33:
;Digitalizador.c,695 :: 		if (isEnviarHoraToRPi == true) {
	MOV	#lo_addr(_isEnviarHoraToRPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Timer3Interrupt197
	GOTO	L_Timer3Interrupt34
L__Timer3Interrupt197:
;Digitalizador.c,703 :: 		punteroLong = &horaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_horaLongSistema), W2
;Digitalizador.c,705 :: 		vectorData[numMuestrasEnvio] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+250), W0
	MOV.B	W1, [W0]
;Digitalizador.c,706 :: 		vectorData[numMuestrasEnvio + 1] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+251), W0
	MOV.B	W1, [W0]
;Digitalizador.c,707 :: 		vectorData[numMuestrasEnvio + 2] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorData+252), W0
	MOV.B	W1, [W0]
;Digitalizador.c,709 :: 		punteroLong = &fechaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_fechaLongSistema), W2
;Digitalizador.c,711 :: 		vectorData[numMuestrasEnvio + 3] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+253), W0
	MOV.B	W1, [W0]
;Digitalizador.c,712 :: 		vectorData[numMuestrasEnvio + 4] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorData+254), W0
	MOV.B	W1, [W0]
;Digitalizador.c,713 :: 		vectorData[numMuestrasEnvio + 5] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorData+255), W0
	MOV.B	W1, [W0]
;Digitalizador.c,717 :: 		isLibreVectorData = false;
	MOV	#lo_addr(_isLibreVectorData), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,719 :: 		contadorMuestras = 0;
	CLR	W0
	MOV	W0, _contadorMuestras
;Digitalizador.c,726 :: 		GenerarInterrupcionRPi(ENV_MUESTRAS_TIME);
	MOV.B	#178, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,730 :: 		} else {
	GOTO	L_Timer3Interrupt35
L_Timer3Interrupt34:
;Digitalizador.c,732 :: 		isLibreVectorData = false;
	MOV	#lo_addr(_isLibreVectorData), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,733 :: 		contadorMuestras = 0;
	CLR	W0
	MOV	W0, _contadorMuestras
;Digitalizador.c,739 :: 		GenerarInterrupcionRPi(ENV_MUESTRAS);
	MOV.B	#177, W10
	CALL	_GenerarInterrupcionRPi
;Digitalizador.c,740 :: 		}
L_Timer3Interrupt35:
;Digitalizador.c,741 :: 		}
L_Timer3Interrupt32:
;Digitalizador.c,742 :: 		}
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

;Digitalizador.c,752 :: 		void interruptSPI1 () org  IVT_ADDR_SPI1INTERRUPT {
;Digitalizador.c,769 :: 		SPI1IF_bit = 0;
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Digitalizador.c,771 :: 		dataSPI = SPI1BUF;
; dataSPI start address is: 4 (W2)
	MOV	SPI1BUF, W2
;Digitalizador.c,777 :: 		if (bandOperacion == 0 && dataSPI == INI_OBT_OPE) {
	MOV	#lo_addr(_bandOperacion), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1199
	GOTO	L__interruptSPI1134
L__interruptSPI1199:
	MOV.B	#160, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1200
	GOTO	L__interruptSPI1133
L__interruptSPI1200:
; dataSPI end address is: 4 (W2)
L__interruptSPI1132:
;Digitalizador.c,780 :: 		bandOperacion = 1;
	MOV	#lo_addr(_bandOperacion), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,782 :: 		SPI1BUF = tipoOperacion;
	MOV	#lo_addr(_tipoOperacion), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,785 :: 		} else if (bandOperacion == 1 && dataSPI == FIN_OBT_OPE) {
	GOTO	L_interruptSPI139
;Digitalizador.c,777 :: 		if (bandOperacion == 0 && dataSPI == INI_OBT_OPE) {
L__interruptSPI1134:
; dataSPI start address is: 4 (W2)
L__interruptSPI1133:
;Digitalizador.c,785 :: 		} else if (bandOperacion == 1 && dataSPI == FIN_OBT_OPE) {
	MOV	#lo_addr(_bandOperacion), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1201
	GOTO	L__interruptSPI1136
L__interruptSPI1201:
	MOV.B	#240, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1202
	GOTO	L__interruptSPI1135
L__interruptSPI1202:
; dataSPI end address is: 4 (W2)
L__interruptSPI1131:
;Digitalizador.c,786 :: 		bandOperacion = 0;
	MOV	#lo_addr(_bandOperacion), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,787 :: 		tipoOperacion = 0;
	MOV	#lo_addr(_tipoOperacion), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,788 :: 		}
	GOTO	L_interruptSPI143
;Digitalizador.c,785 :: 		} else if (bandOperacion == 1 && dataSPI == FIN_OBT_OPE) {
L__interruptSPI1136:
; dataSPI start address is: 4 (W2)
L__interruptSPI1135:
;Digitalizador.c,794 :: 		else if (bandTramaRecBytesPorMuestra == 0 && dataSPI == INI_REC_MUES) {
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1203
	GOTO	L__interruptSPI1138
L__interruptSPI1203:
	MOV.B	#163, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1204
	GOTO	L__interruptSPI1137
L__interruptSPI1204:
; dataSPI end address is: 4 (W2)
L__interruptSPI1130:
;Digitalizador.c,796 :: 		bandTramaRecBytesPorMuestra = 1;
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,798 :: 		indiceBytesPorMuestra = 0;
	CLR	W0
	MOV	W0, interruptSPI1_indiceBytesPorMuestra_L0
;Digitalizador.c,802 :: 		if (isLibreVectorData == false) {
	MOV	#lo_addr(_isLibreVectorData), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1205
	GOTO	L_interruptSPI147
L__interruptSPI1205:
;Digitalizador.c,803 :: 		SPI1BUF = vectorData[indiceBytesPorMuestra];
	MOV	#lo_addr(_vectorData), W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,804 :: 		indiceBytesPorMuestra ++;
	MOV	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,805 :: 		}
L_interruptSPI147:
;Digitalizador.c,808 :: 		} else if (bandTramaRecBytesPorMuestra == 1) {
	GOTO	L_interruptSPI148
;Digitalizador.c,794 :: 		else if (bandTramaRecBytesPorMuestra == 0 && dataSPI == INI_REC_MUES) {
L__interruptSPI1138:
; dataSPI start address is: 4 (W2)
L__interruptSPI1137:
;Digitalizador.c,808 :: 		} else if (bandTramaRecBytesPorMuestra == 1) {
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1206
	GOTO	L_interruptSPI149
L__interruptSPI1206:
;Digitalizador.c,810 :: 		if (dataSPI == DUMMY_BYTE) {
	CP.B	W2, #0
	BRA Z	L__interruptSPI1207
	GOTO	L_interruptSPI150
L__interruptSPI1207:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,812 :: 		if (isLibreVectorData == false) {
	MOV	#lo_addr(_isLibreVectorData), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1208
	GOTO	L_interruptSPI151
L__interruptSPI1208:
;Digitalizador.c,813 :: 		SPI1BUF = vectorData[indiceBytesPorMuestra];
	MOV	#lo_addr(_vectorData), W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,814 :: 		indiceBytesPorMuestra ++;
	MOV	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,815 :: 		}
L_interruptSPI151:
;Digitalizador.c,817 :: 		} else if (dataSPI == FIN_REC_MUES) {
	GOTO	L_interruptSPI152
L_interruptSPI150:
; dataSPI start address is: 4 (W2)
	MOV.B	#243, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1209
	GOTO	L_interruptSPI153
L__interruptSPI1209:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,824 :: 		if (indiceBytesPorMuestra > numMuestrasEnvio) {
	MOV	#250, W1
	MOV	#lo_addr(interruptSPI1_indiceBytesPorMuestra_L0), W0
	CP	W1, [W0]
	BRA LTU	L__interruptSPI1210
	GOTO	L_interruptSPI154
L__interruptSPI1210:
;Digitalizador.c,825 :: 		isEnviarHoraToRPi = false;
	MOV	#lo_addr(_isEnviarHoraToRPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,826 :: 		}
L_interruptSPI154:
;Digitalizador.c,829 :: 		bandTramaRecBytesPorMuestra = 0;
	MOV	#lo_addr(_bandTramaRecBytesPorMuestra), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,831 :: 		if (isLibreVectorData == false) {
	MOV	#lo_addr(_isLibreVectorData), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1211
	GOTO	L_interruptSPI155
L__interruptSPI1211:
;Digitalizador.c,832 :: 		isLibreVectorData = true;
	MOV	#lo_addr(_isLibreVectorData), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,833 :: 		}
L_interruptSPI155:
;Digitalizador.c,834 :: 		}
L_interruptSPI153:
L_interruptSPI152:
;Digitalizador.c,835 :: 		}
	GOTO	L_interruptSPI156
L_interruptSPI149:
;Digitalizador.c,840 :: 		else if (bandTimeFromRPi == 0 && dataSPI == INI_TIME_FROM_RPI) {
; dataSPI start address is: 4 (W2)
	MOV	#lo_addr(_bandTimeFromRPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1212
	GOTO	L__interruptSPI1140
L__interruptSPI1212:
	MOV.B	#164, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1213
	GOTO	L__interruptSPI1139
L__interruptSPI1213:
; dataSPI end address is: 4 (W2)
L__interruptSPI1129:
;Digitalizador.c,842 :: 		bandTimeFromRPi = 1;
	MOV	#lo_addr(_bandTimeFromRPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,844 :: 		indiceTimeFromRPi = 0;
	MOV	#lo_addr(interruptSPI1_indiceTimeFromRPi_L0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,847 :: 		} else if (bandTimeFromRPi == 1) {
	GOTO	L_interruptSPI160
;Digitalizador.c,840 :: 		else if (bandTimeFromRPi == 0 && dataSPI == INI_TIME_FROM_RPI) {
L__interruptSPI1140:
; dataSPI start address is: 4 (W2)
L__interruptSPI1139:
;Digitalizador.c,847 :: 		} else if (bandTimeFromRPi == 1) {
	MOV	#lo_addr(_bandTimeFromRPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1214
	GOTO	L_interruptSPI161
L__interruptSPI1214:
;Digitalizador.c,850 :: 		if (dataSPI != FIN_TIME_FROM_RPI) {
	MOV.B	#244, W0
	CP.B	W2, W0
	BRA NZ	L__interruptSPI1215
	GOTO	L_interruptSPI162
L__interruptSPI1215:
;Digitalizador.c,851 :: 		vectorBytesTimeRPi[indiceTimeFromRPi] = dataSPI;
	MOV	#lo_addr(interruptSPI1_indiceTimeFromRPi_L0), W0
	ZE	[W0], W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0), W0
	ADD	W0, W1, W0
	MOV.B	W2, [W0]
; dataSPI end address is: 4 (W2)
;Digitalizador.c,852 :: 		indiceTimeFromRPi ++;
	MOV.B	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceTimeFromRPi_L0), W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,854 :: 		} else {
	GOTO	L_interruptSPI163
L_interruptSPI162:
;Digitalizador.c,856 :: 		bandTimeFromRPi = 0;
	MOV	#lo_addr(_bandTimeFromRPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,860 :: 		punteroLong = &fechaLongRPi;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_fechaLongRPi), W2
;Digitalizador.c,862 :: 		*(punteroLong + 3) = vectorBytesTimeRPi[0];
	ADD	W2, #3, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,863 :: 		*(punteroLong + 2) = vectorBytesTimeRPi[1];
	ADD	W2, #2, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+1), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,864 :: 		*(punteroLong + 1) = vectorBytesTimeRPi[2];
	ADD	W2, #1, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+2), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,865 :: 		*(punteroLong) = vectorBytesTimeRPi[3];
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+3), W0
	MOV.B	[W0], [W2]
;Digitalizador.c,869 :: 		punteroLong = &horaLongRPi;
	MOV	#lo_addr(_horaLongRPi), W2
;Digitalizador.c,871 :: 		*(punteroLong + 3) = vectorBytesTimeRPi[4];
	ADD	W2, #3, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+4), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,872 :: 		*(punteroLong + 2) = vectorBytesTimeRPi[5];
	ADD	W2, #2, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+5), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,873 :: 		*(punteroLong + 1) = vectorBytesTimeRPi[6];
	ADD	W2, #1, W1
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+6), W0
	MOV.B	[W0], [W1]
;Digitalizador.c,874 :: 		*(punteroLong) = vectorBytesTimeRPi[7];
	MOV	#lo_addr(interruptSPI1_vectorBytesTimeRPi_L0+7), W0
	MOV.B	[W0], [W2]
; punteroLong end address is: 4 (W2)
;Digitalizador.c,878 :: 		if (isGPS_Connected == false) {
	MOV	#lo_addr(_isGPS_Connected), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1216
	GOTO	L_interruptSPI164
L__interruptSPI1216:
;Digitalizador.c,880 :: 		fechaLongSistema = fechaLongRPi;
	MOV	_fechaLongRPi, W0
	MOV	_fechaLongRPi+2, W1
	MOV	W0, _fechaLongSistema
	MOV	W1, _fechaLongSistema+2
;Digitalizador.c,881 :: 		horaLongSistema = horaLongRPi;
	MOV	_horaLongRPi, W0
	MOV	_horaLongRPi+2, W1
	MOV	W0, _horaLongSistema
	MOV	W1, _horaLongSistema+2
;Digitalizador.c,883 :: 		fechaLongRTC = fechaLongRPi;
	MOV	_fechaLongRPi, W0
	MOV	_fechaLongRPi+2, W1
	MOV	W0, _fechaLongRTC
	MOV	W1, _fechaLongRTC+2
;Digitalizador.c,884 :: 		horaLongRTC = horaLongRPi;
	MOV	_horaLongRPi, W0
	MOV	_horaLongRPi+2, W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,886 :: 		isActualizarRTC = true;
	MOV	#lo_addr(_isActualizarRTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,888 :: 		fuenteTiempoSistema = FUENTE_TIME_RTC;
	MOV	#lo_addr(_fuenteTiempoSistema), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Digitalizador.c,889 :: 		}
L_interruptSPI164:
;Digitalizador.c,890 :: 		}
L_interruptSPI163:
;Digitalizador.c,891 :: 		}
	GOTO	L_interruptSPI165
L_interruptSPI161:
;Digitalizador.c,896 :: 		else if (bandTimeFromDSPIC == 0 && dataSPI == INI_TIME_FROM_DSPIC) {
; dataSPI start address is: 4 (W2)
	MOV	#lo_addr(_bandTimeFromDSPIC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1217
	GOTO	L__interruptSPI1142
L__interruptSPI1217:
	MOV.B	#165, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1218
	GOTO	L__interruptSPI1141
L__interruptSPI1218:
; dataSPI end address is: 4 (W2)
L__interruptSPI1128:
;Digitalizador.c,899 :: 		bandTimeFromDSPIC = 1;
	MOV	#lo_addr(_bandTimeFromDSPIC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,901 :: 		indiceTimeFromDSPIC = 0;
	MOV	#lo_addr(interruptSPI1_indiceTimeFromDSPIC_L0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,903 :: 		SPI1BUF = fuenteTiempoSistema;
	MOV	#lo_addr(_fuenteTiempoSistema), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,906 :: 		punteroLong = &fechaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_fechaLongSistema), W2
;Digitalizador.c,908 :: 		vectorTiempoSistema[0] = *(punteroLong + 3);
	ADD	W2, #3, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema), W0
	MOV.B	W1, [W0]
;Digitalizador.c,909 :: 		vectorTiempoSistema[1] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+1), W0
	MOV.B	W1, [W0]
;Digitalizador.c,910 :: 		vectorTiempoSistema[2] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+2), W0
	MOV.B	W1, [W0]
;Digitalizador.c,911 :: 		vectorTiempoSistema[3] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorTiempoSistema+3), W0
	MOV.B	W1, [W0]
;Digitalizador.c,914 :: 		punteroLong = &horaLongSistema;
; punteroLong start address is: 4 (W2)
	MOV	#lo_addr(_horaLongSistema), W2
;Digitalizador.c,915 :: 		vectorTiempoSistema[4] = *(punteroLong + 3);
	ADD	W2, #3, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+4), W0
	MOV.B	W1, [W0]
;Digitalizador.c,916 :: 		vectorTiempoSistema[5] = *(punteroLong + 2);
	ADD	W2, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+5), W0
	MOV.B	W1, [W0]
;Digitalizador.c,917 :: 		vectorTiempoSistema[6] = *(punteroLong + 1);
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema+6), W0
	MOV.B	W1, [W0]
;Digitalizador.c,918 :: 		vectorTiempoSistema[7] = *(punteroLong);
	MOV.B	[W2], W1
; punteroLong end address is: 4 (W2)
	MOV	#lo_addr(_vectorTiempoSistema+7), W0
	MOV.B	W1, [W0]
;Digitalizador.c,921 :: 		} else if (bandTimeFromDSPIC == 1) {
	GOTO	L_interruptSPI169
;Digitalizador.c,896 :: 		else if (bandTimeFromDSPIC == 0 && dataSPI == INI_TIME_FROM_DSPIC) {
L__interruptSPI1142:
; dataSPI start address is: 4 (W2)
L__interruptSPI1141:
;Digitalizador.c,921 :: 		} else if (bandTimeFromDSPIC == 1) {
	MOV	#lo_addr(_bandTimeFromDSPIC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1219
	GOTO	L_interruptSPI170
L__interruptSPI1219:
;Digitalizador.c,923 :: 		if (dataSPI == DUMMY_BYTE) {
	CP.B	W2, #0
	BRA Z	L__interruptSPI1220
	GOTO	L_interruptSPI171
L__interruptSPI1220:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,924 :: 		SPI1BUF = vectorTiempoSistema[indiceTimeFromDSPIC];
	MOV	#lo_addr(interruptSPI1_indiceTimeFromDSPIC_L0), W0
	ZE	[W0], W1
	MOV	#lo_addr(_vectorTiempoSistema), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Digitalizador.c,925 :: 		indiceTimeFromDSPIC ++;
	MOV.B	#1, W1
	MOV	#lo_addr(interruptSPI1_indiceTimeFromDSPIC_L0), W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,927 :: 		} else if (dataSPI == FIN_TIME_FROM_DSPIC) {
	GOTO	L_interruptSPI172
L_interruptSPI171:
; dataSPI start address is: 4 (W2)
	MOV.B	#245, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1221
	GOTO	L_interruptSPI173
L__interruptSPI1221:
; dataSPI end address is: 4 (W2)
;Digitalizador.c,928 :: 		bandTimeFromDSPIC = 0;
	MOV	#lo_addr(_bandTimeFromDSPIC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,929 :: 		}
L_interruptSPI173:
L_interruptSPI172:
;Digitalizador.c,930 :: 		}
	GOTO	L_interruptSPI174
L_interruptSPI170:
;Digitalizador.c,935 :: 		else if (bandTramaInitMues == 0 && dataSPI == INI_INIT_MUES) {
; dataSPI start address is: 4 (W2)
	MOV	#lo_addr(_bandTramaInitMues), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptSPI1222
	GOTO	L__interruptSPI1144
L__interruptSPI1222:
	MOV.B	#161, W0
	CP.B	W2, W0
	BRA Z	L__interruptSPI1223
	GOTO	L__interruptSPI1143
L__interruptSPI1223:
; dataSPI end address is: 4 (W2)
L__interruptSPI1127:
;Digitalizador.c,937 :: 		bandTramaInitMues = 1;
	MOV	#lo_addr(_bandTramaInitMues), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,940 :: 		isComienzoMuestreo = true;
	MOV	#lo_addr(_isComienzoMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,943 :: 		} else if (bandTramaInitMues == 1) {
	GOTO	L_interruptSPI178
;Digitalizador.c,935 :: 		else if (bandTramaInitMues == 0 && dataSPI == INI_INIT_MUES) {
L__interruptSPI1144:
L__interruptSPI1143:
;Digitalizador.c,943 :: 		} else if (bandTramaInitMues == 1) {
	MOV	#lo_addr(_bandTramaInitMues), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptSPI1224
	GOTO	L_interruptSPI179
L__interruptSPI1224:
;Digitalizador.c,944 :: 		bandTramaInitMues = 0;
	MOV	#lo_addr(_bandTramaInitMues), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,945 :: 		}
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
;Digitalizador.c,947 :: 		}
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

;Digitalizador.c,958 :: 		void ExternalInterrupt0_GPS() org IVT_ADDR_INT0INTERRUPT{
;Digitalizador.c,960 :: 		INT0IF_bit = 0;
	BCLR	INT0IF_bit, BitPos(INT0IF_bit+0)
;Digitalizador.c,964 :: 		if (isPPS_GPS == false) {
	MOV	#lo_addr(_isPPS_GPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt0_GPS226
	GOTO	L_ExternalInterrupt0_GPS80
L__ExternalInterrupt0_GPS226:
;Digitalizador.c,965 :: 		isPPS_GPS = true;
	MOV	#lo_addr(_isPPS_GPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,968 :: 		if (isGPS_Connected == false && isComuGPS == true) {
	MOV	#lo_addr(_isGPS_Connected), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt0_GPS227
	GOTO	L__ExternalInterrupt0_GPS147
L__ExternalInterrupt0_GPS227:
	MOV	#lo_addr(_isComuGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt0_GPS228
	GOTO	L__ExternalInterrupt0_GPS146
L__ExternalInterrupt0_GPS228:
L__ExternalInterrupt0_GPS145:
;Digitalizador.c,969 :: 		isGPS_Connected = true;
	MOV	#lo_addr(_isGPS_Connected), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,971 :: 		isEnviarGPSOk = true;
	MOV	#lo_addr(_isEnviarGPSOk), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,973 :: 		fuenteTiempoSistema = FUENTE_TIME_GPS;
	MOV	#lo_addr(_fuenteTiempoSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,968 :: 		if (isGPS_Connected == false && isComuGPS == true) {
L__ExternalInterrupt0_GPS147:
L__ExternalInterrupt0_GPS146:
;Digitalizador.c,975 :: 		}
L_ExternalInterrupt0_GPS80:
;Digitalizador.c,981 :: 		if (isRecTiempoGPS == true) {
	MOV	#lo_addr(_isRecTiempoGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt0_GPS229
	GOTO	L_ExternalInterrupt0_GPS84
L__ExternalInterrupt0_GPS229:
;Digitalizador.c,983 :: 		isRecTiempoGPS = false;
	MOV	#lo_addr(_isRecTiempoGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,986 :: 		horaLongSistema = horaLongGPS;
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	MOV	W0, _horaLongSistema
	MOV	W1, _horaLongSistema+2
;Digitalizador.c,987 :: 		fechaLongSistema = fechaLongGPS;
	MOV	_fechaLongGPS, W0
	MOV	_fechaLongGPS+2, W1
	MOV	W0, _fechaLongSistema
	MOV	W1, _fechaLongSistema+2
;Digitalizador.c,989 :: 		fuenteTiempoSistema = FUENTE_TIME_GPS;
	MOV	#lo_addr(_fuenteTiempoSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,992 :: 		} else {
	GOTO	L_ExternalInterrupt0_GPS85
L_ExternalInterrupt0_GPS84:
;Digitalizador.c,994 :: 		horaLongGPS ++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaLongGPS), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;Digitalizador.c,995 :: 		}
L_ExternalInterrupt0_GPS85:
;Digitalizador.c,998 :: 		if (horaLongGPS == 86400) {
	MOV	_horaLongGPS, W2
	MOV	_horaLongGPS+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__ExternalInterrupt0_GPS230
	GOTO	L_ExternalInterrupt0_GPS86
L__ExternalInterrupt0_GPS230:
;Digitalizador.c,999 :: 		horaLongGPS = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaLongGPS
	MOV	W1, _horaLongGPS+2
;Digitalizador.c,1000 :: 		}
L_ExternalInterrupt0_GPS86:
;Digitalizador.c,1001 :: 		}
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

;Digitalizador.c,1013 :: 		void ExternalInterrupt2_RTC() org IVT_ADDR_INT2INTERRUPT{
;Digitalizador.c,1015 :: 		INT2IF_bit = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT2IF_bit, BitPos(INT2IF_bit+0)
;Digitalizador.c,1017 :: 		LED_2 = ~LED_2;
	BTG	LATD0_bit, BitPos(LATD0_bit+0)
;Digitalizador.c,1022 :: 		if (isActualizarRTC == true) {
	MOV	#lo_addr(_isActualizarRTC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC232
	GOTO	L_ExternalInterrupt2_RTC87
L__ExternalInterrupt2_RTC232:
;Digitalizador.c,1023 :: 		isActualizarRTC = false;
	MOV	#lo_addr(_isActualizarRTC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1026 :: 		PasarTiempoToVector(horaLongRTC, fechaLongRTC, vectorTiempoRTC);
	MOV	_fechaLongRTC, W12
	MOV	_fechaLongRTC+2, W13
	MOV	_horaLongRTC, W10
	MOV	_horaLongRTC+2, W11
	MOV	#lo_addr(_vectorTiempoRTC), W0
	PUSH	W0
	CALL	_PasarTiempoToVector
	SUB	#2, W15
;Digitalizador.c,1037 :: 		} else {
	GOTO	L_ExternalInterrupt2_RTC88
L_ExternalInterrupt2_RTC87:
;Digitalizador.c,1039 :: 		horaLongRTC ++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaLongRTC), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;Digitalizador.c,1040 :: 		}
L_ExternalInterrupt2_RTC88:
;Digitalizador.c,1043 :: 		if (horaLongRTC == 86400) {
	MOV	_horaLongRTC, W2
	MOV	_horaLongRTC+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__ExternalInterrupt2_RTC233
	GOTO	L_ExternalInterrupt2_RTC89
L__ExternalInterrupt2_RTC233:
;Digitalizador.c,1044 :: 		horaLongRTC = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,1045 :: 		}
L_ExternalInterrupt2_RTC89:
;Digitalizador.c,1052 :: 		if (horaLongGPS == 86390 && fuenteTiempoSistema == FUENTE_TIME_GPS) {
	MOV	_horaLongGPS, W2
	MOV	_horaLongGPS+2, W3
	MOV	#20854, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__ExternalInterrupt2_RTC234
	GOTO	L__ExternalInterrupt2_RTC152
L__ExternalInterrupt2_RTC234:
	MOV	#lo_addr(_fuenteTiempoSistema), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC235
	GOTO	L__ExternalInterrupt2_RTC151
L__ExternalInterrupt2_RTC235:
L__ExternalInterrupt2_RTC150:
;Digitalizador.c,1054 :: 		U1RXIE_bit = 1;
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,1052 :: 		if (horaLongGPS == 86390 && fuenteTiempoSistema == FUENTE_TIME_GPS) {
L__ExternalInterrupt2_RTC152:
L__ExternalInterrupt2_RTC151:
;Digitalizador.c,1058 :: 		horaLongSistema = horaLongRTC;
	MOV	_horaLongRTC, W0
	MOV	_horaLongRTC+2, W1
	MOV	W0, _horaLongSistema
	MOV	W1, _horaLongSistema+2
;Digitalizador.c,1061 :: 		if (isComienzoMuestreo == true) {
	MOV	#lo_addr(_isComienzoMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC236
	GOTO	L_ExternalInterrupt2_RTC93
L__ExternalInterrupt2_RTC236:
;Digitalizador.c,1063 :: 		if (isMuestreando == false && (horaLongRTC % 60) == 0) {
	MOV	#lo_addr(_isMuestreando), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt2_RTC237
	GOTO	L__ExternalInterrupt2_RTC154
L__ExternalInterrupt2_RTC237:
	MOV	#60, W2
	MOV	#0, W3
	MOV	_horaLongRTC, W0
	MOV	_horaLongRTC+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__ExternalInterrupt2_RTC238
	GOTO	L__ExternalInterrupt2_RTC153
L__ExternalInterrupt2_RTC238:
L__ExternalInterrupt2_RTC149:
;Digitalizador.c,1064 :: 		isMuestreando = true;
	MOV	#lo_addr(_isMuestreando), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1066 :: 		isComienzoMuestreo = false;
	MOV	#lo_addr(_isComienzoMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1069 :: 		isPrimeraVezMuestreo = true;
	MOV	#lo_addr(_isPrimeraVezMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1063 :: 		if (isMuestreando == false && (horaLongRTC % 60) == 0) {
L__ExternalInterrupt2_RTC154:
L__ExternalInterrupt2_RTC153:
;Digitalizador.c,1071 :: 		}
L_ExternalInterrupt2_RTC93:
;Digitalizador.c,1074 :: 		if (isMuestreando == true) {
	MOV	#lo_addr(_isMuestreando), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__ExternalInterrupt2_RTC239
	GOTO	L_ExternalInterrupt2_RTC97
L__ExternalInterrupt2_RTC239:
;Digitalizador.c,1077 :: 		if ((horaLongRTC % 60) == 0 && isPrimeraVezMuestreo == false) {
	MOV	#60, W2
	MOV	#0, W3
	MOV	_horaLongRTC, W0
	MOV	_horaLongRTC+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__ExternalInterrupt2_RTC240
	GOTO	L__ExternalInterrupt2_RTC156
L__ExternalInterrupt2_RTC240:
	MOV	#lo_addr(_isPrimeraVezMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__ExternalInterrupt2_RTC241
	GOTO	L__ExternalInterrupt2_RTC155
L__ExternalInterrupt2_RTC241:
L__ExternalInterrupt2_RTC148:
;Digitalizador.c,1078 :: 		isEnviarHoraToRPi = true;
	MOV	#lo_addr(_isEnviarHoraToRPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1077 :: 		if ((horaLongRTC % 60) == 0 && isPrimeraVezMuestreo == false) {
L__ExternalInterrupt2_RTC156:
L__ExternalInterrupt2_RTC155:
;Digitalizador.c,1085 :: 		if (TON_T3CON_bit == 0) {
	BTSC	TON_T3CON_bit, BitPos(TON_T3CON_bit+0)
	GOTO	L_ExternalInterrupt2_RTC101
;Digitalizador.c,1086 :: 		TON_T3CON_bit = 1;
	BSET	TON_T3CON_bit, BitPos(TON_T3CON_bit+0)
;Digitalizador.c,1087 :: 		}
L_ExternalInterrupt2_RTC101:
;Digitalizador.c,1089 :: 		TMR3 = 0;
	CLR	TMR3
;Digitalizador.c,1092 :: 		T3IF_bit = 1;
	BSET	T3IF_bit, BitPos(T3IF_bit+0)
;Digitalizador.c,1093 :: 		}
L_ExternalInterrupt2_RTC97:
;Digitalizador.c,1094 :: 		}
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

;Digitalizador.c,1103 :: 		void interruptU1RX() iv IVT_ADDR_U1RXINTERRUPT {
;Digitalizador.c,1107 :: 		U1RXIF_bit = 0;
	PUSH	W10
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;Digitalizador.c,1109 :: 		byteGPS = U1RXREG;                                                                                                                                                                                                                                       //Lee el byte de la trama enviada por el GPS
; byteGPS start address is: 4 (W2)
	MOV	U1RXREG, W2
;Digitalizador.c,1111 :: 		OERR_bit = 0;
	BCLR	OERR_bit, BitPos(OERR_bit+0)
;Digitalizador.c,1113 :: 		if (banTIGPS == 0){
	MOV	#lo_addr(_banTIGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptU1RX243
	GOTO	L_interruptU1RX102
L__interruptU1RX243:
;Digitalizador.c,1116 :: 		if ((byteGPS == 0x24) && (indice_gps == 0)){
	MOV.B	#36, W0
	CP.B	W2, W0
	BRA Z	L__interruptU1RX244
	GOTO	L__interruptU1RX160
L__interruptU1RX244:
	MOV	_indice_gps, W0
	CP	W0, #0
	BRA Z	L__interruptU1RX245
	GOTO	L__interruptU1RX159
L__interruptU1RX245:
L__interruptU1RX158:
;Digitalizador.c,1118 :: 		banTIGPS = 1;
	MOV	#lo_addr(_banTIGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1116 :: 		if ((byteGPS == 0x24) && (indice_gps == 0)){
L__interruptU1RX160:
L__interruptU1RX159:
;Digitalizador.c,1120 :: 		}
L_interruptU1RX102:
;Digitalizador.c,1122 :: 		if (banTIGPS == 1){
	MOV	#lo_addr(_banTIGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptU1RX246
	GOTO	L_interruptU1RX106
L__interruptU1RX246:
;Digitalizador.c,1125 :: 		if (byteGPS != 0x2A){
	MOV.B	#42, W0
	CP.B	W2, W0
	BRA NZ	L__interruptU1RX247
	GOTO	L_interruptU1RX107
L__interruptU1RX247:
;Digitalizador.c,1127 :: 		tramaGPS[indice_gps] = byteGPS;
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_indice_gps), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
; byteGPS end address is: 4 (W2)
;Digitalizador.c,1129 :: 		if (indice_gps < 70){
	MOV	#70, W1
	MOV	#lo_addr(_indice_gps), W0
	CP	W1, [W0]
	BRA GTU	L__interruptU1RX248
	GOTO	L_interruptU1RX108
L__interruptU1RX248:
;Digitalizador.c,1130 :: 		indice_gps ++;
	MOV	#1, W1
	MOV	#lo_addr(_indice_gps), W0
	ADD	W1, [W0], [W0]
;Digitalizador.c,1131 :: 		}
L_interruptU1RX108:
;Digitalizador.c,1136 :: 		if ((indice_gps > 5) && (tramaGPS[1] != 0x47) && (tramaGPS[2] != 0x50)  && (tramaGPS[3] != 0x52)  && (tramaGPS[4] != 0x4D)  && (tramaGPS[5] != 0x43)) {
	MOV	_indice_gps, W0
	CP	W0, #5
	BRA GTU	L__interruptU1RX249
	GOTO	L__interruptU1RX166
L__interruptU1RX249:
	MOV	#lo_addr(_tramaGPS+1), W0
	MOV.B	[W0], W1
	MOV.B	#71, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX250
	GOTO	L__interruptU1RX165
L__interruptU1RX250:
	MOV	#lo_addr(_tramaGPS+2), W0
	MOV.B	[W0], W1
	MOV.B	#80, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX251
	GOTO	L__interruptU1RX164
L__interruptU1RX251:
	MOV	#lo_addr(_tramaGPS+3), W0
	MOV.B	[W0], W1
	MOV.B	#82, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX252
	GOTO	L__interruptU1RX163
L__interruptU1RX252:
	MOV	#lo_addr(_tramaGPS+4), W0
	MOV.B	[W0], W1
	MOV.B	#77, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX253
	GOTO	L__interruptU1RX162
L__interruptU1RX253:
	MOV	#lo_addr(_tramaGPS+5), W0
	MOV.B	[W0], W1
	MOV.B	#67, W0
	CP.B	W1, W0
	BRA NZ	L__interruptU1RX254
	GOTO	L__interruptU1RX161
L__interruptU1RX254:
L__interruptU1RX157:
;Digitalizador.c,1138 :: 		indice_gps = 0;
	CLR	W0
	MOV	W0, _indice_gps
;Digitalizador.c,1140 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1142 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1136 :: 		if ((indice_gps > 5) && (tramaGPS[1] != 0x47) && (tramaGPS[2] != 0x50)  && (tramaGPS[3] != 0x52)  && (tramaGPS[4] != 0x4D)  && (tramaGPS[5] != 0x43)) {
L__interruptU1RX166:
L__interruptU1RX165:
L__interruptU1RX164:
L__interruptU1RX163:
L__interruptU1RX162:
L__interruptU1RX161:
;Digitalizador.c,1145 :: 		} else {
	GOTO	L_interruptU1RX112
L_interruptU1RX107:
;Digitalizador.c,1146 :: 		tramaGPS[indice_gps] = byteGPS;
; byteGPS start address is: 4 (W2)
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_indice_gps), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
; byteGPS end address is: 4 (W2)
;Digitalizador.c,1149 :: 		banTIGPS = 2;
	MOV	#lo_addr(_banTIGPS), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1151 :: 		banTCGPS = 1;
	MOV	#lo_addr(_banTCGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1152 :: 		}
L_interruptU1RX112:
;Digitalizador.c,1153 :: 		}
L_interruptU1RX106:
;Digitalizador.c,1157 :: 		if (banTCGPS == 1) {
	MOV	#lo_addr(_banTCGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__interruptU1RX255
	GOTO	L_interruptU1RX113
L__interruptU1RX255:
;Digitalizador.c,1160 :: 		if (tramaGPS[18] == 0x41) {
	MOV	#lo_addr(_tramaGPS+18), W0
	MOV.B	[W0], W1
	MOV.B	#65, W0
	CP.B	W1, W0
	BRA Z	L__interruptU1RX256
	GOTO	L_interruptU1RX114
L__interruptU1RX256:
;Digitalizador.c,1165 :: 		for (indiceU1RX_1 = 0; indiceU1RX_1 < 6; indiceU1RX_1++){
; indiceU1RX_1 start address is: 6 (W3)
	CLR	W3
; indiceU1RX_1 end address is: 6 (W3)
L_interruptU1RX115:
; indiceU1RX_1 start address is: 6 (W3)
	CP.B	W3, #6
	BRA LTU	L__interruptU1RX257
	GOTO	L_interruptU1RX116
L__interruptU1RX257:
;Digitalizador.c,1167 :: 		datosGPS[indiceU1RX_1] = tramaGPS[7+indiceU1RX_1];
	ZE	W3, W1
	MOV	#lo_addr(_datosGPS), W0
	ADD	W0, W1, W2
	ZE	W3, W0
	ADD	W0, #7, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Digitalizador.c,1165 :: 		for (indiceU1RX_1 = 0; indiceU1RX_1 < 6; indiceU1RX_1++){
	INC.B	W3
;Digitalizador.c,1168 :: 		}
; indiceU1RX_1 end address is: 6 (W3)
	GOTO	L_interruptU1RX115
L_interruptU1RX116:
;Digitalizador.c,1170 :: 		for (indiceU1RX_1 = 50; indiceU1RX_1 < 60; indiceU1RX_1++){
; indiceU1RX_1 start address is: 6 (W3)
	MOV.B	#50, W3
; indiceU1RX_1 end address is: 6 (W3)
L_interruptU1RX118:
; indiceU1RX_1 start address is: 6 (W3)
	MOV.B	#60, W0
	CP.B	W3, W0
	BRA LTU	L__interruptU1RX258
	GOTO	L_interruptU1RX119
L__interruptU1RX258:
;Digitalizador.c,1173 :: 		if (tramaGPS[indiceU1RX_1] == 0x2C){
	ZE	W3, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#44, W0
	CP.B	W1, W0
	BRA Z	L__interruptU1RX259
	GOTO	L__interruptU1RX167
L__interruptU1RX259:
;Digitalizador.c,1175 :: 		for (indiceU1RX_2 = 0; indiceU1RX_2 < 6; indiceU1RX_2++){
	CLR	W0
	MOV.B	W0, [W14+0]
; indiceU1RX_1 end address is: 6 (W3)
L_interruptU1RX122:
; indiceU1RX_1 start address is: 6 (W3)
	MOV.B	[W14+0], W0
	CP.B	W0, #6
	BRA LTU	L__interruptU1RX260
	GOTO	L_interruptU1RX123
L__interruptU1RX260:
;Digitalizador.c,1176 :: 		datosGPS[6 + indiceU1RX_2] = tramaGPS[indiceU1RX_1 + indiceU1RX_2 + 1];
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
;Digitalizador.c,1175 :: 		for (indiceU1RX_2 = 0; indiceU1RX_2 < 6; indiceU1RX_2++){
	MOV.B	#1, W1
	ADD	W14, #0, W0
	ADD.B	W1, [W0], [W0]
;Digitalizador.c,1177 :: 		}
	GOTO	L_interruptU1RX122
L_interruptU1RX123:
;Digitalizador.c,1178 :: 		}
	MOV.B	W3, W0
	GOTO	L_interruptU1RX121
; indiceU1RX_1 end address is: 6 (W3)
L__interruptU1RX167:
;Digitalizador.c,1173 :: 		if (tramaGPS[indiceU1RX_1] == 0x2C){
	MOV.B	W3, W0
;Digitalizador.c,1178 :: 		}
L_interruptU1RX121:
;Digitalizador.c,1170 :: 		for (indiceU1RX_1 = 50; indiceU1RX_1 < 60; indiceU1RX_1++){
; indiceU1RX_1 start address is: 0 (W0)
; indiceU1RX_1 start address is: 6 (W3)
	ADD.B	W0, #1, W3
; indiceU1RX_1 end address is: 0 (W0)
;Digitalizador.c,1179 :: 		}
; indiceU1RX_1 end address is: 6 (W3)
	GOTO	L_interruptU1RX118
L_interruptU1RX119:
;Digitalizador.c,1182 :: 		horaLongGPS = RecuperarHoraGPS(datosGPS);
	MOV	#lo_addr(_datosGPS), W10
	CALL	_RecuperarHoraGPS
	MOV	W0, _horaLongGPS
	MOV	W1, _horaLongGPS+2
;Digitalizador.c,1183 :: 		fechaLongGPS = RecuperarFechaGPS(datosGPS);
	MOV	#lo_addr(_datosGPS), W10
	CALL	_RecuperarFechaGPS
	MOV	W0, _fechaLongGPS
	MOV	W1, _fechaLongGPS+2
;Digitalizador.c,1187 :: 		if (isComuGPS == false) {
	MOV	#lo_addr(_isComuGPS), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__interruptU1RX261
	GOTO	L_interruptU1RX125
L__interruptU1RX261:
;Digitalizador.c,1188 :: 		isComuGPS = true;
	MOV	#lo_addr(_isComuGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1193 :: 		isRecTiempoGPS = true;
	MOV	#lo_addr(_isRecTiempoGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1211 :: 		horaLongRTC = horaLongGPS;
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,1212 :: 		fechaLongRTC = fechaLongGPS;
	MOV	_fechaLongGPS, W0
	MOV	_fechaLongGPS+2, W1
	MOV	W0, _fechaLongRTC
	MOV	W1, _fechaLongRTC+2
;Digitalizador.c,1213 :: 		isActualizarRTC = true;
	MOV	#lo_addr(_isActualizarRTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1216 :: 		U1RXIE_bit = 0;
	BCLR	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,1217 :: 		}
L_interruptU1RX125:
;Digitalizador.c,1221 :: 		if ((horaLongGPS % 3600) == 0) {
	MOV	#3600, W2
	MOV	#0, W3
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__interruptU1RX262
	GOTO	L_interruptU1RX126
L__interruptU1RX262:
;Digitalizador.c,1222 :: 		LED = ~LED;
	BTG	LATB0_bit, BitPos(LATB0_bit+0)
;Digitalizador.c,1227 :: 		isRecTiempoGPS = true;
	MOV	#lo_addr(_isRecTiempoGPS), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1238 :: 		horaLongRTC = horaLongGPS;
	MOV	_horaLongGPS, W0
	MOV	_horaLongGPS+2, W1
	MOV	W0, _horaLongRTC
	MOV	W1, _horaLongRTC+2
;Digitalizador.c,1239 :: 		fechaLongRTC = fechaLongGPS;
	MOV	_fechaLongGPS, W0
	MOV	_fechaLongGPS+2, W1
	MOV	W0, _fechaLongRTC
	MOV	W1, _fechaLongRTC+2
;Digitalizador.c,1240 :: 		isActualizarRTC = true;
	MOV	#lo_addr(_isActualizarRTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Digitalizador.c,1243 :: 		U1RXIE_bit = 0;
	BCLR	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Digitalizador.c,1244 :: 		}
L_interruptU1RX126:
;Digitalizador.c,1245 :: 		}
L_interruptU1RX114:
;Digitalizador.c,1248 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1249 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Digitalizador.c,1250 :: 		indice_gps = 0;
	CLR	W0
	MOV	W0, _indice_gps
;Digitalizador.c,1251 :: 		}
L_interruptU1RX113:
;Digitalizador.c,1252 :: 		}
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
