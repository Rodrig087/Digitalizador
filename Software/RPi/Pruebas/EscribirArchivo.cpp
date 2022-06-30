//g++ /home/rsa/Programas/EscribirArchivo.cpp -o /home/rsa/Ejecutables/escribirarchivo 

//*************************************************************************************************
// Librerias
//*************************************************************************************************
#include <iostream>
#include <chrono>

// Libreria para gestionar el tiempo: time_t, struct tm, time, localtime
#include <time.h>
#include <string>

using namespace std;
//*************************************************************************************************
// Fin Librerias
//*************************************************************************************************

//*************************************************************************************************
// Declaracion de variables
//*************************************************************************************************
// Objeto tipo File para el archivo donde se guardan las lecturas instantaneas del canal
FILE *fTmpCanal;
//*************************************************************************************************
// Fin Declaracion de variables
//*************************************************************************************************

//*************************************************************************************************
// Declaracion de funciones
//*************************************************************************************************
void GuardarDatosCanal(unsigned int valCH1, unsigned int valCH2, unsigned int valCH3);
//*************************************************************************************************
// Fin Declaracion de funciones
//*************************************************************************************************

//*************************************************************************************************
// Metodo principal
//*************************************************************************************************
int main(void)
{
	cout << "Inicio Programa" << endl;
	
	//Prueba
    GuardarDatosCanal(2000, 3000, 4000);
}
//*************************************************************************************************
// Fin Metodo principal
//*************************************************************************************************

//*************************************************************************************************
// Metodo para guardar los datos temporales de los 3 canales
//*************************************************************************************************
void GuardarDatosCanal(unsigned int valCH1, unsigned int valCH2, unsigned int valCH3)
{

    unsigned int vectorDatosCanal[3];
    unsigned int numDatosGuardados;

    vectorDatosCanal[0] = valCH1;
    vectorDatosCanal[1] = valCH2;
    vectorDatosCanal[2] = valCH3;
	
	cout << "Dato 1: " << valCH1 << endl;
	cout << "Dato 2: " << valCH2 << endl;
	cout << "Dato 3: " << valCH3 << endl;

    fTmpCanal = fopen("/home/rsa/TMP/temporalCanal.txt", "w");

    if (fTmpCanal != NULL)
    {
        // Bucle hasta que se guarden todos los bytes
        do
        {
            // Guarda el vector de datos, siempre deben ser tipo char (ese es el tamaño configurado)
            numDatosGuardados = fwrite(vectorDatosCanal, sizeof(int), 3, fTmpCanal);
            //            cout << "Datos guardados " << to_string(datosGuardadosFwrite) << endl;
        } while (numDatosGuardados != 3);
        // Flush
        fflush(fTmpCanal);
    }
	
	fclose(fTmpCanal);
}
//*************************************************************************************************
// Fin Metodo para guardar los datos temporales de los 3 canales
//*************************************************************************************************