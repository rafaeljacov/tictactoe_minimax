return {
    colors = {
        red = { 222 / 255, 43 / 255, 43 / 255 },
        blue = { 43 / 255, 164 / 255, 227 / 255 },
        darkBlue = { 33 / 255, 50 / 255, 92 / 255 },
        black = { 10 / 255, 15 / 255, 28 / 255 }
    },
    fonts = {
        squirk_xl = love.graphics.newFont('assets/fonts/Squirk-RMvV.ttf', 270),
        squirk_l = love.graphics.newFont('assets/fonts/Squirk-RMvV.ttf', 160),
        maldini_bold = love.graphics.newFont('assets/fonts/MaldiniBold-OVZO6.ttf', 60),
        maldini_regular = love.graphics.newFont('assets/fonts/MaldiniNormal-ZVKG3.ttf', 60)
    },
    sounds = {
        play = love.audio.newSource('assets/sound/ball_tap.wav', 'static'),
        win = love.audio.newSource('assets/sound/winner.wav', 'static'),
        tie = love.audio.newSource('assets/sound/draw.wav', 'static'),
        click = love.audio.newSource('assets/sound/click.wav', 'static')
    },

    colorRGB = function(r, g, b)
        return r / 255, g / 255, b / 255
    end
}
