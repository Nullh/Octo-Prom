local class = require 'middleclass'

endState = class('endState')

local anim8 = require 'anim8'
require 'playState'



function endState:initialize()

end


function endState:init()
  self._background = love.graphics.newImage('assets/spin.png')
  self._grid = anim8.newGrid(160, 144, self._background:getWidth(), self._background:getHeight())
  self._spin = anim8.newAnimation(self._grid('1-9',1), 0.05)
end

function endState:update(dt)
  self._spin:update(dt)
  game = {}
  collectgarbage()
  if love.keyboard.isScancodeDown('space') then
    game = playState:new()
    game:init()
    state = 'game'
  end
  if love.keyboard.isScancodeDown('escape') then
    love.event.quit()
  end
end

function endState:draw()
  love.graphics.setColor(255,255,255)
  --love.graphics.draw(self._splashScreen, 0, 0, 0, 4, 4)
  self._spin:draw(self._background, 0, 0, 0, 4, 4)
end
