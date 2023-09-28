function love.load()
    love.window.setTitle("FallingSand by Enviction")
    love.window.setMode(800,600)
    cellSize = 2
    selectedblock = 1
    paused = false
    gridx,gridy = 0,0
    gridx, gridy = love.window.getMode()
    gridx =  gridx/ cellSize
    gridy = gridy/ cellSize
    brushSize = 1
    Tempplace = 25
    heatview = false
    debug = false
    data = {
        temp = 0,
        Block = 0
    }
    grid = {}
    for x = 0, gridx, 1 do
        grid[x] = {}
        for y = 0, gridy, 1 do
            grid[x][y] = {
                type = 0,
                awake = 0,
                temp = 0
            }
        end
    end
    cursorWidth = cellSize * brushSize
    cursorHeight = cellSize * brushSize
    names = {
        [0] = "Air",
        [1] = "Sand",
        [2] = "Stone",
        [3] = "Water",
        [4] = "Fire",
        [5] = "Wood",
        [6] = "Glass",
        [7] = "Steam",
        [8] = "Lava",
        [9] = "Coal",
    }
end


function love.keypressed(key)
    if key == 'space' then paused = not paused end
    if key == 'f' then logic() end
    if key == 'd' then debug = not debug end
    if key == 'h' then heatview = not heatview end
end

function love.wheelmoved(x, y)
    if not love.keyboard.isDown("lshift") then
        if y > 0 then
            brushSize = brushSize + 1
        elseif y < 0 then
            brushSize = math.max(1, brushSize - 1)
        end
    else
        if y > 0 then
            Tempplace = Tempplace + 25
        elseif y < 0 then
            Tempplace = math.max(0, Tempplace - 25)
        end
    end
    updateCursorSize()
end

function updateCursorSize()
    cursorWidth = cellSize * brushSize
    cursorHeight = cellSize * brushSize
end

function love.update(dt)
    love.timer.sleep(1/120)
    mx, my = ismousedown(1)
    for nk=0,9,1 do
        if love.keyboard.isDown(nk) then
            selectedblock = nk
        end
    end
    if mx and my and ismousedown(1) then
        local cursorX = math.floor(mx / cellSize)
        local cursorY = math.floor(my / cellSize)
        for i = cursorX, cursorX + brushSize - 1 do
            for j = cursorY, cursorY + brushSize - 1 do
                if i >= 0 and i < gridx and j >= 0 and j < gridy then
                    grid[i][j].type = selectedblock
                    grid[i][j].awake = 1
                    grid[i][j].temp = Tempplace
                end
            end
        end
    else
        mx, my = ismousedown(2)
        if mx and my and ismousedown(2) then
            for i = 0, brushSize - 1 do
                for j = 0, brushSize - 1 do
                    local bx, by = math.floor((mx + i * cellSize) / cellSize), math.floor((my + j * cellSize) / cellSize)
                    if bx >= 0 and bx < gridx and by >= 0 and by < gridy then
                        grid[bx][by].type = 0
                        grid[bx][by].awake = 1
                        grid[bx][by].temp = 0
                    end
                end
            end
        end
    end

    for x = 0, gridx, 1 do
        for y = 0, gridy, 1 do
            grid[x][y].awake = 1
        end
    end
    if not paused then
        logic()
    end
end


function miv(x,y,xp,yp,block1,block2,value,valueneed)
    if y < gridy and x+xp > 0 and x < gridx and grid[x+xp][y+yp].type == block1 or y < gridy and x > 0 and x < gridx and value == valueneed and grid[x+xp][y+yp].type == block2 then
        Swap(x,y,x+xp,y+yp)
        return true
    end
    return false
end


function heatdistro(x,y,heat)
    if grid[x][y].temp > (heat-1) then
        for ux = -1, 1 do
            for uy = -1, 1 do
                local nx, ny = x + ux, y + uy
                if borders(nx, ny) and nx >= 0 and ny >= 0 then
                    if grid[nx][ny].type ~= 0 then
                        grid[nx][ny].temp = grid[nx][ny].temp + heat/9
                        grid[x][y].temp = grid[x][y].temp - heat/9
                    else
                        if love.math.random(0,25) == 1 then
                            grid[nx][ny].temp = grid[nx][ny].temp + heat/9
                            grid[x][y].temp = grid[x][y].temp - heat/9
                        end
                    end
                end
            end
        end
    end
end


