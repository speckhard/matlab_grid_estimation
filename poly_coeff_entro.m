clear, close all, clc

% This script computes the coefficients of monomials in increasing powers
% of the best polynomial approximation for -x*log(x), x in [0,1]. The
% approximation takes two steps. First, we use the open-source software
% package Chebfun to obtain the Barycentric interpolation form of the best 
% polynomial approximation f_best of order K (based on Remez algorithm). 
% Then, the Barycentric form f_best is converted into its equivalent form f
% involving only monomials 1, x, x^2, ..., x^K, namely, 
%
%               f(x) = p0 + p1*x + ... + pK*x^K, 
%
% where pk = f_best^(k)(0)/k!, k = 0,...,K. The obtained coefficients are
% then stored in the length-(K+1) vector p = [p_0, p_1, ..., p_K]. 
% 
% Remarks: 
%   1) It is demonstrated that the newly computed coefficients using this 
%      script are numerically more accurate than coefficients stored in the 
%      old file poly_coeff_r.mat (which was generated in the first release 
%      of JVHW) for orders 24, 25. 
%   2) For order > 25, the monomial form expression f(x) suffers from very
%      high floating-point errors due to the fact that the numerator and
%      denominator in f_best^(k)(0)/k! are both very large, thus their
%      division can be highly inaccurate. 
%   3) For any order > 25, the Barycentric-form best polynomial 
%      approximation is very accurate because the Barycentric formula is
%      numerically stable and very suitable for numerical computation. 


addpath(genpath(fullfile(pwd,'Chebfun v5.3.0')));  % The Chebfun package provides functionality for best polynomial approximation

a = 0; b = 1;
f = chebfun(@(x) log(x.^-x),[a,b],'splitting','on');  
p = cell(25,1);

% Extract monomial coefficients from the Barycentric-form best polynomial 
% approximation. The polynomial coefficients are organized in the order of 
% increasing powers of x^k. 
for K = 1:numel(p)    
    f_best = remez(f,K);   % f_best: best polynomial approximation of order K    
    f_diff = f_best;
    for k = 0:K
        p{K}(k+1) = f_diff(0);   % f(x) = p0 + p1*x + ... + pK*x^K,, where pk = f_best^(k)(0)/k!, k = 0,...,K
        f_diff = diff(f_diff/(k+1));
    end
end

figure
K = 9;
plot(f,'b*'), hold on
fplot(@(x)polyval(flip(p{K}),x),[a,b],'k-');
load poly_coeff_r.mat poly_coeff_r;
coeff = flip(poly_coeff_r{K});
fplot(@(x)polyval(coeff,x),[a,b],'k>')
legend('chebfun','best polynomial (Monomial form)','poly\__coeff\_r.mat','Location','northwest')
title(sprintf('$-x\\log x$,  $K = %d$',K),'Interpreter','latex','Fontsize',16)


% % Approximation Error
% for K = 8:25
%     figure
%     fplot(@(x)abs(polyval(flip(p{K}),x)-f(x)),[a,b],'k-'); hold on
%     coeff = flip(poly_coeff_r{K});
%     fplot(@(x)abs(polyval(coeff,x)-f(x)),[a,b],'b-')
%     legend('best polynomial (Monomial form)','poly\_coeff\_r.mat','Location','northwest')
%     title(sprintf('$K = %d$',K),'Interpreter','latex','Fontsize',16)
% end

poly_entro = p;
save poly_coeff_entro.mat poly_entro

