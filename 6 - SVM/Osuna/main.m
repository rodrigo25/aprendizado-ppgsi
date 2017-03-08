%Carrega dados
load dados_svm.mat

%Define Constantes
Ker = 'poly';
param = 2;
C = .0000223;
%param = 5;
%C = .000000004;

%Treina o SVM com quadprog
[alfa, b] = traina_svm (Xtr, Ytr, C, Ker, param);

%Treina o SVM com Osuna's Decomposition Method usando quadprog
%[alfa, b] = decompositionSVM(Xtr, Xts, Ker, C, tol);

%Treina o SVM com Platt's SMO Algorithm Simplificado
%[alfa, b] = SimplifiedSMO(Xtr, Xts, Ker, C, tol);

%Treina o SVM com Platt's SMO Algorithm
%[alfa, b] = SMO(Xtr, Xts, Ker, C, QPsize);

%Teste com o conjunto de Teste
m = size(Xts, 1);
ns = size(Yts,2);

Y = zeros(m,ns);

for i=1:m
  Y(i,:) = saida_svm(alfa, b, Xtr, Ytr, Xts(i,:), Ker, param);
end

resultado = abs(Y + Yts);

[Yts Y resultado]

% calculo da acuracia
acertos = sum(resultado == 2);
erros = sum(resultado == 0);
acuracia = acertos/m;

fprintf(' acertos:  %d\n erros:    %d\n acuracia: %2.4f\n', acertos, erros, acuracia)

plot(Xtr(Ytr==1,1),Xtr(Ytr==1,2), 'ro');
hold on
plot(Xtr(Ytr==-1,1),Xtr(Ytr==-1,2), 'bx');