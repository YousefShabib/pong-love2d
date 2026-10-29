function love.load()
    WINDOW_WIDTH = 800
    WINDOW_HEIGHT = 600
    PADDLE_WIDTH = 15
    PADDLE_HEIGHT = 120

    -- Left paddle
    player1 = {
        x = 50,
        y = 240,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = 300
    }

    -- Right paddle
    player2 = {
        x = 800 - 50 - PADDLE_WIDTH,
        y = 250,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = 300
    }

    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
end

function love.draw()
    -- Draw the dashed line at the center
    love.graphics.setColor(1, 1, 1)
    for i = 0, 600, 30 do
        love.graphics.rectangle("fill", 398, i, 4, 15)
    end

    -- Draw left paddle
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", player1.x, player1.y, player1.width, player1.height)

    -- Draw right paddle
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", player2.x, player2.y, player2.width, player2.height)


end

function love.update(dt)
    -- Move paddles (speed is in pixels per second)
    if love.keyboard.isDown("w") then
        player1.y = player1.y - player1.speed * dt
    elseif love.keyboard.isDown("s") then
        player1.y = player1.y + player1.speed * dt
    end

    if love.keyboard.isDown("up") then
        player2.y = player2.y - player2.speed * dt
    elseif love.keyboard.isDown("down") then
        player2.y = player2.y + player2.speed * dt
    end

    -- Keep paddles inside the window
    player1.y = math.max(0, math.min(WINDOW_HEIGHT - player1.height, player1.y))
    player2.y = math.max(0, math.min(WINDOW_HEIGHT - player2.height, player2.y))

end
