clc;clear all;close all;restoredefaultpath;

addpath(genpath('/home/ajoshi/projects/svreg/src'))
addpath(genpath('/home/ajoshi/projects/svreg/3rdParty'));
addpath(genpath('/home/ajoshi/projects/svreg/MEX_Files'));

action = 'test';       % 'training' 'valid' 'test'

train_test_data_slices = ['/ImagePTE1/ajoshi/data/DACN_Dataset/', action, '_data_nii/'];
train_test_data_masks =  ['/ImagePTE1/ajoshi/data/DACN_Dataset/', action, '_data_nii/'];
disp(train_test_data_slices)

slices_nii_folder=dir(train_test_data_slices);
slices_nii_file={slices_nii_folder.name};
% Traverse all .nii.gz file
for num_nii = 3 : length(slices_nii_file)
    
    case_name = slices_nii_file(num_nii);
    case_name = char(case_name);
    if case_name(1)=='s' || case_name(1)=='c' || case_name(1)=='p'
        continue;
    end
    
    finishing = [num2str(num_nii-3),'/',num2str(length(slices_nii_file)-3)];
     disp(finishing)
     disp(case_name)
    
    v_slices = load_untouch_nii(fullfile(train_test_data_slices, case_name, 't1.nii.gz'));  
    v_masks = load_untouch_nii(fullfile(train_test_data_slices, case_name, 't1.mask.nii.gz'));
    %v_masks = load_untouch_nii([train_test_data_masks, case_name, '_ss.nii.gz']);
    slices_tif = v_slices.img;
    masks_tif = uint8(v_masks.img);    
    %masks_tif = zeros(size(slices_tif));
    
    [n1,n2,n3] = size(slices_tif);
%% Save as tiff
    for i = 1 : n3 
        if i == 1
            slices = im2uint8(rescale(slices_tif(:,:,1), 0, 1));
            masks = 255*masks_tif(:,:,1);
        else
            single_slice = im2uint8(rescale(slices_tif(:,:,i), 0, 1));
            single_mask = 255*masks_tif(:,:,i);
            slices = cat(3, slices, single_slice); 
            masks = cat(3, masks, single_mask);
        end
    end
    
%% 
    slices_destination_path = ['/home/ajoshi/projects/DACN/BSEDataset/', action, '_data/', action, '_data_bmp/slices/'];
    masks_destination_path = ['/home/ajoshi/projects/DACN/BSEDataset/', action, '_data/', action, '_data_bmp/masks/'];  
    mkdir(slices_destination_path);
    mkdir(masks_destination_path);
%% classify into two categories    
    if max(max(max(slices_tif))) > 12200
        [slices_preprocessed, mask_preprocessed] = preprocessing_high(slices, masks, slices_destination_path, masks_destination_path, case_name, n1, n2, n3);
    else       
        [slices_preprocessed, mask_preprocessed] = preprocessing(slices_tif, masks, slices_destination_path, masks_destination_path, case_name, n1, n2, n3);  
    end 
end


%% functions
function [slices, mask] = preprocessing_high(slices, mask, slices_destination_path, masks_destination_path, prefix, n1, n2, n3 )      
    save_preprocessed_images(slices, mask, slices_destination_path, masks_destination_path, prefix, n1, n2, n3);
end

function [slices, mask] = preprocessing(slices, mask, slices_destination_path, masks_destination_path, prefix, n1, n2, n3 )      
    slices = double(slices);
    slices = rescale(slices, 0, 255);
    % get histogram of an image volume
    [N, edges] = histcounts(slices(:), 'BinWidth', 2);

    % rescale the intensity peak to be at value 100
    minimum = edges(find(edges > prctile(slices(:), 2), 1));

    diffN = zeros(size(N));
    for nn = 2:numel(N)
        diffN(nn) = N(nn) / N(nn - 1);
    end
    s = find(edges >= prctile(slices(:), 50), 1);
    f = find(diffN(s:end) > 1.0, 5);
    start = s + f(5);

    [~, ind] = max(N(start:end));
    peak_val = edges(ind + start - 1);
    maximum = minimum + ((peak_val - minimum) * 2.55);

    slices(slices < minimum) = minimum;
    slices(slices > maximum) = maximum;
    slices = (slices - minimum) ./ (maximum - minimum);
    save_preprocessed_images(slices, mask, slices_destination_path, masks_destination_path, prefix, n1, n2, n3);
end



function [] = save_preprocessed_images(slices, mask, slices_destination_path, masks_destination_path, prefix, n1, n2, n3)

% save preprocessed images
    slices = im2uint8(slices);
 % center crop to 256x256 square
    slices = center_crop(slices, n1, n2, n3);
    mask = center_crop(mask, n1, n2, n3);   
    
    slicesPerImage = 1;
    easy_sort = 10000;
    for s = size(slices, 3):-slicesPerImage:1
        startSlice = max([1, (s - slicesPerImage + 1)]);
        imageSlices = slices(:, :, startSlice:(startSlice + slicesPerImage - 1));
        maskSlices = mask(:, :, startSlice:(startSlice + slicesPerImage - 1));
        imageSlices = repmat(imageSlices,[1,1,3]);
        %maskSlices(maskSlices==255) = 1;
        %saveastiff(imageSlices, [slices_destination_path prefix '_' num2str(easy_sort + startSlice) '.tif']);
        imwrite(imageSlices, [slices_destination_path prefix '_' num2str(easy_sort + startSlice) '.bmp'], 'bmp');       
        imwrite(maskSlices, [masks_destination_path prefix '_' num2str(easy_sort + startSlice) '.bmp'], 'bmp');
    end

end


function [ image ] = center_crop(image, n1, n2, n3)
    num_pad_n1 = 256-n1;
    num_pad_n2 = 256-n2; 
    
    num_pad_n1_half = round(num_pad_n1/2);
    num_pad_n2_half = round(num_pad_n2/2);
    
    if and(n1<256, n2<256)
        image = padarray(image, [num_pad_n1_half, 0], 'pre');
        image = padarray(image, [num_pad_n1 - num_pad_n1_half, 0 ], 'post');
        image = padarray(image, [0, num_pad_n2_half], 'pre');  
        image = padarray(image, [0, num_pad_n2 - num_pad_n2_half], 'post');
        
    end
    
    if and(n1<256, n2>=256)
        image = padarray(image, [num_pad_n1_half, 0 ], 'pre');
        image = padarray(image, [num_pad_n1 - num_pad_n1_half, 0 ], 'post');  
    end
    
    if and(n1>=256, n2<256)
        image = padarray(image, [0, num_pad_n2_half], 'pre');  
        image = padarray(image, [0, num_pad_n2 - num_pad_n2_half], 'post');  
    end

    image_size = size(image);
    if or(image_size(1)>256, image_size(2)>256)
        win1 = centerCropWindow3d(size(image), [256,256, n3]);
        image = imcrop3(image, win1);  
    end
end

