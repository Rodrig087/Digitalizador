import tkinter
from tkinter import filedialog
import os
from obspy import UTCDateTime, read, Trace, Stream
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
import datetime

#------------------------------------------------------------------------------
# Seleccion del archivo mseed a graficar
#------------------------------------------------------------------------------
#abre una ventana para seleccionar el archivo
root = tkinter.Tk()
root.withdraw() # use to hide tkinter window
# Definir los tipos de archivo y sus extensiones correspondientes
tipos_archivo = (
    ("Archivos mseed", "*.mseed"),
    ("Todos los archivos", "*.*")
)
# establecer atributos de la ventana de selección de archivos
root.attributes('-topmost', True)
root.attributes('-topmost', False)
currdir = os.getcwd()
filepath = filedialog.askopenfilename(parent = root, initialdir = currdir, title = 'please select a file',filetypes=tipos_archivo)
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Funciones
#------------------------------------------------------------------------------

def obtener_fecha_hora(nombre_archivo):
    # Extraer la fecha y la hora del nombre del archivo
    fecha_str = nombre_archivo.split('_')[1]
    hora_str = nombre_archivo.split('_')[2].split('.')[0]
    
    # Convertir la fecha y la hora a objetos datetime
    fecha = datetime.datetime.strptime(fecha_str, "%Y%m%d").date()
    hora = datetime.datetime.strptime(hora_str, "%H%M%S").time()
    
    return fecha, hora


def format_fn(value, tick_number, horainicio):
    segundos = int(value)
    milisegundos = int((value - segundos) * 1000)
    tiempo = horainicio + datetime.timedelta(seconds=segundos, milliseconds=milisegundos)
    return tiempo.strftime("%H:%M:%S:%f")[:-3]


def graficar_trama_mseed(nombre_mseed, horainicio):
    # Lee el archivo mseed y obtiene un objeto Stream
    st = read(nombre_mseed)
    
    # Obtiene las trazas de los tres canales
    traza1 = st[0]
    traza2 = st[1]
    traza3 = st[2]
    
    # Obtiene los valores de tiempo y amplitud de cada traza
    tiempo1 = traza1.times()
    amplitud1 = traza1.data
    
    tiempo2 = traza2.times()
    amplitud2 = traza2.data
    
    tiempo3 = traza3.times()
    amplitud3 = traza3.data
    
    # Crea una figura con tres subplots
    fig, axs = plt.subplots(3, 1, figsize=(8, 10))
    
    # Grafica la traza del primer canal en el primer subplot
    axs[0].plot(tiempo1, amplitud1)
    axs[0].set_ylabel('Canal 1')
    axs[0].grid(True)
    
    # Grafica la traza del segundo canal en el segundo subplot
    axs[1].plot(tiempo2, amplitud2)
    axs[1].set_ylabel('Canal 2')
    axs[1].grid(True)
    
    # Grafica la traza del tercer canal en el tercer subplot
    axs[2].plot(tiempo3, amplitud3)
    axs[2].set_ylabel('Canal 3')
    axs[2].set_xlabel('Tiempo (hh:mm:ss:ms)')
    axs[2].grid(True)
    
    # Formatea el eje x para mostrar en formato de horas:minutos:segundos:milisegundos
    axs[0].xaxis.set_major_formatter(FuncFormatter(lambda value, tick_number: format_fn(value, tick_number, horainicio)))
    axs[1].xaxis.set_major_formatter(FuncFormatter(lambda value, tick_number: format_fn(value, tick_number, horainicio)))
    axs[2].xaxis.set_major_formatter(FuncFormatter(lambda value, tick_number: format_fn(value, tick_number, horainicio)))
    
    # Ajusta el espaciado entre subplots
    plt.tight_layout()
    
    # Muestra la figura
    plt.show()
    
#------------------------------------------------------------------------------
    
# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
fecha, hora = obtener_fecha_hora(filepath)
print("Tiempo de inicio:", fecha.strftime("%Y-%m-%d") + " " + hora.strftime("%H:%M:%S"))


graficar_trama_mseed(filepath, datetime.datetime.combine(fecha, hora))
# -----------------------------------------------------------------------------