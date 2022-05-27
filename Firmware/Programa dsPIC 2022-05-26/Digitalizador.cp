#line 1 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/Digitalizador/Digitalizador/Firmware/Programa dsPIC 2022-05-26/Digitalizador.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/stdbool.h"



 typedef char _Bool;
#line 1 "c:/users/ivan/desktop/milton muñoz/proyectos/git/digitalizador/digitalizador/firmware/programa dspic 2022-05-26/gestiontiempo.c"







unsigned long PasarHoraToSegundos(unsigned char horas, unsigned char minutos, unsigned char segundos);
void PasarTiempoToVector (unsigned long longHora, unsigned long longFecha, unsigned char *tramaTiempoSistema);
unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS);
unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS);









unsigned long PasarHoraToSegundos(unsigned char horas, unsigned char minutos, unsigned char segundos) {

 unsigned long horaEnSegundos;

 horaEnSegundos = (horas*3600) + (minutos*60) + (segundos);
 return horaEnSegundos;
}
#line 40 "c:/users/ivan/desktop/milton muñoz/proyectos/git/digitalizador/digitalizador/firmware/programa dspic 2022-05-26/gestiontiempo.c"
void PasarTiempoToVector (unsigned long longHora, unsigned long longFecha, unsigned char *tramaTiempoSistema) {

 unsigned char anio, mes, dia, hora, minuto, segundo;


 hora = longHora / 3600;
 minuto = (longHora%3600) / 60;
 segundo = (longHora%3600) % 60;


 anio = longFecha / 10000;
 mes = (longFecha%10000) / 100;
 dia = (longFecha%10000) % 100;


 tramaTiempoSistema[0] = anio;
 tramaTiempoSistema[1] = mes;
 tramaTiempoSistema[2] = dia;
 tramaTiempoSistema[3] = hora;
 tramaTiempoSistema[4] = minuto;
 tramaTiempoSistema[5] = segundo;
}









unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS) {

 unsigned long tramaFecha[4];

 unsigned long fechaGPS;


 char datoStringF[3];

 char *ptrDatoStringF = &datoStringF;
 datoStringF[2] = '\0';
 tramaFecha[3] = '\0';


 datoStringF[0] = tramaDatosGPS[6];
 datoStringF[1] = tramaDatosGPS[7];
 tramaFecha[0] = atoi(ptrDatoStringF);


 datoStringF[0] = tramaDatosGPS[8];
 datoStringF[1] = tramaDatosGPS[9];
 tramaFecha[1] = atoi(ptrDatoStringF);


 datoStringF[0] = tramaDatosGPS[10];
 datoStringF[1] = tramaDatosGPS[11];
 tramaFecha[2] = atoi(ptrDatoStringF);


 fechaGPS = (tramaFecha[2]*10000) + (tramaFecha[1]*100) + (tramaFecha[0]);

 return fechaGPS;
}






unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS) {

 unsigned long tramaTiempo[4];

 unsigned long horaGPS;


 char datoString[3];

 char *ptrDatoString = &datoString;
 datoString[2] = '\0';
 tramaTiempo[3] = '\0';


 datoString[0] = tramaDatosGPS[0];
 datoString[1] = tramaDatosGPS[1];

 tramaTiempo[0] = atoi(ptrDatoString);


 datoString[0] = tramaDatosGPS[2];
 datoString[1] = tramaDatosGPS[3];

 tramaTiempo[1] = atoi(ptrDatoString);


 datoString[0] = tramaDatosGPS[4];
 datoString[1] = tramaDatosGPS[5];

 tramaTiempo[2] = atoi(ptrDatoString);


 horaGPS = (tramaTiempo[0]*3600) + (tramaTiempo[1]*60) + (tramaTiempo[2]);
 return horaGPS;
}
#line 1 "c:/users/ivan/desktop/milton muñoz/proyectos/git/digitalizador/digitalizador/firmware/programa dspic 2022-05-26/ds1307_functions.c"
#line 7 "c:/users/ivan/desktop/milton muñoz/proyectos/git/digitalizador/digitalizador/firmware/programa dspic 2022-05-26/ds1307_functions.c"
typedef struct
{
 unsigned short Hor, Min, Seg;
}Hora;
typedef struct
{
 unsigned short Dia, Fec, Mes, Ano;
}Fecha;


