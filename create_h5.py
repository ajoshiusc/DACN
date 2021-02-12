import os
import numpy as np
from PIL import Image
import cv2
import skimage.io as io
import h5py
import glob
slices_list = []
masks_list = []
action = 'valid'     #  valid training
slices_path = glob.glob('../Dataset/' + action + '_data/' + action + '_data_png/slices/*.tif')
masks_path = glob.glob('../Dataset/' + action + '_data/' + action + '_data_png/masks/*.tif')
for path in slices_path:
    slice = np.array(Image.open(path))
    slice = slice.reshape(*slice.shape, 1)
    cv2.imwrite(path, slice)
    slices_list.append(slice)
masks_list = io.ImageCollection(masks_path)
print(len(slices_list))
print(slices_list[0].shape)
h5py_file_name = '../Dataset/h5py/' + action + '_data.hdf5'
f = h5py.File(h5py_file_name, 'w')
c = f.create_dataset('X', data=slices_list)
print(c.shape)
f.create_dataset('Y', data=masks_list)

f.close()

