clc;
clear ALL;

%%   parameters   %%%%%%%% 
global gamma_0 beta_0 S0 I0 gamma_e_step gamma_e_last u_step
gamma_0=0.1;              %%% recovery rate
S0=0.999;                  %%% Initial proportion of susceptible individuals
beta_0=0.8;                %%% transmission rate

gamma_e_step=0.01;          %%% step length of gamma_e
gamma_e_last=6;            %%% last value of gamma_e
u_step=0.01;             %%% step length of u

figure;

%%   analytical results   %%%%%%%%%%%%
for beta_e=[2 3 4 5];      %%% particular values of beta_e
    L1=0;
    n=numel(0:gamma_e_step:gamma_e_last);
    u_opt=[];
    u_peak=[];        %% optimal resource from analytical results
    
for i=1:n
    gamma_e=0+(i-1)*gamma_e_step;
    u=(beta_e-gamma_e+beta_e*gamma_e)./(2*beta_e*gamma_e);
    if u>=1
       u_opt(i)=1;
    else if u>0 && u<1
            u_opt(i)=u;
         else u_opt(i)=0;
     end
    end
 R_0=beta_0./(gamma_0*(1+beta_e*u_opt(i)).*(1+gamma_e*(1-u_opt(i))));
 
   if R_0*S0>1            %%% condition for initial growth of outbreak size or I_max>I0
       u_peak(i)=u_opt(i);
   end
end
        
L1=length(u_peak);
gamma_e=0:gamma_e_step:gamma_e_last;
plot(gamma_e(1:L1),u_peak,'linewidth',5)
hold on
end
        
xlim([-0.17 6.17])   
ylim([0.25 1.035])
set(findall(gcf,'-property','FontSize'),'FontName','Helvetica','FontSize',35,'fontweight','b')   
xlabel('\boldmath$\gamma_{e}$','Interpreter','LaTeX','FontSize',35)
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
legend('\boldmath$\beta_e$=\bf2','\boldmath$\beta_e$=\bf3','\boldmath$\beta_e$=\bf4','\boldmath$\beta_e$=\bf5')
set(legend,'Interpreter','LaTeX','FontSize',25 )
set(legend,'color','none');
set(legend, 'Box', 'off');

