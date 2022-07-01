import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import numpy as np

x = np.linspace(0, 2 * np.pi, 100).reshape(-1, 1)
x = np.concatenate([x] * 3, axis=1)

# generate 3 curves
y = np.copy(x)
y[:, 0] = np.cos(y[:, 0])
y[:, 1] = np.sin(y[:, 1] )
y[:, 2] = np.sin(y[:, 2] ) + np.cos(y[:, 2])

fig, ax = plt.subplots()
ax = plt.axes(xlim=(0,6), ylim=(-1.5, 1.5))
line1, = ax.plot([], [], lw=2)
line2, = ax.plot([], [], lw=2)
line3, = ax.plot([], [], lw=2)


def animate(i):
    line1.set_data(x[:i, 0], y[:i, 0])
    line2.set_data(x[:i, 1], y[:i, 1])
    line3.set_data(x[:i, 2], y[:i, 2])
    return line1,line2,line3

anim = FuncAnimation(fig, animate, frames=100, interval=200, repeat=False)
plt.show()