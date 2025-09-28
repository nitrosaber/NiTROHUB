-- Gui to Lua
-- Version: 3.2
-- Modified by Gemini for Mobile Usability (Toggle, Draggable UI)

-- Instances:

local LayoutsStealer = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Players = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")
local Main = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Layouts = Instance.new("ScrollingFrame")
local UIListLayout_2 = Instance.new("UIListLayout")
local UIPadding_2 = Instance.new("UIPadding")
local ItemTemplate = Instance.new("ImageLabel")
local Amount = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")
local LayoutTemplate = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")
local Items = Instance.new("ScrollingFrame")
local UIGridLayout = Instance.new("UIGridLayout")
local UIPadding_3 = Instance.new("UIPadding")
local LayoutName = Instance.new("TextLabel")
local UICorner_5 = Instance.new("UICorner")
local ItemCount = Instance.new("TextLabel")
local UICorner_6 = Instance.new("UICorner")
local StealLayout = Instance.new("TextButton")
local UICorner_7 = Instance.new("UICorner")
local Frame = Instance.new("Frame")
local UICorner_8 = Instance.new("UICorner")
local Missing = Instance.new("TextButton")
local UICorner_9 = Instance.new("UICorner")
local LoaddingMessage = Instance.new("TextLabel")
local UICorner_10 = Instance.new("UICorner")
local PlayerTemplate = Instance.new("TextButton")
local UICorner_11 = Instance.new("UICorner")
local PlayerImage = Instance.new("ImageLabel")
local UICorner_12 = Instance.new("UICorner")
local Display = Instance.new("TextLabel")
local User = Instance.new("TextLabel")
local UICorner_13 = Instance.new("UICorner")
local WaterMark = Instance.new("TextLabel")
local UICorner_14 = Instance.new("UICorner")
local MissingItems = Instance.new("Frame")
local UICorner_15 = Instance.new("UICorner")
local Items_2 = Instance.new("ScrollingFrame")
local UIGridLayout_2 = Instance.new("UIGridLayout")
local UIPadding_4 = Instance.new("UIPadding")
local Close = Instance.new("TextButton")
local UICorner_16 = Instance.new("UICorner")

--Properties:

LayoutsStealer.Name = "LayoutsStealer"
LayoutsStealer.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
LayoutsStealer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LayoutsStealer.ResetOnSpawn = false -- [+] ป้องกัน GUI รีเซ็ตเมื่อตัวละครเกิดใหม่

-- [*] การตั้งค่า MainFrame ถูกปรับปรุงเพื่อรองรับการเปิด/ปิดและลาก
MainFrame.Name = "MainFrame"
MainFrame.Parent = LayoutsStealer
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0) -- [*] ปรับขนาดให้เหมาะสมกับหน้าจอโดยรวม
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- [*] ยึดตำแหน่งจากจุดกึ่งกลาง
MainFrame.Position = UDim2.new(0.5, 0, -1, 0) -- [*] ตำแหน่งเริ่มต้น (ซ่อนอยู่นอกจอด้านบน)
MainFrame.Visible = false -- [*] เริ่มต้นแบบซ่อน
MainFrame.Active = true -- [+] ทำให้สามารถรับ Input ได้ (สำหรับการลาก)
MainFrame.Draggable = true -- [+] ทำให้ลากย้ายตำแหน่งได้
local mainFrameCorner = Instance.new("UICorner") -- [+] เพิ่มความมนให้กับ MainFrame
mainFrameCorner.Parent = MainFrame

Players.Name = "Players"
Players.Parent = MainFrame
Players.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Players.Position = UDim2.new(0, -10, 0, 0)
Players.Size = UDim2.new(0.224999994, 0, 1, 0)

UICorner.Parent = Players

UIListLayout.Parent = Players
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

UIPadding.Parent = Players
UIPadding.PaddingBottom = UDim.new(0, 5)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)
UIPadding.PaddingTop = UDim.new(0, 5)

