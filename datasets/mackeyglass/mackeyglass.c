/* Mackey-Glass time series using 4th-order Runge-Kutta method */
/* Roger Jang, EECS Dept., UC Berkeley, 1992 */

#include <stdio.h> 
#include <math.h> 

/* Return dx/dt of Mackey-Glass diff. equation */
double
MGeq(double x, double time, double x_tau)
{
	double a = 0.2;
	double b = 0.1;
	double x_dot;
	x_dot = -b*x + a*x_tau/(1 + pow(x_tau, 10.0));
	return(x_dot);
}

/* 4-th order Runge-Kutta integration formula for one variable */
double 
rk4(double x_now, double time, double step, double x_tau)
{
	double a, b, c, d;
	a = step*MGeq(x_now,       time,          x_tau);
	b = step*MGeq(x_now+0.5*a, time+step/2.0, x_tau);
	c = step*MGeq(x_now+0.5*b, time+step/2.0, x_tau);
	d = step*MGeq(x_now+c,     time+step,     x_tau);
	return(x_now + a/6 + b/3 + c/3 + d/6);
}

int
main()
{
	double step_size = 0.1;	/* integration step */
	double x = 1.2;		/* initial condition */
	int sample_n = 12000;	/* total no. of samples, excluding the given
				   initial condition */
	int tau = 17;		/* delay constant */
	int interval = 10;	/* output is printed at every 10 time steps */
	double x_tau;		/* x(t-tau) */
	double x_next;
	double time = 0;
	int i, index = 0;
	double *x_history;	/* array to store delay information */
	int history_length;

	history_length = (int)(tau/step_size);
	x_history = (double *)calloc(history_length, sizeof(double));
	if (history_length != 0) {
		x_history = (double *)calloc(history_length, sizeof(double));
		for (i = 0; i < history_length; i++)
			x_history[i] = 0;
	}

	for (i = 0; i <= sample_n; i++) {
		if (i%interval == 0) printf("%4d %f\n", i/interval, x);
		x_tau = tau == 0 ? x:x_history[index];
		x_next = rk4(x, time, step_size, x_tau);
		if (tau != 0) {
			x_history[index] = x_next;
			index = (index + 1)%history_length; 
		}
		time += step_size;
		x = x_next;
	}
	return(0);
}
