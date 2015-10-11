%   Behrang Mehrparvar
%   10/9/2015
%   This function generates adjacency matrix for the dataset

%   patterns:       input dataset
%   isEntropy:      should we use joint entropy as dependency? (will use mutual information if no)
%   adj:            adjacency matrix

%   Requirement:    InfoTheory library
%   [http://www.mathworks.com/matlabcentral/fileexchange/35625-information-theory-toolbox]

function [ adj ] = adjacency( patterns, isEntropy )

    adj = [];

    features = size(patterns,2);
    
    for f1=1:features
        for f2 = 1:features
            if isEntropy
                adj(f1,f2) = jointEntropy(patterns(:,f1),patterns(:,f2));
            else
                adj(f1,f2) = mutualInformation(patterns(:,f1),patterns(:,f2));
            end
        end
    end

end