--------------------------------------------------------------------------------------------
------------------------------- EpicNode Game ver: 0.1 :D ----------------------------------
--------------------------------------------------------------------------------------------
--Mod by Pinkysnowman                                                                     --
--(c)2015                                                                                 --
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- 'Can grow' function

local random = math.random

function game.can_grow(pos)
	local node_under = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
	if not node_under then
		return false
	end
	local name_under = node_under.name
	local is_soil = minetest.get_item_group(name_under, "soil")
	if is_soil == 0 then
		return false
	end
	local light_level = minetest.get_node_light(pos)
	if not light_level or light_level < 13 then
		return false
	end
	return true
end


-- Sapling ABM

minetest.register_abm({
	nodenames = {"game:sapling", "game:junglesapling",
		"game:pine_sapling", "game:acacia_sapling"},
	interval = 10,
	chance = 50,
	action = function(pos, node)
		if not game.can_grow(pos) then
			return
		end
		return

		local mapgen = minetest.get_mapgen_params().mgname
		if node.name == "game:sapling" then
			minetest.log("action", "A sapling grows into a tree at "..
				minetest.pos_to_string(pos))
			if mapgen == "v6" then
				game.grow_tree(pos, random(1, 4) == 1)
			else
				game.grow_new_apple_tree(pos)
			end
		elseif node.name == "game:junglesapling" then
			minetest.log("action", "A jungle sapling grows into a tree at "..
				minetest.pos_to_string(pos))
			if mapgen == "v6" then
				game.grow_jungle_tree(pos)
			else
				game.grow_new_jungle_tree(pos)
			end
		elseif node.name == "game:pine_sapling" then
			minetest.log("action", "A pine sapling grows into a tree at "..
				minetest.pos_to_string(pos))
			if mapgen == "v6" then
				game.grow_pine_tree(pos)
			else
				game.grow_new_pine_tree(pos)
			end
		elseif node.name == "game:acacia_sapling" then
			minetest.log("action", "An acacia sapling grows into a tree at "..
				minetest.pos_to_string(pos))
			game.grow_new_acacia_tree(pos)
		end
	end
})


--
-- Tree generation
--



local air_node = minetest.get_content_id("air")
local ignore_node = minetest.get_content_id("ignore")
local tree_node = minetest.get_content_id("game:tree")
local jtree_node = minetest.get_content_id("game:jungletree")
local dleaf_node = minetest.get_content_id("game:leaves")
local leaf_node = minetest.get_content_id("cg_decor:leaves")
local jleaf_node = minetest.get_content_id("cg_decor:jungleleaves")
local djleaf_node = minetest.get_content_id("game:jungleleaves")
local apple_node = minetest.get_content_id("game:apple")

function game.grow_tree(data, a, pos, is_apple_tree)

    local height = math.random(8, 14)
    if is_apple_tree == true then height = math.random(5,6) end 
    for tree_h = 0, height-1 do  
        local area_t = a:index(pos.x, pos.y+tree_h, pos.z)  
        if data[area_t] == air_node or data[area_t] == ignore_node then
            data[area_t] = tree_node   
        end
    end 
    for x_area = -3, 3 do
    for y_area = -2, 3 do
    for z_area = -3, 3 do
        if math.random(1,30) < 23 and math.abs(x_area) + math.abs(z_area) < 5 
        	and math.abs(x_area) + math.abs(y_area) < 5 and math.abs(z_area) + math.abs(y_area) < 5 then  
            local area_l = a:index(pos.x+x_area, pos.y+height+y_area-1, pos.z+z_area)  
            if data[area_l] == air_node or data[area_l] == ignore_node then    
                if is_apple_tree and math.random(1, 50) <=  10 then  
                    data[area_l] = apple_node  
                else 
                    data[area_l] = leaf_node 
                end
            end
        end       
    end
    end
    end
end

function game.grow_jungletree(data, a, pos)
        
    local height = math.random(11, 20)
    for tree_h = 0, height-1 do  
        local area_t = a:index(pos.x, pos.y+tree_h, pos.z)  
        if data[area_t] == air_node or data[area_t] == ignore_node then    
            data[area_t] = jtree_node    
        end
    end
    for roots_x = -1, 1 do
    for roots_z = -1, 1 do
        if math.random(1, 3) >= 2 then 
            if a:contains(pos.x+roots_x, pos.y-1, pos.z+roots_z) and data[a:index(pos.x+roots_x, pos.y-1, pos.z+roots_z)] == air_node then
                data[a:index(pos.x+roots_x, pos.y-1, pos.z+roots_z)] = jtree_node
            elseif a:contains(pos.x+roots_x, pos.y, pos.z+roots_z) and data[a:index(pos.x+roots_x, pos.y, pos.z+roots_z)] == air_node then
                data[a:index(pos.x+roots_x, pos.y, pos.z+roots_z)] = jtree_node
            end
        end
    end
    end
    for x_area = -5, 5 do
    for y_area = -4, 4 do
    for z_area = -5, 5 do
        if math.random(1,30) < 23 and math.abs(x_area) + math.abs(z_area) < 8  
        	and math.abs(x_area) + math.abs(y_area) < 8 and math.abs(z_area) + math.abs(y_area) < 8 then  
            local area_l = a:index(pos.x+x_area, pos.y+height+y_area-1, pos.z+z_area)  
            if data[area_l] == air_node or data[area_l] == ignore_node then   
                data[area_l] = jleaf_node 
            end  
        end       
    end
    end
    end