void DS1307SetDir( unsigned short dir )
{
 Soft_I2C_Start();
 Soft_I2C_Write(0xD0);
 Soft_I2C_Write(dir);
}

unsigned short BcdToShort( unsigned short bcd )
{
 unsigned short LV, HV;
 LV = bcd&0x0F;
 HV = (bcd>>4)&0x0F;
 return LV + HV*10;
}

unsigned short ShortToBcd( unsigned short valor )
{
 unsigned short HV, LV;
 HV = valor/10;
 LV = valor - HV*10;
 return LV + HV*16;
}

void DS1307Inicio( void )
{
 unsigned short VAL[7], HV, LV, DATO;
 Soft_I2C_Init();
 delay_ms(50);

 DS1307SetDir(0);
 Soft_I2C_Start();
 Soft_I2C_Write(0xD1);
 VAL[0] = Soft_I2C_Read(1);
 VAL[1] = Soft_I2C_Read(1);
 VAL[2] = Soft_I2C_Read(1);
 VAL[3] = Soft_I2C_Read(1);
 VAL[4] = Soft_I2C_Read(1);
 VAL[5] = Soft_I2C_Read(1);
 VAL[6] = Soft_I2C_Read(0);
 Soft_I2C_Stop();
 delay_ms(50);


 DATO = BcdToShort( VAL[0] );
 if( DATO > 59 )VAL[0]=0;
 DATO = BcdToShort( VAL[1] );
 if( DATO>59 )VAL[1]=0;
 DATO = BcdToShort( VAL[2] );
 if( DATO>23 )VAL[2]=0;
 DATO = BcdToShort( VAL[3] );
 if( DATO>7 || DATO==0 )VAL[3]=1;
 DATO = BcdToShort( VAL[4] );
 if( DATO>31 || DATO==0 )VAL[4]=1;
 DATO = BcdToShort( VAL[5] );
 if( DATO>12 || DATO==0 )VAL[5]=1;
 DATO = BcdToShort( VAL[6] );
 if( DATO>99 )VAL[6]=0;

 DS1307SetDir(0);
 Soft_I2C_Write(VAL[0]);
 Soft_I2C_Write(VAL[1]);
 Soft_I2C_Write(VAL[2]);
 Soft_I2C_Write(VAL[3]);
 Soft_I2C_Write(VAL[4]);
 Soft_I2C_Write(VAL[5]);
 Soft_I2C_Write(VAL[6]);
 Soft_I2C_Write(0x10);
 Soft_I2C_Stop();
 delay_ms(50);
}

void DS1307SetHora( Hora h )
{
 DS1307SetDir(0);
 Soft_I2C_Write( ShortToBcd(h.Seg) );
 Soft_I2C_Write( ShortToBcd(h.Min) );
 Soft_I2C_Write( ShortToBcd(h.Hor) );
 Soft_I2C_Stop();
}

void DS1307SetFecha( Fecha f )
{
 DS1307SetDir(3);
 Soft_I2C_Write( ShortToBcd(f.Dia) );
 Soft_I2C_Write( ShortToBcd(f.Fec) );
 Soft_I2C_Write( ShortToBcd(f.Mes) );
 Soft_I2C_Write( ShortToBcd(f.Ano) );
 Soft_I2C_Stop();
}

Hora DS1307GetHora( void )
{
 Hora H;
 unsigned short VAL[3];
 DS1307SetDir(0);
 Soft_I2C_Start();
 Soft_I2C_Write(0xD1);
 VAL[0] = Soft_I2C_Read(1);
 VAL[1] = Soft_I2C_Read(1);
 VAL[2] = Soft_I2C_Read(0);
 Soft_I2C_Stop();
 H.Seg = BcdToShort( VAL[0] );
 H.Min = BcdToShort( VAL[1] );
 H.Hor = BcdToShort( VAL[2] );
 return H;
}

