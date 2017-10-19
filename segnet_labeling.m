function [ ] = segnet_labeling( )
%% Convert 32b images format to Segnet label format
% Change original images (whose labels are in RGB value & 32b) to visualized images & single channel labeling images for Segnet

% Reference: http://www.cnblogs.com/luckystar-67/p/3722281.html
%            matlab tips from https://github.com/kyamagu/js-segment-annotator 
% Author: Yan Song-lin, PhD
%         Computer Network Information Center
%         Chinese Academy of Sciences
%         Beijing, China
% E-mail: ysl1abx@gmail.com
% Copyright (c) 2017, October 
% All rights reserved.
% Compiled by matlab 2016a

clc;

%% read & show
path = uigetdir('C:\', 'Select dataset path' );  % get the original png file folder

if isequal(path,0)
   disp('User selected Cancel');
   errordlg('no path selected, the program will exit','Error! Please slect a file path');
   error('Program exception');
else
   disp(['User selected ; ', path]);
end

pause(1);

% the inputs must be png format
A = dir(fullfile(path,'*.png'));% change to your image style which you want to change, the default of this program is dicom type

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

%% main
ConvertFrameNum = numel(N);

for k = 1 : ConvertFrameNum
    % read each image
    direction = fullfile(path,N{k});
    [X,MAP] = imread(direction);
    [m,n,l] = size(X);
    if l==3
        annotation = uint8(X(:, :, 1));
        b_1 = X(:,:,2);
        l_1 = any(any(b_1));
        c = X(:,:,3);
        m = any(any(c));
        if (l_1~=0) || (m~=0)
            error('Warning:wrongformat','matrix of images must only contain 1 non-zero two dimensions numerical matrix');
        end
    else
        annotation = uint8(X);
    end

    a = annotation;
    % colour map define
    map = hot(64);
    [s,w] = size(map);

    if w~=3
        error('grs2rgb:wrongColormap','Colormap matrix must contain 3 columns');
    end

    % Calculate the indices of the colormap matrix
    a = double(a);
    a = a+1; % ensure that the classes are not more than 255
    ci = ceil(s*a/max(a(:))); 

    % Colors in the new image
    [il,iw] = size(a);
    r = zeros(il,iw); 
    g = zeros(il,iw);
    b = zeros(il,iw);
    r(:) = map(ci,1);
    g(:) = map(ci,2);
    b(:) = map(ci,3);

    % New image
    res = zeros(il,iw,3);
    res(:,:,1) = r; 
    res(:,:,2) = g; 
    res(:,:,3) = b;

    %figure; % uncomment this line to show image
    %imshow(res,[]); % uncomment this line to show image

    % decode & encode part uses to convert images format, but it does not work for Segnet label
    % Decode
    % 以8位形式将X矩阵R通道与G通道（进行左移8位运算后，返回向左移位k字节，相当于乘以2^k）逐位或运算
    %annotation = bitor(annotation, bitshift(X(:, :, 2), 8));
    %annotation = bitor(annotation, bitshift(X(:, :, 3), 16));
    % 最后输出矩阵为24位，单值矩阵

    % Encode an index map
    %Y = cat(3, bitand(annotation, 255),bitand(bitshift(annotation, -8), 255),bitand(bitshift(annotation, -16), 255));
    
    % save images
    resultFile = fullfile(savepath,N{k});
    imwrite(uint8(annotation), resultFile);
    % colour image for classes
    [pathstr,fname,ext]=fileparts(N{k});
    postfix = strcat(savepath,'\',fname,'_','colour',ext);
    imwrite(uint8(round(res*255)), postfix);  
end

end

