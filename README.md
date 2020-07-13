# Nine-Men-s-Morris
Project for Swift Programming course at FMI summer semester 2020

Swift console application implementing the Nine men's morris game

We have a board (7x7) consists of a grid with twenty-four intersections or points. 
Each player has nine pieces, or "men", marked with X and O. 
Players try to form 'mills'—three of their own men lined horizontally or vertically—allowing a player to remove an opponent's man from the game. 
A player wins by reducing the opponent to two pieces (where they could no longer form mills and thus be unable to win), or by leaving them without a legal move.

The game proceeds in three phases:

- Placing men on vacant points
- Moving men to adjacent points
- Moving men to any vacant point when the player has been reduced to three men

More about the rules could be found [here](https://en.wikipedia.org/wiki/Nine_men%27s_morris). 
