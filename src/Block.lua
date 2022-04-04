Block = Class{}

function Block:init(x, y)
    self.x = x
    self.y = y
    self.size = BLOCK_SIZE
    self.health = math.random(BLOCK_MIN_HEALTH, BLOCK_MAX_HEALTH)
end

function Block:update(dt)
end

function Block:relocate(dy)
    self.y = self.y + dy
end

function Block:hit()
    self.health = self.health - 1
end

function Block:checkCollisions(balls)
    for i, ball in pairs(balls) do
        if self:collides(ball) then
            self:hit()
            local x = self.x - ball.x
            local y = self.y - ball.y
            if math.abs(x) - ball.size < 1 then
                ball.x = self.x - ball.size
                ball:collides(4)
            elseif math.abs(x) - self.size < 1 then
                ball.x = self.x + self.size
                ball:collides(2)
            elseif math.abs(y) - ball.size < 1 then
                ball.y = self.y - ball.size
                ball:collides(1)
            else
                ball.y = self.y + self.size
                ball:collides(3)
            end
        end
    end
end

function Block:collides(obj)
    if self.x > obj.x + obj.size or self.x + self.size < obj.x then
        return false
    elseif self.y > obj.y + obj.size or self.y + self.size < obj.y then
        return false
    else
        return true
    end
end

function Block:render()
    love.graphics.rectangle('line', self.x, self.y, self.size, self.size)
    love.graphics.print(tostring(self.health), self.x + 5, self.y + 5)
end