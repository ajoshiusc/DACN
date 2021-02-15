clc;
clear;

masks_path = '../Dataset/test_data/test_data_bmp/masks/';
preds_path = '../net_preds_results/';
masks_folder=dir(masks_path);
masks_file= {masks_folder.name};

dice = double(zeros(1, length(masks_file)-2));
for num_masks = 3 : length(masks_file)
    
    mask_name = masks_file(num_masks);
   	mask = imread([masks_path char(mask_name)]);
    case_name = char(mask_name);
    case_name = case_name(1:end-10);
    pred = imread([preds_path case_name, '/', char(mask_name)]);
    mask = imbinarize(mask);
    pred = imbinarize(im2gray(pred));

    if(((nnz(mask)==0) && (nnz(pred)==0)))
        dice_coeff = 1;
    else
        dice_coeff =  2*nnz(mask&pred)/(nnz(mask) + nnz(pred));
    end
    dice(num_masks-2) = dice_coeff;
       
end
dice_avg = mean(dice);
disp(dice_avg)