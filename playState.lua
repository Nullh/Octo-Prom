local class = require 'middleclass'

playState = class('playState')

local HC = require 'HC'
require 'mapLoader'
require 'player'
require 'camera'
require 'world'
require 'TEsound'
require 'baddie'
require 'baddiebuilder'

function playState:initialize()

end

function love.keyreleased(key, scancode)
  if scancode == 'space' then
    spaceReleased = true
  end
end

function love.keypressed(key, scancode, isrepeat)
  if scancode == 'm' and isrepeat == false then
    myWorld.mute()
  end
end

function playState:init()
  gravity = 10
  map = mapLoader:new('maps/map4.lua', 'assets/Blocks 8x8.png')
  collider = HC.new(300)
  blockingObj = map:createBlockingObjFromLayer(collider, 'blocking')
  allBaddies = baddiebuilder:new(map:getObjectsFromLayer('enemies'), collider, gravity)
  myPlayer = player:new(10, 140, 50, 60, 3, 0.5, collider, gravity)
  bad1 = baddie:new(60, 60, 10, collider, gravity)
  myWorld = world:new(map, collider, 500)

  myCamera = camera:new(map:getWidth(), map:getHeight(), 0, 4)
  myCamera:newLayer(-3, 0, function()
    love.graphics.setColor(256, 256, 256)
    map:draw(1, 1)
  end)
  myCamera:newLayer(-2, 1.1, function()
    love.graphics.setColor(256, 256, 256)
    map:draw(2, 2)
  end)
  myCamera:newLayer(-1,1.0, function()
    love.graphics.setColor(255, 255, 255)
    myPlayer:draw()
    allBaddies:draw()
  end)
  myCamera:newLayer(0, 1.0, function()
    love.graphics.setColor(255, 255, 255)
    map:draw(3, 3)
    if debug == true then
      love.graphics.setColor(100, 100, 100, 150)
      for i, v in ipairs(blockingObj) do
        v:draw('fill')
      end
    end
  end)
end

function playState:update(dt)

    -- movement handler
    if love.keyboard.isScancodeDown('left', 'a') then
      myPlayer:moveLeft(dt)
    end
    if love.keyboard.isScancodeDown('right', 'd') then
      myPlayer:moveRight(dt)
    end
    if love.keyboard.isScancodeDown('space') then
      spaceReleased = false
      myPlayer:jump(dt, spaceReleased)
    end

    if love.keyboard.isScancodeDown('escape') then
      love.event.quit()
    end

    myPlayer:update(dt, spaceReleased)
    allBaddies:update(dt, map:getHeight())
    myCamera:centerOn(myPlayer:getX(), myPlayer:getY())

    TEsound.cleanup()
end

function playState:draw()

    myCamera:draw()

    if myPlayer:isDead() then
      love.graphics.printf("Game Over!", (love.graphics.getWidth()/2)-300, love.graphics.getHeight()/2, 100, 'center', 0, 3, 3)
      love.graphics.setColor(100, 100, 100, 150)
      love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
    if debug == true then
      love.graphics.print(allBaddies:getBadInfo(), 10, 20)
      --love.graphics.print(myPlayer._invulnTimer, 10, 20)
    end
end