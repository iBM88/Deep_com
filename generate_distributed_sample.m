%   Behrang Mehrparvar
%   10/9/2015
%   This function generates simple predefined representations for sample
%   patterns.

%   all_coms:       community assignments
%   all_patterns:   list of all patterns generated

function [ all_coms, all_patterns] = generate_distributed_sample()
    all_patterns = [0 1 0; 1 0 0; 1 1 0; 0 0 1];
    all_coms = [1;1;2];
end