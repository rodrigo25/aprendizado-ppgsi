function [YY] = transformClassLabels2Binary(y)
% transformClassLabels2Binary - Transforms a decimal vector of class labels
% in a multiclass binary representation for classification
%   [YY] = transformClassesBinary(y) returns a 
% EXEMPLE
%   YY = trasnformClassesBinary([1; 2; 5])
%   YY = 
%        1 0 0
%        0 1 0
%        0 0 1
% IMPUT
%   y  - decimal vector of class labels
% OUTPUT
%   YY - multiclass binary representation of class labels
  classes = unique(y);    % Value of each class labeled in y
  qtdClasses = size(classes,1); % Total number of diferent class labels
  [n] = size(y,1);        % Total number of entries
  
  YY = zeros(n,qtdClasses);
  
  % Transform class labels
  for i=1:qtdClasses
    YY(y==classes(i),i) = 1;
  end
  
end