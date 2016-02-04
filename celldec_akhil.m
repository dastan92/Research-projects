clc ;
close all;
clear all;

%mkdir Live;
mkdir slice;
%% Code to write images

updating_array=0;
dead_cells=0;
total_dead_cells=0;
total_live_cells=0;
live_cells=0;

%for videos=91:91

z=0;

VidObj = VideoReader(strcat('D:\Work\IISc Part II\aKHILMOTOR\Plasma0009','.avi'));

%VidObjDat = read(VidObj);
Nframes = VidObj.NumberOfFrames;
vidHeight = VidObj.Height;
vidWidth = VidObj.Width;
mean_count=1;
pixel_count=1;

%% Generate Background
a1 = read(VidObj,1);
 a= a1(200:400,200:400);


%%% average ten frames to generate background.
bg = 0;
count = 30 ;% set number of frame to be averaged
N = 1; % start frame number
for i = N:N+count
	bg = bg +double(rgb2gray(read(VidObj,i)));
end
bg = uint8(bg /count); % Final Background generated.
%imshow(bg);
% set appropriate cropping for the background
% RS = 135;% start value of the row
%RE = 280; % end value of the row
% RS = 430;% start value of the row
% RE = 560;% start value of the row
% % RS = 493;% start value of the row
% % RE = 638; % end value of the row
% CS = 160;% start value of the column
% CE = 339; % end value of the column
% 42
 %RE = 280; % end value of the row
  RS = 23;% start value of the row
  RE = 162;% start value of the row 70 734 74 266
 
%  RS = 493;% start value of the row
%  RE = 638; % end value of the row
CS = 158;% start value of the column
CE = 550; % end value of the column
% crop as per th
% crop as per the following imshow(CS:CE,RS:RE)
%imshow(bg(:,RS:RE));
%% subtract all subsequent frames and write into a video.
ccount = 0;
gccount = 0;
framecount = 0;
ccount = 0;
MAVector = 0;
MVector = 0;
framenum = 0;
pframenum = 0;

for k =1:1000
	k
    
Copy=rgb2gray(read(VidObj,k));
CurrFrame = double(rgb2gray(read(VidObj,k)));
CurrFrame1=read(VidObj,k);

%new

Sub = double(CurrFrame(RS:RE,CS:CE)-double(bg(RS:RE,CS:CE)));%subtracting the background
Submin = min(Sub(:));
Submax = max(Sub(:));
AdjBGSub = uint8( (Sub - Submin)/(Submax-Submin) * 255);

I = AdjBGSub;
[A, B]=size(I);

if 
% a = uint8(min(Sub(:))*-1+Sub);
[~, threshold] = edge(I, 'sobel');
fudgeFactor = 1;
BWs = edge(I,'sobel', threshold * fudgeFactor);
se90 = strel('line', 4, 90);
se0 = strel('line', 4, 0);
BWsdil = imdilate(BWs, [se90 se0]);
BWdfill = imfill(BWsdil, 'holes');
BWdfillopen = imopen(BWdfill,strel('disk',5,4));
BWnobord = imclearborder(BWdfillopen, 4);
seD = strel('diamond',2);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
CC =bwconncomp(BWfinal);
Areas = regionprops(CC,'Area');
MALength = regionprops(CC,'MajorAxisLength');
MinLength = regionprops(CC,'MinorAxisLength');
Centroids=regionprops(CC,'Centroid');
BWthresh = imcomplement(im2bw(I,0.15));
% imshow(BWthresh);
% figure;
% imshow(uint8(BWthresh).*I);
% CC_par =bwconncomp(BWthresh);
% Centroids=regionprops(CC_par,'Centroid');
% Areas_par = regionprops(CC_par,'Area');
for il = 1:CC.NumObjects
if(Areas(il).Area > 40 && Areas(il).Area < 5000 )

ccount = ccount +1;
gccount = gccount+1;
CR1=round(Centroids(il).Centroid(1))-15;
CC1=round(Centroids(il).Centroid(2))-15;
CR2=round(Centroids(il).Centroid(1))+15;
CC2=round(Centroids(il).Centroid(2))+15;
if CR1 <= 0
CR1=1;
end
if CC1 <= 0
CC1=1;
end
if CR2 > B
CR2=B;
end
if CC2 > A
CC2=A;
end
sliceOfImage = I(CC1:CC2,CR1:CR2);
%imwrite(sliceOfImage,strcat('C:\Users\RBCCPS\Documents\MATLAB\slice/FrameNumber','-',num2str(k),'-',num2str(il),'.jpg'),'jpeg');
%mean(mean_count)=mean2(I(CC1:CC2,CR1:CR2));
%mean_count=mean_count+1;
%mean_slice=mean2(sliceOfImage);
[p, q]=size(sliceOfImage);
% BWthresh = im2bw(sliceOfImage,0.15);

% imshow(BWthresh);
% figure;
% imshow(uint8(BWthresh).*I);
%CC1 =bwconncomp(imcomplement(BWthresh));
% Areas_stained = regionprops(CC1,'Area');
% C_Percentstained = sum(struct2array(Areas_stained))/max(struct2array(Areas))*100;
% Percentstained = horzcat(Percentstained, C_Percentstained );
z=z+1; %if (pixel_count ~=0)
pixel_count_array(z)=pixel_count;
imwrite(sliceOfImage,strcat('D:\Work\IISc Part II\akhil motor\slice\FrameNumber',num2str(k),'-',num2str(il),'.jpg'),'jpeg');
end
end
end
updating_array=vertcat(updating_array(:),pixel_count_array(:));
pixel_count_array=0;
%z=0;
%end
%end
%end
%end
%close(NewObj1);
%close(NewObj2);--
t = [0:1/30000:0.2];

A = 1;
f =10000;
y = A*sin(2*pi*f*t);%provides feedback that the counting has been done
sound(y)