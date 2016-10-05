local class = require 'middleclass'
local anim8 = require 'anim8'

squirt = class('squirt')

local _animation = {}
local _player = {}

function squirt:initialize(x, y, image, player)
  self._x = x
  self._y = y
  _player = player
  self._image = image
  self._grid = anim8.newGrid(8, 16, self._image:getWidth(), self._image:getHeight())
  _animation = anim8.newAnimation(self._grid('1-4',1, '1-4',2, '1-2',3), 0.1, destroy)
end

function squirt:draw()
  _animation:draw(self._image, self._x-4, self._y-4)
end

function squirt:update(dt)
  _animation:update(dt)
end

function destroy()
  _animation:pause()
  _player:removeSquirt()
end
