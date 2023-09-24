grid = {}
spouts = {}

function love.load()
  cellsize = 2
  gridsx = 80 * 10 / cellsize
  gridsy = 60 * 10 / cellsize
  creategrid(gridsx, gridsy)
  selectedcell = 1
  brushSize = 1 -- Initialize brush size
end

function love.update(dt)
  love.timer.sleep(1 / 60)

  -- Simulate spouts
  for _, spout in ipairs(spouts) do
    local gridX, gridY = spout.x, spout.y
    local dx = love.math.random(-1, 1)
    local dy = 1

    if not moveifempty(1, 0, gridX, gridY, 0, dy) then
      if not moveifempty(1, 0, gridX, gridY, dx, dy) then
        dx = -dx
        if not moveifempty(1, 0, gridX, gridY, dx, dy) then
          dx = love.math.random(-1, 1)
        end
      end
    end

    if gridY == gridsy then
      createcell(0, gridX, gridY)
    end
  end

  -- Handle placing spouts
  if love.keyboard.isDown("s") then
    local mouseX, mouseY = love.mouse.getPosition()
    local gridX = math.floor(mouseX / cellsize) + 1
    local gridY = math.floor(mouseY / cellsize) + 1

    -- Check if the position is valid and not already occupied
    if (
      gridX >= 1 and gridX <= gridsx and
      gridY >= 1 and gridY <= gridsy and
      grid[gridX][gridY].type == 0
    ) then
      table.insert(spouts, { x = gridX, y = gridY })
      createcell(2, gridX, gridY) -- Use a different cell type for spouts (2)
    end
  end
  for x = 1, gridsx do
    for y = gridsy, 1, -1 do
      local cell = grid[x][y].type
      if cell == 1 then
        local dx = love.math.random(-1, 1) -- Randomly select a horizontal direction
        if y > gridsy - 3 then
          local dy = 1
          sandmovement(x, y, dx, dy, grid)  -- Pass grid as an argument
        else
          local dy = love.math.random(1, 3)
          sandmovement(x, y, dx, dy, grid)  -- Pass grid as an argument
        end
        if y == gridsy then
          createcell(0, x, y)
        end
      end
    end
  end

  if love.mouse.isDown(1) then
    local mouseX, mouseY = love.mouse.getPosition()
    local gridX = math.floor(mouseX / cellsize) + 1
    local gridY = math.floor(mouseY / cellsize) + 1

    -- Use brushSize to determine the area to modify
    local halfBrush = math.floor(brushSize / 2)

    for i = -halfBrush, halfBrush do
      for j = -halfBrush, halfBrush do
        local targetX = gridX + i
        local targetY = gridY + j

        if (
          targetX >= 1 and targetX <= gridsx and
          targetY >= 1 and targetY <= gridsy
        ) then
          createcell(selectedcell, targetX, targetY)
        end
      end
    end
  end

  if love.keyboard.isDown("0") then
    selectedcell = 0
  elseif love.keyboard.isDown("c") then
    spouts = {}
    creategrid(gridsx,gridsy)
  elseif love.keyboard.isDown("2") then
    selectedcell = 2
  elseif love.keyboard.isDown("1") then
    selectedcell = 1
  elseif love.keyboard.isDown("2") then
    selectedcell = 2
  end
end

function love.wheelmoved(x, y)
  -- Adjust brush size with mouse wheel
  brushSize = math.max(1, brushSize + y)
end

function love.draw()
  for x = 1, gridsx do
    for y = 1, gridsy do
      cell = grid[x][y].type
      if cell == 1 then
        love.graphics.setColor(0.8, 0.8, 0)
        love.graphics.rectangle("fill", cellsize * x - cellsize, cellsize * y - cellsize, cellsize, cellsize)
      elseif cell == 2 then
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", cellsize * x - cellsize, cellsize * y - cellsize, cellsize, cellsize)
      end
    end
  end
end

function sandmovement(x, y, dx, dy)
  local friction = 0.1 -- Adjust this value to control friction
  local inertia = 0.5  -- Adjust this value to control inertia
  
  -- Check if the sand can move vertically
  if not moveifempty(1, 0, x, y, 0, dy) then
    -- Apply friction if sand is not moving horizontally
    if dx == 0 then
      dx = dx * (1 - friction)
    end
    
    -- Apply inertia to simulate sand's tendency to keep moving in the same direction
    if dx < 0 then
      dx = math.max(dx + inertia, -1)
    elseif dx > 0 then
      dx = math.min(dx - inertia, 1)
    end
    
    -- Try to move horizontally with adjusted dx
    if not moveifempty(1, 0, x, y, dx, dy) then
      -- If both directions are blocked, choose a random direction
      dx = love.math.random(-1, 1)
    end
  end
end

function move(cell, trail, x, y, xp, yp)
  if x + xp >= 1 and x + xp <= gridsx and y + yp >= 1 and y + yp <= gridsy then
    grid[x + xp][y + yp].type = cell
    grid[x][y].type = trail
  end
end

function moveifempty(cell, trail, x, y, xp, yp)
  if y < gridsy and grid[x + xp][y + yp].type == 0 then
    move(cell, trail, x, y, xp, yp)
    return true
  end
  return false
end

function createcell(cell, x, y)
  grid[x][y].type = cell
end

function creategrid(sx, sy)
  grid = {}
  for x = 1, sx do
    grid[x] = {}
    for y = 1, sy do
      grid[x][y] = { type = 0 }
    end
  end
end