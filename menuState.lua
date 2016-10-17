local class = require 'middleclass'

menuState = class('menuState')


function menuState:initialize()

end


function menuState:init()
  self._splashScreen = love.graphics.newImage('assets/Splash Screen.png')
  self._timer = 1
end

function menuState:update(dt)
  self._timer = self._timer - dt
  if love.keyboard.isScancodeDown('space') and self._timer <= 0 then
    game = playState:new()
    game:init()
    state = 'game'
  end
  if love.keyboard.isScancodeDown('escape') then
    love.event.quit()
  end
end

function menuState:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(self._splashScreen, 0, 0, 0, 4, 4)
end
