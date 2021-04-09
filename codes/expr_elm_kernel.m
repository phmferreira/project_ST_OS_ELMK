function expr_elm_kernel(dataset_name, legs = 1)

path_datasets = '../datasets/';

[data_legs, mu, sigma] = data_to_legs(dataset_name, legs);

train_data = data_legs;

test_data = data_legs(101:end,:);

LearningTime = 0;

t = [1:size(test_data,1)];

outputs = zeros(size(test_data,1),1);

index = 1;

for new_test_sample = test_data'
    
    new_test_sample = new_test_sample';
    
    [timeTrain,timeTest,output] = elm_kernel(train_data(1:(100 + index - 1),:), new_test_sample, 0, 10, 'RBF_kernel',1);

    outputs(index) = output;
    index += 1;

    LearningTime += timeTrain;
    
endfor

outputs = featureDesnormalize(outputs, mu, sigma);
test_data = featureDesnormalize(test_data(:,1), mu, sigma);

[RMSE, NRMSE, MAPE, SMAPE] = calc_errors(test_data,outputs)
LearningTime

path_result = ["res_" dataset_name];
mkdir(path_result);
path_result = [path_result "/"];

filename_prints = [path_result dataset_name "_print"];

clf;
plot(t, test_data(:,1),'-;Série alvo;', t, outputs, '-.r;Predição;');
ylabel(dataset_name);
xlabel('Amostras');

print([filename_prints ".eps"],"-color");
print([filename_prints ".svg"],"-color");

erro = generateErrorST(outputs,test_data);

clf;
plot(t,erro,'-;Erro;');
ylabel('Erro de predição');
xlabel('Amostras');

print([filename_prints "_err.eps"],"-color");
print([filename_prints "_err.svg"],"-color");

filename_save = [path_result dataset_name "_perf.mat"];

save("-text", filename_save, "RMSE", "NRMSE", "MAPE", "SMAPE", "LearningTime");

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
