function legs_analysis(dataset_name)

maximum_lag = 25;

path_datasets = '../datasets/';
data_path_name = strcat(path_datasets, dataset_name);

data_raw = load(data_path_name);

[acf, stderr, lqp, qpvall] = acorf(data_raw', maximum_lag);

[parcor, sig, cil, ciu] = pacf(data_raw', maximum_lag);

[R,lag] = xcorr(data_raw);

clf;
subplot(2,1,1); stem(acf,'.k');
ylabel('ACF');
xlabel('lag');
subplot(2,1,2); stem(parcor,'.k');
ylabel('Parcial ACF');
xlabel('lag');

path_result = ["res_" dataset_name];
mkdir(path_result);
path_result = [path_result "/"];
filename_prints = [path_result dataset_name "_print"];

print([filename_prints "lag.eps"],"-color");
print([filename_prints "lag.svg"],"-color");

