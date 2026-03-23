-- Script Path: game:GetService("Workspace").bebramen22090.LocalScript1
-- Took 0s to decompile.
-- Executor: Delta (1.1.711.876)

game:GetService("Players")
local v_u_1 = game:GetService("SoundService")
local v_u_2 = game:GetService("Debris")
script.Parent:WaitForChild("Humanoid").Died:Connect(function()
    -- upvalues: (copy) v_u_1, (copy) v_u_2
    local v3 = Instance.new("Sound")
    v3.SoundId = "rbxassetid://128306955968079"
    v3.Volume = 0.3
    v3.Parent = v_u_1
    v3:Play()
    v_u_2:AddItem(v3, 10)
end)
 -- Script Path: game:GetService("Workspace").bebramen22090.LocalScript
-- Took 0.02s to decompile.
-- Executor: Delta (1.1.711.876)

local v1 = game:GetService("Players")
local v2 = game:GetService("RunService")
local v_u_3 = game:GetService("Debris")
local _ = v1.LocalPlayer
local v_u_4 = script.Parent
local v_u_5 = v_u_4:WaitForChild("Humanoid")
local v_u_6 = v_u_4:WaitForChild("HumanoidRootPart")
local v_u_7 = workspace.CurrentCamera
v_u_5.JumpPower = 30
local v_u_8 = 0
local v_u_9 = true
local v_u_10 = false
local v_u_11 = false
local v_u_12 = 80
local v_u_13 = v_u_12
local v_u_14 = v_u_12
local v_u_15 = 0
local v_u_16 = 0
local v_u_17 = v_u_6:FindFirstChild("LandSound")
if not v_u_17 then
    v_u_17 = Instance.new("Sound")
    v_u_17.Name = "LandSound"
    v_u_17.SoundId = "rbxassetid://109962379271807"
    v_u_17.Volume = 0.1
    v_u_17.RollOffMode = Enum.RollOffMode.InverseTapered
    v_u_17.RollOffMinDistance = 8
    v_u_17.RollOffMaxDistance = 60
    v_u_17.Parent = v_u_6
end
local function v_u_20(p18)
    local v19 = Instance.new("ParticleEmitter")
    v19.Texture = "rbxasset://textures/particles/smoke_main.dds"
    v19.Rate = 0
    v19.Lifetime = NumberRange.new(0.3, 0.5)
    v19.Speed = NumberRange.new(6, 10)
    v19.SpreadAngle = Vector2.new(45, 45)
    v19.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 0) })
    v19.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) })
    v19.Color = ColorSequence.new(Color3.fromRGB(200, 200, 200))
    v19.EmissionDirection = Enum.NormalId.Top
    v19.Parent = p18
    return v19
end
local v_u_21 = RaycastParams.new()
v_u_21.FilterType = Enum.RaycastFilterType.Exclude
v_u_21.IgnoreWater = true
local function v_u_26(p22)
    -- upvalues: (copy) v_u_6
    local v23 = v_u_6.CFrame.LookVector
    local v24 = v23 - p22 * v23:Dot(p22)
    if v24.Magnitude < 0.001 then
        v24 = Vector3.new(1, 0, 0) - p22 * (Vector3.new(1, 0, 0)):Dot(p22)
    end
    local v25 = v24.Unit:Cross(p22).Unit
    return v25, p22, p22:Cross(v25).Unit
end
local function v_u_38(p27, p28)
    -- upvalues: (copy) v_u_21, (copy) v_u_4, (copy) v_u_26, (copy) v_u_20, (copy) v_u_3
    if p27 then
        v_u_21.FilterDescendantsInstances = { v_u_4 }
        local v29 = -(p27.Size.Y * 0.75 + 2)
        local v30 = Vector3.new(0, v29, 0)
        local v31 = p27.Position
        local v32 = workspace:Raycast(v31, v30, v_u_21)
        if v32 then
            local v33 = Instance.new("Part")
            v33.Anchored = true
            v33.CanCollide = false
            v33.CanQuery = false
            v33.CanTouch = false
            v33.Transparency = 1
            v33.Size = Vector3.new(0.2, 0.2, 0.2)
            v33.CFrame = CFrame.new(v32.Position)
            v33.Parent = workspace
            local v34 = Instance.new("Attachment")
            v34.Parent = v33
            local v35, v36, v37 = v_u_26(v32.Normal.Unit)
            v34.WorldCFrame = CFrame.fromMatrix(v32.Position, v35, v36, v37)
            v_u_20(v34):Emit(p28 or 6)
            v_u_3:AddItem(v33, 0.8)
        end
    else
        return
    end
end
local function v_u_44(p39)
    -- upvalues: (copy) v_u_7
    local v40 = p39 * 0
    local v41 = math.random(-100, 100) * v40 / 100
    local v42 = math.random(-100, 100) * v40 / 100
    local v43 = Vector3.new(v41, v42, 0)
    v_u_7.CFrame = v_u_7.CFrame * CFrame.new(v43 * 0.1)
end
v_u_5.StateChanged:Connect(function(_, p45)
    -- upvalues: (ref) v_u_9, (ref) v_u_8, (copy) v_u_5
    if p45 == Enum.HumanoidStateType.Jumping then
        local v46 = tick()
        if not v_u_9 or v46 - v_u_8 < 1 then
            v_u_5:ChangeState(Enum.HumanoidStateType.Freefall)
            return
        end
        v_u_8 = v46
        v_u_9 = false
        task.wait(1)
        v_u_9 = true
    end
end)
v2.RenderStepped:Connect(function(_)
    -- upvalues: (copy) v_u_5, (ref) v_u_11, (ref) v_u_10, (ref) v_u_16, (ref) v_u_13, (ref) v_u_12, (ref) v_u_15, (copy) v_u_6, (copy) v_u_4, (copy) v_u_38, (ref) v_u_17, (copy) v_u_44, (ref) v_u_14, (copy) v_u_7
    if v_u_5 and v_u_5.Health > 0 then
        local v47 = v_u_5:GetState() == Enum.HumanoidStateType.Freefall and true or v_u_5:GetState() == Enum.HumanoidStateType.Flying
        if v47 and not v_u_11 then
            v_u_10 = true
            v_u_16 = tick()
            v_u_13 = v_u_12 + 3
        end
        if v_u_11 and not v47 then
            v_u_10 = false
            v_u_15 = tick()
            local v48 = v_u_6.AssemblyLinearVelocity.Y
            local v49 = math.abs(v48) / 50
            local v50 = math.clamp(v49, 0.1, 1)
            v_u_13 = v_u_12 - 1
            local v51 = v_u_4:FindFirstChild("LeftFoot") or v_u_4:FindFirstChild("Left Leg")
            local v52 = v_u_4:FindFirstChild("RightFoot") or v_u_4:FindFirstChild("Right Leg")
            v_u_38(v51, 8)
            v_u_38(v52, 8)
            v_u_17.PlaybackSpeed = 0.95 + math.random() * 0.1
            v_u_17:Play()
            v_u_44(v50)
            if v_u_6.AssemblyLinearVelocity.Magnitude > 5 then
                local v53 = v_u_6.AssemblyLinearVelocity
                local v54 = v_u_6
                local v55 = v53.X * 0.85
                local v56 = v53.Y
                local v57 = v53.Z * 0.85
                v54.AssemblyLinearVelocity = Vector3.new(v55, v56, v57)
            end
        end
        if not v_u_10 and tick() - v_u_15 > 0.15 then
            v_u_13 = v_u_12
        end
        v_u_14 = v_u_14 + (v_u_13 - v_u_14) * 0.15
        v_u_7.FieldOfView = v_u_14
        if tick() - v_u_15 < 0.2 then
            local v58 = (tick() - v_u_15) / 0.2 * 3.141592653589793
            local v59 = math.sin(v58) * 0
            v_u_7.CFrame = v_u_7.CFrame * CFrame.Angles(0, 0, (math.rad(v59)))
        end
        v_u_11 = v47
    end
end)
v_u_7:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    -- upvalues: (copy) v_u_7, (ref) v_u_14, (ref) v_u_12
    local v60 = v_u_7.FieldOfView - v_u_14
    if math.abs(v60) > 5 then
        v_u_12 = v_u_7.FieldOfView
        v_u_14 = v_u_7.FieldOfView
    end
end)
-- Script Path: game:GetService("Workspace").bebramen22090:GetChildren()[11]
-- Took 0.01s to decompile.
-- Executor: Delta (1.1.711.876)

local v1 = game:GetService("Players")
local v_u_2 = game:GetService("UserInputService")
local v3 = game:GetService("RunService")
local _ = v1.LocalPlayer
local v4 = script.Parent
local v_u_5 = v4:WaitForChild("Humanoid")
local v_u_6 = v4:WaitForChild("HumanoidRootPart")
local v_u_7 = workspace.CurrentCamera
local v_u_8 = Enum.KeyCode.C
local v_u_9 = Enum.KeyCode.LeftControl
local v_u_10 = false
local v_u_11 = 0
local v_u_12 = 0
local v_u_13 = v_u_5.WalkSpeed
local v_u_14 = nil
local v_u_15 = nil
local v_u_16 = nil
local function v20()
    -- upvalues: (ref) v_u_16, (copy) v_u_5, (ref) v_u_14, (ref) v_u_15
    v_u_16 = v_u_16 or v_u_5:FindFirstChildOfClass("Animator")
    if not v_u_16 then
        v_u_16 = Instance.new("Animator")
        v_u_16.Parent = v_u_5
    end
    local v17 = v_u_16
    if v17 then
        local v18 = Instance.new("Animation")
        v18.AnimationId = "rbxassetid://102226306945117"
        v_u_14 = v17:LoadAnimation(v18)
        v_u_14.Priority = Enum.AnimationPriority.Action
        local v19 = Instance.new("Animation")
        v19.AnimationId = "rbxassetid://124458965304788"
        v_u_15 = v17:LoadAnimation(v19)
        v_u_15.Priority = Enum.AnimationPriority.Action
    end
end
local function v_u_24()
    -- upvalues: (ref) v_u_10, (copy) v_u_6, (ref) v_u_14, (ref) v_u_15
    if v_u_10 then
        local v21 = v_u_6.Velocity
        local v22 = v21.X
        local v23 = v21.Z
        if Vector3.new(v22, 0, v23).Magnitude > 0.5 then
            if v_u_14 and v_u_14.IsPlaying then
                v_u_14:Stop()
            end
            if v_u_15 and not v_u_15.IsPlaying then
                v_u_15:Play()
                return
            end
        else
            if v_u_15 and v_u_15.IsPlaying then
                v_u_15:Stop()
            end
            if v_u_14 and not v_u_14.IsPlaying then
                v_u_14:Play()
            end
        end
    end
end
v3.RenderStepped:Connect(function()
    -- upvalues: (ref) v_u_11, (ref) v_u_12, (copy) v_u_7, (copy) v_u_5, (copy) v_u_24
    v_u_11 = v_u_11 + (v_u_12 - v_u_11) * 0.2
    if v_u_7.CameraSubject == v_u_5 then
        v_u_7.CFrame = v_u_7.CFrame * CFrame.new(0, v_u_11, 0)
    end
    v_u_24()
end)
v_u_2.InputBegan:Connect(function(p25, p26)
    -- upvalues: (copy) v_u_8, (copy) v_u_9, (ref) v_u_10, (ref) v_u_12, (copy) v_u_5, (ref) v_u_13, (ref) v_u_14
    if not p26 then
        if (p25.KeyCode == v_u_8 or p25.KeyCode == v_u_9) and not v_u_10 then
            if v_u_10 then
                return
            end
            v_u_10 = true
            v_u_12 = -1
            v_u_5.WalkSpeed = v_u_13 * 0.5
            v_u_5.JumpPower = 0
            if v_u_14 then
                v_u_14:Play()
            end
        end
    end
end)
v_u_2.InputEnded:Connect(function(p27, _)
    -- upvalues: (copy) v_u_8, (copy) v_u_9, (copy) v_u_2, (ref) v_u_10, (ref) v_u_12, (copy) v_u_5, (ref) v_u_13, (ref) v_u_14, (ref) v_u_15
    if (p27.KeyCode == v_u_8 or p27.KeyCode == v_u_9) and not (v_u_2:IsKeyDown(v_u_8) or v_u_2:IsKeyDown(v_u_9)) then
        if not v_u_10 then
            return
        end
        v_u_10 = false
        v_u_12 = 0
        v_u_5.WalkSpeed = v_u_13
        v_u_5.JumpPower = 30
        if v_u_14 and v_u_14.IsPlaying then
            v_u_14:Stop()
        end
        if v_u_15 and v_u_15.IsPlaying then
            v_u_15:Stop()
        end
    end
end)
v_u_13 = v_u_5.WalkSpeed
v_u_5.JumpPower = 30
v20()
v_u_5.Died:Connect(function()
    -- upvalues: (ref) v_u_10, (ref) v_u_11, (ref) v_u_12, (copy) v_u_5, (ref) v_u_13, (ref) v_u_14, (ref) v_u_15
    if v_u_10 then
        v_u_10 = false
        v_u_11 = 0
        v_u_12 = 0
        v_u_5.WalkSpeed = v_u_13
        v_u_5.JumpPower = 30
        if v_u_14 and v_u_14.IsPlaying then
            v_u_14:Stop()
        end
        if v_u_15 and v_u_15.IsPlaying then
            v_u_15:Stop()
        end
    end
end)
-- Script Path: game:GetService("Players").bebramen22090.PlayerScripts.killfeed
-- Took 0.01s to decompile.
-- Executor: Delta (1.1.711.876)

local v1 = game:GetService("Players")
local v_u_2 = game:GetService("TweenService")
local v3 = v1.LocalPlayer:WaitForChild("PlayerGui")
local v4 = Instance.new("ScreenGui")
v4.Name = "KillFeedGui"
v4.ResetOnSpawn = false
v4.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
v4.Parent = v3
local v_u_5 = Instance.new("Frame")
v_u_5.Name = "KillFeed"
v_u_5.Size = UDim2.new(0, 350, 0, 500)
v_u_5.Position = UDim2.new(1, -360, 0, 10)
v_u_5.BackgroundTransparency = 1
v_u_5.ClipsDescendants = false
v_u_5.Parent = v4
local v6 = Instance.new("UIListLayout")
v6.SortOrder = Enum.SortOrder.LayoutOrder
v6.Padding = UDim.new(0, 3)
v6.Parent = v_u_5
local function v_u_17(p7, p8, p9, p10)
    local v11 = Instance.new("Frame")
    v11.Name = "Entry"
    v11.Size = UDim2.new(1, 0, 0, 24)
    v11.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    v11.BackgroundTransparency = 0.3
    v11.BorderSizePixel = 0
    local v12 = Instance.new("TextLabel")
    v12.Size = UDim2.new(0, 120, 1, 0)
    v12.Position = UDim2.new(0, 5, 0, 0)
    v12.BackgroundTransparency = 1
    v12.Text = p7
    v12.TextColor3 = Color3.fromRGB(255, 255, 255)
    v12.TextSize = 14
    v12.Font = Enum.Font.GothamBold
    v12.TextXAlignment = Enum.TextXAlignment.Right
    v12.TextStrokeTransparency = 0.7
    v12.Parent = v11
    local v13 = Instance.new("ImageLabel")
    v13.Size = UDim2.new(0, 20, 0, 20)
    v13.Position = UDim2.new(0, 130, 0, 2)
    v13.BackgroundTransparency = 1
    v13.Image = "rbxassetid://" .. tostring(p9)
    v13.ImageColor3 = Color3.fromRGB(255, 255, 255)
    v13.ScaleType = Enum.ScaleType.Fit
    v13.Parent = v11
    local v14
    if p10 then
        local v15 = Instance.new("ImageLabel")
        v15.Size = UDim2.new(0, 16, 0, 16)
        v15.Position = UDim2.new(0, 155, 0, 4)
        v15.BackgroundTransparency = 1
        v15.Image = "rbxassetid://118619928046751"
        v15.ImageColor3 = Color3.fromRGB(255, 255, 255)
        v15.ScaleType = Enum.ScaleType.Fit
        v15.Parent = v11
        v14 = 175
    else
        v14 = 155
    end
    local v16 = Instance.new("TextLabel")
    v16.Size = UDim2.new(0, 120, 1, 0)
    v16.Position = UDim2.new(0, v14, 0, 0)
    v16.BackgroundTransparency = 1
    v16.Text = p8
    v16.TextColor3 = Color3.fromRGB(220, 220, 220)
    v16.TextSize = 14
    v16.Font = Enum.Font.Gotham
    v16.TextXAlignment = Enum.TextXAlignment.Left
    v16.TextStrokeTransparency = 0.7
    v16.Parent = v11
    return v11
