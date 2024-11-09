local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Script:

local rs = game:GetService("RunService")

local p = game.Players.LocalPlayer
local m = p:GetMouse()

local Velocities = {}
local Highlights = {}
local Tracers = {}

local Status = false
local Mode = "Follow"
local Force = "200"
local ESPColor = Color3.fromRGB(255, 255, 255)

local Window = Rayfield:CreateWindow({
    Name = "SchlawgHub V1.2",
    LoadingTitle = "SchlawgHub V1.2",
    LoadingSubtitle = "By Schlawg",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Fling"
    }
})

local FlingTab = Window:CreateTab("Fling")

local SectionToggle = FlingTab:CreateSection("Toggle")

local Toggle = FlingTab:CreateToggle({
    Name = "Enabled",
    CurrentValue = false,
    Flag = "Enabled",
    Callback = function(Value)
        print(Value)
        Status = Value
        Rayfield:Notify({
            Title = "'Enabled' was Changed!",
            Content = "'Enabled' set to "..tostring(Status),
            Duration = 6.5,
            Image = 4483362458,
            })
    end,
})

local SectionSettings = FlingTab:CreateSection("Settings")

local Input = FlingTab:CreateInput({
    Name = "Force",
    PlaceholderText = "200",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Force = tonumber(Text)
    end,
})

local Modes = FlingTab:CreateButton({
    Name = "Change Mode",
        Callback = function()
            if Mode == "Follow" then
                Mode = "Straight"
            else
                Mode = "Follow"
            end

            Rayfield:Notify({
                Title = "Fling mode has been changed!",
                Content = "Current mode: ".."'"..Mode.."'",
                Duration = 6.5,
                Image = 4483362458,
            })
        end
})

local FlingKeybind = FlingTab:CreateKeybind({
    Name = "Fling Keybind",
    CurrentKeybind = "G",
    HoldToInteract = false,
    Flag = "FlingKeybind",
    Callback = function(Keybind)
        if Status == true then
            local v = Instance.new("BodyVelocity")
            v.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            v.Velocity = workspace.Camera.CFrame.LookVector * Force
            v.Parent = m.Target
            local h = Instance.new("Highlight")
            h.Adornee = m.Target
            h.Parent = m.Target
            table.insert(Highlights, h)
            table.insert(Velocities, v)
        end
    end,
})

local ResetKeybind = FlingTab:CreateKeybind({
    Name = "Reset Keybind",
    CurrentKeybind = "V",
    HoldToInteract = false,
    Flag = "ResetKeybind",
    Callback = function(Keybind)
        if Status == true then
            for _,v in pairs(Velocities) do
                v:Destroy()
            end
            for _,v in pairs(Highlights) do
                v:Destroy()
            end
        end
    end,
})

local ESPConnection

local function Trace(Target: Player)
    local Line = Drawing.new("Line")
    local Box = Drawing.new("Square")
    local NameText = Drawing.new("Text")

    Line.Visible = false
    Line.Color = ESPColor
    Line.Thickness = 1
    Line.Transparency = 1

    Box.Visible = false
    Box.Filled = false
    Box.Color = ESPColor
    Box.Thickness = 1

    NameText.Visible = false
    NameText.Center = true
    NameText.Color = ESPColor
    NameText.Text = Target.DisplayName

    table.insert(Tracers, {Line, Box, NameText, Target})
end

for _,v in pairs(game.Players:GetPlayers()) do
    Trace(v)
end

game.Players.PlayerAdded:Connect(function(v)
    Trace(v)
end)

local ESPTab = Window:CreateTab("ESP")

local SectionESPToggle = ESPTab:CreateSection("Toggle")

local ESPToggle = ESPTab:CreateToggle({
    Name = "Enabled",
    CurrentValue = false,
    Flag = nil,
    Callback = function(Value)
        if Value == true then
            ESPConnection = rs.RenderStepped:Connect(function()
                for _,v in pairs(Tracers) do
                    if v[4].Character ~= nil and v[4].Character:FindFirstChild("Humanoid") and v[4].Character:FindFirstChild("HumanoidRootPart") and v[4] ~= p and v[4].Character.Humanoid.Health > 0 then
                        local TargetVector, TargetOnScreen = workspace.CurrentCamera:WorldToViewportPoint(v[4].Character.HumanoidRootPart.Position)
                        local PlayerVector, PlayerOnScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)

                        local HeadPosition = workspace.CurrentCamera:WorldToViewportPoint(v[4].Character.Head.Position + Vector3.new(0, 0.5, 0))
                        local LegPosition = workspace.CurrentCamera:WorldToViewportPoint(v[4].Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))

                        v[1].Color = ESPColor
                        v[2].Color = ESPColor
                        if TargetOnScreen and PlayerOnScreen then
                            v[1].Visible = true
                            v[1].From = Vector2.new(PlayerVector.X, PlayerVector.Y)
                            v[1].To = Vector2.new(TargetVector.X, TargetVector.Y)

                            v[2].Visible = true
                            v[2].Size = Vector2.new(workspace.CurrentCamera.ViewportSize.X / TargetVector.Z, HeadPosition.Y - LegPosition.Y)
                            v[2].Position = Vector2.new(TargetVector.X - (v[2].Size.X / 2), TargetVector.Y - (v[2].Size.Y / 2))

                            v[3].Visible = true
                            v[3].Size = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 20, workspace.CurrentCamera.ViewportSize.Y / 40)
                            v[3].Position = Vector2.new(TargetVector.X, TargetVector.Y)
                        elseif not PlayerOnScreen and TargetOnScreen then
                            v[1].Visible = true
                            v[1].From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                            v[1].To = Vector2.new(TargetVector.X, TargetVector.Y)

                            v[2].Visible = true
                            v[2].Size = Vector2.new(workspace.CurrentCamera.ViewportSize.X / TargetVector.Z, HeadPosition.Y - LegPosition.Y)
                            v[2].Position = Vector2.new(TargetVector.X - (v[2].Size.X / 2), TargetVector.Y - (v[2].Size.Y / 2))

                            v[3].Visible = true
                            v[3].Size = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 20, workspace.CurrentCamera.ViewportSize.Y / 40)
                            v[3].Position = Vector2.new(TargetVector.X, TargetVector.Y)
                        elseif not TargetOnScreen then
                            v[1].Visible = false
                            v[2].Visible = false
                            v[3].Visible = false
                        end
                    else
                        v[1].Visible = false
                        v[2].Visible = false
                        v[3].Visible = false
                    end
                end
            end)
        elseif Value == false then
            ESPConnection:Disconnect()
            for _,v in pairs(Tracers) do
                v[1].Visible = false
                v[2].Visible = false
                v[3].Visible = false
            end
        end
    end,
})

local SectionESPSettings = ESPTab:CreateSection("Settings")

local ESPColorPicker = ESPTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ESP_Color",
    Callback = function(Value)
        ESPColor = Value
    end
})

while task.wait() do
    if Mode == "Follow" then
        for _,v in pairs(Velocities) do
            v.Velocity = workspace.Camera.CFrame.LookVector * Force
        end
    end
    if Status == false then
        for _,v in pairs(Velocities) do
            v:Destroy()
        end
        for _,v in pairs(Highlights) do
            v:Destroy()
        end
    end
end
