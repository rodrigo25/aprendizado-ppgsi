function [Ysvm] = testSVM_multiclass1v1 (X, Y, Xtest, SVMs, Ker, param, type)

  N = size(Xtest, 1); % recupera qtd de exemplos
  qtdClasses = size(Y,2);
  Ysvm = zeros(N, qtdClasses) - 1; % inicializa o vetor de saida

  %oneVsOne
  if strcmp(type,'COMUM')
    for exemplo = 1:N
      votos = zeros(nchoosek(qtdClasses,2),1); % matriz com votos para cada exemplo N
      count = 0; % contador de SVMs consultadas
    
      for i = 1:qtdClasses - 1
        for j = i + 1:qtdClasses
          
          count = count + 1;
            
          % carrega SVM treinada com i e j
          alfa = SVMs{i,j}.alfa;
          b = SVMs{i,j}.b;
            
          % SEPARA EXEMPLOS DAS CLASSES i E j
          indi = find(Y(:,i)==1); % recupera indices dos exemplos da classe i
          indj = find(Y(:,j)==1); % recupera indices dos exemplos da classe j
  
          ind_ij = sort(vertcat(indi, indj));  % reune os indices e ordena
          %ind_ij = sort([indi indj]);  % reune os indices e ordena
   
          X_ij = X(ind_ij, :); %separa os exemplos baseado nos indices
          Y_ij = Y(ind_ij, i); %separa os exemplos com apenas uma coluna para Y_ij (classe i = 1 e classe j = -1)

          [~,y] = outputSVM(alfa, b, X_ij, Y_ij, Xtest(exemplo,:), Ker, param);
            
          if (y == 1) % saida = i (1)
            votos(count) = i;
          else % saida = j (-1)
            votos(count) = j;
          end
            
        end
      end
      votoMaj = mode(votos); % acha moda da linha (classe mais votada - frequente - do exemplo)
      Ysvm(exemplo, votoMaj) = 1; % atualiza a coluna da classe mais votada para o exemplo atual
    end
    
    
    
    
    
    
    
    
    
  elseif strcmp(type,'DAGSVM')
    for exemplo = 1:N
      classesPossiveis = 1:qtdClasses; % inicia a lista das classes possiveis
      %disp(['Classificando exemplo ' num2str(exemplo) '/' num2str(N)]);

      while length(classesPossiveis) > 1 % enquanto ha mais de uma classes possiveis (nao folha)
        i = classesPossiveis(1); % recupera primeira classe
        j = classesPossiveis(end); % recupera ultima classe
  
        % carrega o SVM treinado com i e j
        alfa = SVMs{i,j}.alfa;
        b = SVMs{i,j}.b;

        % SEPARA EXEMPLOS DAS CLASSES i E j
        indi = find(Y(:,i)==1); % recupera indices dos exemplos da classe i
        indj = find(Y(:,j)==1); % recupera indices dos exemplos da classe j
  
        ind_ij = sort(vertcat(indi, indj));  % reune os indices e ordena
        %ind_ij = sort([indi indj]);  % reune os indices e ordena
   
        X_ij = X(ind_ij, :); %separa os exemplos baseado nos indices
        Y_ij = Y(ind_ij, i); %separa os exemplos com apenas uma coluna para Y_ij (classe i = 1 e classe j = -1)

        [~,y] = outputSVM(alfa, b, X_ij, Y_ij, Xtest(exemplo,:), Ker, param);

        if (y == 1) % saida = i (1)
          classesPossiveis = classesPossiveis(1:end-1); % Não é j então remove o final
        else % saida = j (-1)
          classesPossiveis = classesPossiveis(2:end); % Não é i então remove o inicio
        end
      end
      Ysvm(exemplo, classesPossiveis) = 1;
    end
  
  end %if type
end