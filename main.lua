--[[
    Ballz remade in lua

    @author Saverton
]]

require ('src/Dependencies')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Stupid Ballz Game')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.graphics.setFont(gFonts['medium'])
    
    love.keyboard.keysPressed = {}
    MouseInput = {}

    state = PlayState()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    state:update(dt)

    love.keyboard.keysPressed = {}
    MouseInput = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.mousepressed(x, y, button)
    MouseInput = {
    mx, my = push:toGame(x, y),
    b = button or 0
}
end

function love.draw()
    push:apply('start')
    love.graphics.setColor(1, 1, 1, 1)

    state:render()

    push:apply('end')
end