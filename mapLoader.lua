local class = require 'middleclass'

mapLoader = class('mapLoader')

function mapLoader:initialize(path, atlaspath)
  -- load the map file
  self._file = love.filesystem.load(path)()
  -- load the atlas
  -- TODO: make this load each atlas per layer
  self._atlas = love.graphics.newImage(atlaspath)
  -- load the tiles for the map
  self._tiles = {}
  local ids = {} -- list of all tileIds
  local tileids = {} -- list of non-duplicate tileIds
  local hash = {} -- used for de-dup
  -- union all map data across layers
  local n = 1
  for i=1, table.getn(self._file.layers) do
    if self._file.layers[i].type == "tilelayer" then
      for v in pairs(self._file.layers[i].data) do
        ids[n] = self._file.layers[i].data[v]
        n = n+1
      end
    end
  end
  -- get unique tileIDs
  for i,v in ipairs(ids) do
    if (not hash[v]) then
      tileids[#tileids+1] = v
      hash[v] = true
    end
  end
  -- create the table containing the quads
  for i=1, table.getn(tileids) do
    r = tileids[i]
    self._tiles[r] = self:getQuad(r)
  end
end --loadMap()

-- Return the quad for a tileid
function mapLoader:getQuad(tileId)
  -- Get the x index of the tile
  tileX = (((tileId -1) % (self._file.tilesets[1].imagewidth/self._file.tilesets[1].tilewidth)) * self._file.tilesets[1].tilewidth)
  -- get the y index of the tile
  tileY = ((math.floor((tileId - 1) / (self._file.tilesets[1].imagewidth/self._file.tilesets[1].tilewidth))) * self._file.tilesets[1].tilewidth)
  return love.graphics.newQuad(tileX, tileY, self._file.tilesets[1].tilewidth, self._file.tilesets[1].tileheight, self._file.tilesets[1].imagewidth, self._file.tilesets[1].imageheight)
end -- getQuad()

function mapLoader:getHeight()
  return self._file.height * self._file.tileheight
end

function mapLoader:getWidth()
  return self._file.width * self._file.tilewidth
end


function mapLoader:draw(minLayer, maxLayer)
  -- iterate layers
  if table.getn(self._file.layers) < maxLayer then
    maxLayer = table.getn(self._file.layers)
  end
  if minLayer <= 0 then
    minLayer = 1
  end
  for n = minLayer, maxLayer do
    if self._file.layers[n].type == "tilelayer" then
        local row = 1
        local column = 1
        -- for each data elemnt in the layer's table
        for l = 1, table.getn(self._file.layers[n].data) do
          -- goto the next row if we've passed the screen width and reset columns
          if column > self._file.layers[n].width then
            column = 1
            row = row + 1
          end
          -- draw the tile as long as it's not 0 (empty)
          if self._file.layers[n].data[l] ~= 0 then
            love.graphics.setColor(256,256,256)
            love.graphics.draw(self._atlas, self._tiles[self._file.layers[n].data[l]],
              (column * self._file.tileheight) - self._file.tileheight, (row * self._file.tilewidth) - self._file.tilewidth)
          end
          -- move to the next column
          column = column + 1
        end
      end
    end
end -- drawMap()

-- get objects from a named object layer
function mapLoader:createBlockingObjFromLayer(collider, layerString)
  local tileTable = {}
  local matchLayer = nil
  local row = 1
  local column = 1

  for i=1, table.getn(self._file.layers) do
    if self._file.layers[i].name == layerString then
      -- find the blocking layer
      matchLayer = i
    end
  end

  -- draw each blocking object
  for i=1, table.getn(self._file.layers[matchLayer].objects) do
    if self._file.layers[matchLayer].objects[i].shape == "rectangle" then
      table.insert(tileTable, collider:rectangle(self._file.layers[matchLayer].objects[i].x, self._file.layers[matchLayer].objects[i].y,
          self._file.layers[matchLayer].objects[i].width, self._file.layers[matchLayer].objects[i].height))
      tileTable[table.getn(tileTable)].name = layerString
    elseif self._file.layers[matchLayer].objects[i].shape == "ellipse" then
      table.insert(tileTable, collider:circle(self._file.layers[matchLayer].objects[i].x + (self._file.layers[matchLayer].objects[i].width/2),
          self._file.layers[matchLayer].objects[i].y + (self._file.layers[matchLayer].objects[i].width/2),
          self._file.layers[matchLayer].objects[i].width/2))
      tileTable[table.getn(tileTable)].name = layerString
    end
  end
  return tileTable
end -- getMapObjectLayer()

function mapLoader:getObjectsFromLayer(layerString)
  local tileTable = {}
  local matchLayer = nil

  for i=1, table.getn(self._file.layers) do
    if self._file.layers[i].name == layerString then
      -- find the blocking layer
      matchLayer = i
    end
  end

  for i, obj in ipairs(self._file.layers[matchLayer].objects) do
      table.insert(tileTable, {x = obj.x, y = obj.y})
  end

  return tileTable
end
