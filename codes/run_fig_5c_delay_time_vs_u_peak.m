
clc;
clear ALL;

figure;
%% parameters  %%%%%%%%%%%%%%%%%
global gamma_0 mu beta_0 u_step delay_step delay_last S0 I0 initial_delay
gamma_0=0.1;                    %%% recovery rate
beta_0=0.8;                     %%% transmission rate
mu=0;                           %%% natural birth-death rate


u_step=0.0025;                   %%% step_length_of_u
delay_step=0.5;                  %%% step_length_of_delay
initial_delay=0.00001;           %%% initial delay time
delay_last=19;                 %%% last value of delay

%%  Initial condition  %%%%%%%%%%%%%%
S0=0.99999;           %%% initial proportion of susceptible individuals
I0=0.00001;           %%% initial proportion of infected individuals
R0=1-S0-I0;           %%% initial proportion of recovered individuals

beta_e=2;             %%% particular value of beta_e 
gamma_e=2;            %%% particular value of gamma_e


        delay_index=0;
        u_peak=[];        %%%%%% u_peak value for each delay
        for delay_time=initial_delay:delay_step:delay_last 
            delay_index=delay_index+1;           
            peak=[];                    %%%epidemic_peak_corresponding_to_each_u_from_0_to_1
            y_bc=[];                    %%%% time series before control
            y_ac=[];                    %%%% time series after control
    
            time_interval=[0 delay_time];
            y0_bc=[S0 I0 R0];             %%%%%%%%% initial condition before control
            beta_e_woc=0;                 %%%%%%%%% without control beta_e
            gamma_e_woc=0;                %%%%%%%%% without control gamma_e
            u1=0.5;
            [t,y_bc] = ode45(@opt_resource_ode,time_interval,y0_bc,[],u1,beta_e_woc,gamma_e_woc);
            
            
            u=(beta_e+beta_e*gamma_e-gamma_e)/(2*beta_e*gamma_e);
    if u>=1
        u_opt(delay_index)=1;
    else if u>0 && u<1
         u_opt(delay_index)=u;
         else u_opt(delay_index)=0;
        end
    end
%  I=mu./(gamma_0*(1+gamma_e*(1-a1(i)))+mu)-(mu*(1+beta_e*a1(i)))/beta_0;
   R_0=beta_0./((1+beta_e*u_opt(delay_index)).*(gamma_0*(1+gamma_e*(1-u_opt(delay_index)))+mu));
   if y_bc(end,1)*R_0>=1 
       u_long(delay_index)=u_opt(delay_index);
       u_long_min(delay_index)=NaN;
       u_long_max(delay_index)=NaN;
   else
       A=gamma_e*beta_e;
       B=gamma_e-beta_e-beta_e*gamma_e;
       C=y_bc(end,1)*beta_0/gamma_0-gamma_e-1;
       coefficients=[A B C];
       u_long(delay_index)=NaN;
       u_long_min(delay_index)=min(roots(coefficients));
       u_long_max(delay_index)=max(roots(coefficients));
       
   end
   if u_long_max(delay_index)>=1
           u_long_max(delay_index)=1;
   end
      
   if u_long_min(delay_index)<=0
           u_long_min(delay_index)=0;
   end

        end          
      
hold on        
delay_time=initial_delay:delay_step:delay_last;
% plot(delay_time,u_long,'linewidth',5,'edgealpha',0.2)
plot(delay_time,u_long,'linewidth',5)
hold on
b=bar(delay_time, [u_long_min; u_long_max-u_long_min].',0.8, 'stacked','FaceAlpha',1);
b(1).Visible = 'off';            

% hold on
%% axis    %%%%%%%%%%%
xlim([-0.75 19])   
ylim([-0.03 1.03])
set(findall(gcf,'-property','FontSize'),'FontName','Helvetica','FontSize',35,'fontweight','b')   
xlabel('\boldmath$\tau$','Interpreter','LaTeX','FontSize',35)
ylabel('\boldmath$u^{*}_{\rm peak}$','Interpreter','LaTeX','FontSize',35)
axis square
ax = gca;
set(gca,'XTick',[0 5 10 15 20]);   %%% tick location
set(gca,'XTickLabel',{'$\bf{0}$','$\bf{5}$','$\bf{10}$','$\bf{15}$','$\bf{20}$'}); % tick labels
set(gca,'TickLabelInterpreter','latex')
set(gca,'YTick',[0 0.25 0.50 0.75 1]);
set(gca,'YTickLabel',{'$\bf{0}$','$\bf{0.25}$','$\bf{0.50}$','$\bf{0.75}$','$\bf{1}$'})
set(gca,'ticklength',1.5*get(gca,'ticklength'))
set(gca,'linewidth',2)

