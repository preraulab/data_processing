function [vals, inds]=findclosest(A, B)
%FINDCLOSEST  For each element of B, find the closest element in A
%
%   Usage:
%       [vals, inds] = findclosest(A, B)
%
%   Inputs:
%       A : 1xN double - reference values -- required
%       B : 1xM double - query values -- required
%
%   Outputs:
%       vals : 1xM double - A value closest to each B(i)
%       inds : 1xM double - indices into A of the closest matches
%
%   Example:
%       A = [-1 5 74 2 9 -45 23 75 23];
%       B = [-3.4 5.6 9.45 -100];
%       [vals, inds] = findclosest(A, B);
%
%   See also: min, interp1
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main


%Use fast matrix method for smaller data sets
if length(A)*length(B)*2<5000000
    [~, inds]=min(abs(ones(length(A),1)*B(:)'-A(:)*ones(1,length(B))));
else %Use slow method for large sets
    %     disp('Datasets large. Switching to iterative method');
    inds=zeros(1,length(B));
    parfor ii=1:length(B)
        [~, inds(ii)]=min(abs(A-B(ii)));
    end
end

vals=A(inds);