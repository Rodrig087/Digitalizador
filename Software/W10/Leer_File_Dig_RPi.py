# -*- coding: utf-8 -*-
"""
Created on May 20 2020

@author: Ivan Palacios
"""

# Programa que lee los archivos binarios generados por la RPi del digitalizador 
# de 3 componentes

import tkinter
from tkinter import filedialog
import os
import struct
import math, time

fSample = 100
# Factor de conversion, si se coloca en 1 significa que no se aplica ningun factor
# y guarda un archivo de texto con 4 columnas de datos (ganancia, CH1, CH2, CH3)
# y todos como enteros
# Pero si se coloca el factor de conversion, se aplica a los datos y solo guarda 
# los tres canales en tres columnas como punto flotante. Siempre se guarda una
# primera columna con el tiempo
factor_conversion = 52428.8
factor_conversion = 1

# Obtiene el tiempo de inicio del programa en micro segundos
tiempoInicio = int(round(time.time()*1000000))

root = tkinter.Tk()
root.withdraw() # Use to hide tkinter window

# Definir los tipos de archivo y sus extensiones correspondientes
tipos_archivo = (
    ("Archivos binarios", "*.dat"),
    ("Archivos de texto", "*.txt"),
    ("Todos los archivos", "*.*")
)

# Establecer atributos de la ventana de selección de archivos
root.attributes('-topmost', True)
root.attributes('-topmost', False)

currdir = os.getcwd()
filepath = filedialog.askopenfilename(parent = root, initialdir = currdir, title = 'Please select a file', filetypes=tipos_archivo)

# Realiza la lectura si se ha seleccionado un archivo
if filepath:
    print ("Archivo ", filepath)
    # Obtiene el nombre del archivo
    vectorFilepath = filepath.split('/')
    # El nombre esta en la ultima posicion
    fileNameExt = vectorFilepath[len(vectorFilepath) - 1]
    # Quita la extension porque no interesa
    fileName = fileNameExt[0 : (len(fileNameExt) - 4)]
    print(fileName)
    # Este es el tiempo de inicio
    anio = int(fileName[0:2])
    mes = int(fileName[2:4])
    dia = int(fileName[4:6])
    horas = int(fileName[6:8])
    minutos = int(fileName[8:10])
    contadorMinutosOk = minutos
    segundos = int(fileName[10:12])
    segundosAnt = segundos
    contadorSegundosOk = segundos
    print ('Hora Inicio ', anio, ' ', mes, ' ', dia, ' ', horas, ' ', minutos, ' ', segundos)
    
    # Los valores de AAMMDD en una sola variable corresponden a la cabecera
    fechaLong = 10000*anio + 100*mes + dia
    print('Fecha long ', fechaLong)
    
    # Abre el archivo para lectura de binarios "rb"
    objFile = open(filepath, "rb")
    
    # Lee el total de bytes del archivo, se guarda en un array de bytes
    bytesLeidos = objFile.read()
    numTotalBytes = len(bytesLeidos)
    
    # Se convierte el array de bytes a numeros, cada byte a numero
    # Primero se establece el formato, se debe incluir el total de bytes y B
    # corresponde a unsigned char (entero de 8 bits)
    formatoUnpack = '<' + str(numTotalBytes) + 'B'
    print (formatoUnpack)
    # Realiza la conversión de array de bytes a lista de enteros
    vectorDatos = struct.unpack(formatoUnpack, bytesLeidos)
    numTotalDatos = len(vectorDatos)
    print ('Total datos ', numTotalDatos)

    # Abre o crea el archivo de texto para almacenar los datos en punto flotante
    # en modo append para no borrar los datos anteriores
    fileTxt = open((fileName + ".txt"), "a+")
     
    # Recorre todos los bytes, hasta -15 porque siempre se necesitan al menos 
    # 8 bytes para registrar el tiempo y 7 de datos
    indiceDatos = 0
    while indiceDatos < (numTotalDatos - 8):
        # Se analiza si los 4 numeros siguientes son la cabecera (debe ser la fecha)
        valCuatroDatos = vectorDatos[indiceDatos] << 24 | vectorDatos[indiceDatos + 1] << 16 | vectorDatos[indiceDatos + 2] << 8 | vectorDatos[indiceDatos + 3]
        # Analiza si es igual a la fecha (que es la cabecera)
        if valCuatroDatos == fechaLong:
