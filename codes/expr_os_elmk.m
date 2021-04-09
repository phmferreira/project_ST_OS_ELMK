function expr_os_elmk(dataset_name, legs = 1, bs = 1,learn_type = 'os')

path_datasets = '../datasets/';

[data_legs, mu, sigma] = data_to_legs(dataset_name, legs);

train_data = data_legs(1:100,:);

%% bluid the the off-line model
[model,learning_time] = os_elmk_model(train_data, 0, 10, 'RBF_kernel',1);

test_data = data_legs(101:end,:);

len_test_data = size(test_data,1);
outputs = zeros(len_test_data,1);
t = [1:len_test_data];

for i = 1:bs:len_test_data

    index_end_bs = 0;

    if (i + bs - 1) <= len_test_data 
        index_end_bs = (i + bs - 1);
    else
        index_end_bs = len_test_data;
    endif
    
    data_bs = test_data(i:index_end_bs,:);
    if strcmp(learn_type,'os')
        [model,output_bs,time_bs] = os_elmk_seq_learning(model,data_bs);
    elseif strcmp(learn_type,'dec')
        [model,output_bs,time_bs] = os_elmk_dec_learning(model,data_bs,bs);
    endif

    learning_time += time_bs;
    outputs(i:index_end_bs) = output_bs;

endfor

outputs = featureDesnormalize(outputs, mu, sigma);
test_data = featureDesnormalize(test_data(:,1), mu, sigma);

[RMSE, NRMSE, MAPE, SMAPE] = calc_errors(test_data,outputs)
learning_time

path_result = ["res_" learn_type "_lags_" mat2str(legs)  "_bs_" mat2str(bs) "_" dataset_name];
mkdir(path_result);
path_result = [path_result "/"];

filename_prints = [path_result dataset_name "_print"];

plot(t, test_data(:,1),'-;Série alvo;', t, outputs, '-.r;Predição;');
ylabel(dataset_name);
xlabel('Amostras');

print([filename_prints ".eps"],"-color");
print([filename_prints ".svg"],"-color");

erro = generateErrorST(outputs,test_data);

plot(t,erro,'-;Erro;')
ylabel('Erro de predição');
xlabel('Amostras');

print([filename_prints "_err.eps"],"-color");
print([filename_prints "_err.svg"],"-color");

filename_save = [path_result dataset_name "_perf.mat"];

save("-text", filename_save, "bs", "RMSE", "NRMSE", "MAPE", "SMAPE", "learning_time");

clf;
subplot(2,1,1); plot(t, test_data(:,1),'-;Série alvo;', t, outputs, '-.r;Predição;'); xlim ([0 t(end)])
grid
ylabel(dataset_name);
xlabel('Amostras');
subplot(2,1,2); 
plot(t,erro,'-;Erro;'); xlim ([0 t(end)]);
grid
ylabel('Erro de predição');
xlabel('Amostras');

print([filename_prints "2.eps"],"-color");
print([filename_prints "2.svg"],"-color");

clear all;

endfunction