Main.Name = "Main"
Main.Parent = MainFrame
Main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Main.Position = UDim2.new(0.224999994, 0, 0, 0)
Main.Size = UDim2.new(0.774999976, 0, 1, 0)

UICorner_2.Parent = Main

Layouts.Name = "Layouts"
Layouts.Parent = Main
Layouts.Active = true
Layouts.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Layouts.BackgroundTransparency = 1.000
Layouts.BorderSizePixel = 0
Layouts.Size = UDim2.new(1, 0, 1, 0)
Layouts.CanvasSize = UDim2.new(0, 0, 0, 0)
Layouts.ScrollBarThickness = 6

UIListLayout_2.Parent = Layouts
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Padding = UDim.new(0, 5)

UIPadding_2.Parent = Layouts
UIPadding_2.PaddingBottom = UDim.new(0, 10)
UIPadding_2.PaddingLeft = UDim.new(0, 10)
UIPadding_2.PaddingRight = UDim.new(0, 10)
UIPadding_2.PaddingTop = UDim.new(0, 10)

ItemTemplate.Name = "ItemTemplate"
ItemTemplate.Parent = MainFrame
ItemTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ItemTemplate.Size = UDim2.new(0, 100, 0, 100)
ItemTemplate.Visible = false
ItemTemplate.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

Amount.Name = "Amount"
Amount.Parent = ItemTemplate
Amount.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Amount.BackgroundTransparency = 1.000
Amount.Position = UDim2.new(0.649999976, 0, 0.699999988, 0)
Amount.Size = UDim2.new(0.349999994, 0, 0.300000012, 0)
Amount.Font = Enum.Font.ArialBold
Amount.Text = "X400"
Amount.TextColor3 = Color3.fromRGB(225, 225, 225)
Amount.TextScaled = true
Amount.TextSize = 14.000
Amount.TextStrokeTransparency = 0.000
Amount.TextWrapped = true

UICorner_3.Parent = ItemTemplate

LayoutTemplate.Name = "LayoutTemplate"
LayoutTemplate.Parent = MainFrame
LayoutTemplate.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LayoutTemplate.Size = UDim2.new(1, -20, 0, 250)
LayoutTemplate.Visible = false

UICorner_4.Parent = LayoutTemplate

Items.Name = "Items"
Items.Parent = LayoutTemplate
Items.Active = true
Items.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Items.BackgroundTransparency = 1.000
Items.BorderSizePixel = 0
Items.Position = UDim2.new(0, 0, 0.150000006, 5)
Items.Size = UDim2.new(1, 0, 0.850000024, -10)
Items.ZIndex = 2
Items.CanvasSize = UDim2.new(0,0,0,0)
Items.AutomaticCanvasSize = Enum.AutomaticSize.Y
Items.ScrollBarThickness = 5

UIGridLayout.Parent = Items
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellSize = UDim2.new(0, 50, 0, 50)

UIPadding_3.Parent = Items
UIPadding_3.PaddingLeft = UDim.new(0, 5)
UIPadding_3.PaddingRight = UDim.new(0, 5)

LayoutName.Name = "LayoutName"
LayoutName.Parent = LayoutTemplate
LayoutName.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
LayoutName.Position = UDim2.new(0, 5, 0.0199999996, 0)
LayoutName.Size = UDim2.new(0.200000003, 0, 0.125, 0)
LayoutName.Font = Enum.Font.SourceSansBold
LayoutName.Text = "Layout X"
LayoutName.TextColor3 = Color3.fromRGB(255, 255, 255)
LayoutName.TextScaled = true
LayoutName.TextSize = 14.000
LayoutName.TextTransparency = 0.500
LayoutName.TextWrapped = true

UICorner_5.Parent = LayoutName

ItemCount.Name = "ItemCount"
ItemCount.Parent = LayoutTemplate
ItemCount.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ItemCount.Position = UDim2.new(0.224999994, 5, 0.0199999996, 0)
ItemCount.Size = UDim2.new(0.224999994, -5, 0.125, 0)
ItemCount.Font = Enum.Font.SourceSansBold
ItemCount.Text = "Item Count: 250"
ItemCount.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemCount.TextScaled = true
ItemCount.TextSize = 14.000
ItemCount.TextTransparency = 0.500
ItemCount.TextWrapped = true

