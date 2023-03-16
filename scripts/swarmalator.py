# %%
import numpy as np
from numba import cuda
import math
import matplotlib.pyplot as plt
import io
from PIL import Image


@cuda.jit
def totalmovementandphase(center, phase, dpos_X, dpos_Y, dphase, natFreq, K, A, J, B):
    start = cuda.grid(1)
    stride = cuda.gridsize(1)

    for ii in range(start, center.shape[0], stride):
        for jj in range(center.shape[0]):
            if jj != ii:
                distBetweenBots = math.sqrt(
                    (center[jj][0]-center[ii][0])**2 + (center[jj][1]-center[ii][1])**2)
                dphase[ii] += K*math.sin(phase[jj]-phase[ii]-(math.pi/4)*abs(
                    natFreq[ii]/abs(natFreq[ii])-natFreq[jj]/abs(natFreq[jj])))/distBetweenBots
                dpos_X[ii] += (center[jj][0]-center[ii][0])/(distBetweenBots)*(A + J*(math.cos(phase[jj]-phase[ii] - math.pi/2*abs(
                    (natFreq[ii]/(abs(natFreq[ii])))-(natFreq[jj]/(abs(natFreq[jj]))))))) - B*(center[jj][0]-center[ii][0])/(distBetweenBots**2)
                dpos_Y[ii] += (center[jj][1]-center[ii][1])/(distBetweenBots)*(A + J*(math.cos(phase[jj]-phase[ii] - math.pi/2*abs(
                    (natFreq[ii]/(abs(natFreq[ii])))-(natFreq[jj]/(abs(natFreq[jj]))))))) - B*(center[jj][1]-center[ii][1])/(distBetweenBots**2)


@cuda.jit
def reset_diff(dphase, dpos_Y, dpos_X):
    start = cuda.grid(1)
    stride = cuda.gridsize(1)
    for ii in range(start, center.shape[0], stride):
        dphase[ii] = 0
        dpos_X[ii] = 0
        dpos_Y[ii] = 0


@cuda.jit
def update_center(center, phase, dphase, dpos_X, dpos_Y, natFreq, dt, numBots):
    start = cuda.grid(1)
    stride = cuda.gridsize(1)
    for ii in range(start, center.shape[0], stride):
        center[ii][0] += C * \
            math.cos(phase[ii] + math.pi/2) + dpos_X[ii] / numBots*dt
        center[ii][1] += C * \
            math.sin(phase[ii] + math.pi/2) + dpos_Y[ii] / numBots*dt
        phase[ii] += (natFreq[ii] + (dphase[ii]/numBots))*dt
        phase[ii] = phase[ii] % (2*math.pi)


def draw_image(center_value, iteration, phase):
    plt.scatter(center_value[:, 0]*1000, center_value[:, 1]
                * 1000, marker='o', s=6, vmin=0, vmax=2*math.pi, c=phase)
    plt.xlim(-2000, 2000)
    plt.ylim(-2000, 2000)
    plt.colorbar()
    plt.tight_layout()
    buf = io.BytesIO()
    plt.savefig(buf, format='png')
    plt.close()
    buf.seek(0)
    im = Image.open(buf)
    buf.close
    return im


if __name__ == "__main__":

    plotXLimit = 1
    plotYLimit = 1
    numBots = 500
    dt = 0.1
    C = 0

    center = np.array([[np.random.uniform(-plotXLimit, plotXLimit),
                      np.random.uniform(-plotYLimit, plotYLimit)] for i in range(numBots)], dtype=np.float32)
    phase = np.array([np.random.uniform(0, 2*math.pi)
                     for i in range(numBots)], dtype=np.float32)
    # netFreq = np.array([np.random.uniform(1, 3) for i in range(numBots)], dtype=np.float32)
    netFreq = np.ones(numBots, dtype=np.float32)
    netFreq[int(numBots/2):] *= -1

    dphase = np.zeros(center.shape[0], dtype=np.float32)
    dpos_X = np.zeros(center.shape[0], dtype=np.float32)
    dpos_Y = np.zeros(center.shape[0], dtype=np.float32)

    A = 1
    J = 1
    B = 1
    K = -0.1

    center_device = cuda.to_device(center)
    phase_device = cuda.to_device(phase)
    dpos_X_device = cuda.to_device(dpos_X)
    dpos_Y_device = cuda.to_device(dpos_Y)

    dphase_device = cuda.to_device(dphase)
    netFreq_device = cuda.to_device(netFreq)
    iteration = 0

    img_list = []
    while iteration < 1000:
        if iteration % 1 == 0:
            print(f'#####this is {iteration} times#####!')
            center = center_device.copy_to_host()
            phase = phase_device.copy_to_host()
            center_img = draw_image(center, iteration, phase)
            img_list.append(center_img)

        totalmovementandphase[32, 32](center_device, phase_device, dpos_X_device,
                                      dpos_Y_device, dphase_device, netFreq_device, K, A, J, B)
        update_center[32, 32](center_device, phase_device, dphase_device,
                              dpos_X_device, dpos_Y_device, netFreq_device, dt, numBots)
        reset_diff[32, 32](dphase_device, dpos_Y_device, dpos_X_device)
        iteration += 1

    img_list[0].save(f'../results/agents.gif',
                     format='GIF', append_images=img_list[1:], save_all=True, duration=1, loop=0)
