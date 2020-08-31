# BlackwingKaladanda

All assets remain the property of Yaan Dalzell
No part of this repository is for reproduction or redistribution without prior written consent

Composed as an assessment task for Harvards CS50x Course as accessed on edX.

# About
Framework: Love2D \
Scripting: Lua \
Game Type: Vertical 2D Shooter

####Synopsis
You are the test pilot of the X1 Blackwing Experimental Super-Luminal Vehicle on a routine mission
until a massive invasion fleet decimates earths defenses. Armed with nothing but your guns, missiles and one
nuclear weapon you must defend yourself until help arrives.

#### Controls
Movement:   Arrows\
Cannon:     Space Bar\
Missiles:   Left Shift\
Nuclear Core Eject: A

#### Enemy Types    
Nuclear Steath Bomber (Nukes)\
Torpedo Bomber (Missiles)\
Raider (Cannon)

#### X1 Blackwing Specs
Momentum Control Interface \
Prototype Alcubierre Super-Luminal Warp Drive \
Dual Regenerative Missile Launchers \
Dual Regenerative Cannons \
Ejectable Nuclear Core \

# Structure
Scripted in Lua, the general structure involves:

/lib - Classes and other scripts

###### animator.lua
    Provides animation functionality
    
###### class.lua
    Copyright (c) 2010-2013 Matthias Richter. Provides OOP structure to Lua
    
###### enemy.lua
    Provides specific functionality to enemy ships
    
###### pixel.lua
    Creates a pixel class for use in Blackwing Kaladanda V1.0
    
###### player.lua
    Provides specific functionality including control to the players avatar
    
###### projectile.lua
    Provides specific functionality to all projectiles    
    
###### push.lua
    Copyright (c) 2018 Ulysse Ramage. Provides UI scaling framework
    
###### star_scape.lua
    Creates a very simple proceduraly generated "star map" background for Blackwing Kaladanda V1.0

###### story.lua
    Story Information for Blackwing Kaladanda V1.0
    
###### utilities.lua
    Provides some general utility functions
    
###### main.lua
    manages game states and other low level functionality
    Children:   World Class
    
###### wave_generator.lua
    manages the generating of enemy waves for gameplay

###### world.lua
    Manages the games environment. Objects such as the player, enemies and projectiles exist in the world.



# Resources
All Resources Copyright (c) Yaan Dalzell Unless otherwise specified\
/resources/sounds - Audio, Visual assets etc


##Fonts

advanced_pixel_lcd_7.ttf
    LCD Clock style font - No copyright claim
    
Retron2000.ttf
    General font - No copyright claim

Vermin Vibes 1989.ttf
    Edgy Retro font - No copyright claim

## Graphics
Cannon flare.png
    pixel-art cannon flare.

enemy_ships.png
    pixel art enemy ships. frame size: 10x10, sheet size: 5x3
    
explosion.png
    pixel art for player explosion

player_1_ship.png
    pixel art player ship. Frame size: 16x16, sheet size: 3x5

projectiles.png
    pixel art projectiles. Frame size: 7x7, sheet size: 3x2
    
##Sounds
cannon.wav\
damage_warning.wav\
enemy_cannon.wav\
enemy_explode.wav\
enemy_missile.wav\
enemy_nuke_warning.wav\
explosion_1.wav\
kaladanda_fire.wav\
menu_select.wav\
missile.wav\
nuke_det.wav\
nuke_warning.wav\
player_explodes.wav\
player_hit.wav\
player_nuke_warning.mp3\
player_nuke_warning.wav\
thrusters.mp3


