% Carrega Dados
load dados.mat

[m,ne] = size(Xtr); % m - qtd Exemplos   ne - features
ns = size(Ytr,2);     % ns - qtd saidas

X = [ones(m,1), Xtr]; % Adiciona coluna de bias
ne = ne+1;

% Inicia modelos
M = 5; % qtd Modelos

%W = ones(M,1);

for j=1:M
  T{j,1} = randn(ne,1);
end

% Treina ensemble
alfa = 0.0001;
lambda = .1;
for j=1:M
  err=1;
  it = 0;
  maxit = 20000;
  %Jit = zeros(maxit,1);

  if j>1
    fi = X*T{j-1,1};
  else
    fi = 0;
  end
  
  while (err>.001 && it<=maxit)
    it = it +1;
    fj = X*T{j,1};
    
    T{j,1} = T{j,1} + alfa * ( X' * (Ytr-fj) + lambda * (X' * (Ytr-fi)));
    
    err = sum( ((Ytr-fj).^2) + ( lambda*( (Ytr-fi).*(Ytr-fj) ) ) );
   % Jit(it) = err;
  end
end


% Negative Correlation (Liu)

% Decorreleted (Rosen)

% Testa conjunto de testes
  % Gera as saídas de cada modelo
  % Combina valores com uma média simples
  Y = zeros(m,ns);
  for j=1:M
    Yi = X*T{j,1};
    Y = Y+Yi;
  end
  
  Y = Y/M;
  err = sum(abs(Ytr-Y))/m;
  
  [Ytr Y abs(Ytr-Y)]
  fprintf('Erro Médio %f\n', err)
  
  
  
  
  figure
    plot(Ytr, '-'); % Saida esperada
    title(['Saídas']);
    hold on

    T_ff = ((X' * X) \ X') * Ytr; % Formula fechada
    Y_ff = X * T_ff;
    plot(Y_ff, '.-'); % Saida da formula fechada

    plot(Y, '-'); % Saida da mistura obtida

    for i=1:M
      Yi = X*T{i,1};
      plot(Yi, 'k-'); % Saida da mistura obtida
    end
    
    err = sum(abs(Ytr-Y_ff))/m;
  
    fprintf('Erro FF %f\n', err)
    
    %legend('Ytr', 'Yff', 'Ym');