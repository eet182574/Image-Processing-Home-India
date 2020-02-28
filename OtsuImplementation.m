%% This is a script to implementation of Otsu Threshold
clc, clear all, close('all');

% Read Image
Img = imread('kids.jpg');
[rows,cols,dims] = size(Img);

% If RGB convert it to gray
if dims == 3
    Img = rgb2gray(Img);
end

Img = double(Img);

% Convert it to 8 bits
Img = uint8(255 * (Img - min(Img(:))) / (max(Img(:)) - min(Img(:))));

% Display Original Image
figure, imagesc(Img);title('Original Image'),axis off, axis image, colormap(gray);

% Plot its histogram;
[Frequency,bins] = imhist(Img);
figure,stem(bins,Frequency);title('Frequency Plot');xlabel('Intensities'),ylabel('Freq');

% Compute Global mean
mg = mean(Img(:));
hold on, line([mg mg],[0 max(Frequency)],'Color',[1 0 0]);

% Let the threshold value varies from k = 0 to 255

BetClassvariance = zeros(1,256);
Goodness = BetClassvariance;
NormalizedFreq = Frequency / (rows * cols);
figure,stem(bins,NormalizedFreq);title('Normalized Frequency');xlabel('Intensities'),ylabel('Freq');

SigmaGlobal = var(double(Img(:)));

% We are starting from k 1 till 254 because at k=0, P1 = 0 and at k = 255,
% P1 = 1 therefore P2 = 1 - P1 = 0;

for k = 1:255-1
    P1 = sum(NormalizedFreq(1:k+1));
    mk = sum((NormalizedFreq(1:k+1) .* (0:k)')); 
%     mk = mk/P1;
    BetClassvariance(k+1) = (mg * P1 - mk)^2 / (P1 * (1 - P1));
    Goodness(k+1) = BetClassvariance(k+1) / SigmaGlobal;
end
figure,plot(BetClassvariance);xlabel('Thresold Values'),ylabel('Between Class Variance');

[~,index]= max(BetClassvariance);
hold on, line([index index],[0 max(BetClassvariance)],'Color',[1 0 0]);
figure(2),hold on, line([index index],[0 max(Frequency)],'Color',[1 1 0]);
string = sprintf('Thresholded Image with k = %d ',index);
figure,imagesc(Img>index);title(string);axis off, axis image,colormap(gray);
figure,plot(bins,Goodness);title('Goodness plot');xlabel('Threshold Values'),ylabel('Goodness - 0 to 1');
