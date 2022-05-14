 clc;
clear ALL;

%%   parameters   %%%%%%%%    
global gamma_0 mu beta_0 gamma_e_step gamma_e_last u_step S0 I0 y0 time_interval
gamma_0=0.1;
beta_0=0.8;
mu=0.007;
gamma_e_step=0.5;          %%% step length of gamma_e
gamma_e_last=6;            %%% last value of gamma_e
u_step=0.0005;             %%% step length of u
%% initial values and time interval %%%%%%%%%%%%%%%%%%
time_interval=[0 8000];
S0=0.99;
I0=0.01;
R0=1-S0-I0;
y0=[S0 I0 R0];
figure;

%%   analytical results   %%%%%%%%%%%%
for beta_e=[1.5 2.5 3.5 4.5]; %[2 3 4 5];    %%% particular values of beta_e
     L1=0;
     n=numel(0:gamma_e_step:gamma_e_last);
     u_opt=[];
     u_f=[];       %% optimal resource from analytical results
     
for i=1:n
    gamma_e=0+(i-1)*gamma_e_step;
    u=(beta_e.*(gamma_0+gamma_0*gamma_e+mu)-sqrt(beta_0*gamma_0*beta_e.*gamma_e))./(gamma_0*beta_e.*gamma_e);
    if u>=1
        u_opt(i)=1;
    else if u>0 && u<1
         u_opt(i)=u;
         else u_opt(i)=0;
        end
    end
%     I=mu./(gamma_0*(1+gamma_e*(1-a1(i)))+mu)-(mu*(1+beta_e*a1(i)))/beta_0;
      R_0=beta_0./((1+beta_e*u_opt(i)).*(gamma_0*(1+gamma_e*(1-u_opt(i)))+mu));
   if R_0>=1 
       u_f(i)=u_opt(i);
   end
end

L1=length(u_f);
gamma_e=0:gamma_e_step:gamma_e_last;
plot(gamma_e(1:L1),u_f,'linewidth',5)
hold on
end

xlim([-0.37 6.37])   
ylim([-0.058 1.06])
set(findall(gcf,'-property','FontSize'),'FontName','Helvetica','FontSize',35,'fontweight','b')   
xlabel('\boldmath$\gamma_{e}$','Interpreter','LaTeX','FontSize',35)
 ylabel('\boldmath$u_{\rm f}^{*}$','Interpreter','LaTeX','FontSize',35)
axis square
ax = gca;

set(gca,'XTick',[0 2 4 6]);   %%% tick location
set(gca,'XTickLabel',{'$\bf{0}$','$\bf{2}$','$\bf{4}$', '$\bf{6}$'}); % tick labels
set(gca,'TickLabelInterpreter','latex')
set(gca,'YTick',[0 0.25 0.50 0.75 1]);
set(gca,'YTickLabel',{'$\bf{0}$','$\bf{0.25}$','$\bf{0.50}$','$\bf{0.75}$', '$\bf{1}$' })
legend('\bf2','\bf3','\bf4','\bf5')
set(gca,'ticklength',2.2*get(gca,'ticklength'))
set(gca,'linewidth',2.5)

%% Numerical simulation %%%%%%%% 

for beta_e=[1.5 2.5 3.5 4.5];    %[2 3 4 5];       %%% particular values of beta_e
    U_f=[];                          %% optimal resource from numerical simulation
    L2=0;
    gamma_e_index=0;          %% index of gamma_e

 for gamma_e=0:gamma_e_step:gamma_e_last
   gamma_e_index=gamma_e_index+1;           
   I_last=[];         %%%last_value_corresponding_to_each_u_from_0_to_1    
   u_index=0;         %%index_of_u
    
   for u=0:u_step:1
       u_index=u_index+1;          %%%indx_u=indx_u+1;
       [t,y] = ode45(@opt_resource_ode,time_interval,y0,[],u,beta_e,gamma_e);
       I_last(u_index)=y(numel(t),2);

    end

     [A(gamma_e_index),B(gamma_e_index)]=min(I_last);
     R_0=beta_0./((1+beta_e*(B-1)/2000).*(gamma_0*(1+gamma_e*(1-(B-1)/2000))+mu));
     if R_0>1
        U_f(gamma_e_index)=B(gamma_e_index);
     end

end

gamma_e=0:gamma_e_step:gamma_e_last;
u=0:u_step:1;
L2=length(U_f);
plot(gamma_e(1:L2),u(U_f),'o','linewidth',2.3,'MarkerSize',10.5)
hold on
end

