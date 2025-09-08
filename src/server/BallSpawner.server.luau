local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Get modules and ball template
local enterBall = require(ReplicatedStorage.Ball.Scripts.Server.Occupant.enterBall)
local BallTemplate = ReplicatedStorage:WaitForChild("Ball")

-- Spawns a ball for this player
local function spawnBall(player, character)
	-- Cleanup old ball if exists
	if player:FindFirstChild("Ball") then
		local oldBall = player.Ball.Value
		if oldBall and oldBall.Parent then
			oldBall:Destroy()
		end
	end

	-- Clone ball
	local ball = BallTemplate:Clone()
	ball.Parent = workspace

	-- Place at spawn location
	local hrp = character:WaitForChild("HumanoidRootPart")
	ball:SetPrimaryPartCFrame(hrp.CFrame + Vector3.new(0, 5, 0))

	-- Store reference
	local ballValue = Instance.new("ObjectValue")
	ballValue.Name = "Ball"
	ballValue.Value = ball
	ballValue.Parent = player

	-- Sit player in ball
	task.wait(0.5)
	enterBall(player)
end

local function onCharacterAdded(character, player)
	task.wait(1) -- wait for character to load
	spawnBall(player, character)
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(char)
		onCharacterAdded(char, player)
	end)

	-- Handle if player already has character
	if player.Character then
		onCharacterAdded(player.Character, player)
	end
end

-- Cleanup when player leaves
local function onPlayerRemoving(player)
	if player:FindFirstChild("Ball") then
		local ball = player.Ball.Value
		if ball and ball.Parent then
			ball:Destroy()
		end
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
