head = {2, 2} -- Position {x, y} of head of snake
dir = {1, 0} -- Direction {x, y} of head of snake
dirsave = false
length = 10 -- Length of the snake in blocks, including the head
blocks = {}
blocks[1] = {}
blocks[2] = {}

timer = 0
dtg = 0
timermax = 0.1

--love.window.setMode(800, 600)
food = {0, 0}

function love.load()
	math.randomseed(os.time())
	food = spawnFood()
end

function spawnFood()
	loop = true
	x = 0
	y = 0
	while loop==true do
		x = math.random(0, 39)
		y = math.random(0, 29)
		loop = false
		for i=1, length do
			if x == blocks[1][i] and y == blocks[2][i] then
				loop = true
			end
		end
	end
	return {x, y}
end

function love.update(dt)
   timer = timer + dt
   dtg = dt
end

function decrementBlocks()
	for i=2,length do
		if blocks[1] ~= nil then
			blocks[1][i-1] = blocks[1][i]
			blocks[2][i-1] = blocks[2][i]
		end
	end
end

function incremenetBlocks(n)
	for i=length-n,0,-1 do
		if blocks[1] ~= nil then
			blocks[1][i+n] = blocks[1][i]
			blocks[2][i+n] = blocks[2][i]
		end
	end
end

function love.draw()
	if timer > timermax then
		dirsave = false
		for i=1,length do
			if blocks[1][i] == head[1] and blocks[2][i] == head[2] or head[1] > 39 or head[1] < 0 or head[2] > 29 or head[2] < 0 then
				love.graphics.setColor(1,0,0,1)
				dead = 1
				head = {999999999, 999999999}
			end
		end
		timer = 0
		blocks[1][length] = head[1]
		blocks[2][length] = head[2]
		head[1] = head[1] + dir[1]
		head[2] = head[2] + dir[2]
		if head[1] == food[1] and head[2] == food[2] then
			food = spawnFood()
			timermax = timermax * 0.95
			length = length + 10
			incremenetBlocks(10)
		end
		decrementBlocks()
	end
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle("fill", head[1]*20, head[2]*20, 18, 18, 3, 3)
	for i=1,length do
		if blocks[1][i] ~= nil then 
			love.graphics.rectangle("fill", blocks[1][i]*20, blocks[2][i]*20, 18, 18, 3, 3)
		end
	end
	love.graphics.print("Score: " .. (length - 10) / 10, 10, 10)

	love.graphics.setColor(1,0.3,0.3,1)
	love.graphics.rectangle("fill", food[1]*20, food[2]*20, 18, 18, 3, 3)
	if dead == 1 then 
		love.graphics.print("You Died", 200, 200)
	end
	--love.graphics.print(dir[1] .. ", " .. dir[2], 100, 100)
	--[[for i=1,length do
		if blocks[3][i] ~= nil then
			love.graphics.print( blocks[3][i] .. ",", 10 + i * 20, 300)
		end
	end]]
end 

function love.keypressed(key)
	if dirsave ~= true then
		dirsave = true
		if key == "d" and dir[1] ~= -1 then
			dir = {1,0}
		elseif key == "a" and dir[1] ~= 1 then
			dir = {-1,0}
		elseif key == "w" and dir[2] ~= 1 then
			dir = {0,-1}
		elseif key == "s" and dir[2] ~= -1 then 
			dir = {0,1}
		end
	end
end
