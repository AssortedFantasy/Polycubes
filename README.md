# Polycubes
Implementing code to solve the Polycube problem.

## Idea

The idea for this algorithm is fairly simple. For a given polycube $P$ let $A(P)$ be the ancestors and let $D(P)$ be the decendents.

An ancestor of a polycube is any valid polycube that you can form by removing 1 block. Valid meaning that the remaining cubes are still connected together as one piece.

A decendent of a polycube is any valid polycube that you can form by adding 1 block. Adding one block is always done adjacent to an existing block.

By definition of a polycube we can see that all polycubes are decendents of $P_1$, the polycube of a single cube.

A polycube with N cubes is described by an array of N blocks with each block being a 3 tuple described by $(z,y,x)$. The proper form of a polycube is the unique array where each block is lexicographically sorted and the first block has value $(0, 0, 0)$.

A total ordering on Polycubes is a relation `<` where $P$ < $P_j$ iff in proper form the array of $P_i$ is lexicographically smaller than $P_j$.

The proper ancestor $Q$, of $P$, $Q=A_<(P)$ is the least polycube that is an ancestor of $P$.

The proper decendents $P$, of $Q$, is the preimage for proper ancestor.

By construction we can see that we can count all N cube polycubes by counting the N-1th degree proper decendents of $P_1$

The heart of this algorithm is finding a fast way to find all the proper decendents of P.
