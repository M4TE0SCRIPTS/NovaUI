local NovaUI = {}
NovaUI.__index = NovaUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

NovaUI.Themes = {
    Dark = {
        Background = Color3.fromRGB(18,18,22),
        Secondary = Color3.fromRGB(25,25,31),
        Text = Color3.fromRGB(245,245,245),
        Sub = Color3.fromRGB(155,155,165),
        Accent = Color3.fromRGB(120,80,255),
        Element = Color3.fromRGB(32,32,40)
    },
    Light = {
        Background = Color3.fromRGB(240,240,245),
        Secondary = Color3.fromRGB(250,250,255),
        Text = Color3.fromRGB(25,25,30),
        Sub = Color3.fromRGB(100,100,110),
        Accent = Color3.fromRGB(100,70,230),
        Element = Color3.fromRGB(225,225,235)
    }
}

local Theme = NovaUI.Themes.Dark

local function New(class,parent,props)
    local o = Instance.new(class)
    o.Parent = parent
    for k,v in pairs(props or {}) do
        o[k] = v
    end
    return o
end

local function Corner(o,r)
    New("UICorner",o,{CornerRadius=UDim.new(0,r or 8)})
end

local function Stroke(o,c,t)
    return New("UIStroke",o,{
        Color=c or Color3.new(1,1,1),
        Thickness=t or 1
    })
end

