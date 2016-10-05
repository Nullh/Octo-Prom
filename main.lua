-- Colours
-- #ced2a1 - 206, 210, 161
-- #a9af70 - 169, 175, 112
-- #585e20 - 88, 94, 32
-- #2c3106 - 44, 49, 6


require 'playState'
require 'menuState'

debug = true
local blockingObj = {}
local spaceReleased = true



function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest',0)
  state = 'menu'
  game = playState:new()
  menu = menuState:new()

  game:init()
  menu:init()

end

function love.update(dt)
  if state == 'game' then
    game:update(dt)
  elseif state == 'menu' then
    menu:update(dt)
  end
end

function love.draw()
  if state == 'game' then
    game:draw()
  elseif state == 'menu' then
    menu:draw()
  end
end
