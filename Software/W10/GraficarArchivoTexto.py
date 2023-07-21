
import tkinter
from tkinter import filedialog
import os
import matplotlib.pyplot as plt
import numpy as np

#------------------------------------------------------------------------------
# Seleccion del archivo mseed a graficar
#------------------------------------------------------------------------------
#abre una ventana para seleccionar el archivo
root = tkinter.Tk()
root.withdraw() # use to hide tkinter window
# Definir los tipos de archivo y sus extensiones correspondientes
tipos_archivo = (
    ("Archivos de texto", "*.txt"),
    ("Todos los archivos", "*.*")
)
# establecer atributos de la ventana de selección de archivos
root.attributes('-topmost', True)
root.attributes('-topmost', False)
currdir = os.getcwd()
filepath = filedialog.askopenfilename(parent = root, initialdir = currdir, title = 'please select a file',filetypes=tipos_archivo)
#------------------------------------------------------------------------------

tiempo = []  # Lista para almacenar los valores de tiempo
valX = []  # Lista para almacenar los valores de x
valY = []  # Lista para almacenar los valores de y
valZ = []  # Lista para almacenar los valores de z

# Leer el archivo y extraer los datos
with open(filepath, "r") as objFile:
    for line in objFile:
        # Dividir la línea en columnas y convertir los valores a números
        datos = line.split()
        tiempo.append(int(datos[0]))
        valX.append(int(datos[2]))
        valY.append(int(datos[3]))
        valZ.append(int(datos[4]))

# Crear índice en el eje x
indice = np.arange(len(valX))

# Crear subplots para x, y, z
fig, (ax1, ax2, ax3) = plt.subplots(3, 1, sharex=True)

# Graficar los valores de x en el primer subplot
ax1.plot(indice, valX, label='X')
ax1.set_ylabel('Valores X')

# Graficar los valores de y en el segundo subplot
ax2.plot(indice, valY, label='Y')
ax2.set_ylabel('Valores Y')

# Graficar los valores de z en el tercer subplot
ax3.plot(indice, valZ, label='Z')
ax3.set_xlabel('Tiempo (segundos)')
ax3.set_ylabel('Valores Z')

# Ajustar los espacios entre subplots
plt.tight_layout()

# Mostrar la figura con los subplots
plt.show()