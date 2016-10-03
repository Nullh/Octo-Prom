local class = require 'middleclass'

camera = class('camera')

function camera:initialize(mapWidth, mapHeight, rotation, scale)
  self._width = love.graphics.getWidth()
  self._height = love.graphics.getHeight()
  self._mapWidth = mapWidth
  self._mapHeight = mapHeight
  self._rotation = rotation
  self._scale = scale
  self._layers = {}
  self._transformationX = nil
  self._transformationY = nil
end

function camera:centerOn(x, y)
  if self._width  < self._mapWidth*self._scale then
    self._transformationX = math.floor((-x * self._scale) + (self._width /2))/self._scale
    if self._transformationX > 0 then
      self._transformationX = 0
    elseif self._transformationX < ((self._mapWidth)  - (self._width)) then
      self._transformationX = (self._mapWidth - self._width)
    end
  else
    self._transformationX = ((self._width / self._scale) - self._mapWidth)/2
  end

  if self._height < self._mapHeight * self._scale then
    self._transformationY = (-y /2)/self._scale
    if self._transformationY > 0 then
      self._transformationY = 0
    elseif self._transformationY < -((self._mapHeight * self._scale)  - (self._height))/self._scale then
      self._transformationY = (self._height / self._scale) - self._mapHeight
    end
  else
    self._transformationY = ((self._height / self._scale) - self._mapHeight)/2
  end

  --if self._height  < self._mapHeight*self._scale  then
  --  self._transformationY = math.floor(-y/self._scale + ((self._height/self._scale) /2))
  --  if self._transformationY > 0 then
  --    self._transformationY = 0
  --  elseif self._transformationY < -((self._mapHeight/self._scale)  - (self._height/self._scale)) then
  --    self._transformationY = -((self._mapHeight/self._scale)  - (self._height/self._scale))
  --  end
  --else
  --  self._transformationY = ((self._height/self._scale)  - (self._mapHeight/self._scale))/2
  --end
end

function camera:newLayer(order, scale, func)
  local newLayer = {draw = func, scale = scale, order = order}
  table.insert(self._layers, newLayer)
  table.sort(self._layers, function(a,b) return a.order < b.order end)
  return newLayer
end

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self._rotation)
  love.graphics.scale(self._scale, self._scale)
  love.graphics.translate(self._transformationX, self._transformationY)
end

function camera:unset()
  love.graphics.pop()
end

function camera:draw()
  local bx, by = self._transformationX, self._transformationY
  for i, v in ipairs(self._layers) do
    self._transformationX = bx * v.scale
    --self._transformationY = by * v.scale
    self:set()
    v.draw()
    self:unset()
  end
  self._transformationX, self._transformationY = bx, by
  -- draw lives remaining
  love.graphics.setColor(206, 210, 161)
  love.graphics.print('Lives: '..myPlayer:getLives(), love.graphics.getWidth()-(50*self._scale), 10, 0, self._scale, self._scale)
  love.graphics.setColor(256, 256, 256)
end

function camera:getScale()
  return self._scale
end
