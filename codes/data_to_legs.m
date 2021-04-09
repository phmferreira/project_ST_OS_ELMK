function [data_in_legs, mu, sigma] = data_to_legs(filename, legs = 1)

path_datasets = '../datasets/';
data_path_name = strcat(path_datasets, filename);

data_raw = load(data_path_name);

[data_raw, mu, sigma] = featureNormalize(data_raw(:,1));

# formato do dado
# 1ª coluna é a saída desejada
# depois #legs colunas

len_data = size(data_raw,1);

data_in_legs = ones(len_data - legs, 1 + legs);

for i = 0:legs

    data_in_legs(:,i + 1) = data_raw((legs + 1 - i):(end - i),1);

endfor

endfunction
