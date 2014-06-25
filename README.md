#Solution

Here are the fixes applied:

- Create new Gameplay Scene that holds character and a node to load a level
- Remove redundant objects from Levels (Main character, flag) and create seperate files, or in case of character add to Gameplay
- Create a custom class "Level" for levels, to store the "nextLevel" and the "levelSpeed"
- Create a class variable that stores the current level, when level complete, set string to next level
- Create a character position node to mark the starting point in each level. Create a code connection of this node to the owner of the ccb file. Load level with owner `self` in gameplay, to access this start position
- Make popup call `nextLevel` on owner and implement that in Gameplay and load popup with owner:self in gameplay

Menu Fixes:

- Make BG anchor point (0.5, 0.5), BG position from points to percentage, (50%, 48%)
- Logo anchor point (0.5, 0.5), position from points to percentage, (50%, 85%)
- AmazingGamesInc (button_about) anchor point to (0, 0), position in points, (10, 10)
- Options (button_options) anchor point to (1, 0), reference corner bottom right, position from UI points to points, (10, 10)
- Start button position to percentage, (50%, 44%)