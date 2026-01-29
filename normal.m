clear all

%aviobj = avifile('mymovie.avi','fps',10,'quality',100);

vidObj = VideoWriter('mymovie.avi');
vidObj.Quality = 100;
open(vidObj);

mu = 1; % Population parameter
n = 200; % Sample size
ns = 2000; % Number of samples

samples = exprnd(mu,n,ns); % Population samples
means = mean(samples); % Sample means
[muhat,sigmahat,muci,sigmaci] = normfit(means);

numbins = 60;





% hist(means,numbins)
%  set(gca, 'Ylim', [0,110])
%  set(gca, 'Xlim', [0.7,1.3])
% xlabel('Martin.LozanoBanda@mbs.ac.uk'); ylabel('Frequency');
% title('Histogram of a normal variable x');
% % colorbar('YTickLabel',...
% %     {'Freezing','Cold','Cool','Neutral',...
% %      'Warm','Hot','Burning','Nuclear'})
% set(get(gca,'Children'),'FaceColor',[.8 .8 1])
% hold on
% [bincounts,binpositions] = hist(means,numbins);
% binwidth = binpositions(2) - binpositions(1);
% histarea = binwidth*sum(bincounts);
% x = binpositions(1):0.001:binpositions(end);
% y = normpdf(x,muhat,sigmahat);
% plot(x,histarea*y,'r','LineWidth',2)

 for i=1:size(means,2)
close
h=figure;
hist(means(1:i),numbins)
 set(gca, 'Ylim', [0,120])
 set(gca, 'Xlim', [0.7,1.3])
xlabel('Martin.LozanoBanda@mbs.ac.uk'); ylabel('Frequency');
title('Histogram of a normal variable x');

set(get(gca,'Children'),'FaceColor',[.8 .8 1])
hold on
text(0.8,115,'Ball number','HorizontalAlignment','center');
text(0.9,115,num2str(i),'HorizontalAlignment','center')
% text(1.12,100,'Value','HorizontalAlignment','center')
% text(1.2,100,num2str(means(i)),'HorizontalAlignment','center')
scatter((means(i)),110,80,'filled');
[bincounts,binpositions] = hist(means(1:i),numbins);
binwidth = binpositions(2) - binpositions(1);
histarea = binwidth*sum(bincounts);
x = binpositions(1):0.001:binpositions(end);
y = normpdf(x,muhat,sigmahat);
plot(x,histarea*y,'r','LineWidth',2)
%aviobj = addframe(aviobj,h);
 currFrame = getframe(h);
 writeVideo(vidObj,currFrame)

 F(i) = getframe;

end
  close(vidObj);
 %aviobj = close(aviobj);



 
 
%  for i=1:size(means,2)
% close
% h=figure;
% hist(means(1:i),numbins)
%  set(gca, 'Ylim', [0,700])
%  set(gca, 'Xlim', [0.8,1.2])
% xlabel('Martin.LozanoBanda@mbs.ac.uk'); ylabel('Frequency');
% title('Histogram of a normal variable x');
% 
% set(get(gca,'Children'),'FaceColor',[.8 .8 1])
% hold on
% [bincounts,binpositions] = hist(means(1:i),numbins);
% binwidth = binpositions(2) - binpositions(1);
% histarea = binwidth*sum(bincounts);
% x = binpositions(1):0.001:binpositions(end);
% y = normpdf(x,muhat,sigmahat);
% plot(x,histarea*y,'r','LineWidth',2)
% aviobj = addframe(aviobj,h);
% 
% end
% 
%  aviobj = close(aviobj);
% 

