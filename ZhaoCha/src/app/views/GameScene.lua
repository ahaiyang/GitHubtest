
local _mutils       = require 'app.utils.MUtils'
local LevelData  	= require 'app.data.LeveLData'
local GameData   = require("app.views.GameData")
local _netMsg 		= require 'app.utils.NetMsg'
local _schedule = cc.Director:getInstance():getScheduler()

local Max_Time = 0
local GameScene = class("GameScene", cc.load("mvc").ViewBase)
GameScene.RESOURCE_FILENAME = "GameScene.csb"

local nomalTime = 60
local limitTime = 300
local costTime  = 20

function GameScene:onCreate()
	_netMsg.clickOtherBtn("gamescene")
    local csb = self:getResourceNode()
    csb:setPositionY(_mutils.getAddH()/2)
    self.csb = csb

    self.currentLV = 1
    

    if GameData.TYPE == GameData.Model.LEVELMODEL then
    	self.currentLV = GameData.getCurrentLevel()
    	Max_Time = nomalTime
    	GameData.setPlayCounts(GameData.getPlayCounts() + 1)
    elseif GameData.TYPE == GameData.Model.TIMEMODEL then
    	Max_Time = limitTime
    end
    self:initUI()
    self:initButtons()
    self:initRightUI()

    self:startTimer()
end

function GameScene:initButtons()
	local Button_back 			= _mutils.seekNodeByName(self.csb, "Button_back")
	local Button_prompt 		= _mutils.seekNodeByName(self.csb, "Button_tishi")

	
	_mutils.addBtnPressedListener(Button_back, function()
		self:getApp():enterScene("MainScene")
	end)

	_mutils.addBtnPressedListener(Button_prompt,function()
		_netMsg.clickOtherBtn("tishi")
		self:promtMessage()
	end)
end

function GameScene:initUI()
	self.findCount = 0
	local pic_origin 	= _mutils.seekNodeByName(self.csb, "Image_origin")
	local pic_diff 		= _mutils.seekNodeByName(self.csb, "Image_dif")
	pic_origin:loadTexture("pictures/lv_"..self.currentLV..".png")
	pic_diff:loadTexture("pictures/lv_d_"..self.currentLV..".png")
	local yuan_model = _mutils.seekNodeByName(self.csb, "Image_yuan")
	yuan_model:setVisible(false)

	for i=1,10 do
		local node = pic_origin:getChildByTag(1000+i)
		if node then
			pic_origin:removeChild(node)
		end
	end

	for i=1,10 do
		local node = pic_diff:getChildByTag(5000+i)
		if node then
			pic_diff:removeChild(node)
		end
	end

	local data = LevelData[self.currentLV]
	self.level_data = data
	local origin_flags 	= {}
	local diff_flags 	= {}
	--加入隐藏的提示圈
	for i=1,data.diff do
		local red = yuan_model:clone()
		red:setVisible(true)
		red:setPosition(data.diffPos[i])
		red:setOpacity(0)
		red:setScale(data.scales[i])
		pic_origin:addChild(red)
		red:setTag(1000 + i)
		table.insert(origin_flags, red)
		red:setTouchEnabled(true)
		red:addTouchEventListener(function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				if sender:getOpacity() == 255 then
					return
				end 
				sender:setOpacity(255)
				diff_flags[i]:setOpacity(255)
				self.findCount = self.findCount + 1
				self:refreshUI()
			end
		end)
	end

	for i=1,data.diff do
		local red = yuan_model:clone()
		red:setVisible(true)
		red:setPosition(data.diffPos[i])
		red:setOpacity(0)
		red:setScale(data.scales[i])
		pic_diff:addChild(red)
		red:setTag(5000 + i)
		table.insert(diff_flags, red)
		red:setTouchEnabled(true)
		red:addTouchEventListener(function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				if sender:getOpacity() == 255 then
					return
				end 
				sender:setOpacity(255)
				origin_flags[i]:setOpacity(255)
				self.findCount = self.findCount + 1
				self:refreshUI()
			end
		end)
	end

	self.origin_flags = origin_flags
	self.diff_flags = diff_flags

	local panel_pics = _mutils.seekNodeByName(self.csb, "Panel_pics")
	panel_pics:setTouchEnabled(true)
	panel_pics:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.startTime = self.startTime - costTime  
			self:showTimeLabel()
			if self.startTime <= 0 then
				self.startTime = 1
				self:updateTimer()
			end
		end
	end)
end

function GameScene:initRightUI()
	_mutils.seekNodeByName(self.csb, "LV_label"):setString(self.currentLV)
	self.find_label = _mutils.seekNodeByName(self.csb, "Find_label")
	self.find_label:setString("0/"..self.level_data.diff)

	self.timeLabel = _mutils.seekNodeByName(self.csb, "Time_label")

    self.timeLabel:setString(self:timeToString(Max_Time))

	local img_bg = _mutils.seekNodeByName(self.csb, "Image_bg")
	self.img_bg = img_bg

	for i=1,10 do
		local node1 = img_bg:getChildByTag(1000 + i) 
		if node1 then
			img_bg:removeChild(node1)
		end
		local node2 = img_bg:getChildByTag(5000 + i) 
		if node1 then
			img_bg:removeChild(node2)
		end
	end

	--星星背景
	self.allStars = {}
	local star_bg = _mutils.seekNodeByName(self.csb, "Image_star_bg")
	star_bg:setVisible(false)
	local star_model = _mutils.seekNodeByName(self.csb, "Image_star")
	star_model:setVisible(false)
	local maxrow = 4
	for i=1,self.level_data.diff do
		local bg_star = star_bg:clone()
		bg_star:setVisible(true)
		if i > 4 then
			bg_star:setPosition(1070 + (i-4-1)*55, 160)
		else
			bg_star:setPosition(1070 + (i-1)*55, 220)
		end
		bg_star:setTag(1000 + i)
		img_bg:addChild(bg_star)

		local star = star_model:clone()
		star:setPosition(bg_star:getPosition())
		star:setVisible(false)
		star:setTag(5000 + i)
		img_bg:addChild(star)
		table.insert(self.allStars, star)
	end
