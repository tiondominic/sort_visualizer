local normalize = require "normalize"
local sorting = require "sorting_algos"
local delay = 0
local speed = 0.01

local bubbleSortBlocks
local sortThread

function love.load()
    love.math.getRandomSeed()
    local n = 100
    local nums = {}
    for i=0, n, 1 do
        local a = love.math.random(0, 1000)
        table.insert(nums, a)
    end

    normalize:init(nums)

    sortThread = coroutine.create(function()
        sorting.mergeSort(normalize.blocks, speed)
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
