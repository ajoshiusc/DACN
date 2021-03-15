import skimage.io as io
import h5py
import glob
action = 'test'      #  valid training test
slices_path = glob.glob('../Dataset/' + action + '_data/' + action + '_data_bmp/slices/*.bmp')
masks_path = glob.glob('../Dataset/' + action + '_data/' + action + '_data_bmp/masks/*.bmp')
slices_list = io.ImageCollection(slices_path)
print(slices_list)
masks_list = io.ImageCollection(masks_path)
print(slices_list[0].shape)
print(masks_list[0].shape)
h5py_file_name = '../Dataset/h5py/' + action + '_data.hdf5'
f = h5py.File(h5py_file_name, 'w')
f.create_dataset('X', data=slices_list)
f.create_dataset('Y', data=masks_list)
f.close()

