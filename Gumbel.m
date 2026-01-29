alphav=(1:.01:10);
T=size(alphav,2);
N=1000;
alpha=ones(N,1)*alphav;

for i=1:T
    u(:,:,i) = copularnd('Gumbel',alphav(i),N);
end

vidObj = VideoWriter('mymovie.avi');
vidObj.Quality = 100;
open(vidObj);

for i=1:T
         pause(0.05);       
    close
    h=figure;
%u = copularnd('Clayton',alphav(i),1000);
scatter3(u(:,1,i),u(:,2,i),alpha(:,i)); hold on
zlim([0 10]);
xlabel('Vector x')
ylabel('Vector y')
zlabel('Alpha')
title('Gumbel Copula: random numbers'); hold off

 currFrame = getframe(h);
 writeVideo(vidObj,currFrame)

 F(i) = getframe;
end
   close(vidObj);
