import tkinter
from tkinter import filedialog
import os
from obspy import read
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
import datetime
import numpy as np


#------------------------------------------------------------------------------
# Funciones
#------------------------------------------------------------------------------

# Función para abrir y leer un archivo mseed
def abrir_archivo_mseed():
    # Abre una ventana para seleccionar el archivo
    root = tkinter.Tk()
    root.withdraw()
    tipos_archivo = (("Archivos mseed", "*.mseed"), ("Todos los archivos", "*.*"))
    root.attributes('-topmost', True)
    root.attributes('-topmost', False)
    currdir = os.getcwd()
    filepath = filedialog.askopenfilename(parent=root, initialdir=currdir, title='Por favor seleccione un archivo', filetypes=tipos_archivo)

    # Lee el archivo mseed y obtiene un objeto Stream
    st = read(filepath)
    return st


def obtener_metadatos(stream):
    # Verifica que el Stream tenga al menos una traza
    if len(stream) == 0:
        raise ValueError("El Stream está vacío. No se pueden obtener los metadatos.")

    # Obtén el tiempo de inicio de la primera traza en el Stream
    tiempo_inicio = stream[0].stats.starttime
    tiempo_fin = stream[0].stats.endtime

    # Extrae la fecha y la hora del tiempo de inicio
    fecha = tiempo_inicio.datetime.date()
    hora_inicio = tiempo_inicio.datetime.time()
    hora_fin = tiempo_fin.datetime.time()
    
    # Obtiene el valor de npts de la primera traza
    npts = stream[0].stats.npts
    
    # Obtiene el nombre de la estación
    station = stream[0].stats.station

    return fecha, hora_inicio, hora_fin, npts, station


def format_fn(value, tick_number, horainicio):
    segundos = int(value)
    milisegundos = int((value - segundos) * 1000)
    tiempo = datetime.datetime.combine(datetime.date.today(), horainicio) + datetime.timedelta(seconds=segundos, milliseconds=milisegundos)
    tiempo_str = tiempo.strftime("%H:%M:%S.%f")[:-3]
    return tiempo_str


def graficar_intervalo(canal, traza1, traza2, inicio_intervalo, duracion):
        
    # Obtiene los metadatos de las trazas
    fecha1, hora_inicio1, hora_fin1, npts1, station1 = obtener_metadatos(traza1)
    fecha2, hora_inicio2, hora_fin2, npts2, station2 = obtener_metadatos(traza2)
    
    # Obtiene las trazas individuales del Stream
    traza1_seleccionada = traza1[canal - 1]
    traza2_seleccionada = traza2[canal - 1]

    # Obtiene los valores de tiempo y amplitud de la traza 1
    tiempo1 = traza1_seleccionada.times()
    amplitud1 = traza1_seleccionada.data
    
    # Obtiene los valores de tiempo y amplitud de la traza 2
    tiempo2 = traza2_seleccionada.times()
    amplitud2 = traza2_seleccionada.data

    # Convierte hora_inicio a segundos
    segundos_inicio_1 = hora_inicio1.hour * 3600 + hora_inicio1.minute * 60 + hora_inicio1.second
    segundos_inicio_2 = hora_inicio2.hour * 3600 + hora_inicio2.minute * 60 + hora_inicio2.second

    # Calcula el tiempo de inicio y final del intervalo de la trama 1
    tiempo_inicio_1 = inicio_intervalo - segundos_inicio_1 
    tiempo_final_1 = tiempo_inicio_1 + duracion
    
    # Calcula el tiempo de inicio y final del intervalo de la trama 2
    tiempo_inicio_2 = inicio_intervalo - segundos_inicio_2 
    tiempo_final_2 = tiempo_inicio_2 + duracion
    
    print(tiempo_inicio_1)
    print(tiempo_final_1)
    print(tiempo_inicio_2)
    print(tiempo_final_2)
    
    # Encuentra los índices que corresponden al intervalo de tiempo de la traza 1
    indice_inicio_1 = int(np.searchsorted(tiempo1, tiempo_inicio_1))
    indice_final_1 = int(np.searchsorted(tiempo1, tiempo_final_1))
    
    # Encuentra los índices que corresponden al intervalo de tiempo de la traza 2
    indice_inicio_2 = int(np.searchsorted(tiempo2, tiempo_inicio_2))
    indice_final_2 = int(np.searchsorted(tiempo2, tiempo_final_2))

    # Extrae el intervalo de tiempo y amplitud para graficar la traza 1
    tiempo_intervalo_1 = tiempo1[indice_inicio_1:indice_final_1]
    amplitud_intervalo_1 = amplitud1[indice_inicio_1:indice_final_1]
    
    # Extrae el intervalo de tiempo y amplitud para graficar la traza 1
    tiempo_intervalo_2 = tiempo2[indice_inicio_2:indice_final_2]
    amplitud_intervalo_2 = amplitud2[indice_inicio_2:indice_final_2]
    
    # Crea una figura con dos subplots
    fig, axs = plt.subplots(2, 1, figsize=(8, 8))
    
    # Grafica el canal x de la traza1 en el primer subplot
    axs[0].plot(tiempo_intervalo_1, amplitud_intervalo_1)
    axs[0].set_ylabel(f'{station1} - Canal {canal}')
    axs[0].grid(True)
    
    # Grafica el canal x de la traza2 en el segundo subplot
    axs[1].plot(tiempo_intervalo_2, amplitud_intervalo_2)
    axs[1].set_ylabel(f'{station2} - Canal {canal}')
    axs[1].set_xlabel('Tiempo (hh:mm:ss:ms)')
    axs[1].grid(True)
    
    # Formatea el eje x para mostrar en formato de horas:minutos:segundos:milisegundos
    axs[0].xaxis.set_major_formatter(FuncFormatter(lambda value, tick_number: format_fn(value, tick_number, hora_inicio1)))
    axs[1].xaxis.set_major_formatter(FuncFormatter(lambda value, tick_number: format_fn(value, tick_number, hora_inicio2)))
    
    # Ajusta el espaciado entre subplots
    plt.tight_layout()
    
    # Muestra la figura
    plt.show()
    
#------------------------------------------------------------------------------
    
# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

# Selecciona y abre el primer archivo mseed
print("Seleccione el primer archivo mseed:")
traza1 = abrir_archivo_mseed()

# Selecciona y abre el segundo archivo mseed
print("Seleccione el segundo archivo mseed:")
traza2 = abrir_archivo_mseed()


canal = 1  # Número de canal a graficar
graficar_intervalo(1, traza2, traza1, 82290, 60)
# -----------------------------------------------------------------------------