% CARREGA DADOS
%clear
%load ../dadosTeste/dados_svm.mat

load ../dadosTeste/q1x.dat
load ../dadosTeste/q1y.dat
Xtr = q1x;
Ytr = q1y;
Ytr(q1y==0) = -1;

%scatter(Xtr(Ytr==1,1),Xtr(Ytr==1,2))
%hold on
%scatter(Xtr(Ytr==-1,1),Xtr(Ytr==-1,2))

%load ../dadosTeste/data_spambase
%rp = randperm(size(X,1));
%X = X(rp,:);
%Y = Y(rp,:);
%Y(Y==0) = -1;
%X = (X-repmat(mean(X),size(X,1),1))./repmat(std(X),size(X,1),1); % Z-SCORE NORMALIZATION
%Xtr = X(1:3220,:);
%Ytr = Y(1:3220,:);
%Xts = X(3221:end,:);
%Yts = Y(3221:end,:);

% load fisheriris.mat
% Y = zeros(size(species,1),1);
% for i=1:size(species,1)
%   if strcmp(species(i),'setosa')
%     Y(i)=1;
%   elseif strcmp(species(i),'versicolor')
%     Y(i)=-1;
%   else
 %    Y(i)=0;
 %  end
 %end
 %Xtr = meas(Y==1 | Y==-1,:);
 %Ytr = Y(Y==1 | Y==-1,:);

%load testeSpam


% DEFINE PARAMETROS
%Ker = 'linear';
Ker = 'rbf';
param = 1;
C = 10;
tol = 0.002;
max_passes = 1500;

fprintf('\n\nKernel\n   Ker: ''%s''\n   param: %d\n   C: %d\n   tol: %f\n   max_passes: %d\n\n', Ker, param, C, tol, max_passes);


% Calcula Matriz de Kernel
N = size(Xtr, 1);
K = zeros(N);

tic
for i=1:N
 for j=1:N
   K(i,j) = kernel(Xtr(i,:),Xtr(j,:), Ker, param);
 end
end
TimeKernel = toc;

% TREINA
tic
[alfa, b] = SMO_K2( Xtr, Ytr, C, K, tol, max_passes );
TimeTraining = toc;


% CLASSIFICA CONJUNTO DE TREINAMENTO
[m, ns] = size(Ytr);
Y = zeros(m,ns);

for i=1:m
  [~,Y(i,:)] = outputSVM(alfa, b, Xtr, Ytr, Xtr(i,:), Ker, param);
end

resultado = abs(Y + Ytr);

% calculo da acuracia
acertos = sum(resultado == 2);
erros = sum(resultado == 0);
acuracia = acertos/m;

%[Ytr Y resultado]
fprintf('\n\n### Classifica conjunto de treinamento ###\n')
fprintf(' acertos:  %d\n erros:    %d\n acuracia: %2.2f\n', acertos, erros, acuracia)
confMatrix = confusionmat(Ytr,Y,'order',[1,-1])


return
% CLASSIFICA CONJUNTO DE TESTES
[m, ns] = size(Yts);
Y = zeros(m,ns);

for i=1:m
  [~,Y(i,:)] = outputSVM(alfa, b, Xtr, Ytr, Xts(i,:), Ker, param);
end

resultado = abs(Y + Yts);

% calculo da acuracia
acertos = sum(resultado == 2);
erros = sum(resultado == 0);
acuracia = acertos/m;

%[Yts Y resultado]
fprintf('\n\n### Classifica conjunto de teste ###\n')
fprintf(' acertos:  %d\n erros:    %d\n acuracia: %2.2f\n', acertos, erros, acuracia)
confMatrix = confusionmat(Yts,Y,'order',[1,-1])

