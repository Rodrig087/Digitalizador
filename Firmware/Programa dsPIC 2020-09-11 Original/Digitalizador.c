
// dsPIC30F4013
// Cristal de 12 MHz con HS2 wPLL x16, HS2 = 12/2 = 6MHz
// 6*16 = Frecuencia MCU = 96 MHz
// MIPS = 96/4 = 24 MIPS
// Tcy = 1/MIPS = 41.667 ns

// Cristal de 15 MHz con HS2 wPLL x16, HS2 = 15/2 = 7.5MHz
// 7.5*16 = Frecuencia MCU = 120 MHz
// MIPS = 120/4 = 30 MIPS
// Tcy = 1/MIPS = 33.33 ns


// Incluye la definicion de bool
#include <stdbool.h>
// No es necesario agregar al proyecto los archivos .c, pero sí deben estar en
// la misma carpeta
// Incluye la libreria para gestionar los diferentes tiempos del programa, tanto
// del GPS, del RTC, del Sistema y de la RPi
#include <GestionTiempo.c>
// Incluye las funciones del DS1307
#include <DS1307_Functions.c>


// Incluye la libreria GPS, adicionalmente se debe habilitar las librerias de
// Mikro C del UART y C_Stdlib. No es necesario agregar el archivo al proyecto
// en Mikro C, pero sí tiene que estar en la misma carpeta
//#include <PA6HLib_v1.c>
//#include <TIEMPO_GPS.c>


//******************************************************************************
//************************** Definicion de pines *******************************
//******************************************************************************
// Definicion del pin para generar la interrupcion en la RPI y establecer comunicacion
sbit PIN_RPi at LATF1_bit;
sbit PIN_RPi_DIRECTION at TRISF1_bit;

// Version SIN RESET DE DS1307
// Pin para resetear el DS1307 y sincronizar su pulso con el del GPS. Cuando el
// pin esta en 0 funciona el DS1307 y cuando esta en 1 se apaga
//sbit PIN_RST_DS1307 at LATB1_bit;
//sbit PIN_RST_DS1307_DIRECTION at TRISB1_bit;

// Software I2C connections para el RTC, DS1307. Funciona como RD8 no como LAT
sbit Soft_I2C_Scl at RD2_bit;
sbit Soft_I2C_Sda at RD8_bit;
sbit Soft_I2C_Scl_Direction at TRISD2_bit;
sbit Soft_I2C_Sda_Direction at TRISD8_bit;
// End Software I2C connections

// Leds indicadores
sbit LED_DIRECTION at TRISB0_bit;
sbit LED at LATB0_bit;
sbit LED_2_DIRECTION at TRISD0_bit;
sbit LED_2 at LATD0_bit;
sbit LED_3_DIRECTION at TRISD1_bit;
sbit LED_3 at LATD1_bit;
sbit LED_4_DIRECTION at TRISB8_bit;
sbit LED_4 at LATB8_bit;
//******************************************************************************
//************************ Fin Definicion de pines *****************************
//******************************************************************************



//******************************************************************************
//Declaracion de constantes para la comunicacion entre la RPi y el dsPIC por SPI
//******************************************************************************
// Valor dummy que no interesa, pero sirve para leer los datos del SPI, porque
// hay que enviar uno dummy. Este valor lo envia la RPi para leer datos del dsPIC
#define DUMMY_BYTE 0X00
// Valores de inicio y fin para obtener la operacion que desea el dsPIC
#define INI_OBT_OPE 0XA0
#define FIN_OBT_OPE 0XF0
// Valores de inicio y fin para el envio del tiempo desde el RPi al micro
#define INI_TIME_FROM_RPI 0XA4
#define FIN_TIME_FROM_RPI 0XF4
// Valores de inicio y fin para el envio del tiempo desde el dsPIC a la RPi
#define INI_TIME_FROM_DSPIC 0xA5
#define FIN_TIME_FROM_DSPIC 0XF5
// Valores de inicio y fin para indicar al dsPIC que comience el muestreo
#define INI_INIT_MUES 0XA1
#define FIN_INIT_MUES 0XF1
// Valores de inicio y fin para recibir los bytes de un muestreo desde dsPIC
#define INI_REC_MUES 0XA3
#define FIN_REC_MUES 0XF3
// Indica que se desea enviar bytes de cierto numero de muestreos a la RPi
#define ENV_MUESTRAS 0XB1
// Indica que se desea enviar tanto los bytes de cierto numero de muestreos, junto
// con el tiempo, esto es cada cambio de segundo
#define ENV_MUESTRAS_TIME 0XB2
// Indica que se desea enviar el tiempo del sistema a la RPi
#define ENV_TIME_SIS 0XB3
// Indica que el dsPIC se ha conectado y configurado
#define DSPIC_CONEC 0XB4
// Indica que el GPS esta conectado y se ha recibido los datos
#define GPS_OK 0XB5
// Define las dos fuentes de tiempo del sistema: 1 para GPS y 2 para RTC
#define FUENTE_TIME_GPS 0X01
#define FUENTE_TIME_RTC 0X02

// Numero de bytes por muestra, 5 en total, se consideran los bits de cada variable
// Entonces un dato con los 4 bits de la ganancia y 4 bits MSB CH1, otro dato con
// los 8 bits LSB del CH1, otro dato con los 4 bits MSB de los CH2 y CH3, por ultimo
// dos datos con los 8 bits LSB de los CH2 y CH3
#define numBytesPorMuestra 5
// Numero de bytes a enviar por SPI, si se considera 10 muestreos: 10x5 = 50
//#define numMuestrasEnvio 50
#define numMuestrasEnvio 250
// Bytes de tiempo a recibir, 4 corresponden a la variable de Fecha long y 4 a la Hora long
const unsigned char numBytesTiempo = 8;
// Dimension de los vectores de datos a enviar, debe ser el numMuestrasEnvio + numBytesTiempo
//const unsigned char dimVectores = 58;
const unsigned int dimVectores = 256;
//******************************************************************************
//********************** Fin Declaracion de constantes *************************
//******************************************************************************



//******************************************************************************
//************************ Declaracion de variables ****************************
//******************************************************************************
// Variable con el valor de ganancia por defecto, luego se recibe el valor desde
// la RPi
/* Revisar bien los valores de resistencias
    %GananciaMult   Resistencia   Ganancia
    %   0           7.5         5001
    %   1           7.5         5001
    %   2           10          4001
    %   3           22          2041.82
    %   4           47          1011.10
    %   5           91          535.76
    %   6           180         274.97
    %   7           392         127.74
    %   8           820         61.79
    %   9           1620        31.82
    %   10          3320        16.05
    %   11          6800        8.35
    %   12          16500       4.03
    %   13          49900       2
    %   14          100 000     1.5
    %   15          100 000     1.5
    %Ganancia = 1 + (50 000/(Resistencia + 2.5)) ... el 2.5 es la resistencia
    %interna del multiplexor
*/
unsigned char ganancia = 10;
// Variable que almacena la frecuencia de muestreo, por defecto 100
unsigned char fsample = 100;

