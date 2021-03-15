import matplotlib.pyplot as plt
import numpy as np


train_npy_path = "../network4/record/"

training_loss = np.load(train_npy_path + "train_loss.npy")
training_acc = np.load(train_npy_path + "train_acc.npy")
training_dice = np.load(train_npy_path + "train_dice.npy")
valid_loss = np.load(train_npy_path + "valid_loss.npy")
valid_acc = np.load(train_npy_path + "valid_acc.npy")
valid_dice = np.load(train_npy_path + "valid_dice.npy")


epoch = np.arange(1, 100001, 1000)

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

plt.plot(epoch, training_dice)
plt.plot(epoch, valid_dice)
plt.legend(['train', 'valid'], loc='upper right')
plt.ylabel('dice')
plt.xlabel('epoch')
plt.show()