Fecha DS1307GetFecha( void )
{
 Fecha F;
 unsigned short VAL[4];
 DS1307SetDir(3);
 Soft_I2C_Start();
 Soft_I2C_Write(0xD1);
 VAL[0] = Soft_I2C_Read(1);
 VAL[1] = Soft_I2C_Read(1);
 VAL[2] = Soft_I2C_Read(1);
 VAL[3] = Soft_I2C_Read(0);
 Soft_I2C_Stop();
 F.Dia = BcdToShort( VAL[0] );
 F.Fec = BcdToShort( VAL[1] );
 F.Mes = BcdToShort( VAL[2] );
 F.Ano = BcdToShort( VAL[3] );
 return F;
}


unsigned short DS1307GetHoras( void )
{
 Hora h;
 h=DS1307GetHora();
 return h.Hor;
}

unsigned short DS1307GetMinutos( void )
{
 Hora h;
 h=DS1307GetHora();
 return h.Min;
}

unsigned short DS1307GetSegundos( void )
{
 Hora h;
 h=DS1307GetHora();
 return h.Seg;
}

void DS1307SetHoras( unsigned short ho )
{
 Hora h;
 h=DS1307GetHora();
 h.Hor = ho;
 DS1307SetHora( h );
}

void DS1307SetMinutos( unsigned short mi )
{
 Hora h;
 h=DS1307GetHora();
 h.Min = mi;
 DS1307SetHora( h );
}

void DS1307SetSegundos( unsigned short se )
{
 Hora h;
 h=DS1307GetHora();
 h.Seg = se;
 DS1307SetHora( h );
}

unsigned short DS1307GetDias( void )
{
 Fecha f;
 f=DS1307GetFecha();
 return f.Dia;
}

unsigned short DS1307GetFechas( void )
{
 Fecha f;
 f=DS1307GetFecha();
 return f.Fec;
}

unsigned short DS1307GetMeses( void )
{
 Fecha f;
 f=DS1307GetFecha();
 return f.Mes;
}

unsigned short DS1307GetAnos( void )
{
 Fecha f;
 f=DS1307GetFecha();
 return f.Ano;
}

void DS1307SetDias( unsigned short di )
{
 Fecha f;
 f=DS1307GetFecha();
 f.Dia = di;
 DS1307SetFecha(f);
}

void DS1307SetFechas( unsigned short fe )
{
 Fecha f;
 f=DS1307GetFecha();
 f.Fec = fe;
 DS1307SetFecha(f);
}

void DS1307SetMeses( unsigned short me )
{
 Fecha f;
 f=DS1307GetFecha();
 f.Mes = me;
 DS1307SetFecha(f);
}

void DS1307SetAnos( unsigned short an )
{
 Fecha f;
 f=DS1307GetFecha();
 f.Ano = an;
 DS1307SetFecha(f);
}
#line 36 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/Digitalizador/Digitalizador/Firmware/Programa dsPIC 2022-05-26/Digitalizador.c"
sbit PIN_RPi at LATF1_bit;
sbit PIN_RPi_DIRECTION at TRISF1_bit;








sbit Soft_I2C_Scl at RD2_bit;
sbit Soft_I2C_Sda at RD8_bit;
sbit Soft_I2C_Scl_Direction at TRISD2_bit;
sbit Soft_I2C_Sda_Direction at TRISD8_bit;



sbit LED_DIRECTION at TRISB0_bit;
sbit LED at LATB0_bit;
sbit LED_2_DIRECTION at TRISD0_bit;
sbit LED_2 at LATD0_bit;
sbit LED_3_DIRECTION at TRISD1_bit;
sbit LED_3 at LATD1_bit;
sbit LED_4_DIRECTION at TRISB8_bit;
sbit LED_4 at LATB8_bit;
#line 112 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/Digitalizador/Digitalizador/Firmware/Programa dsPIC 2022-05-26/Digitalizador.c"
const unsigned char numBytesTiempo = 8;