// Variable para resetear el watchdog cada 13 segundos
unsigned char contadorWDT = 0;

// Variables que permiten realizar una solicitud de operacion a la RPi
unsigned char bandOperacion, tipoOperacion;
// Variables para la comunicacion con la RPi por SPI
unsigned char bandTimeFromRPi = 0, bandTimeFromDSPIC = 0;
// Variable para trama de comenzar muestreo
unsigned char bandTramaInitMues = 0;

// Vectores para almacenar toda la trama recibida por el GPS y solo la trama de tiempo
unsigned char tramaGPS[70];
unsigned char datosGPS[13];
// Vector para almacenar los datos y transmitirlos por SPI
unsigned char vectorData[dimVectores];
unsigned int contadorMuestras = 0;
// Variable que indica si esta libre o no el vector de datos, T libre y F ocupado
bool isLibreVectorData = true;

// Bandera para establecer la comunicacion SPI para la trama de envio de datos
unsigned char bandTramaRecBytesPorMuestra = 0;
// Bandera de inicio de trama y de trama completa en la recepcion de datos del GPS
unsigned char banTIGPS, banTCGPS;
// Variable para guardar los datos del GPS en el vector
unsigned int indice_gps;
// Variables que indica si el GPS esta o no conectado
bool isPPS_GPS = false, isComuGPS = false, isGPS_Connected = false;
// Variable que indica si se ha recibido o no el tiempo del GPS (esto es la Fecha
// y la Hora, luego cuando ocurre el pulso se debe sincronizar la variable horaGPS
// Esto es porque el GPS devuelve el tiempo un poco antes del pulso)
bool isRecTiempoGPS = false;
// Variables para enviar el estado a la RPi, cuando recien se reciben datos y 
// pulsos del GPS
bool isEnviarGPSOk = false;
// Variable que indica si hay o no que enviar la hora a la RPi. Esta bandera se
// activa cada minuto
bool isEnviarHoraToRPi = false;
// Justo cuando comienza el muestreo, la primera vez es necesario envia el tiempo
// Entonces se tiene esta bandera que se activa con el cambio de minuto del GPS
// y en el main se envia el tiempo
bool isPrimeraVezMuestreo = false;

// Variable que indica cual es la fuente de tiempo considerada para el sistema
// y para enviar el tiempo a la RPi. Si esta conectado el GPS va a ser el GPS,
// pero si se desconecta pasa a ser el RTC. 1 para GPS y 2 para RTC
unsigned char fuenteTiempoSistema = 0;
// Bandera que indica si hay o no que actualizar los datos del reloj a tiempo real
// La otra
bool isActualizarRTC = false;

// Variables para la gestion de la hora total en segundos (de 0 a 86400) y de la 
// fecha tipo long en el orden AAMMDD
unsigned long horaLongSistema = 0, horaLongGPS = 0, horaLongRTC = 0, horaLongRPi = 0;
unsigned long fechaLongSistema = 0, fechaLongGPS = 0, fechaLongRTC = 0, fechaLongRPi = 0;
// Vector de datos con el tiempo del sistema, y del RTC
// El tiempo del sistema se almacenan los 8 bytes de los dos valores tipo long
// En cambio en el tiempo RTC se almacena normalmente YY MM DD hh mm ss
unsigned char vectorTiempoSistema[numBytesTiempo], vectorTiempoRTC[numBytesTiempo];

// Bandera que indica si se esta o no muestreando
bool isMuestreando = false;
// Variable que indica si hay o no que comenzar el muestreo, esta se activa cuando
// se recibe desde la RPi los comandos de inicio. Luego, siempre desde la interrupcion
// al cambio de minuto comienza el muestreo
bool isComienzoMuestreo = false;
//******************************************************************************
//********************** Fin Declaracion de variables **************************
//******************************************************************************



//******************************************************************************
//************************ Declaracion de funciones ****************************
//******************************************************************************
void Setup ();
void InitTimer3();
bool CheckWatchDog ();
void GenerarInterrupcionRPi(unsigned short operacion);
unsigned int LeerCanalADC (unsigned int canal);
//******************************************************************************
//********************** Fin Declaracion de funciones **************************
//******************************************************************************


void main() {
     unsigned char valDummyRec;
     
     // Llama al metodo para realizar las configuraciones
     Setup();
     Delay_ms(500);
     
     // Una vez realizada la configuracion, se realiza una interrupcion a la RPi
     // Para establecer comunicacion e indicar que todo se ha configurado
     GenerarInterrupcionRPi(DSPIC_CONEC);
     // Retardo para que se ejecute la ultima interrupcion y comunicacion con la
     // RPi
     Delay_ms(100);
     
     while (1) {

           // Aumenta la variable de contadorWDT y reinicia el WDT, para evitar
           // que se cuelgue el micro
           contadorWDT ++;
           CheckWatchDog();

           // Siempre envia una sola interrupcion por ciclo, porque no son
           // prioritarias
           // Analiza si esta activa la bandera de enviar al RPi que el GPS esta 
           // Ok, esta bandera se activa apenas el GPS envia datos y el pulso
           if (isEnviarGPSOk == true) {
                 isEnviarGPSOk = false;
                 // Realiza una interrupcion en la RPi para indicar que GPS ok
                 GenerarInterrupcionRPi(GPS_OK);
           // Justo en el tiempo que comienza el muestreo, se debe enviar la Hora
           // a la RPi, esta bandera se activa con el cambio de minuto del GPS
           } else if (isPrimeraVezMuestreo == true) {
                 isPrimeraVezMuestreo = false;
                 // Realiza una interrupcion en la RPi para enviar el tiempo
                 GenerarInterrupcionRPi(ENV_TIME_SIS);
           }

           // Overflow condition para el SPI, hay que leer SPI1BUF
           // SPIROV_bit

           Delay_ms(1);
     }
}

