love = require("love")

function love.load()
    currentPlayer = 'X'
    winner = ''
    boardSize = 900
    cellSize = boardSize / 3
    cellsPlayed = 0
    soundPlayed = false

    board = {
        { '', '', '' },
        { '', '', '' },
        { '', '', '' },
    }

    clickSound = love.audio.newSource('assets/ball_tap.wav', 'static')
    winnerSound = love.audio.newSource('assets/winner.wav', 'static')
    drawSound = love.audio.newSource('assets/draw.wav', 'static')

    love.graphics.setBackgroundColor(153 / 255, 236 / 255, 247 / 255)
    love.window.setMode(boardSize, boardSize)
end

function love.mousepressed(x, y, button, _, _)
    if button == 1 and winner == '' then
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

            love.audio.play(clickSound)
            cellsPlayed = cellsPlayed + 1
        end
    end
end

function love.update()
    if cellsPlayed > 4 and cellsPlayed < 9 then
        if board[1][1] == board[2][2] and board[2][2] == board[3][3] then
            winner = board[1][1]
        elseif board[1][3] == board[2][2] and board[2][2] == board[3][1] then
            winner = board[1][3]
        else
            for i = 1, #board do
                if board[i][1] == board[i][2] and board[i][2] == board[i][3] then
                    winner = board[i][1]
                    break
                elseif board[1][i] == board[2][i] and board[2][i] == board[3][i] then
                    winner = board[1][i]
                    break
                end
            end
        end

        if winner ~= '' and not soundPlayed then
            love.audio.play(winnerSound)
            soundPlayed = true
        elseif cellsPlayed == 9 and not soundPlayed then
            love.audio.play(drawSound)
            soundPlayed = true
        end
    end
end

function love.draw()
    local baseX = 58
    local baseO = 145

    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(7)

    for i = 1, 2 do
        love.graphics.line(i * cellSize, 0, i * cellSize, boardSize)
        love.graphics.line(0, i * cellSize, boardSize, i * cellSize)
    end

    local offset = cellSize + (cellSize / 100)
    for i, row in ipairs(board) do
        for j, val in ipairs(row) do
            if val == 'X' then
                X(baseX + (offset * (j - 1)), baseX + (offset * (i - 1)))
            elseif val == 'O' then
                O(baseO + (offset * (j - 1)), baseO + (offset * (i - 1)))
            end
        end
    end
end

-- draw X
function X(x, y)
    local offset = 170

    love.graphics.setColor(200 / 255, 21 / 255, 30 / 255)
    love.graphics.setLineWidth(37)

    love.graphics.line(x, y, x + offset, y + offset)
    love.graphics.line(x + offset, y, x, y + offset)
end

-- draw O
function O(x, y)
    love.graphics.setColor(15 / 255, 79 / 255, 242 / 255)
    love.graphics.setLineWidth(37)

    love.graphics.circle('line', x, y, 90)
end
