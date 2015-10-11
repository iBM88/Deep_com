%   Behrang Mehrparvar
%   10/9/2015
%   This function generates representations. Each representation contains a
%   number of communities. Each community is used to encode a pattern in
%   the data.

%   patterns:       total number of patterns
%   com_sizes:      range of size of communities
%   max_samples:    the maximum instances of each pattern
%   the number of samples for each pattern
%   all_coms:       community assignments
%   all_patterns:   list of all patterns generated

%   example: 1,1,2,2,3,4
%       the first two features encode 3 patterns together in a distributed
%       manner. The last feature locally detects one feature.

function [ all_coms, all_patterns, all_raw] = generate_distributed( patterns, com_sizes, max_samples)

    flag = true;                % criteria to end loop
    patterns_encoded = 0;       % number of patterns already generated
    all_patterns = [];          % list of all patterns generated
    stack_current_patterns = [];% list of the latest set of pattern representations
    all_coms = [];              % community assignments
    all_raw = [];               % all raw data

    index_com = 0;
    raw_current = 0;
    while(flag)

        index_com = index_com + 1;
        com = randi(com_sizes);
        all_coms = [all_coms ones(1,com)*index_com];

        spaces_prev = zeros(size(all_patterns,1),size(stack_current_patterns,2));
        spaces_next = zeros(size(stack_current_patterns,1),size(all_patterns,2));
        all_patterns = [[all_patterns spaces_prev];[spaces_next stack_current_patterns]];

        current_patterns = 2^com;
        stack_current_patterns = [];
        for i = 1:current_patterns-1
            raw_current = raw_current + 1;
            encoded_single = fliplr(de2bi(i));
            count = randi(max_samples);
            raw_stack = repmat(raw_current,count,1);
            
            encoded = repmat(encoded_single,count,1);
            spaces = zeros(count,com - size(encoded,2));
            stack_current_patterns = [stack_current_patterns; [spaces encoded]];
            all_raw = [all_raw; raw_stack];
        end
        patterns_encoded = current_patterns + patterns_encoded;
        flag = (patterns > patterns_encoded);

    end

    spaces_prev = zeros(size(all_patterns,1),size(stack_current_patterns,2));
    spaces_next = zeros(size(stack_current_patterns,1),size(all_patterns,2));
    all_patterns = [[all_patterns spaces_prev];[spaces_next stack_current_patterns]];
        
    all_coms = all_coms';
end