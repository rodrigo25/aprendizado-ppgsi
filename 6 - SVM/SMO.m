% FUNCTION: SMO - SVM treinado com SMO
%                 Implementacao do Sequential Minimal Optimization (SMO) baseado no artigo do Platt 1998
% PARAMETERS: X - Conjunto de entrada
%             Y - Saida
%             C - Parametro Soft Margin
%             Ker - Funcao de kernel desejada ('linear', 'poly', 'rbf')
%             param - Parametro da funcao de kernel -> Linear: /
%                                                      Polinomial: grau do polinomio (d)
%                                                      Gaussiano: sigma
%             tol - Tolerancia de erro
%             max_passes - Limite de iterações do algoritmo
function [ alfa, b ] = SMO( X, Y, C1, Ker1, param1, tol1, max_passes )
  % ORGANIZACAO DAS VARIAVEIS GLOBAIS
  global point target alpha threshold C Ker param tol eps error_cache m;
  point = X; target = Y; C = C1; Ker = Ker1; param = param1; tol = tol1;
  clear X Y C1 Ker1 param1 tol1;
  
  % INICIA VARIAVEIS
  m = size(point,1); % m - qtd exemplos
  alpha = zeros(m,1);
  threshold = 0;
  numChanged = 0;
  examineAll = 1;
  eps = 0.001;
  error_cache = zeros(m,1);
  passes = 0;
  
  % OUTER LOOP - FIRST CHOICE HEURISTIC
  while ((numChanged>0 || examineAll ) && (passes<max_passes) )
  %while ( numChanged>0 || examineAll )
    numChanged = 0;
    passes = passes+1;
    
    if (examineAll) % Loop por todos os exemplos
      for i=1:m
        numChanged = numChanged + examineExample(i);
      end
    else % Loop por apenas exemplos em que o alfa nao eh 0 nem C
      heuristicList = find(alpha>0 & alpha<C);
      for i=heuristicList'
        numChanged = numChanged + examineExample(i);
      end
    end
    
    if (examineAll == 1)
      examineAll = 0;
    elseif (numChanged == 0)
      examineAll = 1;
    end
  end

  % RETORNO DA FUNCAO
  alfa = alpha;
  b = -threshold;
  
  passes
  
  % LIMPA VARIAVEIS GLOBAIS
  clear point target alpha threshold C Ker param tol eps error_cache m;
end %function SMO

function result = examineExample(i2)
  global point target alpha C tol error_cache m;
  result = 0; % retorno da funcao
  
  % VALORES REFERENTES A i2
  x2 = point(i2,:);
  y2 = target(i2,:);
  alph2 = alpha(i2);
  if (alph2>0 && alph2<C) % Verifica se tem cache do erro
    E2 = error_cache(i2);
  else
    [fx2,~] = output(x2);
    E2 = fx2 - y2;
  end
  r2 = E2*y2;
  
  if ( (r2<-tol && alph2<C) || (r2>tol && alph2>0) )
    
    % SECOND CHOICE HEURISTIC - Part 1
    tmax = -1;
    heuristicList = find(alpha>0 & alpha<C);
    if ~isempty(heuristicList)
   
      for i=heuristicList'
        E1 = error_cache(i);
        temp = abs(E1 - E2);
        if temp>tmax
          tmax = temp;
          i1 = i;
        end
      end
      
      if (tmax>=0)
        if takeStep(i1, i2, E2)
          result = 1;
          return
        end
      end
    
      % SECOND CHOICE HEURISTIC - Part 2
      % loop over all non-zero and non-C alpha, starting at a random point
      for i1=heuristicList(randperm(size(heuristicList,1)))'
        if takeStep(i1, i2, E2)
          result = 1;
          return
        end
      end
    
    end
    
    % SECOND CHOICE HEURISTIC - Part 3
    % loop over all possible i1, starting at a random point
    for i1=randperm(m)
      if ~(alpha(i1)>0 && alpha(i1)<C) % pula valores ja testados
        if takeStep(i1, i2, E2)
          result = 1;
          return
        end
      end
    end
      
  end % if ( (r2<-tol && alph2<C) || (r2>tol && alph2>0) )
  
end %examineExample

