function [SVMs] = trainSVMK_multiclass (X, Y, C, Ker, param, tol, max_passes, multiClassType)
  
qtdClasses = size(Y,2);

switch multiClassType
    
  % Treina SVM usando estrategia One-vs-All
  % Cria um classificador para cada classe
  case 'oneVsAll'
    SVMs = cell(qtdClasses,1);
    
    % CALCULA MATRIZ DE KERNEL
    N = size(X, 1);
    K = zeros(N);
    for ik=1:N
      for jk=1:N
        K(ik,jk) = kernel(X(ik,:),X(jk,:), Ker, param);
      end
    end
    
    for i = 1:qtdClasses
      % SEPARA EXEMPLOS DAS CLASSES I E J
      Y_i = Y(:, i); %separa os exemplos com apenas uma coluna para Y_i (classe i = 1 e outras classes = -1)
      
      % TREINA SVM DE i
      [alfa, b] = SMO_K( X, Y_i, C, K, tol, max_passes );
        
      % SALVA O MODELO GERADO
      %SVMs{i} = [{alfa} b];
      SVMs{i} = struct('alfa',{alfa}, 'b', {b});
    end
      
      
      
      
      
      
  % Treina SVM Multiclass usando estrategia One-vs-One
  % Cria um classificador para cada combinacao possivel entre i e j
  case 'oneVsOne'
    SVMs = cell(qtdClasses);
      
    for i = 1:qtdClasses - 1
      for j = i+1:qtdClasses
        
        fprintf('\nTreinando SVM das classes %d e %d...', i, j);
        
        % SEPARA EXEMPLOS DAS CLASSES i E j
        indi = find(Y(:,i)==1); % recupera indices dos exemplos da classe i
        indj = find(Y(:,j)==1); % recupera indices dos exemplos da classe j
  
        ind_ij = sort(vertcat(indi, indj));  % reune os indices e ordena
        %ind_ij = sort([indi indj]);  % reune os indices e ordena
   
        X_ij = X(ind_ij, :); %separa os exemplos baseado nos indices
        Y_ij = Y(ind_ij, i); %separa os exemplos com apenas uma coluna para Y_ij (classe i = 1 e classe j = -1)
          
        
        % CALCULA MATRIZ DE KERNEL
        fprintf(' Criando Matriz de Kernel...');
        N = size(X_ij, 1);
        K = zeros(N);
        for ik=1:N
         for jk=1:N
           K(ik,jk) = kernel(X_ij(ik,:),X_ij(jk,:), Ker, param);
         end
        end
        
        
        % TREINA SVM DE i E j
        fprintf(' Treinando Modelo...');
        [alfa, b] = SMO_K( X_ij, Y_ij, C, K, tol, max_passes );
        
        % SALVA O MODELO GERADO
        SVMs{i,j} = struct('alfa',{alfa}, 'b', {b});
      end
    end
      
      
      
       
  otherwise
    
end
  
end