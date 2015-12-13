--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015                                                                                 --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- Definitions made by this mod that other mods can use too


game = {}
game.path = minetest.get_modpath("game")
game.LIGHT_MAX = 14
game.LIGHT_MAX = 14

dofile(game.path.."/gui.lua")
dofile(game.path.."/home.lua")




-- Load files
dofile(game.path.."/functions.lua")
dofile(game.path.."/creative.lua")
--dofile(game.path.."/furnace.lua")
--dofile(game.path.."/craftitems.lua")
--dofile(game.path.."/crafting.lua")
dofile(game.path.."/mapgen.lua")
--dofile(game.path.."/player.lua")
--dofile(game.path.."/trees.lua")
--dofile(game.path.."/legacy.lua")





dofile(game.path.."/game_register.lua")

dofile(game.path.."/nodes.lua")
dofile(game.path.."/tools.lua")