function result = takeStep(i1, i2, E2)
  global point target alpha threshold C error_cache eps;
  result = 0;
  
  if (i1==i2)
    return
  end
  
  % VALORES REFERENTES A i1
  x1 = point(i1,:);
  y1 = target(i1,:);
  alph1 = alpha(i1);
  if (alph1>0 && alph1<C) % Verifica se tem cache do erro
    E1 = error_cache(i1);
  else
    [fx1,~] = output(x1);
    E1 = fx1 - y1;
  end
  
  % VALORES REFERENTES A i2
  x2 = point(i2,:);
  y2 = target(i2,:);
  alph2 = alpha(i2);
  
  s = y1*y2;
  
  % CALCULA L & H
  if y1 ~= y2
    L = max(0, alph2 - alph1);
    H = min(C, C + alph2 - alph1);
  else % y1 == y2
    L = max(0, alph1 + alph2 - C);
    H = min(C, alph1 + alph2);
  end
      
  if L == H
    return
  end
  
  % CALCULA eta(n)
  k11 = kernelSMO(x1, x1);
  k12 = kernelSMO(x1, x2);
  k22 = kernelSMO(x2, x2);
  eta = 2*k12-k11-k22;
  
  % CALCULA novo alfa2
  if (eta<0) % Circunstancias normais, existe maximo e eta<0
    a2 = alph2 - y2*(E1-E2)/eta; %calcula novo valor
    if (a2<L) a2 = L; % CLIPPING a2 - mantem valor dentro da caixa L H
    elseif (a2>H) a2 = H;
    end
  else % Circunstancias anormais
    c1 = eta/2;
    c2 = y2*(E1-E2)-eta*alph2;
    Lobj = c1 * L * L + c2 * L;
    Hobj = c1 * H * H + c2 * H;
    
    if (Lobj > Hobj+eps)
      a2 = L;
    elseif (Lobj < Hobj-eps)
      a2 = H;
    else
      a2 = alph2;
    end
  end % if(eta<0)
  
  % Erro de arredondamento do a2 nas bordas
  if (a2<1e-8)
    a2 = 0;
  elseif (a2>C-1e-8) 
    a2 = C;
  end
  
  if ( abs(a2-alph2) < eps*(a2+alph2+eps) )
    return
  end
  
  % CALCULA novo alfa1
  a1 = alph1+s*(alph2-a2);
  
  %if (a1<0)
  %  a2 = a2 + s*a1;
  %  a1 = 0;
  %elseif a1>C
  %  a2 = a2 + s*(a1-C);
  %  a1 = C;
  %end
  
  % ATUALIZA b   
  if (a1>0 && a1<C)       % b = b1
    bNew = E1 + y1*(a1-alph1)*k11 + y2*(a2-alph2)*k12 + threshold;
  elseif (a2>0 && a2<C)   % b = b2
    bNew = E2 + y1*(a1-alph1)*k12 + y2*(a2-alph2)*k22 + threshold;
  else                    % b = (b1+b2)/2
    b1 = E1 + y1*(a1-alph1)*k11 + y2*(a2-alph2)*k12 + threshold;
    b2 = E2 + y1*(a1-alph1)*k12 + y2*(a2-alph2)*k22 + threshold;
    bNew = (b1+b2)/2;
  end
  
  deltab = threshold - bNew;
  threshold = bNew;
  %deltab = 0;
  
  %ATUALIZA CACHE DE ERRO
  for k=1:size(alpha,1)
    if (alpha(k)>0 && alpha(k)<C)
      error_cache(k) = error_cache(k) +  y1*(a1-alph1)*kernelSMO(x1, point(k,:))  +  y2*(a2-alph2)*kernelSMO(x2, point(k,:)) + deltab;
    end
  end
  error_cache(i1) = 0;
  error_cache(i2) = 0;
  
  %ATUALIZA ALFA
  alpha(i1)=a1;
  alpha(i2)=a2;
  
  result = 1;
end


% CALCULA SAIDA DO SVM PARA O EXEMPLO x
function [ f, Y ] = output( x )
  global target alpha threshold;
  
  K = kernelSMO(x);

  f = (alpha.*K)'*target - threshold;
  Y = sign(f);
end

% CALCULA O KERNEL DO SVM PARA O EXEMPLO x
function [K] = kernelSMO( x1, x2 )
  global point Ker param m;
  
  if nargin == 1 % Kernel entre um valor x1 e o conj de entrada point
    if strcmp(Ker, 'linear')
      K = (point*x1');
    elseif strcmp(Ker,'poly')
      K = ((point*x1').^param);
    elseif strcmp(Ker,'rbf')
      K = exp( -(sqrt(sum((point - repmat(x1,m,1)).^2,2)).^2)/(2*param^2));
    end
    
  else % Kernel entre dois valores x1 e x2
    if strcmp(Ker, 'linear')
      K = (x1*x2');
    elseif strcmp(Ker,'poly')
      K = ((x1*x2').^param);
    elseif strcmp(Ker,'rbf')
      K = exp( -(sqrt(sum((x1 - x2).^2,2)).^2)/(2*param^2));
    end
  end
  
end
