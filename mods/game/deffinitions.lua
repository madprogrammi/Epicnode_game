game = {}

game.tree_def = {
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
}
game.wood_def = {
	is_ground_content = false,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
}
game.leaves_def = {
	drawtype = "mesh",
	mesh = "default_leaves.obj",
	waving = 1,
	visual_scale = 1.3,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy=3,leafdecay=5,flammable=2,leaves1},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
}
game.sapling_def = {
	drawtype = "plantlike",
	visual_scale = 1.0,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
	sounds = default.node_sound_leaves_defaults(),
}
game.fruit_def = {
	drawtype = "plantlike",
	visual_scale = 1.0,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=4,leafdecay_drop=1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(2),
}
game.flower_def = {
	sunlight_propagates = true,
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	groups = {snappy=3,flammable=2,flower=1,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
}
game.dirt_def = {
	game.dirt_def.groups = {crumbly = 3, soil = 1},
	game.dirt_def.drop = 'game:dirt',
}
game.stone_def = {
	sounds = default.node_sound_stone_defaults(),
}