end


-- Pine tree from mg mapgen mod, design by sfan5, pointy top added by paramat

local function add_pine_needles(data, vi, c_air, c_ignore, c_snow, c_pine_needles)
	local node_id = data[vi]
	if node_id == c_air or node_id == c_ignore or node_id == c_snow then
		data[vi] = c_pine_needles
	end
end

local function add_snow(data, vi, c_air, c_ignore, c_snow)
	local node_id = data[vi]
	if node_id == c_air or node_id == c_ignore then
		data[vi] = c_snow
	end
end

function game.grow_pine_tree(pos)
	local x, y, z = pos.x, pos.y, pos.z
	local maxy = y + random(9, 13) -- Trunk top

	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_pine_tree = minetest.get_content_id("game:pine_tree")
	local c_pine_needles  = minetest.get_content_id("game:pine_needles")
	local c_snow = minetest.get_content_id("game:snow")
	local c_snowblock = minetest.get_content_id("game:snowblock")
	local c_dirtsnow = minetest.get_content_id("game:dirt_with_snow")

	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - 3, y = y - 1, z = z - 3},
		{x = x + 3, y = maxy + 3, z = z + 3}
	)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	-- Scan for snow nodes near sapling to enable snow on branches
	local snow = false
	for yy = y - 1, y + 1 do
	for zz = z - 1, z + 1 do
		local vi  = a:index(x - 1, yy, zz)
		for xx = x - 1, x + 1 do
			local nodid = data[vi]
			if nodid == c_snow or nodid == c_snowblock or nodid == c_dirtsnow then
				snow = true
			end
			vi  = vi + 1
		end
	end
	end

	-- Upper branches layer
	local dev = 3
	for yy = maxy - 1, maxy + 1 do
		for zz = z - dev, z + dev do
			local vi = a:index(x - dev, yy, zz)
			local via = a:index(x - dev, yy + 1, zz)
			for xx = x - dev, x + dev do
				if random() < 0.95 - dev * 0.05 then
					add_pine_needles(data, vi, c_air, c_ignore, c_snow,
						c_pine_needles)
					if snow then
						add_snow(data, via, c_air, c_ignore, c_snow)
					end
				end
				vi  = vi + 1
				via = via + 1
			end
		end
		dev = dev - 1
	end

	-- Centre top nodes
	add_pine_needles(data, a:index(x, maxy + 1, z), c_air, c_ignore, c_snow,
		c_pine_needles)
	add_pine_needles(data, a:index(x, maxy + 2, z), c_air, c_ignore, c_snow,
		c_pine_needles) -- Paramat added a pointy top node
	if snow then
		add_snow(data, a:index(x, maxy + 3, z), c_air, c_ignore, c_snow)
	end

	-- Lower branches layer
	local my = 0
	for i = 1, 20 do -- Random 2x2 squares of needles
		local xi = x + random(-3, 2)
		local yy = maxy + random(-6, -5)
		local zi = z + random(-3, 2)
		if yy > my then
			my = yy
		end
		for zz = zi, zi+1 do
			local vi = a:index(xi, yy, zz)
			local via = a:index(xi, yy + 1, zz)
			for xx = xi, xi + 1 do
				add_pine_needles(data, vi, c_air, c_ignore, c_snow,
					c_pine_needles)
				if snow then
					add_snow(data, via, c_air, c_ignore, c_snow)
				end
				vi  = vi + 1
				via = via + 1
			end
		end
	end

	local dev = 2
	for yy = my + 1, my + 2 do
		for zz = z - dev, z + dev do
			local vi = a:index(x - dev, yy, zz)
			local via = a:index(x - dev, yy + 1, zz)
			for xx = x - dev, x + dev do
				if random() < 0.95 - dev * 0.05 then
					add_pine_needles(data, vi, c_air, c_ignore, c_snow,
						c_pine_needles)
					if snow then
						add_snow(data, via, c_air, c_ignore, c_snow)
					end
				end
				vi  = vi + 1
				via = via + 1
			end
		end
		dev = dev - 1
	end

	-- Trunk
	data[a:index(x, y, z)] = c_pine_tree -- Force-place lowest trunk node to replace sapling
	for yy = y + 1, maxy do
		local vi = a:index(x, yy, z)
		local node_id = data[vi]
		if node_id == c_air or node_id == c_ignore or
				node_id == c_pine_needles or node_id == c_snow then
			data[vi] = c_pine_tree
		end
	end

	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end