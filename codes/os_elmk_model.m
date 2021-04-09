function [model, TrainingTime] = os_elmk_model(train_data, Elm_Type, Regularization_coefficient, Kernel_type, Kernel_para)

% Input:
% TrainingData_File           - Filename of training data set
% Elm_Type                    - 0 for regression; 1 for (both binary and multi-classes) classification
% Regularization_coefficient  - Regularization coefficient C
% Kernel_type                 - Type of Kernels:
%                                   'RBF_kernel' for RBF Kernel
%                                   'lin_kernel' for Linear Kernel
%                                   'poly_kernel' for Polynomial Kernel
%                                   'wav_kernel' for Wavelet Kernel
%Kernel_para                  - A number or vector of Kernel Parameters. eg. 1, [0.1,10]...
% Output: 
%% model                       - composed by matrix R and weight vector theta
%%                             - model.theta = C * (T - Y); %lagrangien multiplier = C * error 
%%                             - model.K_elm = Omega_train;
%%                             - model.R_inv = (Omega_train+speye(n)/C);
%%                             - model.kernel_type = Kernel_type;
%%                             - model.kernel_para = Kernel_para;
%%                             - model.P;
%%                             - model.T;
%%                             - model.C;
%
    %%%%    Authors:    PAULO FERREIRA
    %%%%    UNIVERSIDADE FEDERAL DE PERNAMBUCO, BRASIL
    %%%%    EMAIL:      PHMF@CIN.UFPE.BR
    %%%%    WEBSITE:    http://www.cin.ufpe.br/~phmf
    %%%%    DATE:       JAN 2016


%%%%%%%%%%% Macro definition
REGRESSION=0;
CLASSIFIER=1;

%%%%%%%%%%% Load training dataset
T=train_data(:,1)';
P=train_data(:,2:size(train_data,2))';
clear train_data;                                   %   Release raw training data array
 
C = Regularization_coefficient;
NumberofTrainingData=size(P,2);

if Elm_Type~=REGRESSION
    %%%%%%%%%%%% Preprocessing the data of classification
    sorted_target=sort(cat(2,T,TV.T),2);
    label=zeros(1,1);                               %   Find and save in 'label' class label from training and testing data sets
    label(1,1)=sorted_target(1,1);
    j=1;
    for i = 2:(NumberofTrainingData+NumberofTestingData)
        if sorted_target(1,i) ~= label(1,j)
            j=j+1;
            label(1,j) = sorted_target(1,i);
        end
    end
    number_class=j;
    NumberofOutputNeurons=number_class;
    
    %%%%%%%%%% Processing the targets of training
    temp_T=zeros(NumberofOutputNeurons, NumberofTrainingData);
    for i = 1:NumberofTrainingData
        for j = 1:number_class
            if label(1,j) == T(1,i)
                break; 
            end
        end
        temp_T(j,i)=1;
    end
    T=temp_T*2-1;
                                             
%end if of Elm_Type
end

%%%%%%%%%%% Training Phase %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
n = size(T,2);
Omega_train = kernel_matrix_os(P',Kernel_type, Kernel_para);
OutputWeight=((Omega_train+speye(n)/C)\(T')); 
TrainingTime=toc;

%%%%%%%%%%% Calculate the training output
Y=(Omega_train * OutputWeight)';                             %   Y: the actual output of the training data

model.theta = C * (T - Y); %lagrangien multiplier = C * error 
model.K_elm = Omega_train;
model.R_inv = (Omega_train+speye(n)/C);
model.kernel_type = Kernel_type;
model.kernel_para = Kernel_para;
model.P = P';
model.T = T';
model.C = C;

endfunction
