clc;
clear ALL;

%%   parameters   %%%%%%%% 

global gamma_0 beta_0 beta_e_step beta_e_last u_step S0 
gamma_0=0.1;               %%% recovery rate
S0=0.999;                  %%% Initial proportion of susceptible individuals
beta_0=0.8;                 %%% transmission rate

beta_e_step=0.01;          %%% step_length_of_beta_e
beta_e_last=6;            %%% last value of beta_e
u_step=0.01;              %%% step_length_of_u

figure;

%%   analytical results  %%%%%%%%%%%%

for gamma_e=[0.5 1 2 5];    %%% particular values of gamma_e
    L1=0;
    n=numel(0:beta_e_step:beta_e_last);
    u_opt=[];
    u_peak=[];        %% optimal resource from analytical results

for i=1:n
   beta_e=0+(i-1)*beta_e_step;
   u=(beta_e-gamma_e+beta_e*gamma_e)./(2*beta_e*gamma_e);
   if u>=1
        u_opt(i)=1;
    else if u>0 && u<1
         u_opt(i)=u;
         else u_opt(i)=0;
        end
   end
   R_0=beta_0./(gamma_0*(1+beta_e*u_opt(i)).*(1+gamma_e*(1-u_opt(i)))); %%% basic reproduction number
 
   if R_0*S0>1         %%% condition for initial growth of outbreak size or I_max>I0
       u_peak(i)=u_opt(i);
   end
end
        
L1=length(u_peak);
beta_e=0:beta_e_step:beta_e_last;
plot(beta_e(1:L1),u_peak,'linewidth',5)
hold on
end
                   
xlim([-0.17 6.17])   
ylim([-0.033 1.035])
set(findall(gcf,'-property','FontSize'),'FontName','Helvetica','FontSize',35,'fontweight','b')   
xlabel('\boldmath$\beta_{e}$','Interpreter','LaTeX','FontSize',35) 
ylabel('\boldmath$u_{\rm peak}^{*}$','Interpreter','LaTeX','FontSize',35)
axis square
ax = gca;
set(gca,'XTick',[0 2 4 6]);   %%% tick location
set(gca,'XTickLabel',{'$\bf{0}$','$\bf{2}$','$\bf{4}$', '$\bf{6}$'}); % tick labels
set(gca,'TickLabelInterpreter','latex')
set(gca,'YTick',[0 0.25 0.50 0.75 1]);
set(gca,'YTickLabel',{'$\bf{0}$','$\bf{0.25}$','$\bf{0.50}$','$\bf{0.75}$', '$\bf{1}$' })
set(gca,'ticklength',2*get(gca,'ticklength'))
set(gca,'linewidth',2)
legend('\boldmath$\gamma_{e}$=\bf0.5','\boldmath$\gamma_{e}$=\bf1','\boldmath$\gamma_{e}$=\bf2','\boldmath$\gamma_{e}$=\bf5')
set(legend,'Interpreter','LaTeX','FontSize',25 )
set(legend,'color','none');
set(legend, 'Box', 'off');

