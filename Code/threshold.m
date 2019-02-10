function image = threshold(img,num)
img = img - num;
img(img<0)=0;
img(img>0)=1;
image = img;