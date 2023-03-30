clc;
clear ALL;

%% parameters  %%%%%%%%%%%
global gamma_0 mu beta_0 beta_e_step beta_e_last
gamma_0=0.1;         %%% recovery rate
mu=1/(70*365);       %%% natural birth-death rate
beta_0=0.8;          %%% transmission rate
beta_e_step=0.01;    %%% step length of beta_e
beta_e_last=6;       %%% last value of beta_e
 
figure;

%% without control %%%%%%%%%%%%%%%%%%%%%%
I_last_woc=mu/(gamma_0+mu)-mu/beta_0;         %%%%% I^* without control
  
 %% with control %%%%%%%%%%%%%%%%%%%%%%%%%%
 for gamma_e=[0.5 1 2 5];      %%% particular values of gamma_e
     beta_e_index=0;           %%% index of beta_e
     RR_I=[];                  %%% relative reduction of I
     u_long=[];
     for beta_e=0:beta_e_step:beta_e_last
         beta_e_index=beta_e_index+1;
         
    u=(beta_e.*(gamma_0+gamma_0*gamma_e+mu)-sqrt(beta_0*gamma_0*beta_e.*gamma_e))./(gamma_0*beta_e.*gamma_e);
    if u>=1
        u_long(beta_e_index)=1;
    else if u>0 && u<1
         u_long(beta_e_index)=u;
         else u_long(beta_e_index)=0;
        end
    end
         I_last_wc(beta_e_index)=mu./(gamma_0*(1+gamma_e*(1-u_long(beta_e_index)))+mu)-mu*(1+beta_e*u_long(beta_e_index))/beta_0;   %%% I^* with control
         RR_I(beta_e_index)= ((I_last_woc - I_last_wc(beta_e_index))/I_last_woc)*100;
         
         if  RR_I(beta_e_index)>=100
              RR_I(beta_e_index)=100;
         end
     end
     
     beta_e=0:beta_e_step:beta_e_last;
     plot(beta_e,RR_I,'linewidth',5)
     hold on 
 end
 
%% axis %%%%%%%%%%%%%%%% 
xlim([-0.18 6.17]) 
ylim([30 105])
set(findall(gcf,'-property','FontSize'),'FontName','Helvetica','FontSize',35,'fontweight','b')   
xlabel('\boldmath$\beta_e$','Interpreter','LaTeX','FontSize',35)
 ylabel('\boldmath$RR_{I^*}$','Interpreter','LaTeX','FontSize',35)
axis square
ax = gca;
set(gca,'XTick',[0 2 4 6]);   %%% tick location
set(gca,'XTickLabel',{'$\bf{0}$','$\bf{2}$','$\bf{4}$','$\bf{6}$','$\bf{4}$'}); % tick labels
set(gca,'TickLabelInterpreter','latex')
set(gca,'YTick',[40 60 80 100]);
set(gca,'YTickLabel',{'$\bf{40}$','$\bf{60}$','$\bf{80}$','$\bf{100}$'})
set(gca,'ticklength',1.5*get(gca,'ticklength'))
set(gca,'linewidth',2)
legend('\boldmath$\gamma_{e}$=\bf 0.5','\boldmath$\gamma_{e}$=\bf 1','\boldmath$\gamma_{e}$=\bf 2','\boldmath$\gamma_{e}$=\bf 5')
set(legend,'Interpreter','LaTeX','FontSize',25 )
set(legend,'color','none');
set(legend, 'Box', 'off');