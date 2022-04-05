PlayState = Class{}

function PlayState:init()
    self.balls = {}
    self.numOfBalls = NUM_OF_BALLS
    self.blocks = {}
    self.numOfBlocks = 0
    for i = 1, ROWS, 1 do
        table.insert(self.blocks, {})
        for j = 1, COLS, 1 do
            if math.random(2) == 1 then
                table.insert(self.blocks[i], Block(START_COLS + (j - 1) * BLOCK_SIZE, START_ROWS + (i - 1) * BLOCK_SIZE))
                self.numOfBlocks = self.numOfBlocks + 1
            end
        end
    end
    self.playState = 'aim'
    self.aimDirection = math.pi / 2
    self.ballTimer = {}
    self.gameOver = false
end

function PlayState:update(dt)
    local dtf = dt
    local tolerance = 2
    if self.playState == 'aim' then
        if love.keyboard.isDown('left') then
            self.aimDirection = math.max(self.aimDirection - AIM_DIR_RATE_OF_CHANGE * dt, MIN_AIM)
        elseif love.keyboard.isDown('right') then
            self.aimDirection = math.min(self.aimDirection + AIM_DIR_RATE_OF_CHANGE * dt, MAX_AIM)
        end

        if love.keyboard.wasPressed('space') then
            self:fire()
            self.playState = 'firing'
        end
    elseif self.playState == 'firing' then
        if love.keyboard.isDown('space') then
            dtf = dtf * 4
            tolerance = 4
        end
        for i, row in pairs(self.blocks) do
            for j, block in pairs(row) do
                block:checkCollisions(self.balls, tolerance)
                if block.health <= 0 then
                    table.remove(row, j)
                    self.numOfBlocks = self.numOfBlocks - 1
                end
            end
        end
        for i, ball in pairs(self.balls) do
            ball:update(dtf)
            if ball.y > VIRTUAL_HEIGHT then
                table.remove(self.balls, i)
            end
        end

        if #self.balls < 1 then
            self.playState = 'advance'
        end
    elseif self.playState == 'advance' then
        Timer.clear(self.ballTimer)
        for i, row in pairs(self.blocks) do
            for j, block in pairs(row) do
                block:relocate(BLOCK_SIZE)
                if block.y > VIRTUAL_HEIGHT - 30 then
                    self.gameOver = true
                end
            end
        end
        if self.gameOver then
            self.playState = 'gameOver'
        elseif self.numOfBlocks < 1 then
            self.playState = 'win'
        else
            self.playState = 'aim'
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    Timer.update(dtf, self.ballTimer)
end

function PlayState:fire()
    for i = 0, NUM_OF_BALLS, 1 do
        Timer.after(0.05 * i, function()
            if #self.balls < NUM_OF_BALLS then
                table.insert(self.balls, Ball(-self.aimDirection))
            end
        end):group(self.ballTimer)
    end
end

function PlayState:render()
    for k, ball in pairs(self.balls) do
        ball:render()
    end
    for j, row in pairs(self.blocks) do
        for k, block in pairs(row) do
            row[k]:render()
        end
    end
    if self.playState == 'aim' then
        love.graphics.line(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT, VIRTUAL_WIDTH / 2 - math.cos(self.aimDirection) * LINE_LENGTH,
                            VIRTUAL_HEIGHT - math.sin(self.aimDirection) * LINE_LENGTH)
    elseif self.playState == 'gameOver' then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    elseif self.playState == 'win' then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.printf('Win', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['small'])

    love.graphics.rectangle("line", VIRTUAL_WIDTH / 2 - (3 * BLOCK_SIZE), 0, (6 * BLOCK_SIZE), VIRTUAL_HEIGHT)
end