const unsigned int dimVectores = 256;
#line 148 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/Digitalizador/Digitalizador/Firmware/Programa dsPIC 2022-05-26/Digitalizador.c"
unsigned char ganancia = 10;

unsigned char fsample = 100;


unsigned char contadorWDT = 0;


unsigned char bandOperacion, tipoOperacion;

unsigned char bandTimeFromRPi = 0, bandTimeFromDSPIC = 0;

unsigned char bandTramaInitMues = 0;


unsigned char tramaGPS[70];
unsigned char datosGPS[13];

unsigned char vectorData[dimVectores];
unsigned int contadorMuestras = 0;

 _Bool  isLibreVectorData =  1 ;


unsigned char bandTramaRecBytesPorMuestra = 0;

unsigned char banTIGPS, banTCGPS;

unsigned int indice_gps;

 _Bool  isPPS_GPS =  0 , isComuGPS =  0 , isGPS_Connected =  0 ;



 _Bool  isRecTiempoGPS =  0 ;


 _Bool  isEnviarGPSOk =  0 ;


 _Bool  isEnviarHoraToRPi =  0 ;



 _Bool  isPrimeraVezMuestreo =  0 ;




unsigned char fuenteTiempoSistema = 0;


 _Bool  isActualizarRTC =  0 ;



unsigned long horaLongSistema = 0, horaLongGPS = 0, horaLongRTC = 0, horaLongRPi = 0;
unsigned long fechaLongSistema = 0, fechaLongGPS = 0, fechaLongRTC = 0, fechaLongRPi = 0;



unsigned char vectorTiempoSistema[numBytesTiempo], vectorTiempoRTC[numBytesTiempo];


 _Bool  isMuestreando =  0 ;



 _Bool  isComienzoMuestreo =  0 ;









void Setup ();
void InitTimer3();
 _Bool  CheckWatchDog ();
void GenerarInterrupcionRPi(unsigned short operacion);
unsigned int LeerCanalADC (unsigned int canal);





void main() {
 unsigned char valDummyRec;


 Setup();
 Delay_ms(500);



 GenerarInterrupcionRPi( 0XB4 );


 Delay_ms(100);

 while (1) {



 contadorWDT ++;
 CheckWatchDog();





 if (isEnviarGPSOk ==  1 ) {
 isEnviarGPSOk =  0 ;

 GenerarInterrupcionRPi( 0XB5 );


 } else if (isPrimeraVezMuestreo ==  1 ) {
 isPrimeraVezMuestreo =  0 ;

 GenerarInterrupcionRPi( 0XB3 );
 }




 Delay_ms(1);
 }
}