UICorner_6.Parent = ItemCount

StealLayout.Name = "StealLayout"
StealLayout.Parent = LayoutTemplate
StealLayout.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
StealLayout.Position = UDim2.new(0.75, -5, 0.0199999996, 0)
StealLayout.Size = UDim2.new(0.25, 0, 0.125, 0)
StealLayout.Font = Enum.Font.SourceSansBold
StealLayout.Text = "Steal This Layout"
StealLayout.TextColor3 = Color3.fromRGB(255, 255, 255)
StealLayout.TextScaled = true
StealLayout.TextSize = 14.000
StealLayout.TextTransparency = 0.500
StealLayout.TextWrapped = true

UICorner_7.Parent = StealLayout

Frame.Parent = LayoutTemplate
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Position = UDim2.new(0, 5, 0.150000006, 5)
Frame.Size = UDim2.new(1, -10, 0.850000024, -10)

UICorner_8.Parent = Frame

Missing.Name = "Missing"
Missing.Parent = LayoutTemplate
Missing.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Missing.Position = UDim2.new(0.474999994, 0, 0.0199999996, 0)
Missing.Size = UDim2.new(0.25, -5, 0.125, 0)
Missing.Font = Enum.Font.SourceSansBold
Missing.Text = "Show Missing Items"
Missing.TextColor3 = Color3.fromRGB(255, 255, 255)
Missing.TextScaled = true
Missing.TextSize = 14.000
Missing.TextTransparency = 0.500
Missing.TextWrapped = true

UICorner_9.Parent = Missing

LoaddingMessage.Name = "LoaddingMessage"
LoaddingMessage.Parent = MainFrame
LoaddingMessage.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
LoaddingMessage.Position = UDim2.new(0, -10, 0, -30)
LoaddingMessage.Size = UDim2.new(1, 0, 0, 25)
LoaddingMessage.Visible = false
LoaddingMessage.Font = Enum.Font.SourceSansBold
LoaddingMessage.Text = "Loading layouts. The game will lag a bit while doing this please be patient."
LoaddingMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
LoaddingMessage.TextScaled = true
LoaddingMessage.TextSize = 14.000
LoaddingMessage.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
LoaddingMessage.TextWrapped = true

UICorner_10.Parent = LoaddingMessage

PlayerTemplate.Name = "PlayerTemplate"
PlayerTemplate.Parent = MainFrame
PlayerTemplate.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerTemplate.Size = UDim2.new(1, 0, 0, 50)
PlayerTemplate.Visible = false
PlayerTemplate.Font = Enum.Font.SourceSans
PlayerTemplate.Text = ""
PlayerTemplate.TextColor3 = Color3.fromRGB(0, 0, 0)
PlayerTemplate.TextSize = 14.000
PlayerTemplate.TextTransparency = 1.000

UICorner_11.Parent = PlayerTemplate

PlayerImage.Name = "PlayerImage"
PlayerImage.Parent = PlayerTemplate
PlayerImage.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerImage.Size = UDim2.new(0, 50, 0, 50)
PlayerImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

UICorner_12.Parent = PlayerImage

Display.Name = "Display"
Display.Parent = PlayerTemplate
Display.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Display.BackgroundTransparency = 1.000
Display.Position = UDim2.new(0, 55, 0, 0)
Display.Size = UDim2.new(1, -55, 0.5, 0)
Display.Font = Enum.Font.SourceSansBold
Display.Text = "OnlyTwentyCharacters"
Display.TextColor3 = Color3.fromRGB(255, 255, 255)
Display.TextScaled = true
Display.TextSize = 14.000
Display.TextWrapped = true

