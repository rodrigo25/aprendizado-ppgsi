# aprendizado-ppgsi

---

This repository contains the coursework for the discipline Machine Learning from the Information System Masters Program at the University of São Paulo (USP).

---

1 - Otimização Irrestrita
  * Gradient descent
  * Bisection method
  * Modified Newton method
  * Levenberg–Marquardt (LM) algorithm
  * Conjugate gradient method - Polak-Ribiére (PR) e Fletcher-Reeves (FR)
      
2 - Otimização Restrita
  * Multiplicadores de Lagrange Aumentado
  * Penalidade Exterior
  
3 - Linear Models Ensemble
  * Decorrelated Ensemble - based on [Rosen's article](https://pdfs.semanticscholar.org/aed4/5c0e4603f9896ac652d8c7091c3b7dd0a250.pdf)
  * Negative Correlation Ensemble - based on [Liu and Yao article](http://www.cs.bham.ac.uk/~pxt/NC/ncl.pdf)
  
6 - Support Vector Machines (SVM)
  * SVM quadprog - otimized with quadprog() function
  * Simplified SMO - based on [Andrew Ng Lucture Notes](https://github.com/rodrigo25/cs229/blob/master/Matlab/SMO/smoSIMPLIFIED.pdf)
  * SMO - based on Platt's pseuso code from the [original article](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/smo-book.pdf)
  * SMO K - SMO using a kernel matrix for optimization
  * multiclass - 1vs1 ou [DAG-SVM](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/dagsvm.pdf)
  
7 - Extreme learning machine (ELM)
  * ELM using pinv() function to get a pseudoinverse and a sigmoid as activation function.
