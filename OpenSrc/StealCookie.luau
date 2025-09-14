local Players = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(Players.LocalPlayer)
local Character = cloneref(LocalPlayer.Character)
local RootPart = cloneref(Character.HumanoidRootPart)


local cn = string.find(LocalPlayer.LocaleId, "zh") ~= nil

local T = {
    Title = cn and "偷取饼干" or "Steal Cookies",
    MainSection = cn and "主功能" or "Main",
    MainTab = cn and "主要功能" or "Main",
    EatMethod = cn and "选择吃饼干方式" or "Select Eat Method",
    Teleport = cn and "传送" or "Teleport",
    Range = cn and "范围" or "Range",
    AutoEat = cn and "自动吃饼干" or "Auto eat cookies",
    DeleteDoors = cn and "删除所有门" or "Delete All Doors",
    DeleteDesc = cn and "点击删除所有门" or "Click to delete all doors",
    NotSelected = cn and "未选择" or "Not Selected"
}

LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = T.Title,
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Author = cn and "作者: Nova" or "Author: Nova",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(300, 350),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function() end,
        Anonymous = false
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true
})

Window:EditOpenButton({
    Title = cn and "打开界面" or "Open UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true
})

local MainSection = Window:Section({
    Title = T.MainSection,
    Opened = true,
})

local Main = MainSection:Tab({ Title = T.MainTab, Icon = "Sword" })

local Data = {
    ["EatMethod"] = T.NotSelected,
    ["AutoEat"] = false
}

Main:Dropdown({
    Title = T.EatMethod,
    Values = { T.Teleport, T.Range },
    Value = T.NotSelected,
    Callback = function(option)
        Data["EatMethod"] = option
    end
})

Main:Toggle({
    Title = T.AutoEat,
    Default = false,
    Image = "check",
    Callback = function(state)
        Data["AutoEat"] = state
        if state then
            spawn(function()
                while Data["AutoEat"] and task.wait() do
                    pcall(function()
                        for _, v in next, workspace.Map.Functional.SpawnedItems:GetChildren() do
                            if v.Name == "CookieObject" and v:FindFirstChild("CookiePrompt") then
                                if Data["EatMethod"] == T.Teleport then
                                    RootPart.CFrame = v.Cookie.CFrame + Vector3.new(0, 5, 0)
                                end
                                fireproximityprompt(v.CookiePrompt)
                            end
                        end
                    end)
                end
            end)
        end
    end
})

Main:Button({
    Title = T.DeleteDoors,
    Desc = T.DeleteDesc,
    Callback = function()
        workspace.Map.Functional.Doors:Destroy()
    end
})
