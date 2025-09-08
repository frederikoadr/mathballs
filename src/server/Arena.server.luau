local arena = workspace:WaitForChild("Arena")
local tilesFolder = arena:WaitForChild("Tiles")

for _, tile in ipairs(tilesFolder:GetChildren()) do
	if tile:IsA("BasePart") then
		-- check if already has SurfaceGui
		if not tile:FindFirstChildOfClass("SurfaceGui") then
			local surfaceGui = Instance.new("SurfaceGui")
			surfaceGui.Face = Enum.NormalId.Top
			surfaceGui.AlwaysOnTop = true
			surfaceGui.ResetOnSpawn = false
			surfaceGui.Parent = tile
			surfaceGui.Adornee = tile

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.TextScaled = true
			label.TextColor3 = Color3.new(1, 1, 1) -- white
			label.Font = Enum.Font.SourceSansBold
			label.Text = "?"
			label.Parent = surfaceGui
		end
	end
end
