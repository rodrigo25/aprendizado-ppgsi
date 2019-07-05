% Testa a funcionalidade do algoritmo SMO para problemas multiclass analisando
% apenas o erro de teinamento

% CARREGA DADOS
clear

% Conjunto Iris - setosa e versicolor (linearmente seraravel)
% load fisheriris.mat
% Y = zeros(size(species,1),1);
% YY = zeros(size(species,1),3);
% for i=1:size(species,1)
%  if strcmp(species(i),'setosa')
%    YY(i,:) = [1 -1 -1];
%    Y(i) = 1;
%  elseif strcmp(species(i),'versicolor')
%    YY(i,:)= [-1 1 -1];
%    Y(i) = 2;
%  else
%    YY(i,:)= [-1 -1 1];
%    Y(i) = 3;
%  end
% end
% X = meas;

%load ../dadosTeste/balance
%YY = zeros(625,3)-1;
%YY(Y==1,1) = 1;
%YY(Y==2,2) = 1;
%YY(Y==3,3) = 1;

%load ../../dadosTeste/data_path-based
%load ../../dadosTeste/data_path-based2
%[n] = size(X,1);
%YY = zeros(n,3)-1;
%YY(Y==1,1) = 1;
%YY(Y==2,2) = 1;
%YY(Y==3,3) = 1;


load ../../dadosTeste/data_winequality-red
n = size(X,1);
YY = zeros(n,6)-1;
YY(Y==3,1) = 1;
YY(Y==4,2) = 1;
YY(Y==5,3) = 1;
YY(Y==6,4) = 1;
YY(Y==7,5) = 1;
YY(Y==8,6) = 1;

% PLOTA GRAFICO QUATRO DIMENSOES
%figure
%igraf = 0;
%for x=1:2
%for y=2:3
%for z=3:4
%if (x~=y && x~=z && y~=z)
%igraf=igraf+1;
%subplot(2,2,igraf)
%scatter3(X(Y==1,x), X(Y==1,y),X(Y==1,z), 'xb')
%hold on
%scatter3(X(Y==2,x), X(Y==2,y),X(Y==2,z), 'or')
%hold on
%scatter3(X(Y==3,x), X(Y==3,y),X(Y==3,z), '*k')
%end
%end
%end
%end

% PLOTA GRAFICO DUAS DIMENSOES
%scatter(X(Y==1,1),X(Y==1,2),'.b')
%hold on
%scatter(X(Y==2,1),X(Y==2,2),'.r')
%scatter(X(Y==3,1),X(Y==3,2),'.g')

% NORMALIZA CONJ DE ENTRADA
X = (X-repmat(mean(X),size(X,1),1))./repmat(std(X),size(X,1),1); % Z-SCORE NORMALIZATION

% PERMUTA CONJ DE ENTRADA
rp = randperm(size(X,1));
X = X(rp,:);
YY = YY(rp,:);

% SEPARA CONJUNTOS DE TESTE E TREINAMENTO
n = size(X,1);
p = ceil(n*0.7);
Xtr = X(1:p,:);
Ytr = YY(1:p,:);
Xts = X(p+1:end,:);
Yts = YY(p+1:end,:);

fprintf('\n\nDistribuição do Dataset:\n')
tabulate(Y)
fprintf('\nDistribuição do Conj de Treinamento:\n')
[~,c]=find(Ytr==1);
tabulate(c+2)
fprintf('\nDistribuição do Conj de Teste:\n')
[~,c]=find(Yts==1);
tabulate(c+2)

% DEFINE PARAMETROS
Ker = 'rbf'; %Ker = 'linear'; %Ker = 'poly';
param = 1;
C = 20;
tol = 0.00002;
max_passes = 200;

fprintf('\n\nKernel\n   Ker: ''%s''\n   param: %d\n   C: %d\n   tol: %f\n   max_passes: %d\n\n', Ker, param, C, tol, max_passes);


% TREINA
tic
[SVMs] = trainSVMK_multiclass( Xtr, Ytr, C, Ker, param, tol, max_passes,'oneVsOne' );
TimeTraining = toc;




% CLASSIFICA CONJUNTO DE TREINAMENTO
[m, ns] = size(Ytr);
Y = zeros(m,ns);

for i=1:m
  Y(i,:) = testSVM_multiclass1v1 (Xtr, Ytr, Xtr(i,:), SVMs, Ker, param, 'DAGSVM');
  %Y(i,:) = testSVM_multiclass1v1 (Xtr, Ytr, Xtr(i,:), SVMs, Ker, param, 'COMUM');
end

resultado = sum(Y==Ytr,2)==ns;

% calculo da acuracia
acertos = sum(resultado == 1);
erros = sum(resultado == 0);
acuracia = acertos/m;

[~,classYtr] = max(Ytr,[],2);
[~,classY] = max(Y,[],2);

%[classYtr classY resultado]
fprintf('\n\n\n\n### Classifica conjunto de treinamento ###\n')
fprintf(' acertos:  %d\n erros:    %d\n acuracia: %2.2f\n', acertos, erros, acuracia)
confMatrix = confusionmat(classYtr,classY)



% CLASSIFICA CONJUNTO DE TESTE
[m, ns] = size(Yts);
Y = zeros(m,ns);

for i=1:m
  Y(i,:) = testSVM_multiclass1v1 (Xtr, Ytr, Xts(i,:), SVMs, Ker, param, 'DAGSVM');
  %Y(i,:) = testSVM_multiclass1v1 (Xtr, Ytr, Xtr(i,:), SVMs, Ker, param, 'COMUM');
end

resultado = sum(Y==Yts,2)==ns;

% calculo da acuracia
acertos = sum(resultado == 1);
erros = sum(resultado == 0);
acuracia = acertos/m;

[~,classYts] = max(Yts,[],2);
[~,classY] = max(Y,[],2);

%[classYts classY resultado]
fprintf('\n\n### Classifica conjunto de teste ###\n')
fprintf(' acertos:  %d\n erros:    %d\n acuracia: %2.2f\n', acertos, erros, acuracia)
confMatrix = confusionmat(classYts,classY)

