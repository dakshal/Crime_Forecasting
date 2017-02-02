function lambda = ar_model(x, p)
%   AR_MODEL compute AR-models parameters of input signal using Yule-Walker
%   method.
%
%   LAMBDA = AR_MODEL(Y, N)
%     estimates an N:th order autoregressive polynomial model (AR) for time
%     series Y:
%        y(n) + l_1 * y(n-1) + l_2 * y(n-2) + ... +l_N * y(n-N) = e(t)
% 
%     Inputs:
%      X: The time series to be modeled, a column vector of values. The
%      data must be uniformly sampled.
%      N: The order of the AR model (positive integer)
%     Output:
%      LAMBDA: AR model delivered as an array where are
%      [1 l_1 l_2 l_3 ... l_N].
%     The model is estimated using "Yule-Walker" approach with no
%     windowing.
%
%   Author(s): G. Alessandroni, 08-01-13
%   Copyright 2013, University of Urbino

% Check number input argouments
narginchk(2,2)

% Compute autocorrelation value
R = autocorr(x, p);
% Place r value in Toeplitz form 
RL = toeplitz(R(1:p));
% Right side of Yule-Walker equation for find AR parameters
RR = - R(2:p+1);
% Compute AR parameters lambda = RL^-1 * RR and added 1 for x(n)
% parameter
lambda = [1 (RL\RR).'];
end

% [EOF] - AR_MODEL