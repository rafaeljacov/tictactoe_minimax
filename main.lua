local tictactoe = require('tictactoe')
local ai = require('minimax')

function love.load()
    MAX = 'X'
    MIN = 'O'
    currentPlayer = MAX
    winner = ''
    boardSize = 900
    cellSize = boardSize / 3
    cellsPlayed = 0
    gameOver = false
    crossLine = {
        start = { x = 0, y = 0 },
        finish = { x = 0, y = 0 },
        progress = 0,
        speed = 1.7,
    }

    board = {
        { '', '', '' },
        { '', '', '' },
        { '', '', '' },
    }

    playSound = love.audio.newSource('assets/ball_tap.wav', 'static')
    winnerSound = love.audio.newSource('assets/winner.wav', 'static')
    tieSound = love.audio.newSource('assets/draw.wav', 'static')

    love.graphics.setBackgroundColor(153 / 255, 236 / 255, 247 / 255)
    love.window.setMode(boardSize, boardSize)
end

function love.mousepressed(x, y, button, _, _)
    if button == 1 and currentPlayer == MAX and winner == '' then
        -- Calculate the row and column clicked
        local row = math.floor(y / cellSize) + 1
        local col = math.floor(x / cellSize) + 1

        -- Check if the cell is empty
        if board[row][col] == '' then
            -- Place the current player's marker
            board[row][col] = currentPlayer

            if currentPlayer == 'X' then
                currentPlayer = 'O'
            else
                currentPlayer = 'X'
            end

            love.audio.play(playSound)
            cellsPlayed = cellsPlayed + 1
        end
    elseif currentPlayer == MIN then
        ai.minimax(board, MIN)
    end
end

function love.update(dt)
    if currentPlayer == MIN and winner == '' and cellsPlayed < 9 then
        local move = ai.minimax(board, MIN, 0)
        board[move.row][move.col] = MIN
        currentPlayer = MAX
        cellsPlayed = cellsPlayed + 1
    end

    if cellsPlayed > 4 and not gameOver then
        local offset = 27
        local base = (cellSize / 2) - 4
        if board[1][1] ~= '' and board[1][1] == board[2][2] and board[2][2] == board[3][3] then
            winner = board[1][1]
            crossLine.start.x = offset
            crossLine.start.y = offset
            crossLine.finish.x = boardSize - offset
            crossLine.finish.y = boardSize - offset
        elseif board[1][3] ~= '' and board[1][3] == board[2][2] and board[2][2] == board[3][1] then
            winner = board[1][3]
            crossLine.start.x = boardSize - offset
            crossLine.start.y = offset
            crossLine.finish.x = offset
            crossLine.finish.y = boardSize - offset
        else
            for i = 1, #board do
                if board[i][1] ~= '' and board[i][1] == board[i][2] and board[i][2] == board[i][3] then
                    winner = board[i][1]
                    crossLine.start.x = offset
                    crossLine.start.y = base + (i - 1) * cellSize
                    crossLine.finish.x = boardSize - offset
                    crossLine.finish.y = base + (i - 1) * cellSize
                    break
                elseif board[1][i] ~= '' and board[1][i] == board[2][i] and board[2][i] == board[3][i] then
                    winner = board[1][i]
                    crossLine.start.x = base + (i - 1) * cellSize
                    crossLine.start.y = offset
                    crossLine.finish.x = base + (i - 1) * cellSize
                    crossLine.finish.y = boardSize - offset
                    break
                end
            end
        end

        if winner ~= '' then
            love.audio.play(winnerSound)
            gameOver = true
        elseif cellsPlayed == 9 then
            love.audio.play(tieSound)
            gameOver = true
        end
    elseif gameOver then
        crossLine.progress = crossLine.progress + crossLine.speed * dt
        if crossLine.progress > 1 then
            crossLine.progress = 1
        end
    end
end

function love.draw()
    local baseX = 67
    local baseO = 145

    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(7)

    -- Dividers
    for i = 1, 2 do
        love.graphics.line(i * cellSize, 0, i * cellSize, boardSize)
        love.graphics.line(0, i * cellSize, boardSize, i * cellSize)
    end

    local offset = cellSize + (cellSize / 100)
    for i, row in ipairs(board) do
        for j, cell in ipairs(row) do
            if cell == 'X' then
                tictactoe.X(baseX + (offset * (j - 1)), baseX + (offset * (i - 1)))
            elseif cell == 'O' then
                tictactoe.O(baseO + (offset * (j - 1)), baseO + (offset * (i - 1)))
            end
        end
    end

    if gameOver then
        tictactoe.crossWin(crossLine.start, crossLine.finish)
    end
end