function logic()
    for x = 0, gridx, 1 do
        for y = 0, gridy, 1 do
            if y == gridy then
                grid[x][y].type = 0
                grid[x][y].awake = 0
            end
            if y == 0 then
                grid[x][y].type = 0
                grid[x][y].awake = 0
            end
            heatdistro(x,y,5)
            heatdistro(x,y,15)
            heatdistro(x,y,50)
            heatdistro(x,y,75)
            heatdistro(x,y,100)
            heatdistro(x,y,200)
            heatdistro(x,y,250)
            heatdistro(x,y,500)
            heatdistro(x,y,1000)
            heatdistro(x,y,1500)
            heatdistro(x,y,1750)
            heatdistro(x,y,2000)
            heatdistro(x,y,3000)

            --Sand
            if grid[x][y].type == 1 then
                if grid[x][y].awake == 1 then
                    dx = love.math.random(-1,1)
                    dy = love.math.random(1,3)
                    if y > gridy-6 then
                        dy = 1
                    end
                    if miv(x,y,0,dy,0,3,love.math.random(0,2),1) then
                    else 
                        if x == 0 then dx = 1 end
                        if miv(x,y,dx,dy,0,3,rand,1) then 
                        else
                            dx = 0-dx
                            miv(x,y,dx,dy,0,3,rand,1)
                        end
                    end
                    if inv(x,y,4) or inv(x,y,6) or inv(x,y,8) then
                        Nsleep(x,y)
                        grid[x][y].temp = grid[x][y].temp + 15
                    end
                    if grid[x][y].temp > 1000 then
                        grid[x][y].awake = 0
                        grid[x][y].type = 6
                        grid[x][y].temp = 1500
                    end
                end
            end
            --stone
            if grid[x][y].type == 2 then
                if grid[x][y].awake == 1 then
                    if grid[x][y].temp > 2000 then
                        grid[x][y].type = 8
                    end
                end
            end
            --Water
            if grid[x][y].type == 3 then
                if grid[x][y].awake == 1 then
                    dx = love.math.random(-1,1)
                    dy = love.math.random(2,4)
                    if y > gridy-6 then
                        dy = 1
                    end
                    if inv(x,y,4) or inv(x,y,8) then
                        Nsleep(x,y)
                        grid[x][y].temp = grid[x][y].temp + 15
                    end
                    if grid[x][y].temp > 50 then
                        grid[x][y].awake = 0
                        grid[x][y].type = 7
                        grid[x][y].temp = 150
                    end
                    if miv(x,y,0,dy,0,0,1,1) then
                    else
                        if x == 0 then dx = 1 end
                        if miv(x,y,dx,dy,0,0,1,1) then
                        else
                            dx = 0-dx
                            if miv(x,y,dx,dy,0,0,1,1) then
                            elseif miv(x,y,dx,0,0,0,1,1) then
                            else
                                dx = 0-dx
                                if miv(x,y,dx,0,0,0,1,1) then
                                end
                            end
                        end
                    end
                end
            end
            --Fire
            if grid[x][y].type == 4 then
                if grid[x][y].awake == 1 then
                    dx = love.math.random(-1,1)
                    dy = love.math.random(-1,1)
                    grid[x][y].temp = 150
                    if love.math.random(0,35) == 1 then
                        grid[x][y].type = 0
                        grid[x][y].awake = 0
                    end
                    if y < 2 then
                        grid[x][y].type = 0
                        grid[x][y].awake = 0
                    end
                    if inv(x,y,3) then
                        grid[x][y].type = 0
                        grid[x][y].awake = 0
                    end
                    if miv(x,y,0,dy,0,0,1,1) then end
                    if x == 0 then dx = 1 end
                    if miv(x,y,dx,dy,0,0,1,1) then
                    else
                        dx = 0-dx
                        if miv(x,y,dx,dy,0,0,1,1) then
                        elseif miv(x,y,dx,0,0,0,1,1) then
                        else
                            dx = 0-dx
                            if miv(x,y,dx,0,0,0,1,1) then end
                        end
                    end
                end
            end
            --Wood
            if grid[x][y].type == 5 then
                if grid[x][y].awake == 1 then
                    if x == 0 then
                        grid[x][y].awake = 0
                        grid[x][y].type = 0
                    elseif inv(x,y,4) or inv(x,y,8) then
                        Nsleep(x,y)
                        grid[x][y].temp = grid[x][y].temp + 15
                    end
                    if grid[x][y].temp > 230 then
                        grid[x][y].awake = 0
                        grid[x][y].type = 9
                    end
                end
            end
            --Glass
            if grid[x][y].type == 6 then
                if grid[x][y].awake == 1 then
                    if inv(x,y,4) or inv(x,y,8) then
                        grid[x][y].temp = grid[x][y].temp + 15
                    end
                end
            end
            --Steam
            if grid[x][y].type == 7 then
                if grid[x][y].awake == 1 then
                    dx = love.math.random(-1,1)
                    dy = love.math.random(-3,-2)
                    if y < 4 then
                        dy = 4
                        grid[x][y].awake = 1
                    end
                    if grid[x][y].temp < 50 then
                        grid[x][y].type = 3
                        grid[x][y].awake = 0
                        grid[x][y].temp = 10
                    else
                        grid[x][y].temp = grid[x][y].temp - love.math.random(0.1,0.5)
                    end
                    if miv(x,y,0,dy,0,3,1,1) then end
                    if x == 0 then dx = 1 end
                    if miv(x,y,dx,dy,0,3,1,1) then
                    else
                        dx = 0-dx
                        if miv(x,y,dx,dy,0,3,1,1) then
                        elseif miv(x,y,dx,0,0,3,1,1) then
                        else
                            dx = 0-dx
                            if miv(x,y,dx,0,0,3,1,1) then end
                        end
                    end
                end
            end
            --Lava
            if grid[x][y].type == 8 then
                if grid[x][y].awake == 1 then
                    grid[x][y].temp = 300
                    dx = love.math.random(-1,1)
                    dy = love.math.random(2,4)
                    if y > gridy-6 then
                        dy = 1
                    end
                    if love.math.random(0,15) == 1 then
                        if miv(x,y,0,dy,0,0,1,1) then
                        else
                            if x == 0 then dx = 1 end
                            if miv(x,y,dx,dy,0,0,1,1) then
                            else
                                dx = 0-dx
                                if miv(x,y,dx,dy,0,0,1,1) then
                                elseif miv(x,y,dx,0,0,0,1,1) then
                                else
                                    dx = 0-dx
                                    if miv(x,y,dx,0,0,0,1,1) then
                                    end
                                end
                            end
                        end
                    end
                end
            end
            --Coal
            if grid[x][y].type == 9 then
                if grid[x][y].awake == 1 then
                    if grid[x][y].temp > 25 then
                        if grid[x][y-1].type == 0 then
                            grid[x][y-1].type = 4
                        end
                    end
                    if grid[x][y].temp < 25 then
                        grid[x][y].type = 4
                    end
                end
            end
        end
    end
