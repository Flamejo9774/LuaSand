# LuaSand

a Falling Sand Game using Lua and Löve2d

# Blocks

Sand  | Sand can fall LeftDown,RightDown and down at a random speed it also sinks and is more sticky in water  
Stone | Stone doesnt Fall or Burn but at a temperature of 2000°C it Turns Into Lava(Liquid Stone)  
Water | Water falls the same as Sand plus Left and Right when water is above a temperature of 100°C it begins to boil  
Fire  | Fire moves in all directions and releases Temperatures of 150°C(had to shrink it)  
Wood  | Wood Is Static but Burns at a temperature of 230°C  
Glass | Glass is created when Sand is Heated Up to 1000°C and can cool down to create a Static Block  
Steam | Steam is created when Water Boils and if it cools it turns back to Water  
Lava  | Lava is like water but Slower and WAYYY Hotter  
Coal  | Coal Can burn and is created by Wood(CharCoal)  


# Keybinds

Space         | Pause the Sim  
F             | Manually Tick the Sim  
D             | Debug View  
H             | Heat View  
1-9           | Elements  
LMB           | Create Elements  
RMB           | Destroy Elements and Temperature in the air  
Scroll        | Change the Brush Size  
Lshift+Scroll | Change the Temperature of the Brush  

# ScreenShots  

![image](https://github.com/Flamejo9774/LuaSand/assets/88045266/0a59377c-a059-4566-8383-4511127ea24e)  
![image](https://github.com/Flamejo9774/LuaSand/assets/88045266/6f0bc6be-5a74-4f16-b70c-ecdf9b8f2d5a)  
![image](https://github.com/Flamejo9774/LuaSand/assets/88045266/07aeb577-0082-4bbb-833c-216b2f7e1572)  

what will heat up faster the upper or lower one  

![image](https://github.com/Flamejo9774/LuaSand/assets/88045266/f316d0a7-de39-4aed-a608-f9b0dcfebe86)  
It was the Lower one

![image](https://github.com/Flamejo9774/LuaSand/assets/88045266/c69de2ae-85b4-4ae0-a1eb-861727fb03ca)  

# Later Updates  
More Elements  
Realistic Update
Performance Update  
# Changelog  
Beta 0.0.1:  
  Added Sand,Stone,Water,Fire,Wood,Glass,Steam,Lava,Coal,Air  
  Added Temperature System(Air is an Isolator) and a Density System.(eg: sand falls through water)  
  Added transformations, like sand turns into Glass and water boils.  
  Added KeyBinds  
  Space             |Pauses the sim  
  F                 |Forwards the game by 1 tick  
  d                 |is Debug  
  h                 |is Heatview  
  scrolling         |changes the brush size  
  Lshift scrolling  |changes the Temperature  
Beta 0.0.2:  
  Added the Sidebar with all elements  
  Added X and Y position to the debug view  
