import os
import glob
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np

pred_case_path = '../net_preds_results/'
mask_path = '../Dataset/test_data/test_data_bmp/masks/'
case_list = os.listdir(pred_case_path)
i = 1
dice = []
for case_name in case_list:
    print(case_name)
    pred_path = glob.glob(pred_case_path + case_name + '/*.bmp')
    single_case_dice = []
    for pred_index in pred_path:
        pred = mpimg.imread(pred_index)[:, :, 1]
        pred = pred//255
        single_mask_path = mask_path + pred_index.split('/')[-1]
        mask = mpimg.imread(single_mask_path)
        if np.sum(pred) == 0 and np.sum(mask) == 0:
            dice_coefficient = 1
        else:
            dice_coefficient = (2. * np.sum(pred * mask)) / (np.sum(pred) + np.sum(mask))
        single_case_dice.append(dice_coefficient)
    dice.append(np.mean(single_case_dice))
print(dice)