end


function inv(x,y,value)
    if x > 5 and x < gridx-5 and y > 5 and y < gridy-5 then
        if grid[x][y+1].type == value or grid[x-1][y].type == value or grid[x][y+1].type == value or grid[x+1][y].type == value or grid[x-1][y+1].type == value or grid[x-1][y-1].type == value or grid[x+1][y+1].type == value or grid[x+1][y-1].type== value then
            if grid[x][y+1].awake == 1 or grid[x-1][y].awake == 1 or grid[x][y+1].awake == 1 or grid[x+1][y].awake == 1 or grid[x-1][y+1].awake == 1 or grid[x-1][y-1].awake == 1 or grid[x+1][y+1].awake == 1 or grid[x+1][y-1].awake == 1 then
                return true
            end
        end
    end
    return false
end
function intmp(x,y,value)
    if x > 5 and x < gridx-5 and y > 5 and y < gridy-5 then
        if grid[x][y+1].temp > value or grid[x-1][y].temp > value or grid[x][y+1].temp > value or grid[x+1][y].temp > value or grid[x-1][y+1].temp > value or grid[x-1][y-1].temp > value or grid[x+1][y+1].temp > value or grid[x+1][y-1].temp > value then
            return true
        end
    end
    return false
end


function Nsleep(x,y)
    grid[x][y+1].awake = 0
    grid[x-1][y].awake = 0
    grid[x][y+1].awake = 0
    grid[x+1][y].awake = 0
    grid[x-1][y+1].awake = 0
    grid[x-1][y-1].awake = 0
    grid[x+1][y+1].awake = 0
    grid[x+1][y-1].awake = 0
end


function Ntemp(x,y,temp)
    if x > 5 and x < gridx-5 and y > 5 and y < gridy-5 then
        grid[x][y+1].temp = grid[x][y+1].temp + temp
        grid[x-1][y].temp = grid[x-1][y].temp + temp
        grid[x][y+1].temp = grid[x][y+1].temp + temp
        grid[x+1][y].temp = grid[x+1][y].temp + temp
        grid[x-1][y+1].temp = grid[x-1][y+1].temp + temp
        grid[x-1][y-1].temp = grid[x-1][y-1].temp + temp
        grid[x+1][y+1].temp = grid[x+1][y+1].temp + temp
        grid[x+1][y-1].temp = grid[x+1][y-1].temp + temp
    end
