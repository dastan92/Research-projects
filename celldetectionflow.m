clc ;
close all;
clear all;
%mkdir Live;
mkdir slice;
%open(NewObj1);
%open(NewObj2);
updating_array=0;
dead_cells=0;
total_dead_cells=0;
total_live_cells=0;
z=0;


live_cells=0;

VidObj = VideoReader(strcat('C:\Work continued\akhil\7','.avi'));
Nframes = VidObj.NumberOfFrames;
vidHeight = VidObj.Height;
vidWidth = VidObj.Width;
mean_count=1;
pixel_count=1;
%% Generate Background
a = read(VidObj,1);
%%% average ten frames to generate background.
bg = 0;
count = 30 ;% set number of frame to be averaged
N = 1; % start frame number
for i = N:N+count
    bg = bg +double(rgb2gray(read(VidObj,i)));
end
bg  = uint8(bg /count); % Final Background generated.
%imshow(bg);
% set appropriate cropping for the background
%  RS = 135;% start value of the row
 %RE = 280; % end value of the row
  RS = 74;% start value of the row
   RE = 450;% start value of the row 70 734 74 266
 
%  RS = 493;% start value of the row
%  RE = 638; % end value of the row
CS = 70;% start value of the column
CE = 350; % end value of the column
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

 for k =1:Nframes
 	k
 Copy=rgb2gray(read(VidObj,k));
 CurrFrame = double(rgb2gray(read(VidObj,k)));
 CurrFrame1=read(VidObj,k);
 CurrFrame1=CurrFrame1(CS:CE,RS:RE);
 Sub = double(CurrFrame(:,RS:RE)-double(bg(:,RS:RE)));
 Submin = min(Sub(:));
 Submax = max(Sub(:));
 AdjBGSub = uint8( (Sub - Submin)/(Submax-Submin) * 255); %dint understand this line
 I = AdjBGSub;
  [A, B]=size(I);

  [~, threshold] = edge(I, 'sobel'); %not sure of this
  fudgeFactor = 1;
  BWs = edge(I,'sobel',threshold*fudgeFactor);
  se90 = strel('line',3,90);
  se0 = strel('line',3,0);
  BWsdil = imdilate(BWs,[se90 se0]);
  BWdfill = imfill(BWsdil,'holes');
  BWdfillopen = imopen(BWdfill,strel('disk',5,4));
  BWnobord = imclearborder(BWdfillopen,4);
  seD = strel('diamond',2);
  BWfinal = imerode(BWnobord,seD);
  BWfinal = imerode(BWfinal,seD);
  CC = bwconncomp(BWfinal);
  Areas = regionprops(CC,'Area');
  MALength = regionprops(CC,'MajorAxisLength');
  MinLength = regionprops(CC,'MinorAxisLength');
  Centroids = regionprops(CC,'Centroid');


  BWthresh = imcomplement(im2bw(I,0.15));

  for il = 1:CC.NumObjects
  	if(Areas(il).Area > 40 && Areas(il).Area < 45840 )
  		ccount = ccount +1;
  		testcount = ccount
  		gccount = gccount +1;

  		    CR1=round(Centroids(il).Centroid(1))-15 %don't get this
            CC1=round(Centroids(il).Centroid(2))-15
            CR2=round(Centroids(il).Centroid(1))+15
            CC2=round(Centroids(il).Centroid(2))+15
            if CR1 <= 0
                CR1=80;
            end
            if CC1 <= 0
                CC1=80;
            end
            if CR2 > B
                CR2=B;
            end
            if CC2 > A
                CC2=A;
            end
        sliceOfImage = CurrFrame1(CC1:CC2,CR1:CR2)';
    
        [p,q]=size(sliceOfImage);

        



[p, q]=size(sliceOfImage);
            
           % BWthresh = im2bw(sliceOfImage,0.15);
            % imshow(BWthresh);

            % figure;
            % imshow(uint8(BWthresh).*I);
            %CC1 =bwconncomp(imcomplement(BWthresh));
            % Areas_stained = regionprops(CC1,'Area');
 %           C_Percentstained = sum(struct2array(Areas_stained))/max(struct2array(Areas))*100;
%            Percentstained = horzcat(Percentstained, C_Percentstained );

            z=z+1;  %if (pixel_count ~=0)
            pixel_count_array(z)=pixel_count;
            

                
                        imwrite(sliceOfImage,strcat('C:\Work continued\akhil\slice/FrameNumber','-',num2str(k),'-',num2str(il),'.jpg'),'jpeg');

               

                 end

            end
      end
