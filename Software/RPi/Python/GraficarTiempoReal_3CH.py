import os 
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import struct
#os.environ['MPLCONFIGDIR'] = "/home/rsa/.config/matplotlib"
#os.environ['MPLCONFIGDIR'] = "/home/rsa/.cache/matplotlib"
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.animation as animation

#print (matplotlib.rcParams['backend']) #Muestra en backend utilizado: QtAgg
#matplotlib.use('QtAgg') #Forza a ultizar el backend QtAgg

filepath = "/home/rsa/TMP/temporalCanal.txt"

#Variables globales
valCH1 = 0
valCH2 = 0
valCH3 = 0

# Parametros
x_len = 120         # Number of points to display
y_range = [0, 4095]  # Range of possible Y values to display

# Crea la figura y los subplots
plt.style.use('dark_background') #Utiliza el modo oscuro
plt.rcParams['toolbar'] = 'None' #Oculta la barra de tareas
fig = plt.figure()
plt.get_current_fig_manager().full_screen_toggle() #Fullscreen mode

ax1 = fig.add_subplot(3, 1, 1)
ax2 = fig.add_subplot(3, 1, 2)
ax3 = fig.add_subplot(3, 1, 3)

#Establece los limistes del eje X
xs = list(range(0, 120))
ys1 = [0] * x_len
ys2 = [0] * x_len
ys3 = [0] * x_len

#Establece los limites del eje Y
ax1.set_ylim(y_range)
ax2.set_ylim(y_range)
ax3.set_ylim(y_range)

#Establece los colores de fondo de los subplots
ax1.set_facecolor('#181c1fff')
ax2.set_facecolor('#181c1fff')
ax3.set_facecolor('#181c1fff')

#Establece el estilo del grid
ax1.grid(linestyle='-',linewidth=0.2)
ax2.grid(linestyle='-',linewidth=0.2)
ax3.grid(linestyle='-',linewidth=0.2)

#Establece las marcas del eje X
plt.setp(ax1.get_xticklabels(), visible=False)     #Borra las marcar del plot x1
plt.setp(ax2.get_xticklabels(), visible=False)     #Borra las marcar del plot x2
ax3.set_xticks([0,20,40,60,80,100,120])     #Selecciona las marcas de los puntos extremos y mitad del eje X
ax3.set_xticklabels([-60,'','',-30,'','',0])     #Remplaza las marcas seleccionadas por los valores 0, 30 y 60
ax1.tick_params(labelsize=9,labelcolor='gray')
ax2.tick_params(labelsize=9,labelcolor='gray')
ax3.tick_params(labelsize=9,labelcolor='gray')

#Establece las etiquetas de los ejes X y Y
ax1.set_ylabel('CH1')
ax2.set_ylabel('CH2')
ax3.set_ylabel('CH3')
ax3.set_xlabel('Tiempo [seg]')

# Create a blank line. We will update the line in animate
line1, = ax1.plot(xs, ys1, color='#5bd15eff')
line2, = ax2.plot(xs, ys2, color='#5bd15eff')
line3, = ax3.plot(xs, ys3, color='#5bd15eff')

#patches = [line1, line2, line3]

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
def animate(i):
    
    global xs
    global ys1
    global ys2
    global ys3

    # Actualiza la medicion de los canales CH1, CH2 y CH3
    medCH1 = valCH1
    medCH2 = valCH2
    medCH3 = valCH3

    # Add x and y to lists
    ys1.append(medCH1)
    ys2.append(medCH2)
    ys3.append(medCH3)

    # Limit y list to set number of items
    ys1 = ys1[-x_len:]
    ys2 = ys2[-x_len:]
    ys3 = ys3[-x_len:]

    # Update line with new Y values
    # line1.set_ydata(ys1)
    # line2.set_ydata(ys2)
    # line3.set_ydata(ys3)

    line1.set_data(xs,ys1)
    line2.set_data(xs,ys2)
    line3.set_data(xs,ys3)

    return line1,line2,line3
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
#ani = animation.FuncAnimation(fig, animate, fargs=(ys1, ys2, ys3, ), interval=500, blit=True)
ani = animation.FuncAnimation(fig, animate, interval=500, blit=True)
plt.show()

try:
    while observer.is_alive():
        observer.join(1)
        print("hola")
except KeyboardInterrupt:
    observer.stop()
observer.join()

#********************************************************************************