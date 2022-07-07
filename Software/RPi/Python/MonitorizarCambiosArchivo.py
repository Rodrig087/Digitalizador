from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import struct




filepath = "/home/rsa/TMP/temporalCanal.txt"

#Variables globales
valCH1 = 0
valCH2 = 0
valCH3 = 0

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

try:
    while observer.is_alive():
        observer.join(1)
        print("hola")
except KeyboardInterrupt:
    observer.stop()
observer.join()

#********************************************************************************