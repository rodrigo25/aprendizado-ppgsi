function [ f, Y ] = outputSVM( alfa, b, Xtr, Ytr, x, Ker, param)
  K = kernel(Xtr, x, Ker, param);

  f = (alfa.*K)'*Ytr + b;
  Y = sign(f);
end

