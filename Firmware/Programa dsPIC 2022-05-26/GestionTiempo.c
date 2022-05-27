
// Libreria para el manejo del tiempo del programa del digitalizador, tanto para
// el tiempo del GPS, del RTC, del sistema y de la RPi

//******************************************************************************
//************************ Declaracion de funciones ****************************
//******************************************************************************
unsigned long PasarHoraToSegundos(unsigned char horas, unsigned char minutos, unsigned char segundos);
void PasarTiempoToVector (unsigned long longHora, unsigned long longFecha, unsigned char *tramaTiempoSistema);
unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS);
unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS);
//******************************************************************************
//********************** Fin Declaracion de funciones **************************
//******************************************************************************


//******************************************************************************
// Metodo para pasar la hora del GPS o RTC, enviando los parametros hora,
// minutos y segundos, a un solo valor long de segundos
//******************************************************************************
unsigned long PasarHoraToSegundos(unsigned char horas, unsigned char minutos, unsigned char segundos) {
     // Variable para almacenar la hora en segundos
     unsigned long horaEnSegundos;
     // Calcula el segundo actual = hh*3600 + mm*60 + ss
     horaEnSegundos = (horas*3600) + (minutos*60) + (segundos);
     return horaEnSegundos;
}
//******************************************************************************
//*********************** Fin Metodo PasarHoraToSegundos ***********************
//******************************************************************************



//******************************************************************************
// Funcion para pasar la hora y la fecha en tipo long a un vector con los indices
// AA MM DD hh mm ss
// Recibe la hora y la fecha en una sola variable tipo long y tambien recibe el
// vector en el que se va a pasar la fecha y hora en 6 posiciones
//******************************************************************************
void PasarTiempoToVector (unsigned long longHora, unsigned long longFecha, unsigned char *tramaTiempoSistema) {
     // Variables para almacenar los 6 valores de tiempo
     unsigned char anio, mes, dia, hora, minuto, segundo;

     // Obtiene las horas, minutos y segundos
     hora = longHora / 3600;
     minuto = (longHora%3600) / 60;
     segundo = (longHora%3600) % 60;

     // Obtiene el año, mes y dia
     anio = longFecha / 10000;
     mes = (longFecha%10000) / 100;
     dia = (longFecha%10000) % 100;

     // Guarda en el vector los datos de tiempo
     tramaTiempoSistema[0] = anio;
     tramaTiempoSistema[1] = mes;
     tramaTiempoSistema[2] = dia;
     tramaTiempoSistema[3] = hora;
     tramaTiempoSistema[4] = minuto;
     tramaTiempoSistema[5] = segundo;
}
//******************************************************************************
//******************** Fin Metodo PasarTiempoToVector **************************
//******************************************************************************


//******************************************************************************
// Metodo para pasar el vector de datos del GPS a una sola variable tipo long
// long con la fecha total en el formato AAMMDD
//******************************************************************************
unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS) {
     // Vector para almacenar el dia, mes y año
     unsigned long tramaFecha[4];
     // Variable para almacenar la fecha completa en el orden AAMMDD
     unsigned long fechaGPS;
     // Vector para almacenar de dos en dos los datos y luego hacer la conversion
     // a entero
     char datoStringF[3];
     // Puntero del vector datoString
     char *ptrDatoStringF = &datoStringF;
     datoStringF[2] = '\0';
     tramaFecha[3] = '\0';

      // Pasa los dos bytes de Dia al vector
     datoStringF[0] = tramaDatosGPS[6];
     datoStringF[1] = tramaDatosGPS[7];
     tramaFecha[0] =  atoi(ptrDatoStringF);

     // Pasa los dos bytes de Mes al vector
     datoStringF[0] = tramaDatosGPS[8];
     datoStringF[1] = tramaDatosGPS[9];
     tramaFecha[1] = atoi(ptrDatoStringF);

     // Pasa los dos bytes de Año al vector
     datoStringF[0] = tramaDatosGPS[10];
     datoStringF[1] = tramaDatosGPS[11];
     tramaFecha[2] = atoi(ptrDatoStringF);

     // Calcula la fecha actual completa = 10000*AA + 100*MM + DD
     fechaGPS = (tramaFecha[2]*10000) + (tramaFecha[1]*100) +  (tramaFecha[0]);

     return fechaGPS;
}

//******************************************************************************
// Metodo para pasar el vector de datos del GPS a una sola variable tipo long
// con los segundos equivalentes. Recibe un vector de 6 datos, dos de la hora,
// dos de los minutos y dos de los segundos (hhmmss)
//******************************************************************************
unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS) {
     // Vector para almacenar las horas, minutos y segundos
     unsigned long tramaTiempo[4];
     // Variable para almacenar la hora completa en segundos
     unsigned long horaGPS;
     // Vector para almacenar de dos en dos los datos y luego hacer la conversion
     // a entero
     char datoString[3];
     // Puntero del vector datoString
     char *ptrDatoString = &datoString;
     datoString[2] = '\0';
     tramaTiempo[3] = '\0';

     // Pasa los dos bytes de Horas al vector
     datoString[0] = tramaDatosGPS[0];
     datoString[1] = tramaDatosGPS[1];
     // Convierte el vector con los dos bytes a entero
     tramaTiempo[0] = atoi(ptrDatoString);

     // Pasa los dos bytes de Minutos al vector
     datoString[0] = tramaDatosGPS[2];
     datoString[1] = tramaDatosGPS[3];
     // Convierte el vector con los dos bytes a entero
     tramaTiempo[1] = atoi(ptrDatoString);

     // Pasa los dos bytes de Segundos al vector
     datoString[0] = tramaDatosGPS[4];
     datoString[1] = tramaDatosGPS[5];
     // Convierte el vector con los dos bytes a entero
     tramaTiempo[2] = atoi(ptrDatoString);

     // Calcula el segundo actual = hh*3600 + mm*60 + ss
     horaGPS = (tramaTiempo[0]*3600) + (tramaTiempo[1]*60) + (tramaTiempo[2]);
     return horaGPS;
}
//******************************************************************************
//*********************** Fin Metodo Recuperar Hora GPS ************************
//******************************************************************************