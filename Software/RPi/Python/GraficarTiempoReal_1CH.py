from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import struct
import matplotlib.pyplot as plt
import matplotlib.animation as animation



filepath = "/home/rsa/TMP/temporalCanal.txt"

#Variables globales
valCH1 = 0
valCH2 = 0
valCH3 = 0

# Parametros
x_len = 120         # Number of points to display
y_range = [0, 4095]  # Range of possible Y values to display

# Create figure for plotting
fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
xs = list(range(0, 120))
ys = [0] * x_len
ax.set_ylim(y_range)

# Create a blank line. We will update the line in animate
line1, = ax.plot(xs, ys)

#********************************************************************************
#Metodo para leer el archivo de texto y extraer los valores de los 3 ejes:
#********************************************************************************
def LeerArchivo():
    
    #variables globales
    global valCH1
    global valCH2
    global valCH3
    
    print("imprimiendo...")
    # Abre el archivo para lectura de binarios "rb"
    objFile = open(filepath, "rb")
    # Lee el total de bytes del archivo, se guarda en un array de bytes
    bytesLeidos = objFile.read()
    # Realiza la conversion de array de bytes a lista de enteros
    formatoUnpack = '<' + '3' + 'I'
    vectorDatos = struct.unpack(formatoUnpack, bytesLeidos)
    #Extrae los valores de los 3 ejes    
    valCH1 = vectorDatos[0]
    valCH2 = vectorDatos[1]
    valCH3 = vectorDatos[2]
    print("%d   %d   %d" % (valCH1, valCH2, valCH3))

    # Al final cierra el archivo de lectura
    objFile.close()
#********************************************************************************

#********************************************************************************
#Esta funcion se llama periodicamente desde FuncAnimation
#********************************************************************************
def animate(i, ys):
    
    # Actualiza la medicion del CH1
    medCH1 = valCH1

    # Add x and y to lists
    #xs.append(dt.datetime.now().strftime('%H:%M:%S.%f'))
    ys.append(medCH1)

    # Limit y list to set number of items
    ys = ys[-x_len:]

    # Update line with new Y values
    line1.set_ydata(ys)

    return line1,
#********************************************************************************

#********************************************************************************
#Clase para monitorizar cambios en los archivos:
#********************************************************************************
class MyEventHandler(FileSystemEventHandler):
    def on_modified(self, event):
        #print(event.src_path, "modificado.")
        LeerArchivo()
#********************************************************************************

#********************************************************************************
#Main
#********************************************************************************
observer = Observer()
observer.schedule(MyEventHandler(), filepath, recursive=False)
observer.start()

# Set up plot to call animate() function periodically
ani = animation.FuncAnimation(fig, animate, fargs=(ys,), interval=500, blit=True)
plt.show()

try:
    while observer.is_alive():
        observer.join(1)
        print("hola")
except KeyboardInterrupt:
    observer.stop()
observer.join()

#********************************************************************************