void Setup () {
     // Variable para limpiar el SPI1BUF
     unsigned char valDummyRec;
     
     // Configura todos los pines como digitales
     ADPCFG = 0XFFFF;

     // Como analogicas las señal de entrada, canal 1 (11), canal 2 (10) y canal 3 (9)
     PCFG_11_bit = 0;    PCFG_10_bit = 0;       PCFG_9_bit = 0;
     // Como analogica la señal de referencia (AN12)
     PCFG_12_bit = 0;

     // Configura como entradas las señales, canal 1, canal 2 y canal 3
     TRISB11_bit = 1;   TRISB10_bit = 1;       TRISB9_bit = 1;
     // Configura como entrada la señal de referencia
     TRISB12_bit = 1;

     // Pines controladores de la ganancia del multiplexor como salidas
     TRISB3_bit = 0;     TRISB4_bit = 0;
     TRISB5_bit = 0;     TRISB6_bit = 0;

     // Al inicio coloca el valor de ganancia por defecto
     LATB = (LATB & 0b1110000111) | (0b0001111000 & (ganancia  << 3));

     // Llama al metodo para configurar el Timer3 que realiza el muestreo
     InitTimer3();

     // Configura los leds como salidas
     LED_DIRECTION = 0;
     LED_2_DIRECTION = 0;
     LED_3_DIRECTION = 0;
     LED_4_DIRECTION = 0;
     // Enciende los leds
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
     
     // Como salida el pin para resetear el DS1307 e inicialmente en 1 para que
     // este apagado
//     PIN_RST_DS1307 = 1;
//     PIN_RST_DS1307_DIRECTION = 0;
     
     // Configura el pin para generar la interrupcion en la RPi como salida y en 0
     PIN_RPi = 0;
     PIN_RPi_DIRECTION = 0;
     
     // Limpia la bandera de inicio de trama  del GPS, para la interrupcion U1RX
     banTIGPS = 0;
     // Limpia la bandera de trama completa para la interrupcion U1RX
     banTCGPS = 0;
     // Variable para guardar los datos recibidos por el GPS en el vector
     indice_gps = 0;

     //*************************************************************************
     // Configuracion del SPI y su interrupcion para la comunicacion con la RPi
     //*************************************************************************
     // Inicia el SPI como esclavo
     SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
     // Limpia el buffer del SPI
     valDummyRec = SPI1BUF;
     // Habilita la interrupcion del SPI
     SPI1IE_bit = 1;
     // Limpia la bandera de interrupcion del SPI
     SPI1IF_bit = 0;
     // Prioridad de interrupcion del SPI, del 0 a 7, con 7 mayor prioridad
     IPC2bits.SPI1IP = 7;
     // Limpia la bandera de overflow
     SPIROV_bit = 0;
     // Habilita el SPI
     SPI1STAT.SPIEN = 1;
     //*************************************************************************
     //******* Fin Configuracion del SPI para la comunicacion con la RPi *******
     //*************************************************************************

     //*************************************************************************
     //********************** Configuracion del GPS ****************************
     //*************************************************************************
     //Inicializa el UART1 con una velocidad de 9600 baudios
     UART1_Init(9600);

     // Habilita el GPS, pin Enable como salida y en 1
     LATD3_bit = 1;
     TRISD3_bit = 0;

     ALTIO_bit = 1;
     Delay_ms(100);
     // Habilita la resistencia de pull-up para el pin RX del UART
     CN1PUE_bit = 1;

     // Habilita la interrupcion por UART1 RX
     U1RXIE_bit = 1;
     // Limpia la bandera de interrupcion por UART1 RX
     U1RXIF_bit = 0;
     // Prioridad de la interrupcion UART1 RX, el valor de 7 es el de mayor prioridad
     IPC2bits.U1RXIP = 0x04;
     U1STAbits.URXISEL = 0x00;

     // Con el codigo 220 establece la tasa de actualizacion del tiempo, en ms
     // En este caso cada segundo la interrupcion del UART y la actualizacion del
     // tiempo. El valor de 1F es el check sum, enlace para calcularlo
     // http://www.hhhh.org/wiml/proj/nmeaxor.html
     UART1_Write_Text("$PMTK220,1000*1F\r\n");
     // Tiempo necesario para que haga efecto el cambio de configuracion
     Delay_ms(1000);

     // Configuracion del GPS, se habilita solamnte la trama RMC (Recommended
     // Minimun Specific GNSS Sentence), solo esta en 1, el resto en 0. Contiene
     // datos de hora, fecha, posicionamiento, entre otros.
     UART1_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n");
     Delay_ms(1000);
     
     // Puerto de interrupcion INT0 para el pulso PPS del GPS
     TRISA11_bit = 1;
     RA11_bit = 0;

     // Configuracion de la INT0 como interrupcion por flanco de subida para
     // detectar el pulso de PPS del GPS
     // Configura flanco positivo
     INT0EP_bit = 0;
     // Habilita la interrupcion INT0
     INT0IE_bit = 1;
     // Limpia la bandera de interrupcion
     INT0IF_bit = 0;

     // Prioridad 4
     INT0IP_2_bit = 1;
     INT0IP_1_bit = 0;
     INT0IP_0_bit = 0;
     //*************************************************************************
     //******************** Fin Configuracion del GPS **************************
     //*************************************************************************

     //*************************************************************************
     //*************** Configuracion del reloj a tiempo real *******************
     //*************************************************************************
     // Inicio y configuración del reloj DS1307 (RTC)
     DS1307Inicio();
     
     // Pin RD9 como entrada, para generar una interrupcion del reloj INT2
     TRISD9_bit = 1;         // Como entrada la señal del reloj
     INT2IE_bit = 1;         // Habilita la interrupcion INT2
     INT2IF_bit = 0;         // Limpia la bandera de interrupcion de INT2
     // Interrupcion en el flanco descendente. Tiene que ser en este flanco para
     // que coincidan los pulsos con la lectura del DS1307
     INT2EP_bit = 1;

     // Prioridad de interrupcion 4. La prioridad mas alta es 7
     INT2IP_2_bit = 1;
     INT2IP_1_bit = 0;
     INT2IP_0_bit = 0;
     //*************************************************************************
     //************* Fin Configuracion del reloj a tiempo real *****************
     //*************************************************************************
     
     // Retardo para que hagan efecto todas las configuraciones
     Delay_ms(500);

}

//******************************************************************************
// Funcion para limpiar el WatchDog y evitar que se resetee el PIC
//******************************************************************************
bool CheckWatchDog () {
     if (contadorWDT >= 2){
         contadorWDT = 0;
         asm clrwdt;
         return true;
     } else {
         return false;
     }
}
//******************************************************************************
// Fin CheckWatchDog
//******************************************************************************



//******************************************************************************
// Configuracion del Timer3 - Actual Interrupt Time = 10 ms
// Prescaler 1:8; PR3 Preload = 37500
// FOSC = 120MHz ... 30 MIPS
//******************************************************************************
void InitTimer3() {
//     T3CON = 0x8010;      // Si se quiere que comience encendido
     // Inicialmente apagado el timer3
     T3CON = 0x0010;

     // Activa la interrupcion del timer3 y limpia la bandera de interrupcion
     T3IE_bit = 1;
     T3IF_bit = 0;

     // Coloca en 0 el registro del timer3
     TMR3 = 0;

     // Prioridad alta en 7, la mas alta
     T3IP_2_bit = 1;
     T3IP_1_bit = 1;
     T3IP_0_bit = 1;

     // Preload
     PR3 = 37500;
}
//******************************************************************************
//********************* Fin de la configuracion del Timer 3 ********************
//******************************************************************************



