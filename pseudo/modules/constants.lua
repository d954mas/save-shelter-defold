local M = {}
-- map inits/ in second
M.PLAYER_SPEED = 3.8
M.PLATER_START_ROT = -90* 3.1415 / 180

M.PLAYER_RAYS = 80
--use fov bigger then in camera to be sure that all models will be visible 
--i have idea not draw model that outside of fov.For now it is not done
M.PLAYER_FOV = 80 * 3.1415 / 180 

M.MINIMAP_SCALE = 15
M.check=true


return M