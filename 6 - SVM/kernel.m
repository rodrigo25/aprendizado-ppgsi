function [K] = kernel( X, x, Ker, param )
  if strcmp(Ker, 'linear')
    K = (X*x');
  elseif strcmp(Ker,'poly') 
    K =((X*x').^param);
  elseif strcmp(Ker,'rbf')
    %K= gaussianKernel_modificado(X,x,param);
    K = exp( -(sqrt(sum((X - repmat(x,size(X,1),1)).^2,2)).^2)/(2*param^2));
  end
end 




function K = gaussianKernel_modificado(X1, X2, param)
    N1 = size(X1, 1);
    N2 = size(X2, 1);
    K = zeros(N1, N2);
    for i = 1:N1
        for j = 1:N2
            dif = X1(i, :) - X2(j, :);
            norma = dif*dif';
            K(i,j) = exp(-norma/(2*param^2));
        end
    end
end


