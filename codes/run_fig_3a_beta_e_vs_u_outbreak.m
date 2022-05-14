clc;
clear ALL;

%%   parameters   %%%%%%%% 
global gamma_0 mu beta_0 beta_e_step beta_e_last u_step S0 I0 y0 time_interval
gamma_0=0.1;
mu=0;
beta_0=0.8;
beta_e_step=0.5;          %%% step_length_of_beta_e
beta_e_last=6;            %%% last value of beta_e
u_step=0.01;              %%% step_length_of_u
%% initial values and time interval %%%%%%%%%%%%%%%%%%
time_interval=[0 1000];
S0=0.99;
I0=0.01;
R0=1-S0-I0;
y0=[S0 I0 R0];

figure;

%%   analytical results  %%%%%%%%%%%%
for gamma_e=[0.5 1 2 4];   %%% particular values of gamma_e
    L1=0;
    n=numel(0:beta_e_step:beta_e_last);
    u_opt=[];
    u_f=[];        %% optimal resource from analytical results

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
   R_0=beta_0./(gamma_0*(1+beta_e*u_opt(i)).*(1+gamma_e*(1-u_opt(i))));
%    peak(i)=S0+I0+(log(1/(S0*R_0))-1)./R_0;
 
   if R_0*S0>1 
       u_f(i)=u_opt(i);
   end
end
        
L1=length(u_f);
beta_e=0:beta_e_step:beta_e_last;
plot(beta_e(1:L1),u_f,'linewidth',5)
hold on
end
                   
xlim([-0.37 6.37])    
ylim([-0.058 1.06])
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
set(gca,'ticklength',2.2*get(gca,'ticklength'))
set(gca,'linewidth',2.5)
legend('\boldmath$\gamma_{e}$=0.5','\boldmath$\gamma_{e}$=1','\boldmath$\gamma_{e}$=2','\boldmath$\gamma_{e}$=4')
set(legend,'Interpreter','LaTeX','FontSize',25 )
set(legend,'color','none');
set(legend, 'Box', 'off');

%% numerical simulation%%%%%%%%%%%%%%%%%

for gamma_e=[0.5 1 2 4];           %%% particular values of gamma_e
    U_f=[];                          %% optimal resource from numerical simulation
    L2=0;
    beta_e_index=0;            %% index of beta_e  
    
for beta_e=0:beta_e_step:beta_e_last
    beta_e_index=beta_e_index+1;           
    peak=[];                %%% epidemic peak_corresponding_to_each_u_from_0_to_1      
    u_index=0;              %%% index of u
    
    for u=0:u_step:1
        u_index=u_index+1;  
        [t,y] = ode45(@opt_resource_ode,time_interval,y0,[],u,beta_e,gamma_e);
        peak(u_index)=max(y(:,2));

    end

    [A(beta_e_index),B(beta_e_index)]=min(peak);
    if A(beta_e_index)>I0
       U_f(beta_e_index)=B(beta_e_index);
    end
  
end

beta_e=0:beta_e_step:beta_e_last;
u=0:u_step:1;
L2=length(U_f);
plot(beta_e(1:L2),u(U_f),'o','linewidth',2.3,'MarkerSize',10.5)
hold on
end
