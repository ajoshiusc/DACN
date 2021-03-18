clc;
clear;

% masks' path
masks_path = '../Dataset/test_data-bs/test_data_bmp/masks/';
preds_path = '../network4/samples_net/';
final_preds_path = '../png_pred_results_densenet/';
masks_folder=dir(masks_path);
masks_file= {masks_folder.name};
i = 0;  % index for the pred masks 
dice = double(zeros(1, length(masks_file)-2));
for num_masks = 3 : length(masks_file)
    
    mask_name = masks_file(num_masks);
   	mask = imread([masks_path char(mask_name)]);
    pred_path_name = [preds_path, num2str(i), '.png'];
    %%%%%%
    pred = im2gray(imread(pred_path_name));
    pred = imbinarize(pred); 
    %pred = bwareaopen(pred, 50);
    pred = imfill(pred, 'holes');
   
    case_name = char(mask_name);
    case_name = case_name(1:end-10);
    if exist([final_preds_path case_name, '/'],'dir')==0
        mkdir([final_preds_path case_name, '/']);
    end
    imwrite(pred, [final_preds_path case_name, '/', char(mask_name)]);
    disp([final_preds_path case_name, '/', char(mask_name)]);
    i = i+1;
    
    mask = logical(mask);
    pred = logical(pred);
    if((nnz(mask)== 0) && (nnz(pred)==0))
        dice_coeff = 1;
    else
        dice_coeff =  2*nnz(mask&pred)/(nnz(mask) + nnz(pred)+0.000001);
    end
    dice(num_masks-2) = dice_coeff;
       
end
dice_avg = mean(dice);
disp(dice_avg)