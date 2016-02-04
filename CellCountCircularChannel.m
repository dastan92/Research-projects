clc ;
close all;
clear all;

% make a directory to store your captured cells' snapshots
indexes = [15;13;14];



for ii = 1
%     filenum = ii
        
        if indexes(ii) < 10
            dirString = strcat('Plasma000',int2str(indexes(ii)));
            
        else
            dirString = strcat('Video_00',int2str(indexes(ii)));
        end    
        %% read the video file 

        VidObj = VideoReader(strcat('D:\Work\IISc Part II\Akhil\1\',dirString,'.avi')); % customizable folder, please change dirString if needed
        mkdir ('D:\Work\IISc Part II\akhil motor\1',dirString)

       %% assign variables under the video object Cell
        Nframes = VidObj.NumberOfFrames;
        vidHeight = VidObj.Height;
        vidWidth = VidObj.Width;

        %% use background subtraction by averaging frames and then doing contrast correction

        bg = 0; % initialize background
        count = 10; % no of frames to be averaged
        N = 1; % start frame for the for loop

        for i = N : N + count 
            bg = bg + rgb2gray(read(VidObj,i));
        end

        bg = uint8(bg/count); %Final Background generated

        %% set appropriate cropping for the background

        RS = 140;% start value of the row used for with motor
        RE = 270;% End value of the row
        CS = 200;% start value of the column
        CE = 410;
%         RS = 3;% start value of the row used for with motor
%         RE = 105;% End value of the row
%         CS = 188;% start value of the column
%         CE = 306; % end value of the column
%         RS = 23;% start value of the row
%         RE = 162;% End value of the row
%         CS = 158;% start value of the column
%         CE = 500; % end value of the column

        ccount = 0; % initialize variable for cell count storage

       %% subtract all subsequent frames and write into a video

for k = 1:600;
            framenumber = k
            CurrFrame = double(rgb2gray(read(VidObj,k))); % reading specific frame in gray
            CurrFrame1=read(VidObj,k);
            Sub = double(CurrFrame(RS:RE,CS:CE)-double(bg(RS:RE,CS:CE)));%subtracting the background
            Submin = min(Sub(:)); % taking minimum and maximum intensity in frame
            Submax = max(Sub(:));
            AdjBGSub = uint8( (Sub - Submin)/(Submax-Submin) * 255); % contrast adjustment
            I = AdjBGSub;
            [A, B]=size(I);

            %% edge detection and creating cell count by connected components
            [~, threshold] = edge(I, 'sobel');
            fudgeFactor = 1;
            BWs = edge(I,'sobel', threshold * fudgeFactor);
            se90 = strel('line', 4, 90);
            se0 = strel('line', 4, 0);
            BWsdil = imdilate(BWs, [se90 se0]);
            
            BWdfill = imfill(BWsdil, 'holes');
            BWdfillopen = imopen(BWdfill,strel('disk',9,4));
            BWnobord = imclearborder(BWdfillopen, 4);
            seD = strel('diamond',2);
            BWfinal = imerode(BWnobord,seD);
            BWfinal = imerode(BWfinal,seD);
            imshow(BWfinal)

            %% create the connected components
            CC = bwconncomp(BWfinal);
            Areas = regionprops(CC,'Area');
            MALength = regionprops(CC,'MajorAxisLength');
            MinLength = regionprops(CC,'MinorAxisLength');
            Centroids=regionprops(CC,'Centroid');
            BWthresh = imcomplement(im2bw(I,0.15));

            for il = 1:CC.NumObjects
                if(Areas(il).Area>40 && Areas(il).Area < 5000)
                ccount = ccount + 1;

                %% centroid creating/detection
                CR1=round(Centroids(il).Centroid(1))-15; % Selecting first index
                CC1=round(Centroids(il).Centroid(2))-15;
                CR2=round(Centroids(il).Centroid(1))+15;
                CC2=round(Centroids(il).Centroid(2))+15;

                if CR1 <= 0
                    CR1=1; % Not put equal to zero as the minimum pixel index in the image is 1
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

                sliceOfImage = I(CC1:CC2,CR1:CR2); % extracting the centroid of the detected object
                [p, q]=size(sliceOfImage);
                imwrite(sliceOfImage,strcat('D:\Work\IISc Part II\akhil motor\1\',dirString,'\FrameNumber',num2str(k),'-',num2str(il),'.jpg'),'jpeg');

                end
                end
                end

        %% Sound that provides feedback that the counting has been done
        t = [0:1/30000:0.2];

        A = 1;
        f =10000;
        y1 = A*sin(2*pi*f*t);%
        
        t = [0:1/30000:0.2];

        A = 1;
        f =7000;
        y2 = A*cos(2*pi*f*t);%
        sound(y1+y2)
        
        
        
        
end        