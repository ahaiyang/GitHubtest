
local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'

local ChipConfig 	= require 'app.data.ChipConfig'
local ColorConfig 	= require 'app.data.ColorConfig'
local GameData 		= require 'app.views.GameData'

local MainScene = class("MainScene", cc.load("mvc").ViewBase)
MainScene.RESOURCE_FILENAME = "MainScene.csb"
function MainScene:onCreate()
	local csb = self:getResourceNode()
    csb:setPositionX(csb:getPositionX() + math.abs(_mutils.getAddW()/2))
    self.csb = csb

    self:initLocalData()

	self:initUI()
	self:initButtons()
end

function MainScene:initLocalData()
	local content = GameData.getFaceDIYData()
	local diy_data = {}
	if content == "" then
		print("no diy data")
		print("create default diy data")
		for i,v in ipairs(ChipConfig) do
			local item_data = {}


			for ii,vv in ipairs(v) do
				local chipdata = {}
				chipdata.id = ii
				chipdata.colorId = 0
				table.insert(item_data, chipdata)
			end
			table.insert(diy_data, item_data)
		end

		GameData.setFaceDIYData(json.encode(diy_data))
	else
		-- dump(json.decode(content), "diy data")
	end
end

function MainScene:initUI()
	self.selectColor = cc.c3b(0, 0, 0) --默认为黑色
	self.selectColorId = 1
	self.faceIndex = GameData.getCurrentLevel()

	_netMsg.clickOtherBtn("lv_"..self.faceIndex)

	--左上角标准图
	self:initLeftTopFace()
	--主要脸谱
	self:initMainFace()
	--右侧色块
	self:initColors()
	--底层列表
	self:initListView()

	if self.text_next then
		self.text_next:setVisible(false)
	end
end

function MainScene:initButtons()
	local btn_update 	= _mutils.seekNodeByName(self.csb, "Button_update")
	local btn_force 	= _mutils.seekNodeByName(self.csb, "Button_force")
	local btn_next 		= _mutils.seekNodeByName(self.csb, "Button_next")

	self.text_next		= _mutils.seekNodeByName(btn_next, "Text_next")
	self.text_next:setVisible(false)

	_mutils.addBtnPressedListener(btn_update, function()
		_netMsg.clickOtherBtn("update")
		self:clearDiyData()
		self:initUI()
	end)
	_mutils.addBtnPressedListener(btn_force, function()
		_netMsg.clickOtherBtn("btn_force")
		local level = GameData.getCurrentLevel()
		if level <= 1 then
			_mutils.showFlyWord("已经是第一张了")
		else
			GameData.setCurrentLevel(level - 1)
			self:initUI()
		end
	end)
	_mutils.addBtnPressedListener(btn_next, function()
		_netMsg.clickOtherBtn("btn_next")
		local level = GameData.getCurrentLevel()
		local maxlevel = GameData.getLevel()
		if level >= maxlevel then
			if self:checkDoneLevel() then
				GameData.setCurrentLevel(level + 1)
				GameData.setLevel(level + 1)
				self:initUI()
			else
				_mutils.showFlyWord("已经是解锁的最后一张了")
			end
			
		else
			GameData.setCurrentLevel(level + 1)
			self:initUI()
		end

		if self:checkDoneLevel() then

		end
	end)

	_mutils.repScale(self.text_next, 1, 0.7, 1)
end

function MainScene:clearDiyData()
	local datastr = GameData.getFaceDIYData()
	local data = json.decode(datastr)

	for i,v in ipairs(self.diy_item_data) do
		v.colorId = 0
	end

	data[self.faceIndex] = self.diy_item_data

	GameData.setFaceDIYData(json.encode(data))
end

function MainScene:initListView()
	local listView = _mutils.seekNodeByName(self.csb, "ListView")
	listView:removeAllChildren()
	local facemodel = _mutils.seekNodeByName(self.csb, "facemodel")
	facemodel:setVisible(false)

	local level = GameData.getLevel()

	for i=1,18 do
		local facecell = facemodel:clone()
		local lockbg = _mutils.seekNodeByName(facecell, "Image_lock")
		local face = _mutils.seekNodeByName(facecell, "face")
		facecell:setVisible(true)
		face:loadTexture("common/lian_"..i..".png")
		listView:pushBackCustomItem(facecell)

		if i <= level then
			lockbg:setVisible(false)
		end

		facecell:setTouchEnabled(true)
		facecell:addTouchEventListener(function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				if i > level then
					_mutils.showFlyWord("请完成前一张脸谱的绘色")
				else
					print("select level")
					GameData.setCurrentLevel(i)
					self:initUI()
				end
			end
		end)
	end
end

