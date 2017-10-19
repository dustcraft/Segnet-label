# Make list
# Reference: http://www.blog.csdn.net/caicai2526/article/details/77170223.html
# Author: Yan Song-lin, PhD
#         Computer Network Information Center
#         Chinese Academy of Sciences
#         Beijing, China
# E-mail: ysl1abx@gmail.com
# Copyright (c) 2017, October 
# All rights reserved.

#!/usr/bin/env sh
DATA_train=/home/ccf/CCF/Cell_segnet/data/data_train_enhancement/train/image
MASK_train=/home/ccf/CCF/Cell_segnet/data/data_train_enhancement/train/mask
DATA_val=/home/ccf/CCF/Cell_segnet/data/data_train_enhancement/val/image
MASK_val=/home/ccf/CCF/Cell_segnet/data/data_train_enhancement/val/mask
DATA_test=/home/ccf/CCF/Cell_segnet/data/data_train_enhancement/test/image
MASK_test=/home/ccf/CCF/Cell_segnet/data/data_train_enhancement/test/mask
MY=/root/hiv

echo "Creating train.txt..."
rm -rf $MY/train.txt
find $DATA_train/ -depth -name \*.png>>$MY/image.txt
find $MASK_train/ -depth -name \*.png>>$MY/mask.txt
paste -d " " $MY/image.txt $MY/mask.txt>$MY/train.txt
rm -rf $MY/image.txt
rm -rf $MY/mask.txt


echo "Creating val.txt..."
rm -rf $MY/val.txt
find $DATA_val/ -depth -name \*.png>>$MY/image.txt
find $MASK_val/ -depth -name \*.png>>$MY/mask.txt
paste -d " " $MY/image.txt $MY/mask.txt>$MY/val.txt
rm -rf $MY/image.txt
rm -rf $MY/mask.txt

echo "Creating test.txt..."
rm -rf $MY/test.txt
find $DATA_test/ -depth -name \*.png>>$MY/image.txt
find $MASK_test/ -depth -name \*.png>>$MY/mask.txt
paste -d " " $MY/image.txt $MY/mask.txt>$MY/test.txt
rm -rf $MY/image.txt
rm -rf $MY/mask.txt

echo "Done."