void Setup () {

 unsigned char valDummyRec;


 ADPCFG = 0XFFFF;


 PCFG_11_bit = 0; PCFG_10_bit = 0; PCFG_9_bit = 0;

 PCFG_12_bit = 0;


 TRISB11_bit = 1; TRISB10_bit = 1; TRISB9_bit = 1;

 TRISB12_bit = 1;


 TRISB3_bit = 0; TRISB4_bit = 0;
 TRISB5_bit = 0; TRISB6_bit = 0;


 LATB = (LATB & 0b1110000111) | (0b0001111000 & (ganancia << 3));


 InitTimer3();


 LED_DIRECTION = 0;
 LED_2_DIRECTION = 0;
 LED_3_DIRECTION = 0;
 LED_4_DIRECTION = 0;

 LED = 1;
 LED_2 = 1;
 LED_3 = 1;
 LED_4 = 1;
 Delay_ms(300);
 LED = 0;
 LED_2 = 0;
 Delay_ms(300);
 LED = 1;
 LED_2 = 1;







 PIN_RPi = 0;
 PIN_RPi_DIRECTION = 0;


 banTIGPS = 0;

 banTCGPS = 0;

 indice_gps = 0;





 SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);

 valDummyRec = SPI1BUF;

 SPI1IE_bit = 1;

 SPI1IF_bit = 0;

 IPC2bits.SPI1IP = 7;

 SPIROV_bit = 0;

 SPI1STAT.SPIEN = 1;








 UART1_Init(9600);


 LATD3_bit = 1;
 TRISD3_bit = 0;

 ALTIO_bit = 1;
 Delay_ms(100);

 CN1PUE_bit = 1;


 U1RXIE_bit = 1;

 U1RXIF_bit = 0;

 IPC2bits.U1RXIP = 0x04;
 U1STAbits.URXISEL = 0x00;





 UART1_Write_Text("$PMTK220,1000*1F\r\n");

 Delay_ms(1000);




 UART1_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n");
 Delay_ms(1000);


 TRISA11_bit = 1;
 RA11_bit = 0;




 INT0EP_bit = 0;

 INT0IE_bit = 1;

 INT0IF_bit = 0;


 INT0IP_2_bit = 1;
 INT0IP_1_bit = 0;
 INT0IP_0_bit = 0;








 DS1307Inicio();


 TRISD9_bit = 1;
 INT2IE_bit = 1;
 INT2IF_bit = 0;


 INT2EP_bit = 1;


 INT2IP_2_bit = 1;
 INT2IP_1_bit = 0;
 INT2IP_0_bit = 0;





 Delay_ms(500);

}




 _Bool  CheckWatchDog () {
 if (contadorWDT >= 2){
 contadorWDT = 0;
 asm clrwdt;
 return  1 ;
 } else {
 return  0 ;
 }
}
#line 469 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/Digitalizador/Digitalizador/Firmware/Programa dsPIC 2022-05-26/Digitalizador.c"
void InitTimer3() {


 T3CON = 0x0010;


 T3IE_bit = 1;
 T3IF_bit = 0;


 TMR3 = 0;


 T3IP_2_bit = 1;
 T3IP_1_bit = 1;
 T3IP_0_bit = 1;


 PR3 = 37500;
}









void GenerarInterrupcionRPi(unsigned short operacion){

 unsigned char valDummyRec;









 bandOperacion = 0; bandTimeFromRPi = 0; bandTimeFromDSPIC = 0;




 bandTramaRecBytesPorMuestra = 0; bandTramaInitMues = 0;


 tipoOperacion = operacion;

 LED_4 = ~LED_4;


 if (SPIROV_bit == 1) {

 LED_3 = ~LED_3;


 SPIROV_bit = 0;
 valDummyRec = SPI1BUF;


 if (SPI1IF_bit == 1) {
 SPI1IF_bit = 0;
 }
 }




 PIN_RPi = 1;

 Delay_us(40);
 PIN_RPi = 0;
}
#line 556 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/Digitalizador/Digitalizador/Firmware/Programa dsPIC 2022-05-26/Digitalizador.c"
unsigned int LeerCanalADC (unsigned int canal) {
 unsigned int valADCleido;



 ADCON1 = 0b0000000011100000;


 ADCHS = 0X0000 | canal;
#line 579 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/Digitalizador/Digitalizador/Firmware/Programa dsPIC 2022-05-26/Digitalizador.c"
 ADCON3 = 0b0000000100101000;


 ADON_bit = 1;



 SAMP_bit = 1;


 while (DONE_bit == 0) {
 asm nop;
 }

 valADCleido = ADCBUF0;

 ADON_bit = 0;

 return valADCleido;
}










