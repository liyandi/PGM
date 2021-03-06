%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)

if nargin < 2, isMax = 0; end

% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Does a log-transform of the values in the 
% factors/cliques using natural log, then max-calibrates it afterwards
if isMax ~= 0
  for i = 1:N
    P.cliqueList(i).val = log(P.cliqueList(i).val);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[i,j] = GetNextCliques(P,MESSAGES);
while i&&j ~= 0 % all msgs passed

  F = P.cliqueList(i);
  for k = 1:N
    if k == j, continue; end
    msg = MESSAGES(k, i); % all msgs to i except for j
    F = FactorProduct(F, msg, isMax); % call FactorSum() if isMax = 1
  end

  sepSetNeg = setdiff(F.var, P.cliqueList(j).var);
  
  if isMax == 0
    F = FactorMarginalization(F, sepSetNeg);
  else
    F = FactorMaxMarginalization(F, sepSetNeg);
  end

  % If we are working in log-space, do not normalize each message
  % as it is passed. Else we do.
  if isMax == 0
    % Normalize msg factor
    partitionFunc = sum(F.val);
    F.val = F.val ./ partitionFunc;
  end

  F = StandardizeFactors(F);
  MESSAGES(i,j) = F;

  [i,j] = GetNextCliques(P,MESSAGES);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final belief potentials for the cliques and place them in P.
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:N

  F = P.cliqueList(i);
  for k = 1:N
    msg = MESSAGES(k, i); % all msgs including j
    F = FactorProduct(F, msg, isMax);
  end

  F = StandardizeFactors(F);
  P.cliqueList(i) = F;

end

return
