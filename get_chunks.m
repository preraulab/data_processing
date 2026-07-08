function [run_lengths, run_inds, run_values, filtered_vector] = get_chunks(data, min_len, max_len, tol)
%GET_CHUNKS  Extract consecutive runs of (near-)equal values from a vector
%
%   Usage:
%       [run_lengths, run_inds, run_values, filtered_vector] = get_chunks(data)
%       [run_lengths, run_inds, run_values, filtered_vector] = get_chunks(data, min_len, max_len)
%       [run_lengths, run_inds, run_values, filtered_vector] = get_chunks(data, min_len, max_len, tol)
%
%   Inputs:
%       data    : 1xN numeric - input vector -- required
%       min_len : double - minimum run length (default: 1)
%       max_len : double - maximum run length (default: inf)
%       tol     : double - a run extends while its full span (max-min) stays
%                 within tol. Default 0 = strict equality (isequaln). Use a
%                 small positive tol to find near-constant runs when the signal
%                 has been resampled (the anti-alias filter leaves sub-unit
%                 ringing in flat/disconnected segments, so a genuinely flat run
%                 is no longer bit-identical - e.g. a 40-min disconnect survives
%                 as < 50 exactly-equal samples, below any 1-s min_len).
%
%   Outputs:
%       run_lengths     : 1xK double - length of each run
%       run_inds        : 1xK cell - index ranges for each run
%       run_values      : 1xK - value of each run
%       filtered_vector : logical, same size as data - true at positions inside a run
%
%   Example:
%       x = [2 2 5 5 5 6 6 6 6 4 7 2 2 2];
%       [lengths, runs] = get_chunks(x, 2, 4);
%
%   See also: consecutive_runs
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿

%Default lengths impose no filtering
if nargin<2
    min_len=1;
end

if nargin<3
    max_len=inf;
end

if nargin<4
    tol=0;
end

%Check for valid lengths
if min_len>max_len
    error('Min size must be less than or equal to max size');
end

% Determine length of data
len = length(data);

% Compute maximum number of runs based on min_len
max_runs = floor(len / min_len);

% Initialize output variables
run_inds = cell(1, max_runs); % Preallocate cell array for maximum possible number of runs
run_lengths = zeros(1, max_runs); % Preallocate vector for maximum possible number of runs

% Initialize run variables
cur_run = 0;
cur_len = 0;

last_val = data(1);
run_min = data(1); % running span of the current run (used when tol > 0)
run_max = data(1);
% Iterate through data vector
for ii = 1:len
    % Extend the current run? tol==0 keeps the original strict-equality
    % (isequaln) behavior; tol>0 extends while the run's span stays <= tol.
    if tol==0
        same = isequaln(data(ii), last_val);
    else
        same = (max(run_max, data(ii)) - min(run_min, data(ii))) <= tol;
    end
    if same
        % Increment current run
        cur_len = cur_len + 1;
        run_min = min(run_min, data(ii));
        run_max = max(run_max, data(ii));
    else
        if cur_len >= min_len && cur_len <= max_len
            % End current run
            cur_run = cur_run + 1;
            runs_start = (ii - cur_len);
            runs_end = (ii - 1);
            run_inds{cur_run} = runs_start:runs_end;
            run_lengths(cur_run) = cur_len;
        end
        % Reset current run
        cur_len = 1;
        last_val = data(ii);
        run_min = data(ii);
        run_max = data(ii);
    end
end

% End last run
if cur_len >= min_len && cur_len <= max_len
    cur_run = cur_run + 1;
    runs_start = (len - cur_len + 1);
    runs_end = (len);
    run_inds{cur_run} = runs_start:runs_end;
    run_lengths(cur_run) = cur_len;
end

% Trim output vectors to only include filled cells
run_inds = run_inds(1:cur_run);
run_lengths = run_lengths(1:cur_run);

%Get the values for each run
if nargout>=3
    run_values = cellfun(@(y)data(y(1)),run_inds);
end

%Create the filtered binary vector if needed
if nargout==4
    filtered_vector = zeros(size(data));
    filtered_vector([run_inds{:}]) = 1;
end

end
