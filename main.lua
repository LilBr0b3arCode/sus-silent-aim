if not game:IsLoaded() then game.Loaded:Wait() end
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()

local Settings = {
    Enabled = false,
    Method = "Raycast",
    TargetPart = "Head",
    FOVRadius = 130,
    VisibleCheck = false,
    TeamCheck = false
}

-- target caching
local CurrentTarget = nil
local lastUpdate = 0

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Circle = Drawing.new("Circle")
Circle.Thickness = 1
Circle.NumSides = 60
Circle.Radius = Settings.FOVRadius
Circle.Visible = false
Circle.Color = Color3.fromRGB(255, 255, 255)

local function UpdateTarget()
    local closestDist = Settings.FOVRadius
    local currentTarget = nil
    local mousePos = game:GetService("UserInputService"):GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local root = p.Character:FindFirstChild(Settings.TargetPart)
            local hum = p.Character:FindFirstChildOfClass("Humanoid")

            if root and hum and hum.Health > 0 then
                if Settings.TeamCheck and p.Team == LocalPlayer.Team then continue end

                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < closestDist then
                        if Settings.VisibleCheck then
                            local parts = Camera:GetPartsObscuringTarget({root.Position}, {LocalPlayer.Character, p.Character})
                            if #parts > 0 then continue end
                        end
                        currentTarget = root
                        closestDist = dist
                    end
                end
            end
        end
    end
    CurrentTarget = currentTarget
end

task.spawn(function()
    while task.wait(0.05) do
        if Settings.Enabled then
            UpdateTarget()
        end
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- prevents retarded lag
    if not checkcaller() and Settings.Enabled and self == workspace then
        if CurrentTarget then
            if method == "Raycast" and Settings.Method == "Raycast" then
                args[2] = (CurrentTarget.Position - args[1]).Unit * 1000
                return oldNamecall(self, unpack(args))
            elseif (string.find(method, "FindPartOnRay")) and Settings.Method == "FindPartOnRay" then
                local origin = args[1].Origin
                args[1] = Ray.new(origin, (CurrentTarget.Position - origin).Unit * 1000)
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end))

local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, idx)
    if not checkcaller() and Settings.Enabled and Settings.Method == "Mouse.Hit" and self == Mouse then
        if (idx == "Hit" or idx == "Target") and CurrentTarget then
            return (idx == "Hit" and CurrentTarget.CFrame or CurrentTarget)
        end
    end
    return oldIndex(self, idx)
end))

-- yay gui
local Window = Library:CreateWindow({Title = 'Universal Silent Aim', Center = true, AutoShow = true})
local Tab = Window:AddTab("Combat")
local Main = Tab:AddLeftTabbox("Main"):AddTab("Config")

Main:AddToggle("SA_Enabled", {Text = "Enabled"}):OnChanged(function() Settings.Enabled = Toggles.SA_Enabled.Value end)
Main:AddDropdown("SA_Method", {Text = "Method", Default = "Raycast", Values = {"Raycast", "FindPartOnRay", "Mouse.Hit"}})
Options.SA_Method:OnChanged(function() Settings.Method = Options.SA_Method.Value end)

local Visuals = Tab:AddRightTabbox("Visuals"):AddTab("FOV")
Visuals:AddToggle("ShowFOV", {Text = "Show FOV Circle"}):OnChanged(function() Circle.Visible = Toggles.ShowFOV.Value end)
Visuals:AddSlider("FOVSize", {Text = "Radius", Min = 10, Max = 600, Default = 130, Rounding = 0}):OnChanged(function() 
    Settings.FOVRadius = Options.FOVSize.Value 
    Circle.Radius = Options.FOVSize.Value 
end)
Visuals:AddToggle("WallCheck", {Text = "Visible Check"}):OnChanged(function() Settings.VisibleCheck = Toggles.WallCheck.Value end)

game:GetService("RunService").RenderStepped:Connect(function()
    Circle.Position = game:GetService("UserInputService"):GetMouseLocation()
end)

Library:Notify("System Optimized. Use RightAlt to Toggle Menu.")
