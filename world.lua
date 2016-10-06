local class = require 'middleclass'
require 'TEsound'
require 'pickup'

world = class('world')

function world:initialize(map, collider, gravity, pickups)
  self._map = map
  self._collider = collider
  self._gravity = gravity
  self._width = map:getWidth()
  self._height = map:getHeight()

  -- add walls at screen edge
  self._leftBorder = collider:rectangle(-10, -10, 10, self._height + 20)
  self._leftBorder.type = 'bounds'
  self._rightBorder = collider:rectangle(self._width, -10, 10, self._height + 20)
  self._rightBorder.type = 'bounds'
  self._botBorder = collider:rectangle(-10, self._height, self._width + 20, 10)
  self._botBorder.type = 'bounds'

  self._pickups = {}
  for i, pckp in ipairs(pickups) do
    --local x, y = bad:center()
    local obj = pickup:new(pckp['x'], pckp['y'], self._collider, i)
    --self._baddiesTable[obj] = obj
    table.insert(self._pickups, obj)
  end

  self._muted = false

  --TEsound.playLooping('assets/MSTRself._-self._MSTRself._-self._Choroself._bavarioself._Loop.ogg', 'bgm')
end

--reload world after a map is loaded
function world:reload(collider, pickups)
  self._collider = collider
  self._pickups = {}
-- get the list of pickups  self._pickups = {}
  for i, pckp in ipairs(pickups) do
    --local x, y = bad:center()
    local obj = pickup:new(pckp['x'], pckp['y'], self._collider, i)
    --self._baddiesTable[obj] = obj
    table.insert(self._pickups, obj)
  end
  -- add walls at screen edge
  self._leftBorder = self._collider:rectangle(-10, -10, 10, self._height + 20)
  self._leftBorder.type = 'bounds'
  self._rightBorder = self._collider:rectangle(self._width, -10, 10, self._height + 20)
  self._rightBorder.type = 'bounds'
  self._botBorder = self._collider:rectangle(-10, self._height, self._width + 20, 10)
  self._botBorder.type = 'bounds'
end

function world:mute()
  if self._muted == false then
    TEsound.pause('bgm')
    self._muted = true
  else
    TEsound.resume('bgm')
    self._muted = false
  end
end

function world:drawPickups()
  for i, v in ipairs(self._pickups) do
    v:draw()
  end
end

function world:removePickup(id)
  for i, v in ipairs(self._pickups) do
    if v:getId() == id then
      v:collect()
    end
  end
end

function world:getPickupInfo()
  local test = table.getn(self._pickups)
  for i, obj in ipairs(self._pickups) do
    test = test..'\n'..obj:getX()..','..obj:getY()
  end
  return test
end

-- what happens when two things collide
-- testObj is the object to be tested
-- exclude is the name of objects to exclude
function world:collideWith(testObj, exclude)
  for shape, delta in pairs(collider:collisions(testObj:getCollObj())) do
    if shape.name ~= exclude then
      testObj:setCoords(testObj:getX() + delta.x, testObj:getY() + delta.y)
      --testObj:setYVelocity(0)
      if delta.y < 0 then
        testObj:setYVelocity(0)
      elseif delta.y > 0 then
        testObj:setYVelocity(0.1)
      end
    end
  end
end

function world:getGravity()
  return self._gravity
end

function world:getCollider()
  return self._collider
end
