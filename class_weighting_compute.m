function [ ] = class_weighting_compute( )
%% Compute class weighting
%  Compute the parameters of loss layer

% Reference: http://blog.csdn.net/caicai2526/article/details/77170223 
% Author: Yan Song-lin, PhD
%         Computer Network Information Center
%         Chinese Academy of Sciences
%         Beijing, China
% E-mail: ysl1abx@gmail.com
% Copyright (c) 2017, October 
% All rights reserved.
% Compiled by matlab 2016a

clc;
%% parameter of classes
%class number
%set this value of your classes, for example: if you have labels 0-11, this value should be 12
prompt2 = {'class number:'};
name2 = 'Enter class number of job';
numlines2 = 1;
defAns2 = {'12'};
Resize2 = 'on';
answer2 = inputdlg(prompt2,name2,numlines2,defAns2,Resize2);

class = str2double(answer2{1});  
if (isequal(isempty(class),1)) || (isequal(isnan(class),1)) || (class <= 1)
    disp('User does not enter any parameter');
    errordlg('no correct parameter entered, the program will exit','Error! Please enter right number');
    error('Program exception');
end

pause(1);
%% read images
path = uigetdir('C:\', 'Select dataset path' );  % get the original png file folder

if isequal(path,0)
   disp('User selected Cancel');
   errordlg('no path selected, the program will exit','Error! Please slect a file path');
   error('Program exception');
else
   disp(['User selected ; ', path]);
end

pause(1);

A = dir(fullfile(path,'*.png'));% change to your image style which you want to change, the default of this program is png type

if isequal(isempty(A),1)
   disp('Not contain any files');
   errordlg('no correct selection, the program will exit','Error! Please slect the right postfix');
   error('Program exception');
else
   disp('processing... ');
end

N = natsortfiles({A.name}); % sort file names into order

%% save path
savepath = uigetdir('C:\', 'Select save path' );  % set the save folder

if isequal(savepath,0)
   disp('User selected Cancel');
   errordlg('no path selected, the program will exit','Error! Please slect a save path');
   error('Program exception');
else
   disp(['User selected : ', savepath]);
end

pause(1);

prompt1 = {'save file name:'};
name1 = 'Enter txt file name';
numlines1 = 1;
defAns1 = {'class_weighting'};
Resize1 = 'on';
answer1 = inputdlg(prompt1,name1,numlines1,defAns1,Resize1);

pause(1);

Filename = strcat(answer1,'.txt');
SaveFile = fullfile(savepath,Filename{1});

%will delete existed the same name file
if (exist(SaveFile,'file') == 2) 
    delete(SaveFile);
end
pause(1);

%% Statistics ; each class' pixels number of all images
ConvertFrameNum = numel(N);
X = zeros(ConvertFrameNum,class);%save the number of all mask's pixels 
N_all_pixel = zeros(ConvertFrameNum,1);%save the number of all masks

for k = 1 : ConvertFrameNum
    % read each image
    direction = fullfile(path,N{k});
    [image,MAP] = imread(direction);
    [l,m,n] = size(image);
    N_all_pixel(k,1) = l*m;
    if n~=1
        error('Warning:wrongformat','matrix of images must only contain 1 non-zero two dimensions numerical matrix');
    end
    I = image;
    label_num = double(unique(I));%store labels of each image 
    M = length(label_num);%the number of classes per image 
    %calculate pixels of each calss   
    for i = 1 : M
        temp = int8(label_num(i,1))+1; 
        X(k,temp) = length(find(I==label_num(i,1)));
    end
 
end

%% calculate the weighting of each class
sum_class = sum(X,1);%pixel number of each class
total = sum(N_all_pixel,1);
median = total/class;
class_weighting = median./sum_class;

%% output
Num = length(class_weighting);
f_id = fopen(SaveFile,'wt');
for i = 1:Num
    fprintf(f_id,'%d\t',i-1);
    fprintf(f_id,'%g\n',class_weighting(1,i));
end
fclose(f_id);

end

