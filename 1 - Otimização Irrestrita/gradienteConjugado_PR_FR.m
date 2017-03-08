% Rodrigo A. de Freitas Vieira - 7972578
% Gradiente Conjugado, PR e FR

f = @(x1,x2) 2*(x1 - 2)^2 + 2*(x2 - 3)^2;

dfx1 = @(x1,x2) 4*(x1 - 2);
dfx2 = @(x1,x2) 4*(x2 - 3);

Gf = @(x1,x2) [dfx1(x1,x2); dfx2(x1,x2)];
Hf = [4 0; 0 4];

xn = [0; 0];
xn1 = [8; 8];

alfa = 1;
err = .00001;

n = 0;

while (abs(f(xn(1),xn(2))-f(xn1(1),xn1(2))) > err)
  
  dn = -Gf(xn(1),xn(2));
  dn1 = -Gf(xn1(1),xn1(2));
  
  if mod(n,2) ~= 0
    Bn1 = Gf(xn1(1),xn1(2))'*Hf*sn ./sn'*Hf*sn;
    %Bn1 = dn1' * (dn1 - dn) ./ dn' * dn;       %Polak-Ribiere   (PR)
    %Bn1 = norm(dn1)^2 / norm(dn)^2;            %Fletcher-Reeves (FR)
    sn1 = dn1 + Bn1*sn;
  else
    sn1 = dn1;
  end;
  
  xn = xn1;
  sn = sn1;
  
  if sn1==0 
    break 
  end
  
  n = n+1;
  
  fprintf('iteracao: %d\n', n);
  
  alfa = metodoBissecao(alfa, xn, Gf, sn1);
  
  xn1 = xn + alfa * sn1;
  
  fprintf('xn:       %5.5f %5.5f\n', xn);
  fprintf('xn+1:     %5.5f %5.5f\n\n', xn1);
end;

  
fprintf('\n\nresposta: %d -> %5.5f %5.5f\n', n, xn1);