local class = require 'middleclass'
require 'TEsound'

world = class('world')

function world:initialize(map, collider, gravity)
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
  --self._topBorder = collider:rectangle(-10, -10, self._width + 20, 10)
  --self._topBorder.type = 'bounds'

  self._muted = false

  --TEsound.playLooping('assets/MSTRself._-self._MSTRself._-self._Choroself._bavarioself._Loop.ogg', 'bgm')
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
