local NiTroUI = {};

function NiTroUI:Window(Title, Description, Icon)
-- StarterGui.UiLibrary
NiTroUI["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
NiTroUI["1"]["IgnoreGuiInset"] = true;
NiTroUI["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
NiTroUI["1"]["Name"] = [[UiLibrary]];
NiTroUI["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
NiTroUI["1"]["ResetOnSpawn"] = false;


-- StarterGui.UiLibrary.NiTroHUBUI
NiTroUI["2"] = Instance.new("Frame", NiTroUI["1"]);
NiTroUI["2"]["BorderSizePixel"] = 0;
NiTroUI["2"]["BackgroundColor3"] = Color3.fromRGB(21, 21, 21);
NiTroUI["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
NiTroUI["2"]["Size"] = UDim2.new(0, 550, 0, 375);
NiTroUI["2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
NiTroUI["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["2"]["Name"] = [[NiTroHUBUI]];
NiTroUI["2"]["BackgroundTransparency"] = 0.05;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder
NiTroUI["3"] = Instance.new("Frame", NiTroUI["2"]);
NiTroUI["3"]["BorderSizePixel"] = 0;
NiTroUI["3"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
NiTroUI["3"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
NiTroUI["3"]["Size"] = UDim2.new(0, 550, 0, 375);
NiTroUI["3"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
NiTroUI["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["3"]["Name"] = [[Holder]];
NiTroUI["3"]["BackgroundTransparency"] = 0.5;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab
NiTroUI["4"] = Instance.new("Frame", NiTroUI["3"]);
NiTroUI["4"]["BorderSizePixel"] = 0;
NiTroUI["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["4"]["Size"] = UDim2.new(0, 144, 0, 288);
NiTroUI["4"]["Position"] = UDim2.new(0, 0, 0, 41);
NiTroUI["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["4"]["Name"] = [[ContainerTab]];
NiTroUI["4"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList
NiTroUI["5"] = Instance.new("Frame", NiTroUI["4"]);
NiTroUI["5"]["BorderSizePixel"] = 0;
NiTroUI["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["5"]["Size"] = UDim2.new(0, 144, 0, 335);
NiTroUI["5"]["Position"] = UDim2.new(0.5, -72, 0.5, -167);
NiTroUI["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["5"]["Name"] = [[TabList]];
NiTroUI["5"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame
NiTroUI["6"] = Instance.new("ScrollingFrame", NiTroUI["5"]);
NiTroUI["6"]["Active"] = true;
NiTroUI["6"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
NiTroUI["6"]["BorderSizePixel"] = 0;
NiTroUI["6"]["CanvasSize"] = UDim2.new(0, 0, 8, 0);
NiTroUI["6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["6"]["Size"] = UDim2.new(0, 135, 0, 334);
NiTroUI["6"]["ScrollBarImageColor3"] = Color3.fromRGB(255, 254, 254);
NiTroUI["6"]["Position"] = UDim2.new(0.5, -72, 0.49552, -144);
NiTroUI["6"]["BorderColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["6"]["ScrollBarThickness"] = 0;
NiTroUI["6"]["BackgroundTransparency"] = 1;
	
	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar
	NiTroUI["1d"] = Instance.new("Frame", NiTroUI["3"]);
	NiTroUI["1d"]["BorderSizePixel"] = 0;
	NiTroUI["1d"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
	NiTroUI["1d"]["Size"] = UDim2.new(0, 549, 0, 40);
	NiTroUI["1d"]["Position"] = UDim2.new(0.5, -274, 0, 0);
	NiTroUI["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["1d"]["Name"] = [[Topbar]];
	NiTroUI["1d"]["BackgroundTransparency"] = 0.05;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.TitleHub
	NiTroUI["1e"] = Instance.new("TextLabel", NiTroUI["1d"]);
	NiTroUI["1e"]["BorderSizePixel"] = 0;
	NiTroUI["1e"]["TextSize"] = 15;
	NiTroUI["1e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
	NiTroUI["1e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUI["1e"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
	NiTroUI["1e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUI["1e"]["BackgroundTransparency"] = 1;
	NiTroUI["1e"]["Size"] = UDim2.new(0, 60, 0, 30);
	NiTroUI["1e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["1e"]["Text"] = Title;
	NiTroUI["1e"]["Name"] = [[TitleHub]];
	NiTroUI["1e"]["Position"] = UDim2.new(0, 50, 0, -2);


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.Desc
	NiTroUI["1f"] = Instance.new("TextLabel", NiTroUI["1d"]);
	NiTroUI["1f"]["BorderSizePixel"] = 0;
	NiTroUI["1f"]["TextSize"] = 14;
	NiTroUI["1f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
	NiTroUI["1f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUI["1f"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
	NiTroUI["1f"]["TextColor3"] = Color3.fromRGB(123, 123, 123);
	NiTroUI["1f"]["BackgroundTransparency"] = 1;
	NiTroUI["1f"]["Size"] = UDim2.new(0, 60, 0, 14);
	NiTroUI["1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["1f"]["Text"] = Description;
	NiTroUI["1f"]["Name"] = [[Desc]];
	NiTroUI["1f"]["Position"] = UDim2.new(0, 50, 0, 20);


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.Minimize
	NiTroUI["20"] = Instance.new("ImageButton", NiTroUI["1d"]);
	NiTroUI["20"]["BorderSizePixel"] = 0;
	NiTroUI["20"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUI["20"]["Selectable"] = false;
	NiTroUI["20"]["Image"] = [[rbxassetid://10734896206]];
	NiTroUI["20"]["Size"] = UDim2.new(0, 20, 0, 20);
	NiTroUI["20"]["BackgroundTransparency"] = 1;
	NiTroUI["20"]["Name"] = [[Minimize]];
	NiTroUI["20"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["20"]["Position"] = UDim2.new(1, -30, 0, 10);


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.Minimize.LocalScript
	NiTroUI["21"] = Instance.new("LocalScript", NiTroUI["20"]);



	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.UICorner
	NiTroUI["22"] = Instance.new("UICorner", NiTroUI["1d"]);



	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.Icon
	NiTroUI["23"] = Instance.new("ImageLabel", NiTroUI["1d"]);
	NiTroUI["23"]["BorderSizePixel"] = 0;
	NiTroUI["23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUI["23"]["Image"] = Icon;
	NiTroUI["23"]["Size"] = UDim2.new(0, 35, 0, 35);
	NiTroUI["23"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["23"]["BackgroundTransparency"] = 1;
	NiTroUI["23"]["Name"] = [[Icon]];
	NiTroUI["23"]["Position"] = UDim2.new(0, 8, 0, 4);


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.LocalScript
	NiTroUI["24"] = Instance.new("LocalScript", NiTroUI["1d"]);



	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.UIAspectRatioConstraint
	NiTroUI["25"] = Instance.new("UIAspectRatioConstraint", NiTroUI["3"]);
	NiTroUI["25"]["AspectRatio"] = 1.46667;
	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.UICorner
	NiTroUI["1c"] = Instance.new("UICorner", NiTroUI["3"]);
end

function NiTroUI:AddTab(Title, Desc, Icon)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List
NiTroUI["7"] = Instance.new("Frame", NiTroUI["6"]);
NiTroUI["7"]["BorderSizePixel"] = 0;
NiTroUI["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["7"]["Size"] = UDim2.new(0, 132, 0, 333);
NiTroUI["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["7"]["Name"] = [[List]];
NiTroUI["7"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.dontchange
NiTroUI["8"] = Instance.new("Frame", NiTroUI["7"]);
NiTroUI["8"]["BorderSizePixel"] = 0;
NiTroUI["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["8"]["Size"] = UDim2.new(0, 125, 0, 20);
NiTroUI["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["8"]["Name"] = [[dontchange]];
NiTroUI["8"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.UIListLayout
NiTroUI["9"] = Instance.new("UIListLayout", NiTroUI["7"]);
NiTroUI["9"]["Padding"] = UDim.new(0, 5);
NiTroUI["9"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active
NiTroUI["a"] = Instance.new("Frame", NiTroUI["7"]);
NiTroUI["a"]["BorderSizePixel"] = 0;
NiTroUI["a"]["BackgroundColor3"] = Color3.fromRGB(59, 59, 59);
NiTroUI["a"]["Size"] = UDim2.new(0, 125, 0, 30);
NiTroUI["a"]["Position"] = UDim2.new(0, 0, 0.07508, 0);
NiTroUI["a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["a"]["Name"] = [[Active]];
NiTroUI["a"]["BackgroundTransparency"] = 0.5;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active.DescTab
NiTroUI["b"] = Instance.new("TextLabel", NiTroUI["a"]);
NiTroUI["b"]["BorderSizePixel"] = 0;
NiTroUI["b"]["TextSize"] = 10;
NiTroUI["b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUI["b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["b"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUI["b"]["TextColor3"] = Color3.fromRGB(123, 123, 123);
NiTroUI["b"]["BackgroundTransparency"] = 1;
NiTroUI["b"]["Size"] = UDim2.new(0, 55, 0, 10);
NiTroUI["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["b"]["Text"] = Desc;
NiTroUI["b"]["Name"] = [[DescTab]];
NiTroUI["b"]["Position"] = UDim2.new(0.28, 0, 0.5, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active.IconTab
NiTroUI["c"] = Instance.new("ImageLabel", NiTroUI["a"]);
NiTroUI["c"]["BorderSizePixel"] = 0;
NiTroUI["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["c"]["Image"] = Icon;
NiTroUI["c"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUI["c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["c"]["BackgroundTransparency"] = 1;
NiTroUI["c"]["Name"] = [[IconTab]];
NiTroUI["c"]["Position"] = UDim2.new(0.056, 0, 0.16667, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active.UIStroke
NiTroUI["d"] = Instance.new("UIStroke", NiTroUI["a"]);
NiTroUI["d"]["Color"] = Color3.fromRGB(53, 53, 53);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active.UICorner
NiTroUI["e"] = Instance.new("UICorner", NiTroUI["a"]);
NiTroUI["e"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.List.Active.TitleTab
NiTroUI["f"] = Instance.new("TextLabel", NiTroUI["a"]);
NiTroUI["f"]["BorderSizePixel"] = 0;
NiTroUI["f"]["TextSize"] = 13;
NiTroUI["f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUI["f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["f"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUI["f"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["f"]["BackgroundTransparency"] = 1;
NiTroUI["f"]["Size"] = UDim2.new(0, 55, 0, 20);
NiTroUI["f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["f"]["Text"] = Title;
NiTroUI["f"]["Name"] = [[TitleTab]];
NiTroUI["f"]["Position"] = UDim2.new(0.28, 0, 0, 0);

-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.Button
NiTroUI["16"] = Instance.new("Frame", NiTroUI["6"]);
NiTroUI["16"]["BorderSizePixel"] = 0;
NiTroUI["16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["16"]["Size"] = UDim2.new(0, 132, 0, 333);
NiTroUI["16"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["16"]["Name"] = [[Button]];
NiTroUI["16"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.Button.dontchange
NiTroUI["17"] = Instance.new("Frame", NiTroUI["16"]);
NiTroUI["17"]["BorderSizePixel"] = 0;
NiTroUI["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["17"]["Size"] = UDim2.new(0, 125, 0, 20);
NiTroUI["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["17"]["Name"] = [[dontchange]];
NiTroUI["17"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.Button.UIListLayout
NiTroUI["18"] = Instance.new("UIListLayout", NiTroUI["16"]);
NiTroUI["18"]["Padding"] = UDim.new(0, 5);
NiTroUI["18"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.TabList.ScrollingFrame.Button.One
NiTroUI["19"] = Instance.new("TextButton", NiTroUI["16"]);
NiTroUI["19"]["BorderSizePixel"] = 0;
NiTroUI["19"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["19"]["TextSize"] = 13;
NiTroUI["19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["19"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Italic);
NiTroUI["19"]["Size"] = UDim2.new(0, 125, 0, 30);
NiTroUI["19"]["BackgroundTransparency"] = 1;
NiTroUI["19"]["Name"] = Title;
NiTroUI["19"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["19"]["Text"] = [[]];

-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerTab.Line
NiTroUI["1b"] = Instance.new("Frame", NiTroUI["4"]);
NiTroUI["1b"]["BorderSizePixel"] = 0;
NiTroUI["1b"]["BackgroundColor3"] = Color3.fromRGB(50, 50, 50);
NiTroUI["1b"]["Size"] = UDim2.new(0, 2, 0, 334);
NiTroUI["1b"]["Position"] = UDim2.new(0.93056, 0, -0.00347, 0);
NiTroUI["1b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["1b"]["Name"] = [[Line]];
	
	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement
	NiTroUI["26"] = Instance.new("Frame", NiTroUI["3"]);
	NiTroUI["26"]["BorderSizePixel"] = 0;
	NiTroUI["26"]["BackgroundColor3"] = Color3.fromRGB(29, 29, 29);
	NiTroUI["26"]["Size"] = UDim2.new(0, 396, 0, 321);
	NiTroUI["26"]["Position"] = UDim2.new(0.26, 0, 0.12533, 0);
	NiTroUI["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["26"]["Name"] = [[ContainerElement]];
	NiTroUI["26"]["BackgroundTransparency"] = 0.5;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element
	NiTroUI["27"] = Instance.new("Frame", NiTroUI["26"]);
	NiTroUI["27"]["BorderSizePixel"] = 0;
	NiTroUI["27"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUI["27"]["Size"] = UDim2.new(0, 396, 0, 321);
	NiTroUI["27"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["27"]["Name"] = [[Element]];
	NiTroUI["27"]["BackgroundTransparency"] = 1;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.Line
	NiTroUI["28"] = Instance.new("Frame", NiTroUI["27"]);
	NiTroUI["28"]["BorderSizePixel"] = 0;
	NiTroUI["28"]["BackgroundColor3"] = Color3.fromRGB(91, 91, 91);
	NiTroUI["28"]["Size"] = UDim2.new(0, 2, 0, 321);
	NiTroUI["28"]["Position"] = UDim2.new(0.49747, 0, 0, 0);
	NiTroUI["28"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["28"]["Name"] = [[Line]];


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.Line.UICorner
	NiTroUI["29"] = Instance.new("UICorner", NiTroUI["28"]);



	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One
	NiTroUI["2a"] = Instance.new("Frame", NiTroUI["27"]);
	NiTroUI["2a"]["BorderSizePixel"] = 0;
	NiTroUI["2a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUI["2a"]["Size"] = UDim2.new(0, 197, 0, 321);
	NiTroUI["2a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["2a"]["Name"] = Title;
	NiTroUI["2a"]["BackgroundTransparency"] = 1;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar
	NiTroUI["2b"] = Instance.new("ScrollingFrame", NiTroUI["2a"]);
	NiTroUI["2b"]["Active"] = true;
	NiTroUI["2b"]["BorderSizePixel"] = 0;
	NiTroUI["2b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUI["2b"]["Name"] = [[ScrollBar]];
	NiTroUI["2b"]["Size"] = UDim2.new(0, 190, 0, 321);
	NiTroUI["2b"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["2b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["2b"]["ScrollBarThickness"] = 0;
	NiTroUI["2b"]["BackgroundTransparency"] = 1;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar
	NiTroUI["2c"] = Instance.new("Frame", NiTroUI["2b"]);
	NiTroUI["2c"]["BorderSizePixel"] = 0;
	NiTroUI["2c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUI["2c"]["Size"] = UDim2.new(0, 190, 0, 321);
	NiTroUI["2c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["2c"]["Name"] = [[BlockScrollbar]];
	NiTroUI["2c"]["BackgroundTransparency"] = 1;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Frame
	NiTroUI["2d"] = Instance.new("Frame", NiTroUI["2c"]);
	NiTroUI["2d"]["BorderSizePixel"] = 0;
	NiTroUI["2d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	NiTroUI["2d"]["Size"] = UDim2.new(0, 130, 0, 2);
	NiTroUI["2d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["2d"]["BackgroundTransparency"] = 1;


	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.UIListLayout
	NiTroUI["2e"] = Instance.new("UIListLayout", NiTroUI["2c"]);
	NiTroUI["2e"]["Padding"] = UDim.new(0, 6);
	NiTroUI["2e"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
end

function NiTroUI:Section(Title, Icon)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Section
NiTroUI["2f"] = Instance.new("Frame", NiTroUI["2c"]);
NiTroUI["2f"]["BorderSizePixel"] = 0;
NiTroUI["2f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["2f"]["Size"] = UDim2.new(0, 189, 0, 20);
NiTroUI["2f"]["Position"] = UDim2.new(0, 0, 0.0405, 0);
NiTroUI["2f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["2f"]["Name"] = [[Section]];
NiTroUI["2f"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Section.Title
NiTroUI["30"] = Instance.new("TextLabel", NiTroUI["2f"]);
NiTroUI["30"]["BorderSizePixel"] = 0;
NiTroUI["30"]["TextSize"] = 13;
NiTroUI["30"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUI["30"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["30"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUI["30"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["30"]["BackgroundTransparency"] = 1;
NiTroUI["30"]["Size"] = UDim2.new(0, 115, 0, 20);
NiTroUI["30"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["30"]["Text"] = Title;
NiTroUI["30"]["Name"] = [[Title]];
NiTroUI["30"]["Position"] = UDim2.new(0.19577, 0, 0.25, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Section.Icon
NiTroUI["31"] = Instance.new("ImageLabel", NiTroUI["2f"]);
NiTroUI["31"]["BorderSizePixel"] = 0;
NiTroUI["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["31"]["Image"] = Icon;
NiTroUI["31"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUI["31"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["31"]["BackgroundTransparency"] = 1;
NiTroUI["31"]["Name"] = [[Icon]];
NiTroUI["31"]["Position"] = UDim2.new(0.02646, 0, 0.25, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Section.Line
NiTroUI["32"] = Instance.new("Frame", NiTroUI["2f"]);
NiTroUI["32"]["BorderSizePixel"] = 0;
NiTroUI["32"]["BackgroundColor3"] = Color3.fromRGB(153, 153, 153);
NiTroUI["32"]["Size"] = UDim2.new(0, 189, 0, 2);
NiTroUI["32"]["Position"] = UDim2.new(-0.00529, 0, -0.23131, 0);
NiTroUI["32"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["32"]["Name"] = [[Line]];
end

function NiTroUI:Toggle(Title, Callback)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox
NiTroUI["33"] = Instance.new("Frame", NiTroUI["2c"]);
NiTroUI["33"]["BorderSizePixel"] = 0;
NiTroUI["33"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["33"]["Size"] = UDim2.new(0, 189, 0, 30);
NiTroUI["33"]["Position"] = UDim2.new(0, 0, 0.11215, 0);
NiTroUI["33"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["33"]["Name"] = [[Checkbox]];
NiTroUI["33"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox
NiTroUI["34"] = Instance.new("Frame", NiTroUI["33"]);
NiTroUI["34"]["BorderSizePixel"] = 0;
NiTroUI["34"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
NiTroUI["34"]["Size"] = UDim2.new(0, 195, 0, 30);
NiTroUI["34"]["Position"] = UDim2.new(-0.03355, 0, 0.05838, 0);
NiTroUI["34"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["34"]["Name"] = [[Checkbox]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.UICorner
NiTroUI["35"] = Instance.new("UICorner", NiTroUI["34"]);
NiTroUI["35"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Title
NiTroUI["36"] = Instance.new("TextLabel", NiTroUI["34"]);
NiTroUI["36"]["BorderSizePixel"] = 0;
NiTroUI["36"]["TextSize"] = 12;
NiTroUI["36"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUI["36"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["36"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUI["36"]["TextColor3"] = Color3.fromRGB(241, 241, 241);
NiTroUI["36"]["BackgroundTransparency"] = 1;
NiTroUI["36"]["Size"] = UDim2.new(0, 155, 0, 30);
NiTroUI["36"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["36"]["Text"] = Title;
NiTroUI["36"]["Name"] = [[Title]];
NiTroUI["36"]["Position"] = UDim2.new(0.06252, 0, 0, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check
NiTroUI["37"] = Instance.new("Frame", NiTroUI["34"]);
NiTroUI["37"]["BorderSizePixel"] = 0;
NiTroUI["37"]["BackgroundColor3"] = Color3.fromRGB(46, 46, 46);
NiTroUI["37"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUI["37"]["Position"] = UDim2.new(0.86243, 0, 0.14667, 0);
NiTroUI["37"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["37"]["Name"] = [[Check]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.UICorner
NiTroUI["38"] = Instance.new("UICorner", NiTroUI["37"]);
NiTroUI["38"]["CornerRadius"] = UDim.new(0, 2);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.UIStroke
NiTroUI["39"] = Instance.new("UIStroke", NiTroUI["37"]);
NiTroUI["39"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
NiTroUI["39"]["LineJoinMode"] = Enum.LineJoinMode.Bevel;
NiTroUI["39"]["Color"] = Color3.fromRGB(71, 71, 71);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.Icon
NiTroUI["3a"] = Instance.new("ImageLabel", NiTroUI["37"]);
NiTroUI["3a"]["BorderSizePixel"] = 0;
NiTroUI["3a"]["BackgroundColor3"] = Color3.fromRGB(0, 115, 176);
NiTroUI["3a"]["Image"] = [[rbxassetid://10709790644]];
NiTroUI["3a"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUI["3a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["3a"]["Name"] = [[Icon]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.Icon.UIStroke
NiTroUI["3b"] = Instance.new("UIStroke", NiTroUI["3a"]);
NiTroUI["3b"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
NiTroUI["3b"]["LineJoinMode"] = Enum.LineJoinMode.Bevel;
NiTroUI["3b"]["Color"] = Color3.fromRGB(31, 31, 31);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Checkbox.Checkbox.Check.togglecheck
NiTroUI["3c"] = Instance.new("ImageButton", NiTroUI["37"]);
NiTroUI["3c"]["BorderSizePixel"] = 0;
NiTroUI["3c"]["ImageTransparency"] = 1;
NiTroUI["3c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["3c"]["Image"] = [[rbxasset://textures/ui/GuiImagePlaceholder.png]];
NiTroUI["3c"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUI["3c"]["BackgroundTransparency"] = 1;
NiTroUI["3c"]["Name"] = [[togglecheck]];
NiTroUI["3c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	NiTroUI["3c"].MouseButton1Click:Connect(function()
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
NiTroUI["3d"] = Instance.new("LocalScript", NiTroUI["3c"]);
end

function NiTroUI:Button(Title, Callback)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button
NiTroUI["3e"] = Instance.new("Frame", NiTroUI["2c"]);
NiTroUI["3e"]["BorderSizePixel"] = 0;
NiTroUI["3e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["3e"]["Size"] = UDim2.new(0, 189, 0, 30);
NiTroUI["3e"]["Position"] = UDim2.new(0, 0, 0.49844, 0);
NiTroUI["3e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["3e"]["Name"] = [[Button]];
NiTroUI["3e"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button
NiTroUI["3f"] = Instance.new("Frame", NiTroUI["3e"]);
NiTroUI["3f"]["BorderSizePixel"] = 0;
NiTroUI["3f"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
NiTroUI["3f"]["Size"] = UDim2.new(0, 189, 0, 30);
NiTroUI["3f"]["Position"] = UDim2.new(0, 0, -0.00592, 0);
NiTroUI["3f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["3f"]["Name"] = [[Button]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button.UICorner
NiTroUI["40"] = Instance.new("UICorner", NiTroUI["3f"]);
NiTroUI["40"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button.Title
NiTroUI["41"] = Instance.new("TextLabel", NiTroUI["3f"]);
NiTroUI["41"]["BorderSizePixel"] = 0;
NiTroUI["41"]["TextSize"] = 12;
NiTroUI["41"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUI["41"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["41"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUI["41"]["TextColor3"] = Color3.fromRGB(241, 241, 241);
NiTroUI["41"]["BackgroundTransparency"] = 1;
NiTroUI["41"]["Size"] = UDim2.new(0, 157, 0, 30);
NiTroUI["41"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["41"]["Text"] = Title;
NiTroUI["41"]["Name"] = [[Title]];
NiTroUI["41"]["Position"] = UDim2.new(0.03175, 0, 0, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button.Icon
NiTroUI["42"] = Instance.new("ImageLabel", NiTroUI["3f"]);
NiTroUI["42"]["BorderSizePixel"] = 0;
NiTroUI["42"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["42"]["Image"] = [[rbxassetid://10734898355]];
NiTroUI["42"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUI["42"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["42"]["BackgroundTransparency"] = 1;
NiTroUI["42"]["Name"] = [[Icon]];
NiTroUI["42"]["Position"] = UDim2.new(0.86243, 0, 0.16667, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button.Click
NiTroUI["43"] = Instance.new("ImageButton", NiTroUI["3f"]);
NiTroUI["43"]["BorderSizePixel"] = 0;
NiTroUI["43"]["ImageTransparency"] = 1;
NiTroUI["43"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["43"]["Image"] = [[rbxasset://textures/ui/GuiImagePlaceholder.png]];
NiTroUI["43"]["Size"] = UDim2.new(0, 90, 0, 30);
NiTroUI["43"]["BackgroundTransparency"] = 1;
NiTroUI["43"]["Name"] = [[Click]];
NiTroUI["43"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["43"]["Position"] = UDim2.new(0.52381, 0, 0, 0);
	NiTroUI["43"].MouseButton1Click:Connect(function()
		pcall(Callback)
	end)

-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Button.Button.Click.LocalScript
	NiTroUI["44"] = Instance.new("LocalScript", NiTroUI["43"]);
end

function NiTroUI:Paragraph(Title, Desc)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Paragraph
NiTroUI["45"] = Instance.new("Frame", NiTroUI["2c"]);
NiTroUI["45"]["BorderSizePixel"] = 0;
NiTroUI["45"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["45"]["Size"] = UDim2.new(0, 189, 0, 42);
NiTroUI["45"]["Position"] = UDim2.new(0, 0, 0.49844, 0);
NiTroUI["45"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["45"]["Name"] = [[Paragraph]];
NiTroUI["45"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Paragraph.Paragraph
NiTroUI["46"] = Instance.new("Frame", NiTroUI["45"]);
NiTroUI["46"]["BorderSizePixel"] = 0;
NiTroUI["46"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
NiTroUI["46"]["Size"] = UDim2.new(0, 189, 0, 42);
NiTroUI["46"]["Position"] = UDim2.new(0, 0, -0.00592, 0);
NiTroUI["46"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["46"]["Name"] = [[Paragraph]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Paragraph.Paragraph.UICorner
NiTroUI["47"] = Instance.new("UICorner", NiTroUI["46"]);
NiTroUI["47"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Paragraph.Paragraph.Title
NiTroUI["48"] = Instance.new("TextLabel", NiTroUI["46"]);
NiTroUI["48"]["BorderSizePixel"] = 0;
NiTroUI["48"]["TextSize"] = 12;
NiTroUI["48"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUI["48"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["48"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUI["48"]["TextColor3"] = Color3.fromRGB(241, 241, 241);
NiTroUI["48"]["BackgroundTransparency"] = 1;
NiTroUI["48"]["Size"] = UDim2.new(0, 183, 0, 19);
NiTroUI["48"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["48"]["Text"] = Title;
NiTroUI["48"]["Name"] = [[Title]];
NiTroUI["48"]["Position"] = UDim2.new(0.03175, 0, 0, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Paragraph.Paragraph.Description
NiTroUI["49"] = Instance.new("TextLabel", NiTroUI["46"]);
NiTroUI["49"]["TextWrapped"] = true;
NiTroUI["49"]["BorderSizePixel"] = 0;
NiTroUI["49"]["TextSize"] = 11;
NiTroUI["49"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUI["49"]["TextYAlignment"] = Enum.TextYAlignment.Top;
NiTroUI["49"]["BackgroundColor3"] = Color3.fromRGB(59, 59, 59);
NiTroUI["49"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUI["49"]["TextColor3"] = Color3.fromRGB(92, 92, 92);
NiTroUI["49"]["BackgroundTransparency"] = 1;
NiTroUI["49"]["Size"] = UDim2.new(0, 182, 0, 28);
NiTroUI["49"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["49"]["Text"] = Desc;
NiTroUI["49"]["Name"] = [[Description]];
NiTroUI["49"]["Position"] = UDim2.new(0.03175, 0, 0.30952, 0);
end

function NiTroUI:Slider(Title,MaxValue,Callback)
-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider
NiTroUI["4a"] = Instance.new("Frame", NiTroUI["2c"]);
NiTroUI["4a"]["BorderSizePixel"] = 0;
NiTroUI["4a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["4a"]["Size"] = UDim2.new(0, 189, 0, 42);
NiTroUI["4a"]["Position"] = UDim2.new(0, 0, 0.49844, 0);
NiTroUI["4a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["4a"]["Name"] = [[Slider]];
NiTroUI["4a"]["BackgroundTransparency"] = 1;


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider
NiTroUI["4b"] = Instance.new("Frame", NiTroUI["4a"]);
NiTroUI["4b"]["BorderSizePixel"] = 0;
NiTroUI["4b"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
NiTroUI["4b"]["Size"] = UDim2.new(0, 189, 0, 41);
NiTroUI["4b"]["Position"] = UDim2.new(0, 0, -0.00592, 0);
NiTroUI["4b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["4b"]["Name"] = [[Slider]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.UICorner
NiTroUI["4c"] = Instance.new("UICorner", NiTroUI["4b"]);
NiTroUI["4c"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.Title
NiTroUI["4d"] = Instance.new("TextLabel", NiTroUI["4b"]);
NiTroUI["4d"]["BorderSizePixel"] = 0;
NiTroUI["4d"]["TextSize"] = 12;
NiTroUI["4d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUI["4d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["4d"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUI["4d"]["TextColor3"] = Color3.fromRGB(241, 241, 241);
NiTroUI["4d"]["BackgroundTransparency"] = 1;
NiTroUI["4d"]["Size"] = UDim2.new(0, 182, 0, 19);
NiTroUI["4d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["4d"]["Text"] = Title;
NiTroUI["4d"]["Name"] = [[Title]];
NiTroUI["4d"]["Position"] = UDim2.new(0.03175, 0, 0, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground
NiTroUI["4e"] = Instance.new("Frame", NiTroUI["4b"]);
NiTroUI["4e"]["BorderSizePixel"] = 0;
NiTroUI["4e"]["BackgroundColor3"] = Color3.fromRGB(85, 85, 85);
NiTroUI["4e"]["Size"] = UDim2.new(0, 175, 0, 13);
NiTroUI["4e"]["Position"] = UDim2.new(0.02116, 0, 0.45726, 0);
NiTroUI["4e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["4e"]["Name"] = [[SliderBackground]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.UICorner
NiTroUI["4f"] = Instance.new("UICorner", NiTroUI["4e"]);
NiTroUI["4f"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.SliderColor
NiTroUI["50"] = Instance.new("Frame", NiTroUI["4e"]);
NiTroUI["50"]["BorderSizePixel"] = 0;
NiTroUI["50"]["BackgroundColor3"] = Color3.fromRGB(0, 115, 176);
NiTroUI["50"]["Size"] = UDim2.new(0, 97, 0, 13);
NiTroUI["50"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["50"]["Name"] = [[SliderColor]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.SliderColor.UICorner
NiTroUI["51"] = Instance.new("UICorner", NiTroUI["50"]);
NiTroUI["51"]["CornerRadius"] = UDim.new(0, 3);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.LocalScript
NiTroUI["52"] = Instance.new("LocalScript", NiTroUI["4e"]);



-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.Trigger
NiTroUI["53"] = Instance.new("TextButton", NiTroUI["4e"]);
NiTroUI["53"]["BorderSizePixel"] = 0;
NiTroUI["53"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["53"]["TextSize"] = 14;
NiTroUI["53"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["53"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
NiTroUI["53"]["Size"] = UDim2.new(0, 175, 0, 13);
NiTroUI["53"]["BackgroundTransparency"] = 1;
NiTroUI["53"]["Name"] = [[Trigger]];
NiTroUI["53"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["53"]["Text"] = [[]];


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.Count
NiTroUI["54"] = Instance.new("TextLabel", NiTroUI["4e"]);
NiTroUI["54"]["BorderSizePixel"] = 0;
NiTroUI["54"]["TextSize"] = 14;
NiTroUI["54"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["54"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUI["54"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["54"]["BackgroundTransparency"] = 1;
NiTroUI["54"]["Size"] = UDim2.new(0, 40, 0, 13);
NiTroUI["54"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["54"]["Text"] = [[50]];
NiTroUI["54"]["Name"] = [[Count]];
NiTroUI["54"]["Position"] = UDim2.new(0.41655, 0, 0, 0);


-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.Output
NiTroUI["55"] = Instance.new("NumberValue", NiTroUI["4e"]);
NiTroUI["55"]["Name"] = [[Output]];
	NiTroUI["55"]["Value"] = 0.5;
	
	-- StarterGui.UiLibrary.NiTroHUBUI.Holder.ContainerElement.Element.One.ScrollBar.BlockScrollbar.Slider.Slider.SliderBackground.LocalScript
	local function C_52()
		local script = NiTroUI["52"];
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
NiTroUI["82"] = Instance.new("UICorner", NiTroUI["2"]);



-- StarterGui.UiLibrary.NiTroHUBUI.UIAspectRatioConstraint
NiTroUI["83"] = Instance.new("UIAspectRatioConstraint", NiTroUI["2"]);
NiTroUI["83"]["AspectRatio"] = 1.46667;

function NiTroUI:OpenUI(Title,Icon,BackgroundColor,BorderColor)
-- StarterGui.UiLibrary.OpenButton
NiTroUI["84"] = Instance.new("Frame", NiTroUI["1"]);
NiTroUI["84"]["Visible"] = false;
NiTroUI["84"]["BorderSizePixel"] = 0;
NiTroUI["84"]["BackgroundColor3"] = Color3.fromRGB(BackgroundColor);
NiTroUI["84"]["BorderMode"] = Enum.BorderMode.Middle;
NiTroUI["84"]["Position"] = UDim2.new(0.14899, 0, 0.59917, 0);
NiTroUI["84"]["BorderColor3"] = Color3.fromRGB(BorderColor);
NiTroUI["84"]["Name"] = [[OpenButton]];


-- StarterGui.UiLibrary.OpenButton.UICorner
NiTroUI["85"] = Instance.new("UICorner", NiTroUI["84"]);



-- StarterGui.UiLibrary.OpenButton.Name
NiTroUI["86"] = Instance.new("TextLabel", NiTroUI["84"]);
NiTroUI["86"]["BorderSizePixel"] = 0;
NiTroUI["86"]["TextSize"] = 14;
NiTroUI["86"]["TextXAlignment"] = Enum.TextXAlignment.Left;
NiTroUI["86"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["86"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
NiTroUI["86"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["86"]["BackgroundTransparency"] = 1;
NiTroUI["86"]["Size"] = UDim2.new(0, 103, 0, 40);
NiTroUI["86"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["86"]["Text"] = Title;
NiTroUI["86"]["Name"] = [[Name]];
NiTroUI["86"]["Position"] = UDim2.new(0.30769, 0, 0, 0);


-- StarterGui.UiLibrary.OpenButton.UIStroke
NiTroUI["87"] = Instance.new("UIStroke", NiTroUI["84"]);
NiTroUI["87"]["Color"] = Color3.fromRGB(255, 255, 255);


-- StarterGui.UiLibrary.OpenButton.UIAspectRatioConstraint
NiTroUI["88"] = Instance.new("UIAspectRatioConstraint", NiTroUI["84"]);
NiTroUI["88"]["AspectRatio"] = 3.25;


-- StarterGui.UiLibrary.OpenButton.LocalScript
NiTroUI["89"] = Instance.new("LocalScript", NiTroUI["84"]);



-- StarterGui.UiLibrary.OpenButton.Icon
NiTroUI["8a"] = Instance.new("ImageLabel", NiTroUI["84"]);
NiTroUI["8a"]["BorderSizePixel"] = 0;
NiTroUI["8a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["8a"]["Image"] = Icon;
NiTroUI["8a"]["Size"] = UDim2.new(0, 40, 0, 40);
NiTroUI["8a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["8a"]["BackgroundTransparency"] = 1;
NiTroUI["8a"]["Name"] = [[Icon]];


-- StarterGui.UiLibrary.OpenButton.IconOpen
NiTroUI["8b"] = Instance.new("ImageButton", NiTroUI["84"]);
NiTroUI["8b"]["Active"] = false;
NiTroUI["8b"]["BorderSizePixel"] = 0;
NiTroUI["8b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
NiTroUI["8b"]["Selectable"] = false;
NiTroUI["8b"]["Image"] = [[rbxassetid://10734895698]];
NiTroUI["8b"]["Size"] = UDim2.new(0, 20, 0, 20);
NiTroUI["8b"]["BackgroundTransparency"] = 1;
NiTroUI["8b"]["Name"] = [[IconOpen]];
NiTroUI["8b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
NiTroUI["8b"]["Position"] = UDim2.new(0.78462, 0, 0.25, 0);


-- StarterGui.UiLibrary.OpenButton.IconOpen.LocalScript
NiTroUI["8c"] = Instance.new("LocalScript", NiTroUI["8b"]);
end


-- StarterGui.UiLibrary.LocalScript
NiTroUI["8d"] = Instance.new("LocalScript", NiTroUI["1"]);



-- StarterGui.UiLibrary.NiTroHUBUI.Holder.Topbar.Minimize.LocalScript
local function C_21()
	local script = NiTroUI["21"];
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
	local script = NiTroUI["24"];
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
	local script = NiTroUI["89"];
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
	local script = NiTroUI["8c"];
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
	local script = NiTroUI["8d"];
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

return NiTroUI["1"], require;
