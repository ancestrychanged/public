--[[
	Explorer App Module
	
	The main explorer interface
]]

-- Common Locals
local Main,Lib,Apps,Settings -- Main Containers
local Explorer, Properties, ScriptViewer, ModelViewer, Notebook -- Major Apps
local API,RMD,env,service,plr,create,createSimple -- Main Locals

local function initDeps(data)
	Main = data.Main
	Lib = data.Lib
	Apps = data.Apps
	Settings = data.Settings

	API = data.API
	RMD = data.RMD
	env = data.env
	service = data.service
	plr = data.plr
	create = data.create
	createSimple = data.createSimple
end

local function initAfterMain()
	Explorer = Apps.Explorer
	Properties = Apps.Properties
	ScriptViewer = Apps.ScriptViewer
	ModelViewer = Apps.ModelViewer
	Notebook = Apps.Notebook
end

local function main()
	local Explorer = {}
	local tree,listEntries,explorerOrders,searchResults,specResults = {},{},{},{},{}
	local expanded
	local entryTemplate,treeFrame,toolBar,descendantAddedCon,descendantRemovingCon,itemChangedCon
	local ffa = game.FindFirstAncestorWhichIsA
	local getDescendants = game.GetDescendants
	local getTextSize = service.TextService.GetTextSize
	local updateDebounce,refreshDebounce = false,false
	local nilNode = {Obj = Instance.new("Folder")}
	local idCounter = 0
	local scrollV,scrollH,clipboard
	local renameBox,renamingNode,searchFunc
	local sortingEnabled,autoUpdateSearch
	local table,math = table,math
	local nilMap,nilCons = {},{}
	local connectSignal = game.DescendantAdded.Connect
	local addObject,removeObject,moveObject = nil,nil,nil

	local iconData
	local remote_blocklist = {} -- list of remotes beng blocked, k = the remote instance, v = their old function :3
	nodes = nodes or {}

	addObject = function(root)
		if nodes[root] then return end

		local isNil = false
		local rootParObj = ffa(root,"Instance")
		local par = nodes[rootParObj]

		-- Nil Handling
		if not par then
			if nilMap[root] then
				nilCons[root] = nilCons[root] or {
					connectSignal(root.ChildAdded,addObject),
					connectSignal(root.AncestryChanged,moveObject),
				}
				par = nilNode
				isNil = true
			else
				return
			end
		elseif nilMap[rootParObj] or par == nilNode then
			nilMap[root] = true
			nilCons[root] = nilCons[root] or {
				connectSignal(root.ChildAdded,addObject),
				connectSignal(root.AncestryChanged,moveObject),
			}
			isNil = true
		end

		local newNode = {Obj = root, Parent = par}
		nodes[root] = newNode

		-- Automatic sorting if expanded
		if sortingEnabled and expanded[par] and par.Sorted then
			local left,right = 1,#par
			local floor = math.floor
			local sorter = Explorer.NodeSorter
			local pos = (right == 0 and 1)

			if not pos then
				while true do
					if left >= right then
						if sorter(newNode,par[left]) then
							pos = left
						else
							pos = left+1
						end
						break
					end

					local mid = floor((left+right)/2)
					if sorter(newNode,par[mid]) then
						right = mid-1
					else
						left = mid+1
					end
				end
			end

			table.insert(par,pos,newNode)
		else
			par[#par+1] = newNode
			par.Sorted = nil
		end

		local insts = getDescendants(root)
		for i = 1,#insts do
			local obj = insts[i]
			if nodes[obj] then continue end -- Deferred

			local par = nodes[ffa(obj,"Instance")]
			if not par then continue end
			local newNode = {Obj = obj, Parent = par}
			nodes[obj] = newNode
			par[#par+1] = newNode

			-- Nil Handling
			if isNil then
				nilMap[obj] = true
				nilCons[obj] = nilCons[obj] or {
					connectSignal(obj.ChildAdded,addObject),
					connectSignal(obj.AncestryChanged,moveObject),
				}
			end
		end

		if searchFunc and autoUpdateSearch then
			searchFunc({newNode})
		end

		if not updateDebounce and Explorer.IsNodeVisible(par) then
			if expanded[par] then
				Explorer.PerformUpdate()
			elseif not refreshDebounce then
				Explorer.PerformRefresh()
			end
		end
	end

	removeObject = function(root)
		local node = nodes[root]
		if not node then return end

		-- Nil Handling
		if nilMap[node.Obj] then
			moveObject(node.Obj)
			return
		end

		local par = node.Parent
		if par then
			par.HasDel = true
		end

		local function recur(root)
			for i = 1,#root do
				local node = root[i]
				if not node.Del then
					nodes[node.Obj] = nil
					if #node > 0 then recur(node) end
				end
			end
		end
		recur(node)
		node.Del = true
		nodes[root] = nil

		if par and not updateDebounce and Explorer.IsNodeVisible(par) then
			if expanded[par] then
				Explorer.PerformUpdate()
			elseif not refreshDebounce then
				Explorer.PerformRefresh()
			end
		end
	end

	moveObject = function(obj)
		local node = nodes[obj]
		if not node then return end

		local oldPar = node.Parent
		local newPar = nodes[ffa(obj,"Instance")]
		if oldPar == newPar then return end

		-- Nil Handling
		if not newPar then
			if nilMap[obj] then
				newPar = nilNode
			else
				return
			end
		elseif nilMap[newPar.Obj] or newPar == nilNode then
			nilMap[obj] = true
			nilCons[obj] = nilCons[obj] or {
				connectSignal(obj.ChildAdded,addObject),
				connectSignal(obj.AncestryChanged,moveObject),
			}
		end

		if oldPar then
			local parPos = table.find(oldPar,node)
			if parPos then table.remove(oldPar,parPos) end
		end

		node.Id = nil
		node.Parent = newPar

		if sortingEnabled and expanded[newPar] and newPar.Sorted then
			local left,right = 1,#newPar
			local floor = math.floor
			local sorter = Explorer.NodeSorter
			local pos = (right == 0 and 1)

			if not pos then
				while true do
					if left >= right then
						if sorter(node,newPar[left]) then
							pos = left
						else
							pos = left+1
						end
						break
					end

					local mid = floor((left+right)/2)
					if sorter(node,newPar[mid]) then
						right = mid-1
					else
						left = mid+1
					end
				end
			end

			table.insert(newPar,pos,node)
		else
			newPar[#newPar+1] = node
			newPar.Sorted = nil
		end

		if searchFunc and searchResults[node] then
			local currentNode = node.Parent
			while currentNode and (not searchResults[currentNode] or expanded[currentNode] == 0) do
				expanded[currentNode] = true
				searchResults[currentNode] = true
				currentNode = currentNode.Parent
			end
		end

		if not updateDebounce and (Explorer.IsNodeVisible(newPar) or Explorer.IsNodeVisible(oldPar)) then
			if expanded[newPar] or expanded[oldPar] then
				Explorer.PerformUpdate()
			elseif not refreshDebounce then
				Explorer.PerformRefresh()
			end
		end
	end

	Explorer.ViewWidth = 0
	Explorer.Index = 0
	Explorer.EntryIndent = 20
	Explorer.FreeWidth = 32
	Explorer.GuiElems = {}

	Explorer.InitRenameBox = function()
		renameBox = create({{1,"TextBox",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderColor3=Color3.new(0.062745101749897,0.51764708757401,1),BorderMode=2,ClearTextOnFocus=false,Font=3,Name="RenameBox",PlaceholderColor3=Color3.new(0.69803923368454,0.69803923368454,0.69803923368454),Position=UDim2.new(0,26,0,2),Size=UDim2.new(0,200,0,16),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,Visible=false,ZIndex=2}}})

		renameBox.Parent = Explorer.Window.GuiElems.Content.List

		renameBox.FocusLost:Connect(function()
			if not renamingNode then return end

			pcall(function() renamingNode.Obj.Name = renameBox.Text end)
			renamingNode = nil
			Explorer.Refresh()
		end)

		renameBox.Focused:Connect(function()
			renameBox.SelectionStart = 1
			renameBox.CursorPosition = #renameBox.Text + 1
		end)
	end

	Explorer.SetRenamingNode = function(node)
		renamingNode = node
		renameBox.Text = tostring(node.Obj)
		renameBox:CaptureFocus()
		Explorer.Refresh()
	end

	Explorer.SetSortingEnabled = function(val)
		sortingEnabled = val
		Settings.Explorer.Sorting = val
	end

	Explorer.UpdateView = function()
		local maxNodes = math.ceil(treeFrame.AbsoluteSize.Y / 20)
		local maxX = treeFrame.AbsoluteSize.X
		local totalWidth = Explorer.ViewWidth + Explorer.FreeWidth

		scrollV.VisibleSpace = maxNodes
		scrollV.TotalSpace = #tree + 1
		scrollH.VisibleSpace = maxX
		scrollH.TotalSpace = totalWidth

		scrollV.Gui.Visible = #tree + 1 > maxNodes
		scrollH.Gui.Visible = totalWidth > maxX

		local oldSize = treeFrame.Size
		treeFrame.Size = UDim2.new(1,(scrollV.Gui.Visible and -16 or 0),1,(scrollH.Gui.Visible and -39 or -23))
		if oldSize ~= treeFrame.Size then
			Explorer.UpdateView()
		else
			scrollV:Update()
			scrollH:Update()

			renameBox.Size = UDim2.new(0,maxX-100,0,16)

			if scrollV.Gui.Visible and scrollH.Gui.Visible then
				scrollV.Gui.Size = UDim2.new(0,16,1,-39)
				scrollH.Gui.Size = UDim2.new(1,-16,0,16)
				Explorer.Window.GuiElems.Content.ScrollCorner.Visible = true
			else
				scrollV.Gui.Size = UDim2.new(0,16,1,-23)
				scrollH.Gui.Size = UDim2.new(1,0,0,16)
				Explorer.Window.GuiElems.Content.ScrollCorner.Visible = false
			end

			Explorer.Index = scrollV.Index
		end
	end

	Explorer.NodeSorter = function(a,b)
		if a.Del or b.Del then return false end -- Ghost node

		local aClass = a.Class
		local bClass = b.Class
		if not aClass then aClass = a.Obj.ClassName a.Class = aClass end
		if not bClass then bClass = b.Obj.ClassName b.Class = bClass end

		local aOrder = explorerOrders[aClass]
		local bOrder = explorerOrders[bClass]
		if not aOrder then aOrder = RMD.Classes[aClass] and tonumber(RMD.Classes[aClass].ExplorerOrder) or 9999 explorerOrders[aClass] = aOrder end
		if not bOrder then bOrder = RMD.Classes[bClass] and tonumber(RMD.Classes[bClass].ExplorerOrder) or 9999 explorerOrders[bClass] = bOrder end

		if aOrder ~= bOrder then
			return aOrder < bOrder
		else
			local aName,bName = tostring(a.Obj),tostring(b.Obj)
			if aName ~= bName then
				return aName < bName
			elseif aClass ~= bClass then
				return aClass < bClass
			else
				local aId = a.Id if not aId then aId = idCounter idCounter = (idCounter+0.001)%999999999 a.Id = aId end
				local bId = b.Id if not bId then bId = idCounter idCounter = (idCounter+0.001)%999999999 b.Id = bId end
				return aId < bId
			end
		end
	end

	Explorer.Update = function()
		table.clear(tree)
		local maxNameWidth,maxDepth,count = 0,1,1
		local nameCache = {}
		local font = Enum.Font.SourceSans
		local size = Vector2.new(math.huge,20)
		local useNameWidth = Settings.Explorer.UseNameWidth
		local tSort = table.sort
		local sortFunc = Explorer.NodeSorter
		local isSearching = (expanded == Explorer.SearchExpanded)
		local textServ = service.TextService

		local function recur(root,depth)
			if depth > maxDepth then maxDepth = depth end
			depth = depth + 1
			if sortingEnabled and not root.Sorted then
				tSort(root,sortFunc)
				root.Sorted = true
			end
			for i = 1,#root do
				local n = root[i]

				if (isSearching and not searchResults[n]) or n.Del then continue end

				if useNameWidth then
					local nameWidth = n.NameWidth
					if not nameWidth then
						local objName = tostring(n.Obj)
						nameWidth = nameCache[objName]
						if not nameWidth then
							nameWidth = getTextSize(textServ,objName,14,font,size).X
							nameCache[objName] = nameWidth
						end
						n.NameWidth = nameWidth
					end
					if nameWidth > maxNameWidth then
						maxNameWidth = nameWidth
					end
				end

				tree[count] = n
				count = count + 1
				if expanded[n] and #n > 0 then
					recur(n,depth)
				end
			end
		end

		recur(nodes[game],1)

		-- Nil Instances
		if env.getnilinstances then
			if not (isSearching and not searchResults[nilNode]) then
				tree[count] = nilNode
				count = count + 1
				if expanded[nilNode] then
					recur(nilNode,2)
				end
			end
		end

		Explorer.MaxNameWidth = maxNameWidth
		Explorer.MaxDepth = maxDepth
		Explorer.ViewWidth = useNameWidth and Explorer.EntryIndent*maxDepth + maxNameWidth + 26 or Explorer.EntryIndent*maxDepth + 226
		Explorer.UpdateView()
	end

	Explorer.StartDrag = function(offX,offY)
		if Explorer.Dragging then return end
		for i,v in next, selection.List do
			local Obj = v.Obj
			if Obj.Parent == game or Obj:IsA("Player") then
				return
			end
		end
		Explorer.Dragging = true

		local dragTree = treeFrame:Clone()
		dragTree:ClearAllChildren()

		for i,v in pairs(listEntries) do
			local node = tree[i + Explorer.Index]
			if node and selection.Map[node] then
				local clone = v:Clone()
				clone.Active = false
				clone.Indent.Expand.Visible = false
				clone.Parent = dragTree
			end
		end

		local newGui = Instance.new("ScreenGui")
		newGui.DisplayOrder = Main.DisplayOrders.Menu
		dragTree.Parent = newGui
		Lib.ShowGui(newGui)

		local dragOutline = create({
			{1,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="DragSelect",Size=UDim2.new(1,0,1,0),}},
			{2,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Name="Line",Parent={1},Size=UDim2.new(1,0,0,1),ZIndex=2,}},
			{3,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Name="Line",Parent={1},Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1),ZIndex=2,}},
			{4,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Name="Line",Parent={1},Size=UDim2.new(0,1,1,0),ZIndex=2,}},
			{5,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Name="Line",Parent={1},Position=UDim2.new(1,-1,0,0),Size=UDim2.new(0,1,1,0),ZIndex=2,}},
		})
		dragOutline.Parent = treeFrame

		local mouse = Main.Mouse or service.Players.LocalPlayer:GetMouse()
		local function move()
			local posX = mouse.X - offX
			local posY = mouse.Y - offY
			dragTree.Position = UDim2.new(0,posX,0,posY)

			for i = 1,#listEntries do
				local entry = listEntries[i]
				if Lib.CheckMouseInGui(entry) then
					dragOutline.Position = UDim2.new(0,entry.Indent.Position.X.Offset-scrollH.Index,0,entry.Position.Y.Offset)
					dragOutline.Size = UDim2.new(0,entry.Size.X.Offset-entry.Indent.Position.X.Offset,0,20)
					dragOutline.Visible = true
					return
				end
			end
			dragOutline.Visible = false
		end
		move()

		local input = service.UserInputService
		local mouseEvent,releaseEvent

		mouseEvent = input.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				move()
			end
		end)

		releaseEvent = input.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				releaseEvent:Disconnect()
				mouseEvent:Disconnect()
				newGui:Destroy()
				dragOutline:Destroy()
				Explorer.Dragging = false

				for i = 1,#listEntries do
					if Lib.CheckMouseInGui(listEntries[i]) then
						local node = tree[i + Explorer.Index]
						if node then
							if selection.Map[node] then return end
							local newPar = node.Obj
							local sList = selection.List
							for i = 1,#sList do
								local n = sList[i]
								pcall(function() n.Obj.Parent = newPar end)
							end
							Explorer.ViewNode(sList[1])
						end
						break
					end
				end
			end
		end)
	end

	Explorer.NewListEntry = function(index)
		local newEntry = entryTemplate:Clone()
		newEntry.Position = UDim2.new(0,0,0,20*(index-1))

		local isRenaming = false

		newEntry.InputBegan:Connect(function(input)
			local node = tree[index + Explorer.Index]
			if not node or selection.Map[node] or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end

			newEntry.Indent.BackgroundColor3 = Settings.Theme.Button
			newEntry.Indent.BorderSizePixel = 0
			newEntry.Indent.BackgroundTransparency = 0
		end)

		newEntry.InputEnded:Connect(function(input)
			local node = tree[index + Explorer.Index]
			if not node or selection.Map[node] or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end

			newEntry.Indent.BackgroundTransparency = 1
		end)

		newEntry.MouseButton1Down:Connect(function()

		end)

		newEntry.MouseButton1Up:Connect(function()

		end)

		newEntry.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				local releaseEvent, mouseEvent

				local mouse = Main.Mouse or plr:GetMouse()
				local startX, startY

				if input.UserInputType == Enum.UserInputType.Touch then
					startX = input.Position.X
					startY = input.Position.Y
				else
					startX = mouse.X
					startY = mouse.Y
				end

				local listOffsetX = startX - treeFrame.AbsolutePosition.X
				local listOffsetY = startY - treeFrame.AbsolutePosition.Y

				releaseEvent = service.UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						releaseEvent:Disconnect()
						mouseEvent:Disconnect()
					end
				end)

				mouseEvent = service.UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						local currentX, currentY

						if input.UserInputType == Enum.UserInputType.Touch then
							currentX = input.Position.X
							currentY = input.Position.Y
						else
							currentX = mouse.X
							currentY = mouse.Y
						end

						local deltaX = currentX - startX
						local deltaY = currentY - startY
						local dist = math.sqrt(deltaX^2 + deltaY^2)

						if dist > 5 then
							releaseEvent:Disconnect()
							mouseEvent:Disconnect()
							isRenaming = false
							Explorer.StartDrag(listOffsetX, listOffsetY)
						end
					end
				end)
			end
		end)

		newEntry.MouseButton2Down:Connect(function()

		end)

		newEntry.Indent.Expand.InputBegan:Connect(function(input)
			local node = tree[index + Explorer.Index]
			if not node or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end

			if input.UserInputType == Enum.UserInputType.Touch then
				Explorer.MiscIcons:DisplayByKey(newEntry.Indent.Expand.Icon, expanded[node] and "Collapse_Over" or "Expand_Over")
			elseif input.UserInputType == Enum.UserInputType.MouseMovement then
				Explorer.MiscIcons:DisplayByKey(newEntry.Indent.Expand.Icon, expanded[node] and "Collapse_Over" or "Expand_Over")
			end
		end)

		newEntry.Indent.Expand.InputEnded:Connect(function(input)
			local node = tree[index + Explorer.Index]
			if not node or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end

			if input.UserInputType == Enum.UserInputType.Touch then
				Explorer.MiscIcons:DisplayByKey(newEntry.Indent.Expand.Icon, expanded[node] and "Collapse" or "Expand")
			elseif input.UserInputType == Enum.UserInputType.MouseMovement then
				Explorer.MiscIcons:DisplayByKey(newEntry.Indent.Expand.Icon, expanded[node] and "Collapse" or "Expand")
			end
		end)

		newEntry.Indent.Expand.MouseButton1Down:Connect(function()
			local node = tree[index + Explorer.Index]
			if not node or #node == 0 then return end

			expanded[node] = not expanded[node]
			Explorer.Update()
			Explorer.Refresh()
		end)

		newEntry.Parent = treeFrame
		return newEntry
	end

	Explorer.Refresh = function()
		local maxNodes = math.max(math.ceil((treeFrame.AbsoluteSize.Y) / 20), 0)	
		local renameNodeVisible = false
		local isa = game.IsA

		for i = 1,maxNodes do
			local entry = listEntries[i]
			if not listEntries[i] then entry = Explorer.NewListEntry(i) listEntries[i] = entry Explorer.ClickSystem:Add(entry) end

			local node = tree[i + Explorer.Index]
			if node then
				local obj = node.Obj
				local depth = Explorer.EntryIndent*Explorer.NodeDepth(node)

				entry.Visible = true
				entry.Position = UDim2.new(0,-scrollH.Index,0,entry.Position.Y.Offset)
				entry.Size = UDim2.new(0,Explorer.ViewWidth,0,20)
				entry.Indent.EntryName.Text = tostring(node.Obj)
				entry.Indent.Position = UDim2.new(0,depth,0,0)
				entry.Indent.Size = UDim2.new(1,-depth,1,0)

				entry.Indent.EntryName.TextTruncate = (Settings.Explorer.UseNameWidth and Enum.TextTruncate.None or Enum.TextTruncate.AtEnd)

				Explorer.MiscIcons:DisplayExplorerIcons(entry.Indent.Icon, obj.ClassName)

				if selection.Map[node] then
					entry.Indent.BackgroundColor3 = Settings.Theme.ListSelection
					entry.Indent.BorderSizePixel = 0
					entry.Indent.BackgroundTransparency = 0
				else
					if Lib.CheckMouseInGui(entry) then
						entry.Indent.BackgroundColor3 = Settings.Theme.Button
					else
						entry.Indent.BackgroundTransparency = 1
					end
				end

				if node == renamingNode then
					renameNodeVisible = true
					renameBox.Position = UDim2.new(0,depth+25-scrollH.Index,0,entry.Position.Y.Offset+2)
					renameBox.Visible = true
				end

				if #node > 0 and expanded[node] ~= 0 then
					if Lib.CheckMouseInGui(entry.Indent.Expand) then
						Explorer.MiscIcons:DisplayByKey(entry.Indent.Expand.Icon, expanded[node] and "Collapse_Over" or "Expand_Over")
					else
						Explorer.MiscIcons:DisplayByKey(entry.Indent.Expand.Icon, expanded[node] and "Collapse" or "Expand")
					end
					entry.Indent.Expand.Visible = true
				else
					entry.Indent.Expand.Visible = false
				end
			else
				entry.Visible = false
			end
		end

		if not renameNodeVisible then
			renameBox.Visible = false
		end

		for i = maxNodes+1, #listEntries do
			Explorer.ClickSystem:Remove(listEntries[i])
			listEntries[i]:Destroy()
			listEntries[i] = nil
		end
	end

	Explorer.PerformUpdate = function(instant)
		updateDebounce = true
		Lib.FastWait(not instant and 0.1)
		if not updateDebounce then return end
		updateDebounce = false
		if not Explorer.Window:IsVisible() then return end
		Explorer.Update()
		Explorer.Refresh()
	end

	Explorer.ForceUpdate = function(norefresh)
		updateDebounce = false
		Explorer.Update()
		if not norefresh then Explorer.Refresh() end
	end

	Explorer.PerformRefresh = function()
		refreshDebounce = true
		Lib.FastWait(0.1)
		refreshDebounce = false
		if updateDebounce or not Explorer.Window:IsVisible() then return end
		Explorer.Refresh()
	end

	Explorer.IsNodeVisible = function(node)
		if not node then return end

		local curNode = node.Parent
		while curNode do
			if not expanded[curNode] then return false end
			curNode = curNode.Parent
		end
		return true
	end

	Explorer.NodeDepth = function(node)
		local depth = 0

		if node == nilNode then
			return 1
		end

		local curNode = node.Parent
		while curNode do
			if curNode == nilNode then depth = depth + 1 end
			curNode = curNode.Parent
			depth = depth + 1
		end
		return depth
	end

	Explorer.SetupConnections = function()
		if descendantAddedCon then descendantAddedCon:Disconnect() end
		if descendantRemovingCon then descendantRemovingCon:Disconnect() end
		if itemChangedCon then itemChangedCon:Disconnect() end

		if Main.Elevated then
			descendantAddedCon = game.DescendantAdded:Connect(addObject)
			descendantRemovingCon = game.DescendantRemoving:Connect(removeObject)
		else
			descendantAddedCon = game.DescendantAdded:Connect(function(obj) pcall(addObject,obj) end)
			descendantRemovingCon = game.DescendantRemoving:Connect(function(obj) pcall(removeObject,obj) end)
		end

		if Settings.Explorer.UseNameWidth then
			itemChangedCon = game.ItemChanged:Connect(function(obj,prop)
				if prop == "Parent" and nodes[obj] then
					moveObject(obj)
				elseif prop == "Name" and nodes[obj] then
					nodes[obj].NameWidth = nil
				end
			end)
		else
			itemChangedCon = game.ItemChanged:Connect(function(obj,prop)
				if prop == "Parent" and nodes[obj] then
					moveObject(obj)
				end
			end)
		end
	end

	Explorer.ViewNode = function(node)
		if not node then return end

		Explorer.MakeNodeVisible(node)
		Explorer.ForceUpdate(true)
		local visibleSpace = scrollV.VisibleSpace

		for i,v in next,tree do
			if v == node then
				local relative = i - 1
				if Explorer.Index > relative then
					scrollV.Index = relative
				elseif Explorer.Index + visibleSpace - 1 <= relative then
					scrollV.Index = relative - visibleSpace + 2
				end
			end
		end

		scrollV:Update() Explorer.Index = scrollV.Index
		Explorer.Refresh()
	end

	Explorer.ViewObj = function(obj)
		Explorer.ViewNode(nodes[obj])
	end

	Explorer.MakeNodeVisible = function(node,expandRoot)
		if not node then return end

		local hasExpanded = false

		if expandRoot and not expanded[node] then
			expanded[node] = true
			hasExpanded = true
		end

		local currentNode = node.Parent
		while currentNode do
			hasExpanded = true
			expanded[currentNode] = true
			currentNode = currentNode.Parent
		end

		if hasExpanded and not updateDebounce then
			coroutine.wrap(Explorer.PerformUpdate)(true)
		end
	end

	Explorer.ShowRightClick = function(MousePos)
		local Mouse = MousePos or Main.Mouse
		local context = Explorer.RightClickContext
		local absoluteSize = context.Gui.AbsoluteSize
		context.MaxHeight = (absoluteSize.Y <= 600 and (absoluteSize.Y - 40)) or nil
		context:Clear()

		local sList = selection.List
		local sMap = selection.Map
		local emptyClipboard = #clipboard == 0
		local presentClasses = {}
		local apiClasses = API.Classes

		for i = 1, #sList do
			local node = sList[i]
			local class = node.Class
			local obj = node.Obj

			if not presentClasses.isViableDecompileScript then
				presentClasses.isViableDecompileScript = env.isViableDecompileScript(obj)
			end
			if not class then
				class = obj.ClassName
				node.Class = class
			end

			local curClass = apiClasses[class]
			while curClass and not presentClasses[curClass.Name] do
				presentClasses[curClass.Name] = true
				curClass = curClass.Superclass
			end
		end

		context:AddRegistered("CUT")
		context:AddRegistered("COPY")
		context:AddRegistered("PASTE", emptyClipboard)
		context:AddRegistered("DUPLICATE")
		context:AddRegistered("DELETE")
		context:AddRegistered("DELETE_CHILDREN", #sList ~= 1)
		context:AddRegistered("RENAME", #sList ~= 1)

		context:AddDivider()

		context:AddRegistered("GROUP")
		context:AddRegistered("UNGROUP")
		context:AddRegistered("SELECT_CHILDREN")
		context:AddRegistered("JUMP_TO_PARENT")
		context:AddRegistered("EXPAND_ALL")
		context:AddRegistered("COLLAPSE_ALL")

		context:AddDivider()

		if expanded == Explorer.SearchExpanded then context:AddRegistered("CLEAR_SEARCH_AND_JUMP_TO") end
		if env.setclipboard then context:AddRegistered("COPY_PATH") end
		context:AddRegistered("INSERT_OBJECT")
		context:AddRegistered("SAVE_INST")
		context:AddRegistered("COPY_API_PAGE")
		context:AddRegistered("SHOW_XREFS", not (filtergc or getgc or get_gc_objects or getconnections or get_signal_cons or getcallbackvalue or getcallbackmember or getallthreads or env.getreg or env.getregistry))

		context:QueueDivider()

		if presentClasses["BasePart"] or presentClasses["Model"] then
			context:AddRegistered("TELEPORT_TO")
			context:AddRegistered("VIEW_OBJECT")
			context:AddRegistered("3DVIEW_MODEL")
		end
		
		if presentClasses["Animation"] then
			context:AddRegistered("LOAD_ANIMATION")
			context:AddRegistered("STOP_ANIMATION")
		end
		
		if presentClasses["Tween"] then context:AddRegistered("PLAY_TWEEN") end
		
		if presentClasses["TouchTransmitter"] then context:AddRegistered("FIRE_TOUCHTRANSMITTER", firetouchinterest == nil) end
		if presentClasses["ClickDetector"] then context:AddRegistered("FIRE_CLICKDETECTOR", fireclickdetector == nil) end
		if presentClasses["ProximityPrompt"] then context:AddRegistered("FIRE_PROXIMITYPROMPT", fireproximityprompt == nil) end
		
		if presentClasses["RemoteEvent"] then context:AddRegistered("BLOCK_REMOTE", env.hookfunction == nil) end
		if presentClasses["RemoteEvent"] then context:AddRegistered("UNBLOCK_REMOTE", env.hookfunction == nil) end
		
		if presentClasses["RemoteFunction"] then context:AddRegistered("BLOCK_REMOTE", env.hookfunction == nil) end
		if presentClasses["RemoteFunction"] then context:AddRegistered("UNBLOCK_REMOTE", env.hookfunction == nil) end

		if presentClasses["UnreliableRemoteEvent"] then context:AddRegistered("BLOCK_REMOTE", env.hookfunction == nil) end
		if presentClasses["UnreliableRemoteEvent"] then context:AddRegistered("UNBLOCK_REMOTE", env.hookfunction == nil) end
		
		if presentClasses["BindableEvent"] then context:AddRegistered("BLOCK_REMOTE", env.hookfunction == nil) end
		if presentClasses["BindableEvent"] then context:AddRegistered("UNBLOCK_REMOTE", env.hookfunction == nil) end
		
		if presentClasses["BindableFunction"] then context:AddRegistered("BLOCK_REMOTE", env.hookfunction == nil) end
		if presentClasses["BindableFunction"] then context:AddRegistered("UNBLOCK_REMOTE", env.hookfunction == nil) end
		
		if presentClasses["Player"] then context:AddRegistered("SELECT_CHARACTER")context:AddRegistered("VIEW_PLAYER") end
		if presentClasses["Players"] then
			context:AddRegistered("SELECT_LOCAL_PLAYER")
			context:AddRegistered("SELECT_ALL_CHARACTERS")
		end

		if presentClasses["LuaSourceContainer"] then
			context:AddRegistered("VIEW_SCRIPT", not presentClasses.isViableDecompileScript or env.decompile == nil)
			context:AddRegistered("DUMP_FUNCTIONS", not presentClasses.isViableDecompileScript or env.getupvalues == nil or env.getconstants == nil)
			context:AddRegistered("SAVE_SCRIPT", not presentClasses.isViableDecompileScript or env.decompile == nil or env.writefile == nil)
			context:AddRegistered("SAVE_BYTECODE", not presentClasses.isViableDecompileScript or env.getscriptbytecode == nil or env.writefile == nil)

		end

		if sMap[nilNode] then
			context:AddRegistered("REFRESH_NIL")
			context:AddRegistered("HIDE_NIL")
		end

		Explorer.LastRightClickX, Explorer.LastRightClickY = Mouse.X, Mouse.Y
		context:Show(Mouse.X, Mouse.Y)
	end

	Explorer.InitRightClick = function()
		local context = Lib.ContextMenu.new()

		context:Register("CUT",{Name = "Cut", IconMap = Explorer.MiscIcons, Icon = "Cut", DisabledIcon = "Cut_Disabled", Shortcut = "Ctrl+Z", OnClick = function()
			local destroy,clone = game.Destroy,game.Clone
			local sList,newClipboard = selection.List,{}
			local count = 1
			for i = 1,#sList do
				local inst = sList[i].Obj
				local s,cloned = pcall(clone,inst)
				if s and cloned then
					newClipboard[count] = cloned
					count = count + 1
				end
				pcall(destroy,inst)
			end
			clipboard = newClipboard
			selection:Clear()
		end})

		context:Register("COPY",{Name = "Copy", IconMap = Explorer.MiscIcons, Icon = "Copy", DisabledIcon = "Copy_Disabled", Shortcut = "Ctrl+C", OnClick = function()
			local clone = game.Clone
			local sList,newClipboard = selection.List,{}
			local count = 1
			for i = 1,#sList do
				local inst = sList[i].Obj
				local s,cloned = pcall(clone,inst)
				if s and cloned then
					newClipboard[count] = cloned
					count = count + 1
				end
			end
			clipboard = newClipboard
		end})

		context:Register("PASTE",{Name = "Paste Into", IconMap = Explorer.MiscIcons, Icon = "Paste", DisabledIcon = "Paste_Disabled", Shortcut = "Ctrl+Shift+V", OnClick = function()
			local sList = selection.List
			local newSelection = {}
			local count = 1
			for i = 1,#sList do
				local node = sList[i]
				local inst = node.Obj
				Explorer.MakeNodeVisible(node,true)
				for c = 1,#clipboard do
					local cloned = clipboard[c]:Clone()
					if cloned then
						cloned.Parent = inst
						local clonedNode = nodes[cloned]
						if clonedNode then newSelection[count] = clonedNode count = count + 1 end
					end
				end
			end
			selection:SetTable(newSelection)

			if #newSelection > 0 then
				Explorer.ViewNode(newSelection[1])
			end
		end})

		context:Register("DUPLICATE",{Name = "Duplicate", IconMap = Explorer.MiscIcons, Icon = "Copy", DisabledIcon = "Copy_Disabled", Shortcut = "Ctrl+D", OnClick = function()
			local clone = game.Clone
			local sList = selection.List
			local newSelection = {}
			local count = 1
			for i = 1,#sList do
				local node = sList[i]
				local inst = node.Obj
				local instPar = node.Parent and node.Parent.Obj
				Explorer.MakeNodeVisible(node)
				local s,cloned = pcall(clone,inst)
				if s and cloned then
					cloned.Parent = instPar
					local clonedNode = nodes[cloned]
					if clonedNode then newSelection[count] = clonedNode count = count + 1 end
				end
			end

			selection:SetTable(newSelection)
			if #newSelection > 0 then
				Explorer.ViewNode(newSelection[1])
			end
		end})

		context:Register("DELETE",{Name = "Delete", IconMap = Explorer.MiscIcons, Icon = "Delete", DisabledIcon = "Delete_Disabled", Shortcut = "Del", OnClick = function()
			local destroy = game.Destroy
			local sList = selection.List
			for i = 1,#sList do
				pcall(destroy,sList[i].Obj)
			end
			selection:Clear()
		end})
		
		context:Register("DELETE_CHILDREN",{Name = "Delete Children", IconMap = Explorer.MiscIcons, Icon = "Delete", DisabledIcon = "Delete_Disabled", Shortcut = "Shift+Del", OnClick = function()
			local sList = selection.List
			for i = 1,#sList do
				pcall(sList[i].Obj.ClearAllChildren,sList[i].Obj)
			end
			selection:Clear()
		end})
		context:Register("RENAME",{Name = "Rename", IconMap = Explorer.MiscIcons, Icon = "Rename", DisabledIcon = "Rename_Disabled", Shortcut = "F2", OnClick = function()
			local sList = selection.List
			if sList[1] then
				Explorer.SetRenamingNode(sList[1])
			end
		end})

		context:Register("GROUP",{Name = "Group", IconMap = Explorer.MiscIcons, Icon = "Group", DisabledIcon = "Group_Disabled", Shortcut = "Ctrl+G", OnClick = function()
			local sList = selection.List
			if #sList == 0 then return end

			local model = Instance.new("Model",sList[#sList].Obj.Parent)
			for i = 1,#sList do
				pcall(function() sList[i].Obj.Parent = model end)
			end

			if nodes[model] then
				selection:Set(nodes[model])
				Explorer.ViewNode(nodes[model])
			end
		end})

		context:Register("UNGROUP",{Name = "Ungroup", IconMap = Explorer.MiscIcons, Icon = "Ungroup", DisabledIcon = "Ungroup_Disabled", Shortcut = "Ctrl+U", OnClick = function()
			local newSelection = {}
			local count = 1
			local isa = game.IsA

			local function ungroup(node)
				local par = node.Parent.Obj
				local ch = {}
				local chCount = 1

				for i = 1,#node do
					local n = node[i]
					newSelection[count] = n
					ch[chCount] = n
					count = count + 1
					chCount = chCount + 1
				end

				for i = 1,#ch do
					pcall(function() ch[i].Obj.Parent = par end)
				end

				node.Obj:Destroy()
			end

			for i,v in next,selection.List do
				if isa(v.Obj,"Model") then
					ungroup(v)
				end
			end

			selection:SetTable(newSelection)
			if #newSelection > 0 then
				Explorer.ViewNode(newSelection[1])
			end
		end})

		context:Register("SELECT_CHILDREN",{Name = "Select Children", IconMap = Explorer.MiscIcons, Icon = "SelectChildren", DisabledIcon = "SelectChildren_Disabled", OnClick = function()
			local newSelection = {}
			local count = 1
			local sList = selection.List

			for i = 1,#sList do
				local node = sList[i]
				for ind = 1,#node do
					local cNode = node[ind]
					if ind == 1 then Explorer.MakeNodeVisible(cNode) end

					newSelection[count] = cNode
					count = count + 1
				end
			end

			selection:SetTable(newSelection)
			if #newSelection > 0 then
				Explorer.ViewNode(newSelection[1])
			else
				Explorer.Refresh()
			end
		end})

		context:Register("JUMP_TO_PARENT",{Name = "Jump to Parent", IconMap = Explorer.MiscIcons, Icon = "JumpToParent", OnClick = function()
			local newSelection = {}
			local count = 1
			local sList = selection.List

			for i = 1,#sList do
				local node = sList[i]
				if node.Parent then
					newSelection[count] = node.Parent
					count = count + 1
				end
			end

			selection:SetTable(newSelection)
			if #newSelection > 0 then
				Explorer.ViewNode(newSelection[1])
			else
				Explorer.Refresh()
			end
		end})

		context:Register("TELEPORT_TO",{Name = "Teleport To", IconMap = Explorer.MiscIcons, Icon = "TeleportTo", OnClick = function()
			local sList = selection.List
			local plrRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

			if not plrRP then return end

			for _,node in next, sList do
				local Obj = node.Obj

				if Obj:IsA("BasePart") then
					if Obj.CanCollide then
						plr.Character:MoveTo(Obj.Position)
					else
						plrRP.CFrame = CFrame.new(Obj.Position + Settings.Explorer.TeleportToOffset)
					end
					break
				elseif Obj:IsA("Model") then
					if Obj.PrimaryPart then
						if Obj.PrimaryPart.CanCollide then
							plr.Character:MoveTo(Obj.PrimaryPart.Position)
						else
							plrRP.CFrame = CFrame.new(Obj.PrimaryPart.Position + Settings.Explorer.TeleportToOffset)
						end
						break
					else
						local part = Obj:FindFirstChildWhichIsA("BasePart", true)
						if part and nodes[part] then
							if part.CanCollide then
								plr.Character:MoveTo(part.Position)
							else
								plrRP.CFrame = CFrame.new(part.Position + Settings.Explorer.TeleportToOffset)
							end
							break
						elseif Obj.WorldPivot then
							plrRP.CFrame = Obj.WorldPivot
						end
					end
				end
			end
		end})

		local OldAnimation
		context:Register("PLAY_TWEEN",{Name = "Play Tween", IconMap = Explorer.MiscIcons, Icon = "Play", OnClick = function()
			local sList = selection.List

			for i = 1, #sList do
				local node = sList[i]
				local Obj = node.Obj

				if Obj:IsA("Tween") then Obj:Play() end
			end
		end})

		local OldAnimation
		context:Register("LOAD_ANIMATION",{Name = "Load Animation", IconMap = Explorer.MiscIcons, Icon = "Play", OnClick = function()
			local sList = selection.List

			local Humanoid = plr.Character and plr.Character:FindFirstChild("Humanoid")
			if not Humanoid then return end

			for i = 1, #sList do
				local node = sList[i]
				local Obj = node.Obj

				if Obj:IsA("Animation") then
					if OldAnimation then OldAnimation:Stop() end
					OldAnimation = Humanoid:LoadAnimation(Obj)
					OldAnimation:Play()
					break
				end
			end
		end})

		context:Register("STOP_ANIMATION",{Name = "Stop Animation", IconMap = Explorer.MiscIcons, Icon = "Pause", OnClick = function()
			local sList = selection.List

			local Humanoid = plr.Character and plr.Character:FindFirstChild("Humanoid")
			if not Humanoid then return end

			for i = 1, #sList do
				local node = sList[i]
				local Obj = node.Obj

				if Obj:IsA("Animation") then
					if OldAnimation then OldAnimation:Stop() end
					Humanoid:LoadAnimation(Obj):Stop()
					break
				end
			end
		end})

		context:Register("EXPAND_ALL",{Name = "Expand All", OnClick = function()
			local sList = selection.List

			local function expand(node)
				expanded[node] = true
				for i = 1,#node do
					if #node[i] > 0 then
						expand(node[i])
					end
				end
			end

			for i = 1,#sList do
				expand(sList[i])
			end

			Explorer.ForceUpdate()
		end})

		context:Register("COLLAPSE_ALL",{Name = "Collapse All", OnClick = function()
			local sList = selection.List

			local function expand(node)
				expanded[node] = nil
				for i = 1,#node do
					if #node[i] > 0 then
						expand(node[i])
					end
				end
			end

			for i = 1,#sList do
				expand(sList[i])
			end

			Explorer.ForceUpdate()
		end})

		context:Register("CLEAR_SEARCH_AND_JUMP_TO",{Name = "Clear Search and Jump to", OnClick = function()
			local newSelection = {}
			local count = 1
			local sList = selection.List

			for i = 1,#sList do
				newSelection[count] = sList[i]
				count = count + 1
			end

			selection:SetTable(newSelection)
			Explorer.ClearSearch()
			if #newSelection > 0 then
				Explorer.ViewNode(newSelection[1])
			end
		end})

		-- this code is very bad but im lazy and it works so cope
		local clth = function(str)
			if str:sub(1, 28) == "game:GetService(\"Workspace\")" then str = str:gsub("game:GetService%(\"Workspace\"%)", "workspace", 1) end
			if str:sub(1, 27 + #plr.Name) == "game:GetService(\"Players\")." .. plr.Name then str = str:gsub("game:GetService%(\"Players\"%)." .. plr.Name, "game:GetService(\"Players\").LocalPlayer", 1) end
			return str
		end

		context:Register("COPY_PATH",{Name = "Copy Path", IconMap = Explorer.LegacyClassIcons, Icon = 50, OnClick = function()
			local sList = selection.List
			if #sList == 1 then
				env.setclipboard(clth(Explorer.GetInstancePath(sList[1].Obj)))
			elseif #sList > 1 then
				local resList = {"{"}
				local count = 2
				for i = 1,#sList do
					local path = "\t"..clth(Explorer.GetInstancePath(sList[i].Obj))..","
					if #path > 0 then
						resList[count] = path
						count = count+1
					end
				end
				resList[count] = "}"
				env.setclipboard(table.concat(resList,"\n"))
			end
		end})

		context:Register("INSERT_OBJECT",{Name = "Insert Object", IconMap = Explorer.MiscIcons, Icon = "InsertObject", OnClick = function()
			local mouse = Main.Mouse
			local x,y = Explorer.LastRightClickX or mouse.X, Explorer.LastRightClickY or mouse.Y
			Explorer.InsertObjectContext:Show(x,y)
		end})

		--[[context:Register("CALL_FUNCTION",{Name = "Call Function", IconMap = Explorer.ClassIcons, Icon = 66, OnClick = function()

		end})]]

		context:Register("SHOW_XREFS",{Name = "Show xrefs", IconMap = Explorer.MiscIcons, Icon = "Reference", DisabledIcon = "Empty", OnClick = function()
			local sList = selection.List
			if #sList == 0 then return end
			local target = sList[1].Obj

			local dbg = debug or {}
			local _getinfo = dbg.getinfo or dbg.info or getinfo
			local _getupvalues = dbg.getupvalues or getupvalues or getupvals
			local _getgc = getgc or get_gc_objects
			local _getconnections = getconnections or get_signal_cons
			local _getcallbackvalue = getcallbackvalue or getcallbackmember
			local _getreg = getreg or getregistry or (env and (env.getreg or env.getregistry))
			local _getstack = dbg.getstack or getstack
			local _getcallstack = dbg.getcallstack or getcallstack

			local _getallthreads = getallthreads or function()
				local threads, seen = {}, {}
				if not _getreg then
					return threads
				end

				local ok, reg = pcall(_getreg)
				if not ok or type(reg) ~= "table" then
					return threads
				end

				for _, v in pairs(reg) do
					if type(v) == "thread" and not seen[v] then
						seen[v] = true
						threads[#threads + 1] = v
					end
				end
				return threads
			end

			local _getloadedmodules = getloadedmodules or function()
				local modules = {}
				for _, desc in ipairs(game:GetDescendants()) do
					if desc:IsA("ModuleScript") then
						modules[#modules + 1] = desc
					end
				end
				return modules
			end

			local _getsenv = getsenv or function(scriptObj)
				if not _getreg then
					return {}
				end

				local ok, reg = pcall(_getreg)
				if not ok or type(reg) ~= "table" then
					return {}
				end

				for _, v in pairs(reg) do
					if type(v) == "table" and rawget(v, "script") == scriptObj then
						return v
					end
				end

				return {}
			end

			local _getscriptfromthread = getscriptfromthread or function(threadObj)
				if not _getinfo then
					return nil
				end

				local ok, info = pcall(_getinfo, threadObj, 1, "s")
				if ok and info and info.source then
					local path = tostring(info.source):gsub("^@?", "")
					local ok2, result = pcall(function()
						return game:FindFirstChild(path, true)
					end)

					if ok2 and result and result:IsA("LuaSourceContainer") then
						return result
					end
				end

				return nil
			end

			local inspector
			do
				local okEnv, genv = pcall(getgenv)
				if okEnv and type(genv) == "table" then
					inspector = rawget(genv, "__DEX_TABLE_INSPECTOR")
				end

				if not inspector then
					local loader = loadfile or dofile or (env and (env.loadfile or env.dofile))
					local hasFile = isfile or (env and env.isfile)

					if loader and hasFile then
						local okFile, exists = pcall(hasFile, "table_inspector_src.lua")
						if okFile and exists then
							local okLoad, loaded = pcall(loader, "table_inspector_src.lua")
							if okLoad then
								if type(loaded) == "table" then
									inspector = loaded
								elseif type(loaded) == "function" then
									local okRun, result = pcall(loaded)
									if okRun and type(result) == "table" then
										inspector = result
									end
								end
							end
						end
					end
				end

				if inspector then
					pcall(function()
						local genv = getgenv()
						if type(genv) == "table" then
							rawset(genv, "__DEX_TABLE_INSPECTOR", inspector)
						end
					end)
				end
			end

			local window = Lib.Window.new()
			window:SetTitle("Xrefs: " .. tostring(target) .. " (scanning...)")
			window:Resize(520, 360)
			window.MinX = 280
			window.MinY = 140

			local content = window.GuiElems.Content

			local statusLabel = createSimple("TextLabel", {
				Parent = content,
				BackgroundColor3 = Color3.fromRGB(35, 35, 35),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 1),
				Size = UDim2.new(1, 0, 0, 20),
				Font = Enum.Font.SourceSans,
				Text = "  Scanning...",
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local copyBtn = createSimple("TextButton", {
				Parent = statusLabel,
				BackgroundColor3 = Color3.fromRGB(60, 60, 60),
				BorderSizePixel = 0,
				Position = UDim2.new(1, -58, 0, 2),
				Size = UDim2.new(0, 55, 0, 16),
				Font = Enum.Font.SourceSans,
				Text = "Copy All",
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextSize = 12,
				AutoButtonColor = false
			})
			Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 3)
			Lib.ButtonAnim(copyBtn, {Mode = 2})

			local dumpBtn
			if inspector and env.setclipboard then
				dumpBtn = createSimple("TextButton", {
					Parent = statusLabel,
					BackgroundColor3 = Color3.fromRGB(60, 60, 60),
					BorderSizePixel = 0,
					Position = UDim2.new(1, -135, 0, 2),
					Size = UDim2.new(0, 74, 0, 16),
					Font = Enum.Font.SourceSans,
					Text = "Dump table",
					TextColor3 = Color3.fromRGB(200, 200, 200),
					TextSize = 12,
					AutoButtonColor = false
				})
				Instance.new("UICorner", dumpBtn).CornerRadius = UDim.new(0, 3)
				Lib.ButtonAnim(dumpBtn, {Mode = 2})
			end

			local cfgFrame = createSimple("Frame", {
				Parent = content,
				BackgroundColor3 = Color3.fromRGB(28, 28, 28),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 22),
				Size = UDim2.new(1, 0, 0, 128)
			})

			local cfgLabel = createSimple("TextLabel", {
				Parent = cfgFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 6, 0, 4),
				Size = UDim2.new(1, -12, 1, -8),
				Font = Enum.Font.Code,
				Text = "Retention chain\n  (building...)",
				TextColor3 = Color3.fromRGB(180, 210, 255),
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			})

			local scrollFrame = createSimple("ScrollingFrame", {
				Parent = content,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 152),
				Size = UDim2.new(1, 0, 1, -152),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 5,
				ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80),
				ClipsDescendants = true
			})
			Instance.new("UIListLayout", scrollFrame).SortOrder = Enum.SortOrder.LayoutOrder

			window:ShowAndFocus()

			local mDepth = 4
			local howmuch = 12000
			local cDepth = 6
			local cLimit = 32

			local resultBuffer = {}
			local resultSeen = {}
			local copyLines = {}
			local resultCount = 0
			local rendered = 0
			local scanning = true
			local renderPerFrame = 12
			local rankedChains = {}
			local weakTableCandidate = nil
			local chainCache = {}
			local topIter = 0
			local renderCon

			local function topYield()
				topIter = topIter + 1
				if topIter % 50 == 0 then
					task.wait()
				end
			end

			local function safePath(inst)
				if typeof(inst) ~= "Instance" then
					return tostring(inst)
				end

				local ok, path = pcall(Explorer.GetInstancePath, inst)
				if ok and path then
					return path
				end

				local ok2, fullName = pcall(inst.GetFullName, inst)
				return ok2 and fullName or tostring(inst)
			end

			local function getFnInfo(fn)
				if not _getinfo then
					return nil
				end

				local ok, info = pcall(_getinfo, fn, "Snl")
				if ok and info then
					local src = info.short_src or info.source or "?"
					local line = info.linedefined or info.currentline or "?"
					return {
						Display = src .. ":" .. tostring(line),
						ShortSource = src,
						Source = info.source,
						Line = line,
						Name = info.name
					}
				end

				return nil
			end

			local function inferScriptFromFunction(fn)
				local ok, fenv = pcall(getfenv, fn)
				if ok and type(fenv) == "table" then
					local scr = rawget(fenv, "script")
					if typeof(scr) == "Instance" and scr:IsA("LuaSourceContainer") then
						return scr, "fenv.script"
					end
				end

				local info = getFnInfo(fn)
				local rawSource = info and info.Source
				if rawSource and rawSource ~= "=[C]" then
					local sourcePath = tostring(rawSource):gsub("^@?", "")
					local ok2, found = pcall(function()
						return game:FindFirstChild(sourcePath, true)
					end)
					if ok2 and found and found:IsA("LuaSourceContainer") then
						return found, "debug.info"
					end
				end

				return nil, nil
			end

			local function inferScriptFromTable(tbl)
				if type(tbl) ~= "table" then
					return nil, nil
				end

				local candidates = {"script", "Script", "__script", "_script"}

				for _, key in ipairs(candidates) do
					local scr = rawget(tbl, key)
					if typeof(scr) == "Instance" and scr:IsA("LuaSourceContainer") then
						return scr, "table." .. key
					end
				end

				local okMt, mt = pcall(getmetatable, tbl)
				if okMt and type(mt) == "table" then
					for _, key in ipairs(candidates) do
						local scr = rawget(mt, key)
						if typeof(scr) == "Instance" and scr:IsA("LuaSourceContainer") then
							return scr, "metatable." .. key
						end
					end
				end

				return nil, nil
			end

			local function labelForFunction(fn, info, scriptObj)
				local label = "function " .. ((info and info.Display) or tostring(fn))
				if scriptObj then
					label = label .. " @ " .. safePath(scriptObj)
				end
				return label
			end

			local function labelForTable(tbl, scriptObj)
				if scriptObj then
					return "table @ " .. safePath(scriptObj)
				end
				return "table " .. tostring(tbl)
			end

			local function labelForThread(threadObj, scriptObj)
				if scriptObj then
					return "thread @ " .. safePath(scriptObj)
				end
				return "thread " .. tostring(threadObj)
			end

			local function getHolderId(holder)
				if holder == nil then
					return "nil"
				end

				local holderType = type(holder)
				if holderType == "table" or holderType == "function" or holderType == "thread" or holderType == "userdata" then
					return holderType .. ":" .. tostring(holder)
				end

				return typeof(holder) .. ":" .. tostring(holder)
			end

			local function makeStep(kind, holder, edge, label, score, rootScript, funcInfo)
				return {
					Kind = kind,
					Holder = holder,
					Edge = edge,
					Label = label,
					Score = score or 0,
					RootScript = rootScript,
					FuncInfo = funcInfo
				}
			end

			local function addResult(source, path, value, holder, seedSteps, baseScore, weakReason)
				local key = tostring(source) .. "|" .. tostring(path) .. "|" .. getHolderId(holder or value)
				if resultSeen[key] then
					return
				end

				resultSeen[key] = true
				resultCount = resultCount + 1
				resultBuffer[resultCount] = {
					Source = source,
					Path = path,
					Value = value,
					Holder = holder,
					SeedSteps = seedSteps or {},
					BaseScore = baseScore or 0,
					WeakReason = weakReason
				}
			end

			local function scanValue(val, source, path, depth, ownerScript, ownerHint, visited, budget)
				if budget.count >= howmuch then
					return
				end

				if depth > mDepth then
					return
				end

				if type(val) == "table" then
					if visited[val] then
						return
					end
					visited[val] = true

					for k, v in pairs(val) do
						budget.count = budget.count + 1
						if budget.count >= howmuch then
							break
						end

						local kStr = tostring(k)

						if v == target then
							local tableScript = select(1, inferScriptFromTable(val))
							addResult(
								source,
								path .. "[" .. kStr .. "]",
								target,
								val,
								{
									makeStep(
										tableScript and "table-script" or "table-value",
										val,
										"[" .. kStr .. "]",
										labelForTable(val, tableScript),
										tableScript and 88 or 54,
										tableScript,
										nil
									)
								},
								tableScript and 88 or 54,
								tableScript and nil or "anonymous table"
							)
						elseif type(v) == "table" then
							scanValue(v, source, path .. "[" .. kStr .. "]", depth + 1, ownerScript, ownerHint, visited, budget)
						elseif type(v) == "function" and _getupvalues then
							local okUps, ups = pcall(_getupvalues, v)
							if okUps and type(ups) == "table" then
								local fnInfo = getFnInfo(v)
								local fnScript = select(1, inferScriptFromFunction(v))
								for ui, uv in pairs(ups) do
									if uv == target then
										addResult(
											source,
											path .. "[" .. kStr .. "].upval[" .. ui .. "]",
											target,
											v,
											{
												makeStep(
													"function-upvalue",
													v,
													"upval[" .. ui .. "]",
													labelForFunction(v, fnInfo, fnScript),
													112,
													fnScript,
													fnInfo
												)
											},
											112,
											nil
										)
									end
								end
							end
						end

						if k == target then
							local tableScript = select(1, inferScriptFromTable(val))
							addResult(
								source,
								path .. ".<key>",
								target,
								val,
								{
									makeStep(
										tableScript and "table-script" or "table-key",
										val,
										".<key>",
										labelForTable(val, tableScript),
										tableScript and 84 or 48,
										tableScript,
										nil
									)
								},
								tableScript and 84 or 48,
								tableScript and nil or "anonymous table"
							)
						end
					end
				elseif type(val) == "function" and _getupvalues then
					if visited[val] then
						return
					end
					visited[val] = true

					local okUps, ups = pcall(_getupvalues, val)
					if okUps and type(ups) == "table" then
						local fnInfo = getFnInfo(val)
						local fnScript = select(1, inferScriptFromFunction(val))

						for ui, uv in pairs(ups) do
							budget.count = budget.count + 1
							if budget.count >= howmuch then
								break
							end

							if uv == target then
								addResult(
									source,
									path .. ".upval[" .. ui .. "]",
									target,
									val,
									{
										makeStep(
											"function-upvalue",
											val,
											"upval[" .. ui .. "]",
											labelForFunction(val, fnInfo, fnScript),
											112,
											fnScript,
											fnInfo
										)
									},
									112,
									nil
								)
							elseif type(uv) == "table" then
								scanValue(uv, source, path .. ".upval[" .. ui .. "]", depth + 1, fnScript or ownerScript, ownerHint, visited, budget)
							end
						end
					end
				end
			end

			local function scanThreadStack(threadObj, ti, threadScript)
				if not (_getstack or _getcallstack) then
					return
				end

				local function pushStackHit(frameLabel, localName, frameInfo)
					local label

					if frameInfo and frameInfo.Display then
						label = "function " .. frameInfo.Display
					else
						label = "stack frame " .. tostring(frameLabel)
					end

					if threadScript then
						label = label .. " @ " .. safePath(threadScript)
					end

					addResult(
						"thread-stack",
						"thread[" .. ti .. "].stack[" .. tostring(frameLabel) .. "].local[" .. tostring(localName) .. "]",
						target,
						threadObj,
						{
							makeStep(
								"thread-stack-local",
								nil,
								"local[" .. tostring(localName) .. "]",
								label,
								320,
								threadScript,
								frameInfo
							)
						},
						320,
						nil
					)
				end

				pcall(function()
					local frameReader = _getcallstack or _getstack
					local okFrames, frames = pcall(frameReader, threadObj)

					if okFrames and type(frames) == "table" then
						for level, frame in pairs(frames) do
							local frameLocals = frame
							local frameInfo = nil

							if type(frame) == "table" then
								local fn =
									rawget(frame, "func") or
									rawget(frame, "closure") or
									rawget(frame, "fn") or
									rawget(frame, "function")

								if type(fn) == "function" then
									frameInfo = getFnInfo(fn)
								end

								frameLocals =
									rawget(frame, "locals") or
									rawget(frame, "stack") or
									rawget(frame, "values") or
									frame
							end

							if type(frameLocals) == "table" then
								for localName, localValue in pairs(frameLocals) do
									if localValue == target then
										pushStackHit(level, localName, frameInfo)
									end
								end
							end
						end

						return
					end

					if _getstack then
						for level = 0, 20 do
							local okLevel, frameLocals = pcall(_getstack, threadObj, level)
							if not okLevel or type(frameLocals) ~= "table" then
								break
							end

							for localName, localValue in pairs(frameLocals) do
								if localValue == target then
									pushStackHit(level, localName, nil)
								end
							end
						end
					end
				end)
			end

			local function getSignalCandidates(obj)
				local out = {}

				local function add(name)
					local ok, signal = pcall(function()
						return obj[name]
					end)
					if ok and signal ~= nil then
						out[#out + 1] = {
							Name = name,
							Signal = signal
						}
					end
				end

				add("Changed")
				add("ChildAdded")
				add("ChildRemoved")
				add("AncestryChanged")
				add("Destroying")
				add("DescendantAdded")
				add("DescendantRemoving")

				if typeof(obj) == "Instance" then
					if obj:IsA("RemoteEvent") then
						add("OnClientEvent")
					end
					if obj:IsA("BindableEvent") then
						add("Event")
					end
				end

				return out
			end

			local function getDirectRetainers(node)
				local cacheKey = getHolderId(node)
				local cached = chainCache[cacheKey]
				if cached then
					return cached
				end

				local found = {}
				local seen = {}

				local function push(step)
					local key = step.Kind .. "|" .. getHolderId(step.Holder) .. "|" .. tostring(step.Edge)
					if not seen[key] then
						seen[key] = true
						found[#found + 1] = step
					end
				end

				if filtergc then
					pcall(function()
						local tbls = filtergc("table", { Values = {node} })
						for _, tbl in ipairs(tbls) do
							for k, v in pairs(tbl) do
								if v == node then
									local tableScript = select(1, inferScriptFromTable(tbl))
									push(makeStep(
										tableScript and "table-script" or "table-value",
										tbl,
										"[" .. tostring(k) .. "]",
										labelForTable(tbl, tableScript),
										tableScript and 88 or 54,
										tableScript,
										nil
									))
									break
								end
							end
							if #found >= cLimit then break end
						end
					end)

					pcall(function()
						local tbls = filtergc("table", { Keys = {node} })
						for _, tbl in ipairs(tbls) do
							for k, _ in pairs(tbl) do
								if k == node then
									local tableScript = select(1, inferScriptFromTable(tbl))
									push(makeStep(
										tableScript and "table-script" or "table-key",
										tbl,
										".<key>",
										labelForTable(tbl, tableScript),
										tableScript and 84 or 48,
										tableScript,
										nil
									))
									break
								end
							end
							if #found >= cLimit then break end
						end
					end)

					if _getupvalues then
						pcall(function()
							local fns = filtergc("function", { Upvalues = {node} })
							for _, fn in ipairs(fns) do
								local okUps, ups = pcall(_getupvalues, fn)
								if okUps and type(ups) == "table" then
									local fnInfo = getFnInfo(fn)
									local fnScript = select(1, inferScriptFromFunction(fn))
									for ui, uv in pairs(ups) do
										if uv == node then
											push(makeStep(
												"function-upvalue",
												fn,
												"upval[" .. ui .. "]",
												labelForFunction(fn, fnInfo, fnScript),
												112,
												fnScript,
												fnInfo
											))
											break
										end
									end
								end
								if #found >= cLimit then break end
							end
						end)
					end
				end

				pcall(function()
					local threads = _getallthreads()
					for _, threadObj in ipairs(threads) do
						local okEnv, tEnv = pcall(getfenv, threadObj)
						if okEnv and type(tEnv) == "table" then
							local threadScript = _getscriptfromthread(threadObj)
							for k, v in pairs(tEnv) do
								if v == node then
									push(makeStep(
										"thread-env",
										threadObj,
										"env[" .. tostring(k) .. "]",
										threadScript and ("thread env @ " .. safePath(threadScript)) or labelForThread(threadObj, nil),
										118,
										threadScript,
										nil
									))
									break
								elseif k == node then
									push(makeStep(
										"thread-env",
										threadObj,
										"env.<key>",
										threadScript and ("thread env @ " .. safePath(threadScript)) or labelForThread(threadObj, nil),
										114,
										threadScript,
										nil
									))
									break
								end
							end
						end
						if #found >= cLimit then break end
					end
				end)

				pcall(function()
					local modules = _getloadedmodules()
					for _, mod in ipairs(modules) do
						local okEnv, senv = pcall(_getsenv, mod)
						if okEnv and type(senv) == "table" then
							for k, v in pairs(senv) do
								if v == node then
									push(makeStep(
										"module-env",
										mod,
										"env[" .. tostring(k) .. "]",
										"module env @ " .. safePath(mod),
										116,
										mod,
										nil
									))
									break
								elseif k == node then
									push(makeStep(
										"module-env",
										mod,
										"env.<key>",
										"module env @ " .. safePath(mod),
										112,
										mod,
										nil
									))
									break
								end
							end
						end
						if #found >= cLimit then break end
					end
				end)

				table.sort(found, function(a, b)
					if a.Score ~= b.Score then
						return a.Score > b.Score
					end
					return tostring(a.Edge) < tostring(b.Edge)
				end)

				chainCache[cacheKey] = found
				return found
			end

			local function confidenceFor(score)
				if score >= 280 then
					return "high"
				elseif score >= 170 then
					return "medium"
				end
				return "low"
			end

			local function buildRetentionChain(res)
				if not res or not res.SeedSteps or #res.SeedSteps == 0 then
					return nil, 0, nil
				end

				local steps = {}
				for i = 1, #res.SeedSteps do
					steps[i] = res.SeedSteps[i]
				end

				local score = res.BaseScore or 0
				local seen = {}
				local tail = steps[#steps] and steps[#steps].Holder or nil
				if tail then
					seen[getHolderId(tail)] = true
				end

				local depth = 0
				while tail and depth < cDepth do
					local holderType = type(tail)
					if holderType ~= "table" and holderType ~= "function" and holderType ~= "thread" then
						break
					end

					local retainers = getDirectRetainers(tail)
					local nextStep = nil

					for _, cand in ipairs(retainers) do
						local id = getHolderId(cand.Holder)
						if not seen[id] then
							nextStep = cand
							break
						end
					end

					if not nextStep then
						break
					end

					steps[#steps + 1] = nextStep
					score = score + (nextStep.Score or 0)
					seen[getHolderId(nextStep.Holder)] = true
					tail = nextStep.Holder
					depth = depth + 1
				end

				local lines = {safePath(target)}
				local firstAnonymousTable = nil

				for _, step in ipairs(steps) do
					lines[#lines + 1] = "  <- " .. tostring(step.Edge) .. " in " .. tostring(step.Label)
					if not firstAnonymousTable and type(step.Holder) == "table" and not step.RootScript then
						firstAnonymousTable = step.Holder
					end
				end

				return table.concat(lines, "\n"), score, firstAnonymousTable
			end

			local function rebuildSummaryText()
				table.clear(rankedChains)
				weakTableCandidate = nil

				if resultCount == 0 then
					return "Retention chain\n  (no live retainers found)"
				end

				local seenText = {}

				for i = 1, resultCount do
					local text, score, weakTable = buildRetentionChain(resultBuffer[i])
					if text and not seenText[text] then
						seenText[text] = true
						rankedChains[#rankedChains + 1] = {
							Text = text,
							Score = score,
							Confidence = confidenceFor(score),
							WeakTable = weakTable
						}
					end
				end

				if #rankedChains == 0 then
					return "Retention chain\n  (no live retainers found)"
				end

				table.sort(rankedChains, function(a, b)
					if a.Score ~= b.Score then
						return a.Score > b.Score
					end
					return a.Text < b.Text
				end)

				for i = 1, #rankedChains do
					if rankedChains[i].WeakTable then
						weakTableCandidate = rankedChains[i].WeakTable
						break
					end
				end

				local lines = {"Retention chain"}
				local maxChains = math.min(3, #rankedChains)

				for i = 1, maxChains do
					local item = rankedChains[i]
					lines[#lines + 1] = ("[%d] [%s]"):format(i, item.Confidence)
					for piece in string.gmatch(item.Text, "[^\n]+") do
						lines[#lines + 1] = "  " .. piece
					end
					if i < maxChains then
						lines[#lines + 1] = ""
					end
				end

				return table.concat(lines, "\n")
			end

			renderCon = game:GetService("RunService").Heartbeat:Connect(function()
				if not scrollFrame.Parent then
					renderCon:Disconnect()
					return
				end

				local batch = 0
				while rendered < resultCount and batch < renderPerFrame do
					rendered = rendered + 1
					batch = batch + 1

					local i = rendered
					local res = resultBuffer[i]
					local firstStep = res.SeedSteps and res.SeedSteps[1]
					local displayText = "[" .. tostring(res.Source) .. "] " .. tostring(res.Path)

					if firstStep and firstStep.Label then
						displayText = displayText .. "  <- " .. firstStep.Label
					end

					copyLines[i] = displayText

					local entry = createSimple("TextButton", {
						Parent = scrollFrame,
						BackgroundColor3 = (i % 2 == 0) and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(32, 32, 32),
						BackgroundTransparency = 0,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 20),
						Font = Enum.Font.Code,
						Text = "  " .. displayText,
						TextColor3 = Color3.fromRGB(190, 190, 190),
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutoButtonColor = false,
						LayoutOrder = i,
						TextTruncate = Enum.TextTruncate.AtEnd
					})

					entry.MouseEnter:Connect(function()
						entry.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
					end)
					entry.MouseLeave:Connect(function()
						entry.BackgroundColor3 = (i % 2 == 0) and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(32, 32, 32)
					end)
				end

				if batch > 0 then
					scrollFrame.CanvasSize = UDim2.new(0, 0, 0, rendered * 20)
					statusLabel.Text = "  " .. rendered .. " xref(s)" .. (scanning and " (scanning...)" or "")
				end

				if not scanning and rendered >= resultCount then
					statusLabel.Text = "  " .. resultCount .. " xref(s)"
					window:SetTitle("Xrefs: " .. tostring(target))
					renderCon:Disconnect()
				end
			end)

			task.spawn(function()
				if filtergc then
					pcall(function()
						local tbls = filtergc("table", { Keys = {target} })
						for i, tbl in ipairs(tbls) do
							for k, _ in pairs(tbl) do
								if k == target then
									local tableScript = select(1, inferScriptFromTable(tbl))
									addResult(
										"filtergc",
										"table[" .. i .. "].<key>",
										target,
										tbl,
										{
											makeStep(
												tableScript and "table-script" or "table-key",
												tbl,
												".<key>",
												labelForTable(tbl, tableScript),
												tableScript and 84 or 48,
												tableScript,
												nil
											)
										},
										tableScript and 84 or 48,
										tableScript and nil or "anonymous table"
									)
									break
								end
							end
							topYield()
						end
					end)
					task.wait()

					pcall(function()
						local tbls = filtergc("table", { Values = {target} })
						for i, tbl in ipairs(tbls) do
							for k, v in pairs(tbl) do
								if v == target then
									local tableScript = select(1, inferScriptFromTable(tbl))
									addResult(
										"filtergc",
										"table[" .. i .. "][" .. tostring(k) .. "]",
										target,
										tbl,
										{
											makeStep(
												tableScript and "table-script" or "table-value",
												tbl,
												"[" .. tostring(k) .. "]",
												labelForTable(tbl, tableScript),
												tableScript and 88 or 54,
												tableScript,
												nil
											)
										},
										tableScript and 88 or 54,
										tableScript and nil or "anonymous table"
									)
									break
								end
							end
							topYield()
						end
					end)
					task.wait()

					if _getupvalues then
						pcall(function()
							local fns = filtergc("function", { Upvalues = {target} })
							for i, fn in ipairs(fns) do
								local okUps, ups = pcall(_getupvalues, fn)
								if okUps and type(ups) == "table" then
									local fnInfo = getFnInfo(fn)
									local fnScript = select(1, inferScriptFromFunction(fn))
									for ui, uv in pairs(ups) do
										if uv == target then
											addResult(
												"filtergc",
												"function[" .. i .. "].upval[" .. ui .. "]",
												target,
												fn,
												{
													makeStep(
														"function-upvalue",
														fn,
														"upval[" .. ui .. "]",
														labelForFunction(fn, fnInfo, fnScript),
														112,
														fnScript,
														fnInfo
													)
												},
												112,
												nil
											)
											break
										end
									end
								end
								topYield()
							end
						end)
						task.wait()
					end
				elseif _getgc then
					pcall(function()
						local gc = _getgc(true)
						if type(gc) == "table" then
							for i, v in ipairs(gc) do
								local visited = {}
								local budget = {count = 0}
								scanValue(v, "getgc", "gc[" .. i .. "]", 0, nil, "gc[" .. i .. "]", visited, budget)
								topYield()
							end
						end
					end)
					task.wait()
				end

				if _getconnections then
					local signalCandidates = getSignalCandidates(target)
					for _, sigData in ipairs(signalCandidates) do
						pcall(function()
							local conns = _getconnections(sigData.Signal)
							if type(conns) == "table" then
								for ci, conn in ipairs(conns) do
									local fn
									pcall(function() fn = conn.Function end)
									if type(fn) ~= "function" then
										pcall(function() fn = conn.Callback end)
									end

									if type(fn) == "function" then
										local fnInfo = getFnInfo(fn)
										local fnScript = select(1, inferScriptFromFunction(fn))
										local connScore = (sigData.Name == "OnClientEvent") and 155 or 138

										addResult(
											"connection",
											"signal." .. sigData.Name .. "[" .. ci .. "]",
											fn,
											fn,
											{
												makeStep(
													"signal-connection",
													fn,
													"signal." .. sigData.Name .. " connection[" .. ci .. "]",
													labelForFunction(fn, fnInfo, fnScript),
													connScore,
													fnScript,
													fnInfo
												)
											},
											connScore,
											nil
										)
									end
								end
							end
						end)
					end
				end
				task.wait()

				pcall(function()
					local threads = _getallthreads()
					for ti, threadObj in ipairs(threads) do
						local threadScript = _getscriptfromthread(threadObj)

						local okEnv, tEnv = pcall(getfenv, threadObj)
						if okEnv and type(tEnv) == "table" then
							local visited = {}
							local budget = {count = 0}
							scanValue(tEnv, "thread", "thread[" .. ti .. "].env", 0, threadScript, threadScript and safePath(threadScript) or ("thread[" .. ti .. "]"), visited, budget)
						end

						scanThreadStack(threadObj, ti, threadScript)
						topYield()
					end
				end)
				task.wait()

				pcall(function()
					local modules = _getloadedmodules()
					for _, mod in ipairs(modules) do
						pcall(function()
							local senv = _getsenv(mod)
							if type(senv) == "table" then
								local visited = {}
								local budget = {count = 0}
								scanValue(senv, "module", safePath(mod) .. ".env", 0, mod, safePath(mod), visited, budget)
							end
						end)
						topYield()
					end
				end)
				task.wait()

				if _getcallbackvalue then
					pcall(function()
						local cbNames = {"OnInvoke", "OnServerInvoke", "OnClientInvoke"}
						for _, cbName in ipairs(cbNames) do
							pcall(function()
								local cb = _getcallbackvalue(target, cbName)
								if type(cb) == "function" then
									local cbInfo = getFnInfo(cb)
									local cbScript = select(1, inferScriptFromFunction(cb))
									addResult(
										"callback",
										cbName,
										cb,
										cb,
										{
											makeStep(
												"callback-slot",
												cb,
												"callback." .. cbName,
												labelForFunction(cb, cbInfo, cbScript),
												126,
												cbScript,
												cbInfo
											)
										},
										126,
										nil
									)
								end
							end)
						end
					end)
				end

				local okSummary, summaryText = pcall(rebuildSummaryText)
				cfgLabel.Text = okSummary and summaryText or "Retention chain\n  (failed to build chain summary)"

				if dumpBtn then
					if weakTableCandidate then
						dumpBtn.Text = "Dump table"
					else
						dumpBtn.Text = "No table"
					end
				end

				scanning = false
			end)

			copyBtn.MouseButton1Click:Connect(function()
				if env.setclipboard then
					local raw = table.concat(copyLines, "\n")
					local payload = cfgLabel.Text or "Retention chain\n  (unavailable)"
					if raw ~= "" then
						payload = payload .. "\n\nRaw xrefs\n" .. raw
					end

					env.setclipboard(payload)
					copyBtn.Text = "Copied!"
					task.delay(1.5, function()
						pcall(function()
							copyBtn.Text = "Copy All"
						end)
					end)
				end
			end)

			if dumpBtn then
				dumpBtn.MouseButton1Click:Connect(function()
					if not weakTableCandidate then
						dumpBtn.Text = "No table"
						task.delay(1.2, function()
							pcall(function()
								dumpBtn.Text = "Dump table"
							end)
						end)
						return
					end

					local ok = pcall(function()
						if inspector.copy then
							inspector.copy(weakTableCandidate, {
								depth = 10,
								sortkeys = true,
								showmt = true,
								maxstringlen = 1000
							})
						elseif inspector.save then
							local _, dumped = inspector.save(weakTableCandidate, "xref_holder", {
								depth = 10,
								sortkeys = true,
								showmt = true,
								maxstringlen = 1000
							})
							if dumped and env.setclipboard then
								env.setclipboard(dumped)
							end
						end
					end)

					dumpBtn.Text = ok and "Dumped!" or "Dump failed"
					task.delay(1.5, function()
						pcall(function()
							dumpBtn.Text = weakTableCandidate and "Dump table" or "No table"
						end)
					end)
				end)
			end
		end})

		context:Register("SAVE_INST",{Name = "Save to File", IconMap = Explorer.MiscIcons, Icon = "Save", OnClick = function()
			local sList = selection.List
			if #sList == 1 then
				Lib.SaveAsPrompt("Place_"..game.PlaceId.."_"..sList[1].Obj.ClassName.."_"..sList[1].Obj.Name.."_"..os.time(), function(filename)
					env.saveinstance(sList[1].Obj, filename, {
						Decompile = true,
						RemovePlayerCharacters = false
					})
				end)
			elseif #sList > 1 then
				for i = 1,#sList do
					-- sList[i].Obj.Name.." ("..sList[1].Obj.ClassName..")"
					-- "Place_"..game.PlaceId.."_"..sList[1].Obj.ClassName.."_"..sList[i].Obj.Name.."_"..os.time()
					Lib.SaveAsPrompt("Place_"..game.PlaceId.."_"..sList[i].Obj.ClassName.."_"..sList[i].Obj.Name.."_"..os.time(), function(filename)
						env.saveinstance(sList[i].Obj, filename, {
							Decompile = true,
							RemovePlayerCharacters = false
						})
					end)
					
					task.wait(0.1)
				end
			end
		end})

        --[[context:Register("VIEW_CONNECTIONS",{Name = "View Connections", OnClick = function()
            
        end})]]
		local ClassFire = {
			RemoteEvent = "FireServer",
			RemoteFunction = "InvokeServer",
			UnreliableRemoteEvent = "FireServer",

			BindableRemote = "Fire",
			BindableFunction = "Invoke",
		}
		context:Register("BLOCK_REMOTE",{Name = "Block From Firing", IconMap = Explorer.MiscIcons, Icon = "Delete", DisabledIcon = "Empty", OnClick = function()
			local sList = selection.List
			for i, list in sList do
				local obj = list.Obj
				if not remote_blocklist[obj] then
					local functionToHook = ClassFire[obj.ClassName]
					remote_blocklist[obj] = true
					local old; old = env.hookmetamethod((oldgame or game), "__namecall", function(self, ...)
						if remote_blocklist[obj] and self == obj and getnamecallmethod() == functionToHook then
							return nil
						end
						return old(self,...)
					end)
					if Settings.RemoteBlockWriteAttribute then
						obj:SetAttribute("IsBlocked", true)
					end
					--print("blocking ",functionToHook)
				end
			end
		end})
		
		context:Register("UNBLOCK_REMOTE",{Name = "Unblock", IconMap = Explorer.MiscIcons, Icon = "Play", DisabledIcon = "Empty", OnClick = function()
			local sList = selection.List
			for i, list in sList do
				local obj = list.Obj
				if remote_blocklist[obj] then
					remote_blocklist[obj] = nil
					if Settings.RemoteBlockWriteAttribute then
						list.Obj:SetAttribute("IsBlocked", false)
					end
					--print("unblocking ",functionToHook)
				end
			end
		end})

		context:Register("COPY_API_PAGE",{Name = "Copy Roblox API Page URL", IconMap = Explorer.MiscIcons, Icon = "Reference", OnClick = function()
			local sList = selection.List
			if #sList == 1 then
				env.setclipboard(
					"https://create.roblox.com/docs/reference/engine/classes/"..sList[1].Obj.ClassName
				)
			end
		end})

		context:Register("3DVIEW_MODEL",{Name = "3D Preview Object", IconMap = Explorer.LegacyClassIcons, Icon = 54, OnClick = function()
			local sList = selection.List
			local isa = game.IsA
			
			if #sList == 1 then
				if isa(sList[1].Obj,"BasePart") or isa(sList[1].Obj,"Model") then
					ModelViewer.ViewModel(sList[1].Obj)
					return
				end
			end
		end})
		
		context:Register("VIEW_OBJECT",{Name = "View Object (Right click to reset)", IconMap = Explorer.LegacyClassIcons, Icon = 5, OnClick = function()
			local sList = selection.List
			local isa = game.IsA

			for i = 1,#sList do
				local node = sList[i]

				if isa(node.Obj,"BasePart") or isa(node.Obj,"Model") then
					workspace.CurrentCamera.CameraSubject = node.Obj
					break
				end
			end
		end, OnRightClick = function()
			workspace.CurrentCamera.CameraSubject = plr.Character
		end})

		context:Register("VIEW_SCRIPT",{Name = "View Script", IconMap = Explorer.MiscIcons, Icon = "ViewScript", DisabledIcon = "Empty", OnClick = function()
			local scr = selection.List[1] and selection.List[1].Obj
			if scr then ScriptViewer.ViewScript(scr) end
		end})
		context:Register("DUMP_FUNCTIONS",{Name = "Dump Functions", IconMap = Explorer.MiscIcons, Icon = "SelectChildren", DisabledIcon = "Empty", OnClick = function()
			local scr = selection.List[1] and selection.List[1].Obj
			if scr then ScriptViewer.DumpFunctions(scr) end
		end})

		context:Register("FIRE_TOUCHTRANSMITTER",{Name = "Fire TouchTransmitter", OnClick = function()
			local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			for _, v in ipairs(selection.List) do if v.Obj and v.Obj:IsA("TouchTransmitter") then firetouchinterest(hrp, v.Obj.Parent, 0) end end
		end})

		context:Register("FIRE_CLICKDETECTOR",{Name = "Fire ClickDetector", OnClick = function()
			local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			for _, v in ipairs(selection.List) do if v.Obj and v.Obj:IsA("ClickDetector") then fireclickdetector(v.Obj) end end
		end})

		context:Register("FIRE_PROXIMITYPROMPT",{Name = "Fire ProximityPrompt", OnClick = function()
			local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			for _, v in ipairs(selection.List) do if v.Obj and v.Obj:IsA("ProximityPrompt") then fireproximityprompt(v.Obj) end end
		end})

		context:Register("VIEW_SCRIPT",{Name = "View Script", IconMap = Explorer.MiscIcons, Icon = "ViewScript", DisabledIcon = "Empty", OnClick = function()
			local scr = selection.List[1] and selection.List[1].Obj
			if scr then ScriptViewer.ViewScript(scr) end
		end})

		context:Register("SAVE_SCRIPT",{Name = "Save Script", IconMap = Explorer.MiscIcons, Icon = "Save", DisabledIcon = "Empty", OnClick = function()
			for _, v in next, selection.List do
				if v.Obj:IsA("LuaSourceContainer") and env.isViableDecompileScript(v.Obj) then
					local success, source = pcall(env.decompile, v.Obj)
					if not success or not source then source = ("-- DEX - %s failed to decompile %s"):format(env.executor, v.Obj.ClassName) end
					local fileName = ("%s_%s_%i_Source.txt"):format(env.parsefile(v.Obj.Name), v.Obj.ClassName, game.PlaceId)
					--env.writefile(fileName, source)
					Lib.SaveAsPrompt(fileName, source)
					
					task.wait(0.2)
				end
			end
		end})

		context:Register("SAVE_BYTECODE",{Name = "Save Script Bytecode", IconMap = Explorer.MiscIcons, Icon = "Save", DisabledIcon = "Empty", OnClick = function()
			for _, v in next, selection.List do
				if v.Obj:IsA("LuaSourceContainer") and env.isViableDecompileScript(v.Obj) then
					local success, bytecode = pcall(env.getscriptbytecode, v.Obj)
					if success and type(bytecode) == "string" then
						local fileName = ("%s_%s_%i_Bytecode.txt"):format(env.parsefile(v.Obj.Name), v.Obj.ClassName, game.PlaceId)
						--env.writefile(fileName, bytecode)
						Lib.SaveAsPrompt(fileName, bytecode)
						task.wait(0.2)
					end
				end
			end
		end})

		context:Register("SELECT_CHARACTER",{Name = "Select Character", IconMap = Explorer.LegacyClassIcons, Icon = 9, OnClick = function()
			local newSelection = {}
			local count = 1
			local sList = selection.List
			local isa = game.IsA

			for i = 1,#sList do
				local node = sList[i]
				if isa(node.Obj,"Player") and nodes[node.Obj.Character] then
					newSelection[count] = nodes[node.Obj.Character]
					count = count + 1
				end
			end

			selection:SetTable(newSelection)
			if #newSelection > 0 then
				Explorer.ViewNode(newSelection[1])
			else
				Explorer.Refresh()
			end
		end})

		context:Register("VIEW_PLAYER",{Name = "View Player", IconMap = Explorer.LegacyClassIcons, Icon = 5, OnClick = function()
			local newSelection = {}
			local count = 1
			local sList = selection.List
			local isa = game.IsA

			for i = 1,#sList do
				local node = sList[i]
				local Obj = node.Obj
				if Obj:IsA("Player") and Obj.Character then
					workspace.CurrentCamera.CameraSubject = Obj.Character
					break
				end
			end
		end})

		context:Register("SELECT_LOCAL_PLAYER",{Name = "Select Local Player", IconMap = Explorer.LegacyClassIcons, Icon = 9, OnClick = function()
			pcall(function() if nodes[plr] then selection:Set(nodes[plr]) Explorer.ViewNode(nodes[plr]) end end)
		end})

		context:Register("SELECT_ALL_CHARACTERS",{Name = "Select All Characters", IconMap = Explorer.LegacyClassIcons, Icon = 2, OnClick = function()
			local newSelection = {}
			local sList = selection.List

			for i,v in next, service.Players:GetPlayers() do
				if v.Character and nodes[v.Character] then
					if i == 1 then Explorer.MakeNodeVisible(v.Character) end
					table.insert(newSelection, nodes[v.Character])
				end
			end

			selection:SetTable(newSelection)
			if #newSelection > 0 then
				Explorer.ViewNode(newSelection[1])
			else
				Explorer.Refresh()
			end
		end})

		context:Register("REFRESH_NIL",{Name = "Refresh Nil Instances", OnClick = function()
			Explorer.RefreshNilInstances()
		end})

		context:Register("HIDE_NIL",{Name = "Hide Nil Instances", OnClick = function()
			Explorer.HideNilInstances()
		end})

		Explorer.RightClickContext = context
	end

	Explorer.HideNilInstances = function()
		table.clear(nilMap)

		local disconnectCon = Instance.new("Folder").ChildAdded:Connect(function() end).Disconnect
		for i,v in next,nilCons do
			disconnectCon(v[1])
			disconnectCon(v[2])
		end
		table.clear(nilCons)

		for i = 1,#nilNode do
			coroutine.wrap(removeObject)(nilNode[i].Obj)
		end

		Explorer.Update()
		Explorer.Refresh()
	end

	Explorer.RefreshNilInstances = function()
		if not env.getnilinstances then return end

		local nilInsts = env.getnilinstances()
		local game = game
		local getDescs = game.GetDescendants
		--local newNilMap = {}
		--local newNilRoots = {}
		--local nilRoots = Explorer.NilRoots
		--local connect = game.DescendantAdded.Connect
		--local disconnect
		--if not nilRoots then nilRoots = {} Explorer.NilRoots = nilRoots end

		for i = 1,#nilInsts do
			local obj = nilInsts[i]
			if obj ~= game then
				nilMap[obj] = true
				--newNilRoots[obj] = true

				local descs = getDescs(obj)
				for j = 1,#descs do
					nilMap[descs[j]] = true
				end
			end
		end

		-- Remove unmapped nil nodes
		--[[for i = 1,#nilNode do
			local node = nilNode[i]
			if not newNilMap[node.Obj] then
				nilMap[node.Obj] = nil
				coroutine.wrap(removeObject)(node)
			end
		end]]

		--nilMap = newNilMap

		for i = 1,#nilInsts do
			local obj = nilInsts[i]
			local node = nodes[obj]
			if not node then coroutine.wrap(addObject)(obj) end
		end

		--[[
		-- Remove old root connections
		for obj in next,nilRoots do
			if not newNilRoots[obj] then
				if not disconnect then disconnect = obj[1].Disconnect end
				disconnect(obj[1])
				disconnect(obj[2])
			end
		end
		
		for obj in next,newNilRoots do
			if not nilRoots[obj] then
				nilRoots[obj] = {
					connect(obj.DescendantAdded,addObject),
					connect(obj.DescendantRemoving,removeObject)
				}
			end
		end]]

		--nilMap = newNilMap
		--Explorer.NilRoots = newNilRoots

		Explorer.Update()
		Explorer.Refresh()
	end

	Explorer.GetInstancePath = function(obj)
		local ffc = game.FindFirstChild
		local getCh = game.GetChildren
		local path = ""
		local curObj = obj
		local ts = tostring
		local match = string.match
		local gsub = string.gsub
		local tableFind = table.find
		local useGetCh = Settings.Explorer.CopyPathUseGetChildren
		local formatLuaString = Lib.FormatLuaString

		while curObj do
			if curObj == game then
				path = "game"..path
				break
			end

			local className = curObj.ClassName
			local curName = ts(curObj)
			local indexName
			if match(curName,"^[%a_][%w_]*$") then
				indexName = "."..curName
			else
				local cleanName = formatLuaString(curName)
				indexName = '["'..cleanName..'"]'
			end

			local parObj = curObj.Parent
			if parObj then
				local fc = ffc(parObj,curName)
				if useGetCh and fc and fc ~= curObj then
					local parCh = getCh(parObj)
					local fcInd = tableFind(parCh,curObj)
					indexName = ":GetChildren()["..fcInd.."]"
				elseif parObj == game and API.Classes[className] and API.Classes[className].Tags.Service then
					indexName = ':GetService("'..className..'")'
				end
			elseif parObj == nil then
				local getnil = "local getNil = function(name, class) for _, v in next, getnilinstances() do if v.ClassName == class and v.Name == name then return v end end end"
				local gotnil = "\n\ngetNil(\"%s\", \"%s\")"
				indexName = getnil .. gotnil:format(curObj.Name, className)
			end

			path = indexName..path
			curObj = parObj
		end

		return path
	end

	Explorer.DefaultProps = {
		["BasePart"] = {
			Position = function(Obj)
				local Player = service.Players.LocalPlayer
				if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
					Obj.Position = (Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)).p
				end
				return Obj.Position
			end,
			Anchored = true
		},
		["GuiObject"] = {
			Position = function(Obj) return (Obj.Parent:IsA("ScreenGui") and UDim2.new(0.5, 0, 0.5, 0)) or Obj.Position end,
			Active = true
		}
	}

	Explorer.InitInsertObject = function()
		local context = Lib.ContextMenu.new()
		context.SearchEnabled = true
		context.MaxHeight = 400
		context:ApplyTheme({
			ContentColor = Settings.Theme.Main2,
			OutlineColor = Settings.Theme.Outline1,
			DividerColor = Settings.Theme.Outline1,
			TextColor = Settings.Theme.Text,
			HighlightColor = Settings.Theme.ButtonHover
		})

		local classes = {}
		for i,class in next,API.Classes do
			local tags = class.Tags
			if not tags.NotCreatable and not tags.Service then
				local rmdEntry = RMD.Classes[class.Name]
				classes[#classes+1] = {class,rmdEntry and rmdEntry.ClassCategory or "Uncategorized"}
			end
		end
		table.sort(classes,function(a,b)
			if a[2] ~= b[2] then
				return a[2] < b[2]
			else
				return a[1].Name < b[1].Name
			end
		end)

		local function defaultProps(obj)
			for class, props in pairs(Explorer.DefaultProps) do
				if obj:IsA(class) then
					for prop, value in pairs(props) do
						obj[prop] = (type(value) == "function" and value(obj)) or value
					end
				end
			end
		end

		local function onClick(className)
			local sList = selection.List
			local instNew = Instance.new
			for i = 1,#sList do
				local node = sList[i]
				local obj = node.Obj
				Explorer.MakeNodeVisible(node, true)
				local success, obj = pcall(instNew, className, obj)
				if success and obj then defaultProps(obj) end
			end
		end

		local lastCategory = ""
		for i = 1,#classes do
			local class = classes[i][1]
			local rmdEntry = RMD.Classes[class.Name]
			local iconInd = rmdEntry and tonumber(rmdEntry.ExplorerImageIndex) or 0
			local category = classes[i][2]

			if lastCategory ~= category then
				context:AddDivider(category)
				lastCategory = category
			end
			
			local icon
			if iconData then
				icon = iconData.Icons[class.Name] or iconData.Icons.Placeholder
			else
				icon = iconInd
			end
			context:Add({Name = class.Name, IconMap = Explorer.ClassIcons, Icon = icon, OnClick = onClick})
		end

		Explorer.InsertObjectContext = context
	end
	
	--[[
		Headers, Setups, Predicate, ObjectDefs
	]]
	Explorer.SearchFilters = { -- TODO: Use data table (so we can disable some if funcs don't exist)
		Comparison = {
			["isa"] = function(argString)
				local lower = string.lower
				local find = string.find
				local classQuery = string.split(argString)[1]
				if not classQuery then return end
				classQuery = lower(classQuery)

				local className
				for class,_ in pairs(API.Classes) do
					local cName = lower(class)
					if cName == classQuery then
						className = class
						break
					elseif find(cName,classQuery,1,true) then
						className = class
					end
				end
				if not className then return end

				return {
					Headers = {"local isa = game.IsA"},
					Predicate = "isa(obj,'"..className.."')"
				}
			end,
			["remotes"] = function(argString)
				return {
					Headers = {"local isa = game.IsA"},
					Predicate = "isa(obj,'RemoteEvent') or isa(obj,'RemoteFunction') or isa(obj,'UnreliableRemoteFunction')"
				}
			end,
			["bindables"] = function(argString)
				return {
					Headers = {"local isa = game.IsA"},
					Predicate = "isa(obj,'BindableEvent') or isa(obj,'BindableFunction')"
				}
			end,
			["rad"] = function(argString)
				local num = tonumber(argString)
				if not num then return end

				if not service.Players.LocalPlayer.Character or not service.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or not service.Players.LocalPlayer.Character.HumanoidRootPart:IsA("BasePart") then return end

				return {
					Headers = {"local isa = game.IsA", "local hrp = service.Players.LocalPlayer.Character.HumanoidRootPart"},
					Setups = {"local hrpPos = hrp.Position"},
					ObjectDefs = {"local isBasePart = isa(obj,'BasePart')"},
					Predicate = "(isBasePart and (obj.Position-hrpPos).Magnitude <= "..num..")"
				}
			end,
		},
		Specific = {
			["players"] = function()
				return function() return service.Players:GetPlayers() end
			end,
			["loadedmodules"] = function()
				return env.getloadedmodules
			end,
		},
		Default = function(argString,caseSensitive)
			local cleanString = argString:gsub("\"","\\\""):gsub("\n","\\n")
			if caseSensitive then
				return {
					Headers = {"local find = string.find"},
					ObjectDefs = {"local objName = tostring(obj)"},
					Predicate = "find(objName,\"" .. cleanString .. "\",1,true)"
				}
			else
				return {
					Headers = {"local lower = string.lower","local find = string.find","local tostring = tostring"},
					ObjectDefs = {"local lowerName = lower(tostring(obj))"},
					Predicate = "find(lowerName,\"" .. cleanString:lower() .. "\",1,true)"
				}
			end
		end,
		SpecificDefault = function(n)
			return {
				Headers = {},
				ObjectDefs = {"local isSpec"..n.." = specResults["..n.."][node]"},
				Predicate = "isSpec"..n
			}
		end,
	}

	Explorer.BuildSearchFunc = function(query)
		local specFilterList,specMap = {},{}
		local finalPredicate = ""
		local rep = string.rep
		local formatQuery = query:gsub("\\.","  "):gsub('".-"',function(str) return rep(" ",#str) end)
		local headers = {}
		local objectDefs = {}
		local setups = {}
		local find = string.find
		local sub = string.sub
		local lower = string.lower
		local match = string.match
		local ops = {
			["("] = "(",
			[")"] = ")",
			["||"] = " or ",
			["&&"] = " and "
		}
		local filterCount = 0
		local compFilters = Explorer.SearchFilters.Comparison
		local specFilters = Explorer.SearchFilters.Specific
		local init = 1
		local lastOp = nil

		local function processFilter(dat)
			if dat.Headers then
				local t = dat.Headers
				for i = 1,#t do
					headers[t[i]] = true
				end
			end

			if dat.ObjectDefs then
				local t = dat.ObjectDefs
				for i = 1,#t do
					objectDefs[t[i]] = true
				end
			end

			if dat.Setups then
				local t = dat.Setups
				for i = 1,#t do
					setups[t[i]] = true
				end
			end

			finalPredicate = finalPredicate..dat.Predicate
		end

		local found = {}
		local foundData = {}
		local find = string.find
		local sub = string.sub

		local function findAll(str,pattern)
			local count = #found+1
			local init = 1
			local sz = #pattern
			local x,y,extra = find(str,pattern,init,true)
			while x do
				found[count] = x
				foundData[x] = {sz,pattern}

				count = count+1
				init = y+1
				x,y,extra = find(str,pattern,init,true)
			end
		end
		local start = tick()
		findAll(formatQuery,'&&')
		findAll(formatQuery,"||")
		findAll(formatQuery,"(")
		findAll(formatQuery,")")
		table.sort(found)
		table.insert(found,#formatQuery+1)

		local function inQuotes(str)
			local len = #str
			if sub(str,1,1) == '"' and sub(str,len,len) == '"' then
				return sub(str,2,len-1)
			end
		end

		for i = 1,#found do
			local nextInd = found[i]
			local nextData = foundData[nextInd] or {1}
			local op = ops[nextData[2]]
			local term = sub(query,init,nextInd-1)
			term = match(term,"^%s*(.-)%s*$") or "" -- Trim

			if #term > 0 then
				if sub(term,1,1) == "!" then
					term = sub(term,2)
					finalPredicate = finalPredicate.."not "
				end

				local qTerm = inQuotes(term)
				if qTerm then
					processFilter(Explorer.SearchFilters.Default(qTerm,true))
				else
					local x,y = find(term,"%S+")
					if x then
						local first = sub(term,x,y)
						local specifier = sub(first,1,1) == "/" and lower(sub(first,2))
						local compFunc = specifier and compFilters[specifier]
						local specFunc = specifier and specFilters[specifier]

						if compFunc then
							local argStr = sub(term,y+2)
							local ret = compFunc(inQuotes(argStr) or argStr)
							if ret then
								processFilter(ret)
							else
								finalPredicate = finalPredicate.."false"
							end
						elseif specFunc then
							local argStr = sub(term,y+2)
							local ret = specFunc(inQuotes(argStr) or argStr)
							if ret then
								if not specMap[term] then
									specFilterList[#specFilterList + 1] = ret
									specMap[term] = #specFilterList
								end
								processFilter(Explorer.SearchFilters.SpecificDefault(specMap[term]))
							else
								finalPredicate = finalPredicate.."false"
							end
						else
							processFilter(Explorer.SearchFilters.Default(term))
						end
					end
				end				
			end

			if op then
				finalPredicate = finalPredicate..op
				if op == "(" and (#term > 0 or lastOp == ")") then -- Handle bracket glitch
					return
				else
					lastOp = op
				end
			end
			init = nextInd+nextData[1]
		end

		local finalSetups = ""
		local finalHeaders = ""
		local finalObjectDefs = ""

		for setup,_ in next,setups do finalSetups = finalSetups..setup.."\n" end
		for header,_ in next,headers do finalHeaders = finalHeaders..header.."\n" end
		for oDef,_ in next,objectDefs do finalObjectDefs = finalObjectDefs..oDef.."\n" end

		local template = [==[
local searchResults = searchResults
local nodes = nodes
local expandTable = Explorer.SearchExpanded
local specResults = specResults
local service = service

%s
local function search(root)	
%s
	
	local expandedpar = false
	for i = 1,#root do
		local node = root[i]
		local obj = node.Obj
		
%s
		
		if %s then
			expandTable[node] = 0
			searchResults[node] = true
			if not expandedpar then
				local parnode = node.Parent
				while parnode and (not searchResults[parnode] or expandTable[parnode] == 0) do
					expandTable[parnode] = true
					searchResults[parnode] = true
					parnode = parnode.Parent
				end
				expandedpar = true
			end
		end
		
		if #node > 0 then search(node) end
	end
end
return search]==]

		local funcStr = template:format(finalHeaders,finalSetups,finalObjectDefs,finalPredicate)
		local s,func = pcall(loadstring,funcStr)
		if not s or not func then return nil,specFilterList end

		local env = setmetatable({["searchResults"] = searchResults, ["nodes"] = nodes, ["Explorer"] = Explorer, ["specResults"] = specResults,
			["service"] = service},{__index = getfenv()})
		setfenv(func,env)

		return func(),specFilterList
	end

	Explorer.DoSearch = function(query)
		table.clear(Explorer.SearchExpanded)
		table.clear(searchResults)
		expanded = (#query == 0 and Explorer.Expanded or Explorer.SearchExpanded)
		searchFunc = nil

		if #query > 0 then	
			local expandTable = Explorer.SearchExpanded
			local specFilters

			local lower = string.lower
			local find = string.find
			local tostring = tostring

			local lowerQuery = lower(query)

			local function defaultSearch(root)
				local expandedpar = false
				for i = 1,#root do
					local node = root[i]
					local obj = node.Obj

					if find(lower(tostring(obj)),lowerQuery,1,true) then
						expandTable[node] = 0
						searchResults[node] = true
						if not expandedpar then
							local parnode = node.Parent
							while parnode and (not searchResults[parnode] or expandTable[parnode] == 0) do
								expanded[parnode] = true
								searchResults[parnode] = true
								parnode = parnode.Parent
							end
							expandedpar = true
						end
					end

					if #node > 0 then defaultSearch(node) end
				end
			end

			if Main.Elevated then
				local start = tick()
				searchFunc,specFilters = Explorer.BuildSearchFunc(query)
				--print("BUILD SEARCH",tick()-start)
			else
				searchFunc = defaultSearch
			end

			if specFilters then
				table.clear(specResults)
				for i = 1,#specFilters do -- Specific search filers that returns list of matches
					local resMap = {}
					specResults[i] = resMap
					local objs = specFilters[i]()
					for c = 1,#objs do
						local node = nodes[objs[c]]
						if node then
							resMap[node] = true
						end
					end
				end
			end

			if searchFunc then
				local start = tick()
				searchFunc(nodes[game])
				searchFunc(nilNode)
				--warn(tick()-start)
			end
		end

		Explorer.ForceUpdate()
	end

	Explorer.ClearSearch = function()
		Explorer.GuiElems.SearchBar.Text = ""
		expanded = Explorer.Expanded
		searchFunc = nil
	end

	Explorer.InitSearch = function()
		local searchBox = Explorer.GuiElems.ToolBar.SearchFrame.SearchBox
		Explorer.GuiElems.SearchBar = searchBox

		Lib.ViewportTextBox.convert(searchBox)

		searchBox.FocusLost:Connect(function()
			Explorer.DoSearch(searchBox.Text)
		end)
	end

	Explorer.InitEntryTemplate = function()
		entryTemplate = create({
			{1,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderColor3=Color3.new(0,0,0),Font=3,Name="Entry",Position=UDim2.new(0,1,0,1),Size=UDim2.new(0,250,0,20),Text="",TextSize=14,}},
			{2,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BackgroundTransparency=1,BorderColor3=Color3.new(0.33725491166115,0.49019610881805,0.73725491762161),BorderSizePixel=0,Name="Indent",Parent={1},Position=UDim2.new(0,20,0,0),Size=UDim2.new(1,-20,1,0),}},
			{3,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="EntryName",Parent={2},Position=UDim2.new(0,26,0,0),Size=UDim2.new(1,-26,1,0),Text="Workspace",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
			{4,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClipsDescendants=true,Font=3,Name="Expand",Parent={2},Position=UDim2.new(0,-20,0,0),Size=UDim2.new(0,20,0,20),Text="",TextSize=14,}},
			{5,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5642383285",ImageRectOffset=Vector2.new(144,16),ImageRectSize=Vector2.new(16,16),Name="Icon",Parent={4},Position=UDim2.new(0,2,0,2),ScaleType=4,Size=UDim2.new(0,16,0,16),}},
			{6,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ImageRectOffset=Vector2.new(304,0),ImageRectSize=Vector2.new(16,16),Name="Icon",Parent={2},Position=UDim2.new(0,4,0,2),ScaleType=4,Size=UDim2.new(0,16,0,16),}},
		})

		local sys = Lib.ClickSystem.new()
		sys.AllowedButtons = {1,2}
		sys.OnDown:Connect(function(item,combo,button)
			local ind = table.find(listEntries,item)
			if not ind then return end
			local node = tree[ind + Explorer.Index]
			if not node then return end

			local entry = listEntries[ind]

			if button == 1 then
				if combo == 2 then
					if node.Obj:IsA("LuaSourceContainer") then
						ScriptViewer.ViewScript(node.Obj)
					elseif #node > 0 and expanded[node] ~= 0 then
						expanded[node] = not expanded[node]
						Explorer.Update()
					end
				end

				if Properties.SelectObject(node.Obj) then
					sys.IsRenaming = false
					return
				end

				sys.IsRenaming = selection.Map[node]

				if Lib.IsShiftDown() then
					if not selection.Piviot then return end

					local fromIndex = table.find(tree,selection.Piviot)
					local toIndex = table.find(tree,node)
					if not fromIndex or not toIndex then return end
					fromIndex,toIndex = math.min(fromIndex,toIndex),math.max(fromIndex,toIndex)

					local sList = selection.List
					for i = #sList,1,-1 do
						local elem = sList[i]
						if selection.ShiftSet[elem] then
							selection.Map[elem] = nil
							table.remove(sList,i)
						end
					end
					selection.ShiftSet = {}
					for i = fromIndex,toIndex do
						local elem = tree[i]
						if not selection.Map[elem] then
							selection.ShiftSet[elem] = true
							selection.Map[elem] = true
							sList[#sList+1] = elem
						end
					end
					selection.Changed:Fire()
				elseif Lib.IsCtrlDown() then
					selection.ShiftSet = {}
					if selection.Map[node] then selection:Remove(node) else selection:Add(node) end
					selection.Piviot = node
					sys.IsRenaming = false
				elseif not selection.Map[node] then
					selection.ShiftSet = {}
					selection:Set(node)
					selection.Piviot = node
				end
			elseif button == 2 then
				if Properties.SelectObject(node.Obj) then
					return
				end

				if not Lib.IsCtrlDown() and not selection.Map[node] then
					selection.ShiftSet = {}
					selection:Set(node)
					selection.Piviot = node
					Explorer.Refresh()
				end
			end

			Explorer.Refresh()
		end)

		sys.OnRelease:Connect(function(item,combo,button,position)
			local ind = table.find(listEntries,item)
			if not ind then return end
			local node = tree[ind + Explorer.Index]
			if not node then return end

			if button == 1 then
				if selection.Map[node] and not Lib.IsShiftDown() and not Lib.IsCtrlDown() then
					selection.ShiftSet = {}
					selection:Set(node)
					selection.Piviot = node
					Explorer.Refresh()
				end

				local id = sys.ClickId
				Lib.FastWait(sys.ComboTime)
				if combo == 1 and id == sys.ClickId and sys.IsRenaming and selection.Map[node] then
					Explorer.SetRenamingNode(node)
				end
			elseif button == 2 then
				Explorer.ShowRightClick(position)
			end
		end)
		Explorer.ClickSystem = sys
	end

	Explorer.InitDelCleaner = function()
		coroutine.wrap(function()
			local fw = Lib.FastWait
			while true do
				local processed = false
				local c = 0
				for _,node in next,nodes do
					if node.HasDel then
						local delInd
						for i = 1,#node do
							if node[i].Del then
								delInd = i
								break
							end
						end
						if delInd then
							for i = delInd+1,#node do
								local cn = node[i]
								if not cn.Del then
									node[delInd] = cn
									delInd = delInd+1
								end
							end
							for i = delInd,#node do
								node[i] = nil
							end
						end
						node.HasDel = false
						processed = true
						fw()
					end
					c = c + 1
					if c > 10000 then
						c = 0
						fw()
					end
				end
				if processed and not refreshDebounce then Explorer.PerformRefresh() end
				fw(0.5)
			end
		end)()
	end

	Explorer.UpdateSelectionVisuals = function()
		local holder = Explorer.SelectionVisualsHolder
		local isa = game.IsA
		local clone = game.Clone
		if not holder then
			holder = Instance.new("ScreenGui")
			holder.Name = "ExplorerSelections"
			holder.DisplayOrder = Main.DisplayOrders.Core
			Lib.ShowGui(holder)
			Explorer.SelectionVisualsHolder = holder
			Explorer.SelectionVisualCons = {}

			local guiTemplate = create({
				{1,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Size=UDim2.new(0,100,0,100),}},
				{2,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BorderSizePixel=0,Parent={1},Position=UDim2.new(0,-1,0,-1),Size=UDim2.new(1,2,0,1),}},
				{3,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BorderSizePixel=0,Parent={1},Position=UDim2.new(0,-1,1,0),Size=UDim2.new(1,2,0,1),}},
				{4,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BorderSizePixel=0,Parent={1},Position=UDim2.new(0,-1,0,0),Size=UDim2.new(0,1,1,0),}},
				{5,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BorderSizePixel=0,Parent={1},Position=UDim2.new(1,0,0,0),Size=UDim2.new(0,1,1,0),}},
			})
			Explorer.SelectionVisualGui = guiTemplate

			local boxTemplate = Instance.new("SelectionBox")
			boxTemplate.LineThickness = 0.03
			boxTemplate.Color3 = Color3.fromRGB(0, 170, 255)
			Explorer.SelectionVisualBox = boxTemplate
		end
		holder:ClearAllChildren()

		-- Updates theme
		for i,v in pairs(Explorer.SelectionVisualGui:GetChildren()) do
			v.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		end

		local attachCons = Explorer.SelectionVisualCons
		for i = 1,#attachCons do
			attachCons[i].Destroy()
		end
		table.clear(attachCons)

		local partEnabled = Settings.Explorer.PartSelectionBox
		local guiEnabled = Settings.Explorer.GuiSelectionBox
		if not partEnabled and not guiEnabled then return end

		local svg = Explorer.SelectionVisualGui
		local svb = Explorer.SelectionVisualBox
		local attachTo = Lib.AttachTo
		local sList = selection.List
		local count = 1
		local boxCount = 0
		local workspaceNode = nodes[workspace]
		for i = 1,#sList do
			if boxCount > 1000 then break end
			local node = sList[i]
			local obj = node.Obj

			if node ~= workspaceNode then
				if isa(obj,"GuiObject") and guiEnabled then
					local newVisual = clone(svg)
					attachCons[count] = attachTo(newVisual,{Target = obj, Resize = true})
					count = count + 1
					newVisual.Parent = holder
					boxCount = boxCount + 1
				elseif isa(obj,"PVInstance") and partEnabled then
					local newBox = clone(svb)
					newBox.Adornee = obj
					newBox.Parent = holder
					boxCount = boxCount + 1
				end
			end
		end
	end

	Explorer.Init = function()
		Explorer.LegacyClassIcons = Lib.IconMap.newLinear("rbxasset://textures/ClassImages.PNG", 16,16)
		
		if Settings.ClassIcon ~= nil and Settings.ClassIcon ~= "Old" then
			iconData = Lib.IconMap.getIconDataFromName(Settings.ClassIcon)
			
			Explorer.ClassIcons = Lib.IconMap.new("rbxassetid://"..tostring(iconData.MapId), iconData.IconSize * iconData.Witdh, iconData.IconSize * iconData.Height,iconData.IconSize,iconData.IconSize)
			-- move every value dict 1 behind because SetDict starts at 0 not 1 lol
			local fixed = {}
			for i,v in pairs(iconData.Icons) do
				fixed[i] = v - 1
			end
			
			iconData.Icons = fixed
			Explorer.ClassIcons:SetDict(fixed)
		else
			Explorer.ClassIcons = Lib.IconMap.newLinear("rbxasset://textures/ClassImages.PNG", 16,16)
		end
		
		Explorer.MiscIcons = Main.MiscIcons

		clipboard = {}

		selection = Lib.Set.new()
		selection.ShiftSet = {}
		selection.Changed:Connect(Properties.ShowExplorerProps)
		Explorer.Selection = selection

		Explorer.InitRightClick()
		Explorer.InitInsertObject()
		Explorer.SetSortingEnabled(Settings.Explorer.Sorting)
		Explorer.Expanded = setmetatable({},{__mode = "k"})
		Explorer.SearchExpanded = setmetatable({},{__mode = "k"})
		expanded = Explorer.Expanded

		nilNode.Obj.Name = "Nil Instances"
		nilNode.Locked = true

		local explorerItems = create({
			{1,"Folder",{Name="ExplorerItems",}},
			{2,"Frame",{BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BorderSizePixel=0,Name="ToolBar",Parent={1},Size=UDim2.new(1,0,0,22),}},
			{3,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.1176470592618,0.1176470592618,0.1176470592618),BorderSizePixel=0,Name="SearchFrame",Parent={2},Position=UDim2.new(0,3,0,1),Size=UDim2.new(1,-6,0,18),}},
			{4,"TextBox",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClearTextOnFocus=false,Font=3,Name="SearchBox",Parent={3},PlaceholderColor3=Color3.new(0.39215689897537,0.39215689897537,0.39215689897537),PlaceholderText="Search workspace",Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-24,0,18),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,}},
			{5,"UICorner",{CornerRadius=UDim.new(0,2),Parent={3},}},
			{6,"UIStroke",{Thickness=1.4,Parent={3},Color=Color3.fromRGB(42,42,42)}},
			{7,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Reset",Parent={3},Position=UDim2.new(1,-17,0,1),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,}},
			{8,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5034718129",ImageColor3=Color3.new(0.39215686917305,0.39215686917305,0.39215686917305),Parent={7},Size=UDim2.new(0,16,0,16),}},
			{9,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Refresh",Parent={2},Position=UDim2.new(1,-20,0,1),Size=UDim2.new(0,18,0,18),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,Visible=false,}},
			{10,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5642310344",Parent={9},Position=UDim2.new(0,3,0,3),Size=UDim2.new(0,12,0,12),}},
			{11,"Frame",{BackgroundColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,Name="ScrollCorner",Parent={1},Position=UDim2.new(1,-16,1,-16),Size=UDim2.new(0,16,0,16),Visible=false,}},
			{12,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClipsDescendants=true,Name="List",Parent={1},Position=UDim2.new(0,0,0,23),Size=UDim2.new(1,0,1,-23),}}
		})

		toolBar = explorerItems.ToolBar
		treeFrame = explorerItems.List

		Explorer.GuiElems.ToolBar = toolBar
		Explorer.GuiElems.TreeFrame = treeFrame

		scrollV = Lib.ScrollBar.new()		
		scrollV.WheelIncrement = 3
		scrollV.Gui.Position = UDim2.new(1,-16,0,23)
		scrollV:SetScrollFrame(treeFrame)
		scrollV.Scrolled:Connect(function()
			Explorer.Index = scrollV.Index
			Explorer.Refresh()
		end)

		scrollH = Lib.ScrollBar.new(true)
		scrollH.Increment = 5
		scrollH.WheelIncrement = Explorer.EntryIndent
		scrollH.Gui.Position = UDim2.new(0,0,1,-16)
		scrollH.Scrolled:Connect(function()
			Explorer.Refresh()
		end)

		local window = Lib.Window.new()
		Explorer.Window = window
		window:SetTitle("Explorer")
		window.GuiElems.Line.Position = UDim2.new(0,0,0,22)

		Explorer.InitEntryTemplate()
		toolBar.Parent = window.GuiElems.Content
		treeFrame.Parent = window.GuiElems.Content
		explorerItems.ScrollCorner.Parent = window.GuiElems.Content
		scrollV.Gui.Parent = window.GuiElems.Content
		scrollH.Gui.Parent = window.GuiElems.Content

		-- Init stuff that requires the window
		Explorer.InitRenameBox()
		Explorer.InitSearch()
		Explorer.InitDelCleaner()
		selection.Changed:Connect(Explorer.UpdateSelectionVisuals)

		-- Window events
		window.GuiElems.Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if Explorer.Active then
				Explorer.UpdateView()
				Explorer.Refresh()
			end
		end)
		window.OnActivate:Connect(function()
			Explorer.Active = true
			Explorer.UpdateView()
			Explorer.Update()
			Explorer.Refresh()
		end)
		window.OnRestore:Connect(function()
			Explorer.Active = true
			Explorer.UpdateView()
			Explorer.Update()
			Explorer.Refresh()
		end)
		window.OnDeactivate:Connect(function() Explorer.Active = false end)
		window.OnMinimize:Connect(function() Explorer.Active = false end)

		-- Settings
		autoUpdateSearch = Settings.Explorer.AutoUpdateSearch

		-- Fill in nodes
		nodes[game] = {Obj = game}
		expanded[nodes[game]] = true

		-- Nil Instances
		if env.getnilinstances then
			nodes[nilNode.Obj] = nilNode
		end

		Explorer.SetupConnections()

		local insts = getDescendants(game)
		if Main.Elevated then
			for i = 1,#insts do
				local obj = insts[i]
				local par = nodes[ffa(obj,"Instance")]
				if not par then continue end
				local newNode = {
					Obj = obj,
					Parent = par,
				}
				nodes[obj] = newNode
				par[#par+1] = newNode
			end
		else
			for i = 1,#insts do
				local obj = insts[i]
				local s,parObj = pcall(ffa,obj,"Instance")
				local par = nodes[parObj]
				if not par then continue end
				local newNode = {
					Obj = obj,
					Parent = par,
				}
				nodes[obj] = newNode
				par[#par+1] = newNode
			end
		end
	end

	return Explorer
end

return {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