end
local function v_u_30(p18, p19, p20, p21)
    -- upvalues: (copy) v_u_17, (copy) v_u_5, (copy) v_u_2
    local v_u_22 = v_u_17(p18, p19, p20 or "16057578111", p21 or false)
    v_u_22.BackgroundTransparency = 1
    for _, v23 in pairs(v_u_5:GetChildren()) do
        if v23:IsA("Frame") then
            v23.LayoutOrder = v23.LayoutOrder + 1
        end
    end
    v_u_22.LayoutOrder = 0
    v_u_22.Parent = v_u_5
    for _, v24 in pairs(v_u_22:GetDescendants()) do
        if v24:IsA("TextLabel") then
            v24.TextTransparency = 1
        elseif v24:IsA("ImageLabel") then
            v24.ImageTransparency = 1
        end
    end
    v_u_2:Create(v_u_22, TweenInfo.new(0.2), {
        ["BackgroundTransparency"] = 0.3
    }):Play()
    for _, v25 in pairs(v_u_22:GetDescendants()) do
        if v25:IsA("TextLabel") then
            v_u_2:Create(v25, TweenInfo.new(0.2), {
                ["TextTransparency"] = 0
            }):Play()
        elseif v25:IsA("ImageLabel") then
            v_u_2:Create(v25, TweenInfo.new(0.2), {
                ["ImageTransparency"] = 0
            }):Play()
        end
    end
    task.delay(5, function()
        -- upvalues: (copy) v_u_22, (ref) v_u_2
        if v_u_22 and v_u_22.Parent then
            v_u_2:Create(v_u_22, TweenInfo.new(0.3), {
                ["BackgroundTransparency"] = 1
            }):Play()
            for _, v26 in pairs(v_u_22:GetDescendants()) do
                if v26:IsA("TextLabel") then
                    v_u_2:Create(v26, TweenInfo.new(0.3), {
                        ["TextTransparency"] = 1
                    }):Play()
                elseif v26:IsA("ImageLabel") then
                    v_u_2:Create(v26, TweenInfo.new(0.3), {
                        ["ImageTransparency"] = 1
                    }):Play()
                end
            end
            task.wait(0.3)
            v_u_22:Destroy()
        end
    end)
    local v27 = {}
    for _, v28 in pairs(v_u_5:GetChildren()) do
        if v28:IsA("Frame") then
            table.insert(v27, v28)
        end
    end
    if #v27 > 8 then
        for v29 = 9, #v27 do
            v27[v29]:Destroy()
        end
    end
end
local v31 = game:GetService("ReplicatedStorage"):FindFirstChild("KillFeedEvent")
if v31 then
    v31.OnClientEvent:Connect(function(p32, p33, p34, p35)
        -- upvalues: (copy) v_u_30
        v_u_30(p32, p33, p34, p35)
    end)
end
-- Script Path: game:GetService("Players").bebramen22090.PlayerScripts.LocalScript
-- Took 0.04s to decompile.
-- Executor: Delta (1.1.711.876)

