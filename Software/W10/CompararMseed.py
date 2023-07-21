import tkinter
from tkinter import filedialog
import os
from obspy import UTCDateTime, read, Trace, Stream
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
import datetime
from scipy.interpolate import interp1d

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


def obtener_fecha_hora_desde_metadatos(stream):
    # Verifica que el Stream tenga al menos una traza
    if len(stream) == 0:
        raise ValueError("El Stream está vacío. No se pueden obtener los metadatos.")

    # Obtén el tiempo de inicio de la primera traza en el Stream
    tiempo_inicio = stream[0].stats.starttime

    # Extrae la fecha y la hora del tiempo de inicio
    fecha = tiempo_inicio.datetime.date()
    hora = tiempo_inicio.datetime.time()
    
    # Obtiene el valor de npts de la primera traza
    npts = stream[0].stats.npts

    return fecha, hora, npts


def format_fn(value, tick_number, horainicio):
    segundos = int(value)
    milisegundos = int((value - segundos) * 1000)
    #tiempo = horainicio + datetime.timedelta(seconds=segundos, milliseconds=milisegundos)
    tiempo = datetime.datetime.combine(datetime.date.today(), horainicio) + datetime.timedelta(seconds=segundos, milliseconds=milisegundos)
    return tiempo.strftime("%H:%M:%S:%f")[:-3]


def graficar_trama_mseed(canal, traza1, traza2, horainicio1, horainicio2, npts1, npts2):
    # Obtiene las trazas individuales del Stream
    traza1_individual = traza1[canal - 1]
    traza2_individual = traza2[canal - 1]
    
    # Obtiene los valores de tiempo y amplitud de la traza1
    tiempo1 = traza1_individual.times()
    amplitud1 = traza1_individual.data
    
    # Obtiene los valores de tiempo y amplitud de la traza2
    tiempo2 = traza2_individual.times()
    amplitud2 = traza2_individual.data
    
    # Trunca la traza más grande para que tenga el mismo número de datos que la traza más pequeña
    if npts1 < npts2:
        tiempo2 = tiempo2[:npts1]
        amplitud2 = amplitud2[:npts1]
    elif npts1 > npts2:
        tiempo1 = tiempo1[:npts2]
        amplitud1 = amplitud1[:npts2]
    
    # Crea una figura con dos subplots
    fig, axs = plt.subplots(2, 1, figsize=(8, 8))
    
    # Grafica el canal x de la traza1 en el primer subplot
    axs[0].plot(tiempo1, amplitud1)  # canal - 1 porque Python usa índices basados en 0
    axs[0].set_ylabel(f'Canal {canal} - Traza 1')
    axs[0].grid(True)
    
    # Grafica el canal x de la traza2 en el segundo subplot
    axs[1].plot(tiempo2, amplitud2)  # canal - 1 porque Python usa índices basados en 0
    axs[1].set_ylabel(f'Canal {canal} - Traza 2')
    axs[1].set_xlabel('Tiempo (hh:mm:ss:ms)')
    axs[1].grid(True)
    
       
    # Formatea el eje x para mostrar en formato de horas:minutos:segundos:milisegundos
    axs[0].xaxis.set_major_formatter(FuncFormatter(lambda value, tick_number: format_fn(value, tick_number, horainicio1)))
    axs[1].xaxis.set_major_formatter(FuncFormatter(lambda value, tick_number: format_fn(value, tick_number, horainicio2)))
    
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

# Obtiene la fecha y la hora a partir de los metadatos
fecha1, hora1, npts1  = obtener_fecha_hora_desde_metadatos(traza1)
fecha2, hora2, npts2 = obtener_fecha_hora_desde_metadatos(traza2)

print("Tiempo de inicio mseed 1:", fecha1.strftime("%Y-%m-%d") + " " + hora1.strftime("%H:%M:%S"))
print("Tiempo de inicio mseed 2:", fecha2.strftime("%Y-%m-%d") + " " + hora2.strftime("%H:%M:%S"))

# Calcula el mínimo entre npts1 y npts2
npts_min = min(npts1, npts2)

canal = 1  # Número de canal a graficar
graficar_trama_mseed(canal, traza1, traza2, hora1, hora2, npts1, npts2)
# -----------------------------------------------------------------------------