User.Name = "User"
User.Parent = PlayerTemplate
User.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
User.BackgroundTransparency = 1.000
User.Position = UDim2.new(0, 55, 0.5, 0)
User.Size = UDim2.new(1, -55, 0.5, 0)
User.Font = Enum.Font.SourceSansBold
User.Text = "OnlyTwentyCharacters"
User.TextColor3 = Color3.fromRGB(255, 255, 255)
User.TextScaled = true
User.TextSize = 14.000
User.TextWrapped = true

WaterMark.Name = "WaterMark"
WaterMark.Parent = MainFrame
WaterMark.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
WaterMark.BackgroundTransparency = 2.000
WaterMark.BorderColor3 = Color3.fromRGB(170, 170, 0)
WaterMark.Position = UDim2.new(1, -50, 1, -22)
WaterMark.Size = UDim2.new(0, 50, 0, 20)
WaterMark.Font = Enum.Font.SourceSansBold
WaterMark.Text = "MX6"
WaterMark.TextColor3 = Color3.fromRGB(170, 170, 0)
WaterMark.TextScaled = true
WaterMark.TextSize = 14.000
WaterMark.TextTransparency = 0.500
WaterMark.TextWrapped = true

UICorner_14.Parent = WaterMark

MissingItems.Name = "MissingItems"
MissingItems.Parent = LayoutsStealer
MissingItems.AnchorPoint = Vector2.new(0, 0.5)
MissingItems.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MissingItems.Position = UDim2.new(1, -310, 0.5, 0)
MissingItems.Size = UDim2.new(0, 300, 0, 500)
MissingItems.Visible = false

UICorner_15.Parent = MissingItems

Items_2.Name = "Items"
Items_2.Parent = MissingItems
Items_2.Active = true
Items_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Items_2.BackgroundTransparency = 1.000
Items_2.BorderSizePixel = 0
Items_2.Size = UDim2.new(1, 0, 1, 0)
Items_2.CanvasSize = UDim2.new(0, 0, 0, 0)
Items_2.AutomaticCanvasSize = Enum.AutomaticSize.Y

UIGridLayout_2.Parent = Items_2
UIGridLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout_2.CellSize = UDim2.new(0, 82, 0, 82)

UIPadding_4.Parent = Items_2
UIPadding_4.PaddingLeft = UDim.new(0, 5)
UIPadding_4.PaddingRight = UDim.new(0, 5)

Close.Name = "Close"
Close.Parent = MissingItems
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Close.Position = UDim2.new(0, -30, 0, 10)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Font = Enum.Font.Arcade
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(0, 0, 0)
Close.TextScaled = true
Close.TextSize = 14.000
Close.TextWrapped = true

UICorner_16.Parent = Close

-- =========================================================================================
-- ||                     ส่วนของโค้ดหลัก (ทำงานเหมือนเดิมทุกประการ)                          ||
-- =========================================================================================

local findItem = require(game.ReplicatedStorage.FetchItem)
local HasItem = game.ReplicatedStorage.HasItem
local Withdraw = game.ReplicatedStorage.DestroyAll
local PlaceItem = game.ReplicatedStorage.PlaceItem 
local buyItem = game.ReplicatedStorage.BuyItem 
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService") -- [+] เรียกใช้ TweenService

local RealAmount = Instance.new("IntValue")
RealAmount.Name = "RealAmount"
RealAmount.Value = 0
RealAmount.Parent = ItemTemplate

local Count1 =Instance.new("IntValue")
Count1.Name = "Count"
Count1.Value = 0
Count1.Parent = LayoutTemplate

local Count2 =Instance.new("IntValue")
Count2.Name = "Count"
Count2.Value = 0
Count2.Parent = MissingItems

local Player = game.Players.LocalPlayer

function GetPlayerImage(Object)
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size420x420
	local content, isReady = game.Players:GetUserThumbnailAsync(Object.userId, thumbType, thumbSize)
	return content
end

function PositionConvert(Item)
	local StealBase = Item.Parent.Base
	local PlayerBase = Player.PlayerTycoon.Value.Base
	local NewPos = Item.Hitbox.CFrame - StealBase.Position
	local PlacePos = NewPos+PlayerBase.Position
	return PlacePos
