local normalize = require "normalize"

local bubbleSortBlocks
local sortThread
local delay = 0
local speed = 0.1

bubbleSortBlocks = function()
    local blocks = normalize.blocks
    local n = #blocks

    for i = 1, n - 1 do
        for j = 1, n - i do
            local a = blocks[j]
            local b = blocks[j + 1]

            a:selected()
            b:selected()

            coroutine.yield(speed)

            if a.value > b.value then
                a.x, b.x = b.x, a.x
                blocks[j], blocks[j + 1] = b, a

                coroutine.yield(speed)
            end

            a:deselected()
            b:deselected()
        end

        blocks[n - i + 1]:sorted()
        coroutine.yield(0.2)
    end

    blocks[1]:sorted()
end

function love.load()
    local nums = {99,99,99,99,7,91,18,63,5,77,29,84,13,56,99,34,71,2,88,47,20,65,11}
    normalize:init(nums)

    sortThread = coroutine.create(bubbleSortBlocks)
end

function love.update(dt)
    if coroutine.status(sortThread) ~= "dead" then
        delay = delay - dt

        if delay <= 0 then
            local ok, waitTime = coroutine.resume(sortThread)
            if ok then
                delay = waitTime or 0
            end
        end
    end
end

function love.draw()
    for _, i in ipairs(normalize.blocks) do
        i:draw()
    end
end
