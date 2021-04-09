function [X_norm, mu, sigma] = featureNormalize(X)
%   FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. This is often a good preprocessing step to do when
%   working with learning algorithms.

% Initialize some useful values
X_norm = X;
mu = zeros(1, size(X, 2));
sigma = zeros(1, size(X, 2));

% For each feature dimension, compute the mean
% of the feature and subtract it from the dataset,
% storing the mean value in mu. Next, compute the 
% standard deviation of each feature and divide
% each feature by it's standard deviation, storing
% the standard deviation in sigma. 
%
% Note that X is a matrix where each column is a 
% feature and each row is an example. We need 
% to perform the normalization separately for 
% each feature. 

	mu = sum(X) / length(X);
	sigma = std(X);
	
	for i=1:length(X),
		X_norm(i,:) = (X(i,:) - mu) ./ sigma;
	end

end
