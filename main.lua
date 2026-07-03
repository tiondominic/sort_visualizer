local board = require "board"
local Board = board

function love.load()
    Board:init()
    

end

function love.update(dt)
    Board:update(dt)

end

function love.draw()
    Board:draw()
end

