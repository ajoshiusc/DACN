import os
import numpy as np
import cv2
import skimage.io as io
import h5py

action = 'training'  # 'valid'
slices_path = '../Dataset/' + action + '_data/' + action + '_data_png/slices/*.tif'
masks_path = '../Dataset/' + action + '_data/' + action + '_data_png/masks/*.tif'
print(slices_path)
slices_list = io.ImageCollection(slices_path)
masks_list = io.ImageCollection(masks_path)
print(len(masks_list))
h5py_file_name = '../Dataset/h5py/' + action + '_data.hdf5'
f = h5py.File(h5py_file_name, 'w')
f.create_dataset('X', data=slices_list)
f.create_dataset('Y', data=masks_list)
f.close()

