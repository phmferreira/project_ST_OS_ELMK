function perf = mse(E)

    perf = sum(E.^2);
    elements = numel(E);
    perf = perf / elements;
