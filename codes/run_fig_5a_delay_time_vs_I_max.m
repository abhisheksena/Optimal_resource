 clc;
clear ALL;

%% parameters  %%%%%%%%%%%%%%%%%
global gamma_0 mu beta_0 u_step delay_step delay_last S0 I0 initial_delay
gamma_0=0.1;
mu=0;
beta_0=0.5;

u_step=0.0025;                   %%%step_length_of_u
delay_step=0.5;                  %%%step_length_of_delay
initial_delay=0.00001;           %%% initial delay time
delay_last=27.5;                 %%% last value of delay

%%  Initial condition  %%%%%%%%%%%%%%
S0=0.9999;
I0=0.0001;
R0=1-S0-I0;

for beta_e=[0.5]   %%% particular value of beta_e for each (beta_e, gamma_e) combination 

    for gamma_e=[0.4]      %%% particular value of gamma_e for each (beta_e, gamma_e) combination 
        delay_index=0;
        I_max=[];        %%%%%% epidemic peak value for each delay
        for delay_time=initial_delay:delay_step:delay_last 
            delay_index=delay_index+1;           
            peak=[];                  %%%epidemic_peak_corresponding_to_each_u_from_0_to_1
            y_bc=[];                    %%%% time series before control
            y_ac=[];                    %%%% time series after control
    
            u_index=0;                    %%%%%index_of_u
            for u=0:u_step:1
                u_index=u_index+1;         
                
%%%%%%%% after control %%%%%%%%%%%%%%%%%%%%%%%%%%
                time_interval=[0 delay_time];
                y0_bc=[S0 I0 R0];             %%%%%%%%% initial condition before control
                beta_e_woc=0;                 %%%%%%%%% without control beta_e
                gamma_e_woc=0;                %%%%%%%%% without control gamma_e
                [t,y_bc] = ode45(@opt_resource_ode,time_interval,y0_bc,[],u,beta_e_woc,gamma_e_woc);
                hold on
                
%%%%%%%% after control %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                time_interval=[delay_time 400];
                y0_ac=[y_bc(end,1) y_bc(end,2) 1-y_bc(end,1)-y_bc(end,2)];      %%%%%%%%% initial condition at the begining of control  
                [t,y_ac] = ode45(@opt_resource_ode,time_interval,y0_ac,[],u,beta_e,gamma_e);
                peak(u_index)=max([y_bc(:,2);y_ac(:,2)]);
            end
            I_max(delay_index)=min(peak);       %%%%%% epidemic peak corresponding to each delay time 
        end
    end
    
delay_time=initial_delay:delay_step:delay_last;
plot(delay_time,I_max,'linewidth',5)
hold on 
end

%% axis
xlim([-1.2 27.5])  
ylim([-0.02 0.53])
set(findall(gcf,'-property','FontSize'),'FontName','Helvetica','FontSize',35,'fontweight','b')   
xlabel('\boldmath$\tau$','Interpreter','LaTeX','FontSize',35)
ylabel('\boldmath$I_{\rm max}$','Interpreter','LaTeX','FontSize',35) 
axis square
ax = gca;
set(gca,'XTick',[0 7 14 21 27]);   %%% tick location
set(gca,'XTickLabel',{'$\bf{0}$','$\bf{7}$','$\bf{14}$','$\bf{21}$','$\bf{27}$'}); % tick labels
set(gca,'TickLabelInterpreter','latex')
set(gca,'YTick',[0 0.1 0.2 0.3 0.4 0.5]);
set(gca,'YTickLabel',{'$\bf{0}$','$\bf{0.1}$','$\bf{0.2}$','$\bf{0.3}$', '$\bf{0.4}$','$\bf{0.5}$'})
set(gca,'ticklength',2.2*get(gca,'ticklength'))
set(gca,'linewidth',2.5)
