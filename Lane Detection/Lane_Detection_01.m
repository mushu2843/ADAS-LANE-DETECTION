clc;
clear;
close all;

video = VideoReader("road_video.mp4");

while hasFrame(video)

    frame = readFrame(video);

    imshow(frame);
    title("Road Video");

    drawnow;

end