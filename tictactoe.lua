local tictactoe = {}

-- draw X
function tictactoe.X(x, y)
    local offset = 160

    love.graphics.setColor(200 / 255, 21 / 255, 30 / 255)
    love.graphics.setLineWidth(37)

    love.graphics.line(x, y, x + offset, y + offset)
    love.graphics.line(x + offset, y, x, y + offset)
end

-- draw O
function tictactoe.O(x, y)
    love.graphics.setColor(15 / 255, 79 / 255, 242 / 255)
    love.graphics.setLineWidth(37)

    love.graphics.circle('line', x, y, 80)
end

function tictactoe.crossWin(start, finish)
    love.graphics.setLineWidth(20)
    love.graphics.setColor(34 / 255, 43 / 255, 54 / 255)

    local currentX = start.x + (finish.x - start.x) * crossLine.progress
    local currentY = start.y + (finish.y - start.y) * crossLine.progress

    love.graphics.line(start.x, start.y, currentX, currentY)
end

return tictactoe
