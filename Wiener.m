clear all

N=1000;

%clf;                                % clear the entire figure

t = (0:1:N)'/N;                     % t is the column vector [0 1/N 2/N ... 1]

W1 = [0; cumsum(randn(N,1))]/sqrt(N); % S is running sum of N(0,1/N) variables
W2 = [0; cumsum(randn(N,1))]/sqrt(N); % S is running sum of N(0,1/N) variables
W3 = [0; cumsum(randn(N,1))]/sqrt(N); % S is running sum of N(0,1/N) variables
W4 = [0; cumsum(randn(N,1))]/sqrt(N); % S is running sum of N(0,1/N) variables

vidObj = VideoWriter('mymovie.avi');
vidObj.Quality = 100;
open(vidObj);


%aviobj = avifile('mymovie.avi','fps',10,'quality',100);
 for i=1:size(t,1)
close
h=figure;

plot(t(1:i),W1(1:i),'g');          % plot the path
hold on
plot(t(1:i),W2(1:i),'k');          % plot the path
hold on
plot(t(1:i),W3(1:i),'r');          % plot the path
%set(findobj('Type','line'),'Color','r')
hold on
plot(t(1:i),W4(1:i));          % plot the path
hold on

plot(t,0*t,':')
axis([0 1 -2 2])
title([int2str(N) '-step version of 4 Wiener process and its mean'])
xlabel('Martin.LozanoBanda@mbs.ac.uk'); ylabel('Y');
hold off
drawnow
 currFrame = getframe(h);
 writeVideo(vidObj,currFrame)

 F(i) = getframe;
%aviobj = addframe(aviobj,h);

 end
  %aviobj = close(aviobj);
  close(vidObj);
