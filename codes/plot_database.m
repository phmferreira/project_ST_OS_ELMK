function plot_database(filename)

path_datasets = '../datasets/';

data_path_name = strcat(path_datasets, filename);

data_raw = load(data_path_name);

train_data = data_raw(:,1);

T = [1:size(train_data,1)];

plot(T, train_data(:,1),'-;Série Temporal;');xlim([0 T(end)]);
ylabel(filename);
xlabel('Amostras');


path_result = ["res_" filename];
mkdir(path_result);
path_result = [path_result "/"];

filename_prints = [path_result filename "_print"];

%print([filename_prints "_o.eps"],"-color");
print([filename_prints "_o.svg"],"-color");
%print([filename_prints "_o_latex.eps"],"-depslatex");
%print([filename_prints "_o.tikz"],"-dtikz");

end
