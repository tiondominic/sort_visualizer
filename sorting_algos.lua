local algos = {}

function algos.bubbleSort(blocks, speed)
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
        coroutine.yield(speed)
    end

    blocks[1]:sorted()
end

function algos.selectionSort(blocks, speed)
    local n = #blocks

    for i = 1, n - 1 do
        local min = i
        blocks[min]:selected()

        for j = i + 1, n do
            blocks[j]:selected()
            coroutine.yield(speed)

            if blocks[j].value < blocks[min].value then
                blocks[min]:deselected()
                min = j
                blocks[min]:selected()
            else
                blocks[j]:deselected()
            end
        end

        if min ~= i then
            blocks[i].x, blocks[min].x = blocks[min].x, blocks[i].x
            blocks[i], blocks[min] = blocks[min], blocks[i]
            coroutine.yield(speed)
        end

        blocks[i]:sorted()
        blocks[min]:deselected()
    end

    blocks[n]:sorted()
end

function algos.insertionSort(blocks, speed)
    local n = #blocks

    for i = 2, n do
        local j = i

        while j > 1 and blocks[j - 1].value > blocks[j].value do
            blocks[j]:selected()
            blocks[j - 1]:selected()

            coroutine.yield(speed)

            blocks[j].x, blocks[j - 1].x = blocks[j - 1].x, blocks[j].x
            blocks[j], blocks[j - 1] = blocks[j - 1], blocks[j]

            coroutine.yield(speed)

            blocks[j]:deselected()
            blocks[j - 1]:deselected()

            j = j - 1
        end
    end

    for _, block in ipairs(blocks) do
        block:sorted()
        coroutine.yield(speed)
    end
end

function algos.mergeSort(blocks, speed)

    local function merge(left, mid, right)
        local temp = {}

        local i = left
        local j = mid + 1

        while i <= mid and j <= right do
            if blocks[i].value <= blocks[j].value then
                table.insert(temp, blocks[i])
                i = i + 1
            else
                table.insert(temp, blocks[j])
                j = j + 1
            end
            -- blocks[i].x, blocks[j].x = blocks[j].x, blocks[i].x
        end

        while i <= mid do
            table.insert(temp, blocks[i])
            i = i + 1
        end

        while j <= right do
            table.insert(temp, blocks[j])
            j = j + 1
        end

        for k = left, right do
            blocks[k] = temp[k - left + 1]

            blocks[k]:selected()
            coroutine.yield(speed)
            blocks[k]:deselected()
        end
    end

    local function sort(left, right)
        if left >= right then
            return
        end

        local mid = math.floor((left + right) / 2)

        sort(left, mid)
        sort(mid + 1, right)
        merge(left, mid, right)
    end

    sort(1, #blocks)

    for _, block in ipairs(blocks) do
        block:sorted()
    end
end

function algos.quickSort(blocks, speed)

    local function partition(low, high)
        local pivot = blocks[high]

        pivot:selected()

        local i = low - 1

        for j = low, high - 1 do
            blocks[j]:selected()
            coroutine.yield(speed)

            if blocks[j].value < pivot.value then
                i = i + 1

                blocks[i].x, blocks[j].x = blocks[j].x, blocks[i].x
                blocks[i], blocks[j] = blocks[j], blocks[i]

                coroutine.yield(speed)
            end

            blocks[j]:deselected()
        end

        blocks[i + 1].x, blocks[high].x = blocks[high].x, blocks[i + 1].x
        blocks[i + 1], blocks[high] = blocks[high], blocks[i + 1]

        coroutine.yield(speed)

        pivot:deselected()

        return i + 1
    end

    local function quick(low, high)
        if low < high then
            local p = partition(low, high)
            quick(low, p - 1)
            quick(p + 1, high)
        end
    end

    quick(1, #blocks)

    for _, block in ipairs(blocks) do
        block:sorted()
    end
end

function algos.cocktailSort(blocks, speed)
    local start = 1
    local finish = #blocks
    local swapped = true

    while swapped do
        swapped = false

        for i = start, finish - 1 do
            local a = blocks[i]
            local b = blocks[i + 1]

            a:selected()
            b:selected()
            coroutine.yield(speed)

            if a.value > b.value then
                a.x, b.x = b.x, a.x
                blocks[i], blocks[i + 1] = b, a
                swapped = true
                coroutine.yield(speed)
            end

            a:deselected()
            b:deselected()
        end

        if not swapped then break end

        finish = finish - 1
        swapped = false

        for i = finish, start + 1, -1 do
            local a = blocks[i - 1]
            local b = blocks[i]

            a:selected()
            b:selected()
            coroutine.yield(speed)

            if a.value > b.value then
                a.x, b.x = b.x, a.x
                blocks[i - 1], blocks[i] = b, a
                swapped = true
                coroutine.yield(speed)
            end

            a:deselected()
            b:deselected()
        end

        start = start + 1
    end

    for _, b in ipairs(blocks) do
        b:sorted()
    end
end

return algos