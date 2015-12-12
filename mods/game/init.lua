-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into game_api.txt

-- Definitions made by this mod that other mods can use too


default = {}
game = {}
default.LIGHT_MAX = 14
game.LIGHT_MAX = 14





-- GUI related stuff
default.gui_bg = "bgcolor[#080808BB;true]"
default.gui_bg_img = "background[5,5;1,1;gui_formbg.png;true]"
default.gui_slots = "listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"

function default.get_hotbar_bg(x,y)
	local out = ""
	for i=0,7,1 do
		out = out .."image["..x+i..","..y..";1,1;gui_hb_bg.png]"
	end
	return out
end

default.gui_survival_form = "size[8,8.5]"..
			default.gui_bg..
			default.gui_bg_img..
			default.gui_slots..
			"list[current_player;main;0,4.25;8,1;]"..
			"list[current_player;main;0,5.5;8,3;8]"..
			"list[current_player;craft;1.75,0.5;3,3;]"..
			"list[current_player;craftpreview;5.75,1.5;1,1;]"..
			"image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
			"listring[current_player;main]"..
			"listring[current_player;craft]"..
			default.get_hotbar_bg(0,4.25)

-- Load files
dofile(minetest.get_modpath("game").."/functions.lua")
--dofile(minetest.get_modpath("default").."/furnace.lua")
--dofile(minetest.get_modpath("default").."/tools.lua")
--dofile(minetest.get_modpath("default").."/craftitems.lua")
--dofile(minetest.get_modpath("default").."/crafting.lua")
--dofile(minetest.get_modpath("default").."/mapgen.lua")
--dofile(minetest.get_modpath("default").."/player.lua")
--dofile(minetest.get_modpath("default").."/trees.lua")
--dofile(minetest.get_modpath("default").."/aliases.lua")
--dofile(minetest.get_modpath("default").."/legacy.lua")




function game.register(type,name,def)
if not type or not name or not def then
	minetest.log("action", "ERROR can not register!!!")
	return
end
if type == "node" then
	minetest.register_alias(name, "game:"..name)
	minetest.register_node("game:"..name, {def})
elseif type == "tool" then 
	minetest.register_tool("game:"..name, {def})
elseif type == "craft_item" then 
	minetest.register_craft_item("game:"..name, {def})
elseif type == "tree" then 
	--tree def={fruit="",replace=""}
	game.tree_def.description = "Tree ("..name..")"
	game.tree_def.tiles = {"default_tree_"..name.."_top.png", "default_tree_"..name.."_top.png", "default_tree_"..name..".png"}
	minetest.register_alias("tree_"..name, "game:tree_"..name)
	minetest.register_node("game:tree_"..name, {game.tree_def})
	--wood planks
	game.wood_def.description = "Wooden Planks ("..name..")"
	game.wood_def.tiles = {"default_wood_"..name..".png"}
	minetest.register_alias("wood_"..name, "game:wood_"..name)
	minetest.register_node("game:wood_"..name, {game.wood_def})
	--leaves
	game.leaves_def.description = "Leaves ("..name..")"
	game.leaves_def.tiles = {"default_leaves_"..name..".png"}
	--leaves_def.special_tiles = {"default_leaves_"..name.."_simple.png"},
	game.leaves_def.drop = {max_items = 1,items = {{items = {'game:sapling_'..name},rarity = 20,},{items = {'game:leaves_'..name},}}}
	minetest.register_alias("leaves_"..name, "game:leaves_"..name)
	minetest.register_node("game:leaves_"..name, {game.leaves_def})
	--sapling
	game.sapling_def.description = "Sapling ("..name..")"
	game.sapling_def.tiles = {"default_sapling_"..name..".png"}
	game.sapling_def.inventory_image = "default_sapling_"..name..".png"
	game.sapling_def.wield_image = "default_sapling_"..name..".png"
	minetest.register_alias("sapling_"..name, "game:sapling_"..name)
	minetest.register_node("game:sapling_"..name, {game.sapling_def})
	if def.fruit then
		--fruit
		game.fruit_def.description = "Fruit ("..name..")"
		game.fruit_def.tiles = {"default_fruit_"..name..".png"}
		game.fruit_def.inventory_image = "default_fruit_"..name..".png"
		game.fruit_def.after_place_node = function(pos, placer, itemstack) 
			if placer:is_player() then 
				minetest.set_node(pos, {name = "game:fruit_"..name, param2 = 1})
			end
		end
		if def.replace then
			game.fruit_def.on_use = minetest.item_eat(2,def.replace)
		end
		minetest.register_alias("fruit_"..name, "game:fruit_"..name)
		minetest.register_node("game:fruit_"..name, {game.fruit_def})
	end
	--craft for planks
	minetest.register_craft({
		output = 'game:wood_'..name..' 6',
		recipe = {{'game:tree_'..name},}
	})
	--abm for saplings
	minetest.register_abm({
		nodenames = {"game:sapling_"..name},
		interval = 5,
		chance = 60,
		action = function(pos, node)
			-- if not default.can_grow(pos) then
			-- 	return
			-- end

			-- local mapgen = minetest.get_mapgen_params().mgname
			-- if node.name == "default:sapling" then
			-- 	minetest.log("action", "A sapling grows into a tree at "..
			-- 		minetest.pos_to_string(pos))
			-- 	if mapgen == "v6" then
			-- 		default.grow_tree(pos, random(1, 4) == 1)
			-- 	else
			-- 		default.grow_new_apple_tree(pos)
			-- 	end
			-- elseif node.name == "default:junglesapling" then
			-- 	minetest.log("action", "A jungle sapling grows into a tree at "..
			-- 		minetest.pos_to_string(pos))
			-- 	if mapgen == "v6" then
			-- 		default.grow_jungle_tree(pos)
			-- 	else
			-- 		default.grow_new_jungle_tree(pos)
			-- 	end
			-- elseif node.name == "default:pine_sapling" then
			-- 	minetest.log("action", "A pine sapling grows into a tree at "..
			-- 		minetest.pos_to_string(pos))
			-- 	if mapgen == "v6" then
			-- 		default.grow_pine_tree(pos)
			-- 	else
			-- 		default.grow_new_pine_tree(pos)
			-- 	end
			-- elseif node.name == "default:acacia_sapling" then
			-- 	minetest.log("action", "An acacia sapling grows into a tree at "..
			-- 		minetest.pos_to_string(pos))
			-- 	default.grow_new_acacia_tree(pos)
			-- end
		end
	})
