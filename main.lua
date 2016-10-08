-- Colours
-- #ced2a1 - 206, 210, 161
-- #a9af70 - 169, 175, 112
-- #585e20 - 88, 94, 32
-- #2c3106 - 44, 49, 6


require 'playState'
require 'menuState'
require 'endState'

debug = true
local blockingObj = {}
local spaceReleased = true



function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest',0)
  state = 'menu'
  currentLevel = 'level1'
  nextLevel = 'level1'
  score = 0
  lives = 3

  game = playState:new()
  menu = menuState:new()
  levelend = endState:new()

  game:init()
  menu:init()
  levelend:init()

end

function love.update(dt)
  if state == 'game' then
    game:update(dt)
  elseif state == 'menu' then
    menu:update(dt)
  elseif state == 'levelEnd' then
    levelend:update(dt)
  end
end

function love.draw()
  if state == 'game' then
    game:draw()
  elseif state == 'menu' then
    menu:draw()
  elseif state == 'levelEnd' then
    levelend:draw()
  end
  if debug then
    love.graphics.print(nextLevel, 100, 100)
  end
end
