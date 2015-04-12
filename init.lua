-- Initial check to see if damage is enabled and peaceful mode active
local damage_enabled = minetest.setting_getbool("enable_damage")

-- Check if object is an entity that can die
local function is_mortalentity(ref)
	local refname = ref:get_luaentity().name or ""
	local is_entity = minetest.registered_entities[refname]
	if is_entity and refname ~= "__builtin:item" then
		return true
	else
		return false
	end
end

-- Cactus do damage now to living things and destroy droped items
local function cactus_damage_fleshy(pos)
	-- get all objects arround cactus
	local objs = minetest.env:get_objects_inside_radius(pos, 1)
	for i, obj in ipairs(objs) do
		if damage_enabled then
			if obj:is_player() or is_mortalentity(obj) then
				obj:punch(obj, 1.0, {full_punch_interval=1,damage_groups = {fleshy=1}})
				minetest.sound_play("poke", {gain = 0.05, pos = pos, object = obj})
			elseif obj:get_luaentity().name == "__builtin:item" then
					minetest.sound_play("poke", {gain = 0.05, pos = pos, object = obj})
					obj:remove()
			end
		end
	end
end

-- Attach new function to cactus
minetest.register_abm({
	nodenames = {"default:cactus"},
	neighbors = {nil},
	interval = 1.0,
	chance = 1,
	action = function(pos, node)
		cactus_damage_fleshy(pos, node)
	end,
})

