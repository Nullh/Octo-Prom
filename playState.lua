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
  timer = 1
  collider = HC.new(300)
  map = mapLoader:new('maps/'..nextLevel..'.lua', 'assets/Tileset.png', collider)
  levelEnd = map:getLevelEnd()

  blockingObj = map:createBlockingObjFromLayer(collider, 'blocking')
  enemyBlockingObj = map:createBlockingObjFromLayer(collider, 'enemyblocking')
  allBaddies = baddiebuilder:new(map:getObjectsFromLayer('enemies'), collider, gravity)
  allPickups = map:getObjectsFromLayer('pickups')
  --bad1 = baddie:new(60, 60, 10, collider, gravity)
  myWorld = world:new(map, collider, gravity, allPickups)
  myPlayer = player:new(10, 140, 50, 60, 4, 0.5, myWorld, lives, score)

  myCamera = camera:new(map:getWidth(), map:getHeight(), 0, 4)
  myCamera:newLayer(-9, 0, function()
    love.graphics.setColor(256, 256, 256)
    map:draw(1, 1)
  end)
  myCamera:newLayer(-8, 1.1, function()
    love.graphics.setColor(256, 256, 256)
    map:draw(2, 2)
  end)
  myCamera:newLayer(-7, 1.2, function()
    love.graphics.setColor(256, 256, 256)
    map:draw(3, 3)
  end)
  myCamera:newLayer(-1, 1.0, function()
    love.graphics.setColor(256, 256, 256)
    map:draw(4, 4)
  end)
  myCamera:newLayer(0,1.0, function()
    love.graphics.setColor(255, 255, 255)
    myPlayer:draw()
    allBaddies:draw()
    myWorld:drawPickups()
  end)
  myCamera:newLayer(1, 1.0, function()
    love.graphics.setColor(256, 256, 256)
    map:draw(5, 5)
  end)
  myCamera:newLayer(2, 1.0, function()
    love.graphics.setColor(255, 255, 255)
    map:draw(6, 6)
    if debug == true then
      love.graphics.setColor(100, 100, 100, 150)
      for i, v in ipairs(blockingObj) do
        v:draw('fill')
      end
    end
  end)
  myCamera:newLayer(2, 1.3, function()
    love.graphics.setColor(256, 256, 256)
    map:draw(7, 7)
  end)
  collectgarbage()
end

function playState:loadLevel(name)
  --spaceReleased = true
  --collider = HC.resetHash(300)
  --map = mapLoader:new('maps/'..name..'.lua', 'assets/Blocks 8x8.png', collider)
  --myCamera:updateMapWidth(map:getWidth())
  --allPickups = map:getObjectsFromLayer('pickups')
  --myWorld = world:new(map, collider, gravity, allPickups)
  --levelEnd = map:getLevelEnd()
  --myPlayer:recreateCollObj(myWorld)
  --myPlayer:setCoords(10, 140)
  --myPlayer = player:new(10, 140, 50, 60, 3, 0.5, myWorld, myPlayer:getLives(), myPlayer:getScore())
  --blockingObj = map:createBlockingObjFromLayer(collider, 'blocking')
  --allBaddies = baddiebuilder:new(map:getObjectsFromLayer('enemies'), collider, gravity)
  --clear up orphaned objects
  --collectgarbage()
  state = 'levelEnd'
  nextLevel = name
  levelend = {}
  levelend = endState:new()
  levelend:init()


end

function playState:update(dt)
  if not myPlayer:isDead() then
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
    else
      timer = timer - dt
      if love.keyboard.isScancodeDown('space') and timer <= 0 then
        state = 'menu'
        menu = menuState:new()
        menu:init()
        score = 0
        lives = 3
        nextLevel = 'l1'
        currentLevel = 'l1'
      end
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
      love.graphics.setColor(44, 49, 6)
      love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
      love.graphics.setColor(206, 210, 161)
      love.graphics.printf("GAME OVER!", (love.graphics.getWidth()/2)-300, love.graphics.getHeight()/2, 100, 'center', 0, 3, 3)
      love.graphics.printf("PRESS SPACE TO RESTART", (love.graphics.getWidth()/2)-300, (love.graphics.getHeight()/4)*3, 100, 'center', 0, 3, 3)

    end
    if debug == true then
      --love.graphics.print(allBaddies:getBadInfo(), 10, 20)
      --love.graphics.print(table.getn(allPickups), 10, 10)
      --love.graphics.print(myWorld:getPickupInfo(), 10, 20)
      --love.graphics.print(myPlayer._invulnTimer, 10, 20)
      --for i, v in ipairs(collider) do
      --  v:draw('fill')
      --end
    end
end
