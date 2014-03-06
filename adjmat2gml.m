function [] = adjmat2gml(S,fname,directed,threshold,names,groups)

% This script converts a weighted adjacency matrix to a GML file for 
% visualization in Gephi.
%
% INPUTS:
%   S - weighted adjacency matrix (required)
%   fname - filename for GML file (required)
%   directed - specify whether edges are directed (1) or undirected (0)
%   (required)
%   threshold - include only connections with weight greater than threshold
%   names - cell array of node names
%   groups - vector of community assignments
%
% Author: Maureen Ritchey, 08/2012, updated 03/2014


% Set defaults
if nargin < 3
    error('Missing inputs.');
end
if nargin < 4
    threshold = 0;
end
if nargin < 5
    names = repmat({'missing'},size(S,1),1);
end
if nargin < 6
    groups = repmat(1,size(S,1),1);
end

% Check that S is symmetric, if
if directed==0 & ~isempty(find(S~=max(S,S')))
    error('S is not symmetric, but edges are specified to be undirected.');
end

% Store node and edge information
numNodes = size(S,1);
cnt = 1;
for i=1:numNodes
    data.node(i).name = names{i};
    data.node(i).group = groups(i);
    for j=1:numNodes
        if directed==0
            S = tril(S); % for undirected, use only lower half
        end
        if S(i,j) > threshold
            data.edge(cnt).source = i;
            data.edge(cnt).target = j;
            data.edge(cnt).weight = round(100.*S(i,j)); % revalue weights
            cnt = cnt + 1;
        end
    end
end

% Write out node information
f1 = fopen(fname,'w+');
if directed==0
    fprintf(f1,'graph\n [ directed 0\n');
else
    fprintf(f1,'graph\n [ directed 1\n');
end
for i=1:size(data.node,2);
    fprintf(f1,'\tnode [\n\t\tid %i\n\t\tlabel "%s"\n\t\tcommunity %i\n\t]\n', ...
        i,data.node(i).name,data.node(i).group);
end
% Write out edge weight information
for i=1:size(data.edge,2)
    fprintf(f1,'\tedge [\n\t\tsource %i\n\t\ttarget %i\n\t\tvalue %i\n\t]\n', ...
        data.edge(i).source,data.edge(i).target,data.edge(i).weight);
end
fprintf(f1,']');
fclose(f1);


end
