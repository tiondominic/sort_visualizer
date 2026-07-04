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

        -- blocks[n - i + 1]:sorted()
        coroutine.yield(speed)
    end

    blocks[1]:deselected()
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

        blocks[min]:deselected()
    end
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
        local positions = {}

        for k = left, right do
            positions[k - left + 1] = blocks[k].x
        end

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
            blocks[k].x = positions[k - left + 1]
            
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
end

function algos.heapSort(blocks, speed)
    local function heapify(n, i)
        local largest = i
        local left = 2 * i
        local right = 2 * i + 1

        if left <= n and blocks[left].value > blocks[largest].value then
            largest = left
        end

        if right <= n and blocks[right].value > blocks[largest].value then
            largest = right
        end

        if largest ~= i then
            blocks[i], blocks[largest] = blocks[largest], blocks[i]
            blocks[i].x, blocks[largest].x = blocks[largest].x, blocks[i].x

            blocks[i]:selected()
            blocks[largest]:selected()
            coroutine.yield(speed)
            blocks[i]:deselected()
            blocks[largest]:deselected()

            heapify(n, largest)
        end
    end

    local n = #blocks

    for i = math.floor(n / 2), 1, -1 do
        heapify(n, i)
    end

    for i = n, 2, -1 do
        blocks[1], blocks[i] = blocks[i], blocks[1]
        blocks[1].x, blocks[i].x = blocks[i].x, blocks[1].x

        blocks[1]:selected()
        blocks[i]:selected()
        coroutine.yield(speed)
        blocks[1]:deselected()
        blocks[i]:deselected()

        heapify(i - 1, 1)
    end
end

function algos.shellSort(blocks, speed)
    local n = #blocks
    local positions = {}

    for k = 1, n do
        positions[k] = blocks[k].x
    end

    local gap = math.floor(n / 2)

    while gap > 0 do
        for i = gap + 1, n do
            local tempBlock = blocks[i]
            local j = i

            while j > gap and blocks[j - gap].value > tempBlock.value do
                blocks[j] = blocks[j - gap]
                blocks[j].x = positions[j]

                blocks[j]:selected()
                coroutine.yield(speed)
                blocks[j]:deselected()

                j = j - gap
            end

            blocks[j] = tempBlock
            blocks[j].x = positions[j]

            blocks[j]:selected()
            coroutine.yield(speed)
            blocks[j]:deselected()
        end
        gap = math.floor(gap / 2)
    end
end

function algos.bogoSort(blocks, speed)
    local n = #blocks
    local positions = {}

    for k = 1, n do
        positions[k] = blocks[k].x
    end

    local function isSorted()
        for i = 1, n - 1 do
            if blocks[i].value > blocks[i + 1].value then
                return false
            end
        end
        return true
    end

    while not isSorted() do
        for i = n, 2, -1 do
            local j = math.random(i)
            
            blocks[i], blocks[j] = blocks[j], blocks[i]
            
            blocks[i].x = positions[i]
            blocks[j].x = positions[j]

            blocks[i]:selected()
            blocks[j]:selected()
        end

        coroutine.yield(speed)

        for i = 1, n do
            blocks[i]:deselected()
        end
    end
end

function algos.stalinSort(blocks, speed)
    local n = #blocks
    local positions = {}

    for k = 1, n do
        positions[k] = blocks[k].x
    end

    local i = 2
    while i <= #blocks do
        blocks[i]:selected()
        blocks[i - 1]:selected()
        coroutine.yield(speed)
        
        blocks[i]:deselected()
        blocks[i - 1]:deselected()

        if blocks[i].value < blocks[i - 1].value then
            local removedBlock = table.remove(blocks, i)
            if type(removedBlock.eliminated) == "function" then
                removedBlock:eliminated()
            end
        else
            i = i + 1
        end

        for k = 1, #blocks do
            blocks[k].x = positions[k]
        end
    end
end

function algos.bucketSort(blocks, speed)
    local n = #blocks
    if n <= 1 then return end

    local positions = {}
    for k = 1, n do
        positions[k] = blocks[k].x
    end

    -- Find the range of values
    local minVal = blocks[1].value
    local maxVal = blocks[1].value
    for i = 2, n do
        if blocks[i].value < minVal then minVal = blocks[i].value end
        if blocks[i].value > maxVal then maxVal = blocks[i].value end
    end

    -- Create empty buckets (using square root of n is a standard heuristic)
    local bucketCount = math.floor(math.sqrt(n))
    if bucketCount < 1 then bucketCount = 1 end
    local buckets = {}
    for i = 1, bucketCount do
        buckets[i] = {}
    end

    -- Distribute blocks into buckets
    local range = maxVal - minVal
    if range == 0 then range = 1 end -- Prevent division by zero if all values are identical

    for i = 1, n do
        local bucketIndex = math.floor(((blocks[i].value - minVal) / range) * (bucketCount - 1)) + 1
        table.insert(buckets[bucketIndex], blocks[i])
        
        blocks[i]:selected()
        coroutine.yield(speed)
        blocks[i]:deselected()
    end

    -- Sort individual buckets using Insertion Sort and rebuild the main array
    local index = 1
    for b = 1, bucketCount do
        local bucket = buckets[b]
        
        -- Insertion Sort on the current bucket
        for i = 2, #bucket do
            local key = bucket[i]
            local j = i - 1
            while j > 0 and bucket[j].value > key.value do
                bucket[j + 1] = bucket[j]
                j = j - 1
            end
            bucket[j + 1] = key
        end

        -- Put sorted bucket elements back into the main blocks table
        for i = 1, #bucket do
            blocks[index] = bucket[i]
            blocks[index].x = positions[index]
            
            blocks[index]:selected()
            coroutine.yield(speed)
            blocks[index]:deselected()
            
            index = index + 1
        end
    end
end
return algos