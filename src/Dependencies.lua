Class = require 'library/class'
push = require 'library/push'
Timer = require 'library/knife.timer'
Event = require 'library/knife.event'

require 'src/Ball'
require 'src/Block'
require 'src/constants'
require 'src/PlayState'

gFonts = {
    ['large'] = love.graphics.newFont('font.ttf', 32),
    ['medium'] = love.graphics.newFont('font.ttf', 16),
    ['small'] = love.graphics.newFont('font.ttf', 8)
}