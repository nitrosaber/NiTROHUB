local NiTroUi = {};

function NiTroUi:Window(Title, Description, Icon)
-- StarterGui.UiLibrary
NiTroUi["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
NiTroUi["1"]["IgnoreGuiInset"] = true;
NiTroUi["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
NiTroUi["1"]["Name"] = [[UiLibrary]];
NiTroUi["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
NiTroUi["1"]["ResetOnSpawn"] = false;


-- StarterGui.UiLibrary.NiTroHUBUI
NiTroUi["2"] = Instance.new("Frame", NiTroUi["1"]);
NiTroUi["2"]["BorderSizePixel"] = 0;
NiTroUi["2"]["BackgroundColor3"] = Color3.fromRGB(21, 21, 21);
NiTroUi["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
NiTroUi["2"]["Size"] = UDim2.new(0, 550, 0, 375);
NiTroUi["2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
NiTroUi["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["2"]["Name"] = [[NiTroHUBUI]];
NiTroUi["2"]["BackgroundTransparency"] = 0.05;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder
NiTroUi["3"] = Instance.new("Frame", NiTroUi["2"]);
NiTroUi["3"]["BorderSizePixel"] = 0;
NiTroUi["3"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
NiTroUi["3"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
NiTroUi["3"]["Size"] = UDim2.new(0, 550, 0, 375);
NiTroUi["3"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
NiTroUi["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["3"]["Name"] = [[Holder]];
NiTroUi["3"]["BackgroundTransparency"] = 0.5;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab
NiTroUi["4"] = Instance.new("Frame", NiTroUi["3"]);
NiTroUi["4"]["BorderSizePixel"] = 0;
NiTroUi["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["4"]["Size"] = UDim2.new(0, 144, 0, 288);
NiTroUi["4"]["Position"] = UDim2.new(0, 0, 0, 41);
NiTroUi["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["4"]["Name"] = [[ContainerTab]];
NiTroUi["4"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList
NiTroUi["5"] = Instance.new("Frame", NiTroUi["4"]);
NiTroUi["5"]["BorderSizePixel"] = 0;
NiTroUi["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["5"]["Size"] = UDim2.new(0, 144, 0, 335);
NiTroUi["5"]["Position"] = UDim2.new(0.5, -72, 0.5, -167);
NiTroUi["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["5"]["Name"] = [[TabList]];
NiTroUi["5"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame
NiTroUi["6"] = Instance.new("ScrollingFrame", NiTroUi["5"]);
NiTroUi["6"]["Active"] = true;
NiTroUi["6"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
NiTroUi["6"]["BorderSizePixel"] = 0;
NiTroUi["6"]["CanvasSize"] = UDim2.new(0, 0, 8, 0);
NiTroUi["6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["6"]["Size"] = UDim2.new(0, 135, 0, 334);
NiTroUi["6"]["ScrollBarImageColor3"] = Color3.fromRGB(255, 254, 254);
NiTroUi["6"]["Position"] = UDim2.new(0.5, -72, 0.49552, -144);
NiTroUi["6"]["BorderColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["6"]["ScrollBarThickness"] = 0;
NiTroUi["6"]["BackgroundTransparency"] = 1;
	
	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar
	NiTroUi["1d"] = Instance.new("Frame", NiTroUi["3"]);
	NiTroUi["1d"]["BorderSizePixel"] = 0;
	NiTroUi["1d"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
	NiTroUi["1d"]["Size"] = UDim2.new(0, 549, 0, 40);
	NiTroUi["1d"]["Position"] = UDim2.new(0.5, -274, 0, 0);
	NiTroUi["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["1d"]["Name"] = [[Topbar]];
	NiTroUi["1d"]["BackgroundTransparency"] = 0.05;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.TitleHub
	NiTroUi["1e"] = Instance.new("TextLabel", NiTroUi["1d"]);
	NiTroUi["1e"]["BorderSizePixel"] = 0;
	NiTroUi["1e"]["TextSize"] = 15;
	NiTroUi["1e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
	NiTroUi["1e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUi["1e"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
	NiTroUi["1e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUi["1e"]["BackgroundTransparency"] = 1;
	NiTroUi["1e"]["Size"] = UDim2.new(0, 60, 0, 30);
	NiTroUi["1e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["1e"]["Text"] = Title;
	NiTroUi["1e"]["Name"] = [[TitleHub]];
	NiTroUi["1e"]["Position"] = UDim2.new(0, 50, 0, -2);


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.Desc
	NiTroUi["1f"] = Instance.new("TextLabel", NiTroUi["1d"]);
	NiTroUi["1f"]["BorderSizePixel"] = 0;
	NiTroUi["1f"]["TextSize"] = 14;
	NiTroUi["1f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
	NiTroUi["1f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUi["1f"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
	NiTroUi["1f"]["TextColor3"] = Color3.fromRGB(123, 123, 123);
	NiTroUi["1f"]["BackgroundTransparency"] = 1;
	NiTroUi["1f"]["Size"] = UDim2.new(0, 60, 0, 14);
	NiTroUi["1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["1f"]["Text"] = Description;
	NiTroUi["1f"]["Name"] = [[Desc]];
	NiTroUi["1f"]["Position"] = UDim2.new(0, 50, 0, 20);


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.Minimize
	NiTroUi["20"] = Instance.new("ImageButton", NiTroUi["1d"]);
	NiTroUi["20"]["BorderSizePixel"] = 0;
	NiTroUi["20"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUi["20"]["Selectable"] = false;
	NiTroUi["20"]["Image"] = [[rbxassetid://10734896206]];
	NiTroUi["20"]["Size"] = UDim2.new(0, 20, 0, 20);
	NiTroUi["20"]["BackgroundTransparency"] = 1;
	NiTroUi["20"]["Name"] = [[Minimize]];
	NiTroUi["20"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["20"]["Position"] = UDim2.new(1, -30, 0, 10);


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.Minimize.LocalScript
	NiTroUi["21"] = Instance.new("LocalScript", NiTroUi["20"]);



	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.UICorner
	NiTroUi["22"] = Instance.new("UICorner", NiTroUi["1d"]);



	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.Icon
	NiTroUi["23"] = Instance.new("ImageLabel", NiTroUi["1d"]);
	NiTroUi["23"]["BorderSizePixel"] = 0;
	NiTroUi["23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUi["23"]["Image"] = Icon;
	NiTroUi["23"]["Size"] = UDim2.new(0, 35, 0, 35);
	NiTroUi["23"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["23"]["BackgroundTransparency"] = 1;
	NiTroUi["23"]["Name"] = [[Icon]];
	NiTroUi["23"]["Position"] = UDim2.new(0, 8, 0, 4);


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.LocalScript
	NiTroUi["24"] = Instance.new("LocalScript", NiTroUi["1d"]);



	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.UIAspectRatioConstraint
	NiTroUi["25"] = Instance.new("UIAspectRatioConstraint", NiTroUi["3"]);
	NiTroUi["25"]["AspectRatio"] = 1.46667;
	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.UICorner
	NiTroUi["1c"] = Instance.new("UICorner", NiTroUi["3"]);
end

function NiTroUi:AddTab(Title, Desc, Icon)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List
NiTroUi["7"] = Instance.new("Frame", NiTroUi["6"]);
NiTroUi["7"]["BorderSizePixel"] = 0;
NiTroUi["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["7"]["Size"] = UDim2.new(0, 132, 0, 333);
NiTroUi["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["7"]["Name"] = [[List]];
NiTroUi["7"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.dontchange
NiTroUi["8"] = Instance.new("Frame", NiTroUi["7"]);
NiTroUi["8"]["BorderSizePixel"] = 0;
NiTroUi["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["8"]["Size"] = UDim2.new(0, 125, 0, 20);
NiTroUi["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["8"]["Name"] = [[dontchange]];
NiTroUi["8"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.UIListLayout
NiTroUi["9"] = Instance.new("UIListLayout", NiTroUi["7"]);
NiTroUi["9"]["Padding"] = UDim.new(0, 5);
NiTroUi["9"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active
NiTroUi["a"] = Instance.new("Frame", NiTroUi["7"]);
NiTroUi["a"]["BorderSizePixel"] = 0;
NiTroUi["a"]["BackgroundColor3"] = Color3.fromRGB(59, 59, 59);
NiTroUi["a"]["Size"] = UDim2.new(0, 125, 0, 30);
NiTroUi["a"]["Position"] = UDim2.new(0, 0, 0.07508, 0);
NiTroUi["a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["a"]["Name"] = [[Active]];
NiTroUi["a"]["BackgroundTransparency"] = 0.5;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active.DescTab
NiTroUi["b"] = Instance.new("TextLabel", NiTroUi["a"]);
NiTroUi["b"]["BorderSizePixel"] = 0;
NiTroUi["b"]["TextSize"] = 10;
NiTroUi["b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUi["b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["b"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUi["b"]["TextColor3"] = Color3.fromRGB(123, 123, 123);
NiTroUi["b"]["BackgroundTransparency"] = 1;
NiTroUi["b"]["Size"] = UDim2.new(0, 55, 0, 10);
NiTroUi["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["b"]["Text"] = Desc;
NiTroUi["b"]["Name"] = [[DescTab]];
NiTroUi["b"]["Position"] = UDim2.new(0.28, 0, 0.5, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active.IconTab
NiTroUi["c"] = Instance.new("ImageLabel", NiTroUi["a"]);
NiTroUi["c"]["BorderSizePixel"] = 0;
NiTroUi["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["c"]["Image"] = Icon;
NiTroUi["c"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUi["c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["c"]["BackgroundTransparency"] = 1;
NiTroUi["c"]["Name"] = [[IconTab]];
NiTroUi["c"]["Position"] = UDim2.new(0.056, 0, 0.16667, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active.UIStroke
NiTroUi["d"] = Instance.new("UIStroke", NiTroUi["a"]);
NiTroUi["d"]["Color"] = Color3.fromRGB(53, 53, 53);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active.UICorner
NiTroUi["e"] = Instance.new("UICorner", NiTroUi["a"]);
NiTroUi["e"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active.TitleTab
NiTroUi["f"] = Instance.new("TextLabel", NiTroUi["a"]);
NiTroUi["f"]["BorderSizePixel"] = 0;
NiTroUi["f"]["TextSize"] = 13;
NiTroUi["f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUi["f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["f"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUi["f"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["f"]["BackgroundTransparency"] = 1;
NiTroUi["f"]["Size"] = UDim2.new(0, 55, 0, 20);
NiTroUi["f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["f"]["Text"] = Title;
NiTroUi["f"]["Name"] = [[TitleTab]];
NiTroUi["f"]["Position"] = UDim2.new(0.28, 0, 0, 0);

-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.Button
NiTroUi["16"] = Instance.new("Frame", NiTroUi["6"]);
NiTroUi["16"]["BorderSizePixel"] = 0;
NiTroUi["16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["16"]["Size"] = UDim2.new(0, 132, 0, 333);
NiTroUi["16"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["16"]["Name"] = [[Button]];
NiTroUi["16"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.Button.dontchange
NiTroUi["17"] = Instance.new("Frame", NiTroUi["16"]);
NiTroUi["17"]["BorderSizePixel"] = 0;
NiTroUi["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["17"]["Size"] = UDim2.new(0, 125, 0, 20);
NiTroUi["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["17"]["Name"] = [[dontchange]];
NiTroUi["17"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.Button.UIListLayout
NiTroUi["18"] = Instance.new("UIListLayout", NiTroUi["16"]);
NiTroUi["18"]["Padding"] = UDim.new(0, 5);
NiTroUi["18"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.Button.One
NiTroUi["19"] = Instance.new("TextButton", NiTroUi["16"]);
NiTroUi["19"]["BorderSizePixel"] = 0;
NiTroUi["19"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["19"]["TextSize"] = 13;
NiTroUi["19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["19"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Italic);
NiTroUi["19"]["Size"] = UDim2.new(0, 125, 0, 30);
NiTroUi["19"]["BackgroundTransparency"] = 1;
NiTroUi["19"]["Name"] = Title;
NiTroUi["19"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["19"]["Text"] = [[]];

-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.Line
NiTroUi["1b"] = Instance.new("Frame", NiTroUi["4"]);
NiTroUi["1b"]["BorderSizePixel"] = 0;
NiTroUi["1b"]["BackgroundColor3"] = Color3.fromRGB(50, 50, 50);
NiTroUi["1b"]["Size"] = UDim2.new(0, 2, 0, 334);
NiTroUi["1b"]["Position"] = UDim2.new(0.93056, 0, -0.00347, 0);
NiTroUi["1b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["1b"]["Name"] = [[Line]];
	
	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement
	NiTroUi["26"] = Instance.new("Frame", NiTroUi["3"]);
	NiTroUi["26"]["BorderSizePixel"] = 0;
	NiTroUi["26"]["BackgroundColor3"] = Color3.fromRGB(29, 29, 29);
	NiTroUi["26"]["Size"] = UDim2.new(0, 396, 0, 321);
	NiTroUi["26"]["Position"] = UDim2.new(0.26, 0, 0.12533, 0);
	NiTroUi["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["26"]["Name"] = [[ContainerElement]];
	NiTroUi["26"]["BackgroundTransparency"] = 0.5;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element
	NiTroUi["27"] = Instance.new("Frame", NiTroUi["26"]);
	NiTroUi["27"]["BorderSizePixel"] = 0;
	NiTroUi["27"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUi["27"]["Size"] = UDim2.new(0, 396, 0, 321);
	NiTroUi["27"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["27"]["Name"] = [[Element]];
	NiTroUi["27"]["BackgroundTransparency"] = 1;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.Line
	NiTroUi["28"] = Instance.new("Frame", NiTroUi["27"]);
	NiTroUi["28"]["BorderSizePixel"] = 0;
	NiTroUi["28"]["BackgroundColor3"] = Color3.fromRGB(91, 91, 91);
	NiTroUi["28"]["Size"] = UDim2.new(0, 2, 0, 321);
	NiTroUi["28"]["Position"] = UDim2.new(0.49747, 0, 0, 0);
	NiTroUi["28"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["28"]["Name"] = [[Line]];


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.Line.UICorner
	NiTroUi["29"] = Instance.new("UICorner", NiTroUi["28"]);



	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One
	NiTroUi["2a"] = Instance.new("Frame", NiTroUi["27"]);
	NiTroUi["2a"]["BorderSizePixel"] = 0;
	NiTroUi["2a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUi["2a"]["Size"] = UDim2.new(0, 197, 0, 321);
	NiTroUi["2a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["2a"]["Name"] = Title;
	NiTroUi["2a"]["BackgroundTransparency"] = 1;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar
	NiTroUi["2b"] = Instance.new("ScrollingFrame", NiTroUi["2a"]);
	NiTroUi["2b"]["Active"] = true;
	NiTroUi["2b"]["BorderSizePixel"] = 0;
	NiTroUi["2b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUi["2b"]["Name"] = [[ScrollBar]];
	NiTroUi["2b"]["Size"] = UDim2.new(0, 190, 0, 321);
	NiTroUi["2b"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["2b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["2b"]["ScrollBarThickness"] = 0;
	NiTroUi["2b"]["BackgroundTransparency"] = 1;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar
	NiTroUi["2c"] = Instance.new("Frame", NiTroUi["2b"]);
	NiTroUi["2c"]["BorderSizePixel"] = 0;
	NiTroUi["2c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUi["2c"]["Size"] = UDim2.new(0, 190, 0, 321);
	NiTroUi["2c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["2c"]["Name"] = [[BlockScrollbar]];
	NiTroUi["2c"]["BackgroundTransparency"] = 1;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Frame
	NiTroUi["2d"] = Instance.new("Frame", NiTroUi["2c"]);
	NiTroUi["2d"]["BorderSizePixel"] = 0;
	NiTroUi["2d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUi["2d"]["Size"] = UDim2.new(0, 130, 0, 2);
	NiTroUi["2d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["2d"]["BackgroundTransparency"] = 1;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.UIListLayout
	NiTroUi["2e"] = Instance.new("UIListLayout", NiTroUi["2c"]);
	NiTroUi["2e"]["Padding"] = UDim.new(0, 6);
	NiTroUi["2e"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
end

function NiTroUi:Section(Title, Icon)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Section
NiTroUi["2f"] = Instance.new("Frame", NiTroUi["2c"]);
NiTroUi["2f"]["BorderSizePixel"] = 0;
NiTroUi["2f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["2f"]["Size"] = UDim2.new(0, 189, 0, 20);
NiTroUi["2f"]["Position"] = UDim2.new(0, 0, 0.0405, 0);
NiTroUi["2f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["2f"]["Name"] = [[Section]];
NiTroUi["2f"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Section.Title
NiTroUi["30"] = Instance.new("TextLabel", NiTroUi["2f"]);
NiTroUi["30"]["BorderSizePixel"] = 0;
NiTroUi["30"]["TextSize"] = 13;
NiTroUi["30"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUi["30"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["30"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUi["30"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["30"]["BackgroundTransparency"] = 1;
NiTroUi["30"]["Size"] = UDim2.new(0, 115, 0, 20);
NiTroUi["30"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["30"]["Text"] = Title;
NiTroUi["30"]["Name"] = [[Title]];
NiTroUi["30"]["Position"] = UDim2.new(0.19577, 0, 0.25, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Section.Icon
NiTroUi["31"] = Instance.new("ImageLabel", NiTroUi["2f"]);
NiTroUi["31"]["BorderSizePixel"] = 0;
NiTroUi["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["31"]["Image"] = Icon;
NiTroUi["31"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUi["31"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["31"]["BackgroundTransparency"] = 1;
NiTroUi["31"]["Name"] = [[Icon]];
NiTroUi["31"]["Position"] = UDim2.new(0.02646, 0, 0.25, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Section.Line
NiTroUi["32"] = Instance.new("Frame", NiTroUi["2f"]);
NiTroUi["32"]["BorderSizePixel"] = 0;
NiTroUi["32"]["BackgroundColor3"] = Color3.fromRGB(153, 153, 153);
NiTroUi["32"]["Size"] = UDim2.new(0, 189, 0, 2);
NiTroUi["32"]["Position"] = UDim2.new(-0.00529, 0, -0.23131, 0);
NiTroUi["32"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["32"]["Name"] = [[Line]];
end

function NiTroUi:Toggle(Title, Callback)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox
NiTroUi["33"] = Instance.new("Frame", NiTroUi["2c"]);
NiTroUi["33"]["BorderSizePixel"] = 0;
NiTroUi["33"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["33"]["Size"] = UDim2.new(0, 189, 0, 30);
NiTroUi["33"]["Position"] = UDim2.new(0, 0, 0.11215, 0);
NiTroUi["33"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["33"]["Name"] = [[Checkbox]];
NiTroUi["33"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox
NiTroUi["34"] = Instance.new("Frame", NiTroUi["33"]);
NiTroUi["34"]["BorderSizePixel"] = 0;
NiTroUi["34"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
NiTroUi["34"]["Size"] = UDim2.new(0, 195, 0, 30);
NiTroUi["34"]["Position"] = UDim2.new(-0.03355, 0, 0.05838, 0);
NiTroUi["34"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["34"]["Name"] = [[Checkbox]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.UICorner
NiTroUi["35"] = Instance.new("UICorner", NiTroUi["34"]);
NiTroUi["35"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Title
NiTroUi["36"] = Instance.new("TextLabel", NiTroUi["34"]);
NiTroUi["36"]["BorderSizePixel"] = 0;
NiTroUi["36"]["TextSize"] = 12;
NiTroUi["36"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUi["36"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["36"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUi["36"]["TextColor3"] = Color3.fromRGB(241, 241, 241);
NiTroUi["36"]["BackgroundTransparency"] = 1;
NiTroUi["36"]["Size"] = UDim2.new(0, 155, 0, 30);
NiTroUi["36"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["36"]["Text"] = Title;
NiTroUi["36"]["Name"] = [[Title]];
NiTroUi["36"]["Position"] = UDim2.new(0.06252, 0, 0, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check
NiTroUi["37"] = Instance.new("Frame", NiTroUi["34"]);
NiTroUi["37"]["BorderSizePixel"] = 0;
NiTroUi["37"]["BackgroundColor3"] = Color3.fromRGB(46, 46, 46);
NiTroUi["37"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUi["37"]["Position"] = UDim2.new(0.86243, 0, 0.14667, 0);
NiTroUi["37"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["37"]["Name"] = [[Check]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.UICorner
NiTroUi["38"] = Instance.new("UICorner", NiTroUi["37"]);
NiTroUi["38"]["CornerRadius"] = UDim.new(0, 2);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.UIStroke
NiTroUi["39"] = Instance.new("UIStroke", NiTroUi["37"]);
NiTroUi["39"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
NiTroUi["39"]["LineJoinMode"] = Enum.LineJoinMode.Bevel;
NiTroUi["39"]["Color"] = Color3.fromRGB(71, 71, 71);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.Icon
NiTroUi["3a"] = Instance.new("ImageLabel", NiTroUi["37"]);
NiTroUi["3a"]["BorderSizePixel"] = 0;
NiTroUi["3a"]["BackgroundColor3"] = Color3.fromRGB(0, 115, 176);
NiTroUi["3a"]["Image"] = [[rbxassetid://10709790644]];
NiTroUi["3a"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUi["3a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["3a"]["Name"] = [[Icon]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.Icon.UIStroke
NiTroUi["3b"] = Instance.new("UIStroke", NiTroUi["3a"]);
NiTroUi["3b"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
NiTroUi["3b"]["LineJoinMode"] = Enum.LineJoinMode.Bevel;
NiTroUi["3b"]["Color"] = Color3.fromRGB(31, 31, 31);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.togglecheck
NiTroUi["3c"] = Instance.new("ImageButton", NiTroUi["37"]);
NiTroUi["3c"]["BorderSizePixel"] = 0;
NiTroUi["3c"]["ImageTransparency"] = 1;
NiTroUi["3c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["3c"]["Image"] = [[rbxasset://textures/ui/GuiImagePlaceholder.png]];
NiTroUi["3c"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUi["3c"]["BackgroundTransparency"] = 1;
NiTroUi["3c"]["Name"] = [[togglecheck]];
NiTroUi["3c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUi["3c"].MouseButton1Click:Connect(function()
		local Icon = script.Parent.Parent.Icon
			if Icon.Visible == false then
				Icon.Visible = true
				Icon:TweenSize(
					UDim2.new(0, 20,0, 20),
					Enum.EasingDirection.Out, 
					Enum.EasingStyle.Linear,
					0.1
				)
				pcall(Callback)
			elseif Icon.Visible == true then
				Icon:TweenSize(
					UDim2.new(0),
					Enum.EasingDirection.Out, 
					Enum.EasingStyle.Linear,
					0.3
				)
				Icon.Visible = false
			end
		end)

-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.togglecheck.LocalScript
NiTroUi["3d"] = Instance.new("LocalScript", NiTroUi["3c"]);
end

function NiTroUi:Button(Title, Callback)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button
NiTroUi["3e"] = Instance.new("Frame", NiTroUi["2c"]);
NiTroUi["3e"]["BorderSizePixel"] = 0;
NiTroUi["3e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["3e"]["Size"] = UDim2.new(0, 189, 0, 30);
NiTroUi["3e"]["Position"] = UDim2.new(0, 0, 0.49844, 0);
NiTroUi["3e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["3e"]["Name"] = [[Button]];
NiTroUi["3e"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button
NiTroUi["3f"] = Instance.new("Frame", NiTroUi["3e"]);
NiTroUi["3f"]["BorderSizePixel"] = 0;
NiTroUi["3f"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
NiTroUi["3f"]["Size"] = UDim2.new(0, 189, 0, 30);
NiTroUi["3f"]["Position"] = UDim2.new(0, 0, -0.00592, 0);
NiTroUi["3f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["3f"]["Name"] = [[Button]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button.UICorner
NiTroUi["40"] = Instance.new("UICorner", NiTroUi["3f"]);
NiTroUi["40"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button.Title
NiTroUi["41"] = Instance.new("TextLabel", NiTroUi["3f"]);
NiTroUi["41"]["BorderSizePixel"] = 0;
NiTroUi["41"]["TextSize"] = 12;
NiTroUi["41"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUi["41"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["41"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUi["41"]["TextColor3"] = Color3.fromRGB(241, 241, 241);
NiTroUi["41"]["BackgroundTransparency"] = 1;
NiTroUi["41"]["Size"] = UDim2.new(0, 157, 0, 30);
NiTroUi["41"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["41"]["Text"] = Title;
NiTroUi["41"]["Name"] = [[Title]];
NiTroUi["41"]["Position"] = UDim2.new(0.03175, 0, 0, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button.Icon
NiTroUi["42"] = Instance.new("ImageLabel", NiTroUi["3f"]);
NiTroUi["42"]["BorderSizePixel"] = 0;
NiTroUi["42"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["42"]["Image"] = [[rbxassetid://10734898355]];
NiTroUi["42"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUi["42"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["42"]["BackgroundTransparency"] = 1;
NiTroUi["42"]["Name"] = [[Icon]];
NiTroUi["42"]["Position"] = UDim2.new(0.86243, 0, 0.16667, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button.Click
NiTroUi["43"] = Instance.new("ImageButton", NiTroUi["3f"]);
NiTroUi["43"]["BorderSizePixel"] = 0;
NiTroUi["43"]["ImageTransparency"] = 1;
NiTroUi["43"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["43"]["Image"] = [[rbxasset://textures/ui/GuiImagePlaceholder.png]];
NiTroUi["43"]["Size"] = UDim2.new(0, 90, 0, 30);
NiTroUi["43"]["BackgroundTransparency"] = 1;
NiTroUi["43"]["Name"] = [[Click]];
NiTroUi["43"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["43"]["Position"] = UDim2.new(0.52381, 0, 0, 0);
	NiTroUi["43"].MouseButton1Click:Connect(function()
		pcall(Callback)
	end)

-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button.Click.LocalScript
	NiTroUi["44"] = Instance.new("LocalScript", NiTroUi["43"]);
end

function NiTroUi:Paragraph(Title, Desc)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Paragraph
NiTroUi["45"] = Instance.new("Frame", NiTroUi["2c"]);
NiTroUi["45"]["BorderSizePixel"] = 0;
NiTroUi["45"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["45"]["Size"] = UDim2.new(0, 189, 0, 42);
NiTroUi["45"]["Position"] = UDim2.new(0, 0, 0.49844, 0);
NiTroUi["45"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["45"]["Name"] = [[Paragraph]];
NiTroUi["45"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Paragraph.Paragraph
NiTroUi["46"] = Instance.new("Frame", NiTroUi["45"]);
NiTroUi["46"]["BorderSizePixel"] = 0;
NiTroUi["46"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
NiTroUi["46"]["Size"] = UDim2.new(0, 189, 0, 42);
NiTroUi["46"]["Position"] = UDim2.new(0, 0, -0.00592, 0);
NiTroUi["46"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["46"]["Name"] = [[Paragraph]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Paragraph.Paragraph.UICorner
NiTroUi["47"] = Instance.new("UICorner", NiTroUi["46"]);
NiTroUi["47"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Paragraph.Paragraph.Title
NiTroUi["48"] = Instance.new("TextLabel", NiTroUi["46"]);
NiTroUi["48"]["BorderSizePixel"] = 0;
NiTroUi["48"]["TextSize"] = 12;
NiTroUi["48"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUi["48"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["48"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUi["48"]["TextColor3"] = Color3.fromRGB(241, 241, 241);
NiTroUi["48"]["BackgroundTransparency"] = 1;
NiTroUi["48"]["Size"] = UDim2.new(0, 183, 0, 19);
NiTroUi["48"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["48"]["Text"] = Title;
NiTroUi["48"]["Name"] = [[Title]];
NiTroUi["48"]["Position"] = UDim2.new(0.03175, 0, 0, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Paragraph.Paragraph.Description
NiTroUi["49"] = Instance.new("TextLabel", NiTroUi["46"]);
NiTroUi["49"]["TextWrapped"] = true;
NiTroUi["49"]["BorderSizePixel"] = 0;
NiTroUi["49"]["TextSize"] = 11;
NiTroUi["49"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUi["49"]["TextYAlignment"] = Enum.TextYAlignment.Top;
NiTroUi["49"]["BackgroundColor3"] = Color3.fromRGB(59, 59, 59);
NiTroUi["49"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUi["49"]["TextColor3"] = Color3.fromRGB(92, 92, 92);
NiTroUi["49"]["BackgroundTransparency"] = 1;
NiTroUi["49"]["Size"] = UDim2.new(0, 182, 0, 28);
NiTroUi["49"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["49"]["Text"] = Desc;
NiTroUi["49"]["Name"] = [[Description]];
NiTroUi["49"]["Position"] = UDim2.new(0.03175, 0, 0.30952, 0);
end

function NiTroUi:Slider(Title,MaxValue,Callback)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider
NiTroUi["4a"] = Instance.new("Frame", NiTroUi["2c"]);
NiTroUi["4a"]["BorderSizePixel"] = 0;
NiTroUi["4a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["4a"]["Size"] = UDim2.new(0, 189, 0, 42);
NiTroUi["4a"]["Position"] = UDim2.new(0, 0, 0.49844, 0);
NiTroUi["4a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["4a"]["Name"] = [[Slider]];
NiTroUi["4a"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider
NiTroUi["4b"] = Instance.new("Frame", NiTroUi["4a"]);
NiTroUi["4b"]["BorderSizePixel"] = 0;
NiTroUi["4b"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
NiTroUi["4b"]["Size"] = UDim2.new(0, 189, 0, 41);
NiTroUi["4b"]["Position"] = UDim2.new(0, 0, -0.00592, 0);
NiTroUi["4b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["4b"]["Name"] = [[Slider]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.UICorner
NiTroUi["4c"] = Instance.new("UICorner", NiTroUi["4b"]);
NiTroUi["4c"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.Title
NiTroUi["4d"] = Instance.new("TextLabel", NiTroUi["4b"]);
NiTroUi["4d"]["BorderSizePixel"] = 0;
NiTroUi["4d"]["TextSize"] = 12;
NiTroUi["4d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUi["4d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["4d"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUi["4d"]["TextColor3"] = Color3.fromRGB(241, 241, 241);
NiTroUi["4d"]["BackgroundTransparency"] = 1;
NiTroUi["4d"]["Size"] = UDim2.new(0, 182, 0, 19);
NiTroUi["4d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["4d"]["Text"] = Title;
NiTroUi["4d"]["Name"] = [[Title]];
NiTroUi["4d"]["Position"] = UDim2.new(0.03175, 0, 0, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground
NiTroUi["4e"] = Instance.new("Frame", NiTroUi["4b"]);
NiTroUi["4e"]["BorderSizePixel"] = 0;
NiTroUi["4e"]["BackgroundColor3"] = Color3.fromRGB(85, 85, 85);
NiTroUi["4e"]["Size"] = UDim2.new(0, 175, 0, 13);
NiTroUi["4e"]["Position"] = UDim2.new(0.02116, 0, 0.45726, 0);
NiTroUi["4e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["4e"]["Name"] = [[SliderBackground]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.UICorner
NiTroUi["4f"] = Instance.new("UICorner", NiTroUi["4e"]);
NiTroUi["4f"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.SliderColor
NiTroUi["50"] = Instance.new("Frame", NiTroUi["4e"]);
NiTroUi["50"]["BorderSizePixel"] = 0;
NiTroUi["50"]["BackgroundColor3"] = Color3.fromRGB(0, 115, 176);
NiTroUi["50"]["Size"] = UDim2.new(0, 97, 0, 13);
NiTroUi["50"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["50"]["Name"] = [[SliderColor]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.SliderColor.UICorner
NiTroUi["51"] = Instance.new("UICorner", NiTroUi["50"]);
NiTroUi["51"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.LocalScript
NiTroUi["52"] = Instance.new("LocalScript", NiTroUi["4e"]);



-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.Trigger
NiTroUi["53"] = Instance.new("TextButton", NiTroUi["4e"]);
NiTroUi["53"]["BorderSizePixel"] = 0;
NiTroUi["53"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["53"]["TextSize"] = 14;
NiTroUi["53"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["53"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
NiTroUi["53"]["Size"] = UDim2.new(0, 175, 0, 13);
NiTroUi["53"]["BackgroundTransparency"] = 1;
NiTroUi["53"]["Name"] = [[Trigger]];
NiTroUi["53"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["53"]["Text"] = [[]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.Count
NiTroUi["54"] = Instance.new("TextLabel", NiTroUi["4e"]);
NiTroUi["54"]["BorderSizePixel"] = 0;
NiTroUi["54"]["TextSize"] = 14;
NiTroUi["54"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["54"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUi["54"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["54"]["BackgroundTransparency"] = 1;
NiTroUi["54"]["Size"] = UDim2.new(0, 40, 0, 13);
NiTroUi["54"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["54"]["Text"] = [[50]];
NiTroUi["54"]["Name"] = [[Count]];
NiTroUi["54"]["Position"] = UDim2.new(0.41655, 0, 0, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.Output
NiTroUi["55"] = Instance.new("NumberValue", NiTroUi["4e"]);
NiTroUi["55"]["Name"] = [[Output]];
	NiTroUi["55"]["Value"] = 0.5;
	
	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.LocalScript
	local function C_52()
		local script = NiTroUi["52"];
		local mouse = game.Players.LocalPlayer:GetMouse()
		local slider = script.Parent
		local fillslider = script.Parent.SliderColor
		local Trigger = script.Parent.Trigger
		local count = script.Parent.Output
		local txt = script.Parent.Count


		txt.Text = tostring(math.round(count.Value*MaxValue))

		local TweenService = game:GetService("TweenService")
		local TweenStyle = TweenInfo.new(0.25,Enum.EasingStyle.Exponential)

		function UpdateSlider()
			local output = math.clamp((mouse.X-slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1)
			txt.Text = tostring(math.round(output*MaxValue))
			count.Value = output
			fillslider.Size = UDim2.fromScale(count.Value,1)
			pcall(Callback)
			if count.Value ~= output then
				TweenService:Create(fillslider,TweenStyle{Size = UDim2.fromScale(output,1)}):Play()
			end

			count.Value = output
		end

		fillslider:GetPropertyChangedSignal("Size"):Connect(function()
			txt.Text = tostring(math.round(fillslider.Size.X.Scale*MaxValue))	
		end)

		local slideractive = false

		function ActivateSlider()
			slideractive = true
			while slideractive do
				UpdateSlider()
				task.wait()
			end
		end

		Trigger.MouseButton1Down:Connect(ActivateSlider)

		game:GetService("UserInputService").InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				slideractive = false
			end
		end)
	end;
	task.spawn(C_52);
end

-- StarterGui.UiLibrary.NiTroHUBUI.UICorner
NiTroUi["82"] = Instance.new("UICorner", NiTroUi["2"]);



-- StarterGui.UiLibrary.NiTroHUBUI.UIAspectRatioConstraint
NiTroUi["83"] = Instance.new("UIAspectRatioConstraint", NiTroUi["2"]);
NiTroUi["83"]["AspectRatio"] = 1.46667;

function NiTroUi:OpenUI(Title,Icon,BackgroundColor,BorderColor)
-- StarterGui.UiLibrary.OpenButton
NiTroUi["84"] = Instance.new("Frame", NiTroUi["1"]);
NiTroUi["84"]["Visible"] = false;
NiTroUi["84"]["BorderSizePixel"] = 0;
NiTroUi["84"]["BackgroundColor3"] = Color3.fromRGB(BackgroundColor);
NiTroUi["84"]["BorderMode"] = Enum.BorderMode.Middle;
NiTroUi["84"]["Position"] = UDim2.new(0.14899, 0, 0.59917, 0);
NiTroUi["84"]["BorderColor3"] = Color3.fromRGB(BorderColor);
NiTroUi["84"]["Name"] = [[OpenButton]];


-- StarterGui.UiLibrary.OpenButton.UICorner
NiTroUi["85"] = Instance.new("UICorner", NiTroUi["84"]);



-- StarterGui.UiLibrary.OpenButton.Name
NiTroUi["86"] = Instance.new("TextLabel", NiTroUi["84"]);
NiTroUi["86"]["BorderSizePixel"] = 0;
NiTroUi["86"]["TextSize"] = 14;
NiTroUi["86"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUi["86"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["86"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUi["86"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["86"]["BackgroundTransparency"] = 1;
NiTroUi["86"]["Size"] = UDim2.new(0, 103, 0, 40);
NiTroUi["86"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["86"]["Text"] = Title;
NiTroUi["86"]["Name"] = [[Name]];
NiTroUi["86"]["Position"] = UDim2.new(0.30769, 0, 0, 0);


-- StarterGui.UiLibrary.OpenButton.UIStroke
NiTroUi["87"] = Instance.new("UIStroke", NiTroUi["84"]);
NiTroUi["87"]["Color"] = Color3.fromRGB(255, 255, 255);


-- StarterGui.UiLibrary.OpenButton.UIAspectRatioConstraint
NiTroUi["88"] = Instance.new("UIAspectRatioConstraint", NiTroUi["84"]);
NiTroUi["88"]["AspectRatio"] = 3.25;


-- StarterGui.UiLibrary.OpenButton.LocalScript
NiTroUi["89"] = Instance.new("LocalScript", NiTroUi["84"]);



-- StarterGui.UiLibrary.OpenButton.Icon
NiTroUi["8a"] = Instance.new("ImageLabel", NiTroUi["84"]);
NiTroUi["8a"]["BorderSizePixel"] = 0;
NiTroUi["8a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["8a"]["Image"] = Icon;
NiTroUi["8a"]["Size"] = UDim2.new(0, 40, 0, 40);
NiTroUi["8a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["8a"]["BackgroundTransparency"] = 1;
NiTroUi["8a"]["Name"] = [[Icon]];


-- StarterGui.UiLibrary.OpenButton.IconOpen
NiTroUi["8b"] = Instance.new("ImageButton", NiTroUi["84"]);
NiTroUi["8b"]["Active"] = false;
NiTroUi["8b"]["BorderSizePixel"] = 0;
NiTroUi["8b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUi["8b"]["Selectable"] = false;
NiTroUi["8b"]["Image"] = [[rbxassetid://10734895698]];
NiTroUi["8b"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUi["8b"]["BackgroundTransparency"] = 1;
NiTroUi["8b"]["Name"] = [[IconOpen]];
NiTroUi["8b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUi["8b"]["Position"] = UDim2.new(0.78462, 0, 0.25, 0);


-- StarterGui.UiLibrary.OpenButton.IconOpen.LocalScript
NiTroUi["8c"] = Instance.new("LocalScript", NiTroUi["8b"]);
end


-- StarterGui.UiLibrary.LocalScript
NiTroUi["8d"] = Instance.new("LocalScript", NiTroUi["1"]);



-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.Minimize.LocalScript
local function C_21()
	local script = NiTroUi["21"];
	local Open = script.Parent.Parent.Parent.Parent.Parent.OpenButton
	local Minim = script.Parent
	local UI = script.Parent.Parent.Parent.Parent.Parent.NiTroHUBUI
	local Holder = script.Parent.Parent.Parent.Parent.Parent.NiTroHUBUI.Holder

	Minim.MouseButton1Click:Connect(function()
		Open:TweenSize(
			UDim2.new(0, 130,0, 40),
			Enum.EasingDirection.In, 
			Enum.EasingStyle.Linear,
			0.3
		)
		UI:TweenPosition(
			UDim2.new(0, 1000,0, 1000),
			Enum.EasingDirection.Out, 
			Enum.EasingStyle.Linear,
			0.2
		)

		wait(0)
		Open.Visible = true
		UI.Visible = false
	end)
end;
task.spawn(C_21);
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.LocalScript
local function C_24()
	local script = NiTroUi["24"];
	local UserInputService = game:GetService("UserInputService")

	local gui = script.Parent.Parent.Parent.Parent.NiTroHUBUI
	local topbar = script.Parent.Parent.Topbar

	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end;
task.spawn(C_24);
-- StarterGui.UiLibrary.OpenButton.LocalScript
local function C_89()
	local script = NiTroUi["89"];
	local UserInputService = game:GetService("UserInputService")

	local gui = script.Parent.Parent.OpenButton

	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end;
task.spawn(C_89);
-- StarterGui.UiLibrary.OpenButton.IconOpen.LocalScript
local function C_8c()
	local script = NiTroUi["8c"];
	local Open = script.Parent
	local Open2 = script.Parent.Parent.Parent.OpenButton
	local UI = script.Parent.Parent.Parent.NiTroHUBUI
	local Holder = script.Parent.Parent.Parent.NiTroHUBUI.Holder

	Open.MouseButton1Click:Connect(function()
		Open2:TweenSize(
			UDim2.new(0,0,0),
			Enum.EasingDirection.Out, 
			Enum.EasingStyle.Sine,
			0.3
		)
		UI:TweenPosition(
			UDim2.new(0.5, 0,0.5, 0),
			Enum.EasingDirection.Out, 
			Enum.EasingStyle.Linear,
			0.2
		)
		wait(0)
		Open2.Visible = false
		UI.Visible = true
	end)
end;
task.spawn(C_8c);
-- StarterGui.UiLibrary.LocalScript
local function C_8d()
	local script = NiTroUi["8d"];
	local ItemContainer = script.Parent.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.Button
	local Element = script.Parent.NiTroHUBUI.Holder.ContainerElement.Element
	for i,v in pairs(ItemContainer:GetChildren()) do
		if v.ClassName == "TextButton" then
			v.MouseButton1Click:Connect(function()
				for i,v2 in pairs(Element:GetChildren()) do
					if v2.Name ~= v.Name then
						v2.Visible = false
					else
						v2.Visible = true
					end
				end

			end)
		end
	end
end;
task.spawn(C_8d);

return NiTroUi["1"], require;