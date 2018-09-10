# CMPS-4560-Uninformed-Search
CMPS 4560 Lab: Uninformed search in Prolog

# Introduction

# Requirements

* SWI Prolog
* File in this repo

# Objectives

1. Represent a graph in Prolog, 
1. Understand how to implement lists in Prolog, 
1. Reviewing a depth-first search implementation in Prolog, and (4) programming a breadth first search in Prolog.

I: Graphs in Prolog

Consider the structures we used in previous labs: in lab one we experimented with defining relationships of a tree, and in lab two we defined a state space. In today's lab we will use a graph. Prolog can be unusual for some programmers coming from C/C++ who are used to declaring a node object with pointers to other nodes. In Prolog, the existence (declaration) of an atom is not as important as its relationships with other atoms as defined in facts and rules. Consider a tree:

a
/\
b c

We would represent this in Prolog as the relationships between a, b and c:

arc(a,b).
arc(a,c).

If we wanted to represent a graph with arc weights (with arbitrary numbers):

arc(a,b,10).

arc(a,c,12).

Download map.pl and study it. This Prolog source contains the arc and weight information for the Romania example in the text.

How do we explore this graph? Though Prolog has a built-in depth first search, we will learn how to implement our own version of a tree search. The key difference between the tree search algorithms we learned in class is how the nodes are selected for expansion. In depth-first search a stack is used. In breadth first search a queue is used. The problem becomes one of implementing the appropriate data structure for your search, and pushing the nodes into the structure. In the following section we discuss how to implement this structure in Prolog.

II: Lists, Stacks and Queues in Prolog

Prolog handles a collection of objects with a list. A list is represented in Prolog as follows:

[a,b,c,d,e]

This is an ordered list with atoms a, b, c, d and e. The brackets are the beginning and end, and the elements are separated by commas. Interaction with a list generally follows this form:

[Head|Tail]

Head and Tail can be anything (a predicate or another list) but the Tail must be another list. There are some default library rules, such as length:

length( [1, 3, 6], W ).

where W will take the length of the first argument. In this example W = 3. There is also append:

append( [a, b], [c, d, e], X ).

where X will take [a,b,c,d,e]. There is also reverse:

reverse( [a,b,c], W ).

where W will take [c,b,a]. There is also listsplit, which will split a list into two separate lists:

listsplit([H|T], H, T). There is also the command findall:

findall(Object, Goal, List).

which will produce a List of the objects Object to satisfy the Goal.

In your code, you will represent a stack or queue with a list. You will generally fetch from the one side of the list with [Head|Tail], so you will implement a stack or queue by appending the new elements to one side with proper ordering of append. Think critically about which side this should be, knowing that the Tail must be a list.

III: Depth-First Search

Download and study lab_3.pl. It contains an implementation of depth first search. Consult map.pl and lab_3.pl and query the depth first search with:

depth_first([[arad]],bucharest,P,N).

which will search for possible paths to bucharest. P is the path and N is the number of nodes visited. Since P is not unique, many possible paths will be returned. How does this work? This is a recursive depth first search. The base case is as follows:

depth_first([[Goal|Path]|_],Goal,[Goal|Path],0).

Consider the first part. In the query, this was the starting point. The first argument is the queue for the recursive call. This is a list of nodes. In this case, we use [Head|Tail] call twice because we care only that there is a Goal and a Path to it. Other nodes do not matter, hence [[Goal|Path]|_]. The second argument is the Goal. The third argument is the Path taken to reach Goal. The fourth argument is a counter for the number of nodes visited. In the base case, we initialize the counter to 0. Now consider the recursive calling:

depth_first([Path|Queue],Goal,FinalPath,N) :-
extend(Path,NewPaths),
append(NewPaths,Queue,NewQueue),

depth_first(NewQueue,Goal,FinalPath,M),
N is M+1.

The first clause determines which new paths can be taken with an external predicate called extend. Take it as given for now, and come back to it if you have time. NewPaths will be the nodes that have an edge to Path. The second clause pushes the new nodes to the queue. Note that we had to discover the nodes with the first clause before we pushed them to the queue. The ordering of NewPaths and the existing Queue is critical. The third clause is the recursive call. The fourth clause keeps track of the number of nodes visited.

Try this search out for different cities in Romania before moving on.

IV: Breadth-First Search

Create a new predicate that will perform a best first search.

V: Additional Questions

You are required to only implement a breadth first search. However, if you finish early you may want to implement a depth-limited DFS, then an iterative deepening DFS.

 
