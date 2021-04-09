function [X_desnorm] = featureDesnormalize(X_norm, mu, sigma)

X_desnorm = X_norm * sigma + mu;

endfunction
