function filtered_data = percentile_filt(data, ptile, window_size)
%PERCENTILE_FILT  Compute a running percentile filter along rows
%
%   Usage:
%       filtered_data = percentile_filt(data, ptile, window_size)
%
%   Inputs:
%       data        : NxT double - time series data (rows = series, cols = time) -- required
%       ptile       : double - percentile value in [0,100] -- required
%       window_size : integer - sliding window size in samples -- required
%
%   Outputs:
%       filtered_data : NxT double - percentile-filtered data, same size as data
%
%   Notes:
%       Requires the Image Processing Toolbox (ordfilt2).
%
%   See also: ordfilt2, prctile
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

%Make sure inputs are valid
% p = inputParser;
% 
% addRequired(p,'data',@(x)validateattributes(x,'numeric',{'2d','nonempty'}))
% addRequired(p,'ptile',@(x)validateattributes(x,'numeric',{'scalar','>=',0,'<=',100}));
% addRequired(p,'window_size',@(x)validateattributes(x,'numeric',{'scalar','nonempty'}))
% 
% parse(p,data,ptile,window_size);

if ~exist('ordfilt2', 'file')
    error('percentile_filt:missingDep', ...
        'percentile_filt requires the Image Processing Toolbox (for ordfilt2).');
end

%Create a row filter
filt_mat = ones(1, window_size);

%Compute the order 1 = smallest, winsize = biggest
order = round(prctile(1:window_size, ptile));
%Verify order
assert(order>= 1 & order<= window_size,'Order must a valid index');

%Compute order filter
filtered_data = ordfilt2(data, order, filt_mat, 'symmetric');

assert(isequal(size(data), size(filtered_data)), 'Output and input sizes unequal');
end

