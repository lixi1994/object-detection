%% Load Data From Dataset
Path = '..\DataSets\walk';
Files = dir(Path);
[num,~]=size(Files);
path_temp = fullfile(Path,Files(3).name);
image_temp = imread(path_temp);
[m,n,~] = size(image_temp);
Image_matrix = zeros(m,n,num-2);
parfor i = 3:num
    path_temp = fullfile(Path,Files(i).name);
    image_temp = im2double(imread(path_temp));
    Image_matrix(:,:,i-2) = rgb2gray(image_temp);
end

%% Basic Setting

lamda = 0.15;

%% Simple Background Substraction 

Background = Image_matrix(:,:,1);
Image_matrix_SBS = zeros(m,n,num-2);
parfor i = 1:(num-2)
    image_temp = abs(Image_matrix(:,:,i)-Background);
    Image_matrix_SBS(:,:,i) = threshold(image_temp,lamda);
end

%% Simple Frame Differencing

Background = zeros(m,n);
Image_matrix_SFD = zeros(m,n,num-2);
num_jump = 0;
for i = (1+num_jump):(num-2-num_jump)
    image_temp_add = abs(Image_matrix(:,:,i+num_jump)-Background);
    image_temp_min = abs(Image_matrix(:,:,i-num_jump)-Background);
    image_temp = MatrixAnd(image_temp_add,image_temp_min,lamda);
    Background = Image_matrix(:,:,i);
    Image_matrix_SFD(:,:,i) = threshold(image_temp,lamda);
end

%% Adaptive Background Subtraction

Background = zeros(m,n);
Image_matrix_ABS = zeros(m,n,num-2);
alpha = 0.3;
for i = 1:(num-2)
    image_temp = abs(Image_matrix(:,:,i)-Background);
    Background = alpha*Image_matrix(:,:,i) + (1-alpha)*Background;
    Image_matrix_ABS(:,:,i) = threshold(image_temp,lamda);
end

%% Persistent Frame Differencing

Background = zeros(m,n);
H = zeros(m,n);
gamma =0.05;
Image_matrix_PFD = zeros(m,n,num-2);
for i = 1:(num-2)
    image_temp = abs(Image_matrix(:,:,i)-Background);
    M = threshold(image_temp,lamda);
    Temp = (H-gamma).*threshold(H-gamma,0);
    H = M.*threshold(M - Temp,0) + Temp.*threshold(Temp - M,0);
    Image_matrix_PFD(:,:,i) = H;
    Background = Image_matrix(:,:,i);
end


%% Show result

Position = [[1 1];[n+2 1];[1 m+2];[n+2 m+2]];
String = str2cells('Simple_Background_Substraction Simple_Frame_Differencing Adaptive_Background_Subtraction Persistent_Frame_Differencing')';
Box_color = {'black','black','black','black'};
Show_Matrix = zeros(2*m+1,2*n+1,3,num-2);
parfor i = 1:num-2
    Show_Matrix_temp = [Image_matrix_SBS(:,:,i) 255*ones(m,1) Image_matrix_SFD(:,:,i);255*ones(1,2*n+1);Image_matrix_ABS(:,:,i) 255*ones(m,1) Image_matrix_PFD(:,:,i)];
    Show_Matrix_temp_text = insertText(Show_Matrix_temp,Position,String);
    Show_Matrix(:,:,:,i) = Show_Matrix_temp_text;
end

Movie(num-2) = struct('cdata',[],'colormap',[]);
figure
for i = 1:num-2
    imshow(Show_Matrix(:,:,:,i));
    Movie(i) = getframe;
end
