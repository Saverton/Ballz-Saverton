Ball = Class{}

function Ball:init(dir)
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT
    self.size = BALL_SIZE
    self.dx = BALL_SPEED * math.cos(dir)
    self.dy = BALL_SPEED * math.sin(dir)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if math.abs(VIRTUAL_WIDTH / 2 - (self.x + self.size / 2)) > 90 then
        self:collides(2)
    elseif self.y < 0 then
        self:collides(1)
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