end

function GameScene:refreshUI()
	for i,v in ipairs(self.allStars) do
		if i <= self.findCount then
			v:setVisible(true)
		end
	end

	self.find_label:setString(self.findCount.."/"..self.level_data.diff)

	if self.findCount == self.level_data.diff then
		if GameData.TYPE == GameData.Model.LEVELMODEL then
			self:nextLevelModel()
		elseif GameData.TYPE == GameData.Model.TIMEMODEL then
			if self.currentLV == 9 then
				self:removeTimeHandler()
				local cost_time = self:timeToString(limitTime - self.startTime)
				local callfunc = function()
					self:getApp():enterScene("MainScene")
				end
				require("app.views.NoticeTip").new("挑战成功！用时"..cost_time, nil, callfunc, true)
				return
			end
			self.currentLV = self.currentLV + 1
			self:initUI()
			self:initRightUI()
		end
	end
end

function GameScene:nextLevelModel()
	self:removeTimeHandler()
	local call1 = function()
		self:getApp():enterScene("MainScene")
	end
	local call2 = function()
		self:getApp():enterScene("GameScene")
	end
	if self.currentLV == GameData.getLevevModel() then
		GameData.setLevelModel(self.currentLV + 1)
	end
	GameData.setCurrentLevel(self.currentLV + 1)
	local stars = self:getStars()
	require("app.views.SuccessLayer").new(stars, call1, call2)
end

function GameScene:promtMessage()
	
	self.startTime = self.startTime - costTime  
	self:showTimeLabel()
	if self.startTime <= 0 then
		self.startTime = 1
		self:updateTimer()
		return
	end
	
	for i,v in ipairs(self.origin_flags) do
		if v:getOpacity() == 0 then
			self:flagsRunAction(v,self.diff_flags[i])
			break
		end
	end
end

function GameScene:flagsRunAction(node1,node2)
	node1:setOpacity(255)
	node2:setOpacity(255)
	node1:setTouchEnabled(false)
	node2:setTouchEnabled(false)
	local ac1 = CCBlink:create(3,5)
	local ac2 = CCBlink:create(3,5)

	node1:runAction(ac1)
	node2:runAction(cc.Sequence:create(ac2,cc.CallFunc:create(function()
		node1:setOpacity(0)
		node2:setOpacity(0)
		node1:setTouchEnabled(true)
		node2:setTouchEnabled(true)
	end)))

end

function GameScene:startTimer()
	if not self.timeHandler then
		self.timeHandler = _schedule:scheduleScriptFunc(handler(self,self.updateTimer), 1, false)
		if not self.startTime then
			self.startTime = Max_Time
		end
	end
end

function GameScene:removeTimeHandler()
	if self.timeHandler then
		_schedule:unscheduleScriptEntry(self.timeHandler)
		self.timeHandler = nil
	end
end

function GameScene:updateTimer()
	if self.startTime > 0 then
		self.startTime = self.startTime - 1
		local _time = self:timeToString(self.startTime)
		self.timeLabel:setString(_time)
	else
		self.startTime = nil
		self:showFailedLayer()
	end
end

function GameScene:timeToString(_time)
	local h = math.floor(_time / 3600)
	local m = math.floor((_time % 3600) / 60)
	local s = math.floor((_time % 3600) % 60)
	return string.format("%02d:%02d", m, s)
end

function GameScene:showFailedLayer()
	self:removeTimeHandler()
	local str = "挑战失败！请求复活"
	require("app.views.NoticeTip").new(str, nil, function()
		local adsLayer = require("app.ADSLayer").new()
		display.getRunningScene():addChild(adsLayer, 100)
		performWithDelay(self, function()
			self:getApp():enterScene("GameScene")
		end,5)

	end, true)
end

function GameScene:getStars()
	local stars = 1
	if self.startTime > Max_Time * 0.7 then
		stars = 3
	elseif self.startTime > Max_Time * 0.5 then
		stars = 2
	else
		stars = 1
	end

	return stars
end

function GameScene:showTimeLabel()
	local proLabel = _mutils.createTTFLabel("-"..costTime, 40)
	proLabel:setAnchorPoint(0.5,0.5)
	proLabel:setPosition(1200, 420)
	proLabel:setColor(cc.c3b(255,0,0))
	self.img_bg:addChild(proLabel)

	local moveby = cc.MoveBy:create(1,cc.p(0, 50))

	proLabel:runAction(cc.Sequence:create(moveby,cc.CallFunc:create(function()
		self.img_bg:removeChild(proLabel)
	end)))
end

function GameScene:onExit()
	self:removeTimeHandler()
end

return GameScene
