% Rodrigo A. de Freitas Vieira - 7972578
% Gradiente Descendente

function [xn1] = gradienteDescendente(xn1, rh, rg, l, B)

  f    = @(x1,x2) (x1 - 2)^4 + (x1 - 2*x2)^2;
  dfx1 = @(x1,x2) 4*(x1 - 2)^3 + 2*(x1 - 2*x2);
  dfx2 = @(x1,x2) -4*(x1 - 2*x2);
  Gf   = @(x1,x2) [dfx1(x1,x2); dfx2(x1,x2)];

  h1    = @(x1,x2) x1^2 - x2;
  dh1x1 = @(x1,x2) 2*x1;
  dh1x2 = -1;
  Gh1   = @(x1,x2) [dh1x1(x1,x2); dh1x2];

  h2    = @(x1,x2) (x1 - 2)^2 + (x2 - 2)^2 - 1;
  dh2x1 = @(x1,x2) 2*(x1 - 2);
  dh2x2 = @(x1,x2) 2*(x2 - 2);
  Gh2   = @(x1,x2) [dh2x1(x1,x2); dh2x2(x1,x2)];
  
  g1    = @(x1,x2) x1^2 + x2 - 4;
  dg1x1 = @(x1,x2) 2*x1;
  dg1x2 = 1;
  Gg1   = @(x1,x2) [dg1x1(x1,x2); dg1x2];
  
  g2 = @(x1,x2) x1-4;
  dg2x1 = 1;
  dg2x2 = 0;
  Gg2   = [dg2x1; dg2x2];
  
  g3 = @(x1,x2) -x1;
  dg3x1 = -1;
  dg3x2 = 0;
  Gg3   = [dg3x1; dg3x2];
  
  g4 = @(x1,x2) x2-4;
  dg4x1 = 0;
  dg4x2 = 1;
  Gg4   = [dg4x1; dg4x2];

  g5 = @(x1,x2) -x2;
  dg5x1 = 0;
  dg5x2 = -1;
  Gg5   = [dg5x1; dg5x2];

%  p = @(x1,x2) rh*( (h1(x1,x2))^2 + (h2(x1,x2))^2 ) + rg*( max(0,g1(x1,x2))^2 + max(0,g2(x1,x2))^2 + max(0,g3(x1,x2))^2 + max(0,g4(x1,x2))^2 + max(0,g5(x1,x2))^2);
  ph1 = @(x1,x2) rh*( l(1)*(h1(x1,x2))^2 + l(2)*(h2(x1,x2))^2 );
  ph2 = @(x1,x2) l(1)*h1(x1,x2) + l(2)*h2(x1,x2);
  pg1 = @(x1,x2) rg*( max(g1(x1,x2),-B(1)/2*rg )^2 + max( g2(x1,x2),-B(2)/2*rg )^2 + max( g3(x1,x2),-B(3)/2*rg )^2 + max( g4(x1,x2),-B(4)/2*rg )^2 + max( g5(x1,x2),-B(5)/2*rg )^2 );
  pg2 = @(x1,x2) max( g1(x1,x2),-B(1)/2*rg ) + max( g2(x1,x2),-B(2)/2*rg ) + max( g3(x1,x2),-B(3)/2*rg ) + max( g4(x1,x2),-B(4)/2*rg ) + max( g5(x1,x2),-B(5)/2*rg );
  
  %p = @(x1,x2) rh*( l(1)*(h1(x1,x2))^2 + l(2)*(h2(x1,x2))^2 ) + rg*( max(g1(x1,x2),-B(1)/2*rg)^2 + max(g2(x1,x2),-B(2)/2*rg)^2 + max(g3(x1,x2),-B(3)/2*rg)^2 + max(g4(x1,x2),-B(4)/2*rg)^2 + max(g5(x1,x2),-B(5)/2*rg)^2) + ( l(1)*h1(x1,x2) + l(2)*h2(x1,x2) ) + ( max(g1(x1,x2),-B(1)/2*rg) + max(g2(x1,x2),-B(2)/2*rg) + max(g3(x1,x2),-B(3)/2*rg) + max(g4(x1,x2),-B(4)/2*rg) + max(g5(x1,x2),-B(5)/2*rg) );
  p = @(x1,x2) ph1(x1,x2) + pg1(x1,x2) + ph2(x1,x2) + pg2(x1,x2);
  
  func  = @(x1,x2) f(x1,x2) + p(x1,x2);

  %Gfunc = @(x1,x2) Gf(x1,x2) + 2*rh*(Gh1(x1,x2) + Gh2(x1,x2)) + 2*rg*( Gg1(x1,x2)*(g1(x1,x2)>0) + Gg2*(g2(x1,x2)>0) + Gg3*(g3(x1,x2)>0) + Gg4*(g4(x1,x2)>0) + Gg5*(g5(x1,x2)>0));
