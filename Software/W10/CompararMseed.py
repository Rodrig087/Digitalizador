import tkinter
from tkinter import filedialog
import os
from obspy import UTCDateTime, read, Trace, Stream
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
import datetime
from scipy.interpolate import interp1d
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


# def graficar_intervalo(canal, traza, hora_inicio, inicio_intervalo, duracion):
#     # Obtiene la traza seleccionada
#     traza_seleccionada = traza[canal - 1]

#     # Obtiene los valores de tiempo y amplitud de la traza seleccionada
#     tiempo = traza_seleccionada.times()
#     amplitud = traza_seleccionada.data

    
#     # Convierte inicio_intervalo a segundos
#     segundos_inicio_intervalo = inicio_intervalo

#     # Calcula el tiempo de inicio y final del intervalo en segundos
#     tiempo_inicio = segundos_inicio_intervalo
#     tiempo_final = tiempo_inicio + duracion
    
#     print(tiempo_inicio)
#     print(tiempo_final)

#     # Encuentra los índices que corresponden al intervalo de tiempo
#     indice_inicio = int(tiempo.searchsorted(tiempo_inicio))
#     indice_final = int(tiempo.searchsorted(tiempo_final))

#     # Extrae el intervalo de tiempo y amplitud para graficar
#     tiempo_intervalo = tiempo[indice_inicio:indice_final]
#     amplitud_intervalo = amplitud[indice_inicio:indice_final]

#     # Crea una figura y grafica el intervalo de tiempo y amplitud
#     plt.figure(figsize=(10, 6))
#     plt.plot(tiempo_intervalo, amplitud_intervalo)
#     plt.xlabel('Tiempo (s)')
#     plt.ylabel(f'Canal {canal} - {traza_seleccionada.stats.station}')
#     plt.title(f'Intervalo de {duracion} segundos desde las {hora_inicio.strftime("%H:%M:%S")} segundos')

#     # Formatea el eje x utilizando la función format_fn
#     plt.gca().xaxis.set_major_formatter(FuncFormatter(lambda value, tick_number: format_fn(value, tick_number, hora_inicio)))

#     plt.grid(True)
#     plt.show()

def graficar_intervalo(canal, traza, hora_inicio, inicio_intervalo, duracion):
    # Obtiene la traza seleccionada
    traza_seleccionada = traza[canal - 1]

    # Obtiene los valores de tiempo y amplitud de la traza seleccionada
    tiempo = traza_seleccionada.times()
    amplitud = traza_seleccionada.data

    # Convierte hora_inicio a segundos
    segundos_inicio = hora_inicio.hour * 3600 + hora_inicio.minute * 60 + hora_inicio.second

    # Convierte inicio_intervalo a segundos
    segundos_inicio_intervalo = inicio_intervalo

    # Calcula el tiempo de inicio y final del intervalo en segundos
    tiempo_inicio = segundos_inicio_intervalo - segundos_inicio 
    tiempo_final = tiempo_inicio + duracion
    
    
    print(tiempo_inicio)
    print(tiempo_final)
    
    #tiempo_inicio = 0
    #tiempo_final = 60

    # Encuentra los índices que corresponden al intervalo de tiempo
    indice_inicio = int(np.searchsorted(tiempo, tiempo_inicio))
    indice_final = int(np.searchsorted(tiempo, tiempo_final))

    # Extrae el intervalo de tiempo y amplitud para graficar
    tiempo_intervalo = tiempo[indice_inicio:indice_final]
    amplitud_intervalo = amplitud[indice_inicio:indice_final]

    # Crea una figura y grafica el intervalo de tiempo y amplitud
    plt.figure(figsize=(10, 6))
    plt.plot(tiempo_intervalo, amplitud_intervalo)
    plt.xlabel('Tiempo (s)')
    plt.ylabel(f'Canal {canal} - {traza_seleccionada.stats.station}')
    plt.title(f'Intervalo de {duracion} segundos desde las {hora_inicio.strftime("%H:%M:%S")} segundos')

    # Formatea el eje x utilizando la función format_fn
    plt.gca().xaxis.set_major_formatter(FuncFormatter(lambda value, tick_number: format_fn(value, tick_number, hora_inicio)))

    plt.grid(True)
    plt.show()
    
#------------------------------------------------------------------------------
    
# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

# Selecciona y abre el primer archivo mseed
print("Seleccione el primer archivo mseed:")
traza1 = abrir_archivo_mseed()

# Selecciona y abre el segundo archivo mseed
#print("Seleccione el segundo archivo mseed:")
#traza2 = abrir_archivo_mseed()


canal = 1  # Número de canal a graficar
#graficar_trama_mseed(canal, traza1, traza2, 630, 300)

fecha, hora_inicio, hora_fin, npts, station = obtener_metadatos(traza1)

print(fecha)
print(hora_inicio)
print(hora_fin)

graficar_intervalo(1, traza1, hora_inicio, 6, 60)
# -----------------------------------------------------------------------------