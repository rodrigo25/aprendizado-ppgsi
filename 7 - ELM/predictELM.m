% predictELM - Predicty class labels with ELM model
%   [Y, accuracy] = predictELM(model, Xte, Yte) predicts class labels for
%   Xte exemples using the ELM model given. It also returns the accuracy
%   when the expected class labels are available.
% IMPUT
%   model     - 
%   Xte       - 
%   Yte       -
% OUTPUT
%   Y         -
%   accuracy  -
%
function [ Y, accuracy] = predictELM(model, Xte, Yte)
  accuracy = [];
  [N, ~] = size(Xte); % N - number entries
  Xte = [Xte, ones(N, 1)];  % add the bias vector to data matrix Xte

  % Predict
  Hi = Xte * model.W;
  H = 1./(1 + exp(-Hi));
  Yaux = H * model.Bi;
  
  % Transform result vector
  Y = zeros(size(Yaux));
  [~,ind] = max(Yaux,[],2);
  for i=1:N
    Y(i,ind(i)) = 1;
  end
  
  if nargin<3, return; end;
  
  % Calculate accuracy
  count = 0;
  for i=1:N
    count = count + isequal(Y(i,:),Yte(i,:));
  end
  accuracy = count/N;
  
end


