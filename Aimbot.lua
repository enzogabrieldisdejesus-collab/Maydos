-- V REDLINE | Arceus Mobile | Aimbot + ESP
local P=game:GetService("Players")
local R=game:GetService("RunService")
local U=game:GetService("UserInputService")
local T=game:GetService("TweenService")
local G=game:GetService("CoreGui")
local LP=P.LocalPlayer
local CAM=workspace.CurrentCamera

local C={aim=false,fov=120,smooth=0.15,part="Head",team=true,esp=false,
names=true,dist=true,hp=true,maxd=2000}

local ACC=Color3.fromRGB(200,20,30)
local ACCB=Color3.fromRGB(255,45,55)
local BG=Color3.fromRGB(12,12,12)
local SURF=Color3.fromRGB(22,22,22)
local TXT=Color3.fromRGB(240,240,240)
local OFF=Color3.fromRGB(45,45,45)

local function N(c,p,par)
local i=Instance.new(c)
for k,v in pairs(p or {}) do i[k]=v end
if par then i.Parent=par end
return i
end

local function same(p)
if not C.team then return false end
if not LP.Team or not p.Team then return false end
return LP.Team==p.Team
end

local function part(ch,n)
if not ch then return nil end
return ch:FindFirstChild(n) or ch:FindFirstChild("HumanoidRootPart")
or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
end

local function drag(f,h)
h=h or f
local d,di,ds,sp
h.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1
or i.UserInputType==Enum.UserInputType.Touch then
d=true ds=i.Position sp=f.Position
i.Changed:Connect(function()
if i.UserInputState==Enum.UserInputState.End then d=false end
end)
end
end)
h.InputChanged:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseMovement
or i.UserInputType==Enum.UserInputType.Touch then di=i end
end)
U.InputChanged:Connect(function(i)
if i==di and d then
local dl=i.Position-ds
f.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dl.X,sp.Y.Scale,sp.Y.Offset+dl.Y)
end
end)
end

-- ESP
local E={}
local function mkESP(p)
if p==LP or same(p) or E[p] then return end
local ch=p.Character
if not ch then return end
local hd=ch:FindFirstChild("Head")
local hm=ch:FindFirstChildOfClass("Humanoid")
if not hd or not hm then return end
local e={}
e.hl=N("Highlight",{FillColor=ACC,FillTransparency=0.75,
OutlineColor=ACC,OutlineTransparency=0,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,
Parent=ch})
local bb=N("BillboardGui",{Size=UDim2.new(0,200,0,50),
StudsOffset=Vector3.new(0,3,0),AlwaysOnTop=true,Parent=hd})
e.nl=N("TextLabel",{Size=UDim2.new(1,0,0.5,0),BackgroundTransparency=1,
TextColor3=ACC,TextStrokeTransparency=0,TextStrokeColor3=Color3.new(),
Font=Enum.Font.GothamBold,TextSize=14,Text=p.Name,Parent=bb})
e.il=N("TextLabel",{Size=UDim2.new(1,0,0.5,0),Position=UDim2.new(0,0,0.5,0),
BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(),Font=Enum.Font.Gotham,TextSize=12,Text="",Parent=bb})
e.bb=bb E[p]=e
end

local function rmESP(p)
if E[p] then
if E[p].hl then E[p].hl:Destroy() end
if E[p].bb then E[p].bb:Destroy() end
E[p]=nil
end
end

local function upESP()
for p,e in pairs(E) do
if not p.Character or not p.Character.Parent then rmESP(p) continue end
local hr=p.Character:FindFirstChild("HumanoidRootPart")
local hm=p.Character:FindFirstChildOfClass("Humanoid")
if not hr or not hm then rmESP(p) continue end
local d=(hr.Position-CAM.CFrame.Position).Magnitude
if d>C.maxd then e.bb.Enabled=false e.hl.Enabled=false
else
e.bb.Enabled=true e.hl.Enabled=true
e.nl.Visible=C.names
e.il.Visible=C.dist or C.hp
local s=""
if C.dist then s=s..math.floor(d).."m" end
if C.hp then
if s~="" then s=s.." | " end
s=s..math.floor(hm.Health).." HP"
end
e.il.Text=s
end
end
end

-- Aimbot
local function closest()
local b,bs=nil,C.fov
for _,p in ipairs(P:GetPlayers()) do
if p~=LP and not same(p) then
local ch=p.Character
if ch then
local hm=ch:FindFirstChildOfClass("Humanoid")
if hm and hm.Health>0 then
local pt=part(ch,C.part)
if pt then
local sp,on=CAM:WorldToViewportPoint(pt.Position)
if on then
local sc=Vector2.new(CAM.ViewportSize.X/2,CAM.ViewportSize.Y/2)
local d=(Vector2.new(sp.X,sp.Y)-sc).Magnitude
if d<bs then bs=d b=p end
end
end
end
end
end
end
return b
end