//******************************************************************************
//************ Funcion para realizar la interrupcion en la RPi *****************
//******************************************************************************
void GenerarInterrupcionRPi(unsigned short operacion){
     // Variable para limpiar el SPI1BUF
     unsigned char valDummyRec;
     
     // Si la interrupcion del SPI esta apagada, la enciende
//     if (SPI1IE_bit == 0) {
//          SPI1IE_bit = 1;
          // Tambien limpia la bandera de interrupcion
//          SPI1IF_bit = 0;
//     }
     // Encera la bandera para permitir una nueva peticion de operacion, en la
     // interrupcion del SPI
     bandOperacion = 0; bandTimeFromRPi = 0; bandTimeFromDSPIC = 0;
     // Reiniciar la bandera de interrupcion del envio de las muestras que
     // permite la comunicacion con el SPI, esto es en caso de que haya existido
     // anteriormente algun problema en la comunicacion y la bandera haya quedado
     // activada, dado que se envian tantos datos
     bandTramaRecBytesPorMuestra = 0; bandTramaInitMues = 0;
     
     // Carga en la variable el tipo de operacion requerido
     tipoOperacion = operacion;

     LED_4 = ~LED_4;

     // Analiza si la bandera de overflow del SPI esta activa
     if (SPIROV_bit == 1) {
         
         LED_3 = ~LED_3;
         
         // Limpia la bandera y el buffer
         SPIROV_bit = 0;
         valDummyRec = SPI1BUF;
         // Tambien analiza si la bandera de interrupcion esta activa, en caso
         // afirmativo la limpia
         if (SPI1IF_bit == 1) {
              SPI1IF_bit = 0;
         }
     }
     
//     LED = ~LED;
     
     //Genera el pulso para producir la interrupcion externa en la RPi
     PIN_RPi = 1;
//     Delay_us(20);
     Delay_us(40);
     PIN_RPi = 0;
}
//******************************************************************************
//********** Fin Funcion para realizar la interrupcion en la RPi ***************
//******************************************************************************



//******************************************************************************
// Funcion para leer los datos de los tres canales mediante el ADC
// Recibe como parametro el canal del ADC a leer y devuelve el valor leido por
// el ADC como entero
//******************************************************************************
unsigned int LeerCanalADC (unsigned int canal) {
     unsigned int valADCleido;

     //Configuraciones
     //ADC apagado, Finaliza muestreo y comienza conversion, SSRC = 111
     ADCON1 = 0b0000000011100000;

     //Selecciona el canal a leer, operacion or
     ADCHS = 0X0000 | canal;
//     ADCSSL = 0;                //No scan

     // Minimun TAD = 667 nsec, condicion para una buena conversion
     // MIPS = 24 ... Tcy = 1/24 = 41.667 ns
     // ADCS = 2*(TAD/Tcy) - 1 = 2*(667/41.667) - 1 = 31.015
     // Siempre se redondea al mayor: ADCS = 32
     // TAD = Tcy*0.5*(ADCS + 1)
     //ADCON3 = 0b0000000100100000; //SAMC<4:0> = 1*TAD ... SI ADCS<5:0> = 32 ... si 24 MIPS :: Tcy = 41.667ns y TAD = 687.506nsec ... TiempoConversion: 15*TAD = 15*687.506ns = 10.31 us

     // Minimun TAD = 667 nsec, condicion para una buena conversion
     // MIPS = 30 ... Tcy = 1/30 = 33.333 ns
     // ADCS = 2*(TAD/Tcy) - 1 = 2*(667/33.333) - 1 = 39.02
     // Siempre se redondea al mayor: ADCS = 40
     // TAD = Tcy*0.5*(ADCS + 1) = 683.33ns
     ADCON3 = 0b0000000100101000; //SAMC<4:0> = 1*TAD ... SI ADCS<5:0> = 40 ... si 30 MIPS :: Tcy = 33ns y TAD = 677nsec ... TiempoConversion: 15*TAD = 15*683.33ns = 10.249 us
     
     // Inicia el ADC
     ADON_bit = 1;

     // Lectura
     // Comienza muestreo, termina despues de 7*TAD
     SAMP_bit = 1;

     // Espera que termine la conversion del ADC
     while (DONE_bit == 0) {
           asm nop;
     }
     // Lee del buffer el valor del ADC
     valADCleido = ADCBUF0;
     // Apaga el ADC
     ADON_bit = 0;

     return valADCleido;
}
//******************************************************************************
// Fin LeerCanalADC
//******************************************************************************