void Timer3Interrupt() iv IVT_ADDR_T3INTERRUPT{

 char *punteroValADC_1, *punteroValADC_2, *punteroValADC_3;

 unsigned int valADC_canal_1, valADC_canal_2, valADC_canal_3;


 unsigned char vectorDatos[5];

 unsigned char indiceForTimer3;



 static unsigned int contadorFsample = 0;

 char *punteroLong;


 T3IF_bit = 0;




 contadorFsample ++;


 valADC_canal_1 = LeerCanalADC(11);
 valADC_canal_2 = LeerCanalADC(10);
 valADC_canal_3 = LeerCanalADC(9);


 punteroValADC_1 = &valADC_canal_1;
 punteroValADC_2 = &valADC_canal_2;
 punteroValADC_3 = &valADC_canal_3;





 vectorDatos[0] = (ganancia << 4) | *(punteroValADC_1 + 1);

 vectorDatos[1] = *punteroValADC_1;

 vectorDatos[2] = (*(punteroValADC_2 + 1) << 4) | *(punteroValADC_3 + 1);

 vectorDatos[3] = *punteroValADC_2;
 vectorDatos[4] = *punteroValADC_3;


 for (indiceForTimer3 = 0; indiceForTimer3 <  5 ; indiceForTimer3 ++) {
 vectorData[contadorMuestras + indiceForTimer3] = vectorDatos[indiceForTimer3];
 }
 contadorMuestras = contadorMuestras +  5 ;





 if (contadorMuestras >=  250 ) {







 if (contadorFsample >= fsample) {

 contadorFsample = 0;

 TON_T3CON_bit = 0;
 }

 if (isEnviarHoraToRPi ==  1 ) {







 punteroLong = &horaLongSistema;

 vectorData[ 250 ] = *(punteroLong + 2);
 vectorData[ 250  + 1] = *(punteroLong + 1);
 vectorData[ 250  + 2] = *(punteroLong);

 punteroLong = &fechaLongSistema;

 vectorData[ 250  + 3] = *(punteroLong + 2);
 vectorData[ 250  + 4] = *(punteroLong + 1);
 vectorData[ 250  + 5] = *(punteroLong);



 isLibreVectorData =  0 ;

 contadorMuestras = 0;






 GenerarInterrupcionRPi( 0XB2 );



 } else {

 isLibreVectorData =  0 ;
 contadorMuestras = 0;





 GenerarInterrupcionRPi( 0XB1 );
 }
 }
}









void interruptSPI1 () org IVT_ADDR_SPI1INTERRUPT {

 unsigned short dataSPI;




 static unsigned char indiceTimeFromRPi = 0;
 static unsigned char vectorBytesTimeRPi[numBytesTiempo];

 static unsigned char indiceTimeFromDSPIC = 0;

 static unsigned int indiceBytesPorMuestra;

 char *punteroLong;


 SPI1IF_bit = 0;

 dataSPI = SPI1BUF;





 if (bandOperacion == 0 && dataSPI ==  0XA0 ) {


 bandOperacion = 1;

 SPI1BUF = tipoOperacion;


 } else if (bandOperacion == 1 && dataSPI ==  0XF0 ) {
 bandOperacion = 0;
 tipoOperacion = 0;
 }





 else if (bandTramaRecBytesPorMuestra == 0 && dataSPI ==  0XA3 ) {

 bandTramaRecBytesPorMuestra = 1;

 indiceBytesPorMuestra = 0;



 if (isLibreVectorData ==  0 ) {
 SPI1BUF = vectorData[indiceBytesPorMuestra];
 indiceBytesPorMuestra ++;
 }


 } else if (bandTramaRecBytesPorMuestra == 1) {

 if (dataSPI ==  0X00 ) {

 if (isLibreVectorData ==  0 ) {
 SPI1BUF = vectorData[indiceBytesPorMuestra];
 indiceBytesPorMuestra ++;
 }

 } else if (dataSPI ==  0XF3 ) {






 if (indiceBytesPorMuestra >  250 ) {
 isEnviarHoraToRPi =  0 ;
 }


 bandTramaRecBytesPorMuestra = 0;

 if (isLibreVectorData ==  0 ) {
 isLibreVectorData =  1 ;
 }
 }
 }




 else if (bandTimeFromRPi == 0 && dataSPI ==  0XA4 ) {

 bandTimeFromRPi = 1;

 indiceTimeFromRPi = 0;


 } else if (bandTimeFromRPi == 1) {


 if (dataSPI !=  0XF4 ) {
 vectorBytesTimeRPi[indiceTimeFromRPi] = dataSPI;
 indiceTimeFromRPi ++;

 } else {

 bandTimeFromRPi = 0;



 punteroLong = &fechaLongRPi;

 *(punteroLong + 3) = vectorBytesTimeRPi[0];
 *(punteroLong + 2) = vectorBytesTimeRPi[1];
 *(punteroLong + 1) = vectorBytesTimeRPi[2];
 *(punteroLong) = vectorBytesTimeRPi[3];



 punteroLong = &horaLongRPi;

 *(punteroLong + 3) = vectorBytesTimeRPi[4];
 *(punteroLong + 2) = vectorBytesTimeRPi[5];
 *(punteroLong + 1) = vectorBytesTimeRPi[6];
 *(punteroLong) = vectorBytesTimeRPi[7];



 if (isGPS_Connected ==  0 ) {

 fechaLongSistema = fechaLongRPi;
 horaLongSistema = horaLongRPi;

 fechaLongRTC = fechaLongRPi;
 horaLongRTC = horaLongRPi;

 isActualizarRTC =  1 ;

 fuenteTiempoSistema =  0X02 ;
 }
 }
 }




 else if (bandTimeFromDSPIC == 0 && dataSPI ==  0xA5 ) {


 bandTimeFromDSPIC = 1;

 indiceTimeFromDSPIC = 0;

 SPI1BUF = fuenteTiempoSistema;


 punteroLong = &fechaLongSistema;

 vectorTiempoSistema[0] = *(punteroLong + 3);
 vectorTiempoSistema[1] = *(punteroLong + 2);
 vectorTiempoSistema[2] = *(punteroLong + 1);
 vectorTiempoSistema[3] = *(punteroLong);


 punteroLong = &horaLongSistema;
 vectorTiempoSistema[4] = *(punteroLong + 3);
 vectorTiempoSistema[5] = *(punteroLong + 2);
 vectorTiempoSistema[6] = *(punteroLong + 1);
 vectorTiempoSistema[7] = *(punteroLong);


 } else if (bandTimeFromDSPIC == 1) {

 if (dataSPI ==  0X00 ) {
 SPI1BUF = vectorTiempoSistema[indiceTimeFromDSPIC];
 indiceTimeFromDSPIC ++;

 } else if (dataSPI ==  0XF5 ) {
 bandTimeFromDSPIC = 0;
 }
 }




 else if (bandTramaInitMues == 0 && dataSPI ==  0XA1 ) {

 bandTramaInitMues = 1;


 isComienzoMuestreo =  1 ;


 } else if (bandTramaInitMues == 1) {
 bandTramaInitMues = 0;
 }

}