elseif type == "flower" then
	--flowers def={drawtype="",mesh="",sel_box={0,0,0,0,0,0},} --sel_box optional
	if not def.sel_box or def.sel_box == "" then
		def.sel_box = { -0.5, -0.5, -0.5, 0.5, -0.3, 0.5 }
	end
	game.flower_def.description = "Flower ("..name..")"
	game.flower_def.drawtype = def.drawtype
	game.flower_def.mesh = def.mesh
	game.flower_def.tiles = {"default_flower_"..name..".png"}
	game.flower_def.inventory_image = "default_flower_"..name..".png"
	game.flower_def.wield_image = "default_flower_"..name..".png"
	game.flower_def.selection_box = {type="fixed",fixed=sel_box,}
	minetest.register_alias("flower_"..name, "game:flower_"..name)
	minetest.register_node("game:flower_"..name, {game.flower_def})
elseif type == "dirt" then 
	--dirt types
	game.dirt_def.description = "Dirt with "..name
	game.dirt_def.tiles = {"default_"..name..".png","default_dirt.png",
		{name = "default_dirt.png^default_"..name.."_side.png",tileable_vertical = false}}
	game.dirt_def.sounds = default.node_sound_dirt_defaults({footstep = def.footstep})
	minetest.register_alias("dirt_with_"..name, "game:dirt_with_"..name)
	minetest.register_node("game:dirt_with_"..name, {game.dirt_def})
elseif type == "ore" then  
	--ores {stone_group={},block_group={},scarcity=8*8*8,num_ores=8,size=3,height_min=-31000,height_max=64,tool_hardness=1,in_desert=bool}
	game.stone_def.description = "Ore ("..name..")"
	game.stone_def.tiles = {"default_stone.png^default_mineral_"..name..".png"}
	game.stone_def.groups = def.stone_group
	game.stone_def.drop = 'game:'..name..'_lump'
	minetest.register_alias("stone_with_"..name, "game:stone_with_"..name)
	minetest.register_node("game:stone_with_"..name, {game.stone_def})
	minetest.register_alias(name.."block", "game:"..name.."block")
	minetest.register_node("game:"..name.."block", {
		description = "Block ("..name..")",
		tiles = {"default_"..name.."_block.png"},
		is_ground_content = false,
		groups = def.block_group
		sounds = default.node_sound_stone_defaults(),
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "game:stone_with_"..name,
		wherein        = "game:stone",
		clust_scarcity = def.scarcity,
		clust_num_ores = def.num_ores,
		clust_size     = def.size,
		height_min     = def.height_min,
		height_max     = def.height_max,
	})
	if def.in_desert == true then
		game.stone_def.description = "Ore ("..name..")"
		game.stone_def.tiles = {"default_desert_stone.png^default_mineral_"..name..".png"}
		game.stone_def.groups = def.stone_group
		game.stone_def.drop = 'game:'..name..'_lump'
		minetest.register_alias("desert_stone_with_"..name, "game:desert_stone_with_"..name)
		minetest.register_node("game:desert_stone_with_"..name, {game.stone_def})
		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "game:desert_stone_with_"..name,
			wherein        = "game:desert_stone",
			clust_scarcity = def.scarcity,
			clust_num_ores = def.num_ores,
			clust_size     = def.size,
			height_min     = def.height_min,
			height_max     = def.height_max,
		})
	end











end
end


dofile(minetest.get_modpath("game").."/nodes.lua")