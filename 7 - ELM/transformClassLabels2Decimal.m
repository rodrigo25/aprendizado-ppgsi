function [YY] = transformClassLabels2Decimal(y)
  [~,YY] = max(y,[],2);
end