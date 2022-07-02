# import matplotlib.pyplot as plt
# import matplotlib.animation as animation

# gData = []
# gData.append([0])
# gData.append([0])

# #Configuramos la gráfica
# fig = plt.figure()
# ax = fig.add_subplot(111)
# hl, = plt.plot(gData[0], gData[1])
# plt.ylim(-90, 90)
# plt.xlim(0,120)

# #Prueba
# gData.append([0,1,2])
# gData.append([0,2,1])
# plt.plot(gData[0],gData[1])
# plt.show
# #Fin Prueba

import matplotlib.pyplot as plt
#from ing_theme_matplotlib import mpl_style
#from ing_theme_matplotlib.mpl_style import add_logo
import math



#logo = add_logo()


# Create sinewaves with sine and cosine
xs = [i / 5.0 for i in range(0, 50)]
y1s = [math.sin(x) for x in xs]
y2s = [math.cos(x) for x in xs]

# Explicitly create our figure and subplots
plt.style.use('dark_background')
#plt.style.use('bmh')
fig = plt.figure()
ax1 = fig.add_subplot(2, 1, 1)
ax2 = fig.add_subplot(2, 1, 2)
ax1.grid(linestyle='-',linewidth=0.2)
ax2.grid(linestyle='-',linewidth=0.2)

ax1.set_facecolor('#181c1fff')
ax2.set_facecolor('#181c1fff')

# Draw our sinewaves on the different subplots
ax1.plot(xs, y1s, color='#5bd15eff')
ax2.plot(xs, y2s, color='#5bd15eff')




# Adding labels to subplots is a little different
#ax1.set_title('sin(x)')
#ax1.set_xlabel('Radians')
ax1.set_ylabel('sin(x)')
plt.setp(ax1.get_xticklabels(), visible=False)


#ax2.set_title('cos(x)')
ax2.set_xlabel('Radians')
ax2.set_ylabel('cos(x)')
ax2.set_xticks([0,2,4,5,6,8,10]) 
ax2.set_xticklabels([0,'','',30,'','',60], fontsize=9)

ax1.tick_params(labelsize=9,labelcolor='gray')
ax2.tick_params(labelsize=9)


# We can use the subplots_adjust function to change the space between subplots
plt.subplots_adjust(hspace=0.6)

# Draw all the plots!
plt.show()