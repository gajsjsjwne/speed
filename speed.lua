-- Mod Menu for Roblox (LocalScript)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- настройки
local WALK = 16
local RUN = 50

-- текущие ссылки (обновляются при респавне)
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- состояние кнопок (сохраняется между респавнами)
local speedOn = false
local infJump = false

-- при респавне обновляем ссылки и применяем состояние
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    root = newChar:WaitForChild("HumanoidRootPart")

    -- применяем сохранённые настройки к новому персонажу
    if speedOn then
        humanoid.WalkSpeed = RUN
    end
end)

-- создаём GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ModMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "MOD MENU"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- кнопка
local function makeButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 15
    b.Text = text
    b.Parent = frame
    return b
end

-- скорость
local speedBtn = makeButton("Скорость: ВЫКЛ", 45)
speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    humanoid.WalkSpeed = speedOn and RUN or WALK
    speedBtn.Text = "Скорость: " .. (speedOn and "ВКЛ" or "ВЫКЛ")
end)

-- бесконечный прыжок
local infJumpBtn = makeButton("Inf Jump: ВЫКЛ", 85)
infJumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    infJumpBtn.Text = "Inf Jump: " .. (infJump and "ВКЛ" or "ВЫКЛ")
end)
UserInputService.JumpRequest:Connect(function()
    if infJump and humanoid and humanoid.Health > 0 then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- телепорт вверх
local tpBtn = makeButton("Телепорт вверх (+100)", 125)
tpBtn.MouseButton1Click:Connect(function()
    if root and root.Parent then
        root.CFrame = root.CFrame + Vector3.new(0, 100, 0)
    end
end)

-- респавн
local respawnBtn = makeButton("Респавн", 165)
respawnBtn.MouseButton1Click:Connect(function()
    if humanoid then
        humanoid.Health = 0
    end
end)
