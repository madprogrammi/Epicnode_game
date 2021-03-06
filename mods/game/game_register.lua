--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015 WTFPL                                                                           --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

function game.register(register_type,name,def)
	if not register_type or not name or not def then
		minetest.log("action", "ERROR can not register!!!")
		return
	end
	if register_type == "node" then
		minetest.register_alias(name, "game:"..name)
		print("game:"..name.." registered! "..register_type)
		minetest.register_node("game:"..name, def)
	elseif register_type == "tool" then 
		minetest.register_tool("game:"..name, def)
	elseif register_type == "craft_item" then 
		minetest.register_craft_item("game:"..name, def)
	elseif register_type == "tree" then 
		--tree def={fruit="",replace=""}
		minetest.register_node("game:tree_"..name, {
			description = "Tree ("..name..")",
			tiles = {"default_tree_"..name.."_top.png", "default_tree_"..name.."_top.png", "default_tree_"..name..".png"},
			paramregister_type2 = "facedir",
			is_ground_content = false,
			groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
			sounds = game.node_sound_wood_defaults(),
			on_place = minetest.rotate_node
		})
		minetest.register_alias("tree_"..name, "game:tree_"..name)
		--wood planks
		minetest.register_node("game:wood_"..name, {
			description = "Wooden Planks ("..name..")",
			tiles = {"default_wood_"..name..".png"},
			is_ground_content = false,
			groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
			sounds = game.node_sound_wood_defaults(),
		})
		minetest.register_alias("wood_"..name, "game:wood_"..name)
		--leaves
		minetest.register_node("game:leaves_"..name, {
			description = "Leaves ("..name..")",
			tiles = {"default_leaves_"..name..".png"},
			drawregister_type = "mesh",
			mesh = "default_leaves.obj",
			waving = 1,
			visual_scale = 1.3,
			paramregister_type = "light",
			is_ground_content = false,
			groups = {snappy=3,leafdecay=5,flammable=2,leaves1},
			sounds = game.node_sound_leaves_defaults(),
			after_place_node = game.after_place_leaves,
			--leaves_def.special_tiles = {"default_leaves_"..name.."_simple.png"},
			drop = {max_items = 1,items = {{items = {'game:sapling_'..name},rarity = 20,},{items = {'game:leaves_'..name},}}},
		})
		minetest.register_alias("leaves_"..name, "game:leaves_"..name)
		--sapling
		minetest.register_node("game:sapling_"..name, {
			drawregister_type = "plantlike",
			visual_scale = 1.0,
			paramregister_type = "light",
			sunlight_propagates = true,
			walkable = false,
			selection_box = {
				register_type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = game.node_sound_leaves_defaults(),
			description = "Sapling ("..name..")",
			tiles = {"default_sapling_"..name..".png"},
			inventory_image = "default_sapling_"..name..".png",
			wield_image = "default_sapling_"..name..".png",
		})
		minetest.register_alias("sapling_"..name, "game:sapling_"..name)
		if def.fruit then
			if not def.replace then def.replace = "" end
			--fruit
			minetest.register_node("game:fruit_"..name, {
				description = "Fruit ("..name..")",
				tiles = {"default_fruit_"..name..".png"},
				inventory_image = "default_fruit_"..name..".png",
				drawregister_type = "plantlike",
				visual_scale = 1.0,
				paramregister_type = "light",
				sunlight_propagates = true,
				walkable = false,
				is_ground_content = false,
				selection_box = {
					register_type = "fixed",
					fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
				},
				groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=4,leafdecay_drop=1},
				sounds = game.node_sound_leaves_defaults(),
				on_use = minetest.item_eat(2),
				after_place_node = function(pos, placer, itemstack) 
					if placer:is_player() then 
						minetest.set_node(pos, {name = "game:fruit_"..name, param2 = 1})
					end
				end,
				on_use = minetest.item_eat(2,def.replace),
			})
			minetest.register_alias("fruit_"..name, "game:fruit_"..name)
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

			end
		})
	elseif register_type == "flower" then
		--flowers def={drawregister_type="",mesh="",sel_box={0,0,0,0,0,0},} --sel_box optional
		if not def.sel_box or def.sel_box == "" then
			def.sel_box = { -0.5, -0.5, -0.5, 0.5, -0.3, 0.5 }
		end
		minetest.register_node("game:flower_"..name, {
			description = "Flower ("..name..")",
			drawregister_type = def.drawregister_type,
			mesh = def.mesh,
			tiles = {"default_flower_"..name..".png"},
			inventory_image = "default_flower_"..name..".png",
			wield_image = "default_flower_"..name..".png",
			selection_box = {register_type="fixed",fixed=sel_box,},
			sunlight_propagates = true,
			paramregister_type = "light",
			walkable = false,
			buildable_to = true,
			groups = {snappy=3,flammable=2,flower=1,attached_node=1},
			sounds = game.node_sound_leaves_defaults(),
		})
		minetest.register_alias("flower_"..name, "game:flower_"..name)
	elseif register_type == "dirt" then 
		--dirt register_types
		minetest.register_node("game:dirt_with_"..name, {
			description = "Dirt with "..name,
			groups = {crumbly = 3, soil = 1},
			drop = 'game:dirt',
			tiles = {"default_"..name..".png","default_dirt.png",
				{name = "default_dirt.png^default_"..name.."_side.png",tileable_vertical = false}},
			sounds = game.node_sound_dirt_defaults({footstep = def.footstep}),
		})
		minetest.register_alias("dirt_with_"..name, "game:dirt_with_"..name)
		--minetest.register_node("game:dirt_with_"..name, {dirt_def})
	elseif register_type == "ore" then  
		--ores {stone_group={},block_group={},scarcity=8*8*8,num_ores=8,size=3,height_min=-31000,height_max=64,tool_hardness=1,in_desert=bool}
		minetest.register_node("game:stone_with_"..name, {
			description = "Ore ("..name..")",
			tiles = {"default_stone.png^default_mineral_"..name..".png"},
			groups = def.stone_group,
			drop = 'game:'..name..'_lump',
			sounds = game.node_sound_stone_defaults(),
		})
		minetest.register_alias("stone_with_"..name, "game:stone_with_"..name)
		minetest.register_alias(name.."block", "game:"..name.."block")
		minetest.register_node("game:"..name.."block", {
			description = "Block ("..name..")",
			tiles = {"default_"..name.."_block.png"},
			is_ground_content = false,
			groups = def.block_group,
			sounds = game.node_sound_stone_defaults(),
		})
		minetest.register_ore({
			ore_register_type       = "scatter",
			ore            = "game:stone_with_"..name,
			wherein        = "game:stone",
			clust_scarcity = def.scarcity,
			clust_num_ores = def.num_ores,
			clust_size     = def.size,
			height_min     = def.height_min,
			height_max     = def.height_max,
		})
		if def.in_desert == true then
			minetest.register_node("game:desert_stone_with_"..name, {
				description = "Ore ("..name..")",
				tiles = {"default_desert_stone.png^default_mineral_"..name..".png"},
				groups = def.stone_group,
				drop = 'game:'..name..'_lump',
				sounds = game.node_sound_stone_defaults(),
			})
			minetest.register_alias("desert_stone_with_"..name, "game:desert_stone_with_"..name)
			minetest.register_ore({
				ore_register_type       = "scatter",
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