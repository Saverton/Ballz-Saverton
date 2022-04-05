Ball = Class{}

function Ball:init(dir)
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT
    self.size = BALL_SIZE
    self.dx = BALL_SPEED * math.cos(math.pi - dir)
    self.dy = BALL_SPEED * math.sin(math.pi - dir)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if VIRTUAL_WIDTH / 2 - 3 * BLOCK_SIZE > self.x then
        self.x = VIRTUAL_WIDTH / 2 - 3 * BLOCK_SIZE
        self:collides(2)
    elseif self.x + self.size > VIRTUAL_WIDTH / 2 + 3 * BLOCK_SIZE then
        self.x = VIRTUAL_WIDTH / 2 + 3 * BLOCK_SIZE - self.size
        self:collides(4)
    elseif self.y < 1 then
        self.y = 1
        self:collides(3)
    end
end 

function Ball:collides(dir)
    if dir == 1 or dir == 3 then
        self.dy = -self.dy
    elseif dir == 2 or dir == 4 then
        self.dx = -self.dx
    end
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end