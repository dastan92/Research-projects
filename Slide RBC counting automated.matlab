% By Akhil Chaturvedi
%To count RBC's without staining on a slide image

close all
clear 
fileNodes = {'1.jpg' '2.jpg' '3.jpg' '4.jpg' '5.jpg' '6.jpg' '7.jpg' '8.jpg' '9.jpg' '10.jpg' '11.jpg' '12.jpg' '13.jpg'}
%Add folder to matlab current folder and your filenames to the filNodes file

for i = 1:13 
	%Read and crop the image to suitable dimension and then show image
	I = imread(fileNodes{2});
	I2 = imcrop(I,[500 1732 1000 1000]);
	figure; imshow(I2);


	binary = im2bw(I2,0.55); %Convert image into binary with threshold value = 0.55
	%figure;
	%imshow(binary)
	binary2 = imcomplement(binary); 
	figure;
	imshow(binary2);

	%Morphological operations : Structural element is disk and dimension 5 pixels 
	%follow it by image opening (erode then dilate)
	se = strel('disk',5);
    afterOpening = imopen(binary2,se);
	figure;
	imshow(afterOpening,[]);

	%Counting the cells(connected components) and storing the counter value
	cc = bwconncomp(afterOpening);
	cellcount{i} = cc.NumObjects;
end	

