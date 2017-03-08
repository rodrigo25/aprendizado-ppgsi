function Y=saida_svm(alfa, b, Xtr, Ytr, Xt, Ker, param)
if strcmp(Ker, 'linear')
    K = (Xt*Xtr');
elseif strcmp(Ker,'poly')
    K=((Xt*Xtr'+1).^param);
end

Y = sign(K*(alfa.*Ytr)+b);

