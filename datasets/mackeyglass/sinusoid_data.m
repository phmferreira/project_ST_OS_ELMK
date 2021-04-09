function x = sinusoid_data()

T = 0:1:1200;
f = 1/1550 * pi;
a = 0.3;

x = a * sin(f*T);
x = x';

plot(T,x)
print -color sinusoid.eps

endfunction
