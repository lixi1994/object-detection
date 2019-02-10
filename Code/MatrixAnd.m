function img_and = MatrixAnd(img_add,img_min,num)
img_add = img_add - num;
img_min = img_min - num;
img_add(img_add<0)=0;
img_add(img_add>0)=1;
img_min(img_min<0)=0;
img_min(img_min>0)=1;
img_and = img_add.*img_min;


