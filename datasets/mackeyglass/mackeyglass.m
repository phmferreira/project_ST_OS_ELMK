clear all;
%% mackeyglass
% This script generates a Mackey-Glass time series using the 4th order
% Runge-Kutta method.
% The code is a straighforward translation in Matlab of C source code provided by Roger Jang,
% which is available <http://neural.cs.nthu.edu.tw/jang/dataset/mg/mg.c here>


%% The theory
% Mackey-Glass time series refers to the following, delayed differential
% equation:

%%
% 
% $$\frac{dx(t)}{dt}=\frac{ax(t-\tau)}{1+x(t-\tau)^{10}}-bx(t)
% \hspace{1cm} (1)$$
% 

%% 
% It can be numerically solved using, for example, the 4th order
% Runge-Kutta method, at discrete, equally spaced time steps:

%%
% 
% $$x(t+\Delta t) = mackeyglass\_rk4(x(t), x(t-\tau), \Delta t, a, b)$$
%

%%
% where the function <mackeyglass_rk4.html mackeyglass_rk4> numerically solves the
% Mackey-Glass delayed differential equation using the 4-th order Runge
% Kutta. This is the RK4 method:


%%
% $$k_1=\Delta t \cdot mackeyglass\_eq(x(t), x(t-\tau), a, b)$$
%%
% $$k_2=\Delta t \cdot mackeyglass\_eq(x(t+\frac{1}{2}k_1), x(t-\tau), a, b)$$
%%
% $$k_3=\Delta t \cdot mackeyglass\_eq(x(t+\frac{1}{2}k_2), x(t-\tau), a, b)$$
%%
% $$k_4=\Delta t \cdot mackeyglass\_eq(x(t+k_3), x(t-\tau), a, b)$$
%%
% $$x(t+\Delta t) = x(t) + \frac{k_1}{6}+ \frac{k_2}{3} + \frac{k_3}{6} +
% \frac{k_4}{6}$$

%%
% where <mackeyglass_eq.html mackeyglass_eq> is the function which return 
% the value of the Mackey-Glass delayed differential equation in (1)
% once its inputs and its parameters (a,b) are provided.



%%
% Here is an example:

%% Input parameters
a        = 0.2;     	% value for a in eq (1)
b        = 0.1;     	% value for b in eq (1)
tau      = 17;		% delay constant in eq (1)
x0       = 1.2;		% initial condition: x(t=0)=x0
deltat   = 1;	   	% time step size (which coincides with the integration step)
sample_n = 1200;	% total no. of samples, excluding the given initial condition
interval = 1;	    	% output is printed at every 'interval' time steps


%% Main algorithm
% * x_t             : x at instant t         , i.e. x(t)        (current value of x)
% * x_t_minus_tau   : x at instant (t-tau)   , i.e. x(t-tau)   
% * x_t_plus_deltat : x at instant (t+deltat), i.e. x(t+deltat) (next value of x)
% * X               : the (sample_n+1)-dimensional vector containing x0 plus all other computed values of x
% * T               : the (sample_n+1)-dimensional vector containing time samples
% * x_history       : a circular vector storing all computed samples within x(t-tau) and x(t)

time = 0;
index = 1;
history_length = floor(tau/deltat);
x_history = zeros(history_length, 1); % here we assume x(t)=0 for -tau <= t < 0
x_t = x0;

X = zeros(sample_n+1, 1); % vector of all generated x samples
T = zeros(sample_n+1, 1); % vector of time samples

for i = 1:sample_n+1,
    X(i) = x_t;
    if (mod(i-1, interval) == 0),
         disp(sprintf('%4d %f', (i-1)/interval, x_t));
    end
    if tau == 0,
        x_t_minus_tau = 0.0;
    else
        x_t_minus_tau = x_history(index);
    end

    x_t_plus_deltat = mackeyglass_rk4(x_t, x_t_minus_tau, deltat, a, b);

    if (tau ~= 0),
        x_history(index) = x_t_plus_deltat;
        index = mod(index, history_length)+1;
    end
    time = time + deltat;
    T(i) = time;
    x_t = x_t_plus_deltat;
end

sinusoid = sinusoid_data();

size(T);

X = X + sinusoid;

save MG_chaotic X;

plot(T, X,'-;Mackey-Glass Alterada;', T, sinusoid,'-;Senoide;'); xlim([0 T(end)]);
xlabel('Tempo'); ylabel('Amplitude');
print -color mg_sinusoid.eps
