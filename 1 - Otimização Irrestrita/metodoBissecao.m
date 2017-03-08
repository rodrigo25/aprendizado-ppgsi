function [ alfa ] = metodoBissecao( alfaIni, x, Gf, d )
  fprintf('Alfas da Bissecao:\n');
  
  i = 0;
  err = 0.00001;
  
  alfa1 = 0;
  alfa2 = alfaIni/2;
  
  hl = 0;
  while hl <= 0
    alfa2 = 2 *alfa2;
    arg = x + alfa2 * d;
    hl = Gf(arg(1),arg(2))' * d;
  end
  
  iMax = ceil(log2((alfa2)/err));
  
  cont = true;
  while(cont && i <= iMax )
    i = i+1;
    alfa = (alfa2+alfa1)/2;
    
    arg = x + alfa * d;
    hl = Gf(arg(1),arg(2))' * d;
    
    if hl > 0
      alfa2 = alfa;
    else
      if hl < 0
        alfa1 = alfa;
      else
        cont = false;
      end
    end;
    fprintf('%d alfa: %5.5f\n', i, alfa);
  end;
  
end