local function Tween(o,time,props)
    TweenService:Create(
        o,
        TweenInfo.new(time or .2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
        props
    ):Play()
end

local function Text(parent,text,size,color)
    return New("TextLabel",parent,{
        BackgroundTransparency=1,
        Text=text or "",
        TextSize=size or 14,
        Font=Enum.Font.Gotham,
        TextColor3=color or Theme.Text,
        TextXAlignment=Enum.TextXAlignment.Left
    })
end

function NovaUI:CreateWindow(cfg)
    cfg = cfg or {}

    local self = setmetatable({},NovaUI)

    self.Title = cfg.Title or "NovaUI"
    self.Subtitle = cfg.Subtitle or "Modern Roblox UI"
    self.ThemeName = cfg.Theme or "Dark"
    self.RGBBorders = cfg.RGBBorders or false
    self.RGBSpeed = cfg.RGBSpeed or 120
    self.Animated = cfg.Animated ~= false
    self.Sounds = cfg.Sounds ~= false
    self.Minimized = false
    self.Tabs = {}

    Theme = NovaUI.Themes[self.ThemeName] or NovaUI.Themes.Dark

    self.GUI = New("ScreenGui",PG,{
        Name="NovaUI",
        ResetOnSpawn=false,
        IgnoreGuiInset=true
    })

    self.Main = New("Frame",self.GUI,{
        Size=UDim2.fromOffset(560,400),
        Position=UDim2.new(.5,-280,.5,-200),
        BackgroundColor3=Theme.Background,
        BorderSizePixel=0
    })
    Corner(self.Main,12)

    self.Border = Stroke(self.Main,Theme.Accent,1)

    self.Top = New("Frame",self.Main,{
        Size=UDim2.new(1,0,0,65),
        BackgroundColor3=Theme.Secondary,
        BorderSizePixel=0
    })
    Corner(self.Top,12)

    self.TitleLabel = Text(self.Top,self.Title,17,Theme.Text)
    self.TitleLabel.Position=UDim2.fromOffset(18,10)
    self.TitleLabel.Size=UDim2.new(1,-70,0,24)

    self.SubLabel = Text(self.Top,self.Subtitle,11,Theme.Sub)
    self.SubLabel.Position=UDim2.fromOffset(19,35)
    self.SubLabel.Size=UDim2.new(1,-70,0,18)

    self.Close = New("TextButton",self.Top,{
        Size=UDim2.fromOffset(35,35),
        Position=UDim2.new(1,-45,0,15),
        Text="×",
        TextSize=22,
        Font=Enum.Font.GothamBold,
        TextColor3=Theme.Text,
        BackgroundTransparency=1
    })

    self.Min = New("TextButton",self.Top,{
        Size=UDim2.fromOffset(35,35),
        Position=UDim2.new(1,-82,0,15),
        Text="—",
        TextSize=20,
        Font=Enum.Font.GothamBold,
        TextColor3=Theme.Text,
        BackgroundTransparency=1
    })

    self.Side = New("ScrollingFrame",self.Main,{
        Size=UDim2.new(0,135,1,-75),
        Position=UDim2.fromOffset(8,70),
        BackgroundTransparency=1,
        ScrollBarThickness=2,
        CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.Y
    })

    New("UIListLayout",self.Side,{
        Padding=UDim.new(0,6)
    })

    self.Pages = New("Frame",self.Main,{
        Size=UDim2.new(1,-155,1,-75),
        Position=UDim2.fromOffset(145,70),
        BackgroundTransparency=1
    })

    self:Drag()

    self.Close.MouseButton1Click:Connect(function()
        self:CloseWindow()
    end)

    self.Min.MouseButton1Click:Connect(function()
        self:Minimize()
    end)

    if self.RGBBorders then
        self:StartRGB()
    end

    if self.Animated then
        self.Main.Size=UDim2.fromOffset(0,0)
        Tween(self.Main,.35,{
            Size=UDim2.fromOffset(560,400)
        })
    end

    return self
end

function NovaUI:Drag()
    local dragging=false
    local start
    local pos

    local function move(input)
        local delta=input.Position-start
        self.Main.Position=UDim2.new(
            pos.X.Scale,pos.X.Offset+delta.X,
            pos.Y.Scale,pos.Y.Offset+delta.Y
        )
    end

    self.Top.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            start=input.Position
            pos=self.Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and
        (input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch) then
            move(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
end

function NovaUI:StartRGB()
    task.spawn(function()
        local h=0
        while self.GUI and self.GUI.Parent do
            h=(h+1/self.RGBSpeed)%1
            self.Border.Color=Color3.fromHSV(h,1,1)
            RunService.RenderStepped:Wait()
        end
    end)
end

function NovaUI:Minimize()
    if self.Minimized then
        self.Minimized=false
        self.Top.Visible=true
        self.Side.Visible=true
        self.Pages.Visible=true
        Tween(self.Main,.25,{Size=UDim2.fromOffset(560,400)})
    else
        self.Minimized=true
        self.Side.Visible=false
        self.Pages.Visible=false
        Tween(self.Main,.25,{Size=UDim2.fromOffset(560,65)})
    end
end

function NovaUI:CloseWindow()
    if self.Animated then
        Tween(self.Main,.25,{Size=UDim2.fromOffset(0,0)})
        task.wait(.25)
    end
    self.GUI:Destroy()
end

function NovaUI:CreateTab(name,icon)
    local page=New("ScrollingFrame",self.Pages,{
        Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,
        Visible=#self.Tabs==0,
        ScrollBarThickness=3,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        CanvasSize=UDim2.new()
    })

    New("UIListLayout",page,{
        Padding=UDim.new(0,7)
    })

    local button=New("TextButton",self.Side,{
        Size=UDim2.new(1,-8,0,38),
        BackgroundColor3=Theme.Element,
        Text=(icon and icon.."  " or "")..name,
        TextSize=12,
        Font=Enum.Font.GothamMedium,
        TextColor3=Theme.Sub
    })
    Corner(button,7)

    local tab={Name=name,Page=page,Button=button}
    table.insert(self.Tabs,tab)

    button.MouseButton1Click:Connect(function()
        for _,t in pairs(self.Tabs) do
            t.Page.Visible=false
            t.Button.BackgroundColor3=Theme.Element
        end

        page.Visible=true
        button.BackgroundColor3=Theme.Accent
    end)

    return setmetatable({Page=page,Window=self},{
        __index={
            CreateButton=function(s,c)return self:CreateButton(page,c)end,
            CreateToggle=function(s,c)return self:CreateToggle(page,c)end,
            CreateSlider=function(s,c)return self:CreateSlider(page,c)end,
            CreateDropdown=function(s,c)return self:CreateDropdown(page,c)end,
            CreateTextbox=function(s,c)return self:CreateTextbox(page,c)end,
            CreateLabel=function(s,c)return self:CreateLabel(page,c)end,
            CreateSection=function(s,c)return self:CreateSection(page,c)end,
            CreateKeybind=function(s,c)return self:CreateKeybind(page,c)end
        }
    })
end

function NovaUI:Base(page,name,height)
    local b=New("Frame",page,{
        Size=UDim2.new(1,-8,0,height or 45),
        BackgroundColor3=Theme.Element,
        BorderSizePixel=0
    })
    Corner(b,8)

    local l=Text(b,name,13,Theme.Text)
    l.Position=UDim2.fromOffset(12,0)
    l.Size=UDim2.new(.55,0,1,0)

    return b
end

function NovaUI:CreateButton(page,c)
    local b=self:Base(page,c.Name or "Button")
    local x=New("TextButton",b,{
        Size=UDim2.fromOffset(110,30),
        Position=UDim2.new(1,-120,.5,-15),
        Text=c.Text or "Click",
        TextSize=12,
        Font=Enum.Font.GothamMedium,
        TextColor3=Theme.Text,
        BackgroundColor3=Theme.Accent
    })
    Corner(x,6)

    x.MouseButton1Click:Connect(function()
        if c.Callback then c.Callback() end
    end)

    return b
end

function NovaUI:CreateToggle(page,c)
    local b=self:Base(page,c.Name or "Toggle")
    local on=c.Default or false

    local x=New("TextButton",b,{
        Size=UDim2.fromOffset(45,24),
        Position=UDim2.new(1,-57,.5,-12),
        Text="",
        BackgroundColor3=on and Theme.Accent or Theme.Background
    })
    Corner(x,12)

    local dot=New("Frame",x,{
        Size=UDim2.fromOffset(18,18),
        Position=UDim2.fromOffset(on and 24 or 3,3),
        BackgroundColor3=Theme.Text
    })
    Corner(dot,20)

    x.MouseButton1Click:Connect(function()
        on=not on
        Tween(dot,.15,{Position=UDim2.fromOffset(on and 24 or 3,3)})
        x.BackgroundColor3=on and Theme.Accent or Theme.Background
        if c.Callback then c.Callback(on) end
    end)

    return b
end

function NovaUI:CreateSlider(page,c)
    local b=self:Base(page,c.Name or "Slider",60)
    local min=c.Min or 0
    local max=c.Max or 100
    local val=c.Default or min

    local bar=New("Frame",b,{
        Size=UDim2.new(.45,0,0,5),
        Position=UDim2.new(.52,0,.5,8),
        BackgroundColor3=Theme.Background
    })
    Corner(bar,5)

    local fill=New("Frame",bar,{
        Size=UDim2.new((val-min)/(max-min),0,1,0),
        BackgroundColor3=Theme.Accent
    })
    Corner(fill,5)

    local hit=New("TextButton",bar,{
        Size=UDim2.new(1,20,1,20),
        Position=UDim2.fromOffset(-10,-10),
        BackgroundTransparency=1,
        Text=""
    })

    local function set(x)
        local p=math.clamp(x.X/bar.AbsoluteSize.X,0,1)
        val=math.floor(min+(max-min)*p)
        fill.Size=UDim2.new(p,0,1,0)
        if c.Callback then c.Callback(val) end
    end

    hit.MouseButton1Down:Connect(function()
        local con
        con=UIS.InputChanged:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseMovement
            or i.UserInputType==Enum.UserInputType.Touch then
                set(i.Position-bar.AbsolutePosition)
            end
        end)

        UIS.InputEnded:Wait()
        con:Disconnect()
    end)

    return b
end

function NovaUI:CreateDropdown(page,c)
    local b=self:Base(page,c.Name or "Dropdown",45)
    local open=false

    local x=New("TextButton",b,{
        Size=UDim2.fromOffset(120,30),
        Position=UDim2.new(1,-130,.5,-15),
        Text=c.Default or "Select",
        TextSize=11,
        Font=Enum.Font.Gotham,
        TextColor3=Theme.Text,
        BackgroundColor3=Theme.Background
    })
    Corner(x,6)

    local list=New("Frame",page,{
        Size=UDim2.new(1,-8,0,0),
        BackgroundColor3=Theme.Secondary,
        Visible=false,
        ClipsDescendants=true
    })
    Corner(list,7)
    New("UIListLayout",list)

    for _,v in ipairs(c.Options or {}) do
        local o=New("TextButton",list,{
            Size=UDim2.new(1,0,0,30),
            Text=tostring(v),
            TextSize=11,
            Font=Enum.Font.Gotham,
            TextColor3=Theme.Text,
            BackgroundTransparency=1
        })

        o.MouseButton1Click:Connect(function()
            x.Text=tostring(v)
            list.Visible=false
            list.Size=UDim2.new(1,-8,0,0)
            if c.Callback then c.Callback(v) end
        end)
    end

    x.MouseButton1Click:Connect(function()
        open=not open
        list.Visible=open
        list.Size=UDim2.new(1,-8,0,open and (#(c.Options or {})*30) or 0)
    end)

    return b
end

function NovaUI:CreateTextbox(page,c)
    local b=self:Base(page,c.Name or "Textbox",48)

    local x=New("TextBox",b,{
        Size=UDim2.fromOffset(145,30),
        Position=UDim2.new(1,-155,.5,-15),
        Text=c.Default or "",
        PlaceholderText=c.Placeholder or "Enter text...",
        TextSize=11,
        Font=Enum.Font.Gotham,
        TextColor3=Theme.Text,
        PlaceholderColor3=Theme.Sub,
        BackgroundColor3=Theme.Background,
        ClearTextOnFocus=false
    })
    Corner(x,6)

    x.FocusLost:Connect(function()
        if c.Callback then c.Callback(x.Text) end
    end)

    return b
end

function NovaUI:CreateLabel(page,c)
    local b=self:Base(page,"",c.Height or 35)
    b.BackgroundTransparency=1

    local l=Text(b,c.Text or "",12,Theme.Sub)
    l.Size=UDim2.new(1,-15,1,0)
    l.Position=UDim2.fromOffset(8,0)

    return b
end

function NovaUI:CreateSection(page,c)
    local l=Text(page,c.Name or "Section",12,Theme.Accent)
    l.Size=UDim2.new(1,-8,0,28)
    l.Position=UDim2.fromOffset(5,0)
    return l
end

function NovaUI:CreateKeybind(page,c)
    local b=self:Base(page,c.Name or "Keybind")
    local key=c.Default or Enum.KeyCode.RightShift
    local listening=false

    local x=New("TextButton",b,{
        Size=UDim2.fromOffset(110,30),
        Position=UDim2.new(1,-120,.5,-15),
        Text=key.Name,
        TextSize=11,
        Font=Enum.Font.Gotham,
        TextColor3=Theme.Text,
        BackgroundColor3=Theme.Background
    })
    Corner(x,6)

    x.MouseButton1Click:Connect(function()
        listening=true
        x.Text="Press key"
    end)

    UIS.InputBegan:Connect(function(i,g)
        if listening and i.UserInputType==Enum.UserInputType.Keyboard then
            key=i.KeyCode
            listening=false
            x.Text=key.Name
            if c.Callback then c.Callback(key) end
        end
    end)

    return b
end

function NovaUI:Notify(c)
    c=c or {}

    local holder=self.GUI:FindFirstChild("Notifications")
    if not holder then
        holder=New("Frame",self.GUI,{
            Name="Notifications",
            Size=UDim2.fromOffset(310,400),
            Position=UDim2.new(1,-325,0,20),
            BackgroundTransparency=1
        })

        local layout=New("UIListLayout",holder,{
            Padding=UDim.new(0,8),
            VerticalAlignment=Enum.VerticalAlignment.Top
        })
    end

    local n=New("Frame",holder,{
        Size=UDim2.new(1,0,0,65),
        BackgroundColor3=Theme.Secondary,
        BorderSizePixel=0
    })
    Corner(n,9)
    Stroke(n,Theme.Accent,1)

    local title=Text(n,c.Title or "NovaUI",13,Theme.Text)
    title.Position=UDim2.fromOffset(12,8)
    title.Size=UDim2.new(1,-25,0,20)

    local msg=Text(n,c.Content or "",11,Theme.Sub)
    msg.Position=UDim2.fromOffset(12,29)
    msg.Size=UDim2.new(1,-25,0,27)
    msg.TextWrapped=true

    local bar=New("Frame",n,{
        Size=UDim2.new(1,0,0,2),
        Position=UDim2.new(0,0,1,-2),
        BackgroundColor3=Theme.Accent
    })

    n.Position=UDim2.new(1,320,0,0)

    Tween(n,.3,{
        Position=UDim2.new(0,0,0,0)
    })

    local duration=c.Duration or 4

    Tween(bar,duration,{
        Size=UDim2.new(0,0,0,2)
    })

    task.delay(duration,function()
        if n.Parent then
            Tween(n,.25,{
                Position=UDim2.new(1,320,0,0)
            })
            task.wait(.25)
            n:Destroy()
        end
    end)

    return n
end

function NovaUI:CreateKeySystem(c)
    c=c or {}

    local gui=New("ScreenGui",PG,{
        Name="NovaUI_KeySystem",
        ResetOnSpawn=false,
        IgnoreGuiInset=true
    })

    local box=New("Frame",gui,{
        Size=UDim2.fromOffset(390,250),
        Position=UDim2.new(.5,-195,.5,-125),
        BackgroundColor3=Theme.Background
    })
    Corner(box,12)
    Stroke(box,Theme.Accent,1)

    local title=Text(box,c.Title or "NovaUI",18,Theme.Text)
    title.Position=UDim2.fromOffset(20,18)
    title.Size=UDim2.new(1,-40,0,25)

    local sub=Text(box,c.Subtitle or "Key System",11,Theme.Sub)
    sub.Position=UDim2.fromOffset(21,45)
    sub.Size=UDim2.new(1,-42,0,20)

    local note=Text(box,c.Note or "Introduce tu key para continuar.",11,Theme.Sub)
    note.Position=UDim2.fromOffset(20,72)
    note.Size=UDim2.new(1,-40,0,35)
    note.TextWrapped=true

    local input=New("TextBox",box,{
        Size=UDim2.new(1,-40,0,42),
        Position=UDim2.fromOffset(20,115),
        PlaceholderText="Enter key...",
        Text="",
        TextSize=12,
        Font=Enum.Font.Gotham,
        TextColor3=Theme.Text,
        PlaceholderColor3=Theme.Sub,
        BackgroundColor3=Theme.Element,
        ClearTextOnFocus=false
    })
    Corner(input,7)

    local verify=New("TextButton",box,{
        Size=UDim2.new(1,-40,0,40),
        Position=UDim2.fromOffset(20,168),
        Text="Verify",
        TextSize=12,
        Font=Enum.Font.GothamMedium,
        TextColor3=Theme.Text,
        BackgroundColor3=Theme.Accent
    })
    Corner(verify,7)

    local status=Text(box,"",11,Theme.Sub)
    status.Position=UDim2.fromOffset(20,214)
    status.Size=UDim2.new(1,-40,0,20)
    status.TextXAlignment=Enum.TextXAlignment.Center

    local obj={Valid=false,GUI=gui}

    verify.MouseButton1Click:Connect(function()
        if input.Text==c.Key then
            obj.Valid=true
            status.Text="✓ Key válida"
            status.TextColor3=Color3.fromRGB(80,220,120)

            task.wait(.4)
            gui:Destroy()
        else
            obj.Valid=false
            status.Text="✕ Key inválida"
            status.TextColor3=Color3.fromRGB(255,90,90)
        end
    end)

    function obj:IsValid()
        return self.Valid
    end

    return obj
end

function NovaUI:SetTheme(name)
    if not NovaUI.Themes[name] then return end
    Theme=NovaUI.Themes[name]

    self.Main.BackgroundColor3=Theme.Background
    self.Top.BackgroundColor3=Theme.Secondary
    self.Border.Color=Theme.Accent
end

function NovaUI:SetRGB(enabled,speed)
    self.RGBBorders=enabled
    self.RGBSpeed=speed or self.RGBSpeed or 120

    if enabled then
        self:StartRGB()
    else
        self.Border.Color=Theme.Accent
    end
end

function NovaUI:SetSubtitle(text)
    self.Subtitle=text
    self.SubLabel.Text=text
end

function NovaUI:SetTitle(text)
    self.Title=text
    self.TitleLabel.Text=text
end

function NovaUI:SaveConfig(data)
    self.Config=data or {}
    return self.Config
end

function NovaUI:LoadConfig()
    return self.Config or {}
end

return NovaUI
