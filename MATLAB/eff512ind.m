close all; 
clear all; 
clc; 

load F-F_Research_Data_Factors.txt
load 5_Industry_Portfolios.txt
load 12_Industry_Portfolios.txt


time_full = F_F_Research_Data_Factors(1:end,1);
rf_full = F_F_Research_Data_Factors(1:end,5);
R_full = X5_Industry_Portfolios(1:end,2:end);
R12_full = X12_Industry_Portfolios(1:end,2:end);
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
    R12_s = R12_full(i:window+i-1,:);

    R = mean(R_s)';
    R12 = mean(R12_s)';
    rf = mean(rf_s);
    sigma = cov(R_s);
    invsigma = inv(sigma);
    sigma12 = cov(R12_s);
    invsigma12 = inv(sigma12);
    
    I = ones(5,1);
    a = I'*invsigma*I;
    b = I'*invsigma*R;
    c = R'*invsigma*R;
    d = (a*c)-b^2;
    g = (invsigma*(c*I-b*R))/d;
    h = (invsigma*(a*R-b*I))/d; 
    
    I12 = ones(12,1);
    a12 = I12'*invsigma12*I12;
    b12 = I12'*invsigma12*R12;
    c12 = R12'*invsigma12*R12;
    d12 = (a12*c12)-b12^2;
    g12 = (invsigma12*(c12*I12-b12*R12))/d12;
    h12 = (invsigma12*(a12*R12-b12*I12))/d12; 

        
    % Minimum variance
    w_GMV(i,:) = (invsigma*I)/a;
    mu_GMV(i) = w_GMV(i,:)*R;
    var_GMV(i) = 1/a;
    sigma_GMV(i) = var_GMV(i)^0.5;
    sr_GMV(i) = mu_GMV(i)/sigma_GMV(i);

    w_GMV12(i,:) = (invsigma12*I12)/a12;
    mu_GMV12(i) = w_GMV12(i,:)*R12;
    var_GMV12(i) = 1/a12;
    sigma_GMV12(i) = var_GMV12(i)^0.5;
    sr_GMV12(i) = mu_GMV12(i)/sigma_GMV12(i);

    
    % Tangent portfolio
    w_TGP(i,:) = (invsigma*(R-rf))/(I'*invsigma*(R-rf));
    mu_TGP(i) = w_TGP(i,:)*R;
    var_TGP(i) = w_TGP(i,:)*sigma*w_TGP(i,:)';
    sigma_TGP(i) = var_TGP(i)^0.5;
    sr_TGP(i) = mu_TGP(i)/sigma_TGP(i);
    
    w_TGP12(i,:) = (invsigma12*(R12-rf))/(I12'*invsigma12*(R12-rf));
    mu_TGP12(i) = w_TGP12(i,:)*R12;
    var_TGP12(i) = w_TGP12(i,:)*sigma12*w_TGP12(i,:)';
    sigma_TGP12(i) = var_TGP12(i)^0.5;
    sr_TGP12(i) = mu_TGP12(i)/sigma_TGP12(i);

 for j = 1:length(rho);
     w(:,j) = g + h*rho(j);
     vp(j) = w(:,j)'*sigma*w(:,j);
 end
    sdp=vp.^0.5;
    
     for j = 1:length(rho);
     w12(:,j) = g12 + h12*rho(j);
     vp12(j) = w12(:,j)'*sigma12*w12(:,j);
 end
    sdp12=vp12.^0.5;
    
     close
    h=figure;

    p=plot(sdp,rho, 'r');
    set(p,'Color','red','LineWidth',2)
    axis([0 20 -1 6])
    title ('US efficient frontiers: 5 (red) and 12 (blue) industry portfolios')
    ylabel ('Expected return')
    xlabel ('Standard deviation')
    hold on
    scatter(sigma_TGP(i),mu_TGP(i),115,'filled');
    scatter(sigma_GMV(i),mu_GMV(i),115,'filled');
    scatter(sigma_TGP12(i),mu_TGP12(i),115,'filled');
    scatter(sigma_GMV12(i),mu_GMV12(i),115,'filled');

    text(1.5,5.5,'ini:','HorizontalAlignment','right')
    text(1.5,5,'end:','HorizontalAlignment','right')
    text(3.5,5.5,num2str(t_s(1)),'HorizontalAlignment','right')
    text(3.5,5,num2str(t_s(end)),'HorizontalAlignment','right')
    hold off
    hold on
    plot(sdp12,rho, 'b','LineWidth',2);
    %set(q,'Color','blue,'LineWidth',2)

    hold off
    
 currFrame = getframe(h);
 writeVideo(vidObj,currFrame)

 F(i) = getframe;
 
end

   close(vidObj);