end


function love.draw()
    -- Get the cursor position in the middle of the mouse
    mx, my = love.mouse.getPosition()
    local cursorX = math.floor((mx - cursorWidth * 1) / cellSize) * cellSize
    local cursorY = math.floor((my - cursorHeight * 1) / cellSize) * cellSize

    -- Draw the cursor rectangle
    
    
    -- Draw the grid cells
    for x = 0, gridx, 1 do
        for y = 0, gridy, 1 do
            tmp = grid[x][y].temp / 250
            if heatview then
                tmp = tmp*2
            end
            if grid[x][y].type == 1 then
                love.graphics.setColor(0.8+(tmp/5), 0.8, 0)
                love.graphics.rectangle("fill", cellSize * x, cellSize * y, cellSize, cellSize)
            elseif grid[x][y].type == 2 then
                love.graphics.setColor(0.5+tmp, 0.5, 0.5)
                love.graphics.rectangle("fill", cellSize * x, cellSize * y, cellSize, cellSize)
            elseif grid[x][y].type == 3 then
                love.graphics.setColor(0.1+(tmp/10), 0.1, 0.8)
                love.graphics.rectangle("fill", cellSize * x, cellSize * y, cellSize, cellSize)
            elseif grid[x][y].type == 4 then
                love.graphics.setColor(0.8+tmp, 0.1, 0.1)
                love.graphics.rectangle("fill", cellSize * x, cellSize * y, cellSize, cellSize)
            elseif grid[x][y].type == 5 then
                love.graphics.setColor(0.7+tmp, 0.5, 0.1)
                love.graphics.rectangle("fill", cellSize * x, cellSize * y, cellSize, cellSize)
            elseif grid[x][y].type == 6 then
                love.graphics.setColor(0.7+tmp, 0.7, 0.7)
                love.graphics.rectangle("fill", cellSize * x, cellSize * y, cellSize, cellSize)
            elseif grid[x][y].type == 7 then
                love.graphics.setColor(0.5, 0.5, 0.5)
                love.graphics.rectangle("fill", cellSize * x, cellSize * y, cellSize, cellSize)
            elseif grid[x][y].type == 8 then
                love.graphics.setColor(5+tmp, 0.0, 0.0)
                love.graphics.rectangle("fill", cellSize * x, cellSize * y, cellSize, cellSize)
            elseif grid[x][y].type == 9 then
                love.graphics.setColor(0.05+(tmp/10), 0.05, 0.0)
                love.graphics.rectangle("fill", cellSize * x, cellSize * y, cellSize, cellSize)
            end
            if heatview then
                if grid[x][y].type == 0 and grid[x][y].temp > 10 then
                    love.graphics.setColor(0.0+(tmp), 0.0, 0.0)
                    love.graphics.rectangle("line", cellSize * x, cellSize * y, cellSize, cellSize)
                end
            end
        end
    end

    debugtext()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", cursorX+cursorWidth, cursorY+cursorHeight, cursorWidth, cursorHeight)
end


function debugtext()
    if mx and my then
        local msx = math.floor(mx / cellSize)
        local msy = math.floor(my / cellSize)
        for i = msx, msx, - 1 do
            for j = msy, msy, - 1 do
                data = {
                    temp = grid[i][j].temp,
                    blockk = grid[i][j].type,
                }
            end
        end
    end
    if debug then
        love.graphics.setColor(1,1,1)
        love.graphics.print("Block:",            10,15      )
        love.graphics.print(names[selectedblock],50,15      )
        love.graphics.print("Temp:",             10,35      )
        love.graphics.print(Tempplace,           50,35      )

        love.graphics.print("Block:",            mx+10,my   )
        love.graphics.print(names[data.blockk],   mx+50,my   )
        love.graphics.print("Temp:",             mx+10,my+15)
        love.graphics.print(data.temp,           mx+50,my+15)
    end
end


function Swap(x1,y1,x2,y2)
    gridxy = grid[x1][y1].type
    tempxy = grid[x1][y1].temp
    grid[x1][y1].type = grid[x2][y2].type
    grid[x1][y1].temp = grid[x2][y2].temp
    grid[x2][y2].type = gridxy
    grid[x2][y2].temp = tempxy
    grid[x1][y1].awake = 0
    grid[x2][y2].awake = 0
    
end


function borders(x,y)
    return (y < gridy and x > 0 and x < gridx)
end


function ismousedown(button)
    mx, my = love.mouse.getPosition()
    return love.mouse.isDown(button) and mx, my
end