local function aim(t)
if not t or not t.Character then return end
local pt=part(t.Character,C.part)
if not pt then return end
CAM.CFrame=CAM.CFrame:Lerp(CFrame.new(CAM.CFrame.Position,pt.Position),C.smooth)
end

-- UI
local old=G:FindFirstChild("V_RB_UI")
if old then old:Destroy() end
local sg=N("ScreenGui",{Name="V_RB_UI",ResetOnSpawn=false,
IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=G})
local mf=N("Frame",{Size=UDim2.new(0,270,0,340),
Position=UDim2.new(0.5,-135,0.3,0),BackgroundColor3=BG,
BorderSizePixel=0,Active=true,Parent=sg})
N("UICorner",{CornerRadius=UDim.new(0,10)},mf)
N("UIStroke",{Color=ACC,Thickness=1.5,Transparency=0.3},mf)
local tb=N("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=SURF,
BorderSizePixel=0,Parent=mf})
N("UICorner",{CornerRadius=UDim.new(0,10)},tb)
N("Frame",{Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,1,-10),
BackgroundColor3=SURF,BorderSizePixel=0,Parent=tb})
N("TextLabel",{Size=UDim2.new(1,-40,1,0),Position=UDim2.new(0,15,0,0),
BackgroundTransparency=1,TextColor3=ACCB,Font=Enum.Font.GothamBold,
TextSize=16,Text="V // ARCEUS",TextXAlignment=Enum.TextXAlignment.Left,Parent=tb})
local mb=N("TextButton",{Size=UDim2.new(0,30,0,30),Position=UDim2.new(1,-35,0,5),
BackgroundColor3=ACC,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,
TextSize=18,Text="−",Parent=tb})
N("UICorner",{CornerRadius=UDim.new(0,6)},mb)
drag(mf,tb)
local ct=N("Frame",{Size=UDim2.new(1,-20,1,-55),Position=UDim2.new(0,10,0,50),
BackgroundTransparency=1,Parent=mf})

local function tgl(y,l,st,cb)
local r=N("Frame",{Size=UDim2.new(1,0,0,32),Position=UDim2.new(0,0,0,y),
BackgroundTransparency=1,Parent=ct})
N("TextLabel",{Size=UDim2.new(1,-60,1,0),BackgroundTransparency=1,
TextColor3=TXT,Font=Enum.Font.Gotham,TextSize=13,Text=l,
TextXAlignment=Enum.TextXAlignment.Left,Parent=r})
local bg=N("Frame",{Size=UDim2.new(0,44,0,22),Position=UDim2.new(1,-44,0.5,-11),
BackgroundColor3=st and ACC or OFF,BorderSizePixel=0,Parent=r})
N("UICorner",{CornerRadius=UDim.new(1,0)},bg)
local kn=N("Frame",{Size=UDim2.new(0,16,0,16),
Position=UDim2.new(0,st and 24 or 4,0.5,-8),
BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=bg})
N("UICorner",{CornerRadius=UDim.new(1,0)},kn)
local s=st
local ca=N("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=r})
ca.MouseButton1Click:Connect(function()
s=not s
bg.BackgroundColor3=s and ACC or OFF
T:Create(kn,TweenInfo.new(0.15),{Position=UDim2.new(0,s and 24 or 4,0.5,-8)}):Play()
if cb then cb(s) end
end)
return r
end

local function sld(y,l,mn,mx,df,cb)
local r=N("Frame",{Size=UDim2.new(1,0,0,44),Position=UDim2.new(0,0,0,y),
BackgroundTransparency=1,Parent=ct})
N("TextLabel",{Size=UDim2.new(1,-60,0,20),BackgroundTransparency=1,
TextColor3=TXT,Font=Enum.Font.Gotham,TextSize=12,Text=l,
TextXAlignment=Enum.TextXAlignment.Left,Parent=r})
local vl=N("TextLabel",{Size=UDim2.new(0,50,0,20),Position=UDim2.new(1,-50,0,0),
BackgroundTransparency=1,TextColor3=ACCB,Font=Enum.Font.GothamBold,
TextSize=12,Text=tostring(df),TextXAlignment=Enum.TextXAlignment.Right,Parent=r})
local bb=N("Frame",{Size=UDim2.new(1,0,0,6),Position=UDim2.new(0,0,0,28),
BackgroundColor3=OFF,BorderSizePixel=0,Parent=r})
N("UICorner",{CornerRadius=UDim.new(1,0)},bb)
local fl=N("Frame",{Size=UDim2.new((df-mn)/(mx-mn),0,1,0),
BackgroundColor3=ACC,BorderSizePixel=0,Parent=bb})
N("UICorner",{CornerRadius=UDim.new(1,0)},fl)
local kn=N("Frame",{Size=UDim2.new(0,14,0,14),
Position=UDim2.new((df-mn)/(mx-mn),-7,0.5,-7),
BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=2,Parent=bb})
N("UICorner",{CornerRadius=UDim.new(1,0)},kn)
local dg=false
local function upd(i)
local bp=bb.AbsolutePosition.X
local bs=bb.AbsoluteSize.X
local rl=math.clamp((i.Position.X-bp)/bs,0,1)
local v=math.floor(mn+(mx-mn)*rl)
fl.Size=UDim2.new(rl,0,1,0)
kn.Position=UDim2.new(rl,-7,0.5,-7)
vl.Text=tostring(v)
if cb then cb(v) end
end
local ca=N("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.new(0,0,0,20),
BackgroundTransparency=1,Text="",Parent=r})
ca.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1
or i.UserInputType==Enum.UserInputType.Touch then
dg=true upd(i)
end
end)
U.InputChanged:Connect(function(i)
if dg and (i.UserInputType==Enum.UserInputType.MouseMovement
or i.UserInputType==Enum.UserInputType.Touch) then upd(i) end
end)
U.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1
or i.UserInputType==Enum.UserInputType.Touch then dg=false end
end)
return r
end

