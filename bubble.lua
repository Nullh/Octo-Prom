local class = require 'middleclass'
local anim8 = require 'anim8'

bubble = class('bubble')

local _bouyancy = 10

function bubble:initialize(x, y, image)
  self._x = x
  self._y = y
  self._xOffset = 0
  self._xBound = 8
  self._direction = love.math.random(1,2)
  self._image = image
end

function bubble:draw()
  love.graphics.draw(self._image, self._x-4, self._y-4)
end

function bubble:update(dt)
  self._y = self._y - (_bouyancy * dt)
  if self._direction == 1 then
    self._x = self._x + (3*dt)
    self._xOffset = self._xOffset + (3*dt)
    if self._xOffset > self._xBound then
      self._direction = 2
    end
  elseif self._direction == 2 then
    self._x = self._x - (3*dt)
    self._xOffset = self._xOffset - (3*dt)
    if self._xOffset < -self._xBound then
      self._direction = 1
    end
  end
end

function bubble:getY()
  return self._y
end