//******************************************************************************
// Interrupcion del timer 3 cada 10ms, aqui se realiza la lectura de las tres
// señales y se activa el envio a la RPi
//******************************************************************************
void Timer3Interrupt() iv IVT_ADDR_T3INTERRUPT{
     // Punteros para obtener los bytes MSB y LSB de cada canal
     char *punteroValADC_1, *punteroValADC_2, *punteroValADC_3;
     // Variables para la lectura del ADC de los tres canales
     unsigned int valADC_canal_1, valADC_canal_2, valADC_canal_3;
     // Vector que permite guardar los datos de ganancia, CH1, CH2 y CH3
     // 5 en total porque se considera los bits MSB y LSB
     unsigned char vectorDatos[5];
     // Indice para el bucle for de este metodo
     unsigned char indiceForTimer3;
     // Variable para contar el numero de veces que entra a la interrupcion y cada
     // vez que llega al valor de fsample, significa cambio de segundo. Static
     // porque tiene que mantenerse en las siguientes interrupciones
     static unsigned int contadorFsample = 0;
     // Puntero para obtener los 4 bytes de las variables de tiempo long
     char *punteroLong;
     
     // Limpia la bandera de la interrupcion
     T3IF_bit = 0;
     // Resetea el valor del contador del timer 3
//     TMR3 = 0;

     // Aumenta el contador de fsample
     contadorFsample ++;
     
     // Lee los valores del ADC, canal 1, canal 2 y canal 3
     valADC_canal_1 = LeerCanalADC(11);
     valADC_canal_2 = LeerCanalADC(10);
     valADC_canal_3 = LeerCanalADC(9);

     // Mediante punteros obtiene la direccion de cada variable int de los canales
     punteroValADC_1 = &valADC_canal_1;
     punteroValADC_2 = &valADC_canal_2;
     punteroValADC_3 = &valADC_canal_3;
     
     // Guarda los datos en el vector en el siguiente orden:
     // Como la ganancia es de 4 bits, el ADC tiene resolucion de 12 bits
     // El primer valor corresponde a la Ganancia en los 4 MSB y el valor MSB del
     // canal 1 (4 bits) en los 4 LSB del vectorDatos[0]
     vectorDatos[0] = (ganancia << 4) | *(punteroValADC_1 + 1);
     // El segundo dato corresponde al val LSB del canal 1
     vectorDatos[1] = *punteroValADC_1;
     // El tercer dato corresponde al val MSB del canal 2 y el MSB del canal 3
     vectorDatos[2] = (*(punteroValADC_2 + 1) << 4) | *(punteroValADC_3 + 1);
     // Los datos 4 y 5 corresponde a los valores LSB de los canales 2 y 3
     vectorDatos[3] = *punteroValADC_2;
     vectorDatos[4] = *punteroValADC_3;

     // Guarda los datos
     for (indiceForTimer3 = 0; indiceForTimer3 < numBytesPorMuestra; indiceForTimer3 ++) {
         vectorData[contadorMuestras + indiceForTimer3] = vectorDatos[indiceForTimer3];
     }
     contadorMuestras = contadorMuestras + numBytesPorMuestra;
    

     // Si el contador de muestras es mayor o igual que el numero de muestras a
     // enviar por SPI (esto es cada medio segundo un total de 250 muestras)
     // analiza si hay que enviar con tiempo o no y realiza la peticion a la RPi
     if (contadorMuestras >= numMuestrasEnvio) {
         // Si se completa la frecuencia de muestreo, es decir se ha realizado
         // fsample interrupciones, significa cambio de segundo. Para no perder
         // muestras y que se tengan exactamente las fsample por segundo, apaga
         // el timer y en la interrupcion del GPS (o RTC) se enciende nuevamente
         // Esto se hace porque el timer no es exacto y puede adelantarse un poco
         // y tener una interrupcion justo antes de que haya el pulso del GPS, si
         // pasa esto se tendrian dos muestras practicamente al mismo tiempo
         if (contadorFsample >= fsample) {
             // Reinicia el contador
             contadorFsample = 0;
             // Apaga el timer
             TON_T3CON_bit = 0;
         }
         
         if (isEnviarHoraToRPi == true) {
             // La bandera se resetea al final del envio de datos

             // Guarda en el vector los bytes de la Hora long para realizar el envio
             // a la RPi, dado que este valor puede ser entre 0 y 86400, significa
             // que con enviar los 3 bytes menos significativos es mas que suficiente
             // el ultimo byte siempre va a ser 0 entonces se ahorra el envio
             // Obtiene la direccion de la variable de la hora en segundos
             punteroLong = &horaLongSistema;
             // Guarda en orden de MSB a LSB, desde el tercer byte al primero
             vectorData[numMuestrasEnvio] = *(punteroLong + 2);
             vectorData[numMuestrasEnvio + 1] = *(punteroLong + 1);
             vectorData[numMuestrasEnvio + 2] = *(punteroLong);
             // Asimismo para la fecha
             punteroLong = &fechaLongSistema;
             // Guarda en orden de MSB a LSB, desde el tercer byte al primero
             vectorData[numMuestrasEnvio + 3] = *(punteroLong + 2);
             vectorData[numMuestrasEnvio + 4] = *(punteroLong + 1);
             vectorData[numMuestrasEnvio + 5] = *(punteroLong);
             
             
             // Actualiza las banderas
             isLibreVectorData = false;
    //         contadorFsample = 0;
             contadorMuestras = 0;

    //               LED_2 = ~LED_2;

             // Una vez almacenados los datos en uno de los dos vectores, llama al metodo
             // para generar una interrupcion en la RPi y asi transmitir luego los datos
             // junto con el tiempo
             GenerarInterrupcionRPi(ENV_MUESTRAS_TIME);
         // Caso contrario si se han completado las muestras por enviar, envia
         // solo las muestras
    //     } else if (contadorMuestras >= numMuestrasEnvio) {
         } else {
             // Actualiza la bandera
             isLibreVectorData = false;
             contadorMuestras = 0;

    //               LED_2 = ~LED_2;

             // Una vez almacenados los datos en uno de los dos vectores, llama al metodo
             // para generar una interrupcion en la RPi y asi transmitir luego los datos
             GenerarInterrupcionRPi(ENV_MUESTRAS);
         }
     }
}
//******************************************************************************
// Fin de la interrupcion del Timer 3 que realiza el muestreo
//******************************************************************************



