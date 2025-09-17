local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(Players.LocalPlayer)
local Character = cloneref(LocalPlayer.Character)
local RootPart = cloneref(Character.HumanoidRootPart)
local net = game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net
local cn = string.find(LocalPlayer.LocaleId, "zh") ~= nil

local T = {
    Title = cn and "钓它！" or "Fish It!",
    MainSection = cn and "主功能" or "Main",
    MainTab = cn and "主要功能" or "Main",
    AutoComplete = cn and "自动完成钓鱼" or "Auto Complete Fishing",
    AutoSell = cn and "自动出售" or "Auto Sell",
    PerfectFish = cn and "完美钓鱼" or "Perfect Fishing",
    InfOxygen = cn and "无限氧气" or "Infinite Oxygen",
    WaterWalk = cn and "水上行走" or "Water Walk",
    Author = cn and "作者: Nova" or "Author: Nova",
    OpenUI = cn and "打开UI" or "Open UI"
}

LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local Window =
    WindUI:CreateWindow(
    {
        Title = T.Title,
        Icon = "rbxassetid://129260712070622",
        IconThemed = true,
        Author = T.Author,
        Folder = "CloudHub",
        Size = UDim2.fromOffset(300, 350),
        Transparent = true,
        Theme = "Dark",
        User = {
            Enabled = true,
            Callback = function()
                print("clicked")
            end,
            Anonymous = false
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true
    }
)

Window:EditOpenButton(
    {
        Title = T.OpenUI,
        Icon = "monitor",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
        Draggable = true
    }
)

MainSection = Window:Section({
    Title = T.MainSection,
    Opened = true,
})

local setting = {
    AutoComplete = false,
    SellAll = false,
    infoxygen = false,
    antifall = false
}

local oxygen
oxygen = hookmetamethod(net:FindFirstChild("URE/UpdateOxygen"), "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if setting.infoxygen and not checkcaller() and method == "FireServer" then
        args[1] = -math.huge
        return oxygen(self, unpack(args))
    end
    return oxygen(self, ...)
end)

local perfect1
perfect1 = hookmetamethod(net:FindFirstChild("RF/ChargeFishingRod"), "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if setting.perfectfish and not checkcaller() and method == "InvokeServer" then
        args[1] = 0
        return perfect1(self, unpack(args))
    end
    return perfect1(self, ...)
end)

local perfect2
perfect2 = hookmetamethod(net:FindFirstChild("RF/RequestFishingMinigameStarted"), "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if setting.perfectfish and not checkcaller() and method == "InvokeServer" then
        args[1] = 0
        args[2] = 1
        return perfect2(self, unpack(args))
    end
    return perfect2(self, ...)
end)

local Main = MainSection:Tab({ Title = T.MainTab, Icon = "Sword" })

Main:Toggle(
    {
        Title = T.AutoComplete,
        Default = false,
        Image = "check",
        Callback = function(state)
            setting.AutoComplete = state
            while setting.AutoComplete and task.wait() do
                net:FindFirstChild("RE/FishingCompleted"):FireServer()
            end
        end
    }
)

Main:Toggle(
    {
        Title = T.AutoSell,
        Default = false,
        Image = "check",
        Callback = function(state)
            setting.SellAll = state
            while setting.SellAll and task.wait() do
                net:FindFirstChild("RF/SellAllItems"):InvokeServer()
            end
        end
    }
)

Main:Toggle(
    {
        Title = T.PerfectFish,
        Default = false,
        Image = "check",
        Callback = function(state)
            setting.perfectfish = state
        end
    }
)

Main:Toggle(
    {
        Title = T.InfOxygen,
        Default = false,
        Image = "check",
        Callback = function(state)
            setting.infoxygen = state
        end
    }
)

Main:Toggle(
    {
        Title = T.WaterWalk,
        Default = false,
        Image = "check",
        Callback = function(state)
            for _,v in next,workspace.Zones.Ocean:GetChildren() do
                if v.Name == "Ocean" then
                    v.CanCollide = state
                end
            end
        end
    }
)
