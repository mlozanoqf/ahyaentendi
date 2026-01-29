mu = [0 1];
SIGMA = [1 1.5; 1.5 5];
r = mvnrnd(mu,SIGMA,1000);

vidObj = VideoWriter('mymovie.avi');
vidObj.Quality = 100;
open(vidObj);
for i=1:1000
    close
    h=figure
plot(r(1:i,1),r(1:i,2),'o')
axis([-3 4 -6 10])
title('Multivariate normal. Martin.LozanoBanda@mbs.ac.uk')
xlabel('mean=0, variance=1, covariance=1.5'); ylabel('mean=1, variance=5, covariance=1.5');


 currFrame = getframe(h);
 writeVideo(vidObj,currFrame)

 F(i) = getframe;
end
 
   close(vidObj);