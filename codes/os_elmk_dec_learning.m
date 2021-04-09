function [model, outputs_news, TrainingTime] = os_elmk_dec_learning(model, train_data, bs)

%%%%%%%%%%% Load training dataset
T=train_data(:,1)';
P=train_data(:,2:size(train_data,2))';
[outputs_news, executing_time] = predict_os_elmk(model,train_data);
E_bs = T - outputs_news;
clear train_data;                % Release raw training data array

%% ver se tem diferença em calcular f(x_new) com o theta_i (como no aritog)

tic;

%% Computer G using (17)
K_lines_bs = kernel_matrix_os(model.P, model.kernel_type, model.kernel_para, P');
G = -(model.R_inv \ K_lines_bs);

%% Computer gamma_bs using (26)
K_2lines_bs = kernel_matrix_os(P', model.kernel_type, model.kernel_para, P');
n = size(K_2lines_bs,1);
gamma_bs = (K_2lines_bs + speye(n)/model.C) +(K_lines_bs') * G;

%% Computer theta_new using (27)
theta_new = gamma_bs \ (E_bs');

%% Computer delta_theta using (20)
delta_theta = G * theta_new;

% Computer theta_ast
theta_ast = [(model.theta + delta_theta') theta_new'];
model.theta = theta_ast((bs+1):end);

% Computer R using (35)
% R_new = [model zeros(n, size(model.T,1));

% Computer K_elm_new
K_elm_new = [model.K_elm K_lines_bs; (K_lines_bs') K_2lines_bs];
model.K_elm = K_elm_new(((bs+1):end),((bs+1):end));

% Computer R_new using (29)
R_inv_new = (K_elm_new + speye(size(K_elm_new,1))/model.C);
model.R_inv = R_inv_new(((bs+1):end),((bs+1):end));

%% Update what is necessary
model.P = [model.P((bs+1):end,:); P'];
model.T = [model.T((bs+1):end); T'];

TrainingTime=toc;

TrainingTime += executing_time;
endfunction
