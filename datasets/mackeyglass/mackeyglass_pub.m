function mackeyglass_pub

delete ('html\*.*');
opts.format ='html';
opts.outputDir = 'html';
opts.evalCode = false;
publish('mackeyglass_eq.m',opts);
publish('mackeyglass_rk4.m',opts);
opts.evalCode = true;
opts.maxOutputLines = 21;
file = publish('mackeyglass.m',opts);
web(file);
disp(file);