#            print("Fecha Ok indice ", indiceDatos)
            # Los cuatro siguientes datos son de la hora en segundos
            horaSegundos = vectorDatos[indiceDatos + 4] << 24 | vectorDatos[indiceDatos + 5] << 16 | vectorDatos[indiceDatos + 6] << 8 | vectorDatos[indiceDatos + 7]
            # Actualiza el indiceDatos sumando los 8 datos
            indiceDatos += 8
            # Coloca una bandera para leer los siguientes datos que son las 
            # muestras, hasta que aparezca de nuevo una cabecera
            banderaDatos = True
            contadorMuestreos = 0
            while banderaDatos == True:
                # Si los 4 primeros valores coinciden con la fecha, significa
                # cambio de minuto
                valCuatroDatos = vectorDatos[indiceDatos] << 24 | vectorDatos[indiceDatos + 1] << 16 | vectorDatos[indiceDatos + 2] << 8 | vectorDatos[indiceDatos + 3]                    
                # Si es la fecha, sale del bucle 
                if valCuatroDatos == fechaLong:
                    banderaDatos = False
                # Caso contrario almacena los 7 datos en los vectores mas el 
                # tiempo y cada vez que se completa los datos igual a la fsample
                # aumenta en 1 la hora segundos
                else:                    
                    # La ganancia corresponde a los 4 bits MSB del primer valor, 
                    # entonces se elimina los 4 bits LSB
                    ganancia = vectorDatos[indiceDatos] >> 4;
                    # EL canal 1 esta dividido: los 4 bits MSB en el primer dato 
                    # (parte LSB) y los 8 bits LSB en el segundo dato
                    valCH1 = ((vectorDatos[indiceDatos] & 0X0F) << 8) | vectorDatos[indiceDatos + 1];
                    # EL canal 2 esta dividido: los 4 bits MSB en el tercer dato 
                    # (parte MSB) y los 8 bits LSB en el cuarto dato
                    valCH2 = ((vectorDatos[indiceDatos + 2] >> 4) << 8) | vectorDatos[indiceDatos + 3];
                    # EL canal 3 esta dividido: los 4 bits MSB en el tercer dato 
                    # (parte LSB) y los 8 bits LSB en el quinto dato
                    valCH3 = ((vectorDatos[indiceDatos + 2] & 0X0F) << 8) | vectorDatos[indiceDatos + 4];
                    # Guarda todos los datos
                    # Si el factor de conversion es 1, guarda una columna adicional 
                    # de la ganancia y todo como enteros
                    if factor_conversion == 1:
                        #fileTxt.write("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\r" %(horaSegundos, vectorDatos[indiceDatos], vectorDatos[indiceDatos + 1], vectorDatos[indiceDatos + 2], vectorDatos[indiceDatos + 3], vectorDatos[indiceDatos + 4], vectorDatos[indiceDatos + 5], vectorDatos[indiceDatos + 6]))
                        fileTxt.write("%d\t%d\t%d\t%d\t%d\r" %(horaSegundos, ganancia, valCH1, valCH2, valCH3))
                    # Caso contrario, aplica el factor de conversion y guarda solo 
                    # las 3 columnas de los 3 canales en punto flotante
                    else:
                        valCH1 = valCH1/factor_conversion
                        valCH2 = valCH2/factor_conversion
                        valCH3 = valCH3/factor_conversion
                        fileTxt.write("%d\t%f\t%f\t%f\r" %(horaSegundos, valCH1, valCH2, valCH3))
                    # Aumenta el indice en 5, que es el num datos por muestra
                    indiceDatos += 5
                    # Si el numero de datos es mayor que el total - 5 significa 
                    # que se han terminado los datos
                    if indiceDatos > (numTotalDatos - 5):
                        banderaDatos = False
                    
                    # Aumenta el contador de muestreos y si es igual a la 
                    # fsample significa que hay que aumentar en 1 los segundos
                    contadorMuestreos += 1
                    if contadorMuestreos == fSample:
                        horaSegundos += 1
                        contadorMuestreos = 0
        else:
            # Cada 1000 datos muestra el mensaje. Hay que mencionar que 1 segundo
            # tiene 30000 datos
            if indiceDatos%1000 == 0:
                print ("Fecha error ", valCuatroDatos, " indice ", indiceDatos)
#            time.sleep(1)
            indiceDatos += 1
#        print (indiceDatos)
        
    # Cierra el archivo de texto de escritura    
    fileTxt.close()
            
    # Al final cierra el archivo de lectura
    objFile.close()
    
    tiempoFin = int(round(time.time()*1000000))
    print ('Tiempo lectura en us ', (tiempoFin - tiempoInicio))    