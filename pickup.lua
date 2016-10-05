local class = require 'middleclass'

pickup = class('pickup')

function pickup:initialize(x, y, collider, id)
  self._x = x
  self._y = y
  self._collider = collider
  self._id = id
  self._visible = true
  local rand = love.math.random(1,3)
  if rand == 1 then
    self._sprite = love.graphics.newImage('assets/Baddie.png')
  elseif rand == 2 then
    self._sprite = love.graphics.newImage('assets/Baddie.png')
  elseif rand == 3 then
    self._sprite = love.graphics.newImage('assets/Baddie.png')
  end
  self._collObj = collider:rectangle(self._x, self._y, self._sprite:getWidth(), self._sprite:getHeight())
  self._collObj.type = 'pickup'
  self._collObj.id = self._id
end

function pickup:draw()
  if self._visible then
    love.graphics.draw(self._sprite, self._x, self._y)
    if debug then
      love.graphics.setColor(100, 100, 100, 150)
      self._collObj:draw('fill')
      love.graphics.setColor(0,0,0)
      love.graphics.print(self._collObj.id, self._x, self._y)
    end
  end
end

function pickup:collect()
  self._collider:remove(self._collObj)
  self._visible = false
end

function pickup:getX()
  return self._x
end

function pickup:getY()
  return self._y
end

function pickup:getId()
  return self._id
end
