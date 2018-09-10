%--------------------------------------------------------------%
%   Base on Zdravko and Markov 1998                            %
%--------------------------------------------------------------%

%--------------------------------------------------------------%
%   Depth-first search by using a stack                        %
%   call: depth_first([[arad]],bucharest,P,N).                 %
%--------------------------------------------------------------%
depth_first([[Goal|Path]|_],Goal,[Goal|Path],0).
depth_first([Path|Queue],Goal,FinalPath,N) :-
    extend(Path,NewPaths), 
    append(NewPaths,Queue,NewQueue),
    depth_first(NewQueue,Goal,FinalPath,M),
    N is M+1.

extend([Node|Path],NewPaths) :-
    findall([NewNode,Node|Path],
            (arc(Node,NewNode,_), 
            \+ member(NewNode,Path)), % for avoiding loops
            NewPaths).