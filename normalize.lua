local normalize = {}
local block = require "blocks"

function normalize:init(values)
    self.blocks = {}
    local w,h = love.graphics.getDimensions()

    local width = w / #values


    local current_min = math.huge
    local current_max = -math.huge

    for _, v in ipairs(values) do
        if v < current_min then current_min = v end
        if v > current_max then current_max = v end
    end

    local range = current_max - current_min

    for i, v in ipairs(values) do
        local height
        if range == 0 then
            height = h - 20
        else
            height = ((v - current_min) / range) * (h-20)

        end
        local a = block.new()   
        a:init(v, width-2, height+20, (i - 1) * width+1, h)
        table.insert(self.blocks, a)
    end
end

return normalize