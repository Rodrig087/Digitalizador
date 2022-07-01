from matplotlib import pyplot as plt
from matplotlib import animation
import numpy as np

#plt.rcParams["figure.figsize"] = [7.50, 3.50]
#plt.rcParams["figure.autolayout"] = True

# Parametros
x_len = 120         # Number of points to display
y_range = [0, 100]  # Range of possible Y values to display

fig = plt.figure()
ax1 = fig.add_subplot(2, 1, 1)
ax2 = fig.add_subplot(2, 1, 2)
ax1.set_ylim(y_range)
ax2.set_ylim(y_range)

xs = list(range(0, 120))
ys1 = [0] * x_len
ys2 = [0] * x_len

N = 4
x = np.linspace(-5, 5, 100)
lines = [ax1.plot(x, np.sin(x))[0] for _ in range(N)]
rectangles = ax2.bar([0.5, 1, 1.5], [50, 40, 90], width=0.1)
patches = lines + list(rectangles)

def animate(i):
   for j, line in enumerate(lines):
      line.set_data([0, 2, i, j], [0, 3, 10 * j, i])
   for j, rectangle in enumerate(rectangles):
      rectangle.set_height(i / (j + 1))
   return patches

anim = animation.FuncAnimation(fig, animate,frames=100, interval=20, blit=True)

plt.show()