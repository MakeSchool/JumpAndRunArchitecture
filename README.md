#Goal for this exercise
John Doe, a former employee of AmazingGames Inc. has been fired for having poor Game Architecture skills. It's your first day on the new job and you have to clean up behind John. The PM is asking you to:

- Replace the blue character with a green one
- Replace the flag with a different color
- Increase the running speed in level 2
- Decrease the running speed in level 3
- Reduce the jump height in all levels
- Add 5 collectible stars to each level, add a label to the screen that displays the amount of collected stars
- Make sure the game looks good on screens with different aspect ratios

You can find the **new** art assets [here](https://s3.amazonaws.com/mgwu-misc/Summer+Academy/ArchitectureExcercise/NewAssets.zip).

#Hints for this exercise

- Use custom properties in SpriteBuilder
- Make use of code connections with `Owner`

#Solution

Here are the fixes applied:

- Create new Gameplay Scene that holds character and a node to hold the loaded level
- Remove redundant objects from Levels (Main character, flag) and create seperate files, or in case of character add to Gameplay. Add a level node to the Gameplay
- Create a custom class "Level" for levels, to store the "nextLevel" and the "levelSpeed"
- Create a character position node to mark the starting point in each level. Create a code connection of this node to the owner of the ccb file. Load level with owner `self` in gameplay, to access this start position
- Create a class variable that stores the current level, when level complete, set string to next level (not a high tech solution but absolutely valid for this game)
- Make popup call `nextLevel` on owner and implement that in Gameplay and load popup with owner:self in gameplay

Menu Fixes:

- Make BG anchor point (0.5, 0.5), BG position from points to percentage, (50%, 48%)
- Logo anchor point (0.5, 0.5), position from points to percentage, (50%, 85%)
- AmazingGamesInc (button_about) anchor point to (0, 0), position in points, (10, 10)
- Options (button_options) anchor point to (1, 0), reference corner bottom right, position from UI points to points, (10, 10)
- Start button position to percentage, (50%, 44%)