return {
    colors = {
        red = { 227, 43 / 255, 43 / 255 },
        blue = { 43 / 255, 164 / 255, 227 / 255 },
        darkBlue = { 33 / 255, 50 / 255, 92 / 255 }
    },
    fonts = {
        squirk = love.graphics.newFont('assets/fonts/Squirk-RMvV.ttf', 270),
        latoBold = love.graphics.newFont('assets/fonts/Lato-Bold.ttf', 30)
    },
    sounds = {
        playSound = love.audio.newSource('assets/sound/ball_tap.wav', 'static'),
        winnerSound = love.audio.newSource('assets/sound/winner.wav', 'static'),
        tieSound = love.audio.newSource('assets/sound/draw.wav', 'static')
    },

    colorRGB = function (r, g, b)
        return r / 255, g / 255, b / 255
    end
}
