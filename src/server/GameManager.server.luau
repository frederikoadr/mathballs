local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local arena = workspace:WaitForChild("Arena")
local tilesFolder = arena:WaitForChild("Tiles")

local ROUND_TIME = 15
local currentAnswer = nil
local problem = ""

-- Store original CFrames of tiles so we can reset them
local originalStates = {}
for _,tile in ipairs(tilesFolder:GetChildren()) do
	if tile:IsA("BasePart") then
		originalStates[tile] = tile.CFrame
	end
end

-- Leaderstats setup
local function setupLeaderstats(player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player

	local streak = Instance.new("IntValue")
	streak.Name = "Streak"
	streak.Value = 0
	streak.Parent = stats

	local maxStreak = Instance.new("IntValue")
	maxStreak.Name = "MaxStreak"
	maxStreak.Value = 0
	maxStreak.Parent = stats
end
Players.PlayerAdded:Connect(setupLeaderstats)

-- Generate math problem
local function generateProblem()
	local operators = {"+","-","*"}
	local a = math.random(1,12)
	local b = math.random(1,12)
	local op = operators[math.random(#operators)]

	if op == "+" then currentAnswer = a+b
	elseif op == "-" then currentAnswer = a-b
	elseif op == "*" then currentAnswer = a*b
	end

	problem = a .. " " .. op .. " " .. b
	return problem, currentAnswer
end

-- Assign numbers to tiles
local function assignNumbers(correctAnswer)
	local tiles = tilesFolder:GetChildren()
	-- shuffle tiles
	for i = #tiles, 2, -1 do
		local j = math.random(i)
		tiles[i], tiles[j] = tiles[j], tiles[i]
	end

	-- Ratio'd tiles
	local totalTiles = #tiles
  local minCorrect = math.floor(totalTiles * 0.15)
  local maxCorrect = math.floor(totalTiles * 0.25)
  local numCorrect = math.random(minCorrect, maxCorrect)

	for i, tile in ipairs(tiles) do
		local label = tile:FindFirstChildOfClass("SurfaceGui").TextLabel
		if i <= numCorrect then
			label.Text = tostring(correctAnswer)
		else
			-- give wrong answers
			local wrongAnswer = correctAnswer + math.random(-5,5)
			if wrongAnswer == correctAnswer then
				wrongAnswer = wrongAnswer + 1
			end
			label.Text = tostring(wrongAnswer)
		end
		-- Reset tile each round
		tile.Anchored = true
		tile.Orientation = Vector3.new(0,0,0)
		tile.CFrame = originalStates[tile]
	end
end

-- Drop wrong tiles
local function dropWrongTiles()
	for _, tile in ipairs(tilesFolder:GetChildren()) do
		local surfaceGui = tile:FindFirstChildOfClass("SurfaceGui")
		if surfaceGui and surfaceGui:FindFirstChild("TextLabel") then
			local num = tonumber(surfaceGui.TextLabel.Text)
			if num ~= currentAnswer then
					-- Your pivot offset relative to tile center
					local pivotOffset = Vector3.new(0, 0, -tile.Size.Z / 2 )

					-- Step 1: move pivot to world space
					local pivotWorld = tile.CFrame * CFrame.new(pivotOffset)

					-- Step 2: build target rotation around that pivot
					local targetCFrame =
						pivotWorld * CFrame.Angles(math.rad(90), 0, 0) * CFrame.new(-pivotOffset)

					-- Step 3: tween the Part to that new CFrame
					local tween = TweenService:Create(
						tile,
						TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{CFrame = targetCFrame}
					)
					tween:Play()
				end
		end
	end
end

-- Respawn tiles (smooth tween back to original state)
local function respawnTiles()
	for tile, cf in pairs(originalStates) do
		tile.Anchored = true
		local tween = TweenService:Create(
			tile,
			TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{CFrame = cf, Orientation = Vector3.new(0,0,0)}
		)
		tween:Play()
	end
end

local function awardStreak(player)
    -- Safety check
    if not player:FindFirstChild("leaderstats") then return end
    
    local streak = player.leaderstats:FindFirstChild("Streak")
    local maxStreak = player.leaderstats:FindFirstChild("MaxStreak")

    if streak and maxStreak then
        streak.Value += 1
        if streak.Value > maxStreak.Value then
            maxStreak.Value = streak.Value
        end
    end
end


-- Validate survivors & update streaks
local function validatePlayers()
	for _,player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
			local standingTile = nil
			for _,tile in ipairs(tilesFolder:GetChildren()) do
				if (hrp.Position - tile.Position).Magnitude < 10 then
					standingTile = tile
					break
				end
			end

			if standingTile then
        print("standing")
				local num = tonumber(standingTile:FindFirstChildOfClass("SurfaceGui").TextLabel.Text)
				if num == currentAnswer then
					awardStreak(player)
				else
					-- on wrong tile
					player.leaderstats.Streak.Value = 0
				end
			else
				-- fell off
				player.leaderstats.Streak.Value = 0
			end
		end
	end
end

-- Round flow
local function startRound()
	local prob, ans = generateProblem()
	print("Problem:", prob, "Answer:", ans)

	-- Show GUI
	for _,plr in ipairs(Players:GetPlayers()) do
		local gui = plr:WaitForChild("PlayerGui"):WaitForChild("GameGui")
		gui.QuestionLabel.Text = prob
		gui.TimerLabel.Text = tostring(ROUND_TIME)
	end

	assignNumbers(ans)

	-- Countdown
	for t = ROUND_TIME,1,-1 do
		for _,plr in ipairs(Players:GetPlayers()) do
			local gui = plr.PlayerGui.GameGui
			gui.TimerLabel.Text = tostring(t)
		end
		wait(1)
	end

	-- Drop wrong tiles
	dropWrongTiles()

	-- Validate who survived
	wait(1)
	validatePlayers()

	-- Wait before respawn
	wait(4)
	respawnTiles()

	-- Start next round
	wait(1)
	startRound()
end

-- Run first round after 5s
task.wait(5)
startRound()
