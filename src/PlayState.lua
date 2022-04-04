PlayState = Class{}

function PlayState:init()
    self.balls = {}
    self.numOfBalls = NUM_OF_BALLS
    self.blocks = {}
    for i = 1, ROWS, 1 do
        self.blocks[i] = {}
        for j = 1, COLS, 1 do
            --if math.random(2) == 1 then
                self.blocks[i][j] = Block(START_ROWS + (i - 1) * BLOCK_SIZE, START_COLS + (i - 1) * BLOCK_SIZE)
            --end
        end
    end
    self.playState = 'aim'
    self.aimDirection = math.pi / 2
    self.shootTimer = nil
end

function PlayState:update(dt)
    if self.playState == 'aim' then
        if love.keyboard.isDown('left') then
            self.aimDirection = math.max(self.aimDirection - AIM_DIR_RATE_OF_CHANGE * dt, MIN_AIM)
        elseif love.keyboard.isDown('right') then
            self.aimDirection = math.min(self.aimDirection + AIM_DIR_RATE_OF_CHANGE * dt, MAX_AIM)
        end

        if love.keyboard.wasPressed('space') then
            self.fire()
            self.playState = 'firing'
        end
    elseif self.playState == 'firing' then
        Timer.update(dt, self.shootTimer)
        --check collisions
        for i, row in pairs(self.blocks) do
            for j, block in pairs(row) do
                block:checkCollisions(self.balls)
            end
        end

        if #self.balls == 0 then
            self.playState = 'advance'
        end
    elseif self.playState == 'advance' then
        for i, row in pairs(self.blocks) do
            for j, block in pairs(row) do
                block:relocate(BLOCK_SIZE)
            end
        end
        for k, ball in pairs(self.balls) do
            if ball.y > VIRTUAL_HEIGHT then
                table.remove(self.balls, k)
            end
        end
        self.playState = 'aim'
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:fire()
    local count = 1
    Timer.after(0.05, function()
        if count > NUM_OF_BALLS then
            Timer.clear(self.shootTimer)
        else
            table.insert(self.balls, Ball(self.aimDirection))
            count = count + 1
        end
    end)
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
        love.graphics.line(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT, VIRTUAL_WIDTH / 2 - math.cos(self.aimDirection) * LINE_LENGTH, VIRTUAL_HEIGHT - math.sin(self.aimDirection) * LINE_LENGTH)
    end
end