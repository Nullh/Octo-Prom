local class = require 'middleclass'

menuState = class('menuState')

local HC = require 'HC'
require 'mapLoader'
require 'player'
require 'camera'
require 'world'
require 'TEsound'
require 'baddie'
require 'baddiebuilder'

function menuState:initialize()

end


function menuState:init()
  self._splashScreen = love.graphics.newImage('assets/Splash Screen.png')
end

function menuState:update(dt)
  if love.keyboard.isScancodeDown('space') then
    state = 'game'
  end
end

function menuState:draw()
  love.graphics.draw(self._splashScreen, 0, 0, 0, 4, 4)
end
