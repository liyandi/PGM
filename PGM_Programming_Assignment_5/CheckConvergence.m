% CHECKCONVERGENCE Ascertain whether the messages indicate that we have converged
%   converged = CHECKCONVERGENCE(MNEW,MOLD) compares lists of messages MNEW
%   and MOLD.  If the values listed in any message differs by more than the 
%   value 'thresh' then we determine that convergence has not occured and 
%   return converged=0, otherwise we have converged and converged=1
%
%   The 'message' data structure is an array of structs with the following 3 fields:
%     -.var:  the variables covered in this message
%     -.card: the cardinalities of those variables
%     -.val:  the value of the message w.r.t. the message's variables
%
%   MNEW and MOLD are the message where M(i,j).val gives the values associated
%   with the message from cluster i to cluster j.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function converged = CheckConvergence(mNew, mOld)
%converged = true;
thresh = 1.0e-6;
%converged should be 1 if converged, 0 otherwise.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mNew and mOld are matrix arrays each is a struct of vals
for i = 1:size(mNew,1)
  for j = 1:size(mNew,2)
    %if norm(mNew(i,j).val-mOld(i,j).val, 1) > thresh
    if MessageDelta(mNew(i,j), mOld(i,j)) > thresh
      converged = 0;
      return
    end
  end
end
converged = 1; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return;

% Get the max difference between the marginal entries of 2 messages -------
function delta = MessageDelta(Mes1, Mes2)
delta = max(abs(Mes1.val - Mes2.val));
return;