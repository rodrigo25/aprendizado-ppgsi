% TrainELM - Train an Extreme Learning Machine (ELM) classification model
%   ELMmodel=trainELM(X,Y,nh) returns an ELM classification  model with nh
%   neurons on the hidden layer for predictors X and class labels Y.
% IMPUT
%   X  - Training data
%   Y  - Class labels
%   nh - Number of neurons on the hidden layer
% OUTPUT
%   model - Stucture of ELM model
%
function [ELMmodel] = trainELM(X, Y, nh)
  % Verify if class labels Y are in right form
  %if size(Y,2)==1 && size(unique(Y),1)>2
  %  Y = transformClassLabels2Binary(Y);
  %end
  ne = size(X, 2);
  [N, ~] = size(Y);
  X = [X, ones(N, 1)];

  W = rand(ne + 1, nh)/10;
  Hi = X * W;
  H = 1./(1 + exp(-Hi));
  Bi = pinv(H) * Y;
  %Y = H * Bi;
  ELMmodel = struct('W',W,'Bi',Bi);
end


