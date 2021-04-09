clear all;

dataset_name = 'djia';

path_datasets = '../datasets/';

[data_legs, mu, sigma] = data_to_legs(dataset_name,1);

train_data = data_legs(1:100,:);

%% bluid the the off-line model
[model,learning_time] = os_elmk_model(train_data, 0, 10, 'RBF_kernel',1);

test_data = data_legs(101:end,:);

bs = 20;
len_test_data = size(test_data,1);
outputs = zeros(len_test_data,1);
t = [1:len_test_data];

LearningTime = 0;

for i = 1:bs:len_test_data

    index_end_bs = 0;

    if (i + bs - 1) <= len_test_data 
        index_end_bs = (i + bs - 1);
    else
        index_end_bs = len_test_data;
    endif
    
    data_bs = test_data(i:index_end_bs,:);
    [model,output_bs,time_bs] = os_elmk_seq_learning(model,data_bs);

    learning_time += time_bs;
    outputs(i:index_end_bs) = output_bs;

endfor

outputs = featureDesnormalize(outputs, mu, sigma);
test_data = featureDesnormalize(test_data(:,1), mu, sigma);

[RMSE, NRMSE, MAPE, SMAPE] = calc_errors(test_data,outputs)
LearningTime

path_result = ["res_os_" dataset_name];
mkdir(path_result);
path_result = [path_result "/"];

filename_prints = [path_result dataset_name "_print"];

plot(t, test_data(:,1),'-;DJIA;', t, outputs, '-.r;Predição;');
ylabel('DJIA');
xlabel('Número do dia');

print([filename_prints ".eps"],"-color");
print([filename_prints ".svg"],"-color");

erro = generateErrorST(outputs,test_data);

plot(t,erro,'-;Erro;')
ylabel('Erro de predição');
xlabel('Número do dia');

print([filename_prints "_err.eps"],"-color");
print([filename_prints "_err.svg"],"-color");

filename_save = [path_result dataset_name "_perf.mat"];

save("-text", filename_save, "RMSE", "NRMSE", "MAPE", "SMAPE", "LearningTime");
