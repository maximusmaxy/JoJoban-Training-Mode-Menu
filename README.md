# Jojo training mode menu

This is the update version of the jojo training mode with the new menu features. It includes everything the previous training modes had and much more. 

Developed specifically for JoJo's Bizarre Adventure (Japan 990913, NO CD) (jojoban) though other versions should work.

This script was designed for FBA-RR however the basic features should work for MAME-RR as well.

It is still undergoing development so more features will be added in the future. If you find any bugs or have any feature requests DM Maxie#7777 on discord.

# Features

You can enable and disable the following system features

- Music
- Gui (Simple and advanced)
- Health Refill
- Meter Refill
- Stand Gauge Refill
- Infinite Protection System (IPS)

## Air Tech

Air teching can be set to on or off with 4 options. Up/Neutral, Down, Away or toward with delay

## Guard Cancel

Guard cancel can be set to on or off with delay. To use this feature when enabled use start and hold away from you to set your opponent into blocking mode. Once they block an attack they will automatically guard cancel after the desired amount of frames.

## Direct Control

Direct character control by holding start has been revamped to include buttons. You can use this to:

- Select your opponents character in the menu
- Hold a direction and let go of start to make them continue holding in that direction
- Turn on there stand

## Force Stand

The opponent will automatically turn their stand on or off. This can be used to practice stand break combos quicker. To refill your opponent stand gauge press Medium Kick while the menu is open.

## Record/Replay

Record your inputs and play them back. The default keys are set to medium kick and heavy kick but can be rebound in the menu. If you hold down the replay button it will be set to loop. To record your opponents inputs you will need to set player 2's controls and record them manually. Alternatively you could use the following feature to play back inputs.

# Input playback

To perform tool assisted input playback either copy the inputs.txt file into your fba directory or create your own. 

They syntax for the inputs text is as follows:
- P1 = Start player 1's inputs (Only 1 player is required)
- P2 = Start player 2's inputs (Only 1 player is required)
- u = Up
- d = Down
- l = Left
- r = Right
- a = A
- b = B
- c = C
- s = S
- number = Repeat for x frames

Each new line is a frame of input unless specified with a number eg. 5 = nothing for 5 frames, da10 = down and A for 10 frames

Directions assume the player 1 is on the left and facing right, while player 2 is on the right facing left. The inputs will be 
flipped programmatically if players swap sides so there is no need to rewrite your input for each side.

To perform the input playback change one of the hotkeys in the system settings menu to "Input playback" and press the hotkey

The included inputs.txt file is a dio vs polnaref combo. Start a round and push play to watch it or create your own.

## Credits

Credits to Maxie and the HFTF OCEANIA community for the current version with menu features.

Credits to peon2 for programming, potatoboih for finding RAM values and Klofkac for the initial version.

Special Thanks to Zarythe for graphical design and all the beta testers.