//******************************************************************************
//********** Interrupcion del SPI para comunicacion con la RPi *****************
//******************************************************************************
void interruptSPI1 () org  IVT_ADDR_SPI1INTERRUPT {
     // Variable para recibir el dato del SPI
     unsigned short dataSPI;
     // Variables para la recepcion de datos de tiempo desde la RPi
     // Interesa que sean static, al menos bandTimeFromRPi porque debe conservar
     // su valor en la siguiente entrada al metodo. Solo la primera vez comienza
     // con false
     static unsigned char indiceTimeFromRPi = 0;
     static unsigned char vectorBytesTimeRPi[numBytesTiempo];
     // Variables similares para enviar los datos de tiempo a la RPi
     static unsigned char indiceTimeFromDSPIC = 0;
     // Variables para trama de enviar bytes de varios muestreos
     static unsigned int indiceBytesPorMuestra;
     // Puntero para obtener los 4 bytes de las variables de tiempo long
     char *punteroLong;
     
     // Limpia la bandera de interrupcion
     SPI1IF_bit = 0;
     // Lee el valor recibido en el buffer del SPI
     dataSPI = SPI1BUF;
//     LED_3 = ~LED_3;
     
     //*************************************************************************
     // Analiza si se ha recibido el inicio de operacion, para que el micro
     // envie que operacion desea realizar
     if (bandOperacion == 0 && dataSPI == INI_OBT_OPE) {
//          LED = ~LED;
          // Coloca la bandera para recibir el byte de fin de operacion
          bandOperacion = 1;
          // Carga en el buffer el tipo de operacion que desea
          SPI1BUF = tipoOperacion;
     // Analiza si se ha recibido operacion completada, en este caso resetea las
     // variables
     } else if (bandOperacion == 1 && dataSPI == FIN_OBT_OPE) {
          bandOperacion = 0;
          tipoOperacion = 0;
     }
     //*************************************************************************

     //*************************************************************************
     // Analiza si se ha recibido el inicio de trama para enviar los bytes de
     // un muestreo
     else if (bandTramaRecBytesPorMuestra == 0 && dataSPI == INI_REC_MUES) {
          // Actualiza la bandera
          bandTramaRecBytesPorMuestra = 1;
          // Resetea el indice
          indiceBytesPorMuestra = 0;
          // Primero carga en el buffer el valor de la ganancia para enviar
          // Se tiene que enviar ahora para que la RPi reciba en la proxima comunicacion
          // Analiza si el vector esta lleno de datos
          if (isLibreVectorData == false) {
                SPI1BUF = vectorData[indiceBytesPorMuestra];
                indiceBytesPorMuestra ++;
          }
     // Si la bandera es 1 significa que hay que enviar los bytes de un muestreo
     // O si se recibe el final de trama, termina el envio
     } else if (bandTramaRecBytesPorMuestra == 1) {
          // Si se recibe un DUMMY_BYTE significa enviar
          if (dataSPI == DUMMY_BYTE) {
                // Analiza si el vector esta lleno de datos
                if (isLibreVectorData == false) {
                      SPI1BUF = vectorData[indiceBytesPorMuestra];
                      indiceBytesPorMuestra ++;
                }
          // Si se recibe el fin de trama, hay que resetear las banderas
          } else if (dataSPI == FIN_REC_MUES) {
                // Apaga la interrupcion del SPI
//                SPI1IE_bit = 0;

                // Si el indice es mayor que el numero de muestras a enviar (50)
                // significa que tambien se envio el tiempo, entonces desactiva
                // la bandera
                if (indiceBytesPorMuestra > numMuestrasEnvio) {
                      isEnviarHoraToRPi = false;
                }
                
                // La bandera para recibir en el proximo intento
                bandTramaRecBytesPorMuestra = 0;
                // La bandera del vector que se envio ahora queda libre
                if (isLibreVectorData == false) {
                      isLibreVectorData = true;
                }
          }
     }
     //*************************************************************************
     
     //*************************************************************************
     // Analiza si se ha recibido el inicio de envio de tiempo desde la RPi
     else if (bandTimeFromRPi == 0 && dataSPI == INI_TIME_FROM_RPI) {
          // Actualiza la bandera, para que desde el siguiente dato se guarde
          bandTimeFromRPi = 1;
          // Tambien el indice para guardar en el vector
          indiceTimeFromRPi = 0;
     // Si esta activada la bandera, significa que se esta recibiendo los datos
     // del tiempo
     } else if (bandTimeFromRPi == 1) {
          // Si no es el final de trama, significa que son datos de tiempo y los
          // va almacenando. Se reciben los bytes de los dos valores de tiempo
          if (dataSPI != FIN_TIME_FROM_RPI) {
                vectorBytesTimeRPi[indiceTimeFromRPi] = dataSPI;
                indiceTimeFromRPi ++;
          // Si se recibe el final de trama de recepcion de tiempo desde la RPi
          } else {
                // Resetea la bandera para recibir datos en un futuro
                bandTimeFromRPi = 0;

                // Coloca los bytes en las dos variables de tiempo tipo long
                // Obtiene la direccion de la variable fechaLongRPi
                punteroLong = &fechaLongRPi;
                // Carga los valores desde el MSB al LSB
                *(punteroLong + 3) = vectorBytesTimeRPi[0];
                *(punteroLong + 2) = vectorBytesTimeRPi[1];
                *(punteroLong + 1) = vectorBytesTimeRPi[2];
                *(punteroLong) = vectorBytesTimeRPi[3];
                
                // De forma similar para la hora
                // Obtiene la direccion de la variable fechaLongRPi
                punteroLong = &horaLongRPi;
                // Carga los valores desde el MSB al LSB
                *(punteroLong + 3) = vectorBytesTimeRPi[4];
                *(punteroLong + 2) = vectorBytesTimeRPi[5];
                *(punteroLong + 1) = vectorBytesTimeRPi[6];
                *(punteroLong) = vectorBytesTimeRPi[7];

                // Comprueba si el GPS no esta conectado, en este caso se considera
                // el tiempo recibido como el tiempo del sistema y del RTC
                if (isGPS_Connected == false) {
                      // Actualiza el tiempo del sistema
                      fechaLongSistema = fechaLongRPi;
                      horaLongSistema = horaLongRPi;
                      // Actualiza el tiempo del RTC
                      fechaLongRTC = fechaLongRPi;
                      horaLongRTC = horaLongRPi;
                      // Activa la bandera para actualizar los datos del RTC
                      isActualizarRTC = true;
                      // Tambien considera la fuente de tiempo del sistema como del RTC
                      fuenteTiempoSistema = FUENTE_TIME_RTC;
                }
          }
     }
     //*************************************************************************
     
     //*************************************************************************
     // Analiza si se ha recibido el inicio de envio de tiempo desde el dsPIC
     else if (bandTimeFromDSPIC == 0 && dataSPI == INI_TIME_FROM_DSPIC) {
          // Actualiza la bandera, para que desde la siguiente interrupcion se
          // envie el tiempo
          bandTimeFromDSPIC = 1;
          // Tambien encera el indice para recorrer vector de tiempo
          indiceTimeFromDSPIC = 0;
          // Envia la fuente de tiempo, 1 para GPS y 2 para RTC
          SPI1BUF = fuenteTiempoSistema;
          // Obtiene los 4 bytes de las variables de tiempo long del sistema
          // Y las guarda en el vector. Primero la fecha
          punteroLong = &fechaLongSistema;
          // En orden de MSB a LSB
          vectorTiempoSistema[0] = *(punteroLong + 3);
          vectorTiempoSistema[1] = *(punteroLong + 2);
          vectorTiempoSistema[2] = *(punteroLong + 1);
          vectorTiempoSistema[3] = *(punteroLong);
          // Luego la hora en segundos
          // En orden de MSB a LSB
          punteroLong = &horaLongSistema;
          vectorTiempoSistema[4] = *(punteroLong + 3);
          vectorTiempoSistema[5] = *(punteroLong + 2);
          vectorTiempoSistema[6] = *(punteroLong + 1);
          vectorTiempoSistema[7] = *(punteroLong);
     // Si la bandera es 1 significa que hay que enviar los 8 bytes de las dos
     // variables del tiempo. O si es el fin de envio, hay que resetear las banderas
     } else if (bandTimeFromDSPIC == 1) {
          // Si el byte recibido es dummy byte (0X00) significa enviar
          if (dataSPI == DUMMY_BYTE) {
                SPI1BUF = vectorTiempoSistema[indiceTimeFromDSPIC];
                indiceTimeFromDSPIC ++;
          // Si el byte es fin de envio, resetea la bandera
          } else if (dataSPI == FIN_TIME_FROM_DSPIC) {
                bandTimeFromDSPIC = 0;
          }
     }
     //*************************************************************************
     
     //*************************************************************************
     // Analiza si se ha recibido el inicio de trama para comenzar el muestreo
     else if (bandTramaInitMues == 0 && dataSPI == INI_INIT_MUES) {
          // Cambia la bandera
          bandTramaInitMues = 1;
          // Activa la bandera para comenzar el muestreo. Luego el muestreo se
          // inicia justo al cambio de minuto
          isComienzoMuestreo = true;
          
     // Si recibe el final de trama para comenzar el muestreo, resetea la bandera
     } else if (bandTramaInitMues == 1) {
          bandTramaInitMues = 0;
     }
     //*************************************************************************
}
//******************************************************************************
//********* Fin Interrupcion del SPI para comunicacion con la RPi **************
//******************************************************************************


