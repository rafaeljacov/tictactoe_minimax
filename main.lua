local utils = require('utils')
local colors = utils.colors
local fonts = utils.fonts
local sounds = utils.sounds

local tictactoe = require('tictactoe')
local ai = require('minimax')
local Button = require('button')
local players = tictactoe.players

local buttons = {
    menu = {},
    inGame = {},
}

local game = {}

function love.load()
    game.timers = {
        restart = 0,
        aiPlay = 0
    }
    game.state = {
        menu = true,
        playing = false,
    }
    game.enemyIsAi = true

    buttons.menu.vsPlayer = Button('vs Player', colors.black, fonts.maldini_bold_m, 300, 110, 7, colors.blue)
    buttons.menu.vsAI = Button('vs Bot', colors.black, fonts.maldini_bold_m, 300, 110, 7, colors.red)
    buttons.menu.quit = Button('Quit', colors.white, fonts.maldini_bold_m, 300, 90, 7, colors.darkBlue)
    buttons.inGame.returnTitle = Button('Return to Screen Title', colors.black, fonts.maldini_bold_m, 620, 90, 7, colors.red)

    winner = ''
    cellsPlayed = 0
    round = 1
    MAX = players.MAX
    MIN = players.MIN
    currentPlayer = 'X'
    boardSize = 900
    cellSize = boardSize / 3
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

    love.graphics.setBackgroundColor(utils.colorRGB(220, 244, 250))
    love.window.setMode(boardSize + 700, boardSize)
end

function love.mousepressed(x, y, button, _, _)
    if game.state.menu and button == 1 then
        buttons.menu.vsPlayer:onclick(function()
            game.enemyIsAi = false
            game.state.menu = false
            game.state.playing = true
        end, x, y)
        buttons.menu.vsAI:onclick(function()
            game.enemyIsAi = true
            game.state.menu = false
            game.state.playing = true
        end, x, y)
        buttons.menu.quit:onclick(love.event.quit, x, y)
    elseif (game.state.playing and button == 1 and winner == '') and
        (not game.enemyIsAi or currentPlayer == 'X') then
        -- Calculate the row and column clicked
        local row = math.floor(y / cellSize) + 1
        local col = math.floor(x / cellSize) + 1

        -- Check if the cell is empty
        if board[row][col] == '' then
            -- Place the current player's marker
            board[row][col] = currentPlayer

            if currentPlayer == 'X' then
                currentPlayer = 'O'
            elseif not game.enemyIsAi then
                currentPlayer = 'X'
            end

            love.audio.play(sounds.play)
            cellsPlayed = cellsPlayed + 1
        end

        buttons.inGame.returnTitle:onclick(function ()
            game.state.menu = true
            game.state.playing = false

            round = 1
            currentPlayer = 'X'
        end, x, y)
    end
end

function love.update(dt)
    if game.state.playing then
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
                love.audio.play(sounds.win)
                gameOver = true
            elseif cellsPlayed == 9 then
                love.audio.play(sounds.tie)
                gameOver = true
            end
        elseif gameOver then
            crossLine.progress = crossLine.progress + crossLine.speed * dt
            if crossLine.progress > 1 then
                crossLine.progress = 1
            end
            restartGame(dt)
        end

        -- AI Playing
        if game.enemyIsAi and currentPlayer == MIN and winner == '' and cellsPlayed < 9 then
            game.timers.aiPlay = game.timers.aiPlay + dt

            if game.timers.aiPlay > 0.75 then
                local move = ai.minimax(board, MIN, 0)
                board[move.row][move.col] = MIN
                love.audio.play(sounds.play)
                currentPlayer = MAX
                cellsPlayed = cellsPlayed + 1
                game.timers.aiPlay = 0
            end
        end
    end
end

function love.draw()
    if game.state.menu then
        showMenu()
    elseif game.state.playing then
        playGame()
    end
end

function showMenu()
    buttons.menu.vsPlayer:draw(940, 370, 40, 32)
    buttons.menu.vsAI:draw(940, 510, 70, 32)
    buttons.menu.quit:draw(940, 660, 101, 21)

    -- Reset colors
    love.graphics.setColor(1, 1, 1)

    local titleX = 170
    love.graphics.print({ colors.blue, 'TIC' }, fonts.squirk_xl, titleX + 14, 70)
    love.graphics.print({ colors.darkBlue, 'TAC' }, fonts.squirk_xl, titleX, 300)
    love.graphics.print({ colors.red, 'TOE' }, fonts.squirk_xl, titleX, 530)

    love.graphics.print({ colors.darkBlue, 'Play !' }, fonts.squirk_l, titleX + 727, 120)
end

function playGame()
    local baseX = 67
    local baseO = 145

    r, g, b = colors.darkBlue[1], colors.darkBlue[2], colors.darkBlue[3]
    love.graphics.setColor(r, g, b)
    love.graphics.setLineWidth(7)

    -- Dividers
    for i = 0, 3 do
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
    displayGameStats()
end

function displayGameStats()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print({ colors.darkBlue, 'Round' }, fonts.squirk_m, 930, 20)
    love.graphics.print({ colors.darkBlue, round }, fonts.maldini_bold_l, 1175, 28)

    buttons.inGame.returnTitle:draw(942, 780, 50, 22)
end

function restartGame(dt)
    game.timers.restart = game.timers.restart + dt
    if game.timers.restart > 2 then
        winner = ''
        cellsPlayed = 0
        round = round + 1
        gameOver = false
        crossLine.start.x = 0
        crossLine.start.y = 0
        crossLine.finish.x = 0
        crossLine.finish.y = 0
        crossLine.progress = 0

        for _, row in ipairs(board) do
            for j = 1, 3 do
                row[j] = ''
            end
        end
        game.timers.restart = 0
    end
end
