clc;
clear;
%% Evaluate deep learning model
prediction_path = '../pred_nii_bsdata/dl_pred_nii/';
masks_path = '../Dataset/test_data-bs/test_data_nii/masks/';
pred_folder= dir(prediction_path);
pred_file={pred_folder.name};
dice_coef_dl = zeros(1, length(pred_file)-3);
case_name_list = string(pred_file(3:length(pred_file)));
for num_pred= 3 : length(pred_file)
    case_name = pred_file(num_pred);
    case_name = char(case_name);   
    preds_nii = load_untouch_nii([prediction_path, case_name, '/',case_name, '_pred.nii']);  
    masks_nii = load_untouch_nii([masks_path, case_name, '.manual.mask.nii.gz']);
    pred = logical(preds_nii.img);
    mask = logical(masks_nii.img);  
    dice =  2*nnz(mask&pred)/(nnz(mask) + nnz(pred));
    dice_coef_dl(num_pred-2) = dice;

end
    dice_dl_avg = mean(dice_coef_dl)

    
%% Evaluate brainsuite
prediction_path = '../pred_nii_bsdata/bs_pred_nii/';
masks_path = '../Dataset/test_data-bs/test_data_nii/masks/';
pred_folder= dir(prediction_path);
pred_file={pred_folder.name};
dice_coef_bse = zeros(1, length(pred_file)-3);
for num_pred= 3 : length(pred_file)
    case_name = pred_file(num_pred);
    case_name = char(case_name);   
    preds_nii = load_untouch_nii([prediction_path, case_name, '/',case_name, '.mask.nii.gz']);  
    masks_nii = load_untouch_nii([masks_path, case_name, '.manual.mask.nii.gz']);
    pred = logical(preds_nii.img);
    mask = logical(masks_nii.img);
    dice =  2*nnz(mask&pred)/(nnz(mask) + nnz(pred));
    dice_coef_bse(num_pred-2) = dice;
end
    dice_bse_avg = mean(dice_coef_bse)

%% Evaluate unet
dice_coef_unet = importdata('dice_for_unet.txt');
dice_coef_unet = dice_coef_unet';
dice_unet_avg = mean(dice_coef_unet)

%% Evaluate Denseunet
prediction_path = '../pred_nii_bsdata_densenet/dl_pred_nii/';
masks_path = '../Dataset/test_data-bs/test_data_nii/masks/';
pred_folder= dir(prediction_path);
pred_file={pred_folder.name};
dice_coef_denseunet = zeros(1, length(pred_file)-3);
for num_pred= 3 : length(pred_file)
    case_name = pred_file(num_pred);
    case_name = char(case_name);   
    preds_nii = load_untouch_nii([prediction_path, case_name, '/',case_name, '_pred.nii']); 
    masks_nii = load_untouch_nii([masks_path, case_name, '.manual.mask.nii.gz']);
    pred = logical(preds_nii.img);
    mask = logical(masks_nii.img);  
    dice =  2*nnz(mask&pred)/(nnz(mask) + nnz(pred));
    dice_coef_denseunet(num_pred-2) = dice;
end
    dice_denseunet_avg = mean(dice_coef_denseunet)





%% plot
figure(1)
x = [[dice_coef_dl'], [dice_coef_bse'], [dice_coef_denseunet'], [dice_coef_unet']];
y = categorical(case_name_list);
barh(y, x)
set(gca,'FontSize',9);
xlabel('Dice Coefficient')
xlim([0.7, 1])
ylabel('Case Name')
xlabel('Dice Coefficient');
grid on;
ax = gca;
ax.LineWidth = 2;
ylim=get(gca,'Ylim');
line([dice_dl_avg, dice_dl_avg], ylim, 'Color','blue','LineStyle','--', 'LineWidth',2 );
line([dice_bse_avg, dice_bse_avg], ylim, 'Color','red','LineStyle','--', 'LineWidth',2 );
line([dice_denseunet_avg, dice_denseunet_avg], ylim, 'Color','#EDB120','LineStyle','--', 'LineWidth',2 );
line([dice_unet_avg, dice_unet_avg], ylim, 'Color','#7E2F8E','LineStyle', '--', 'LineWidth',2 );

legend({['DACN: ', num2str(dice_dl_avg)], ['Brainsuite: ', num2str(dice_bse_avg)], ['DenseUNet: ', num2str(dice_denseunet_avg)], ['UNet: ', num2str(dice_unet_avg)]}, 'Location','southwest');
saveas(gcf,'result_final.png')





% %% plot
% figure(1)
% x = cat(2, dice_coef_dl', dice_coef_bse');
% y = categorical(case_name_list);
% barh(y, x)
% set(gca,'FontSize',9);
% xlabel('Dice Coefficient')
% xlim([0.7, 1])
% ylabel('Case Name')
% xlabel('Dice Coefficient');
% grid on;
% ax = gca;
% ax.LineWidth = 2;
% ylim=get(gca,'Ylim');
% line([dice_dl_avg, dice_dl_avg], ylim, 'Color','blue','LineStyle','--', 'LineWidth',2 );
% line([dice_bse_avg, dice_bse_avg], ylim, 'Color','red','LineStyle','--', 'LineWidth',2 );
% text(dice_dl_avg, ylim(1), num2str(dice_dl_avg), 'color','b');
% text(dice_bse_avg, ylim(2), num2str(dice_bse_avg), 'color','r');
% legend({'DACN', 'Brainsuite', 'Avg Dice for UNet','Avg Dice for brainsuite'}, 'Location','northwest');
% saveas(gcf,'result_cc.png')
