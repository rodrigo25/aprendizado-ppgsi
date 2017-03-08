function [ alfa, b ] = decompositionSVM( X, Y, ker, C, QPsize )

  [m,ne] = size(X);
  ns = size(Y ,2);
  
  class0 = find(Y == -1);
  class1 = find(Y == 1);
  
end

