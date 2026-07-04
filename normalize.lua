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

    -- Helper function to convert HSL to RGB (all values 0 to 1)
    local function hslToRgb(h, s, l)
        if s == 0 then return l, l, l end
        local function toRgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        return toRgb(p, q, h + 1/3), toRgb(p, q, h), toRgb(p, q, h - 1/3)
    end

    local total_blocks = #values
    for i, v in ipairs(values) do
        local height
        if range == 0 then
            height = h - 20
        else
            height = ((v - current_min) / range) * (h-20)
        end

        -- Calculate hue based on position (0.0 to 1.0)
        local hue = (i - 1) / (total_blocks == 1 and 1 or (total_blocks - 1))
        
        -- Generate color table {r, g, b} with 100% saturation and 50% lightness
        local r, g, b = hslToRgb(hue, 1, 0.5)
        local color = {r, g, b}

        local a = block.new()   
        a:init(v, width-2, height+20, (i - 1) * width+1, h, color)
        table.insert(self.blocks, a)
    end
end

return normalize