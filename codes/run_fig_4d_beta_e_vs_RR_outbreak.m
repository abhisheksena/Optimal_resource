clc;
clear ALL;

%% parameters  %%%%%%%%%%%
global gamma_0 mu beta_0 S0 I0 beta_e_step beta_e_last u_step
gamma_0=0.1;         %%% recovery rate
mu=1/(70*365);       %%% natural birth-death rate
beta_0=0.8;          %%% transmission rate
beta_e_step=0.01;    %%% step length of beta_e
beta_e_last=6;       %%% last value of beta_e

S0=0.999;

figure;
 
 %% without control  %%%%%%%%%%%%%%%%%%%%%%

 R_woc=beta_0./gamma_0;                        %%% basic reproduction number without control
 peak_woc=S0+I0-(log(S0*R_woc)+1)./R_woc;      %%%%% Epidemic-peak without control
 
 %% with control %%%%%%%%%%%%%%%%%%%%%%%%%%
 for gamma_e=[0.5 1 2 5];        %%% particular values of gamma_e
     beta_e_index=0;           %%% index of beta_e
     RR_I_max=[];              %%%%% relative reduction of epidemic peak
     for beta_e=0:beta_e_step:beta_e_last
         beta_e_index=beta_e_index+1;
         u=(beta_e-gamma_e+beta_e*gamma_e)./(2*beta_e*gamma_e);
         if u>=1
       u_peak(beta_e_index)=1;
    else if u>0 && u<1
            u_peak(beta_e_index)=u;
         else u_peak(beta_e_index)=0;
     end
         end
         
         R_0(beta_e_index)=beta_0./((1+beta_e*u_peak(beta_e_index))*(gamma_0*(1+gamma_e*(1-u_peak(beta_e_index)))));
         if S0*R_0(beta_e_index)>1
             
              peak_wc(beta_e_index)=S0+I0-(log(S0*R_0(beta_e_index))+1)./R_0(beta_e_index);       %%%%% peak with control
         else 
              peak_wc(beta_e_index)=I0;
         end
         RR_I_max(beta_e_index)= ((peak_woc -peak_wc(beta_e_index))/peak_woc)*100;
     end
     
     beta_e=0:beta_e_step:beta_e_last;
     plot(beta_e,RR_I_max,'linewidth',5)
     hold on 
 end
 
%% axis %%%%%%%%%%%%%%%% 
xlim([-0.18 6.17])   
ylim([15 105])
set(findall(gcf,'-property','FontSize'),'FontName','Helvetica','FontSize',35,'fontweight','b')   
xlabel('\boldmath$\beta_e$','Interpreter','LaTeX','FontSize',35)
 ylabel('\boldmath$RR_{I_{\rm max}}$','Interpreter','LaTeX','FontSize',35)
axis square
ax = gca;
set(gca,'XTick',[0 2 4 6]);   %%% tick location
set(gca,'XTickLabel',{'$\bf{0}$','$\bf{2}$','$\bf{4}$','$\bf{6}$'}); % tick labels
set(gca,'TickLabelInterpreter','latex')
set(gca,'YTick',[25 50 75 100]);
set(gca,'YTickLabel',{'$\bf{25}$','$\bf{50}$','$\bf{75}$','$\bf{100}$'})
set(gca,'ticklength',1.5*get(gca,'ticklength'))
set(gca,'linewidth',2)
legend('\boldmath$\gamma_{e}$=\bf 0.5','\boldmath$\gamma_{e}$=\bf 1','\boldmath$\gamma_{e}$=\bf 2','\boldmath$\gamma_{e}$=\bf 5')
set(legend,'Interpreter','LaTeX','FontSize',25 )
set(legend,'color','none');
set(legend, 'Box', 'off');