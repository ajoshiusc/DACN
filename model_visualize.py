import matplotlib.pyplot as plt
import numpy as np


pre_train_npy_path = "./pre_network4/record/"

training_loss = np.load(pre_train_npy_path + "train_loss.npy")
training_acc = np.load(pre_train_npy_path + "train_acc.npy")
training_miou = np.load(pre_train_npy_path + "train_miou.npy")

valid_loss = np.load(pre_train_npy_path + "valid_loss.npy")
valid_acc = np.load(pre_train_npy_path + "valid_acc.npy")
valid_miou = np.load(pre_train_npy_path + "valid_miou.npy")


epoch = np.arange(1, 50001, 500)

plt.plot(epoch, training_loss)
plt.plot(epoch, valid_loss)
plt.legend(['train', 'valid'], loc='upper right')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.show()

plt.plot(epoch, training_acc)
plt.plot(epoch, valid_acc)
plt.legend(['train', 'valid'], loc='upper right')
plt.ylabel('accuracy')
plt.xlabel('epoch')
plt.show()

plt.plot(epoch, training_miou)
plt.plot(epoch, valid_miou)
plt.legend(['train', 'valid'], loc='upper right')
plt.ylabel('miou')
plt.xlabel('epoch')
plt.show()