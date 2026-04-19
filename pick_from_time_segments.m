function picked_idx = pick_from_time_segments(time_segments, times)
%PICK_FROM_TIME_SEGMENTS  Subselect data from multiple discontinuous time ranges
%
%   Usage:
%       picked_idx = pick_from_time_segments(time_segments, times)
%
%   Inputs:
%       time_segments : Kx2 double - (start, end) time pairs -- required
%       times         : 1xN double - data times to test -- required
%
%   Outputs:
%       picked_idx : 1xN logical - true for times falling inside any segment
%
%   See also: interval_intersect
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

%Use time segments to interpolate logicals on the data
x=reshape(time_segments',1,numel(time_segments));
y=zeros(size(x));
y(1:2:end)=1;

yi=interp1(x,y,times,'previous');
yi(isnan(yi))=0;

picked_idx=logical(yi);

