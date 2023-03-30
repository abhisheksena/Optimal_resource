clc;
clear ALL;

%% parameters  %%%%%%%%%%%%%%%%%
global gamma_0 mu beta_0 u_step beta_e gamma_e S0 I0 R0
gamma_0=0.1;                    %%% recovery rate
beta_0=0.8;                     %%% transmission rate
mu=0;                           %%% natural birth-death rate

%%  Initial condition  %%%%%%%%%%%%%%
S0=0.99999;        %%% initial proportion of susceptible individuals
I0=0.00001;        %%% initial proportion of infected individuals
R0=1-S0-I0;        %%% initial proportion of recovered individuals
y0=[S0 I0 R0];

beta_e=2;           %%% particular value of beta_e 
gamma_e=2;          %%% particular value of gamma_e  

         %% control without delay %%%%%%%%%%%%
u_opt=(beta_e - gamma_e + beta_e*gamma_e)./(2*gamma_e*beta_e);
R_0=beta_0/(gamma_0*(1+beta_e*u_opt)*(1+gamma_e*(1-u_opt)));
peak_0=S0+I0-(log(S0*R_0)+1)/R_0;       %%%% peak without delay %%%%%%%%%
                       
          %% control with delay %%%%%%%%%
                  
u_step=0.005;          %%% step_length_of_u       
d_step=0.5;            %%% step_length_of_delay
d_last=19;             %%% last value of delay
tic
p=0;
peak_1=0;              %%%%%% peak for each delay time %%%%%%%

                       
relat_incr=[];         %%%%%%% relative increase of peak for each delay %%%%%%%
 for d=0.00001:d_step:d_last           %%% initial delay time
    p=p+1;                   
   peak=[];                  %%% peak_value_corresponding_to_each_u_from_0_to_1
    y2=[];
    y3=[];
    
    q=0;             
    for u=0:u_step:1

    q=q+1;         

time_interval_1=[0 d];
beta_e1=0;                  %%% beta_e before start of control 
gamma_e1=0;                 %%% gamma_e before start of control

[t,y2] = ode45(@opt_resource_ode,time_interval_1,y0,[],u,beta_e1,gamma_e1);
hold on

time_interval_2=[d 1200]; 

S2=y2(end,1);          %%% proportion of susecptible after d day
I2=y2(end,2);          %%% proportion of individual after d day
R2=1-S2-I2;            %%% proportion of recovered after d day
t2=[S2 I2 R2];         %%% initial condition for control (proportion after d day without control)

[t,y3] = ode45(@opt_resource_ode,time_interval_2,t2,[],u,beta_e,gamma_e);

peak(q)=max([y2(:,2);y3(:,2)]);
    end

    peak_1=min(peak);
    relat_incr(p)=((peak_1-peak_0)/peak_1)*100;
 end
delay=0.00001:d_step:d_last;
lnth=length(0.00001:d_step:7.5);
plot(delay(lnth:end),relat_incr(lnth:end),'linewidth',5)

% plot(delay,relat_incr,'linewidth',5)

%% axis %%%%%%%%%%%%%%%% 
xlim([7 19.5])   %%% increased a bit 
ylim([-2 100.5])
set(findall(gcf,'-property','FontSize'),'FontName','Helvetica','FontSize',35,'fontweight','b')   
xlabel('\boldmath$\tau$','Interpreter','LaTeX','FontSize',35)
 ylabel('\boldmath$RI_\tau$','Interpreter','LaTeX','FontSize',35)
axis square
ax = gca;
set(gca,'XTick',[0 7 11 15 19]);   %%% tick location
set(gca,'XTickLabel',{'$\bf{0}$','$\bf{7}$','$\bf{11}$','$\bf{15}$','$\bf{19}$'}); % tick labels
set(gca,'TickLabelInterpreter','latex')
set(gca,'YTick',[0 25 50 75 100]);
set(gca,'YTickLabel',{'$\bf{0}$','$\bf{25}$','$\bf{50}$','$\bf{75}$','$\bf{100}$'})
set(gca,'ticklength',1.5*get(gca,'ticklength'))
set(gca,'linewidth',2)
