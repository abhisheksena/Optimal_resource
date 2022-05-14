clc;
clear ALL;

%% parameters  %%%%%%%%%%%
global gamma_0 mu beta_0 S0 I0 R0 time_interval beta_e_step beta_e_last u_step
gamma_0=0.1;
mu=0.007;
beta_0=0.8;
u_step=0.01;
beta_e_step=0.2;
beta_e_last=4;
 
%% initial values and time interval %%%%%%%%%%%%%%%%%%
S0=0.99;
I0=0.01;
R0=1-S0-I0;
y0=[S0 I0 R0];
time_interval=0:0.5:3000;
figure;

%% without control %%%%%%%%%%%%%%%%%%%%%%
 u=0;               %%%% arbitary value of u
 beta_e_woc=0;            %%% without control beta_e=0
 gamma_e_woc=0;           %%% without control gamma_e=0
 [t,y] = ode45(@opt_resource_ode,time_interval,y0,[],u,beta_e_woc,gamma_e_woc);
 I_last_woc=y(end,2);          %%%%% I^* without control
 
 %% with control %%%%%%%%%%%%%%%%%%%%%%%%%%
 for gamma_e=[0.5 1 2];      %%% particular values of gamma_e
     beta_e_index=0;         %%% index of beta_e
     RR_I=[];                 %%% relative reduction of I
     for beta_e=0:beta_e_step:beta_e_last
         beta_e_index=beta_e_index+1;
         u_index=0;             %%% index of u 
         I_last=[];             %%% last values of I corresponding to each u from 0 to 1
         for u=0:u_step:1
             u_index=u_index+1; 
             [t,y] = ode45(@opt_resource_ode,time_interval,y0,[],u,beta_e,gamma_e);
             I_last(u_index)=y(end,2);
         end
         I_last_wc=min(I_last);   %%% I^* with control
         RR_I(beta_e_index)= ((I_last_woc - I_last_wc)/I_last_woc)*100;
     end
     
     beta_e=0:beta_e_step:beta_e_last;
     plot(beta_e,RR_I,'linewidth',5)
     hold on 
 end
 
%% axis %%%%%%%%%%%%%%%% 
xlim([-0.18 4.17]) 
ylim([-5 105])
set(findall(gcf,'-property','FontSize'),'FontName','Helvetica','FontSize',35,'fontweight','b')   
xlabel('\boldmath$\beta_e$','Interpreter','LaTeX','FontSize',35)
 ylabel('\boldmath$RR_{I^*}$','Interpreter','LaTeX','FontSize',35)
axis square
ax = gca;
set(gca,'XTick',[0 1 2 3 4]);   %%% tick location
set(gca,'XTickLabel',{'$\bf{0}$','$\bf{1}$','$\bf{2}$','$\bf{3}$','$\bf{4}$'}); % tick labels
set(gca,'TickLabelInterpreter','latex')
set(gca,'YTick',[0 25 50 75 100]);
set(gca,'YTickLabel',{'$\bf{0}$','$\bf{25}$','$\bf{50}$','$\bf{75}$','$\bf{100}$'})
set(gca,'ticklength',2.2*get(gca,'ticklength'))
set(gca,'linewidth',2.5)
legend('\boldmath$\gamma_{e}$=\bf 0.5','\boldmath$\gamma_{e}$=\bf 1','\boldmath$\gamma_{e}$=\bf 2')
set(legend,'Interpreter','LaTeX','FontSize',25 )
set(legend,'color','none');
set(legend, 'Box', 'off');