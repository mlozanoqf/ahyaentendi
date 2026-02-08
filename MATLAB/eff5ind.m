close all; 
clear all; 
clc; 

load F-F_Research_Data_Factors.txt
load 5_Industry_Portfolios.txt

time_full = F_F_Research_Data_Factors(1:end,1);
rf_full = F_F_Research_Data_Factors(1:end,5);
R_full = X5_Industry_Portfolios(1:end,2:end);
T = size(time_full,1);

X = 1000;
Y = 6;
rho = linspace(-1,Y,X);
window = 60;

vidObj = VideoWriter('mymovie.avi');
vidObj.Quality = 100;
open(vidObj);

for i = 1:T-window
    t_s = time_full(i:window+i-1);
    rf_s = rf_full(i:window+i-1);
    R_s = R_full(i:window+i-1,:);
    
    R = mean(R_s)';
    rf = mean(rf_s);
    sigma = cov(R_s);
    invsigma = inv(sigma);
    
    I = ones(5,1);
    a = I'*invsigma*I;
    b = I'*invsigma*R;
    c = R'*invsigma*R;
    d = (a*c)-b^2;
    g = (invsigma*(c*I-b*R))/d;
    h = (invsigma*(a*R-b*I))/d; 
        
    % Minimum variance
    w_GMV(i,:) = (invsigma*I)/a;
    mu_GMV(i) = w_GMV(i,:)*R;
    var_GMV(i) = 1/a;
    sigma_GMV(i) = var_GMV(i)^0.5;
    sr_GMV(i) = mu_GMV(i)/sigma_GMV(i);
%     if mu_GMV(i)<0
%         sr_GMVpositive(i)=0;
%     else
%         sr_GMVpositive(i)=mu_GMV(i)/sigma_GMV(i);
%     end
    
    
    % Tangent portfolio
    w_TGP(i,:) = (invsigma*(R-rf))/(I'*invsigma*(R-rf));
    mu_TGP(i) = w_TGP(i,:)*R;
    var_TGP(i) = w_TGP(i,:)*sigma*w_TGP(i,:)';
    sigma_TGP(i) = var_TGP(i)^0.5;
    sr_TGP(i) = mu_TGP(i)/sigma_TGP(i);
%         if mu_TGP(i)<0
%         sr_TGPpositive(i)=0;
%     else
%         sr_TGPpositive(i)=mu_TGP(i)/sigma_TGP(i);
%     end

 for j = 1:length(rho);
     w(:,j) = g + h*rho(j);
     vp(j) = w(:,j)'*sigma*w(:,j);
 end
    sdp=vp.^0.5;
    
     close
    h=figure;

    p=plot(sdp,rho, 'r');
    set(p,'Color','red','LineWidth',2)
    axis([0 20 -1 6])
    title ('US efficient frontier: 5 industry portfolios')
    ylabel ('Expected return')
    xlabel ('Standard deviation')
    hold on
    scatter(sigma_TGP(i),mu_TGP(i),115,'filled');
    scatter(sigma_GMV(i),mu_GMV(i),115,'filled');
    text(1.5,5.5,'ini:','HorizontalAlignment','right')
    text(1.5,5,'end:','HorizontalAlignment','right')
    text(3.5,5.5,num2str(t_s(1)),'HorizontalAlignment','right')
    text(3.5,5,num2str(t_s(end)),'HorizontalAlignment','right')
    
 currFrame = getframe(h);
 writeVideo(vidObj,currFrame)

 F(i) = getframe;
 
end

   close(vidObj);