//******************************************************************************
//****************** Interrupcion externa INT0 del PPS del GPS *****************
// En el pin RA11 con cada cambio de estado se produce una interrupcion, para
// sincronizar el reloj y la adquisicion de los datos
//******************************************************************************
void ExternalInterrupt0_GPS() org IVT_ADDR_INT0INTERRUPT{
     // Limpia la bandera de interrupcion
     INT0IF_bit = 0;
//     LED_2 = ~LED_2;
     
     // Si esta en false la bandera, la actualiza
     if (isPPS_GPS == false) {
          isPPS_GPS = true;
          // Ademas, si aun no se ha actualizado la bandera de GPS conectado y
          // ya se recibieron datos del mismo, la actualiza
          if (isGPS_Connected == false && isComuGPS == true) {
               isGPS_Connected = true;
               // Tambien actualiza la bandera para enviar al RPi que el GPS esta Ok
               isEnviarGPSOk = true;
               // Actualiza la fuente de tiempo del sistema como la del GPS
               fuenteTiempoSistema = FUENTE_TIME_GPS;
          }
     }

     // Si esta activa la bandera de tiempo recibido del GPS, significa que justo
     // se recibio la informacion del tiempo y hay que mantener este valor porque
     // con el pulso se sincroniza. Además, actualiza todos los tiempos del sistema
     // y del RTC
     if (isRecTiempoGPS == true) {
          // Limpia la bandera
          isRecTiempoGPS = false;

          // Actualiza la hora del sistema con estos datos
          horaLongSistema = horaLongGPS;
          fechaLongSistema = fechaLongGPS;
          // Actualiza la fuente de tiempo del sistema como la del GPS
          fuenteTiempoSistema = FUENTE_TIME_GPS;
          
     // Caso contrario, significa que hay que incrementar la Hora el GPS
     } else {
          // Aumenta en 1 los segundos del dia
          horaLongGPS ++;
     }

     // Si se completa el dia (HH*3600) reinicia el contador
     if (horaLongGPS == 86400) {
          horaLongGPS = 0;
     }
}
//******************************************************************************
//**************** Fin Interrupcion externa INT0 del PPS del GPS ***************
//******************************************************************************