end

function Message(Text)
	local SafeText = LoaddingMessage.Text
	LoaddingMessage.Text = Text
	LoaddingMessage.Visible = true
	task.wait(3)
	LoaddingMessage.Visible = false
	LoaddingMessage.Text = SafeText
end

function clearMissing()
	for i,v in pairs(MissingItems.Items:GetChildren()) do
		task.spawn(function()
			if v:IsA("ImageLabel") then
				v:Destroy()
			end
		end)
	end
end

function FindMissing(Layout)
	clearMissing()
	task.wait(0.01)
	local ItemCountValue = Count2
	Count2.Value = 0
	MissingItems.Visible =true
	for i,Item in pairs(Layout) do
		task.spawn(function()
			local RealItem = findItem:Get(Item.ItemId)
			if HasItem:InvokeServer(RealItem.ItemId.Value) <=0 then
				if MissingItems.Items:FindFirstChild(RealItem.Name) then
					local Item = MissingItems.Items:FindFirstChild(RealItem.Name)
					Item.RealAmount.Value =Item.RealAmount.Value +1
					Item.Amount.Text = "X"..Item.RealAmount.Value
				else
					local Clone = ItemTemplate:Clone()
					Clone.Name = RealItem.Name
					Clone.Image = "rbxassetid://"..RealItem.ThumbnailId.Value
					Clone.Parent = MissingItems.Items
					Clone.RealAmount.Value = 1
					Clone.Visible = true
					Clone.Amount.Text = "X"..Clone.RealAmount.Value
					ItemCountValue.Value = ItemCountValue.Value +1
				end
			end
		end)
	end
end

function SaveLayout(Layout)
	Withdraw:InvokeServer()
	print(Player.PlayerTycoon.Value.Base.CFrame)
	for i,Item in pairs(Layout) do
		task.spawn(function()
			local RealItem = findItem:Get(Item.ItemId)
			local Tycoon = Player.PlayerTycoon.Value
			local TycoonBase = Tycoon.Base
			local TycoonTopLeft = TycoonBase.CFrame * CFrame.new(Vector3.new(TycoonBase.Size.x/2, 0, TycoonBase.Size.z/2))		
			Item.Position[1] = tonumber(Item.Position[1])
			Item.Position[2] = tonumber(Item.Position[2])
			Item.Position[3] = tonumber(Item.Position[3])	

			local HitboxDirection = Vector3.new()
			local DirectionValue = Item.Position[4]

			local Position = TycoonTopLeft * Vector3.new(Item.Position[1], Item.Position[2], Item.Position[3])
			local lookVector = Vector3.new(Item.Position[4],Item.Position[5],Item.Position[6])
			local CoordinateFrame = CFrame.new(Position, Position + (lookVector * 5))

			if RealItem.ItemType.Value >=1 and RealItem.ItemType.Value <5  then
				if Player.PlayerGui.GUI.Money.Value >= RealItem.Cost.Value then
					buyItem:InvokeServer(RealItem.Name,1)
					PlaceItem:InvokeServer(RealItem.Name,  CoordinateFrame, {Player.PlayerTycoon.Value.Base}) 
				else
					print("Cant buy item :(")
				end
			else
				if HasItem:InvokeServer(RealItem.ItemId.Value) >0 then
					PlaceItem:InvokeServer(RealItem.Name,  CoordinateFrame, {Player.PlayerTycoon.Value.Base}) 
				else
					print("You Dont have "..RealItem.Name)
				end
			end 
		end)
	end
	Message("Loading Finnished. Check F9/Dev menu for item that didnt get placed")
end

