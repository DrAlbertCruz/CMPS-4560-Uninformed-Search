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

# Background

## Graphs in Prolog

Consider the structures we used in previous lab: in one we experimented with defining relationships of a tree, and in part two we defined a state space. In today's lab we will use a graph. Prolog can be unusual for some programmers coming from C/C++ who are used to declaring a node object with pointers to other nodes. In Prolog, the existence (declaration) of a node is not as important as its relationships with other nodes as defined in facts and rules. Consider node A with children B and C. We would represent this in Prolog as the relationships between A, B and C:

```prolog
% Must use lower case here, otherwise read as variables
arc(a,b). % Read as: A has an arc to B
arc(a,c).
```

If we wanted to represent a graph with path weights (with arbitrary numbers):

```prolog
arc(a,b,10). % Read as: A has an arc to B with path cost of 10
arc(a,c,12).
```

Download map.pl and study it. This Prolog source contains the arc and weight information for the Romania example in the text.

How do we explore this graph? Though Prolog has a built-in depth first search, we will learn how to implement our own version of a tree search. Recall that the key differences between different tree search algorithms are how nodes are selected for expansion. Specifically, if you are using a queue to hold the `fringe` nodes:

* How are new nodes added to `fringe`
* In what order are nodes popped from `fringe`

In depth-first search a LIFO is used and new nodes are added to the front of `fringe`. In breadth first search a FIFO queue is used and new nodes are added to the back of `fringe`. The problem becomes one of implementing the appropriate data structure for your search, and pushing/popping the nodes into the structure. In the following section we discuss how to implement this structure in Prolog.

## Lists, stacks and queues in Prolog

Prolog handles a collection of objects with a list. A list is represented in Prolog as follows:

```prolog
func([a,b,c,d,e]). % func() has a list with five elements
func2([]) % An empty list
```

`[a,b,c,d,e]` is an ordered list with `a`, `b`, `c`, `d` and `e` as elements. The brackets are the beginning and end, and the elements are separated by commas. Interaction with a list in Prolog generally follows this form:

```prolog
...[Head|Tail]...
```

So, generally, no random access. This notation means that there is some list and that it is discretely segmented at some point in the list with `Head` being a sub-list on the LHS and `Tail` being a sub-list on the RHS. Head and Tail can be anything (a predicate, another list, or empty) but the Tail must be another list. There are some default library rules, such as length:

```prolog
length( [1, 3, 6], W ).
```

where W will take the length of the first argument. In this example `W` is 3. There is also append:

```prolog
append( [a, b], [c, d, e], X ).
```

where `X` will be assigned `[a,b,c,d,e]`. There is also reverse:

```prolog
reverse( [a,b,c], W ).
```

where W will take `[c,b,a]`. There is also `listsplit`, which will split a list into two separate lists:

```prolog
listsplit([H|T], H, T).
```

There is also the command `findall`:

```prolog
findall(Object, Goal, List).
```

which will produce a List of the objects Object to satisfy the Goal.

In your code, you will represent a queue with a list. You will generally fetch from the one side of the list with `[Head|Tail]`, so you will implement a queue by appending the new elements to one side with proper ordering of append. Think critically about which side this should be.

# Approach

# Part 1: Study depth-first search

Study `lab3.pl` that was included in this repository. It contains an implementation of depth first search. Bring up swipl, and consult the files contained in this repository:

```shell
$ swipl
...
(swipl) consult( 'map.pl' ).
(swipl) consult( 'lab3.pl' ).
```

*By convention*, the notation for a depth-first search in `lab3.pl` is as follows:

```prolog
depth_first([[StartNode]],GoalNode,FinalPath,NumberVisited)
```

which will search for possible paths to `GoalNode`. `FinalPath` is the path from `StartNode` to `GoalNode` and `NumberVisited` is the number of nodes visited. For our problem we will execute:

```prolog
depth_first([[arad]],bucharest,P,N).
```

which will search for possible paths to `bucharest`. Since `P` is not unique, many possible paths will be returned. How does this work? This is a recursive depth first search. The base case is as follows:

depth_first([[Goal|Path]|_],Goal,[Goal|Path],0).

Consider the first argument. It is the queue for the recursive call. This is a list of nodes. In this case, we use `[Head|Tail]` call twice because we care only that there is a Goal and a Path to it. Other nodes do not matter, hence `[[Goal|Path]|_]`. The second argument is the `Goal`. The third argument is the `Path` taken to reach `Goal`. The fourth argument is a counter for the number of nodes visited. In the base case, we initialize the counter to 0 (this seems weird but we will make sense of it later). Now consider the recursive calling:

```prolog
depth_first([Path|Queue],Goal,FinalPath,N) :-
   extend(Path,NewPaths),
   append(NewPaths,Queue,NewQueue),
   depth_first(NewQueue,Goal,FinalPath,M),
   N is M+1.
```

The first clause determines which new paths can be taken with an external predicate called `extend`. Take it as given for now. A path consists of a list with the root at the far right of the list and the current node at the head, thus: `[CurrentNode|RestOfTheNodes]`, or `[CurrentNode|[MiddleNodes|InitialNode]]`. `NewPaths` will be the children of the left-most node in `Path`. 

The second clause pushes the new nodes to the queue. Recall that the syntax is `append(LeftSide,RightSide,List of LeftSide+RightSide).` Note that we had to discover the nodes with the first clause before we pushed them to the queue. The ordering of NewPaths and the existing Queue is critical.

The third clause is the recursive call. The fourth clause keeps track of the number of nodes visited. *Note that here we can understand why the base case is 0, the node costs are summed up through the recursive calls.* Try this search out for different cities in Romania before moving on.

### Sidebar: Depth-limited search

*This part is not necessary to complete the lab.* Suppose that you wanted to implement a depth-limited depth-first search (perhaps for improvement into IDS later on). How would you do this? Consider:

```prolog
depth_first([Path|Queue],Goal,FinalPath,N,Limit) :-
    ..., % Skipped for brevity
    N is M+1,
    N =< Limit. % This is not a typo, less than operation has = come first
```

We add another argument, `Limit`, to the search. And, as a final check after the recursive call and getting the path distances, make sure that `N` does not exceed `Limit`. If the path is greater, then `depth_first` will just fail without having found the goal.

## Part 2: Implement breadth-First Search

Create a new predicate that will perform a best first search. Test DFS and BFS and compare the solutions.

## Additional work

You are only required to implement a breadth first search. However, if you finish early you may want to implement a depth-limited DFS, then an iterative deepening DFS.