local v_u_1 = game:GetService("Players")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("ReplicatedStorage")
local v4 = game:GetService("UserInputService")
local v_u_5 = game:GetService("StarterGui")
local v6 = game:GetService("TextChatService")
local v_u_7 = v_u_1.LocalPlayer:WaitForChild("PlayerGui")
if not _G.__CustomChatClientRunning then
    _G.__CustomChatClientRunning = true
    pcall(function()
        -- upvalues: (copy) v_u_5
        v_u_5:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    end)
    if v6:FindFirstChild("ChatWindowConfiguration") then
        v6.ChatWindowConfiguration.Enabled = false
    end
    if v6:FindFirstChild("ChatInputBarConfiguration") then
        v6.ChatInputBarConfiguration.Enabled = false
    end
    local v8 = v_u_7:WaitForChild("chat")
    local v_u_9 = v8:WaitForChild("chat")
    local v_u_10 = v_u_9:WaitForChild("MessageLog")
    local v_u_11 = v_u_9:WaitForChild("InputBox")
    local v12 = v_u_9:WaitForChild("Header"):FindFirstChild("CloseButton")
    local v_u_13 = v8:WaitForChild("ChatButton")
    local v14 = v3:WaitForChild("RemoteEvents")
    local v_u_15 = v14:WaitForChild("VoteEvent")
    local v_u_16 = v14:WaitForChild("ChatEvent")
    local v_u_17 = false
    local v_u_18 = {}
    local v_u_19 = 0
    local v_u_20 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local v_u_21 = nil
    local v_u_22 = nil
    local v_u_23 = nil
    local v_u_24 = nil
    local v_u_25 = nil
    local v_u_26 = false
    (function()
        -- upvalues: (copy) v_u_7, (ref) v_u_24, (ref) v_u_25, (ref) v_u_22, (ref) v_u_23, (ref) v_u_26, (copy) v_u_15, (ref) v_u_21
        local v27 = Instance.new("ScreenGui")
        v27.Name = "VoteKickGUI"
        v27.ResetOnSpawn = false
        v27.Parent = v_u_7
        local v28 = Instance.new("Frame")
        v28.Name = "MainFrame"
        v28.Size = UDim2.new(0, 280, 0, 140)
        v28.Position = UDim2.new(0, 20, 0.5, -70)
        v28.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        v28.BorderSizePixel = 0
        v28.BackgroundTransparency = 0.2
        v28.Visible = false
        v28.Parent = v27
        local v29 = Instance.new("UIGradient")
        v29.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25)) })
        v29.Parent = v28
        local v30 = Instance.new("Frame")
        v30.Size = UDim2.new(0, 4, 1, 0)
        v30.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        v30.BorderSizePixel = 0
        v30.Parent = v28
        local v31 = Instance.new("TextLabel")
        v31.Text = "votekick"
        v31.Size = UDim2.new(1, -20, 0, 25)
        v31.Position = UDim2.new(0, 15, 0, 5)
        v31.BackgroundTransparency = 1
        v31.Font = Enum.Font.GothamBold
        v31.TextColor3 = Color3.fromRGB(255, 50, 50)
        v31.TextSize = 18
        v31.TextXAlignment = Enum.TextXAlignment.Left
        v31.Parent = v28
        v_u_24 = Instance.new("TextLabel")
        v_u_24.Text = "PlayerName"
        v_u_24.Size = UDim2.new(1, -70, 0, 25)
        v_u_24.Position = UDim2.new(0, 65, 0, 35)
        v_u_24.BackgroundTransparency = 1
        v_u_24.Font = Enum.Font.Gotham
        v_u_24.TextColor3 = Color3.fromRGB(255, 255, 255)
        v_u_24.TextSize = 16
        v_u_24.TextXAlignment = Enum.TextXAlignment.Left
        v_u_24.Parent = v28
        v_u_25 = Instance.new("ImageLabel")
        v_u_25.Size = UDim2.new(0, 40, 0, 40)
        v_u_25.Position = UDim2.new(0, 15, 0, 35)
        v_u_25.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        v_u_25.Parent = v28
        local v32 = Instance.new("UICorner")
        v32.CornerRadius = UDim.new(0, 4)
        v32.Parent = v_u_25
        local v33 = Instance.new("Frame")
        v33.Size = UDim2.new(1, -20, 0, 25)
        v33.Position = UDim2.new(0, 15, 0, 80)
        v33.BackgroundTransparency = 1
        v33.Parent = v28
        local v34 = Instance.new("TextLabel")
        v34.Text = "[8]"
        v34.Size = UDim2.new(0, 30, 1, 0)
        v34.BackgroundTransparency = 1
        v34.TextColor3 = Color3.fromRGB(150, 150, 150)
        v34.Font = Enum.Font.GothamBold
        v34.TextSize = 14
        v34.Parent = v33
        local v35 = Instance.new("TextLabel")
        v35.Text = "YES"
        v35.Position = UDim2.new(0, 35, 0, 0)
        v35.Size = UDim2.new(0, 50, 1, 0)
        v35.BackgroundTransparency = 1
        v35.TextColor3 = Color3.fromRGB(100, 255, 100)
        v35.Font = Enum.Font.GothamBold
        v35.TextSize = 14
        v35.TextXAlignment = Enum.TextXAlignment.Left
        v35.Parent = v33
        v_u_22 = Instance.new("TextLabel")
        v_u_22.Text = "0"
        v_u_22.Size = UDim2.new(0, 30, 1, 0)
        v_u_22.Position = UDim2.new(1, -30, 0, 0)
        v_u_22.BackgroundTransparency = 1
        v_u_22.TextColor3 = Color3.fromRGB(255, 255, 255)
        v_u_22.Font = Enum.Font.Gotham
        v_u_22.TextXAlignment = Enum.TextXAlignment.Right
        v_u_22.Parent = v33
        local v36 = Instance.new("Frame")
        v36.Size = UDim2.new(1, -20, 0, 25)
        v36.Position = UDim2.new(0, 15, 0, 105)
        v36.BackgroundTransparency = 1
        v36.Parent = v28
        local v37 = Instance.new("TextLabel")
        v37.Text = "[9]"
        v37.Size = UDim2.new(0, 30, 1, 0)
        v37.BackgroundTransparency = 1
        v37.TextColor3 = Color3.fromRGB(150, 150, 150)
        v37.Font = Enum.Font.GothamBold
        v37.TextSize = 14
        v37.Parent = v36
        local v38 = Instance.new("TextLabel")
        v38.Text = "NO"
        v38.Position = UDim2.new(0, 35, 0, 0)
        v38.Size = UDim2.new(0, 50, 1, 0)
        v38.BackgroundTransparency = 1
        v38.TextColor3 = Color3.fromRGB(255, 100, 100)
        v38.Font = Enum.Font.GothamBold
        v38.TextSize = 14
        v38.TextXAlignment = Enum.TextXAlignment.Left
        v38.Parent = v36
        v_u_23 = Instance.new("TextLabel")
        v_u_23.Text = "0"
        v_u_23.Size = UDim2.new(0, 30, 1, 0)
        v_u_23.Position = UDim2.new(1, -30, 0, 0)
        v_u_23.BackgroundTransparency = 1
        v_u_23.TextColor3 = Color3.fromRGB(255, 255, 255)
        v_u_23.Font = Enum.Font.Gotham
        v_u_23.TextXAlignment = Enum.TextXAlignment.Right
        v_u_23.Parent = v36
        local v39 = Instance.new("TextButton")
        v39.Size = UDim2.new(1, 0, 1, 0)
        v39.BackgroundTransparency = 1
        v39.Text = ""
        v39.Parent = v33
        v39.MouseButton1Click:Connect(function()
            -- upvalues: (ref) v_u_26, (ref) v_u_15
            if v_u_26 then
                v_u_15:FireServer("VoteYes")
            end
        end)
        local v40 = Instance.new("TextButton")
        v40.Size = UDim2.new(1, 0, 1, 0)
        v40.BackgroundTransparency = 1
        v40.Text = ""
        v40.Parent = v36
        v40.MouseButton1Click:Connect(function()
            -- upvalues: (ref) v_u_26, (ref) v_u_15
            if v_u_26 then
                v_u_15:FireServer("VoteNo")
            end
        end)
        v_u_21 = v28
    end)()
    v_u_15.OnClientEvent:Connect(function(p41, p42, p43)
        -- upvalues: (ref) v_u_26, (ref) v_u_24, (copy) v_u_1, (ref) v_u_25, (ref) v_u_22, (ref) v_u_23, (ref) v_u_21
        if p41 == "StartVote" then
            v_u_26 = true
            v_u_24.Text = p42
            v_u_25.Image = v_u_1:GetUserThumbnailAsync(p43, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            v_u_22.Text = "1"
            v_u_23.Text = "0"
            v_u_21.Visible = true
            return
        elseif p41 == "UpdateVotes" then
            v_u_22.Text = tostring(p42)
            v_u_23.Text = tostring(p43)
        elseif p41 == "EndVote" then
            v_u_26 = false
            v_u_21.Visible = false
        end
    end)
    v4.InputBegan:Connect(function(p44, p45)
        -- upvalues: (ref) v_u_26, (copy) v_u_15
        if v_u_26 then
            if p45 then
                return
            elseif p44.KeyCode == Enum.KeyCode.Eight then
                v_u_15:FireServer("VoteYes")
            elseif p44.KeyCode == Enum.KeyCode.Nine then
                v_u_15:FireServer("VoteNo")
            end
        else
            return
        end
    end)
    local function v_u_67(p46, p47, p48, p49)
        -- upvalues: (copy) v_u_10, (copy) v_u_18, (ref) v_u_17, (copy) v_u_2, (copy) v_u_20
        local v50 = tostring(p46 or "System"):sub(1, 20)
        local v51 = tostring(p47 or ""):sub(1, 200)
        local v_u_52 = Instance.new("Frame")
        v_u_52.Size = UDim2.new(1, -5, 0, 0)
        v_u_52.AutomaticSize = Enum.AutomaticSize.Y
        v_u_52.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        v_u_52.BackgroundTransparency = 0.6
        v_u_52.BorderSizePixel = 0
        v_u_52.LayoutOrder = tick()
        local v53 = Instance.new("UIPadding")
        v53.PaddingLeft = UDim.new(0, 6)
        v53.PaddingRight = UDim.new(0, 6)
        v53.PaddingTop = UDim.new(0, 3)
        v53.PaddingBottom = UDim.new(0, 3)
        v53.Parent = v_u_52
        local v_u_54 = Instance.new("TextLabel")
        v_u_54.Size = UDim2.new(1, 0, 0, 0)
        v_u_54.AutomaticSize = Enum.AutomaticSize.Y
        v_u_54.BackgroundTransparency = 1
        v_u_54.Font = Enum.Font.SourceSans
        v_u_54.TextSize = 16
        v_u_54.TextWrapped = true
        v_u_54.TextXAlignment = Enum.TextXAlignment.Left
        v_u_54.TextYAlignment = Enum.TextYAlignment.Top
        v_u_54.RichText = true
        v_u_54.TextTransparency = 0
        local v55 = tostring(v51 or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        local v56 = tostring(v50 or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        if p48 then
            v_u_54.Text = string.format("<font color=\"rgb(255, 200, 100)\">* %s</font>", v55)
        else
            local v57 = p49 or Color3.fromRGB(180, 220, 255)
            local v58 = v57.R * 255
            local v59 = math.floor(v58)
            local v60 = v57.G * 255
            local v61 = math.floor(v60)
            local v62 = v57.B * 255
            local v63 = math.floor(v62)
            v_u_54.Text = string.format("<font color=\"rgb(%d, %d, %d)\">%s</font><font color=\"rgb(200, 200, 200)\">: %s</font>", v59, v61, v63, v56, v55)
        end
        v_u_54.Parent = v_u_52
        v_u_52.Parent = v_u_10
        local v_u_64 = {
            ["frame"] = v_u_52,
            ["textLabel"] = v_u_54,
            ["timestamp"] = tick(),
            ["fadeThread"] = nil,
            ["fadeStarted"] = false
        }
        local v65 = v_u_18
        table.insert(v65, v_u_64)
        if not v_u_17 then
            v_u_64.fadeThread = task.delay(12, function()
                -- upvalues: (copy) v_u_52, (ref) v_u_17, (copy) v_u_64, (ref) v_u_2, (ref) v_u_20, (copy) v_u_54
                if v_u_52 and (v_u_52.Parent and not v_u_17) then
                    v_u_64.fadeStarted = true
                    v_u_2:Create(v_u_52, v_u_20, {
                        ["BackgroundTransparency"] = 1
                    }):Play()
                    v_u_2:Create(v_u_54, v_u_20, {
                        ["TextTransparency"] = 1
                    }):Play()
                    task.wait(0.5)
                    if v_u_52 and (v_u_52.Parent and not v_u_17) then
                        v_u_52.Visible = false
                    end
                end
            end)
        end
        if #v_u_18 > 100 then
            local v66 = table.remove(v_u_18, 1)
            if v66.fadeThread then
                task.cancel(v66.fadeThread)
            end
            if v66.frame then
                v66.frame:Destroy()
            end
        end
        task.wait(0.05)
        v_u_10.CanvasPosition = Vector2.new(0, v_u_10.AbsoluteCanvasSize.Y)
    end
    local function v_u_71(p68)
        -- upvalues: (ref) v_u_17, (copy) v_u_9, (copy) v_u_18, (copy) v_u_11, (copy) v_u_13, (copy) v_u_2, (copy) v_u_20
        if p68 == nil then
            v_u_17 = not v_u_17
        else
            v_u_17 = p68
        end
        if v_u_17 then
            v_u_9.Visible = true
            for _, v69 in ipairs(v_u_18) do
                if v69.frame and v69.frame.Parent then
                    if v69.fadeThread then
                        task.cancel(v69.fadeThread)
                        v69.fadeThread = nil
                    end
                    v69.frame.Visible = true
                    v69.frame.BackgroundTransparency = 0.6
                    v69.textLabel.TextTransparency = 0
                    v69.fadeStarted = false
                end
            end
            v_u_9.BackgroundTransparency = 0.3
            v_u_11.Visible = true
            v_u_13.Visible = false
            task.wait(0.05)
            v_u_11:CaptureFocus()
        else
            v_u_9.BackgroundTransparency = 1
            v_u_11.Visible = false
            v_u_13.Visible = true
            for _, v_u_70 in ipairs(v_u_18) do
                if v_u_70.frame and v_u_70.frame.Parent then
                    v_u_70.fadeThread = task.delay(12, function()
                        -- upvalues: (copy) v_u_70, (ref) v_u_17, (ref) v_u_2, (ref) v_u_20
                        if v_u_70.frame and (v_u_70.frame.Parent and not v_u_17) then
                            v_u_70.fadeStarted = true
                            v_u_2:Create(v_u_70.frame, v_u_20, {
                                ["BackgroundTransparency"] = 1
                            }):Play()
                            v_u_2:Create(v_u_70.textLabel, v_u_20, {
                                ["TextTransparency"] = 1
                            }):Play()
                            task.wait(0.5)
                            if v_u_70.frame and (v_u_70.frame.Parent and not v_u_17) then
                                v_u_70.frame.Visible = false
                            end
                        end
                    end)
                end
            end
        end
    end
    local function v_u_74()
        -- upvalues: (ref) v_u_19, (copy) v_u_11, (copy) v_u_16
        local v72 = tick()
        if v72 - v_u_19 < 0.5 then
            return
        else
            local v73 = v_u_11.Text:match("^%s*(.-)%s*$")
            if v73 and #v73 ~= 0 then
                if #v73 > 200 then
                    v73 = v73:sub(1, 200)
                end
                v_u_19 = v72
                v_u_11.Text = ""
                v_u_16:FireServer(v73)
            end
        end
    end
    v_u_13.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_71
        v_u_71(true)
    end)
    if v12 then
        v12.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_71
            v_u_71(false)
        end)
    end
    v_u_11.FocusLost:Connect(function(p75)
        -- upvalues: (copy) v_u_74, (ref) v_u_17, (copy) v_u_11, (copy) v_u_71
        if p75 then
            v_u_74()
            if v_u_17 then
                task.wait(0.05)
                v_u_11:CaptureFocus()
                return
            end
        else
            v_u_71(false)
        end
    end)
    v4.InputBegan:Connect(function(p76, p77)
        -- upvalues: (copy) v_u_11, (copy) v_u_71, (ref) v_u_17
        if not p77 then
            if p76.KeyCode == Enum.KeyCode.Y and not v_u_11:IsFocused() then
                v_u_71(true)
            end
            if p76.KeyCode == Enum.KeyCode.Escape and v_u_17 then
                v_u_71(false)
            end
        end
    end)
    v_u_16.OnClientEvent:Connect(function(p78, p79, p80)
        -- upvalues: (copy) v_u_1, (copy) v_u_67
        local v81 = v_u_1:GetPlayerByUserId(p78)
        local v82 = Color3.fromRGB(180, 220, 255)
        if v81 and (v81.Team and v81.Team.TeamColor) then
            v82 = v81.Team.TeamColor.Color
        end
        v_u_67(tostring(p79 or "Player"), tostring(p80 or ""), false, v82)
    end)
end
-- Script Path: game:GetService("Players").bebramen22090.PlayerScripts.LocalScript
-- Took 0.03s to decompile.
-- Executor: Delta (1.1.711.876)

local v_u_1 = game:GetService("Players")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("ReplicatedStorage")
local v4 = game:GetService("UserInputService")
local v_u_5 = game:GetService("StarterGui")
local v6 = game:GetService("TextChatService")
local v_u_7 = v_u_1.LocalPlayer:WaitForChild("PlayerGui")
if not _G.__CustomChatClientRunning then
    _G.__CustomChatClientRunning = true
    pcall(function()
        -- upvalues: (copy) v_u_5
        v_u_5:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    end)
    if v6:FindFirstChild("ChatWindowConfiguration") then
        v6.ChatWindowConfiguration.Enabled = false
    end
    if v6:FindFirstChild("ChatInputBarConfiguration") then
        v6.ChatInputBarConfiguration.Enabled = false
    end
    local v8 = v_u_7:WaitForChild("chat")
    local v_u_9 = v8:WaitForChild("chat")
    local v_u_10 = v_u_9:WaitForChild("MessageLog")
    local v_u_11 = v_u_9:WaitForChild("InputBox")
    local v12 = v_u_9:WaitForChild("Header"):FindFirstChild("CloseButton")
    local v_u_13 = v8:WaitForChild("ChatButton")
    local v14 = v3:WaitForChild("RemoteEvents")
    local v_u_15 = v14:WaitForChild("VoteEvent")
    local v_u_16 = v14:WaitForChild("ChatEvent")
    local v_u_17 = false
    local v_u_18 = {}
    local v_u_19 = 0
    local v_u_20 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local v_u_21 = nil
    local v_u_22 = nil
    local v_u_23 = nil
    local v_u_24 = nil
    local v_u_25 = nil
    local v_u_26 = false
    (function()
        -- upvalues: (copy) v_u_7, (ref) v_u_24, (ref) v_u_25, (ref) v_u_22, (ref) v_u_23, (ref) v_u_26, (copy) v_u_15, (ref) v_u_21
        local v27 = Instance.new("ScreenGui")
        v27.Name = "VoteKickGUI"
        v27.ResetOnSpawn = false
        v27.Parent = v_u_7
        local v28 = Instance.new("Frame")
        v28.Name = "MainFrame"
        v28.Size = UDim2.new(0, 280, 0, 140)
        v28.Position = UDim2.new(0, 20, 0.5, -70)
        v28.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        v28.BorderSizePixel = 0
        v28.BackgroundTransparency = 0.2
        v28.Visible = false
        v28.Parent = v27
        local v29 = Instance.new("UIGradient")
        v29.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25)) })
        v29.Parent = v28
        local v30 = Instance.new("Frame")
        v30.Size = UDim2.new(0, 4, 1, 0)
        v30.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        v30.BorderSizePixel = 0
        v30.Parent = v28
        local v31 = Instance.new("TextLabel")
        v31.Text = "votekick"
        v31.Size = UDim2.new(1, -20, 0, 25)
        v31.Position = UDim2.new(0, 15, 0, 5)
        v31.BackgroundTransparency = 1
        v31.Font = Enum.Font.GothamBold
        v31.TextColor3 = Color3.fromRGB(255, 50, 50)
        v31.TextSize = 18
        v31.TextXAlignment = Enum.TextXAlignment.Left
        v31.Parent = v28
        v_u_24 = Instance.new("TextLabel")
        v_u_24.Text = "PlayerName"
        v_u_24.Size = UDim2.new(1, -70, 0, 25)
        v_u_24.Position = UDim2.new(0, 65, 0, 35)
        v_u_24.BackgroundTransparency = 1
        v_u_24.Font = Enum.Font.Gotham
        v_u_24.TextColor3 = Color3.fromRGB(255, 255, 255)
        v_u_24.TextSize = 16
        v_u_24.TextXAlignment = Enum.TextXAlignment.Left
        v_u_24.Parent = v28
        v_u_25 = Instance.new("ImageLabel")
        v_u_25.Size = UDim2.new(0, 40, 0, 40)
        v_u_25.Position = UDim2.new(0, 15, 0, 35)
        v_u_25.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        v_u_25.Parent = v28
        local v32 = Instance.new("UICorner")
        v32.CornerRadius = UDim.new(0, 4)
        v32.Parent = v_u_25
        local v33 = Instance.new("Frame")
        v33.Size = UDim2.new(1, -20, 0, 25)
        v33.Position = UDim2.new(0, 15, 0, 80)
        v33.BackgroundTransparency = 1
        v33.Parent = v28
        local v34 = Instance.new("TextLabel")
        v34.Text = "[8]"
        v34.Size = UDim2.new(0, 30, 1, 0)
        v34.BackgroundTransparency = 1
        v34.TextColor3 = Color3.fromRGB(150, 150, 150)
        v34.Font = Enum.Font.GothamBold
        v34.TextSize = 14
        v34.Parent = v33
        local v35 = Instance.new("TextLabel")
        v35.Text = "YES"
        v35.Position = UDim2.new(0, 35, 0, 0)
        v35.Size = UDim2.new(0, 50, 1, 0)
        v35.BackgroundTransparency = 1
        v35.TextColor3 = Color3.fromRGB(100, 255, 100)
        v35.Font = Enum.Font.GothamBold
        v35.TextSize = 14
        v35.TextXAlignment = Enum.TextXAlignment.Left
        v35.Parent = v33
        v_u_22 = Instance.new("TextLabel")
        v_u_22.Text = "0"
        v_u_22.Size = UDim2.new(0, 30, 1, 0)
        v_u_22.Position = UDim2.new(1, -30, 0, 0)
        v_u_22.BackgroundTransparency = 1
        v_u_22.TextColor3 = Color3.fromRGB(255, 255, 255)
        v_u_22.Font = Enum.Font.Gotham
        v_u_22.TextXAlignment = Enum.TextXAlignment.Right
        v_u_22.Parent = v33
        local v36 = Instance.new("Frame")
        v36.Size = UDim2.new(1, -20, 0, 25)
        v36.Position = UDim2.new(0, 15, 0, 105)
        v36.BackgroundTransparency = 1
        v36.Parent = v28
        local v37 = Instance.new("TextLabel")
        v37.Text = "[9]"
        v37.Size = UDim2.new(0, 30, 1, 0)
        v37.BackgroundTransparency = 1
        v37.TextColor3 = Color3.fromRGB(150, 150, 150)
        v37.Font = Enum.Font.GothamBold
        v37.TextSize = 14
        v37.Parent = v36
        local v38 = Instance.new("TextLabel")
        v38.Text = "NO"
        v38.Position = UDim2.new(0, 35, 0, 0)
        v38.Size = UDim2.new(0, 50, 1, 0)
        v38.BackgroundTransparency = 1
        v38.TextColor3 = Color3.fromRGB(255, 100, 100)
        v38.Font = Enum.Font.GothamBold
        v38.TextSize = 14
        v38.TextXAlignment = Enum.TextXAlignment.Left
        v38.Parent = v36
        v_u_23 = Instance.new("TextLabel")
        v_u_23.Text = "0"
        v_u_23.Size = UDim2.new(0, 30, 1, 0)
        v_u_23.Position = UDim2.new(1, -30, 0, 0)
        v_u_23.BackgroundTransparency = 1
        v_u_23.TextColor3 = Color3.fromRGB(255, 255, 255)
        v_u_23.Font = Enum.Font.Gotham
        v_u_23.TextXAlignment = Enum.TextXAlignment.Right
        v_u_23.Parent = v36
        local v39 = Instance.new("TextButton")
        v39.Size = UDim2.new(1, 0, 1, 0)
        v39.BackgroundTransparency = 1
        v39.Text = ""
        v39.Parent = v33
        v39.MouseButton1Click:Connect(function()
            -- upvalues: (ref) v_u_26, (ref) v_u_15
            if v_u_26 then
                v_u_15:FireServer("VoteYes")
            end
        end)
        local v40 = Instance.new("TextButton")
        v40.Size = UDim2.new(1, 0, 1, 0)
        v40.BackgroundTransparency = 1
        v40.Text = ""
        v40.Parent = v36
        v40.MouseButton1Click:Connect(function()
            -- upvalues: (ref) v_u_26, (ref) v_u_15
            if v_u_26 then
                v_u_15:FireServer("VoteNo")
            end
        end)
        v_u_21 = v28
    end)()
    v_u_15.OnClientEvent:Connect(function(p41, p42, p43)
        -- upvalues: (ref) v_u_26, (ref) v_u_24, (copy) v_u_1, (ref) v_u_25, (ref) v_u_22, (ref) v_u_23, (ref) v_u_21
        if p41 == "StartVote" then
            v_u_26 = true
            v_u_24.Text = p42
            v_u_25.Image = v_u_1:GetUserThumbnailAsync(p43, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            v_u_22.Text = "1"
            v_u_23.Text = "0"
            v_u_21.Visible = true
            return
        elseif p41 == "UpdateVotes" then
            v_u_22.Text = tostring(p42)
            v_u_23.Text = tostring(p43)
        elseif p41 == "EndVote" then
            v_u_26 = false
            v_u_21.Visible = false
        end
    end)
    v4.InputBegan:Connect(function(p44, p45)
        -- upvalues: (ref) v_u_26, (copy) v_u_15
        if v_u_26 then
            if p45 then
                return
            elseif p44.KeyCode == Enum.KeyCode.Eight then
                v_u_15:FireServer("VoteYes")
            elseif p44.KeyCode == Enum.KeyCode.Nine then
                v_u_15:FireServer("VoteNo")
            end
        else
            return
        end
    end)
    local function v_u_67(p46, p47, p48, p49)
        -- upvalues: (copy) v_u_10, (copy) v_u_18, (ref) v_u_17, (copy) v_u_2, (copy) v_u_20
        local v50 = tostring(p46 or "System"):sub(1, 20)
        local v51 = tostring(p47 or ""):sub(1, 200)
        local v_u_52 = Instance.new("Frame")
        v_u_52.Size = UDim2.new(1, -5, 0, 0)
        v_u_52.AutomaticSize = Enum.AutomaticSize.Y
        v_u_52.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        v_u_52.BackgroundTransparency = 0.6
        v_u_52.BorderSizePixel = 0
        v_u_52.LayoutOrder = tick()
        local v53 = Instance.new("UIPadding")
        v53.PaddingLeft = UDim.new(0, 6)
        v53.PaddingRight = UDim.new(0, 6)
        v53.PaddingTop = UDim.new(0, 3)
        v53.PaddingBottom = UDim.new(0, 3)
        v53.Parent = v_u_52
        local v_u_54 = Instance.new("TextLabel")
        v_u_54.Size = UDim2.new(1, 0, 0, 0)
        v_u_54.AutomaticSize = Enum.AutomaticSize.Y
        v_u_54.BackgroundTransparency = 1
        v_u_54.Font = Enum.Font.SourceSans
        v_u_54.TextSize = 16
        v_u_54.TextWrapped = true
        v_u_54.TextXAlignment = Enum.TextXAlignment.Left
        v_u_54.TextYAlignment = Enum.TextYAlignment.Top
        v_u_54.RichText = true
        v_u_54.TextTransparency = 0
        local v55 = tostring(v51 or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        local v56 = tostring(v50 or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        if p48 then
            v_u_54.Text = string.format("<font color=\"rgb(255, 200, 100)\">* %s</font>", v55)
        else
            local v57 = p49 or Color3.fromRGB(180, 220, 255)
            local v58 = v57.R * 255
            local v59 = math.floor(v58)
            local v60 = v57.G * 255
            local v61 = math.floor(v60)
            local v62 = v57.B * 255
            local v63 = math.floor(v62)
            v_u_54.Text = string.format("<font color=\"rgb(%d, %d, %d)\">%s</font><font color=\"rgb(200, 200, 200)\">: %s</font>", v59, v61, v63, v56, v55)
        end
        v_u_54.Parent = v_u_52
        v_u_52.Parent = v_u_10
        local v_u_64 = {
            ["frame"] = v_u_52,
            ["textLabel"] = v_u_54,
            ["timestamp"] = tick(),
            ["fadeThread"] = nil,
            ["fadeStarted"] = false
        }
        local v65 = v_u_18
        table.insert(v65, v_u_64)
        if not v_u_17 then
            v_u_64.fadeThread = task.delay(12, function()
                -- upvalues: (copy) v_u_52, (ref) v_u_17, (copy) v_u_64, (ref) v_u_2, (ref) v_u_20, (copy) v_u_54
                if v_u_52 and (v_u_52.Parent and not v_u_17) then
                    v_u_64.fadeStarted = true
                    v_u_2:Create(v_u_52, v_u_20, {
                        ["BackgroundTransparency"] = 1
                    }):Play()
                    v_u_2:Create(v_u_54, v_u_20, {
                        ["TextTransparency"] = 1
                    }):Play()
                    task.wait(0.5)
                    if v_u_52 and (v_u_52.Parent and not v_u_17) then
                        v_u_52.Visible = false
                    end
                end
            end)
        end
        if #v_u_18 > 100 then
            local v66 = table.remove(v_u_18, 1)
            if v66.fadeThread then
                task.cancel(v66.fadeThread)
            end
            if v66.frame then
                v66.frame:Destroy()
            end
        end
        task.wait(0.05)
        v_u_10.CanvasPosition = Vector2.new(0, v_u_10.AbsoluteCanvasSize.Y)
    end
    local function v_u_71(p68)
        -- upvalues: (ref) v_u_17, (copy) v_u_9, (copy) v_u_18, (copy) v_u_11, (copy) v_u_13, (copy) v_u_2, (copy) v_u_20
        if p68 == nil then
            v_u_17 = not v_u_17
        else
            v_u_17 = p68
        end
        if v_u_17 then
            v_u_9.Visible = true
            for _, v69 in ipairs(v_u_18) do
                if v69.frame and v69.frame.Parent then
                    if v69.fadeThread then
                        task.cancel(v69.fadeThread)
                        v69.fadeThread = nil
                    end
                    v69.frame.Visible = true
                    v69.frame.BackgroundTransparency = 0.6
                    v69.textLabel.TextTransparency = 0
                    v69.fadeStarted = false
                end
            end
            v_u_9.BackgroundTransparency = 0.3
            v_u_11.Visible = true
            v_u_13.Visible = false
            task.wait(0.05)
            v_u_11:CaptureFocus()
        else
            v_u_9.BackgroundTransparency = 1
            v_u_11.Visible = false
            v_u_13.Visible = true
            for _, v_u_70 in ipairs(v_u_18) do
                if v_u_70.frame and v_u_70.frame.Parent then
                    v_u_70.fadeThread = task.delay(12, function()
                        -- upvalues: (copy) v_u_70, (ref) v_u_17, (ref) v_u_2, (ref) v_u_20
                        if v_u_70.frame and (v_u_70.frame.Parent and not v_u_17) then
                            v_u_70.fadeStarted = true
                            v_u_2:Create(v_u_70.frame, v_u_20, {
                                ["BackgroundTransparency"] = 1
                            }):Play()
                            v_u_2:Create(v_u_70.textLabel, v_u_20, {
                                ["TextTransparency"] = 1
                            }):Play()
                            task.wait(0.5)
                            if v_u_70.frame and (v_u_70.frame.Parent and not v_u_17) then
                                v_u_70.frame.Visible = false
                            end
                        end
                    end)
                end
            end
        end
    end
    local function v_u_74()
        -- upvalues: (ref) v_u_19, (copy) v_u_11, (copy) v_u_16
        local v72 = tick()
        if v72 - v_u_19 < 0.5 then
            return
        else
            local v73 = v_u_11.Text:match("^%s*(.-)%s*$")
            if v73 and #v73 ~= 0 then
                if #v73 > 200 then
                    v73 = v73:sub(1, 200)
                end
                v_u_19 = v72
                v_u_11.Text = ""
                v_u_16:FireServer(v73)
            end
        end
    end
    v_u_13.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_71
        v_u_71(true)
    end)
    if v12 then
        v12.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_71
            v_u_71(false)
        end)
    end
    v_u_11.FocusLost:Connect(function(p75)
        -- upvalues: (copy) v_u_74, (ref) v_u_17, (copy) v_u_11, (copy) v_u_71
        if p75 then
            v_u_74()
            if v_u_17 then
                task.wait(0.05)
                v_u_11:CaptureFocus()
                return
            end
        else
            v_u_71(false)
        end
    end)
    v4.InputBegan:Connect(function(p76, p77)
        -- upvalues: (copy) v_u_11, (copy) v_u_71, (ref) v_u_17
        if not p77 then
            if p76.KeyCode == Enum.KeyCode.Y and not v_u_11:IsFocused() then
                v_u_71(true)
            end
            if p76.KeyCode == Enum.KeyCode.Escape and v_u_17 then
                v_u_71(false)
            end
        end
    end)
    v_u_16.OnClientEvent:Connect(function(p78, p79, p80)
        -- upvalues: (copy) v_u_1, (copy) v_u_67
        local v81 = v_u_1:GetPlayerByUserId(p78)
        local v82 = Color3.fromRGB(180, 220, 255)
        if v81 and (v81.Team and v81.Team.TeamColor) then
            v82 = v81.Team.TeamColor.Color
        end
        v_u_67(tostring(p79 or "Player"), tostring(p80 or ""), false, v82)
    end)
end
-- Script Path: game:GetService("Players").bebramen22090.PlayerScripts.LocalScript2
-- Took 0.05s to decompile.
-- Executor: Delta (1.1.711.876)

local v_u_1 = game:GetService("Players")
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("UserInputService")
game:GetService("RunService")
local v_u_4 = v_u_1.LocalPlayer
local v_u_5 = workspace.CurrentCamera
local v6 = v2:WaitForChild("SpectatorEvent", 10)
local v_u_7 = v2:WaitForChild("GetAlivePlayers", 10)
if v6 and v_u_7 then
    local v_u_8 = false
    local v_u_9 = nil
    local v_u_10 = {}
    local v_u_11 = 1
    local v_u_12 = nil
    local v_u_13 = nil
    local v_u_14 = nil
    local v_u_15 = nil
    local v_u_16 = nil
    local v_u_17 = 0
    local v_u_18 = false
    local v_u_19 = nil
    local function v_u_27()
        -- upvalues: (ref) v_u_12, (ref) v_u_14, (ref) v_u_16, (ref) v_u_13, (ref) v_u_15, (copy) v_u_4
        if v_u_12 then
            v_u_12:Destroy()
        end
        v_u_12 = Instance.new("ScreenGui")
        v_u_12.Name = "SpectatorUI"
        v_u_12.ResetOnSpawn = false
        v_u_12.IgnoreGuiInset = true
        v_u_12.DisplayOrder = 100
        v_u_12.Enabled = true
        v_u_12.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        v_u_14 = Instance.new("Frame")
        v_u_14.Name = "InfoFrame"
        v_u_14.Size = UDim2.new(0, 450, 0, 110)
        v_u_14.Position = UDim2.new(0.5, -225, 0.85, 0)
        v_u_14.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        v_u_14.BackgroundTransparency = 0.3
        v_u_14.BorderSizePixel = 0
        v_u_14.Visible = false
        v_u_14.ZIndex = 100
        v_u_14.Parent = v_u_12
        local v20 = Instance.new("UICorner")
        v20.CornerRadius = UDim.new(0, 10)
        v20.Parent = v_u_14
        local v21 = Instance.new("UIStroke")
        v21.Color = Color3.fromRGB(255, 100, 100)
        v21.Thickness = 2
        v21.Transparency = 0.5
        v21.Parent = v_u_14
        local v22 = Instance.new("TextLabel")
        v22.Name = "Title"
        v22.Size = UDim2.new(1, -20, 0, 25)
        v22.Position = UDim2.new(0, 10, 0, 8)
        v22.BackgroundTransparency = 1
        v22.Text = "SPECTATING"
        v22.TextColor3 = Color3.fromRGB(255, 100, 100)
        v22.TextSize = 16
        v22.Font = Enum.Font.GothamBold
        v22.TextXAlignment = Enum.TextXAlignment.Left
        v22.ZIndex = 101
        v22.Parent = v_u_14
        v_u_16 = Instance.new("TextLabel")
        v_u_16.Name = "PlayerCount"
        v_u_16.Size = UDim2.new(0, 100, 0, 25)
        v_u_16.Position = UDim2.new(1, -110, 0, 8)
        v_u_16.BackgroundTransparency = 1
        v_u_16.Text = "0/0"
        v_u_16.TextColor3 = Color3.fromRGB(200, 200, 200)
        v_u_16.TextSize = 14
        v_u_16.Font = Enum.Font.GothamBold
        v_u_16.TextXAlignment = Enum.TextXAlignment.Right
        v_u_16.ZIndex = 101
        v_u_16.Parent = v_u_14
        v_u_13 = Instance.new("TextLabel")
        v_u_13.Name = "PlayerName"
        v_u_13.Size = UDim2.new(1, -20, 0, 30)
        v_u_13.Position = UDim2.new(0, 10, 0, 35)
        v_u_13.BackgroundTransparency = 1
        v_u_13.Text = "Loading..."
        v_u_13.TextColor3 = Color3.fromRGB(255, 255, 255)
        v_u_13.TextSize = 22
        v_u_13.Font = Enum.Font.GothamBold
        v_u_13.TextXAlignment = Enum.TextXAlignment.Left
        v_u_13.ZIndex = 101
        v_u_13.Parent = v_u_14
        local v23 = Instance.new("Frame")
        v23.Name = "HealthBG"
        v23.Size = UDim2.new(1, -20, 0, 8)
        v23.Position = UDim2.new(0, 10, 0, 68)
        v23.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        v23.BorderSizePixel = 0
        v23.ZIndex = 101
        v23.Parent = v_u_14
        local v24 = Instance.new("UICorner")
        v24.CornerRadius = UDim.new(0, 4)
        v24.Parent = v23
        v_u_15 = Instance.new("Frame")
        v_u_15.Name = "HealthBar"
        v_u_15.Size = UDim2.new(1, 0, 1, 0)
        v_u_15.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        v_u_15.BorderSizePixel = 0
        v_u_15.ZIndex = 102
        v_u_15.Parent = v23
        local v25 = Instance.new("UICorner")
        v25.CornerRadius = UDim.new(0, 4)
        v25.Parent = v_u_15
        local v26 = Instance.new("TextLabel")
        v26.Name = "Controls"
        v26.Size = UDim2.new(1, -20, 0, 20)
        v26.Position = UDim2.new(0, 10, 0, 82)
        v26.BackgroundTransparency = 1
        v26.Text = "[\226\134\144 A] Previous  [\226\134\146 D] Next  [MOUSE WHEEL] Cycle"
        v26.TextColor3 = Color3.fromRGB(180, 180, 180)
        v26.TextSize = 11
        v26.Font = Enum.Font.Gotham
        v26.TextXAlignment = Enum.TextXAlignment.Center
        v26.ZIndex = 101
        v26.Parent = v_u_14
        v_u_12.Parent = v_u_4.PlayerGui
    end
    local function v_u_39()
        -- upvalues: (copy) v_u_7, (copy) v_u_1, (copy) v_u_4, (ref) v_u_10, (ref) v_u_16, (ref) v_u_11
        local v28, v29 = pcall(function()
            -- upvalues: (ref) v_u_7
            return v_u_7:InvokeServer()
        end)
        if not (v28 and v29) then
            warn("[SPECTATOR CLIENT] Failed to get alive players:", v29)
            v_u_10 = {}
            return false
        end
        local v30 = {}
        for _, v31 in ipairs(v29) do
            local v32 = v_u_1:GetPlayerByUserId(v31.UserId)
            if v32 and (v32 ~= v_u_4 and v32.Character) then
                local v33 = v32.Character:FindFirstChild("Humanoid")
                if v33 and v33.Health > 0 then
                    local v34 = {
                        ["UserId"] = v31.UserId,
                        ["Player"] = v32
                    }
                    table.insert(v30, v34)
                end
            end
        end
        v_u_10 = v30
        if v_u_16 then
            local v35 = v_u_16
            local v36 = string.format
            local v37 = v_u_11
            local v38 = #v_u_10
            v35.Text = v36("%d/%d", math.min(v37, v38), #v_u_10)
        end
        return true
    end
    local function v_u_41()
        -- upvalues: (copy) v_u_4, (copy) v_u_5
        if v_u_4.Character then
            local v40 = v_u_4.Character:FindFirstChild("Humanoid")
            if v40 then
                v_u_5.CameraType = Enum.CameraType.Custom
                v_u_5.CameraSubject = v40
                v_u_4.CameraMode = Enum.CameraMode.Classic
                v_u_4.CameraMaxZoomDistance = 400
                v_u_4.CameraMinZoomDistance = 0.5
                task.wait(0.1)
                v_u_5.CameraSubject = v40
            end
        else
            return
        end
    end
    local function v_u_42()
        -- upvalues: (ref) v_u_9, (ref) v_u_41
        if v_u_9 then
            v_u_9 = nil
        end
        v_u_41()
    end
    local function v_u_52(p_u_43)
        -- upvalues: (ref) v_u_18, (ref) v_u_9, (copy) v_u_5, (copy) v_u_4, (ref) v_u_13, (ref) v_u_15, (ref) v_u_8, (ref) v_u_39, (ref) v_u_19
        if not p_u_43 or v_u_18 then
            return false
        end
        v_u_18 = true
        if not p_u_43.Character then
            v_u_18 = false
            return false
        end
        local v_u_44 = p_u_43.Character:FindFirstChild("Humanoid")
        if not v_u_44 or v_u_44.Health <= 0 then
            v_u_18 = false
            return false
        end
        v_u_9 = p_u_43
        v_u_5.CameraType = Enum.CameraType.Custom
        v_u_5.CameraSubject = v_u_44
        v_u_4.CameraMode = Enum.CameraMode.Classic
        v_u_4.CameraMaxZoomDistance = 50
        v_u_4.CameraMinZoomDistance = 0.5
        if v_u_13 then
            local v45 = p_u_43.Team and (p_u_43.Team.Name or "No Team") or "No Team"
            local v46 = p_u_43.Team and p_u_43.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
            v_u_13.Text = string.format("%s [%s]", p_u_43.DisplayName, v45)
            v_u_13.TextColor3 = v46
        end
        if v_u_15 and v_u_44 then
            local v47 = v_u_44.Health / v_u_44.MaxHealth
            local v48 = math.clamp(v47, 0, 1)
            v_u_15.Size = UDim2.new(v48, 0, 1, 0)
            if v48 > 0.6 then
                v_u_15.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            elseif v48 > 0.3 then
                v_u_15.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
            else
                v_u_15.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            end
        end
        local v_u_49 = nil
        v_u_49 = v_u_44.Died:Connect(function()
            -- upvalues: (ref) v_u_49, (ref) v_u_9, (copy) p_u_43, (ref) v_u_8, (ref) v_u_39, (ref) v_u_19
            v_u_49:Disconnect()
            if v_u_9 == p_u_43 and v_u_8 then
                task.wait(1)
                if v_u_8 then
                    v_u_39()
                    v_u_19()
                end
            end
        end)
        v_u_44:GetPropertyChangedSignal("Health"):Connect(function()
            -- upvalues: (ref) v_u_15, (copy) v_u_44
            if v_u_15 and v_u_44 then
                local v50 = v_u_44.Health / v_u_44.MaxHealth
                local v51 = math.clamp(v50, 0, 1)
                v_u_15.Size = UDim2.new(v51, 0, 1, 0)
                if v51 > 0.6 then
                    v_u_15.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
                    return
                end
                if v51 > 0.3 then
                    v_u_15.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
                    return
                end
                v_u_15.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            end
        end)
        v_u_18 = false
        return true
    end
    v_u_19 = function()
        -- upvalues: (ref) v_u_8, (ref) v_u_18, (ref) v_u_17, (ref) v_u_10, (ref) v_u_39, (ref) v_u_13, (ref) v_u_42, (ref) v_u_11, (ref) v_u_52, (ref) v_u_16
        if v_u_8 and not v_u_18 then
            local v53 = tick()
            if v53 - v_u_17 >= 0.3 then
                v_u_17 = v53
                local v54
                if #v_u_10 == 0 then
                    v_u_39()
                    if #v_u_10 == 0 then
                        if v_u_13 then
                            v_u_13.Text = "No players alive"
                            v_u_13.TextColor3 = Color3.fromRGB(255, 255, 100)
                        end
                        v_u_42()
                        return
                    end
                    v54 = 0
                else
                    v54 = 0
                end
                while v54 < #v_u_10 do
                    v_u_11 = v_u_11 + 1
                    if v_u_11 > #v_u_10 then
                        v_u_11 = 1
                    end
                    local v55 = v_u_10[v_u_11]
                    if v55 and (v55.Player and v_u_52(v55.Player)) then
                        if v_u_16 then
                            v_u_16.Text = string.format("%d/%d", v_u_11, #v_u_10)
                        end
                        return
                    end
                    v54 = v54 + 1
                    task.wait(0.05)
                end
            end
        else
            return
        end
    end
    local function v_u_59()
        -- upvalues: (ref) v_u_8, (ref) v_u_18, (ref) v_u_17, (ref) v_u_10, (ref) v_u_39, (ref) v_u_13, (ref) v_u_42, (ref) v_u_11, (ref) v_u_52, (ref) v_u_16
        if v_u_8 and not v_u_18 then
            local v56 = tick()
            if v56 - v_u_17 >= 0.3 then
                v_u_17 = v56
                local v57
                if #v_u_10 == 0 then
                    v_u_39()
                    if #v_u_10 == 0 then
                        if v_u_13 then
                            v_u_13.Text = "No players alive"
                            v_u_13.TextColor3 = Color3.fromRGB(255, 255, 100)
                        end
                        v_u_42()
                        return
                    end
                    v57 = 0
                else
                    v57 = 0
                end
                while v57 < #v_u_10 do
                    v_u_11 = v_u_11 - 1
                    if v_u_11 < 1 then
                        v_u_11 = #v_u_10
                    end
                    local v58 = v_u_10[v_u_11]
                    if v58 and (v58.Player and v_u_52(v58.Player)) then
                        if v_u_16 then
                            v_u_16.Text = string.format("%d/%d", v_u_11, #v_u_10)
                        end
                        return
                    end
                    v57 = v57 + 1
                    task.wait(0.05)
                end
            end
        else
            return
        end
    end
    local function v_u_63()
        -- upvalues: (ref) v_u_8, (ref) v_u_12, (copy) v_u_27, (ref) v_u_14, (copy) v_u_4, (ref) v_u_39, (ref) v_u_10, (ref) v_u_13, (ref) v_u_11, (ref) v_u_52
        if v_u_8 then
            return
        else
            v_u_8 = true
            if not (v_u_12 and v_u_12.Parent) then
                v_u_27()
            end
            if v_u_14 then
                v_u_14.Visible = true
            end
            if v_u_4.Character then
                local v60 = v_u_4.Character:FindFirstChild("Humanoid")
                if v60 then
                    v60.WalkSpeed = 0
                    v60.JumpPower = 0
                end
                for _, v61 in ipairs(v_u_4.Character:GetDescendants()) do
                    if v61:IsA("BasePart") or v61:IsA("Decal") then
                        v61.Transparency = 1
                    end
                end
            end
            task.wait(0.5)
            v_u_39()
            if #v_u_10 == 0 then
                if v_u_13 then
                    v_u_13.Text = "No players alive"
                    v_u_13.TextColor3 = Color3.fromRGB(255, 255, 100)
                end
            else
                v_u_11 = 1
                local v62 = v_u_10[1]
                if v62 and v62.Player then
                    v_u_52(v62.Player)
                end
            end
        end
    end
    local function v_u_66()
        -- upvalues: (ref) v_u_8, (ref) v_u_41, (ref) v_u_14, (ref) v_u_42, (copy) v_u_4, (copy) v_u_5, (ref) v_u_9
        if v_u_8 then
            v_u_8 = false
            if v_u_14 then
                v_u_14.Visible = false
            end
            v_u_42()
            if not v_u_4.Character then
                v_u_4.CharacterAdded:Wait()
            end
            task.wait(0.2)
            if v_u_4.Character then
                local v64 = v_u_4.Character:FindFirstChild("Humanoid")
                if v64 then
                    v_u_5.CameraSubject = v64
                    v_u_5.CameraType = Enum.CameraType.Custom
                    v_u_4.CameraMode = Enum.CameraMode.Classic
                    task.wait(0.1)
                    v_u_5.CameraSubject = v64
                    if v64.Health > 0 then
                        v64.WalkSpeed = 16
                        v64.JumpPower = 50
                    end
                end
                for _, v65 in ipairs(v_u_4.Character:GetDescendants()) do
                    if v65:IsA("BasePart") or v65:IsA("Decal") then
                        v65.Transparency = 0
                    end
                end
            end
            v_u_9 = nil
        else
            v_u_41()
        end
    end
    v3.InputBegan:Connect(function(p67, p68)
        -- upvalues: (ref) v_u_8, (ref) v_u_59, (ref) v_u_19
        if p68 or not v_u_8 then
            return
        elseif p67.KeyCode == Enum.KeyCode.Left or p67.KeyCode == Enum.KeyCode.A then
            v_u_59()
        elseif p67.KeyCode == Enum.KeyCode.Right or p67.KeyCode == Enum.KeyCode.D then
            v_u_19()
        end
    end)
    v3.InputChanged:Connect(function(p69, p70)
        -- upvalues: (ref) v_u_8, (ref) v_u_59, (ref) v_u_19
        if not p70 and v_u_8 then
            if p69.UserInputType == Enum.UserInputType.MouseWheel then
                if p69.Position.Z > 0 then
                    v_u_59()
                    return
                end
                v_u_19()
            end
        end
    end)
    v6.OnClientEvent:Connect(function(p71, _)
        -- upvalues: (ref) v_u_63, (ref) v_u_66
        if p71 == "EnableSpectator" then
            v_u_63()
        elseif p71 == "DisableSpectator" then
            v_u_66()
        end
    end)
    v_u_4.CharacterAdded:Connect(function(p72)
        -- upvalues: (ref) v_u_8, (ref) v_u_66, (ref) v_u_41
        if v_u_8 then
            v_u_66()
        end
        p72:WaitForChild("Humanoid")
        task.wait(0.3)
        v_u_41()
    end)
    task.spawn(function()
        -- upvalues: (ref) v_u_8, (ref) v_u_39, (ref) v_u_9, (ref) v_u_10, (ref) v_u_52
        while true do
            while true do
                repeat
                    task.wait(2)
                until v_u_8
                v_u_39()
                if v_u_9 then
                    break
                end
                if #v_u_10 > 0 then
                    for _, v73 in ipairs(v_u_10) do
                        if v73.Player and v73.Player.Character then
                            local v74 = v73.Player.Character:FindFirstChild("Humanoid")
                            if v74 and v74.Health > 0 then
                                v_u_52(v73.Player)
                                break
                            end
                        end
                    end
                end
            end
            local v75 = false
            for _, v76 in ipairs(v_u_10) do
                if v76.Player == v_u_9 and v76.Player.Character then
                    local v77 = v76.Player.Character:FindFirstChild("Humanoid")
                    if v77 and v77.Health > 0 then
                        v75 = true
                        break
                    end
                end
            end
            if not v75 then
                for _, v78 in ipairs(v_u_10) do
                    if v78.Player and v78.Player.Character then
                        local v79 = v78.Player.Character:FindFirstChild("Humanoid")
                        if v79 and v79.Health > 0 then
                            v_u_52(v78.Player)
                        end
                    end
                end
            end
        end
    end)
    task.wait(1)
    v_u_27()
end
-- Script Path: game:GetService("Players").bebramen22090.PlayerScripts.LocalScript3
-- Took 0s to decompile.
-- Executor: Delta (1.1.711.876)

local v1 = game:GetService("Players").LocalPlayer
local v2 = game:GetService("AvatarEditorService")
if v1 then
    v2:PromptSetFavorite(game.PlaceId, Enum.AvatarItemType.Asset, true)
end
-- Script Path: game:GetService("Players").bebramen22090.PlayerScripts.LocalScript4
-- Took 0s to decompile.
-- Executor: Delta (1.1.711.876)

local v1 = game:GetService("Players").LocalPlayer
local v_u_2 = nil
local function v5(p3)
    -- upvalues: (ref) v_u_2
    if v_u_2 then
        v_u_2:Disconnect()
        v_u_2 = nil
    end
    local v_u_4 = p3:WaitForChild("Humanoid", 5)
    if v_u_4 then
        v_u_4.JumpPower = 30
        v_u_4.UseJumpPower = true
        v_u_2 = v_u_4:GetPropertyChangedSignal("JumpPower"):Connect(function()
            -- upvalues: (copy) v_u_4
            if v_u_4.JumpPower ~= 30 then
                v_u_4.JumpPower = 30
            end
        end)
    end
end
if v1.Character then
    v5(v1.Character)
end
v1.CharacterAdded:Connect(v5)
-- Script Path: game:GetService("Players").bebramen22090.PlayerScripts.LocalScript5
-- Took 0.01s to decompile.
-- Executor: Delta (1.1.711.876)

local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = game:GetService("TweenService")
game:GetService("Debris")
local v_u_4 = v2.LocalPlayer
local v5 = v_u_4:WaitForChild("PlayerGui")
local v6 = v1:WaitForChild("kfd")
local v_u_7 = {
    ["AWP"] = "rbxassetid://139265934828410",
    ["Zeus x27"] = "rbxassetid://80630992676238",
    ["Headshot"] = "rbxassetid://101980367890591",
    ["AirKill"] = "rbxassetid://124386298743066"
}
local v_u_8 = {
    ["LIFETIME"] = 5,
    ["FADE_TIME"] = 0.5,
    ["MAX_ITEMS"] = 6
}
local v_u_9 = {
    ["BG"] = Color3.fromRGB(45, 45, 50),
    ["BORDER_RED"] = Color3.fromRGB(220, 20, 20),
    ["KILLER_BLUE"] = Color3.fromRGB(100, 150, 255),
    ["VICTIM_YELLOW"] = Color3.fromRGB(255, 200, 80),
    ["WHITE"] = Color3.fromRGB(255, 255, 255)
}
local v10 = Instance.new("ScreenGui")
v10.Name = "CleanKillFeed"
v10.ResetOnSpawn = false
v10.IgnoreGuiInset = true
v10.Parent = v5
local v_u_11 = Instance.new("Frame")
v_u_11.Name = "FeedContainer"
v_u_11.Size = UDim2.new(0, 300, 0.5, 0)
v_u_11.Position = UDim2.new(1, -10, 0, 40)
v_u_11.AnchorPoint = Vector2.new(1, 0)
v_u_11.BackgroundTransparency = 1
v_u_11.Parent = v10
local v12 = Instance.new("UIListLayout")
v12.Parent = v_u_11
v12.SortOrder = Enum.SortOrder.LayoutOrder
v12.VerticalAlignment = Enum.VerticalAlignment.Top
v12.HorizontalAlignment = Enum.HorizontalAlignment.Right
v12.Padding = UDim.new(0, 4)
v6.OnClientEvent:Connect(function(p13, p14, p15, p16, p17)
    -- upvalues: (copy) v_u_11, (copy) v_u_8, (copy) v_u_9, (copy) v_u_4, (copy) v_u_7, (copy) v_u_3
    local v18 = {}
    local v19 = p16 or "AWP"
    for _, v20 in ipairs(v_u_11:GetChildren()) do
        if v20:IsA("Frame") then
            table.insert(v18, v20)
        end
    end
    if #v18 >= v_u_8.MAX_ITEMS then
        v18[1]:Destroy()
    end
    local v_u_21 = Instance.new("Frame")
    v_u_21.Name = "Entry"
    v_u_21.Size = UDim2.new(0, 0, 0, 24)
    v_u_21.AutomaticSize = Enum.AutomaticSize.X
    v_u_21.BackgroundColor3 = v_u_9.BG
    v_u_21.BackgroundTransparency = 0.3
    v_u_21.BorderSizePixel = 0
    local v22 = Instance.new("UICorner")
    v22.CornerRadius = UDim.new(0, 4)
    v22.Parent = v_u_21
    local v_u_23 = Instance.new("UIStroke")
    v_u_23.Thickness = 1
    v_u_23.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    v_u_23.Color = v_u_9.BORDER_RED
    if p13 == v_u_4.Name then
        v_u_23.Enabled = true
        v_u_21.BackgroundTransparency = 0.15
    else
        v_u_23.Enabled = false
    end
    v_u_23.Parent = v_u_21
    local v24 = Instance.new("UIListLayout")
    v24.FillDirection = Enum.FillDirection.Horizontal
    v24.VerticalAlignment = Enum.VerticalAlignment.Center
    v24.HorizontalAlignment = Enum.HorizontalAlignment.Center
    v24.SortOrder = Enum.SortOrder.LayoutOrder
    v24.Padding = UDim.new(0, 6)
    v24.Parent = v_u_21
    local v25 = Instance.new("UIPadding")
    v25.PaddingLeft = UDim.new(0, 8)
    v25.PaddingRight = UDim.new(0, 8)
    v25.Parent = v_u_21
    local v26 = Instance.new("TextLabel")
    v26.LayoutOrder = 1
    v26.Text = p13
    v26.Font = Enum.Font.GothamBold
    v26.TextSize = 13
    v26.TextColor3 = v_u_9.KILLER_BLUE
    v26.BackgroundTransparency = 1
    v26.AutomaticSize = Enum.AutomaticSize.XY
    v26.Parent = v_u_21
    if p17 then
        local v27 = Instance.new("ImageLabel")
        v27.LayoutOrder = 2
        v27.Image = v_u_7.AirKill
        v27.BackgroundTransparency = 1
        v27.ScaleType = Enum.ScaleType.Crop
        v27.ImageColor3 = v_u_9.WHITE
        v27.Size = UDim2.new(0, 20, 0, 20)
        v27.Parent = v_u_21
    end
    local v28 = Instance.new("ImageLabel")
    v28.LayoutOrder = 3
    v28.Image = v_u_7[v19] or v_u_7.AWP
    v28.BackgroundTransparency = 1
    v28.ScaleType = Enum.ScaleType.Crop
    v28.ImageColor3 = v_u_9.WHITE
    v28.Size = UDim2.new(0, 42, 0, 20)
    v28.Parent = v_u_21
    local v29 = 4
    if p15 then
        local v30 = Instance.new("ImageLabel")
        v30.LayoutOrder = v29
        v30.Image = v_u_7.Headshot
        v30.BackgroundTransparency = 1
        v30.ScaleType = Enum.ScaleType.Crop
        v30.ImageColor3 = v_u_9.WHITE
        v30.Size = UDim2.new(0, 20, 0, 20)
        v30.Parent = v_u_21
        v29 = v29 + 1
    end
    local v31 = Instance.new("TextLabel")
    v31.LayoutOrder = v29
    v31.Text = p14
    v31.Font = Enum.Font.GothamBold
    v31.TextSize = 13
    v31.TextColor3 = v_u_9.VICTIM_YELLOW
    v31.BackgroundTransparency = 1
    v31.AutomaticSize = Enum.AutomaticSize.XY
    v31.Parent = v_u_21
    v_u_21.Parent = v_u_11
    task.delay(v_u_8.LIFETIME, function()
        -- upvalues: (copy) v_u_21, (ref) v_u_8, (ref) v_u_3, (copy) v_u_23
        if v_u_21.Parent then
            local v32 = TweenInfo.new(v_u_8.FADE_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            v_u_3:Create(v_u_21, v32, {
                ["BackgroundTransparency"] = 1
            }):Play()
            if v_u_23.Enabled then
                v_u_3:Create(v_u_23, v32, {
                    ["Transparency"] = 1
                }):Play()
            end
            for _, v33 in pairs(v_u_21:GetDescendants()) do
                if v33:IsA("TextLabel") then
                    v_u_3:Create(v33, v32, {
                        ["TextTransparency"] = 1
                    }):Play()
                elseif v33:IsA("ImageLabel") then
                    v_u_3:Create(v33, v32, {
                        ["ImageTransparency"] = 1
                    }):Play()
                end
            end
            task.wait(v_u_8.FADE_TIME)
            v_u_21:Destroy()
        end
    end)
end)
-- Script Path: game:GetService("Players").bebramen22090.PlayerScripts.PlayerScriptsLoader
-- Took 0s to decompile.
-- Executor: Delta (1.1.711.876)

require(script.Parent:WaitForChild("PlayerModule"))

local v_u_1 = game:GetService("TweenService")
local v_u_2 = game:GetService("Players")
local v3 = game:GetService("UserInputService")
local v4 = game:GetService("RunService")
local v_u_5 = game:GetService("ReplicatedStorage")
local v_u_6 = game:GetService("Debris")
local v_u_7 = script.Parent
local v_u_8 = v_u_2.LocalPlayer
local v_u_9 = v_u_7:WaitForChild("Configuration")
local v10 = v_u_7:WaitForChild("Remotes")
local v_u_11 = v10:WaitForChild("FireShot")
local v12 = v10:WaitForChild("PlaySound")
local v13 = v_u_5:WaitForChild("eve")
local v_u_14 = script:WaitForChild("GunGui")
local v_u_15 = true
local v_u_16 = false
local v_u_17 = false
local v_u_18 = nil
local v_u_19 = nil
local v_u_20 = false
local v_u_21 = Vector3.new(0, 0, 0)
local v_u_22 = workspace.CurrentCamera
local v_u_23 = nil
local v_u_24 = nil
local v_u_25 = nil
local v_u_26 = false
local v_u_27 = true
local v_u_28 = nil
local function v_u_85()
	-- upvalues: (ref) v_u_26, (copy) v_u_8, (copy) v_u_5, (copy) v_u_1, (ref) v_u_27, (ref) v_u_17, (ref) v_u_25
	if not v_u_26 then
		local v29 = v_u_8:WaitForChild("PlayerGui")
		if v29:FindFirstChild("crosshairrxd") then
			v29.crosshairrxd:Destroy()
		end
		local v30 = Color3.fromRGB(255, 255, 255)
		local v31 = nil
		local v32 = v_u_5:FindFirstChild("cfgg")
		local v33
		if v32 then
			v33 = v32:FindFirstChild("cross")
			if v33 then
				v30 = v33.Value
			else
				v33 = v31
			end
		else
			v33 = v31
		end
		local v_u_34 = {
			["LineColor"] = v30,
			["LineThickness"] = 1,
			["NoScopeLength"] = 0,
			["NoScopeGap"] = 0,
			["NoScopeOpacity"] = 1,
			["ScopeLength"] = 80,
			["ScopeGap"] = 8,
			["ScopeOpacity"] = 0.3,
			["RecoilLength"] = 95,
			["RecoilGap"] = 10,
			["ScopeTransitionTime"] = 0.15,
			["RecoilTransitionTime"] = 0.06,
			["RecoveryTransitionTime"] = 0.1,
			["ScopeEasing"] = Enum.EasingStyle.Quad,
			["RecoilEasing"] = Enum.EasingStyle.Quad
		}
		local v_u_35 = Instance.new("ScreenGui")
		v_u_35.Name = "crosshairrxd"
		v_u_35.ResetOnSpawn = false
		v_u_35.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		v_u_35.IgnoreGuiInset = true
		v_u_35.Enabled = false
		v_u_35.Parent = v29
		local v_u_36 = Instance.new("Frame")
		v_u_36.Name = "MainFrame"
		v_u_36.Size = UDim2.new(0, 200, 0, 200)
		v_u_36.Position = UDim2.new(0.5, 0, 0.5, 0)
		v_u_36.AnchorPoint = Vector2.new(0.5, 0.5)
		v_u_36.BackgroundTransparency = 1
		v_u_36.Parent = v_u_35
		local v_u_37 = "noscope"
		local v_u_38 = false
		local v_u_39 = false
		local v_u_40 = {}
		local function v49(p41, p42)
			-- upvalues: (copy) v_u_36, (copy) v_u_34
			local v43 = Instance.new("Frame")
			v43.Name = p41
			v43.Size = UDim2.new(0, 200, 0, 200)
			v43.Position = UDim2.new(0.5, 0, 0.5, 0)
			v43.AnchorPoint = Vector2.new(0.5, 0.5)
			v43.BackgroundTransparency = 1
			v43.Parent = v_u_36
			local v44 = nil
			local v45 = nil
			local v46 = nil
			if p42 == "top" then
				v44 = UDim2.new(0, v_u_34.LineThickness, 0, v_u_34.NoScopeLength)
				v45 = UDim2.new(0.5, 0, 0.5, -v_u_34.NoScopeGap)
				v46 = Vector2.new(0.5, 1)
			elseif p42 == "bottom" then
				v44 = UDim2.new(0, v_u_34.LineThickness, 0, v_u_34.NoScopeLength)
				v45 = UDim2.new(0.5, 0, 0.5, v_u_34.NoScopeGap)
				v46 = Vector2.new(0.5, 0)
			elseif p42 == "left" then
				v44 = UDim2.new(0, v_u_34.NoScopeLength, 0, v_u_34.LineThickness)
				v45 = UDim2.new(0.5, -v_u_34.NoScopeGap, 0.5, 0)
				v46 = Vector2.new(1, 0.5)
			elseif p42 == "right" then
				v44 = UDim2.new(0, v_u_34.NoScopeLength, 0, v_u_34.LineThickness)
				v45 = UDim2.new(0.5, v_u_34.NoScopeGap, 0.5, 0)
				v46 = Vector2.new(0, 0.5)
			end
			local v47 = Instance.new("Frame")
			v47.Name = "Line"
			v47.Size = v44
			v47.Position = v45
			v47.AnchorPoint = v46
			v47.BackgroundColor3 = v_u_34.LineColor
			v47.BorderSizePixel = 0
			v47.BackgroundTransparency = v_u_34.ScopeOpacity
			v47.ZIndex = 2
			v47.Parent = v43
			local v48 = Instance.new("UIGradient")
			v48.Name = "LineGradient"
			v48.Parent = v47
			v48.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.6, 0),
				NumberSequenceKeypoint.new(0.85, 0.4),
				NumberSequenceKeypoint.new(1, 1)
			})
			if p42 == "top" then
				v48.Rotation = 270
			elseif p42 == "bottom" then
				v48.Rotation = 90
			elseif p42 == "left" then
				v48.Rotation = 180
			elseif p42 == "right" then
				v48.Rotation = 0
			end
			return {
				["Container"] = v43,
				["Line"] = v47,
				["Direction"] = p42
			}
		end
		local v_u_50 = {
			["top"] = v49("TopLine", "top"),
			["bottom"] = v49("BottomLine", "bottom"),
			["left"] = v49("LeftLine", "left"),
			["right"] = v49("RightLine", "right")
		}
		if v33 then
			v33.Changed:Connect(function(p51)
				-- upvalues: (copy) v_u_50
				for _, v52 in pairs(v_u_50) do
					v52.Line.BackgroundColor3 = p51
				end
			end)
		end
		local function v_u_54()
			-- upvalues: (ref) v_u_40
			for _, v53 in pairs(v_u_40) do
				if v53 then
					v53:Cancel()
				end
			end
			v_u_40 = {}
		end
		local function v_u_66(p55, p56, p57, p58, p59)
			-- upvalues: (copy) v_u_34, (ref) v_u_1, (ref) v_u_40
			local v60 = p55.Direction
			local v61 = p55.Line
			local v62 = nil
			local v63 = nil
			if v60 == "top" then
				v62 = UDim2.new(0, v_u_34.LineThickness, 0, p56)
				v63 = UDim2.new(0.5, 0, 0.5, -p57)
			elseif v60 == "bottom" then
				v62 = UDim2.new(0, v_u_34.LineThickness, 0, p56)
				v63 = UDim2.new(0.5, 0, 0.5, p57)
			elseif v60 == "left" then
				v62 = UDim2.new(0, p56, 0, v_u_34.LineThickness)
				v63 = UDim2.new(0.5, -p57, 0.5, 0)
			elseif v60 == "right" then
				v62 = UDim2.new(0, p56, 0, v_u_34.LineThickness)
				v63 = UDim2.new(0.5, p57, 0.5, 0)
			end
			if p59 then
				local v64 = v_u_1:Create(v61, p59, {
					["Size"] = v62,
					["Position"] = v63,
					["BackgroundTransparency"] = p58
				})
				local v65 = v_u_40
				table.insert(v65, v64)
				v64:Play()
			else
				v61.Size = v62
				v61.Position = v63
				v61.BackgroundTransparency = p58
			end
		end
		local function v_u_70(p67)
			-- upvalues: (ref) v_u_37, (copy) v_u_54, (copy) v_u_34, (copy) v_u_50, (copy) v_u_66
			if v_u_37 ~= "noscope" or p67 then
				v_u_37 = "noscope"
				v_u_54()
				local v68 = TweenInfo.new(v_u_34.ScopeTransitionTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				for _, v69 in pairs(v_u_50) do
					v_u_66(v69, v_u_34.NoScopeLength, v_u_34.NoScopeGap, 1, v68)
				end
			end
		end
		local function v_u_74(p71)
			-- upvalues: (ref) v_u_37, (copy) v_u_54, (copy) v_u_34, (copy) v_u_50, (copy) v_u_66
			if v_u_37 ~= "scope" or p71 then
				v_u_37 = "scope"
				v_u_54()
				local v72 = TweenInfo.new(v_u_34.ScopeTransitionTime, v_u_34.ScopeEasing, Enum.EasingDirection.Out)
				for _, v73 in pairs(v_u_50) do
					v_u_66(v73, v_u_34.ScopeLength, v_u_34.ScopeGap, v_u_34.ScopeOpacity, v72)
				end
			end
		end
		local function v_u_80()
			-- upvalues: (ref) v_u_39, (copy) v_u_54, (copy) v_u_34, (copy) v_u_50, (copy) v_u_66, (ref) v_u_38, (ref) v_u_37
			if not v_u_39 then
				v_u_39 = true
				v_u_54()
				local v75 = TweenInfo.new(v_u_34.RecoilTransitionTime, v_u_34.RecoilEasing, Enum.EasingDirection.Out)
				for _, v76 in pairs(v_u_50) do
					v_u_66(v76, v_u_34.RecoilLength, v_u_34.RecoilGap, v_u_34.ScopeOpacity, v75)
				end
				task.delay(v_u_34.RecoilTransitionTime, function()
					-- upvalues: (ref) v_u_39, (ref) v_u_34, (ref) v_u_38, (ref) v_u_50, (ref) v_u_66, (ref) v_u_37
					if v_u_39 then
						local v77 = TweenInfo.new(v_u_34.RecoveryTransitionTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
						if v_u_38 then
							for _, v78 in pairs(v_u_50) do
								v_u_66(v78, v_u_34.ScopeLength, v_u_34.ScopeGap, v_u_34.ScopeOpacity, v77)
							end
							v_u_37 = "scope"
						else
							for _, v79 in pairs(v_u_50) do
								v_u_66(v79, v_u_34.NoScopeLength, v_u_34.NoScopeGap, 1, v77)
							end
							v_u_37 = "noscope"
						end
						v_u_39 = false
					end
				end)
			end
		end
		local function v84()
			-- upvalues: (ref) v_u_5, (ref) v_u_27, (ref) v_u_17, (copy) v_u_35, (copy) v_u_70
			local v81 = v_u_5:FindFirstChild("cfgg")
			local v82 = v81 and v81:FindFirstChild("scope")
			local v83
			if v82 then
				v_u_27 = v82.Value
				v83 = v_u_27
			else
				v83 = true
			end
			if v83 then
				if v_u_17 then
					v_u_35.Enabled = true
					v_u_70(true)
				end
			else
				return
			end
		end
		v_u_70(true)
		v_u_25 = {
			["Show"] = v84,
			["Hide"] = function()
				-- upvalues: (copy) v_u_35, (ref) v_u_38
				v_u_35.Enabled = false
				v_u_38 = false
			end,
			["EnableScope"] = function()
				-- upvalues: (ref) v_u_38, (copy) v_u_74
				v_u_38 = true
				v_u_74(false)
			end,
			["DisableScope"] = function()
				-- upvalues: (ref) v_u_38, (copy) v_u_70
				v_u_38 = false
				v_u_70(false)
			end,
			["TriggerRecoil"] = function()
				-- upvalues: (ref) v_u_39, (ref) v_u_38, (copy) v_u_80
				if not v_u_39 and v_u_38 then
					task.spawn(v_u_80)
				end
			end,
			["Gui"] = v_u_35,
			["IsScoping"] = function()
				-- upvalues: (ref) v_u_38
				return v_u_38
			end
		}
		v_u_26 = true
	end
end
local function v_u_95()
	-- upvalues: (ref) v_u_17, (copy) v_u_14, (copy) v_u_7, (copy) v_u_8
	if v_u_17 and v_u_14 then
		local v86 = v_u_14:FindFirstChild("Frame")
		if v86 then
			local v87 = v_u_7:FindFirstChild("Ammo_" .. v_u_8.UserId)
			local v88 = v_u_7:FindFirstChild("StoredAmmo_" .. v_u_8.UserId)
			if v87 and v88 then
				if v86:FindFirstChild("AmmoInMag") then
					local v89 = v86.AmmoInMag
					local v90 = v87.Value
					v89.Text = tostring(v90)
				end
				if v86:FindFirstChild("AmmoInMagShadow") then
					local v91 = v86.AmmoInMagShadow
					local v92 = v87.Value
					v91.Text = tostring(v92)
				end
				if v86:FindFirstChild("why") then
					local v93 = v86.why
					local v94 = v88.Value
					v93.Text = " /" .. tostring(v94)
				end
			end
		end
	else
		return
	end
end
local function v_u_98(p96)
	-- upvalues: (copy) v_u_7
	for _, v97 in pairs(v_u_7:GetDescendants()) do
		if v97:IsA("BasePart") then
			v97.Transparency = p96 and 0 or 1
		end
	end
end
local function v_u_101()
	-- upvalues: (ref) v_u_24, (ref) v_u_18, (ref) v_u_19
	if v_u_24 then
		if not v_u_18 then
			local v99 = Instance.new("Animation")
			v99.AnimationId = "rbxassetid://100951147520925"
			v_u_18 = v_u_24:LoadAnimation(v99)
		end
		if not v_u_19 then
			local v100 = Instance.new("Animation")
			v100.AnimationId = "rbxassetid://79820033925854"
			v_u_19 = v_u_24:LoadAnimation(v100)
		end
	end
end
local function v_u_105()
	-- upvalues: (ref) v_u_16, (copy) v_u_7, (copy) v_u_8, (ref) v_u_15, (copy) v_u_9, (copy) v_u_95
	if v_u_16 then
		return
	else
		local v102 = v_u_7:FindFirstChild("Ammo_" .. v_u_8.UserId)
		local v103 = v_u_7:FindFirstChild("StoredAmmo_" .. v_u_8.UserId)
		if v102 and v103 then
			if v102.Value < 10 and v103.Value > 0 then
				v_u_16 = true
				v_u_15 = false
				if v_u_7:FindFirstChild("Handle") and v_u_7.Handle:FindFirstChild("Reload") then
					v_u_7.Handle.Reload:Play()
				end
				task.wait(v_u_9.ReloadTime.Value)
				local v104 = 10 - v102.Value
				if v103.Value < v104 then
					v102.Value = v102.Value + v103.Value
					v103.Value = 0
				else
					v102.Value = v102.Value + v104
					v103.Value = v103.Value - v104
				end
				v_u_95()
				v_u_15 = true
				v_u_16 = false
			end
		else
			return
		end
	end
end
local function v_u_122()
	-- upvalues: (ref) v_u_15, (ref) v_u_16, (copy) v_u_8, (copy) v_u_7, (ref) v_u_23, (ref) v_u_21, (ref) v_u_25, (copy) v_u_2, (copy) v_u_11, (copy) v_u_95, (copy) v_u_6, (copy) v_u_9, (copy) v_u_105
	if v_u_15 and not v_u_16 then
		local v106 = v_u_8:GetMouse()
		local v107 = v_u_7:FindFirstChild("Ammo_" .. v_u_8.UserId)
		if v107 and v_u_23 then
			if v107.Value > 0 then
				v_u_15 = false
				local v108 = v_u_21
				local v109 = math.random(-1.5, 1.5)
				v_u_21 = v108 + Vector3.new(v109, 3, 0)
				if v_u_25 and v_u_25.TriggerRecoil then
					v_u_25.TriggerRecoil()
				end
				local v110 = Ray.new(v_u_7.Handle.Position, (v106.Hit.Position - v_u_7.Handle.Position).Unit * 2048)
				local v111, v112 = workspace:FindPartOnRay(v110, v_u_23, false, true)
				local v113 = nil
				local v114 = nil
				if v111 and v111.Parent then
					local v115 = v111.Parent
					if v115:FindFirstChild("Humanoid") then
						v113 = v_u_2:GetPlayerFromCharacter(v115)
						v114 = v111
					elseif v111.Parent.Parent:FindFirstChild("Humanoid") then
						v113 = v_u_2:GetPlayerFromCharacter(v111.Parent.Parent)
						v114 = v111
					end
				end
				v_u_11:FireServer(v110, v112, v113, v114)
				v107.Value = v107.Value - 1
				v_u_95()
				local v116 = Instance.new("Part")
				v116.BrickColor = BrickColor.new("Bright red")
				v116.FormFactor = Enum.FormFactor.Custom
				v116.Material = Enum.Material.Neon
				v116.Transparency = 1
				v116.Anchored = true
				v116.CanCollide = false
				v116.Parent = workspace
				v_u_6:AddItem(v116, v_u_9.Firerate.Value + 0.1)
				local v117 = (v_u_7.Handle.Position - v112).Magnitude
				v116.Size = Vector3.new(0.3, 0.3, v117)
				v116.CFrame = CFrame.new(v_u_7.Handle.Position, v112) * CFrame.new(0, 0, -v117 / 2)
				if v111 then
					local v118 = not v111.Parent:FindFirstChildOfClass("Humanoid") and v111.Parent.Parent
					if v118 then
						v118 = v111.Parent.Parent:FindFirstChildOfClass("Humanoid")
					end
					if v118 then
						if v111.Name == "Head" then
							script.Headshot:Play()
						else
							script.HitMarker:Play()
						end
					end
				end
				task.wait(v_u_9.Firerate.Value)
				local v119 = Instance.new("Sound")
				v119.SoundId = "rbxassetid://" .. 138656898889366
				v119.Volume = 0.5
				v119.Parent = workspace
				v119:Play()
				v_u_6:AddItem(v119, 5)
				v_u_15 = true
			else
				if v_u_7:FindFirstChild("Handle") and v_u_7.Handle:FindFirstChild("Empty") then
					v_u_7.Handle.Empty:Play()
				end
				local v120 = v_u_7:FindFirstChild("Ammo_" .. v_u_8.UserId)
				local v121 = v_u_7:FindFirstChild("StoredAmmo_" .. v_u_8.UserId)
				if v120 and (v121 and (v120.Value <= 0 and v121.Value > 0)) then
					v_u_105()
				end
			end
		else
			return
		end
	else
		return
	end
end
v3.InputBegan:Connect(function(p123, p124)
	-- upvalues: (ref) v_u_17, (ref) v_u_16, (copy) v_u_105, (copy) v_u_5, (ref) v_u_27, (ref) v_u_20, (ref) v_u_25, (copy) v_u_122
	if v_u_17 then
		if p123.KeyCode == Enum.KeyCode.R and not (p124 or v_u_16) then
			v_u_105()
		end
		if not p124 and (p123.UserInputType == Enum.UserInputType.MouseButton2 or p123.KeyCode == Enum.KeyCode.LeftControl) then
			local v125 = v_u_5:FindFirstChild("cfgg")
			local v126 = v125 and v125:FindFirstChild("scope")
			local v127
			if v126 then
				v_u_27 = v126.Value
				v127 = v_u_27
			else
				v127 = true
			end
			if not v127 then
				return
			end
			v_u_20 = not v_u_20
			if v_u_20 then
				if v_u_25 then
					v_u_25.EnableScope()
				end
			elseif v_u_25 then
				v_u_25.DisableScope()
			end
		end
		if p123.UserInputType == Enum.UserInputType.MouseButton1 and not p124 then
			v_u_122()
		end
	end
end)
v_u_7.Equipped:Connect(function(p128)
	-- upvalues: (ref) v_u_23, (copy) v_u_8, (ref) v_u_24, (ref) v_u_17, (ref) v_u_20, (ref) v_u_28, (ref) v_u_21, (copy) v_u_6, (ref) v_u_26, (copy) v_u_85, (copy) v_u_5, (ref) v_u_27, (ref) v_u_25, (copy) v_u_14, (copy) v_u_95, (copy) v_u_101, (ref) v_u_18, (ref) v_u_19, (copy) v_u_22, (copy) v_u_98
	v_u_23 = v_u_8.Character or v_u_8.CharacterAdded:Wait()
	v_u_24 = v_u_23:WaitForChild("Humanoid")
	p128.Icon = ""
	v_u_17 = true
	v_u_20 = false
	v_u_28 = nil
	v_u_21 = Vector3.new(0, 0, 0)
	local v129 = Instance.new("Sound")
	v129.SoundId = "rbxassetid://" .. 138656898889366
	v129.Volume = 0.5
	v129.Parent = workspace
	v129:Play()
	v_u_6:AddItem(v129, 5)
	if not v_u_26 then
		v_u_85()
	end
	local v130 = v_u_5:FindFirstChild("cfgg")
	local v131 = v130 and v130:FindFirstChild("scope")
	local v132
	if v131 then
		v_u_27 = v131.Value
		v132 = v_u_27
	else
		v132 = true
	end
	if v132 and v_u_25 then
		v_u_25.Show()
	end
	if v_u_14 then
		v_u_14.Parent = v_u_8:WaitForChild("PlayerGui")
	end
	v_u_95()
	v_u_101()
	if v_u_18 then
		v_u_18:Play()
		task.delay(v_u_18.Length * 0.95, function()
			-- upvalues: (ref) v_u_17, (ref) v_u_19
			if v_u_17 and v_u_19 then
				v_u_19:Play()
				v_u_19.Looped = true
			end
		end)
	end
	local v133
	if v_u_23 then
		local v134 = v_u_23:FindFirstChild("Head")
		if v134 and v_u_22 then
			v133 = (v134.Position - v_u_22.CFrame.Position).Magnitude < 3
		else
			v133 = false
		end
	else
		v133 = false
	end
	if v133 ~= v_u_28 then
		v_u_28 = v133
		v_u_98(not v133)
	end
end)
v_u_7.Unequipped:Connect(function()
	-- upvalues: (copy) v_u_8, (ref) v_u_17, (ref) v_u_16, (ref) v_u_20, (ref) v_u_25, (copy) v_u_14, (ref) v_u_18, (ref) v_u_19
	local v135 = v_u_8:GetMouse()
	if v135 then
		v135.Icon = ""
	end
	v_u_17 = false
	v_u_16 = false
	v_u_20 = false
	if v_u_25 then
		v_u_25.Hide()
	end
	if v_u_14 then
		v_u_14.Parent = script
	end
	if v_u_18 then
		v_u_18:Stop()
	end
	if v_u_19 then
		v_u_19:Stop()
	end
end)
v12.OnClientEvent:Connect(function(p136)
	-- upvalues: (copy) v_u_6
	local v137 = Instance.new("Sound")
	v137.SoundId = p136
	v137.Volume = 0.5
	v137.Parent = workspace
	v137:Play()
	v_u_6:AddItem(v137, 5)
end)
v_u_11.OnClientEvent:Connect(function()
	-- upvalues: (ref) v_u_21, (ref) v_u_25, (copy) v_u_95
	local v138 = v_u_21
	local v139 = math.random(-1.5, 1.5)
	v_u_21 = v138 + Vector3.new(v139, 3, 0)
	if v_u_25 then
		v_u_25.TriggerRecoil()
	end
	task.spawn(v_u_95)
end)
v10.Scope.OnClientEvent:Connect(function()
	-- upvalues: (ref) v_u_17, (copy) v_u_5, (ref) v_u_27, (ref) v_u_25, (ref) v_u_20
	if v_u_17 then
		local v140 = v_u_5:FindFirstChild("cfgg")
		local v141 = v140 and v140:FindFirstChild("scope")
		local v142
		if v141 then
			v_u_27 = v141.Value
			v142 = v_u_27
		else
			v142 = true
		end
		if v142 then
			if v_u_25 then
				v_u_25.DisableScope()
				v_u_20 = false
			end
			return
		end
	end
end)
v13.Event:Connect(function()
	-- upvalues: (ref) v_u_17, (copy) v_u_5, (ref) v_u_27, (ref) v_u_26, (copy) v_u_85, (ref) v_u_25
	if v_u_17 then
		local v143 = v_u_5:FindFirstChild("cfgg")
		local v144 = v143 and v143:FindFirstChild("scope")
		local v145
		if v144 then
			v_u_27 = v144.Value
			v145 = v_u_27
		else
			v145 = true
		end
		if v145 then
			if not v_u_26 then
				v_u_85()
			end
			if v_u_25 and not v_u_25.Gui.Enabled then
				v_u_25.Show()
			end
			return
		end
	end
end)
v4.RenderStepped:Connect(function(p146)
	-- upvalues: (ref) v_u_17, (ref) v_u_23, (copy) v_u_22, (ref) v_u_28, (copy) v_u_98, (ref) v_u_21
	if v_u_17 then
		local v147
		if v_u_23 then
			local v148 = v_u_23:FindFirstChild("Head")
			if v148 and v_u_22 then
				v147 = (v148.Position - v_u_22.CFrame.Position).Magnitude < 3
			else
				v147 = false
			end
		else
			v147 = false
		end
		if v147 ~= v_u_28 then
			v_u_28 = v147
			v_u_98(not v147)
		end
		v_u_21 = v_u_21:Lerp(Vector3.new(0, 0, 0), p146 * 8)
	end
end)
v_u_8.CharacterAdded:Connect(function(p149)
	-- upvalues: (ref) v_u_23, (ref) v_u_24, (ref) v_u_17, (ref) v_u_16, (ref) v_u_15, (ref) v_u_20, (copy) v_u_8, (ref) v_u_25, (ref) v_u_26
	v_u_23 = p149
	v_u_24 = p149:WaitForChild("Humanoid")
	v_u_17 = false
	v_u_16 = false
	v_u_15 = true
	v_u_20 = false
	local v150 = v_u_8:FindFirstChild("PlayerGui")
	local v151 = v150 and v150:FindFirstChild("crosshairrxd")
	if v151 then
		v151:Destroy()
	end
	v_u_25 = nil
	v_u_26 = false
	v_u_20 = false
	v_u_24.Died:Connect(function()
		-- upvalues: (ref) v_u_17, (ref) v_u_20, (ref) v_u_8, (ref) v_u_25, (ref) v_u_26
		v_u_17 = false
		v_u_20 = false
		local v152 = v_u_8:FindFirstChild("PlayerGui")
		local v153 = v152 and v152:FindFirstChild("crosshairrxd")
		if v153 then
			v153:Destroy()
		end
		v_u_25 = nil
		v_u_26 = false
		v_u_20 = false
	end)
end)
local v154 = v_u_7:FindFirstChild("Ammo_" .. v_u_8.UserId)
local v155 = v_u_7:FindFirstChild("StoredAmmo_" .. v_u_8.UserId)
if v154 then
	v154.Changed:Connect(function()
		-- upvalues: (ref) v_u_17, (copy) v_u_95
		if v_u_17 then
			v_u_95()
		end
	end)
end
if v155 then
	v155.Changed:Connect(function()
		-- upvalues: (ref) v_u_17, (copy) v_u_95
		if v_u_17 then
			v_u_95()
		end
	end)
end

local script = game:GetService("Players").LocalPlayer:WaitForChild("LocalScript")
local v_u_1 = game:GetService("TweenService")
local v_u_2 = game:GetService("Players")
local v3 = game:GetService("RunService")
local v_u_4 = game:GetService("Workspace")
local v_u_5 = v_u_4.CurrentCamera
local v6 = game:GetService("ReplicatedStorage")
local v_u_7 = v_u_2.LocalPlayer
local v_u_8 = v6:WaitForChild("aahelp", 5)
local v_u_9 = v6:WaitForChild("aahelp1", 5)
local v10 = script.Parent.TextButton
local v_u_11 = script.Parent.Frame2
local v_u_12 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v_u_13 = UDim2.new(0.609, 0, v_u_11.Position.Y.Scale, v_u_11.Position.Y.Offset)
local v_u_14 = UDim2.new(0, 0, v_u_11.Position.Y.Scale, v_u_11.Position.Y.Offset)
local v_u_15 = v6:FindFirstChild("DTMarker")
if not v_u_15 then
	v_u_15 = Instance.new("RemoteEvent")
	v_u_15.Name = "DTMarker"
	v_u_15.Parent = v6
end
local v16 = script.Parent.Parent:FindFirstChild("DT")
local v_u_17
if v16 then
	v_u_17 = v16.Value or false
else
	v_u_17 = false
end
if v16 then
	v16.Changed:Connect(function(p18)
		-- upvalues: (ref) v_u_17
		v_u_17 = p18
	end)
end
local v_u_19 = false
local v_u_20 = nil
local function v_u_23(p21, p22)
	-- upvalues: (ref) v_u_19, (copy) v_u_13, (copy) v_u_14, (copy) v_u_1, (copy) v_u_11, (copy) v_u_12, (ref) v_u_20
	v_u_19 = p21
	v_u_1:Create(v_u_11, v_u_12, {
		["Position"] = v_u_19 and v_u_13 or v_u_14
	}):Play()
	if not v_u_19 then
		v_u_20 = nil
	end
	if p22 and _G.ConfigSystem then
		_G.ConfigSystem.onSettingChanged("AutoShoot", v_u_19)
	end
end
v10.MouseButton1Click:Connect(function()
	-- upvalues: (copy) v_u_23, (ref) v_u_19
	v_u_23(not v_u_19, true)
end)
local v_u_24 = 0
local v_u_25 = false
local v_u_26 = 0
local v_u_27 = false
local v_u_28 = 0
local v29 = script.Parent.Parent:FindFirstChild("Fov")
local v_u_30 = v29 and (v29.Value or 360) or 360
if v29 then
	v29.Changed:Connect(function(p31)
		-- upvalues: (ref) v_u_30
		v_u_30 = p31
	end)
end
local v32 = script.Parent.Parent:FindFirstChild("Prediction")
local v_u_33
if v32 then
	v_u_33 = v32.Value or false
else
	v_u_33 = false
end
if v32 then
	v32.Changed:Connect(function(p34)
		-- upvalues: (ref) v_u_33
		v_u_33 = p34
	end)
end
local v35 = script.Parent.Parent:FindFirstChild("Head")
local v36 = script.Parent.Parent:FindFirstChild("Legs")
local v37 = script.Parent.Parent:FindFirstChild("Torso")
local v_u_38 = v35 and (v35.Value or true) or true
local v_u_39 = v36 and (v36.Value or true) or true
local v_u_40 = v37 and (v37.Value or true) or true
if v35 then
	v35.Changed:Connect(function(p41)
		-- upvalues: (ref) v_u_38
		v_u_38 = p41
	end)
end
if v36 then
	v36.Changed:Connect(function(p42)
		-- upvalues: (ref) v_u_39
		v_u_39 = p42
	end)
end
if v37 then
	v37.Changed:Connect(function(p43)
		-- upvalues: (ref) v_u_40
		v_u_40 = p43
	end)
end
local v44 = script.Parent.Parent:FindFirstChild("BAim")
local v45 = script.Parent.Parent:FindFirstChild("Hitchance")
local v46 = script.Parent.Parent:FindFirstChild("MinDamage")
local v47 = script.Parent.Parent:FindFirstChild("AutoS")
local v_u_48
if v44 then
	v_u_48 = v44.Value or false
else
	v_u_48 = false
end
local v_u_49 = v45 and (v45.Value or 100) or 100
local v_u_50 = v46 and (v46.Value or 0) or 0
local v_u_51
if v47 then
	v_u_51 = v47.Value or false
else
	v_u_51 = false
end
if v44 then
	v44.Changed:Connect(function(p52)
		-- upvalues: (ref) v_u_48
		v_u_48 = p52
	end)
end
if v45 then
	v45.Changed:Connect(function(p53)
		-- upvalues: (ref) v_u_49
		v_u_49 = p53
	end)
end
if v46 then
	v46.Changed:Connect(function(p54)
		-- upvalues: (ref) v_u_50
		v_u_50 = p54
	end)
end
if v47 then
	v47.Changed:Connect(function(p55)
		-- upvalues: (ref) v_u_51
		v_u_51 = p55
	end)
end
local v_u_56 = {
	["Head"] = 4,
	["UpperTorso"] = 1,
	["LowerTorso"] = 1,
	["Torso"] = 1,
	["HumanoidRootPart"] = 1,
	["LeftUpperArm"] = 0.75,
	["LeftLowerArm"] = 0.75,
	["LeftHand"] = 0.75,
	["RightUpperArm"] = 0.75,
	["RightLowerArm"] = 0.75,
	["RightHand"] = 0.75,
	["LeftUpperLeg"] = 0.6,
	["LeftLowerLeg"] = 0.6,
	["LeftFoot"] = 0.6,
	["RightUpperLeg"] = 0.6,
	["RightLowerLeg"] = 0.6,
	["RightFoot"] = 0.6,
	["Left Leg"] = 0.6,
	["Right Leg"] = 0.6
}
local function v_u_62()
	-- upvalues: (copy) v_u_7
	local v57 = v_u_7.Character
	if not v57 then
		return nil
	end
	local v58 = v57:FindFirstChildOfClass("Tool")
	if not v58 then
		return nil
	end
	local v59 = v58:FindFirstChild("Remotes")
	if not v59 then
		return nil
	end
	local v60 = v59:FindFirstChild("FireShot")
	if not v60 then
		return nil
	end
	local v61 = v58:FindFirstChild("Handle")
	return {
		["tool"] = v58,
		["fireShot"] = v60,
		["reload"] = v59:FindFirstChild("Reload"),
		["handle"] = v61
	}
end
local v_u_63 = 0
local function v_u_82()
	-- upvalues: (ref) v_u_63, (copy) v_u_7, (ref) v_u_17, (ref) v_u_15, (copy) v_u_4
	if os.clock() - v_u_63 < 1 then
		return
	else
		local v64 = v_u_7:FindFirstChild("leaderstats")
		if v64 then
			v64 = v64:FindFirstChild("leavemealonexd")
		end
		if v_u_17 then
			v_u_63 = os.clock()
			if v64 then
				v64.Value = false
			end
			local v_u_65 = v_u_7.Character
			if v_u_65 then
				local v66 = v_u_65:FindFirstChild("Humanoid")
				local v67 = v_u_65:FindFirstChild("HumanoidRootPart")
				if v66 and (v67 and v66.Health > 0) then
					pcall(function()
						-- upvalues: (ref) v_u_15
						v_u_15:FireServer("start", 4)
					end)
					local v68 = v66.MoveDirection
					if v68.Magnitude < 0.05 then
						v68 = v67.CFrame.LookVector
					end
					local v69 = v68.X
					local v70 = v68.Z
					local v71 = Vector3.new(v69, 0, v70).Unit
					local v72 = v67.Position
					local v73 = v72 + v71 * 4
					local v74 = RaycastParams.new()
					v74.FilterDescendantsInstances = { v_u_65 }
					v74.FilterType = Enum.RaycastFilterType.Exclude
					v74.IgnoreWater = true
					local v75 = v_u_4:Raycast(v72, v73 - v72, v74)
					if v75 then
						local v76 = (v75.Position - v72).Magnitude - 2
						v73 = v72 + v71 * math.max(0, v76)
					end
					local v77 = v_u_4:Raycast(v73 + Vector3.new(0, 5, 0), Vector3.new(0, -20, 0), v74)
					if v77 then
						local v78 = v73.X
						local v79 = v77.Position.Y + v66.HipHeight + 0.5
						local v80 = v73.Z
						local v81 = Vector3.new(v78, v79, v80)
						v67.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
						v67.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
						v_u_65:PivotTo(CFrame.new(v81) * v67.CFrame.Rotation)
						task.defer(function()
							-- upvalues: (copy) v_u_65, (ref) v_u_15
							if v_u_65 and v_u_65:FindFirstChild("HumanoidRootPart") then
								v_u_65.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
							end
							task.wait(0.1)
							pcall(function()
								-- upvalues: (ref) v_u_15
								v_u_15:FireServer("end")
							end)
						end)
					else
						pcall(function()
							-- upvalues: (ref) v_u_15
							v_u_15:FireServer("cancel")
						end)
					end
				else
					return
				end
			else
				return
			end
		else
			if v64 and v64.Value ~= true then
				v64.Value = true
			end
			return
		end
	end
end
local function v_u_90(p83)
	-- upvalues: (copy) v_u_7, (copy) v_u_8, (copy) v_u_9, (ref) v_u_28
	local v_u_84 = v_u_7.Character
	if v_u_84 then
		local v_u_85 = v_u_84:FindFirstChild("HumanoidRootPart")
		if v_u_85 then
			local v_u_86 = v_u_85.CFrame.Rotation
			if v_u_8 then
				v_u_8:FireServer("disable")
			end
			if v_u_9 then
				v_u_9:FireServer("disable")
			end
			task.wait(0.01)
			local v87 = p83.X
			local v88 = p83.Z
			local v89 = Vector3.new(v87, 0, v88).Unit
			if v89.Magnitude > 0.1 then
				v_u_85.CFrame = CFrame.new(v_u_85.Position, v_u_85.Position + v89)
			end
			v_u_28 = tick() + 0.15
			task.delay(0.15, function()
				-- upvalues: (copy) v_u_84, (copy) v_u_85, (copy) v_u_86, (ref) v_u_8, (ref) v_u_9
				if v_u_84 and (v_u_85 and v_u_85.Parent) then
					v_u_85.CFrame = CFrame.new(v_u_85.Position) * v_u_86
				end
				if v_u_8 then
					v_u_8:FireServer("enable")
				end
				if v_u_9 then
					v_u_9:FireServer("enable")
				end
			end)
		end
	else
		return
	end
end
local v_u_91 = false
local v_u_92 = false
local function v_u_98()
	-- upvalues: (ref) v_u_51, (ref) v_u_92, (ref) v_u_91, (copy) v_u_7
	if v_u_51 then
		if v_u_92 or v_u_91 then
			return
		else
			local v93 = v_u_7.Character
			if v93 then
				local v_u_94 = v93:FindFirstChild("Humanoid")
				local v95 = v93:FindFirstChild("HumanoidRootPart")
				if v_u_94 and v95 then
					if v_u_94.FloorMaterial ~= Enum.Material.Air then
						v_u_92 = true
						v_u_91 = true
						local v_u_96 = Instance.new("BodyVelocity")
						v_u_96.Name = "AutoStopVelocity"
						v_u_96.Velocity = Vector3.new(0, 0, 0)
						v_u_96.MaxForce = Vector3.new(100000, 0, 100000)
						v_u_96.P = 10000
						v_u_96.Parent = v95
						local v_u_97 = v_u_94.WalkSpeed
						v_u_94.WalkSpeed = 0
						task.delay(0.3, function()
							-- upvalues: (copy) v_u_96, (copy) v_u_94, (copy) v_u_97, (ref) v_u_91, (ref) v_u_92
							if v_u_96 and v_u_96.Parent then
								v_u_96:Destroy()
							end
							if v_u_94 and v_u_94.Parent then
								v_u_94.WalkSpeed = v_u_97
							end
							v_u_91 = false
							v_u_92 = false
						end)
					end
				else
					return
				end
			else
				return
			end
		end
	else
		return
	end
end
local v99 = v6:FindFirstChild("hit")
if v99 then
	v99.OnClientEvent:Connect(function()
		-- upvalues: (copy) v_u_98
		v_u_98()
	end)
end
local v_u_100 = Random.new()
local function v_u_104(p101)
	if not (p101 and p101:IsA("BasePart")) then
		return false
	end
	local v102 = p101.Name:lower()
	if v102:find("hamik") or v102:find("paletka") then
		return true
	end
	if p101.Parent then
		local v103 = p101.Parent.Name:lower()
		if v103:find("hamik") or v103:find("paletka") then
			return true
		end
	end
	return p101.Transparency > 0.2 and true or (not p101.CanCollide and true or ((p101:IsA("Decal") or (p101:IsA("ParticleEmitter") or (p101:IsA("Beam") or p101:IsA("Trail")))) and true or false))
end
local function v_u_107(p105)
	if p105 and p105:IsA("BasePart") then
		local v106 = p105.Parent
		if v106 then
			return v106:FindFirstChild("Humanoid") and true or ((v106:IsA("Accessory") or v106:IsA("Hat")) and true or false)
		else
			return false
		end
	else
		return false
	end
end
local function v_u_122(p108, p109, p110, p111)
	-- upvalues: (copy) v_u_4, (copy) v_u_104, (copy) v_u_122, (copy) v_u_107
	if p108 and p109 then
		local v112 = p109 - p108
		local v113 = v112.Magnitude
		if v113 < 0.1 or v113 > 1000 then
			return false, "invalid_distance"
		else
			local v114 = { p110, p111 }
			for _, v115 in ipairs(p110:GetDescendants()) do
				if v115:IsA("BasePart") then
					table.insert(v114, v115)
				end
			end
			for _, v116 in ipairs(p111:GetDescendants()) do
				if v116:IsA("BasePart") then
					table.insert(v114, v116)
				end
			end
			local v117 = RaycastParams.new()
			v117.FilterDescendantsInstances = v114
			v117.FilterType = Enum.RaycastFilterType.Exclude
			v117.IgnoreWater = true
			local v118 = v_u_4:Raycast(p108, v112, v117)
			if v118 then
				local v119 = v118.Instance
				if v119:IsDescendantOf(p111) then
					return true, "hit_target"
				elseif v_u_104(v119) then
					local v120 = v118.Position + v112.Unit * 0.1
					if (p109 - v120).Magnitude < 0.1 then
						return true, "transparent_pass"
					else
						return v_u_122(v120, p109, p110, p111)
					end
				elseif v_u_107(v119) then
					local v121 = v118.Position + v112.Unit * 0.1
					if (p109 - v121).Magnitude < 0.1 then
						return true, "passed_other_player"
					else
						return v_u_122(v121, p109, p110, p111)
					end
				else
					return false, "wall_blocking"
				end
			else
				return true, "clear"
			end
		end
	else
		return false, "invalid_positions"
	end
end
local function v_u_130(p123, p124, p125, p126)
	-- upvalues: (copy) v_u_122
	if not (p123 and (p124 and (p125 and p126))) then
		return false
	end
	local v127, _ = v_u_122(p123, p124, p125, p126)
	if v127 then
		return true
	end
	for _, v128 in ipairs({ Vector3.new(0, 0.3, 0), Vector3.new(0, -0.3, 0) }) do
		local v129, _ = v_u_122(p123, p124 + v128, p125, p126)
		if v129 then
			return true
		end
	end
	return false
end
local v_u_131 = {}
local function v_u_137(p132, p133)
	-- upvalues: (ref) v_u_33, (copy) v_u_5
	if not (v_u_33 and p133) then
		return p132.Position
	end
	local v134 = p133.AssemblyLinearVelocity or Vector3.new()
	if v134.Magnitude < 3 then
		return p132.Position
	end
	local v135 = (p132.Position - v_u_5.CFrame.Position).Magnitude / 1000
	local v136 = math.clamp(v135, 0.08, 0.2)
	return p132.Position + v134 * v136 * 1.2
end
local v_u_138 = {}
local v_u_139 = 0
local function v_u_145()
	-- upvalues: (copy) v_u_138, (copy) v_u_2, (copy) v_u_7
	table.clear(v_u_138)
	for _, v140 in ipairs(v_u_2:GetPlayers()) do
		if v140 ~= v_u_7 and (not v140.Team or (not v_u_7.Team or v140.Team ~= v_u_7.Team)) then
			local v141 = v140.Character
			if v141 then
				local v142 = v141:FindFirstChild("Humanoid")
				local v143 = v141:FindFirstChild("HumanoidRootPart")
				if v142 and (v142.Health > 0 and v143) then
					local v144 = v_u_138
					table.insert(v144, {
						["player"] = v140,
						["character"] = v141,
						["humanoid"] = v142,
						["rootPart"] = v143
					})
				end
			end
		end
	end
end
local function v_u_190()
	-- upvalues: (copy) v_u_7, (ref) v_u_139, (copy) v_u_145, (copy) v_u_138, (copy) v_u_5, (ref) v_u_48, (ref) v_u_38, (ref) v_u_40, (ref) v_u_39, (ref) v_u_30, (ref) v_u_50, (copy) v_u_56, (copy) v_u_130
	local v146 = v_u_7.Character
	local v147
	if v146 then
		local v148 = v146:FindFirstChild("Humanoid")
		v147 = v148 and v148.Health > 0 and true or false
	else
		v147 = false
	end
	if not v147 then
		return nil
	end
	local v149 = tick()
	if v149 - v_u_139 >= 0.5 then
		v_u_139 = v149
		v_u_145()
	end
	if #v_u_138 == 0 then
		return nil
	end
	local v150 = v_u_7.Character
	local v151 = v150:FindFirstChild("Head")
	if not v151 then
		return nil
	end
	local v152 = v151.Position
	local v153 = v_u_5.ViewportSize
	local v154 = v153.X * 0.5
	local v155 = v153.Y * 0.5
	local v156 = v_u_5.CFrame.Position
	local v157 = (1 / 0)
	local v158 = nil
	for v159 = 1, #v_u_138 do
		local v160 = v_u_138[v159]
		if v160.humanoid.Health > 0 then
			local v161 = v160.character
			local v162 = v160.humanoid.Health
			local v163 = {}
			local v164 = v_u_48
			if v164 then
				v164 = v162 < 30
			end
			local v165 = v_u_38 and not v164 and v161:FindFirstChild("Head")
			if v165 then
				table.insert(v163, {
					["part"] = v165,
					["priority"] = 1
				})
			end
			local v166 = v_u_40 and (v161:FindFirstChild("Torso") or (v161:FindFirstChild("UpperTorso") or v161:FindFirstChild("LowerTorso")))
			if v166 then
				table.insert(v163, {
					["part"] = v166,
					["priority"] = v164 and 1 or 2
				})
			end
			local v167 = v_u_38 and v164 and v161:FindFirstChild("Head")
			if v167 then
				table.insert(v163, {
					["part"] = v167,
					["priority"] = 3
				})
			end
			local v168 = v_u_39 and (v161:FindFirstChild("LeftUpperLeg") or (v161:FindFirstChild("RightUpperLeg") or v161:FindFirstChild("HumanoidRootPart")))
			if v168 then
				table.insert(v163, {
					["part"] = v168,
					["priority"] = 4
				})
			end
			if #v163 ~= 0 then
				for v169 = 1, #v163 do
					local v170 = v163[v169]
					local v171 = v170.part
					local v172 = v171.Position
					local v173
					if v_u_30 >= 360 then
						v173 = true
					else
						local v174, v175 = v_u_5:WorldToViewportPoint(v172)
						if v175 then
							local v176 = v_u_5.ViewportSize
							local v177 = v176.X * 0.5
							local v178 = v176.Y * 0.5
							local v179 = v174.X - v177
							local v180 = v174.Y - v178
							v173 = v179 * v179 + v180 * v180 <= v_u_30 * v_u_30
						else
							v173 = false
						end
					end
					if v173 then
						local v181 = (v160.rootPart.Position - v156).Magnitude
						local v182
						if v_u_50 <= 0 then
							v182 = true
						else
							local v183 = 54 * (v_u_56[v171.Name] or 0.5)
							if v181 > 300 then
								v183 = v183 * 0.3
							elseif v181 > 200 then
								v183 = v183 * 0.5
							elseif v181 > 100 then
								v183 = v183 * 0.8
							end
							v182 = v_u_50 <= math.floor(v183)
						end
						if v182 and v_u_130(v152, v171.Position, v150, v161) then
							local v184, v185 = v_u_5:WorldToViewportPoint(v171.Position)
							if v185 then
								local v186 = v184.X - v154
								local v187 = v184.Y - v155
								local v188 = v186 * v186 + v187 * v187
								local v189 = math.sqrt(v188) * v170.priority
								if v189 < v157 then
									v158 = {
										["player"] = v160.player,
										["character"] = v161,
										["targetPart"] = v171,
										["rootPart"] = v160.rootPart,
										["distance"] = v181
									}
									v157 = v189
								end
							end
						end
					end
				end
			end
		end
	end
	return v158
end
local function v_u_194(p191, p192)
	-- upvalues: (copy) v_u_7, (copy) v_u_4
	if not (p191 and p192) then
		return false
	end
	if p191.FloorMaterial ~= Enum.Material.Air then
		return true
	end
	local v193 = RaycastParams.new()
	v193.FilterDescendantsInstances = { v_u_7.Character }
	v193.FilterType = Enum.RaycastFilterType.Exclude
	return v_u_4:Raycast(p192.Position, Vector3.new(0, -3.5, 0), v193) ~= nil
end
local v195 = nil
task.spawn(function()
	-- upvalues: (copy) v_u_131
	while task.wait(2) do
		for v196, v197 in pairs(v_u_131) do
			if tick() - v197.time > 3 then
				v_u_131[v196] = nil
			end
		end
	end
end)
task.wait(1)
if _G.ConfigSystem then
	_G.ConfigSystem.settings.AutoShoot = v_u_19
	local v_u_198 = _G.ConfigSystem.onConfigLoad
	function _G.ConfigSystem.onConfigLoad(p199, p200)
		-- upvalues: (ref) v_u_19, (copy) v_u_13, (copy) v_u_14, (copy) v_u_1, (copy) v_u_11, (copy) v_u_12, (ref) v_u_20, (copy) v_u_198
		if p199 == "AutoShoot" then
			v_u_19 = p200
			v_u_1:Create(v_u_11, v_u_12, {
				["Position"] = v_u_19 and v_u_13 or v_u_14
			}):Play()
			if not v_u_19 then
				v_u_20 = nil
			end
		end
		if v_u_198 then
			v_u_198(p199, p200)
		end
	end
end
if not v195 then
	v195 = v3.RenderStepped:Connect(function(_)
		-- upvalues: (ref) v_u_19, (ref) v_u_20, (ref) v_u_27, (copy) v_u_7, (copy) v_u_194, (ref) v_u_24, (ref) v_u_25, (copy) v_u_62, (copy) v_u_190, (ref) v_u_26, (ref) v_u_33, (copy) v_u_137, (copy) v_u_130, (ref) v_u_49, (copy) v_u_100, (copy) v_u_90, (copy) v_u_82
		if v_u_19 then
			local v201 = v_u_7.Character
			local v202
			if v201 then
				local v203 = v201:FindFirstChild("Humanoid")
				v202 = v203 and v203.Health > 0 and true or false
			else
				v202 = false
			end
			if v202 then
				local v204 = v_u_7.Character
				local v205
				if v204 then
					v205 = v204:FindFirstChild("Humanoid")
				else
					v205 = v204
				end
				if v204 then
					v204 = v204:FindFirstChild("HumanoidRootPart")
				end
				local v206
				if v205 then
					local v207 = v205:GetState()
					v206 = (v207 == Enum.HumanoidStateType.Jumping or v207 == Enum.HumanoidStateType.Freefall) and true or v207 == Enum.HumanoidStateType.FallingDown
				else
					v206 = true
				end
				if v206 then
					v_u_20 = nil
					return
				elseif v_u_194(v205, v204) then
					local v208 = tick()
					if v208 - v_u_24 < 1.3 then
						return
					elseif v_u_25 then
						return
					else
						local v_u_209 = v_u_62()
						if v_u_209 then
							local v_u_210 = v_u_190()
							if v_u_210 then
								if v_u_27 then
									v_u_27 = false
									v_u_26 = v208
								end
								if v208 - v_u_26 < 0.05 then
									return
								else
									v_u_20 = v_u_210
									local v211
									if v_u_33 then
										v211 = v_u_137(v_u_210.targetPart, v_u_210.rootPart)
									else
										v211 = v_u_210.targetPart.Position
									end
									if v211 then
										local v212 = v_u_7.Character
										local v213 = v212:FindFirstChild("Head")
										if v213 then
											if v_u_130(v213.Position, v211, v212, v_u_210.character) then
												local v214
												if v_u_49 >= 100 then
													v214 = true
												elseif v_u_49 <= 0 then
													v214 = false
												else
													v214 = v_u_100:NextInteger(1, 100) <= v_u_49
												end
												if v214 then
													local v_u_215 = v213.Position
													local v_u_216 = (v211 - v_u_215).Unit
													local v217
													if v205 then
														local v218 = v205:GetState()
														v217 = (v218 == Enum.HumanoidStateType.Jumping or v218 == Enum.HumanoidStateType.Freefall) and true or v218 == Enum.HumanoidStateType.FallingDown
													else
														v217 = true
													end
													if not v217 then
														v_u_25 = true
														v_u_90(v_u_216)
														local v219, v220 = pcall(function()
															-- upvalues: (copy) v_u_209, (copy) v_u_215, (copy) v_u_216, (copy) v_u_210
															v_u_209.fireShot:FireServer(v_u_215, v_u_216, v_u_210.targetPart)
														end)
														if v219 then
															v_u_24 = v208
															v_u_82()
														else
															warn("AutoShoot Error:", v220)
														end
														task.delay(0.1, function()
															-- upvalues: (ref) v_u_25
															v_u_25 = false
														end)
													end
												else
													return
												end
											else
												return
											end
										else
											return
										end
									else
										return
									end
								end
							else
								if not v_u_27 then
									v_u_27 = true
									v_u_26 = v208
								end
								v_u_20 = nil
								return
							end
						else
							v_u_20 = nil
							v_u_27 = false
							return
						end
					end
				else
					v_u_20 = nil
					return
				end
			else
				v_u_20 = nil
				v_u_27 = false
				return
			end
		else
			v_u_20 = nil
			v_u_27 = false
			return
		end
	end)
end
