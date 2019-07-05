function [alfa,b]=SVM_quadprog(X,Y,C,Ker,param)
if strcmp(Ker, 'linear')
    K = (X*X');
    H = (Y*Y').*K;
elseif strcmp(Ker,'poly')
    K=((X*X').^param);
    H = (Y*Y').*K;
elseif strcmp(Ker,'rbf')
    K= gaussianKernel_modificado(X,X,param);
    H = (Y*Y').*K;
end
[N,ne]=size(X);
c = -ones(N,1);
A = Y';
alfa = quadprog(H, c, [], [], A, 0, zeros(N,1), C*ones(N,1));
NSV = sum(alfa>0);
id = find(alfa>0);
b = (1/NSV)*sum((K*(alfa.*Y) - Y));
end


function K = gaussianKernel_modificado(X1, X2, param)
    N = size(X2, 1);
    n = size(X1, 1);
    xny = zeros(N, n);
    for i = 1:N
        for j = 1:n
            dif = X2(i, :) - X1(j, :);
            norma = dif*dif';
            xny(i,j) = exp(-norma/(2*param^2));
        end
    end
    K = xny';
end

