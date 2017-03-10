% Carrega Dados
load dados.mat

[m,ne] = size(Xtr);   % m - qtd Exemplos   ne - features
ns = size(Ytr,2);     % ns - qtd saidas

X = [ones(m,1), Xtr]; % Adiciona coluna de bias
ne = ne+1;



% Inicia modelos
M = 5; % qtd Modelos

stan_dev = 10; %desvio padrao da distribuicao inicial
mean = 0; %media da distribuicao inicial

sumFi= zeros(m,ns);

for i=1:M
  T{i,1} = stan_dev.*randn(ne,1) + mean; %inicia valores randomicamente

  fiAtual{i,1} = X*T{i,1};
  sumFi = sumFi + fiAtual{i,1};
end

fens = sumFi/M;




% Plota saidas com valores iniciais randomicos
figure
title(['Modelos']);
hold on
plot(Ytr, 'b-','DisplayName','Saida Esperada'); % Saida esperada

TNorEq = ((X' * X) \ X') * Ytr; % Modelo unico com Normal Equation
YNorEq = X * TNorEq;
plot(YNorEq, 'r-','DisplayName','Normal Equation');

Y = zeros(m,ns);

for i=1:M
  Yi = X*T{i,1};
  Y = Y+Yi;
  legenda = ['modelo ' num2str(i)];
  plot(Yi, 'k-','DisplayName',legenda); % M modelos randomicos
end

plot(Y/M, 'g-', 'DisplayName','Ensemble'); % Saida do ensemble inicial  

legend('Location','southeast')
    
pause





% Treina ensemble
alfa = 0.0001;
lambda = .1;

err=1;
it = 0;
maxit = 20000;

while (err>.001 && it<=maxit)
  it = it +1;
  
  fiAnt = fiAtual;
  sumFi= zeros(m,ns);
  
  for i=1:M
    %T{i,1} = T{i,1} + alfa * ( X' * (Ytr-fj) - lambda * (X' * (Ytr-fi)));
    
    T{i,1} = T{i,1} + alfa * ( X'*(Ytr-fiAnt{i,1}) - lambda*X'*(fens-fiAnt{i,1}) );  
    %T{i,1} = T{i,1} + alfa * ( (1-lambda)*X'*(Ytr-fiAnt{i,1}) + lambda*X'*(fens-Ytr) );  
    
    fiAtual{i,1} = X*T{i,1};
    sumFi = sumFi + fiAtual{i,1};
  end
  
  fens = sumFi/M;
  %err = sum( ((Ytr-fj).^2) + ( lambda*( (Ytr-fi).*(Ytr-fj) ) ) );
end







% Testa sobre o mesmo conjunto
 
% Gera saidas
Y = zeros(m,ns);
Yi = cell(M,1);
for i=1:M
  Yi{i,1} = X*T{i,1}; % Gera saidas modelos individuais
  Y = Y+Yi{i,1};
end
  
Y = Y/M; %Gera saida do ensemble

errEns = sum(abs(Ytr-Y))/m;
errNorEq = sum(abs(Ytr-YNorEq))/m;

fprintf('Erro Médio Ensemble %f\n', errEns)
fprintf('Erro Médio Normal Equation %f\n', errNorEq)

  
  
  
% Plota Resultados Finais
figure
title(['Modelos Finais']);
hold on

for i=1:M % M modelos
  legenda = ['modelo ' num2str(i)];
  %plot(Yi{i,1}, 'g-','DisplayName',legenda); 
end

plot(Ytr, 'b-','DisplayName','Saida Esperada'); % Saida esperada
plot(YNorEq, 'r-','DisplayName','Normal Equation'); % Modelo unico com Normal Equation
plot(Y, 'k-', 'DisplayName','Ensemble'); % Saida da mistura obtida

legend('Location','southeast')
