local block = {}

function block.new()
    local instance = setmetatable({}, block) 
    block.__index = block
    return instance
end

function block:init(value, width, height, x, y, color)
    self.value = value
    self.width = width
    self.height = height
    self.x = x
    self.y = y
    self.color = color or {0.5,0.5,0.5}
    self.prev_color = nil
end

function block:update(dt)

end

function block:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, -self.height)
    love.graphics.setColor(1,1,1)
end

function block:selected()
    self.prev_color = self.color
    self.color = {1,0,0}
end 

function block:deselected()
    self.color = self.prev_color
end

function block:sorted()
    self.color = {0,1,0}
end

return block