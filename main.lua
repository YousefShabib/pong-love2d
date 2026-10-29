function love.load()
    WINDOW_WIDTH = 800
    WINDOW_HEIGHT = 600
    PADDLE_WIDTH = 15
    PADDLE_HEIGHT = 120
    BALL_SIZE = 14

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

    -- Ball
    ball = {
        x = 400 - BALL_SIZE / 2,
        y = 300 - BALL_SIZE / 2,
        size = BALL_SIZE,
        dx = 300,
        dy = 180
    }

    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
end

function love.draw()
    -- Draw the dashed line at the center
    love.graphics.setColor(1, 1, 1)
    for i = 0, 600, 30 do
        love.graphics.rectangle("fill", 398, i, 4, 15)
    end

    -- Draw left paddle (my change: blue)
    love.graphics.setColor(0.3, 0.7, 1)
    love.graphics.rectangle("fill", player1.x, player1.y, player1.width, player1.height)

    -- Draw right paddle (my change: orange)
    love.graphics.setColor(1, 0.6, 0.25)
    love.graphics.rectangle("fill", player2.x, player2.y, player2.width, player2.height)

    -- Draw ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.size, ball.size)
end

function love.update(dt)
    -- Move paddles (speed is in pixels per second)
    -- Scancodes keep W/S working even with an Arabic keyboard layout.
    if love.keyboard.isDown("w") or love.keyboard.isScancodeDown("w") then
        player1.y = player1.y - player1.speed * dt
    elseif love.keyboard.isDown("s") or love.keyboard.isScancodeDown("s") then
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

    -- Move ball
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    -- Bounce off the top and bottom walls
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = math.abs(ball.dy)
    elseif ball.y + ball.size >= WINDOW_HEIGHT then
        ball.y = WINDOW_HEIGHT - ball.size
        ball.dy = -math.abs(ball.dy)
    end

    -- Bounce off paddles and move the ball outside after a hit
    if ball.dx < 0 and checkCollision(ball.x, ball.y, ball.size, ball.size,
        player1.x, player1.y, player1.width, player1.height) then
        ball.x = player1.x + player1.width
        ball.dx = -ball.dx
    elseif ball.dx > 0 and checkCollision(ball.x, ball.y, ball.size, ball.size,
        player2.x, player2.y, player2.width, player2.height) then
        ball.x = player2.x - ball.size
        ball.dx = -ball.dx
    end

    -- Start again in the center when a player misses
    if ball.x > WINDOW_WIDTH or ball.x + ball.size < 0 then
        ball.x = WINDOW_WIDTH / 2 - ball.size / 2
        ball.y = WINDOW_HEIGHT / 2 - ball.size / 2
        ball.dx = -ball.dx
        ball.dy = 180
    end
end

-- AABB collision: the rectangles must overlap on both axes
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x1 + w1 > x2
        and y1 < y2 + h2 and y1 + h1 > y2
end