void ExternalInterrupt0_GPS() org IVT_ADDR_INT0INTERRUPT{

 INT0IF_bit = 0;



 if (isPPS_GPS ==  0 ) {
 isPPS_GPS =  1 ;


 if (isGPS_Connected ==  0  && isComuGPS ==  1 ) {
 isGPS_Connected =  1 ;

 isEnviarGPSOk =  1 ;

 fuenteTiempoSistema =  0X01 ;
 }
 }





 if (isRecTiempoGPS ==  1 ) {

 isRecTiempoGPS =  0 ;


 horaLongSistema = horaLongGPS;
 fechaLongSistema = fechaLongGPS;

 fuenteTiempoSistema =  0X01 ;


 } else {

 horaLongGPS ++;
 }


 if (horaLongGPS == 86400) {
 horaLongGPS = 0;
 }
}
#line 1000 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/Digitalizador/Digitalizador/Firmware/Programa dsPIC 2022-05-26/Digitalizador.c"
void ExternalInterrupt2_RTC() org IVT_ADDR_INT2INTERRUPT{

 INT2IF_bit = 0;

 LED_2 = ~LED_2;




 if (isActualizarRTC ==  1 ) {
 isActualizarRTC =  0 ;


 PasarTiempoToVector(horaLongRTC, fechaLongRTC, vectorTiempoRTC);

 DS1307SetAnos(vectorTiempoRTC[0]);
 DS1307SetMeses(vectorTiempoRTC[1]);
 DS1307SetFechas(vectorTiempoRTC[2]);
 DS1307SetHoras(vectorTiempoRTC[3]);
 DS1307SetMinutos(vectorTiempoRTC[4]);
 DS1307SetSegundos(vectorTiempoRTC[5]);

 } else {

 horaLongRTC ++;
 }


 if (horaLongRTC == 86400) {
 horaLongRTC = 0;
 }






 if (horaLongGPS == 86390 && fuenteTiempoSistema ==  0X01 ) {

 U1RXIE_bit = 1;
 }


 horaLongSistema = horaLongRTC;


 if (isComienzoMuestreo ==  1 ) {

 if (isMuestreando ==  0  && (horaLongRTC % 60) == 0) {
 isMuestreando =  1 ;

 isComienzoMuestreo =  0 ;


 isPrimeraVezMuestreo =  1 ;
 }
 }


 if (isMuestreando ==  1 ) {


 if ((horaLongRTC % 60) == 0 && isPrimeraVezMuestreo ==  0 ) {
 isEnviarHoraToRPi =  1 ;


 }



 if (TON_T3CON_bit == 0) {
 TON_T3CON_bit = 1;
 }

 TMR3 = 0;


 T3IF_bit = 1;
 }
}