%  Gfunc = @(x1,x2) Gf(x1,x2) + 2*rh*( h1(x1,x2)*Gh1(x1,x2) + h2(x1,x2)*Gh2(x1,x2) ) + 2*rg*( g1(x1,x2)*Gg1(x1,x2)*(g1(x1,x2)>0) + g2(x1,x2)*Gg2*(g2(x1,x2)>0) + g3(x1,x2)*Gg3*(g3(x1,x2)>0) + g4(x1,x2)*Gg4*(g4(x1,x2)>0) + g5(x1,x2)*Gg5*(g5(x1,x2)>0));
  Gph1 = @(x1,x2) 2*rh*( l(1)*h1(x1,x2)*Gh1(x1,x2) + l(2)*h2(x1,x2)*Gh2(x1,x2) ); 
  Gph2 = @(x1,x2) l(1)*Gh1(x1,x2) + l(2)*Gh2(x1,x2);
  Gpg1 = @(x1,x2) 2*rg*( g1(x1,x2)*Gg1(x1,x2)*(g1(x1,x2)>=-B(1)/2*rg) + g2(x1,x2)*Gg2*(g2(x1,x2)>=-B(2)/2*rg) + g3(x1,x2)*Gg3*(g3(x1,x2)>=-B(3)/2*rg) + g4(x1,x2)*Gg4*(g4(x1,x2)>=-B(4)/2*rg) + g5(x1,x2)*Gg5*(g5(x1,x2)>=-B(5)/2*rg) );
  Gpg2 = @(x1,x2) Gg1(x1,x2)*(g1(x1,x2)>-B(1)/2*rg) + Gg2*(g2(x1,x2)>=-B(2)/2*rg) + Gg3*(g3(x1,x2)>=-B(3)/2*rg) + Gg4*(g4(x1,x2)>=-B(4)/2*rg) + Gg5*(g5(x1,x2)>=-B(5)/2*rg);
  
  Gp = @(x1,x2) Gph1(x1,x2) + Gpg1(x1,x2) + Gph2(x1,x2) + Gpg2(x1,x2);
  
  Gfunc = @(x1,x2) Gf(x1,x2) + Gp(x1,x2);
  %Gfunc = @(x1,x2) Gf(x1,x2) + 2*rh*( l(1)*h1(x1,x2)*Gh1(x1,x2) + l(2)*h2(x1,x2)*Gh2(x1,x2) ) + 2*rg*( g1(x1,x2)*Gg1(x1,x2)*(g1(x1,x2)>-B(1)/2*rg) + g2(x1,x2)*Gg2*(g2(x1,x2)>-B(2)/2*rg) + g3(x1,x2)*Gg3*(g3(x1,x2)>-B(3)/2*rg) + g4(x1,x2)*Gg4*(g4(x1,x2)>-B(4)/2*rg) + g5(x1,x2)*Gg5*(g5(x1,x2)>-B(5)/2*rg)) + ( l(1)*Gh1(x1,x2) + l(2)*Gh2(x1,x2) ) + ( Gg1(x1,x2)*(g1(x1,x2)>-B(1)/2*rg) + Gg2*(g2(x1,x2)>-B(2)/2*rg) + Gg3*(g3(x1,x2)>-B(3)/2*rg) + Gg4*(g4(x1,x2)>-B(4)/2*rg) + Gg5*(g5(x1,x2)>-B(5)/2*rg));

  err = .001;
  alfa = .5;
  xn = [0; 0];
  k = 0;
  
  while (abs(func(xn(1),xn(2))-func(xn1(1),xn1(2))) > err)
    
    xn = xn1;
  
    d = -Gfunc(xn(1),xn(2));
    %fprintf('direção:     %5.5f\n', d);
    if d == 0
      break
    end

    k = k+1;
  
    alfa = metodoBissecao(alfa, xn, Gfunc, d);
  
    xn1 = xn + alfa * d;
    
    if mod(k,10000) == 0
      fprintf('iteracao: %d\n', k);
      fprintf('alfa:     %5.5f\n', alfa);
      fprintf('xn:       %5.5f %5.5f\n', xn);
      fprintf('xn+1:     %5.5f %5.5f\n\n', xn1);
    end
  end;
  fprintf('\n\nresposta: %d --> %5.5f %5.5f\n', k, xn1);
end