//******************************************************************************
// Interrupcion externa INT2 para los pulsos del RTC - DS1307
// En el pin RD9 con cada cambio de estado se produce una interrupcion, para
// sincronizar el reloj y la adquisicion de los datos cuando no esta el GPS
//******************************************************************************
void ExternalInterrupt2_RTC() org IVT_ADDR_INT2INTERRUPT{
     // Limpia la bandera de interrupcion
     INT2IF_bit = 0;
     
     LED_2 = ~LED_2;

     // Analiza si esta activa la bandera para actualizar el tiempo del RTC
     // Esto ocurre solo al inicio cuando se conecta el GPS o cada vez que hay
     // cambio de dia
     if (isActualizarRTC == true) {
          isActualizarRTC = false;
          // Pasa los datos de tiempo de variables long a un vector, para
          // poder actualizar el DS1307
          PasarTiempoToVector(horaLongRTC, fechaLongRTC, vectorTiempoRTC);
          // Actualiza todos los parametros del RTC
          DS1307SetAnos(vectorTiempoRTC[0]);
          DS1307SetMeses(vectorTiempoRTC[1]);
          DS1307SetFechas(vectorTiempoRTC[2]);
          DS1307SetHoras(vectorTiempoRTC[3]);
          DS1307SetMinutos(vectorTiempoRTC[4]);
          DS1307SetSegundos(vectorTiempoRTC[5]);
     // Caso contrario continua con el incremento del tiempo en segundos
     } else {
          // Aumenta en 1 los segundos del dia
          horaLongRTC ++;
     }

     // Si se completa el dia (HH*3600) reinicia el contador
     if (horaLongRTC == 86400) {
          horaLongRTC = 0;
     }

     // Si el resto de la Hora es igual a 86390, significa que faltan 10 segundos
     // para que haya cambio de dia. Además, si la fuente del sistema es del GPS
     // entonces activa la interrupcion para recibir los datos de Hora desde el Uart
     // De esta forma se actualizan los datos de tiempo y se sincroniza nuevamente
     // el reloj RTC, porque este se atrasa o adelanta
     if (horaLongGPS == 86390 && fuenteTiempoSistema == FUENTE_TIME_GPS) {
          // Activa la interrupcion del GPS
          U1RXIE_bit = 1;
     }

     // Actualiza la hora del sistema
     horaLongSistema = horaLongRTC;

     // Si esta activa la bandera para comenzar el muestreo
     if (isComienzoMuestreo == true) {
           // Se activa la variable isMuestrear solo al cambio de minuto
           if (isMuestreando == false && (horaLongRTC % 60) == 0) {
                isMuestreando = true;
                // En este caso tambien desactiva la de isComienzoMuestreo
                isComienzoMuestreo = false;
                // La primera vez no se envia la Hora desde la interrupcion
                // del timer 3, sino desde el main, entonces activa la bandera
                isPrimeraVezMuestreo = true;
           }
     }
     // Si esta activada la bandera de muestrear, enciende el timer en caso
     // de que este apagado, activa una interrupcion para comenzar el muestreo
     if (isMuestreando == true) {
            // Si hay cambio de minuto activa la bandera de envio de Hora
            // Excepto la primera vez que debe ser desde el main
            if ((horaLongRTC % 60) == 0 && isPrimeraVezMuestreo == false) {
                isEnviarHoraToRPi = true;

//                LED_2 = ~LED_2;
            }

            // Si esta apagado encience el timer 3, esto sera la primera vez
            // solo cuando comienza el muestreo
            if (TON_T3CON_bit == 0) {
                 TON_T3CON_bit = 1;
            }
            // Resetea el valor del timer 3
            TMR3 = 0;
            // Activa una interrupcion del timer3, xq se desea que ahora
            // comience el muestreo y asi evitar la perdida de muestras
            T3IF_bit = 1;
     }
}
//******************************************************************************
//********** Fin Interrupcion externa INT2 de los pulsos del RTC ***************
//******************************************************************************
     
     
//******************************************************************************
//******** Interrupcion del UART1 para recepcion de datos del GPS **************
//******************************************************************************
void interruptU1RX() iv IVT_ADDR_U1RXINTERRUPT {
     unsigned char byteGPS, indiceU1RX_1, indiceU1RX_2;
     
     // Limpia la bandera de interrupcion por UART
     U1RXIF_bit = 0;
     // Lee el dato recibido
     byteGPS = U1RXREG;                                                                                                                                                                                                                                       //Lee el byte de la trama enviada por el GPS
     //Limpia el FIFO UART
     OERR_bit = 0;
     
     if (banTIGPS == 0){
        // Verifica si el primer byte recibido es el simbolo "$" que indica el 
        // inicio de una trama GPS
        if ((byteGPS == 0x24) && (indice_gps == 0)){
             // Activa la bandera de inicio de trama
             banTIGPS = 1;
        }
     }

     if (banTIGPS == 1){
          // Verifica si no es el ultimo dato de la trama, 0x2A = "*". En este
          // caso recibe los datos y los almacena en la trama
          if (byteGPS != 0x2A){
               // LLena la tramaGPS hasta recibir el ultimo simbolo ("*") de la trama GPS
               tramaGPS[indice_gps] = byteGPS;
               // Incrementa el valor del subindice mientras sea menor a 70
               if (indice_gps < 70){
                     indice_gps ++;
               }
               // Dado que se configuro RMC (los valores minimos), verifica si
               // los siguientes datos despues de $ no son GPRMC, G = 0x47, 
               // P = 0x50, R = 0x52, M = 0x4D y C = 0x43. Si no son reinicia
               // las banderas porque no nos interesa seguir recibiendo datos
               if ((indice_gps > 5) && (tramaGPS[1] != 0x47) && (tramaGPS[2] != 0x50)  && (tramaGPS[3] != 0x52)  && (tramaGPS[4] != 0x4D)  && (tramaGPS[5] != 0x43)) {
                     //Limpia el subindice para almacenar la trama desde el principio
                     indice_gps = 0;
                     //Limpia la bandera de inicio de trama
                     banTIGPS = 0;
                     //Limpia la bandera de trama completa
                     banTCGPS = 0;
               }
          // Si es que es el simbolo '*', significa que termino la trama
          } else {
               tramaGPS[indice_gps] = byteGPS;
               // Cambia el estado de la bandera de inicio de trama para no 
               // permitir que se almacene mas datos en la trama
               banTIGPS = 2;
               // Activa la bandera de trama completa
               banTCGPS = 1;
          }
     }

     // Si ya se completo la trama RMC, valida que los datos sean correctos y los
     // almacena
     if (banTCGPS == 1) {
        // Verifica que el caracter en la posicion 18 sea igual a "A = 0x41", lo
        // cual valida los datos en el caso de trabajar con RMC
        if (tramaGPS[18] == 0x41) {
//           LED = ~LED;

           // Los 7 primeros datos son fijos: $GPRMC,
           // Luego vienen los 6 datos de la hora
           for (indiceU1RX_1 = 0; indiceU1RX_1 < 6; indiceU1RX_1++){
               // Guarda los datos de hhmmss
               datosGPS[indiceU1RX_1] = tramaGPS[7+indiceU1RX_1];
           }

           for (indiceU1RX_1 = 50; indiceU1RX_1 < 60; indiceU1RX_1++){
               // Busca el simbolo "," a partir de la posicion 50. Despues de
               // este simbolo vienen los datos de fecha
               if (tramaGPS[indiceU1RX_1] == 0x2C){
                   // Guarda los datos de DDMMAA en la trama datosGPS
                   for (indiceU1RX_2 = 0; indiceU1RX_2 < 6; indiceU1RX_2++){
                       datosGPS[6 + indiceU1RX_2] = tramaGPS[indiceU1RX_1 + indiceU1RX_2 + 1];
                   }
               }
           }

           // Recupera la hora y la fecha del GPS en una sola variable
           horaLongGPS = RecuperarHoraGPS(datosGPS);
           fechaLongGPS = RecuperarFechaGPS(datosGPS);
           
           // Si esta en false la bandera, la actualiza. Esto es para indicar que
           // si esta conectado y comunicado el GPS
           if (isComuGPS == false) {
                isComuGPS = true;
                
                // Activa la bandera para actualizar el tiempo del GPS en el siguiente
                // pulso de interrupcion, esto es porque el valor se recibe antes
                // que el pulso
                isRecTiempoGPS = true;
                
                // Ademas, si aun no se ha actualizado la bandera de GPS conectado y
                // ya se recibieron pulsos (PPS), la actualiza
/*                if (isGPS_Connected == false && isPPS_GPS == true) {
                     isGPS_Connected = true;
                     // Tambien actualiza la bandera para enviar al RPi que el GPS esta Ok
                     isEnviarGPSOk = true;
                     // Actualiza la fuente de tiempo del sistema como la del GPS
                     fuenteTiempoSistema = FUENTE_TIME_GPS;
                }
                // Actualiza la hora del sistema con estos datos
                horaLongSistema = horaLongGPS;
                fechaLongSistema = fechaLongGPS;
*/
               // Tambien actualiza la Hora del RTC y activa la bandera para su
               // actualizacion. Esto si deja para que se actualice con el siguiente
               // pulso del RTC
               horaLongRTC = horaLongGPS;
               fechaLongRTC = fechaLongGPS;
               isActualizarRTC = true;

                // Desactiva la interrupcion del UART del GPS
                U1RXIE_bit = 0;
           }

           // Comprueba que haya cambio de Hora para desactivar la interrupcion
           // y actualizar la Hora del sistema
           if ((horaLongGPS % 3600) == 0) {
               LED = ~LED;

               // Activa la bandera para actualizar el tiempo del GPS en el siguiente
               // pulso de interrupcion, esto es porque el valor se recibe antes
               // que el pulso
               isRecTiempoGPS = true;
/*
               // Actualiza la hora del sistema con estos datos
               horaLongSistema = horaLongGPS;
               fechaLongSistema = fechaLongGPS;
               // Actualiza la fuente de tiempo del sistema como la del GPS
               fuenteTiempoSistema = FUENTE_TIME_GPS;
*/
               // Tambien actualiza la Hora del RTC y activa la bandera para su
               // actualizacion. Esto si deja para que se actualice con el siguiente
               // pulso del RTC
               horaLongRTC = horaLongGPS;
               fechaLongRTC = fechaLongGPS;
               isActualizarRTC = true;

               // Desactiva la interrupcion del UART del GPS
               U1RXIE_bit = 0;
           }
        }

        // Reinicia la bandera de inicio de trama, para recibir nuevas tramas
        banTIGPS = 0;
        banTCGPS = 0;
        indice_gps = 0;
     }
}
//******************************************************************************
//******* Fin Interrupcion del UART1 para recepcion de datos del GPS ***********
//******************************************************************************