function SaveBase(Base)
	Withdraw:InvokeServer()
	for i,v in pairs(Base:GetChildren()) do
		task.spawn(function()
			if v:FindFirstChild("ItemId") then
				local Pos = v.Hitbox.CFrame - Base.Base.Position
				local PlacePos = Pos + Player.PlayerTycoon.Value.Base.Position
				if v.ItemType.Value >=1 and v.ItemType.Value <5  then
					if Player.PlayerGui.GUI.Money.Value >= v.Cost.Value then
						buyItem:InvokeServer(v.Name,1)
						PlaceItem:InvokeServer(v.Name,  PlacePos, {Player.PlayerTycoon.Value.Base}) 
					else
						print("Cant buy item :(")
					end
				else
					if HasItem:InvokeServer(v.ItemId.Value) >0 then
						PlaceItem:InvokeServer(v.Name,  PlacePos, {Player.PlayerTycoon.Value.Base}) 
					else
						print("You Dont have "..v.Name)
					end
				end 
			end
		end)
	end
	Message("Loading Finnished. Check F9/Dev menu for item that didnt get placed")
end

function ClearLayoutsFrame()
	for i,v in pairs(Layouts:GetChildren()) do
		if v and v:IsA("Frame") then
			v:Destroy()
		end
	end
end

