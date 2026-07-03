local block = {}

function block.new()
    local instance = setmetatable({}, block) 
    block.__index = block
    return instance
end

function block:init(value, width, height, x, y)
    self.value = value
    self.width = width
    self.height = height
    self.x = x
    self.y = y
    self.color = {0.5,0.5,0.5}
end

function block:update(dt)

end

function block:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, -self.height)
    love.graphics.setColor(1,1,1)
end

function block:selected()
    self.color = {1,0,0}
end 

function block:deselected()
    self.color = {0.5,0.5,0.5}
end

function block:sorted()
    self.color = {0,1,0}
end

return block