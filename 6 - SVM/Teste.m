%% Teste do SVM - IRIS
% Teste

%% Dados
% Dados do conjunto IRIS com 50 exemplos da classe setosa e 50 exemplos da
% classe versicolor.
%
%  X -> [100x4]
%
%  1 -> 'setosa'
%  -1 -> 'versicolor'

load('dadosIris.mat')
N = size(X, 1);

scatter3(X(Y==1,1),X(Y==1,2),X(Y==1,3))
hold on
scatter3(X(Y==-1,1),X(Y==-1,2),X(Y==-1,3))


%% Define Parâmetros
%

Ker = 'rbf';
param = 1;
C = 10;
tol = 0.002;
max_passes = 1500;

% Calcula Matriz de Kernel
K = zeros(N);
for i=1:N
 for j=1:N
   K(i,j) = kernel(X(i,:),X(j,:), Ker, param);
 end
end


%% Treina Meu SVM

tic
[alfa, b] = SMO_K2( X, Y, C, K, tol, max_passes );
QtdSupportVectors = sum(alfa~=0)
Bias = b
TimeTrainingSMO = toc
           
           

%% Treina SVM do MATLAB
tic
if strcmp(Ker,'rbf')
  SVMStruct = svmtrain(X,Y,'kernel_function',Ker,'rbf_sigma',param,'boxconstraint',C)
else
  SVMStruct = svmtrain(X,Y,'kernel_function',Ker,'boxconstraint',C)
end
TimeTrainingSMOMatlab = toc


%% Compara  Vetores de Suporte
alfaMatlab = zeros(size(alfa));
alfaMatlab(SVMStruct.SupportVectorIndices) = SVMStruct.Alpha;

[alfa alfaMatlab]


%% Classifica Conjunto de Treinamento
Yans = zeros(N,1);

for i=1:N
  [~,Yans(i,:)] = outputSVM(alfa, b, X, Y, X(i,:), Ker, param);
end

resultado = abs(Yans + Y);

% calculo da acuracia
acertos = sum(resultado == 2);
erros = sum(resultado == 0);
acuracia = acertos/N;

fprintf('\n\n### Meu SVM ###\n')
fprintf(' acertos:  %d\n erros:    %d\n acuracia: %2.2f\n', acertos, erros, acuracia)
confMatrix = confusionmat(Y,Yans,'order',[1,-1])




%Yans = zeros(N,1);
%for i=1:N
%  [~,Yans(i,:)] = outputSVM(alfaMatlab, SVMStruct.Bias, X, Y, X(i,:), Ker, param);
%end
Yans = svmclassify(SVMStruct,X);

resultado = abs(Yans + Y);

% calculo da acuracia
acertos = sum(resultado == 2);
erros = sum(resultado == 0);
acuracia = acertos/N;

fprintf('\n\n### SVM do Matlab ###\n')
fprintf(' acertos:  %d\n erros:    %d\n acuracia: %2.2f\n', acertos, erros, acuracia)
confMatrix = confusionmat(Y,Yans,'order',[1,-1])
