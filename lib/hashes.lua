local M = {}

M.INPUT_TOUCH = hash("touch")
M.INPUT_ACQUIRE_FOCUS = hash("acquire_input_focus")
M.INPUT_RELEASE_FOCUS = hash("release_input_focus")

M.MSG_PHYSICS_CONTACT = hash("contact_point_response")
M.MSG_PHYSICS_COLLISION = hash("collision_response")
M.MSG_PHYSICS_TRIGGER = hash("trigger_response")
M.MSG_PHYSICS_RAY_CAST= hash("ray_cast_response")

M.MSG_RENDER_CLEAR_COLOR = hash("clear_color")
M.MSG_RENDER_SET_VIEW_PROJECTION = hash("set_view_projection")
M.MSG_RENDER_WINDOW_RESIZED = hash("window_resized")
M.MSG_PLAY_SOUND = hash("play_sound")
M.MSG_ENABLE = hash("enable")
M.MSG_DISABLE = hash("disable")
M.MSG_PLAY_ANIMATION = hash("play_animation")
M.MSG_ACQUIRE_CAMERA_FOCUS = hash("acquire_camera_focus")

M.CONTROLLER_LOAD_MAP = hash("load_map")
M.CONTROLLER_MAP_CHANGED = hash("map_changed")
M.CONTROLLER_SPAWN_WALLS = hash("spawn_walls")
M.CONTROLLER_SPAWN_FLOORS = hash("spawn_floors")
M.CONTROLLER_SPAWN_CEILS = hash("spawn_ceils")
M.CONTROLLER_SPAWN_GEOMETRY = hash("spawn_geometry")
M.CONTROLLER_SPAWN_OBJECTS = hash("spawn_objects")
M.CONTROLLER_SPAWN_SPRITES = hash("spawn_sprites")
M.CONTROLLER_SPAWN_PICKUPS = hash("spawn_pickups")
M.CONTROLLER_SPAWN_ENEMIES = hash("spawn_enemies")
M.CONTROLLER_SPAWN_3D_SOUNDS = hash("spawn_3d_sounds")

M.PLAYER_CHANGE_POSITION = hash("player_change_position")

M.RGB = hash("rgb")

M.PHYSICS_GROUP_PICKUPS=hash("pickups")
M.PHYSICS_GROUP_BLOCK_PROJECTIVES=hash("block_projectives")
M.PHYSICS_GROUP_BLOCK_PROJECTIVES_PLAYER=hash("block_projectives_player")
M.PHYSICS_GROUP_WALL=hash("wall")


M.INPUT_SHOW_MAP = hash("show_map")
M.INPUT_UP = hash("up")
M.INPUT_DOWN = hash("down")
M.INPUT_LEFT = hash("left")
M.INPUT_RIGHT = hash("right")
M.INPUT_RIGHT_HAND = hash("right_hand")
M.INPUT_LEFT_HAND = hash("left_hand")
M.INPUT_NEXT_ITEM = hash("next_item")
M.INPUT_PREV_ITEM = hash("prev_item")


return M
