local normalize = require "normalize"
local sorting = require "sorting_algos"
local delay = 0
local speed = 0.0

local bubbleSortBlocks
local sortThread

local function shuffleTable(t)
    local n = #t
    local positions = {}

    for k = 1, n do
        positions[k] = t[k].x
    end

    for i = n, 2, -1 do
        local j = love.math.random(i)
        t[i], t[j] = t[j], t[i]
    end

    for k = 1, n do
        t[k].x = positions[k]
    end
end

function love.load()
    love.math.setRandomSeed(os.time())
    local n = 2000

    local nums = {}
    for i=1, n, 1 do
        table.insert(nums, i)
    end

    normalize:init(nums)
    shuffleTable(normalize.blocks)
    

    sortThread = coroutine.create(function()
        sorting.bucketSort(normalize.blocks, speed)
    end)
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
