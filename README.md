# DACN
Deep Active Contour Network for Medical Image Segmentation

## Requirement  
- Tensorflow 1.x
 
## Usage
# Prepare training/valid/test data
1. Put '.nii' format data into directory as the following file structure:
'''
Dataset  
    └── training_data  
        ├── training_data_nii  
        |   ├── slices  
        │   │   └── CC0001_philips_15_55_M.nii.gz...  
        │   └── masks  
        │       └── CC0001_philips_15_55_M_ss.nii.gz...              
        │    
       ├── valid_data_nii  
        |   ├── slices  
        │   │   └── CC0016_philips_15_55_M.nii.gz...  
        │   └── masks  
        │       └── CC0016_philips_15_55_M_ss.nii.gz...     
        │  
       ├── test_data_nii  
        |   ├── slices  
        │   │   └── 5254HD.nii.gz...  
        │   └── masks  
        │       └── 5254HD.manual.mask.nii.gz...    
        ...  
'''  
2.  run ''' input.m ''' to slice the volumn into 2d image.  
3.  run ''' create_h5py.py ''' to convert dataset into hdf5 file.  
4.   train： ''' python main.py '''
     valid： ''' python main.py --action=test '''
     predict： ''' python main.py --action=predict '''

test on brainsuite data:  
![image](https://github.com/yanlong-sun/DACN/blob/main/result_bs.png)  


test on CC-359 dataset:   
![image](https://github.com/yanlong-sun/DACN/blob/main/result_cc.png)

Dense Unet Structure
![image](https://github.com/yanlong-sun/DACN/blob/main/Dense%20Unet%20Structure.png)

DACN Structure
![image](https://github.com/yanlong-sun/DACN/blob/main/DACN%20Structure.png)