function MainScene:initLeftTopFace()
	local lefttop_face = _mutils.seekNodeByName(self.csb, "lefttop_face")
	lefttop_face:loadTexture("common/lian_"..self.faceIndex..".png")
end

function MainScene:initColors()
	local Panel_bg = _mutils.seekNodeByName(self.csb, "Panel_bg")

	local color_model = _mutils.seekNodeByName(self.csb, "color_model")
	color_model:setVisible(false)

	for i=1,10 do
		local color_t = Panel_bg:getChildByTag(100+i)
		if color_t then
			color_t:removeFromParent()
		end
	end

	local colorsTab = {}

	local slectColorFunc = function(index)
		for i,v in ipairs(colorsTab) do
			local red_bg = _mutils.seekNodeByName(v, "red_bg")
			red_bg:setVisible(i == index)
		end
	end

	for i,v in ipairs(ColorConfig) do
		local color_btn = color_model:clone()
		local red_bg = _mutils.seekNodeByName(color_btn, "red_bg")
		red_bg:setVisible(false)
		color_btn:loadTexture("common/"..v.name)
		color_btn:setVisible(true)
		color_btn:setPosition(cc.p(color_model:getPositionX(),color_model:getPositionY() - (i-1)*80))
		Panel_bg:addChild(color_btn)
		color_btn:setTag(100+i)
		table.insert(colorsTab,color_btn)
		color_btn:setTouchEnabled(true)
		color_btn:addTouchEventListener(function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				_netMsg.clickOtherBtn("select")
				self.selectColor = v.color
				self.selectColorId = v.id
				slectColorFunc(i)
			end
		end)
	end

	slectColorFunc(1)
end

function MainScene:initMainFace()

	self.diy_item_data = json.decode(GameData.getFaceDIYData())[self.faceIndex]

	self.mainface = _mutils.seekNodeByName(self.csb, "mainface")
	self.mainface:loadTexture("mainface/lianpu-"..self.faceIndex..".png")
	self.mainface:setTag(100)
	self.mainface:removeAllChildren()
	self.allChips = {}
	local chip_path = "chip/"..self.faceIndex.."/"
	local chip_cfg = ChipConfig[self.faceIndex]
	for i,v in ipairs(chip_cfg) do
		local chip = cc.Sprite:create(chip_path..v.name)
		chip:setTag(i)
		chip:setPosition(v.pos)
		local colorId = self.diy_item_data[i].colorId
		if colorId > 0 then
			chip:setColor(ColorConfig[colorId].color)
		end
		self.mainface:addChild(chip)
		chip.isClick = false
		chip.id = i
		table.insert(self.allChips, chip)
	end

	if not self.listener then
		-- 触摸事件
		self.listener = cc.EventListenerTouchOneByOne:create()
		self.listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
		self.listener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
		self.listener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
		local eventDispatcher = self.mainface:getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self.mainface)
	end
end

function MainScene:touchChip(touch)
	for i,v in ipairs(self.allChips) do
		local location = v:convertToNodeSpace(touch)
		local size = v:getContentSize()
		local rect = cc.rect(0, 0, size.width, size.height)
		local p = v:convertToNodeSpace(touch)
		if cc.rectContainsPoint(rect, p) then
	        local isClick = GameUtils:alphaTouchCheck(v, location)
			if isClick then
				return v
			end
	    end
	end
end

function MainScene:onTouchBegan(touch,event)
	print("onTouchBegan---->")
	local target = event:getCurrentTarget()
    local size = target:getContentSize()
    local rect = cc.rect(0, 0, size.width, size.height)
    local p = target:convertTouchToNodeSpace(touch)

    if not cc.rectContainsPoint(rect, p) then
        return false
    end

	local clickChip = self:touchChip(touch:getLocation())

	if clickChip then
		self.clickChip = clickChip
		return true
	end
	return false
end

function MainScene:onTouchMoved(touch, event)
	-- body
end

function MainScene:onTouchEnded( touch, event )
	_netMsg.clickOtherBtn("chip")
	self.clickChip:setColor(self.selectColor)
	self.clickChip.isClick = true
	
	
	self.diy_item_data[self.clickChip.id].colorId = self.selectColorId
	
	local datastr = GameData.getFaceDIYData()
	local data = json.decode(datastr)
	data[self.faceIndex] = self.diy_item_data

	GameData.setFaceDIYData(json.encode(data))
	if self:checkDoneLevel() then
		_mutils.showFlyWord("填色完成,可以开启下一张脸谱啦")

		--加提示
		self.text_next:setVisible(true)
	end
end

function MainScene:checkDoneLevel()
	for i,v in ipairs(self.allChips) do
		if v.isClick == false then
			return false
		end
	end
	return true
end

return MainScene
