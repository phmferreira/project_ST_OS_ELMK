clear all;

dataset_name = 'djia';

path_datasets = '../datasets/';

[data_legs, mu, sigma] = data_to_legs(dataset_name,1);

train_data = data_legs;

test_data = data_legs(101:end,:);

LearningTime = 0;

t = [1:size(test_data,1)];

outputs = zeros(size(test_data,1),1);

index = 1;

for new_test_sample = test_data'
    
    new_test_sample = new_test_sample';
    
    [timeTrain,timeTest,AccuracyTrain,AccuracyTest,output] = elm_kernel(train_data(1:(100 + index - 1),:), new_test_sample, 0, 10, 'RBF_kernel',1);

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

filename_prints = [dataset_name "_print"];

plot(t, test_data(:,1),'-;DJIA;', t, outputs, '-.r;Predição;');
ylabel('DJIA');
xlabel('Número do dia');

print([filename_prints ".eps"],"-color");
print([filename_prints ".svg"],"-color");
print([filename_prints "_latex.eps"],"-depslatex");
print([filename_prints ".tikz"],"-dtikz");

%print -color resultado_DJIA.eps
%print -color -dtikz resultado_DJIA.tikz
%print -color -depslatex resultado_DJIA_latex.eps
%print -color resultado_DJIA.svg

erro = generateErrorST(outputs,test_data);

plot(t,erro,'-;Erro;')
ylabel('Erro de predição');
xlabel('Número do dia');

print([filename_prints "_err.eps"],"-color");
print([filename_prints "_err.svg"],"-color");
print([filename_prints "_err_latex.eps"],"-depslatex");
print([filename_prints "_err.tikz"],"-dtikz");
%print -color erro_DJIA.eps
%print -color -dtikz erro_DJIA.tikz
%print -color -depslatex resultado_DJIA_latex.eps
%print -color resultado_DJIA.svg

filename_save = [path_result dataset_name "_perf.mat"];

save("-text", filename_save, "RMSE", "NRMSE", "MAPE", "SMAPE", "LearningTime");