function ClearPlayers()
	for i,v in pairs(Players:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

function LoadPlayersLayouts(SelectedPlayer)
	LoaddingMessage.Visible = true
	ClearLayoutsFrame()
	local PlayerLayouts = SelectedPlayer.Layouts
	for x,Layout in pairs(PlayerLayouts:GetChildren()) do
		local Frame = LayoutTemplate:Clone()
		Frame.LayoutName.Text = Layout.Name 
		Frame.Visible = true
		Frame.Parent = Layouts
		local layoutItems = game.HttpService:JSONDecode(Layout.Value)
		local LayoutNumber = string.gsub(tostring(Layout.Name), "%D", "")
		Frame.LayoutOrder = tonumber(LayoutNumber) or x
		local RealItemCount = 0
		local ItemCountValue = 0
		for a,Item in pairs(layoutItems) do
			if Item then
				local RealItem = findItem:Get(Item.ItemId)
				if RealItem then
					if Frame.Items:FindFirstChild(RealItem.Name) then
						local Item = Frame.Items:FindFirstChild(RealItem.Name)
						Item.RealAmount.Value =Item.RealAmount.Value +1
						RealItemCount = RealItemCount +1
						Item.Amount.Text = "X"..Item.RealAmount.Value
					else
						local Clone = ItemTemplate:Clone()
						Clone.Name = RealItem.Name
						Clone.Image = "rbxassetid://"..RealItem.ThumbnailId.Value
						Clone.Parent = Frame.Items
						Clone.RealAmount.Value = 1
						Clone.Visible = true
						Clone.Amount.Text = "X"..Clone.RealAmount.Value
						ItemCountValue = ItemCountValue +1
						RealItemCount = RealItemCount +1
					end
				end
			end
		end
		Frame.Visible = true
		Layouts.CanvasSize = UDim2.new(0,0,0,260*x)
		Frame.ItemCount.Text = "Item Count: ".. RealItemCount
		Frame.Count.Value  =ItemCountValue

		Frame.StealLayout.MouseButton1Click:Connect(function()
			if Player:FindFirstChild("BaseDataLoaded") then
				SaveLayout(layoutItems)
			else
				Message("You have to load in to the game first.")
			end
		end)
		Frame.Missing.MouseButton1Click:Connect(function()
			FindMissing(layoutItems)
		end)
	end
	pcall(function()
		local Frame = LayoutTemplate:Clone()
		Frame.LayoutName.Text = "Current Base Layout" 
		Frame.LayoutOrder = 0
		Frame.Visible = true
		Frame.Parent = Layouts
		Frame.StealLayout.Text =  "Steal current Base"
		local RealItemCount = 0
		local ItemCountValue = 0
		local Base = SelectedPlayer.PlayerTycoon.Value
		for a,BaseItem in pairs(Base:GetChildren()) do 
			if BaseItem:FindFirstChild("ItemId") then
				if Frame.Items:FindFirstChild(BaseItem.Name) then
					local Item = Frame.Items:FindFirstChild(BaseItem.Name)
					Item.RealAmount.Value =Item.RealAmount.Value +1
					RealItemCount = RealItemCount +1
					Item.Amount.Text = "X"..Item.RealAmount.Value
				else
					local Clone = ItemTemplate:Clone()
					Clone.Name = BaseItem.Name
					Clone.Image = "rbxassetid://"..BaseItem.ThumbnailId.Value
					Clone.Parent = Frame.Items
					Clone.RealAmount.Value = 1
					Clone.Visible = true
					Clone.Amount.Text = "X"..Clone.RealAmount.Value
					ItemCountValue = ItemCountValue +1
					RealItemCount = RealItemCount +1
				end
			end
		end

		Frame.ItemCount.Text = "Item Count: ".. RealItemCount
		Frame.Count.Value = ItemCountValue
		Layouts.CanvasSize = Layouts.CanvasSize + UDim2.new(0,0,0,260)
		Frame.StealLayout.MouseButton1Click:Connect(function()
			if Player:FindFirstChild("BaseDataLoaded") then
				SaveBase(Base)
			else
				Message("You have to load in to the game first.")
			end
		end)
	end)
	Message("Loading is complete enjoy stealing:)")
end

function GetPlayers()
	ClearPlayers()
	for i,v in pairs(game.Players:GetChildren()) do
		local PlayerClone = PlayerTemplate:Clone()
		PlayerClone.Name = v.Name
		PlayerClone.User.Text = v.Name
		PlayerClone.Display.Text = v.DisplayName
		PlayerClone.PlayerImage.Image = GetPlayerImage(v)
		PlayerClone.Parent = Players
		PlayerClone.Visible = true

		PlayerClone.MouseButton1Click:Connect(function()
			if v:FindFirstChild("BaseDataLoaded") then
				LoadPlayersLayouts(v)
			else
				Message("Players is not loaded in please select another player")
			end
		end)
	end
end

Close.MouseButton1Click:Connect(function()
	MissingItems.Visible = false
end)

GetPlayers()
game.Players.PlayerAdded:Connect(GetPlayers)
game.Players.PlayerRemoving:Connect(GetPlayers)

-- =========================================================================================
-- ||                     [+] โค้ดใหม่สำหรับเปิด/ปิด และควบคุม UI                             ||
-- =========================================================================================

local isUiVisible = false

-- สร้างปุ่มสำหรับเปิด/ปิด UI
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = LayoutsStealer
ToggleButton.Size = UDim2.fromOffset(50, 50)
ToggleButton.Position = UDim2.new(0, 15, 0, 15) -- ตำแหน่งมุมซ้ายบน
ToggleButton.Text = "⚙️" -- ใช้อิโมจิ
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 30
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.Draggable = true -- ทำให้ปุ่มลากได้
ToggleButton.Active = true

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = ToggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(80, 80, 80)
toggleStroke.Thickness = 1
toggleStroke.Parent = ToggleButton

-- ฟังก์ชันสำหรับควบคุมการเปิด/ปิด
ToggleButton.MouseButton1Click:Connect(function()
    isUiVisible = not isUiVisible

    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local targetPosition

    if isUiVisible then
        MainFrame.Visible = true
        targetPosition = UDim2.new(0.5, 0, 0.5, 0) -- ตำแหน่งกลางจอ
    else
        targetPosition = UDim2.new(0.5, 0, -1, 0) -- เลื่อนกลับไปซ่อนนอกจอ
    end
    
    local tween = TweenService:Create(MainFrame, tweenInfo, { Position = targetPosition })
    tween:Play()

    -- ถ้าเป็นการปิด ให้ซ่อน Frame หลังจากอนิเมชันจบ
    if not isUiVisible then
        tween.Completed:Connect(function()
            MainFrame.Visible = false
        end)
    end
end)

-- [-] ลบโค้ดเก่าที่ใช้ปุ่ม 'K'
--[[
UIS.InputBegan:Connect(function(Input)
	if UIS:GetFocusedTextBox() == nil then
		if Input.KeyCode == Enum.KeyCode.K then
			MainFrame.Visible = not MainFrame.Visible
		end
	end
end)
]]
