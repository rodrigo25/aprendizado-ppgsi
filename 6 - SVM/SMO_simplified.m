%function [ alfa, b ] = SMO( C, tol, max_passes, X, Y, Ker, param )
function [ alfa, b ] = SMO_simplified( X, Y, C, Ker, param, tol, max_passes )

[m, ne] = size(X);
ns = size(Y,2);

alfa = zeros(m,1);
b = 0;
passes = 0;

while passes<max_passes
  num_changed_alphas = 0;
  
  for i=1:m
    %valores referentes a i
    ai = alfa(i);
    xi = X(i,:);
    yi = Y(i,:);
    [fxi,~] = outputSVM( alfa, b, X, Y, xi, Ker, param);
    %Calcula Ei
    Ei = fxi - yi;
    %Condição
    if ((yi*Ei < -tol && ai < C) || (yi*Ei > tol && ai > 0))
      j = randi([1 m-1],1); % seleciona j randomicamente
      if (j>=i) j=j+1; end  % seleciona j randomicamente
      
      %valores referentes a j
      aj = alfa(j);
      xj = X(j,:);
      yj = Y(j,:);
      [fxj,~] = outputSVM( alfa, b, X, Y, xj, Ker, param);
      %Calcula Ej
      Ej = fxj - yj;
      
      % Salva valores de alfa antigo
      aiold = ai;
      ajold = aj;
      
      if yi ~= yj
        L = max(0, aj - ai);
        H = min(C, C + aj - ai);
      elseif yi == yj
        L = max(0, ai + aj - C);
        H = min(C, ai + aj);
      end
      
      if L == H continue; end
      
      eta = 2*kernel(xi, xj, Ker, param) - kernel(xi, xi, Ker, param) - kernel(xj, xj, Ker, param);
      
      if eta >= 0 continue; end
      
      aj = aj - (yj*(Ei-Ej))/eta;
      
      if (aj > H)            aj=H;
      elseif (L <= aj <= H)  aj=aj;
      elseif (aj < L)        aj=L;
      end
      
      if (abs(aj - ajold) < 1e-5) continue; end
      
      ai = ai + yi*yj*(ajold - aj);
      
      
      b1 = b - Ei - yi*(ai-aiold)*kernel(xi, xi, Ker, param) - yj*(aj-ajold)*kernel(xi, xj, Ker, param);
      b2 = b - Ej - yi*(ai-aiold)*kernel(xi, xj, Ker, param) - yj*(aj-ajold)*kernel(xj, xj, Ker, param);
      
      if (0< ai <C)     b=b1;
      elseif (0< aj <C) b=b2;
      else              b=(b1+b2)/2;
      end
      
      alfa(i)=ai;
      alfa(j)=aj;
      
      num_changed_alphas = num_changed_alphas + 1;
      
    end % if
  end %for
  
  if num_changed_alphas ~= 0
    passes = passes + 1;
  else
    passes = 0;
  end
end %while

end %function

