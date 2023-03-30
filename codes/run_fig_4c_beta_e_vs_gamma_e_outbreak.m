clc;
clear ALL;

%%   parameters   %%%%%%%%   

global gamma_0 beta_0 beta_e_step gamma_e_step beta_e_last gamma_e_last S0
S0=0.999;               %%% initial prportion of susceptible individuals
gamma_0=0.1;            %%% recovery rate
beta_0=0.8;             %%% transmission rate

beta_e_step=0.01;       %%% step length of beta_e
gamma_e_step=0.01;       %%% step length of gamma_e
beta_e_last=7;         %%% last value of beta_e
gamma_e_last=7;        %%% last value of gamma_e

beta_e_index=0;          %%% index of beta_e
 for beta_e=0.01:beta_e_step:beta_e_last
     beta_e_index=beta_e_index+1;
     gamma_e_index=0;              %%% index of gamma_e
    
for gamma_e=0.01:gamma_e_step:gamma_e_last
    gamma_e_index=gamma_e_index+1;
    
    u=(beta_e-gamma_e+beta_e*gamma_e)./(2*beta_e*gamma_e);
    if u<=0
          u_peak(beta_e_index,gamma_e_index)=0;
    else if u>=1
               u_peak(beta_e_index,gamma_e_index)=1;
           else
               u_peak(beta_e_index,gamma_e_index)=u;
           end
    end
    R_0(beta_e_index,gamma_e_index)=beta_0/((1+beta_e*u_peak(beta_e_index,gamma_e_index)).*gamma_0*(1+gamma_e*(1-u_peak(beta_e_index,gamma_e_index))));


     if u_peak(beta_e_index,gamma_e_index)>0 && u_peak(beta_e_index,gamma_e_index)<1     %%% for three different color in 0<u_peak<1
        u_peak(beta_e_index,gamma_e_index)=0.5;
     end

end
    
 end
 
beta_e=0.01:beta_e_step:beta_e_last;
gamma_e=0.01:gamma_e_step:gamma_e_last;
[X,Y]=meshgrid(beta_e,gamma_e);
figure;
contourf(X,Y,u_peak');
hold on
contour(X,Y,S0*R_0',[1 1],'r','ShowText','off','linewidth',2)
colormap cool
view(2)

xlim([0 7])  
ylim([0 7])
set(findall(gcf,'-property','FontSize'),'FontName','Helvetica','FontSize',35,'fontweight','b')   
xlabel('\boldmath$\beta_{e}$','Interpreter','LaTeX','FontSize',35) 
 ylabel('\boldmath$\gamma_e$','Interpreter','LaTeX','FontSize',35)
axis square
ax = gca;
set(gca, 'Box', 'off');

set(gca,'XTick',[0 2 4 6 8]);   %%% tick location
set(gca,'XTickLabel',{'$\bf{0}$','$\bf{2}$','$\bf{4}$', '$\bf{6}$', '$\bf{8}$'}); % tick labels
set(gca,'YTick',[0 2 4 6 8]);   %%% tick location
set(gca,'YTickLabel',{'$\bf{0}$','$\bf{2}$','$\bf{4}$', '$\bf{6}$', '$\bf{8}$'}); % tick labels
set(gca,'TickLabelInterpreter','latex')
set(gca,'ticklength',0*get(gca,'ticklength'))
set(gca,'linewidth',2)