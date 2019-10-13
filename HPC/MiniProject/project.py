import cv2
import numpy as np

import os
import time

from pycuda import compiler, gpuarray, tools
import pycuda.driver as cuda
import pycuda.autoinit


bgr2grayKernel = '''

__global__ void bgr2gray(float *image_b, float *image_g, float *image_r, float *image_gray, int m, int n) {
    unsigned int row = blockIdx.y * blockDim.y + threadIdx.y;
    unsigned int col = blockIdx.x * blockDim.x + threadIdx.x;
    
    if(row < m && col < n) {
        image_gray[row*n + col] = (image_b[row*n + col] + image_g[row*n + col] + image_r[row*n + col]) / 3;
    }

}

'''

def processImageCPU(image_bgr, image_gray):

    for k in range(image_bgr.shape[2]):
        image_gray[:, :] += image_bgr[:, :, k]

    image_gray = image_gray/3

    return image_gray


def main():

    total_time_cpu = 0
    total_time_gpu = 0

    module = compiler.SourceModule(bgr2grayKernel)

    bgr2gray = module.get_function("bgr2gray")

    for file in os.listdir('.\\Images'):
        print('\nFile = ' + file)
        image_bgr = cv2.imread('Images\\' + file)
        image_bgr = np.asarray(image_bgr, dtype='float32')
        image_gray = np.zeros(image_bgr.shape[:-1], dtype = 'float32')

        print('\n\tShape = ',image_bgr.shape)

        m = image_bgr.shape[0]
        n = image_bgr.shape[1]

        cv2.imwrite('.\\Output\\' + file.split('.')[0] + '_bgr.jpg', image_bgr)
        cv2.imwrite('.\\Temp\\' + file.split('.')[0] + '_b.jpg', image_bgr[:, :, 0])
        cv2.imwrite('.\\Temp\\' + file.split('.')[0] + '_g.jpg', image_bgr[:, :, 1])
        cv2.imwrite('.\\Temp\\' + file.split('.')[0] + '_r.jpg', image_bgr[:, :, 2])


        time_start = time.perf_counter()
        image_gray = processImageCPU(image_bgr, image_gray)
        time_end = time.perf_counter()
        total_time_cpu += (time_end - time_start)*1000

        print('\n\tTime on CPU : ', (time_end - time_start)*1000, ' mili seconds')

        cv2.imwrite('.\\Output\\' + file.split('.')[0] + '_cpu.jpg', np.asarray(image_gray, dtype='uint8'))
        
        # ------------------------------------- GPU Code -------------------------------------

        image_b_device = gpuarray.to_gpu(image_bgr[:, :, 0])
        image_g_device = gpuarray.to_gpu(image_bgr[:, :, 1])
        image_r_device = gpuarray.to_gpu(image_bgr[:, :, 2])
        image_gray_device = gpuarray.empty(image_gray.shape, np.float32)

        block = (32,32,1)

        grid = (int(n/block[0]) + 1, int(m/block[1]) + 1)

        start = cuda.Event()
        end = cuda.Event()

        start.record()
        bgr2gray(image_b_device, image_g_device, image_r_device, image_gray_device, np.uint(m), np.uint(n), block= block, grid= grid)
        end.record()
        end.synchronize()

        
        total_time_gpu += start.time_till(end)

        
        image_gray_gpu = image_gray_device.get()
        
        cv2.imwrite('.\\Output\\' + file.split('.')[0] + '_gpu.jpg', np.asarray(image_gray_gpu, dtype='uint8'))

        print('\tTime on GPU : ', start.time_till(end), ' mili seconds')


    print('\n\nTotal time CPU : {} mili Seconds'.format(total_time_cpu))
    print('\nTotal time GPU : {} mili Seconds'.format(total_time_gpu),'\n\n')

    cv2.waitKey(0)
    cv2.destroyAllWindows()



if __name__ == '__main__':
    main()