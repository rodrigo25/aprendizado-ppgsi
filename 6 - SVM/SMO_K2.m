% FUNCTION: SMO - SVM treinado com SMO
%                 Implementacao do Sequential Minimal Optimization (SMO) baseado no artigo do Platt 1998
% PARAMETERS: X - Conjunto de entrada
%             Y - Saida
%             C - Parametro Soft Margin
%             K - Matrix de Kernel para o conjunto de entrada
%             tol - Tolerancia do erro
%             max_passes - Limite de iterações do algoritmo
function [ alfa, b ] = SMO_K( X, Y, C1, K1, tol1, max_passes )
  % ORGANIZACAO DAS VARIAVEIS GLOBAIS
  global point target alpha threshold C tol eps error_cache m K;
  point = X; target = Y; C = C1; tol = tol1; K = K1;
  clear X Y C1 K1 tol1;
  
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
  b = threshold;
  
  %passes
  
  % LIMPA VARIAVEIS GLOBAIS
  clear point target alpha threshold C tol eps error_cache m K;
end %function SMO

function result = examineExample(i2)
  global target alpha C tol error_cache m;
  result = 0; % retorno da funcao
  
  % VALORES REFERENTES A i2
  y2 = target(i2,:);
  alph2 = alpha(i2);
  if (alph2>0 && alph2<C) % Verifica se tem cache do erro
    E2 = error_cache(i2);
  else
    [fx2,~] = output(i2);
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
  global target alpha threshold C error_cache eps K;
  result = 0;
  
  if (i1==i2)%OK
    return%OK
  end%OK
  
  % VALORES REFERENTES A i1
  y1 = target(i1,:);%OK
  alph1 = alpha(i1);%OK
  if (alph1>0 && alph1<C) % Verifica se tem cache do erro%OK
    E1 = error_cache(i1);%OK
  else%OK
    [fx1,~] = output(i1);%OK
    E1 = fx1 - y1;%OK
  end%OK
  
  % VALORES REFERENTES A i2
  y2 = target(i2,:);%OK
  alph2 = alpha(i2);%OK
  
  s = y1*y2;%OK
  
  % CALCULA L & H
  if y1 ~= y2
    L = max(0, alph2 - alph1);%OK
    H = min(C, C + alph2 - alph1);%OK
  else % y1 == y2
    L = max(0, alph1 + alph2 - C);%OK
    H = min(C, alph1 + alph2);%OK
  end
      
  if L == H%OK
    return%OK
  end%OK
  
  % CALCULA eta(n)
  k11 = K(i1, i1);%OK
  k12 = K(i1, i2);%OK
  k22 = K(i2, i2);%OK
  eta = 2*k12-k11-k22;%OK
  
  % CALCULA novo alfa2
  if (eta<0) % Circunstancias normais, existe maximo e eta<0%OK
    a2 = alph2 - y2*(E1-E2)/eta; %calcula novo valor%OK
    if (a2<L)     a2 = L; % CLIPPING a2 - mantem valor dentro da caixa L H%OK
    elseif (a2>H) a2 = H;%OK
    end%OK
  else % Circunstancias anormais%OK
    c1 = eta/2; %OK
    c2 = y2*(E1-E2)-eta*alph2;%OK
    Lobj = c1*L*L + c2*L;%OK
    Hobj = c1*H*H + c2*H;%OK
    
    if (Lobj > Hobj+eps)     a2 = L;%OK
    elseif (Lobj < Hobj-eps) a2 = H;%OK
    else                     a2 = alph2;%OK
    end%OK
  end % if(eta<0)%OK
  
  % Erro de arredondamento do a2 nas bordas
  if (a2<1e-8)%OK
    a2 = 0;%OK
  elseif (a2>C-1e-8) %OK
    a2 = C;%OK
  end%OK
  
  if ( abs(a2-alph2) < eps*(a2+alph2+eps) )%OK
    return%OK
  end%OK
  
  % CALCULA novo alfa1
  a1 = alph1+s*(alph2-a2);%OK
  
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
  
  %ATUALIZA CACHE DE ERRO
  for k=1:size(alpha,1)
    if (alpha(k)>0 && alpha(k)<C)
      %error_cache(k) = error_cache(k) +  y1*(a1-alph1)*kernel(x1, point(k,:))  +  y2*(a2-alph2)*kernel(x2, point(k,:)) + deltab;
      error_cache(k) = error_cache(k) +  y1*(a1-alph1)*K(i1, k)  +  y2*(a2-alph2)*K(i2, k) + deltab;
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
function [ f, Y ] = output( ix )
  global target alpha threshold K;
  
  k = K(:,ix);

  f = (alpha.*k)'*target - threshold;
  Y = sign(f);
end

