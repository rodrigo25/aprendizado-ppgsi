% Testa a funcionalidade do algoritmo SMO para problemas biclass analisando
% apenas o erro de teinamento

% CARREGA DADOS
clear

% Conjunto não linearmente separavel
load ../dadosTeste/dados_svm.mat

% Conjunto não linearmente separavel, com alguns poucos pontos misturados
%load ../dadosTeste/q1x.dat
%load ../dadosTeste/q1y.dat
%Xtr = q1x;
%Ytr = q1y;
%Ytr(q1y==0) = -1;

% Conjunto Iris - setosa e versicolor (linearmente seraravel)
 %load fisheriris.mat
 %Y = zeros(size(species,1),1);
 %for i=1:size(species,1)
%   if strcmp(species(i),'setosa')
%     Y(i)=1;
%   elseif strcmp(species(i),'versicolor')
%     Y(i)=-1;
%   else
%     Y(i)=0;
%   end
% end
% Xtr = meas(Y==1 | Y==-1,:);
% Ytr = Y(Y==1 | Y==-1,:);


% Conjunto Spambase
%load ../dadosTeste/data_spambase
%rp = randperm(size(X,1));
%X = X(rp,:);
%Y = Y(rp,:);
%Y(Y==0) = -1;
%Xtr = X(1:3220,:);
%Ytr = Y(1:3220,:);
%Xts = X(3221:end,:);
%Yts = Y(3221:end,:);

%scatter(Xtr(Ytr==1,1),Xtr(Ytr==1,2))
%hold on
%scatter(Xtr(Ytr==-1,1),Xtr(Ytr==-1,2))

rp = randperm(size(Xtr,1));
Xtr = Xtr(rp,:);
Ytr = Ytr(rp,:);

%Xtr = XX(1:70,:);
%Ytr = YY(1:70,:);

%Xts = XX(71:end,:);
%Yts = YY(71:end,:);

%load testeSpam

% DEFINE PARAMETROS
Ker = 'rbf';
param = 1;
C = 1;
tol = 0.002;
max_passes = 100;

fprintf('\n\nKernel\n   Ker: ''%s''\n   param: %d\n   C: %d\n   tol: %f\n   max_passes: %d\n\n', Ker, param, C, tol, max_passes);

% TREINA
tic
[alfa, b] = SMO( Xtr, Ytr, C, Ker, param, tol, max_passes );
[alfa2, b2] = SMO_simplified( Xtr, Ytr, C, Ker, param, tol, max_passes );
[alfa3, b3] = SVM_quadprog(Xtr,Ytr,C,Ker,param);
TimeTraining = toc;
%pause


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



