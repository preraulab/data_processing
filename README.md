# data_processing

Generic signal and index manipulation — consecutive runs, chunk detection, interval arithmetic.

Part of the Prerau Lab [`preraulab_utilities`](https://github.com/preraulab/preraulab_utilities) meta-repository. Can also be used standalone.

## When to use which

| Task | Use |
|---|---|
| Group contiguous true / equal runs in a vector | `consecutive_runs` |
| Find the index of the nearest value | `findclosest` |
| Detect chunks (valid vs NaN / flat stretches) | `get_chunks` |
| Intersect two sets of time intervals | `interval_intersect` |
| Rolling percentile filter | `percentile_filt` |
| Slice a signal by a list of `[start end]` intervals | `pick_from_time_segments` |

## Examples

```matlab
% Find runs of artifact samples
art = detect_artifacts(data, Fs);
[n_runs, idx_cell] = consecutive_runs(art);
for k = 1:n_runs
    this_run = idx_cell{k};   % indices for run #k
end

% Nearest-neighbor index
i = findclosest(t, 125.7);

% Rolling 95th-percentile filter, window = 5 s at Fs = 200
y = percentile_filt(x, 5*200, 95);
```

## Function list

`consecutive_runs`, `findclosest`, `get_chunks`, `interval_intersect`, `percentile_filt`, `pick_from_time_segments`

See `help <function>` at the MATLAB prompt for the full docstring of each.

## Install

```matlab
addpath('/path/to/data_processing');
```

## Dependencies

MATLAB R2020a+. No required toolboxes.

## License

BSD 3-Clause. See [`LICENSE`](LICENSE).
