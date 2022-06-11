//Libreria para el manejo del tiempo del RTC DS3231

/////////////////////////////////////////// Definicion de registros ///////////////////////////////////////////

#define DS3231_ADDRESS 0xD0
#define DS3231_REG_SEGUNDOS 0x00
#define DS3231_REG_MINUTOS 0x01
#define DS3231_REG_HORAS 0x02
#define DS3231_REG_DIA 0x04
#define DS3231_REG_MES 0x05
#define DS3231_REG_ANIO 0x06
#define DS3231_REG_CONTROL 0x0E
#define DS3231_REG_STATUS 0x0F
#define DS3231_REG_TEMP_MSB 0x11
#define DS3231_REG_TEMP_LSB 0x12

///////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////   Definicion de pines   ///////////////////////////////////////////

#define RTC_I2C_START Soft_I2C_Start
#define RTC_I2C_RESTART Soft_I2C_Start
#define RTC_I2C_WRITE Soft_I2C_Write
#define RTC_I2C_READ Soft_I2C_Read
#define RTC_I2C_STOP Soft_I2C_Stop

///////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////// Definicion de funciones ///////////////////////////////////////////
unsigned char bcd_to_decimal(unsigned char number);
unsigned char decimal_to_bcd(unsigned char number);
void RTC_Write_Reg(unsigned char reg_address, unsigned char reg_value);
unsigned char RTC_Read_Reg(unsigned char reg_address);
void DS3231_init();
void DS3231_setTime(unsigned long longHora, unsigned long longFecha);
unsigned long DS3231_getHour();
unsigned long DS3231_getDate();
///////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////        Funciones        ///////////////////////////////////////////

//Funcion para convertir BCD a decimal
unsigned char bcd_to_decimal(unsigned char number){
     return ( (number >> 4) * 10 + (number & 0x0F) );
}

//Funcion para convertir decimal a BCD
unsigned char decimal_to_bcd(unsigned char number){
     return ( ((number / 10) << 4) + (number % 10) );
}

//Funcion para escribir 'reg_value' en el registro de la direccion 'reg_address'
void RTC_Write_Reg(unsigned char reg_address, unsigned char reg_value){
     RTC_I2C_START();
	 RTC_I2C_WRITE(DS3231_ADDRESS);
	 RTC_I2C_WRITE(reg_address);
	 RTC_I2C_WRITE(reg_value);
	 RTC_I2C_STOP();
}

//Funcion para leer el valor almacenado en el registro de la direccion 'reg_address' 
unsigned char RTC_Read_Reg(unsigned char reg_address){
     unsigned char reg_data;
	 RTC_I2C_START();
	 RTC_I2C_WRITE(DS3231_ADDRESS);
	 RTC_I2C_WRITE(reg_address);
	 RTC_I2C_RESTART();
	 RTC_I2C_WRITE(DS3231_ADDRESS | 0x01);
	 reg_data = RTC_I2C_READ(0);
	 RTC_I2C_STOP();
	 return reg_data;
}

//Funcion para configurar el DS3231
void DS3231_init(){
     RTC_Write_Reg(DS3231_REG_CONTROL, 0x20);  
}

//Funcion para establecer la hora y fecha en el DS3231 
void DS3231_setTime(unsigned long longHora, unsigned long longFecha){
        
     unsigned char hora;
     unsigned char minuto;
     unsigned char segundo;
     unsigned char dia;
     unsigned char mes;
     unsigned char anio;
     
     //Extrae la hora, minuto y segundo de la hora long:
	 hora = (char)(longHora / 3600);
     minuto = (char)((longHora%3600) / 60);
     segundo = (char)((longHora%3600) % 60);
     
	 //Extrae el dia, mes y anio de la fecha long:
	 dia = (char)(longFecha / 10000);
     mes = (char)((longFecha%10000) / 100);
     anio = (char)((longFecha%10000) % 100);

     //Convesion decimal a BCD:
	 segundo = decimal_to_bcd(segundo);
     minuto = decimal_to_bcd(minuto);
     hora = decimal_to_bcd(hora);
     dia = decimal_to_bcd(dia);
     mes = decimal_to_bcd(mes);
     anio = decimal_to_bcd(anio);

     //Escribe en los registros del DS3231:
	 RTC_Write_Reg(DS3231_REG_SEGUNDOS,segundo);
	 RTC_Write_Reg(DS3231_REG_MINUTOS,minuto);
	 RTC_Write_Reg(DS3231_REG_HORAS,hora);
	 RTC_Write_Reg(DS3231_REG_DIA,dia);
	 RTC_Write_Reg(DS3231_REG_MES,mes);
	 RTC_Write_Reg(DS3231_REG_ANIO,anio);
              
}

//Funcion para recuperar la hora del DS3231
unsigned long DS3231_getHour(){
        
     unsigned short valueRead;
     unsigned long hora;
     unsigned long minuto;
     unsigned long segundo;
     unsigned long horaRTC;
     
     valueRead = RTC_Read_Reg(DS3231_REG_SEGUNDOS);
     valueRead = bcd_to_decimal(valueRead);
     segundo = (long)valueRead;
     valueRead = RTC_Read_Reg(DS3231_REG_MINUTOS);
     valueRead = bcd_to_decimal(valueRead);
     minuto = (long)valueRead;
     valueRead = RTC_Read_Reg(DS3231_REG_HORAS);
     valueRead = bcd_to_decimal(valueRead);
     hora = (long)valueRead;

     horaRTC = (hora*3600)+(minuto*60)+(segundo);                               //Calcula el segundo actual = hh*3600 + mm*60 + ss
                  
     return horaRTC;
         
}

//Funcion para recuperar la hora del DS3231
unsigned long DS3231_getDate(){
        
     unsigned short valueRead;
     unsigned long dia;
     unsigned long mes;
     unsigned long anio;
     unsigned long fechaRTC;
     
     valueRead = RTC_Read_Reg(DS3231_REG_DIA);
     valueRead = bcd_to_decimal(valueRead);
     dia = (long)valueRead;
     valueRead = RTC_Read_Reg(DS3231_REG_MES);
     valueRead = bcd_to_decimal(valueRead);
     mes = (long)valueRead;
     valueRead = RTC_Read_Reg(DS3231_REG_ANIO);
     valueRead = bcd_to_decimal(valueRead);
     anio = (long)valueRead;

     fechaRTC = (anio*10000)+(mes*100)+(dia);                                   //10000*aa + 100*mm + dd
                  
     return fechaRTC;
         
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Comentarios:
//Configuracion inicial DS3234:
  //CONTROL = 0x20 = 00100000 : enciende el oscilador y lo configura a 1HZ
  //CONTROL/STATUS = 0x08 = 00001000 (No tiene sentido)