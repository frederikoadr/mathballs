game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local streak = Instance.new("IntValue")
    streak.Name = "Streak"
    streak.Value = 0
    streak.Parent = leaderstats

    local maxStreak = Instance.new("IntValue")
    maxStreak.Name = "MaxStreak"
    maxStreak.Value = 0
    maxStreak.Parent = leaderstats

    -- Reset streak when player dies
    player.CharacterAdded:Connect(function(char)
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            streak.Value = 0
        end)
    end)
end)
