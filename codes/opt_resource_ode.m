
function dy=opt_resource_ode(t,y,u,beta_e,gamma_e)
global gamma_0 mu beta_0 
S=y(1);
I=y(2);
R=y(3);

dS=mu-(beta_0*S*I)/(1+beta_e*u)-mu*S;
dI=(beta_0*S*I)/(1+beta_e*u)-(gamma_0*(1+gamma_e*(1-u))+mu)*I;
dR=(gamma_0*(1+gamma_e*(1-u)))*I-mu*R;
dy=[dS;dI;dR];

end