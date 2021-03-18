# DACN
Deep Active Contour Network for Medical Image Segmentation

## Requirement  
- Tensorflow 1.x
 
## Usage

1. Put '.nii' format data into directory as the following file structure:  
```
Dataset  
    └── training_data  
            ├── training_data_nii  
            |      ├── slices  
            │      │      └── CC0001_philips_15_55_M.nii.gz...  
            │      └── masks  
            │             └── CC0001_philips_15_55_M_ss.nii.gz...              
            │    
            ├── valid_data_nii  
            |      ├── slices  
            │      │      └── CC0016_philips_15_55_M.nii.gz...  
            │      └── masks  
            │             └── CC0016_philips_15_55_M_ss.nii.gz...     
            │  
            ├── test_data_nii  
            |      ├── slices  
            │      │      └── 5254HD.nii.gz...  
            │      └── masks  
            │             └── 5254HD.manual.mask.nii.gz...    
        ...  
```  
2.  run ``` input.m ``` to slice the volumn into 2d image.  
3.  run ``` create_h5.py ``` to convert dataset into hdf5 file.  
4.  train： ``` python main.py ```  
    valid： ``` python main.py --action=test ```  
    predict： ``` python main.py --action=predict ```  
5.  run ``` save_pred_and_quantify.m ``` to convert the prediction results into different folders according to different volume.  
6.  run ``` save_results.m ``` to convert 2d results into 3d volumes.  

## Results  
- test on brainsuite data:  
![image](https://github.com/yanlong-sun/DACN/blob/main/result_final.png)  

## Network structure  
- Dense Unet Structure  
![image](https://github.com/yanlong-sun/DACN/blob/main/Dense%20Unet%20Structure.png)  

- DACN Structure  
![image](https://github.com/yanlong-sun/DACN/blob/main/DACN%20Structure.png)

## Training data we used are as following:
- Training data : 
         CC0001 - CC0015, CC0110-CC0134, CC0230-CC0254, CC0350-CC0359 