void interruptU1RX() iv IVT_ADDR_U1RXINTERRUPT {
 unsigned char byteGPS, indiceU1RX_1, indiceU1RX_2;


 U1RXIF_bit = 0;

 byteGPS = U1RXREG;

 OERR_bit = 0;

 if (banTIGPS == 0){


 if ((byteGPS == 0x24) && (indice_gps == 0)){

 banTIGPS = 1;
 }
 }

 if (banTIGPS == 1){


 if (byteGPS != 0x2A){

 tramaGPS[indice_gps] = byteGPS;

 if (indice_gps < 70){
 indice_gps ++;
 }




 if ((indice_gps > 5) && (tramaGPS[1] != 0x47) && (tramaGPS[2] != 0x50) && (tramaGPS[3] != 0x52) && (tramaGPS[4] != 0x4D) && (tramaGPS[5] != 0x43)) {

 indice_gps = 0;

 banTIGPS = 0;

 banTCGPS = 0;
 }

 } else {
 tramaGPS[indice_gps] = byteGPS;


 banTIGPS = 2;

 banTCGPS = 1;
 }
 }



 if (banTCGPS == 1) {


 if (tramaGPS[18] == 0x41) {




 for (indiceU1RX_1 = 0; indiceU1RX_1 < 6; indiceU1RX_1++){

 datosGPS[indiceU1RX_1] = tramaGPS[7+indiceU1RX_1];
 }

 for (indiceU1RX_1 = 50; indiceU1RX_1 < 60; indiceU1RX_1++){


 if (tramaGPS[indiceU1RX_1] == 0x2C){

 for (indiceU1RX_2 = 0; indiceU1RX_2 < 6; indiceU1RX_2++){
 datosGPS[6 + indiceU1RX_2] = tramaGPS[indiceU1RX_1 + indiceU1RX_2 + 1];
 }
 }
 }


 horaLongGPS = RecuperarHoraGPS(datosGPS);
 fechaLongGPS = RecuperarFechaGPS(datosGPS);



 if (isComuGPS ==  0 ) {
 isComuGPS =  1 ;




 isRecTiempoGPS =  1 ;
#line 1196 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/Digitalizador/Digitalizador/Firmware/Programa dsPIC 2022-05-26/Digitalizador.c"
 horaLongRTC = horaLongGPS;
 fechaLongRTC = fechaLongGPS;
 isActualizarRTC =  1 ;


 U1RXIE_bit = 0;
 }



 if ((horaLongGPS % 3600) == 0) {
 LED = ~LED;




 isRecTiempoGPS =  1 ;
#line 1223 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/Digitalizador/Digitalizador/Firmware/Programa dsPIC 2022-05-26/Digitalizador.c"
 horaLongRTC = horaLongGPS;
 fechaLongRTC = fechaLongGPS;
 isActualizarRTC =  1 ;


 U1RXIE_bit = 0;
 }
 }


 banTIGPS = 0;
 banTCGPS = 0;
 indice_gps = 0;
 }
}
