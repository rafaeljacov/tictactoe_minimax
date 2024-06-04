---@diagnostic disable: cast-local-type
ai = {}

function ai.moves(board)
    local moves = {}
    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == '' then
                table.insert(moves, { row = i, col = j })
            end
        end
    end
    return moves
end

function ai.simulateMove(board, move, player)
    local newBoard = {
        { '', '', '' },
        { '', '', '' },
        { '', '', '' },
    }

    -- Copy Board
    for i = 1, 3 do
        for j = 1, 3 do
            newBoard[i][j] = board[i][j]
        end
    end

    -- Play the current player's move
    newBoard[move.row][move.col] = player

    return newBoard
end

function ai.boardState(board)
    function getValue(row, col)
        if board[row][col] == MAX then
            return 1
        elseif board[row][col] == MIN then
            return -1
        end
    end

    local state = {}
    -- Check if there's a winner
    if board[1][1] ~= '' and board[1][1] == board[2][2] and board[2][2] == board[3][3] then
        state.value = getValue(1, 1)
        state.isTerminal = true
    elseif board[1][3] ~= '' and board[1][3] == board[2][2] and board[2][2] == board[3][1] then
        state.value = getValue(1, 3)
        state.isTerminal = true
    else
        for i = 1, #board do
            if board[i][1] ~= '' and board[i][1] == board[i][2] and board[i][2] == board[i][3] then
                state.value = getValue(i, 1)
                state.isTerminal = true
                return state
            elseif board[1][i] ~= '' and board[1][i] == board[2][i] and board[2][i] == board[3][i] then
                state.value = getValue(1, i)
                state.isTerminal = true
                return state
            end
        end
    end

    local filledCellsCount = 0
    for _, row in ipairs(board) do
        for _, cell in ipairs(row) do
            if cell ~= '' then
                filledCellsCount = filledCellsCount + 1
            end
        end
    end

    -- check if tie
    if filledCellsCount == 9 then
        state.value = 0
        state.isTerminal = true
    else
        state.isTerminal = false
    end

    return state
end

function ai.minimax(board, player, depth)
    local state = ai.boardState(board)
    local bestMove = nil

    if state.isTerminal then
        return state.value
    end

    if player == MAX then
        local value = -math.huge

        for _, move in ipairs(ai.moves(board)) do
            local nextVal = ai.minimax(ai.simulateMove(board, move, MAX), MIN, depth + 1)
            if nextVal > value then
                value = nextVal
                bestMove = move
            end
        end

        if depth > 0 then
            return value
        else
            return bestMove
        end
    elseif player == MIN then
        local value = math.huge

        for _, move in ipairs(ai.moves(board)) do
            local nextVal = ai.minimax(ai.simulateMove(board, move, MIN), MAX, depth + 1)
            if nextVal < value then
                value = nextVal
                bestMove = move
            end
        end

        if depth > 0 then
            return value
        else
            return bestMove
        end
    end
end

return ai
