function timeSeries = MackyGlassTS()

dt = 1;
t = [0:dt:18]';

y = lsode("MackyGlassDifferential", 1.2, t);
 
timeSeries = [ t, y];

endfunction

function ydot = f(y, t)
    ydot = t * sqrt( y );
endfunction

function xdot = MackyGlassDifferential(x,t)
	tau = 17;
	x_tau = 0;
	dt = 1;
	steps = round(t/dt);
	if ((t - tau) >= 0)
		x_tau = x(t - tau + 1);
	endif

	xdot = (0.2 * x_tau)/(1 + x_tau^10) -  0.1 * x;

endfunction

