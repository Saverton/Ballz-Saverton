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

function Block:checkCollisions(balls, tolerance)
    for i, ball in pairs(balls) do
        if self:collides(ball) then
            self:hit()
            local x = self.x - ball.x
            local y = self.y - ball.y
            local distTop = math.abs(ball.y + ball.size - self.y)
            local distBot = math.abs(self.y + self.size - ball.y)
            local distL = math.abs(ball.x + ball.size - self.x)
            local distR = math.abs(self.x + self.size - ball.x)
            local minDist = math.min(distTop, distBot, distL, distR)
            if minDist == distTop then
                ball.y = self.y - ball.size
                ball:collides(1)
            elseif minDist == distR then
                ball.x = self.x + self.size
                ball:collides(2)
            elseif minDist == distBot then
                ball.y = self.y + self.size
                ball:collides(3)
            else
                ball.x = self.x - ball.size
                ball:collides(4)
            end

            if self.health == 0 then
                return
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
    love.graphics.print(tostring(self.health), self.x + 9, self.y + 12)
end