local y=0
N("TextLabel",{Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,0,y),
BackgroundTransparency=1,TextColor3=ACCB,Font=Enum.Font.GothamBold,
TextSize=11,Text="▸ AIMBOT",TextXAlignment=Enum.TextXAlignment.Left,Parent=ct})
y=y+22
tgl(y,"Aimbot",C.aim,function(s) C.aim=s end) y=y+36
tgl(y,"Team Check",C.team,function(s) C.team=s end) y=y+36
sld(y,"FOV",30,300,C.fov,function(v) C.fov=v end) y=y+50
N("TextLabel",{Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,0,y),
BackgroundTransparency=1,TextColor3=ACCB,Font=Enum.Font.GothamBold,
TextSize=11,Text="▸ ESP",TextXAlignment=Enum.TextXAlignment.Left,Parent=ct})
y=y+22
tgl(y,"ESP",C.esp,function(s)
C.esp=s
if s then for _,p in ipairs(P:GetPlayers()) do mkESP(p) end
else for p,_ in pairs(E) do rmESP(p) end end
end) y=y+36
tgl(y,"Names",C.names,function(s) C.names=s end) y=y+36
tgl(y,"Distance",C.dist,function(s) C.dist=s end) y=y+36
tgl(y,"Health",C.hp,function(s) C.hp=s end) y=y+36
tgl(y,"ESP Team Check",C.team,function(s)
C.team=s
for p,_ in pairs(E) do rmESP(p) end
if C.esp then for _,p in ipairs(P:GetPlayers()) do mkESP(p) end end
end) y=y+36
mf.Size=UDim2.new(0,270,0,y+75)

local mn=false
local os=mf.Size
mb.MouseButton1Click:Connect(function()
mn=not mn
if mn then mf.Size=UDim2.new(0,270,0,40) mb.Text="+"
else mf.Size=os mb.Text="−" end
end)

P.PlayerAdded:Connect(function(p)
p.CharacterAdded:Connect(function()
if C.esp then task.wait(0.5) mkESP(p) end
end)
end)
P.PlayerRemoving:Connect(function(p) rmESP(p) end)

R.RenderStepped:Connect(function()
if C.aim and U:IsKeyDown(Enum.KeyCode.E) and LP.Character then
local t=closest()
if t then aim(t) end
end
if C.esp then upESP() end
end)

local fc=N("Frame",{Size=UDim2.new(0,C.fov*2,0,C.fov*2),
Position=UDim2.new(0.5,-C.fov,0.5,-C.fov),
BackgroundTransparency=1,BorderSizePixel=0,Parent=sg,Visible=false})
N("UICorner",{CornerRadius=UDim.new(1,0)},fc)
N("UIStroke",{Color=ACC,Thickness=1,Transparency=0.5},fc)
R.RenderStepped:Connect(function()
if not C.aim then fc.Visible=false return end
fc.Visible=true
fc.Size=UDim2.new(0,C.fov*2,0,C.fov*2)
fc.Position=UDim2.new(0.5,-C.fov,0.5,-C.fov)
end)

if C.esp then for _,p in ipairs(P:GetPlayers()) do mkESP(p) end end
print("[V ARCEUS] loaded")
