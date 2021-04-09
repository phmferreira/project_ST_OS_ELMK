function [outputs,TestingTime] = predict_os_elmk(model, test_data)

%%%%%%%%%%% Load testing dataset
TV.T=test_data(:,1)';
TV.P=test_data(:,2:size(test_data,2))';
clear test_data;                                    % Release raw testing data array

%%%%%%%%%%% Calculate the output of testing input
tic;
OutputWeight = ((model.R_inv)\(model.T));
Omega_test = kernel_matrix_os(model.P,model.kernel_type,model.kernel_para,TV.P');
outputs=(Omega_test' * OutputWeight)';              % outputs: the actual output of the testing data
TestingTime=toc;
endfunction
