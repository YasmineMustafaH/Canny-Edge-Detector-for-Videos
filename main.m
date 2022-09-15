clc
close all 
clear all 

%compressed video
video = VideoReader('compressedInputVideo.mp4');

video2 = VideoWriter('result.avi','Uncompressed AVI'); %create the video object
video2.FrameRate = 23;

open(video2); %open the file for writing

cmap = gray(256);
for i = 1 : 191
BW=canny2(frame,0,0.4431);
writeVideo(video2,im2frame(BW,cmap)); %write the image to file
end

close(video2); %close the file