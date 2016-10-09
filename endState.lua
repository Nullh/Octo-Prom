local class = require 'middleclass'

endState = class('endState')

local anim8 = require 'anim8'
require 'playState'



function endState:initialize()

end


function endState:init()
  self._timer = 2
  self._text = 'test'
  if currentLevel == 'l1' then
    self._image = love.graphics.newImage('assets/Cool hat.png')
    self._text = 'YOU GOT A COOL HAT!'
  elseif currentLevel == 'l2' then
    self._image = love.graphics.newImage('assets/Sweet Kicks.png')
    self._text = 'YOU GOT FORMAL SHOES!'
  elseif currentLevel == 'finale' then
    self._finalOcto = love.graphics.newImage('assets/FinalOcto.png')
    self._finalGrid = anim8.newGrid(64, 64, self._finalOcto:getWidth(), self._finalOcto:getHeight())
    self._finalAnimate = anim8.newAnimation(self._finalGrid('1-2',1, '1-2',2), 0.2)
    self._text = "YOU LOOK GREAT! LET'S GO TO THE PROM!"
  end
  self._background = love.graphics.newImage('assets/spin.png')
  self._grid = anim8.newGrid(160, 144, self._background:getWidth(), self._background:getHeight())
  self._spin = anim8.newAnimation(self._grid('1-9',1), 0.05)
end

function endState:update(dt)
  self._timer = self._timer - dt
  self._spin:update(dt)
  if currentLevel == 'finale' then
    self._finalAnimate:update(dt)
  end
  game = {}
  collectgarbage()
  if love.keyboard.isScancodeDown('space') and self._timer <= 0 then
    if currentLevel == 'finale' then
      state = 'menu'
      menu = menuState:new()
      menu:init()
      score = 0
      lives = 3
      currentLevel = 'l1'
      nextLevel = 'l1'
    elseif nextLevel == 'finale' then
      --state = 'levelEnd'
      currentLevel = 'finale'
      self:init()
    else
      game = playState:new()
      game:init()
      state = 'game'
      currentLevel = nextLevel
    end
  end
  if love.keyboard.isScancodeDown('escape') then
    love.event.quit()
  end
end

function endState:draw()
  love.graphics.setColor(255,255,255)
  --love.graphics.draw(self._splashScreen, 0, 0, 0, 4, 4)
  self._spin:draw(self._background, 0, 0, 0, 4, 4)

  if currentLevel == 'finale' then
    self._finalAnimate:draw(self._finalOcto, (love.graphics.getWidth()/2) - ((self._image:getWidth()/2)*4), (love.graphics.getHeight()/2) - ((self._image:getHeight()/2)*4), 0, 4, 4)
  else
    love.graphics.draw(self._image, (love.graphics.getWidth()/2) - ((self._image:getWidth()/2)*4), (love.graphics.getHeight()/2) - ((self._image:getHeight()/2)*4), 0, 4, 4)
  end
  love.graphics.setColor(44, 49, 6)
  love.graphics.printf(self._text, 0, (love.graphics.getHeight()/8), love.graphics.getWidth()/4, 'center', 0, 4, 4)
  if self._timer <= 0 then
    love.graphics.printf('PRESS SPACE', 0, (love.graphics.getHeight()/8)*7, love.graphics.getWidth()/4, 'center', 0, 4, 4)
  end
  if debug then
    love.graphics.print(self._timer, 100, 100)
  end
end
