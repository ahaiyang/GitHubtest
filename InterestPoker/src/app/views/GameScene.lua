local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'
local GameScene = class("GameScene", cc.load("mvc").ViewBase)
GameScene.RESOURCE_FILENAME = "GameScene.csb"


local PokerReferPos = require("app/views/PokerReferPos")
local Poker = require("app/modules/Poker")
local PokerManager = require("app/views/PokerManager")

local GameData 		= require 'app.views.GameData'

local _schedule = cc.Director:getInstance():getScheduler()

local PokerHold = {
	[1] = "gamescene/jl_img_pian.png",
	[2] = "gamescene/jl_img_huazi.png",
	[3]	= "gamescene/jl_img_hongtao.png",
	[4]	= "gamescene/jl_img_heitao.png",
}

local Zorder = {
	LEFT_BTN 	= 10,
	TOUCH 		= 99,
}

local Max_Time = 600 --10分钟

local Top_Line = 7 --7列扑克 

function GameScene:onCreate()
	_netMsg.clickOtherBtn("gamescene")
	local csb = self:getResourceNode()
    self.csb = csb
    csb:setPositionY(_mutils.getAddH()/2)
    self.bg	= _mutils.seekNodeByName(csb, "background")

    
    self.timeLabel = _mutils.seekNodeByName(csb, "timeLabel")
    self:initButtons()

    local playPokerLayer = cc.Layer:create()
    self.csb:addChild(playPokerLayer,100)
    self.playPokerLayer = playPokerLayer

    -- 触摸事件
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
	local eventDispatcher = self.playPokerLayer:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.playPokerLayer)

	self:initObjectsOnPokerLayer()

end

function GameScene:initObjectsOnPokerLayer()
	self:startTimer()
	--布局
    	--右侧四个位置，每个位置收集正确的从小到大且同花的牌型、牌面正
    	--顶部7个位置，初始化时：位置index对应index张扑克，只留一张牌面正(可拖动、点击)，其余牌面背，不可以点击、不可拖动，没有child时自动变牌面正
    	--左侧剩余扑克，
    	--左侧展示扑克。
    --发牌：没有遗留牌局。有遗留牌局，展示遗留牌局

	self.pokerObjects 	= {} --52张扑克

    self.topPokers		= {} --初始化时28张扑克
    self.leftPokers 	= {} --初始化时24张扑克


    self.leftShowPokers = {} --左侧翻出来的扑克

    self.sortPokers		= {}

    self.sortHold 		= {}

    self.topHold 		= {}

	self:initRightHold()
    self:initTopHold()
   	self:initLeftOpactyBtn()
    self:initAllPokersData()
end

function GameScene:initButtons()
	local prompBtn = _mutils.seekNodeByName(self.csb, "Button_tishi")
    _mutils.addBtnPressedListener(prompBtn, function()
    	_netMsg.clickOtherBtn("tishi")
    	if GameData.getDiamondCount() > 0 then
    		local callFunc = function()
    			GameData.setDiamondCount(GameData.getDiamondCount() - 1)
    			self:promptPlay()
    		end
    		require("app.views.NoticeTip").new("提示需要消耗1个钻石哦！", nil, callFunc)
    	else
    		require("app.views.NoticeTip").new("钻石不足！", nil, nil, true)
    	end
    	
    end)

	local helpBtn = _mutils.seekNodeByName(self.csb, "Button_back")
    _mutils.addBtnPressedListener(helpBtn, function()
    	_netMsg.clickOtherBtn("help")
    	require("app.views.HelpLayer").new()
    end)

    local okFunc = function()
    	self.playPokerLayer:removeAllChildren()

    	self:initObjectsOnPokerLayer()
    end

    local replayBtn = _mutils.seekNodeByName(self.csb, "Button_replay")
    _mutils.addBtnPressedListener(replayBtn, function()
    	_netMsg.clickOtherBtn("replay")
    	require("app.views.NoticeTip").new("确定要重新开始？",nil , okFunc)
    end)

    local okFunc_back = function()
    	self:getApp():enterScene("MainScene")
    end

    local cancleFunc = function()
    	self:startTimer()
    end

    local pauseBtn = _mutils.seekNodeByName(self.csb, "Button_stop")
    _mutils.addBtnPressedListener(pauseBtn, function()
    	_netMsg.clickOtherBtn("pause")
    	self:removeTimeHandler()
    	require("app.views.NoticeTip").new("是否需要返回主页？",cancleFunc , okFunc_back)
    end)


    local setBtn = _mutils.seekNodeByName(self.csb, "Button_setting")
    _mutils.addBtnPressedListener(setBtn, function()
    	_netMsg.clickOtherBtn("shezhi")
    	require("app.views.SettingLayer").new()
    end)

end

function GameScene:initLeftOpactyBtn()
	local leftSp = cc.Sprite:create("gamescene/sp_left.png")
	leftSp:setPosition(PokerReferPos.left.hold)
	leftSp:setScale(0.6)
	self.leftSp = leftSp
	self.playPokerLayer:addChild(leftSp)


	local leftBtn = ccui.Button:create("poker/sp_hold.png", "poker/sp_hold.png", "poker/sp_hold.png", ccui.TextureResType.localType)
	leftBtn:setPosition(PokerReferPos.left.hold)
	leftBtn:setOpacity(0)
	leftBtn:setScale(0.6)
	
	self.playPokerLayer:addChild(leftBtn,Zorder.LEFT_BTN)
	leftBtn:onTouch(function(event)
		if event.name == "ended" then
			print("left show new poker ")
			leftBtn:setTouchEnabled(false)
			self:leftPokerToShowTab()
			performWithDelay(leftBtn,function()
				leftBtn:setTouchEnabled(true)
			end,0.2)
		end
	end)
end

function GameScene:leftPokerToShowTab()
	local leftCounts = #self.leftPokers
	local showCounts = #self.leftShowPokers
	if leftCounts == 0 and showCounts == 0 then
		return
	end

	if leftCounts > 0 then
		self.leftPokers[leftCounts]:hideBack()
		self.leftPokers[leftCounts]:setZOrder(50)
		table.insert(self.leftShowPokers, self.leftPokers[leftCounts])
		self:moveToPos(self.leftPokers[leftCounts], 0.2, PokerReferPos.left.show.x + 60, PokerReferPos.left.show.y)
		
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(function()
			table.remove(self.leftPokers,leftCounts)
			self:updateShowPokers()
		end)))
		return
	end

	
	if showCounts > 0 then
		for i,v in ipairs(self.leftShowPokers) do
			table.insert(self.leftPokers, v)
			self:moveToPos(v,0.2,PokerReferPos.left.hold.x,PokerReferPos.left.hold.y)
			v:showBack()
		end
	end
	self.leftShowPokers = {}
end

function GameScene:moveToPos(node, time, x, y)
	if not node then print("moveto---->") return end
	print("moveto---->2")
	local order = node:getZOrder()
	node:setZOrder(Zorder.TOUCH)
	local action = cc.MoveTo:create(time,cc.p(x,y))
	node:runAction(action)

	performWithDelay(node,function()
		node:setZOrder(order)
	end,time)
end


function GameScene:updateShowPokers()
	local showPos = PokerReferPos.left.show
	local posx = showPos.x
	local posy = showPos.y
	local spaceX = PokerReferPos.left.show_spaceX

	local counts = #self.leftShowPokers

	local starIndex = counts - 3 --> 0 and counts - 3 or 0

	for i,v in ipairs(self.leftShowPokers) do
		v:setZOrder(i)
		v:setPosition(posx + (i-1) * spaceX, posy)


		if counts > 3 then
			local starIndex = counts - 3
			if i <= counts - 3 then
				v:setPosition(showPos)
			else
				v:setPosition(posx + (i-starIndex-1) * spaceX, posy)
			end
		else
			v:setPosition(posx + (i-1) * spaceX, posy)
		end

	end
end

function GameScene:initRightHold()
	for i=1,4 do
		local sprite = cc.Sprite:create(PokerHold[i])
		sprite:setPosition(PokerReferPos.right[i])
		self.playPokerLayer:addChild(sprite)

		table.insert(self.sortHold, sprite)
		local temp = {}
		table.insert(self.sortPokers, temp)
	end
end

function GameScene:initTopHold()
	for i=1,Top_Line do
		local sp_hold = cc.Sprite:create("gamescene/sp_top.png")
		sp_hold:setScale(0.6)
		sp_hold:setPosition(PokerReferPos.top.startPosX + (i-1)* PokerReferPos.top.spaceX, PokerReferPos.top.startPosY)
		self.playPokerLayer:addChild(sp_hold)
		table.insert(self.topHold, sp_hold)
	end
end

function GameScene:initAllPokersData()
	local randomTab = PokerManager.getRandomData()

	for i=1,#randomTab do
		local v = randomTab[i]
		local poker = Poker.new(v._color,v._number)
		table.insert(self.pokerObjects, poker)
	end

	for i,v in ipairs(self.pokerObjects) do
		v:setScale(0.6)
		self.playPokerLayer:addChild(v)
		v:setPosition(640,100)
	end

	--发牌
	local index = 0
	for i=1,Top_Line do
		local temp = {}
		for j=1,i do
			index = index + 1
			print("index---->",index)
			table.insert(temp,self.pokerObjects[index])
			local top = PokerReferPos.top
			self:moveAction(0, temp[j], 0.1*j, top.startPosX + (i-1)*top.spaceX, top.startPosY-(j-1)*top.spaceY, j==i)
		end
		table.insert(self.topPokers, temp)

	end
	local leftPos = PokerReferPos.left
	
	for i=index+1,#self.pokerObjects do
		table.insert(self.leftPokers, self.pokerObjects[i])
		self:moveAction(0.2, self.pokerObjects[i],(i-index)*0.08, leftPos.hold.x, leftPos.hold.y)
	end
	dump(self.topPokers, "self.topPokers--->")
	dump(self.leftPokers, "self.leftPokers--->")
end

function GameScene:moveAction(delay, node, time, toX, toY, isshow)
	local delay_action = cc.DelayTime:create(delay)
	local motoAc = cc.MoveTo:create(time,cc.p(toX,toY))
	node:runAction(cc.Sequence:create(delay_action, motoAc, cc.CallFunc:create(function()
		if isshow then
			--翻牌动作
			node:turnCard()
		end
	end)))
end

function GameScene:touchPlayerPoker(touch)
	--遍历两个数组
	for i,v in ipairs(self.topPokers) do
		for k=#v, 1, -1 do
			local poker = v[k]
			local touchPoint = poker.m_force:convertToNodeSpace(touch)
			local pokerSize = poker.m_force:getContentSize()

			local pokerRect = cc.rect(0, 0, pokerSize.width, pokerSize.height)
			if cc.rectContainsPoint(pokerRect, touchPoint) then
				return poker, k, v
			end
		end
		
	end
	for i=#self.leftShowPokers, 1, -1 do
		local poker = self.leftShowPokers[i]
		local touchPoint = poker.m_force:convertToNodeSpace(touch)
		local pokerSize = poker.m_force:getContentSize()

		local pokerRect = cc.rect(0, 0, pokerSize.width, pokerSize.height)
		if cc.rectContainsPoint(pokerRect, touchPoint) then
			return poker, i, self.leftShowPokers
		end
	end

	return nil
end

function GameScene:onTouchBegan(touch, event)
	local touchPoker, pokerIndex, pokerTab = self:touchPlayerPoker(touch:getLocation())
	if not touchPoker or not touchPoker:getShowStatus() or not self:pokerIsLastInLeftShow(pokerIndex, pokerTab) then
		print("no poker--->")
		return false
	end
	print("onTouchBegan true---->")

	local index = self:getIndexPokerInTopList(touchPoker, pokerTab) or #pokerTab

	print("调试到这里了---->,我要找移动的一组牌----------------->",index)

	self.choosePoker = touchPoker --点击的牌
	self.allChoosePokers = {}	--点击时，跟随的扑克
	self.choosePoker:setZOrder(Zorder.TOUCH)
	self.pokerInTab		= 	pokerTab


	for i=index,#pokerTab do
		table.insert(self.allChoosePokers, pokerTab[i])
	end

	for i,v in ipairs(self.allChoosePokers) do
		v:setZOrder(Zorder.TOUCH)
	end

	return true
end

function GameScene:onTouchMoved(touch, event)
	local moveTouchPoint = self.playPokerLayer:convertToNodeSpace(touch:getLocation())
	for i,v in ipairs(self.allChoosePokers) do
		v:setPosition(moveTouchPoint.x , moveTouchPoint.y - (i-1)* PokerReferPos.top.spaceY)
	end
end

function GameScene:onTouchEnded(touch, event)
	--扑克落位处理
	self:pokerToPos()
end

function GameScene:pokerToPos()
	local number,color = self.choosePoker:getPoker()
	local poker_moved = false
	
	--真正的落位，选中的扑克要与目标扑克有交集
	--top时，颜色不同，number由大到小
	--sort时，类型相同，number有小到大

	--先遍历寻找目标扑克
	--遍历top
	for i,v in ipairs(self.topPokers) do
		local v_counts = #v
		if v_counts > 0 then
			local targetPoker = v[v_counts]
			
			local isIntersects = self:pokerIntersectsPoker(self.choosePoker, targetPoker)
			local canDownTop = self:canSortInTop(self.choosePoker, targetPoker)

			if isIntersects and canDownTop then
				self:movePokersData(v)
				poker_moved = true
				self:updateOneTopPokers()
				self:showNewPoker(self.pokerInTab)
				return
			end
		elseif v_counts == 0 then
			local targetPoker = self.topHold[i]
			local isIntersects = self:pokerIntersectsPokerFor_K(self.choosePoker, targetPoker)
			local canDownTop = self.choosePoker:getPoker() == 13
			if isIntersects and canDownTop then
				self:movePokersData(v)
				poker_moved = true
				self:updateOneTopPokers()
				self:showNewPoker(self.pokerInTab)
				return
			end
		end
	end

	for i,v in ipairs(self.sortHold) do
		if i == (color + 1) and number == #self.sortPokers[i]+1 then
			table.insert(self.sortPokers[i], self.choosePoker)
			self.choosePoker:setZOrder(number)
			self:moveToPos(self.choosePoker, 0.2,v:getPositionX(), v:getPositionY())
			poker_moved = true

			table.remove(self.pokerInTab)

			self:showNewPoker(self.pokerInTab)
			break
		end
	end

	if not poker_moved then
		self:updateOneTopPokers()
		self:updateShowPokers()
	end

	self:checkGameSuccess()
end

function GameScene:movePokersData(targetList)
	for i,v in ipairs(self.allChoosePokers) do
		table.insert(targetList, v)
		table.remove(self.pokerInTab)
	end
end

function GameScene:updateOneTopPokers()
	local top = PokerReferPos.top
	for i,v in ipairs(self.topPokers) do
		for k,vv in ipairs(v) do
			vv:setZOrder(i)
			vv:setPosition(top.startPosX + (i-1)*top.spaceX, top.startPosY-(k-1)*top.spaceY)
		end
	end
end

function GameScene:pokerIntersectsPoker(touchPoker, targetPoker)

	if touchPoker:getFileName() == targetPoker:getFileName() then
		return false
	end

	local isIntersects = false
	local pokerSize = targetPoker.m_force:getContentSize()

	local pos = targetPoker:convertToWorldSpace(cc.p(0,0))
	local tarRect = cc.rect(pos.x, pos.y, pokerSize.width*0.6, pokerSize.height*0.6)
	local choosePos = touchPoker:convertToWorldSpace(cc.p(0,0))
	local touchRect = cc.rect(choosePos.x, choosePos.y, pokerSize.width*0.6, pokerSize.height*0.6)

	return cc.rectIntersectsRect(touchRect, tarRect)
end

function GameScene:pokerIntersectsPokerFor_K(touchPoker,targetPoker)
	local isIntersects = false

	local pokerSize = targetPoker:getContentSize()

	local pos = targetPoker:convertToWorldSpace(cc.p(0,0))
	local tarRect = cc.rect(pos.x + pokerSize.width*0.6/2, pos.y + pokerSize.height*0.6/2, pokerSize.width*0.6, pokerSize.height*0.6)
	local choosePos = touchPoker:convertToWorldSpace(cc.p(0,0))
	local touchRect = cc.rect(choosePos.x, choosePos.y, pokerSize.width*0.6, pokerSize.height*0.6)

	return cc.rectIntersectsRect(touchRect, tarRect)
end

--颜色相同的不能移动过来，不是按降序的不能移动过来
function GameScene:canSortInTop(touchPoker, targetPoker)
	local number, color = touchPoker:getPoker()
	local numberTar, colorTar = targetPoker:getPoker()
	if color%2 == colorTar % 2 then
		return false
	end 

	if number + 1 ~= numberTar then
		return false
	end

	return true
end

function GameScene:showNewPoker(tab)
	if #tab == 0 then
		return
	end

	if self:isLeftShowTab(tab) then
		self:updateShowPokers()
	else
		if not tab[#tab]:getShowStatus() then
			tab[#tab]:turnCard()
		end
	end
end

function GameScene:isLeftShowTab(tab)
	if #self.leftShowPokers == 0 then
		return false
	end 
	for k,v in pairs(self.leftShowPokers) do
		if tab[1]:getFileName() == v:getFileName() then
			return true
		end
	end
	return false
end

function GameScene:pokerIsLastInLeftShow(index, list)
	if self:isLeftShowTab(list) then
		if index ~= #list then
			return false
		end
	end

	return true
end

function GameScene:getIndexPokerInTopList(poker, list)
	if not poker or #list == 0 or self:isLeftShowTab(list) then
		return
	end
	for i,v in ipairs(list) do
		if poker:getFileName() == v:getFileName() then
			return i
		end
	end
end

function GameScene:checkGameSuccess()
	local isSuccess = true
	for i,v in ipairs(self.sortPokers) do
		if #v ~= 13 then
			isSuccess = false
			break
		end
	end
	if isSuccess then
		--成功代码
    	local callFunc = function()
	    	if GameData.getCurrentLevel() == GameData.getLevel() and GameData.getLevel() < 8 then
				GameData.setLevel(GameData.getLevel() + 1) 
			end
			self:getApp():enterScene("MainScene")
		end
		self:removeTimeHandler()
		require("app.views.SuccessLayer").new(true, "奖励剩余时间:"..self.timeLabel:getString(), nil, callFunc)
	end
end
--提示按钮
function GameScene:promptPlay()
	print("GameScene:promptPlay----->")
	--先找top组的最后一张，是否有直接sort的牌，没有的话，在找top内是否有可移动的牌，
	for i,v in ipairs(self.topPokers) do
		if #v > 0 then
			local poker = v[#v]
			local number,color = poker:getPoker()
			for k,m in ipairs(self.sortPokers) do
				if k == (color + 1) and  number == #m + 1 then
					print(poker:getFileName() .. "    can moveto right")
					local tempList = {}
					table.insert(tempList, poker)
					local oldX,oldY = poker:getPosition()
					local newX,newY = self.sortHold[k]:getPosition()
					self:promptMoveTo(tempList, oldX, oldY, newX, newY)
					return
				end
			end
		end
	end

	--在找左侧展示的牌是否有可以入sort的扑克
	local count = #self.leftShowPokers
	if count > 0 then
		local poker = self.leftShowPokers[count]
		local number,color = poker:getPoker()
		for i,v in ipairs(self.sortPokers) do
			if i == (color + 1) and number == #v + 1 then
				local tempList = {}
				table.insert(tempList, poker)
				local oldX,oldY = poker:getPosition()
				local newX,newY = self.sortHold[i]:getPosition()
				self:promptMoveTo(tempList, oldX, oldY, newX, newY)
				return
			end
		end

		if self:canMoveArray(poker, count, self.leftShowPokers) then
			return
		end
	end

	--遍历top有没有可以移动的一组牌
	for i,v in ipairs(self.topPokers) do
		local firstShow = false
		for k,m in ipairs(v) do
			if m:getShowStatus() then
				if not firstShow then
					firstShow = true
					if self:canMoveArray(m, k, v) then 
						return 
					end
				end
			end
		end
	end

	--K暂时不处理

	local have_hold = false
	local index_empty = nil
	for i,v in ipairs(self.topPokers) do
		if #v == 0 then
			have_hold = true
			index_empty = i
			break
		end
	end
	if have_hold then
		local count = #self.leftShowPokers
		if count > 0 and self.leftShowPokers[count]:getPoker() == 13 then
			local tempList = {}
			table.insert(tempList, self.leftShowPokers[count])
			local oldX,oldY = self.leftShowPokers[count]:getPosition()
			local newX,newY = self.topHold[index_empty]:getPositionX(), self.topHold[index_empty]:getPositionY()
			self:promptMoveTo(tempList, oldX, oldY, newX, newY)
			return
		end

		--遍历top找K
		local function find_K( ... )
			for i,v in ipairs(self.topPokers) do
				for k,m in ipairs(v) do
					if k > 1 and m:getPoker() ==13 and m:getShowStatus() then
						return i, k, v
					end
				end
			end
		end

		local row, index, list = find_K()
		if row and index then
			local poker = list[index]
			local tempList = {}
			for i=index,#list do
				table.insert(tempList, list[i])
			end
			local oldX,oldY = poker:getPosition()
			local newX,newY = self.topHold[index_empty]:getPositionX(), self.topHold[index_empty]:getPositionY()
			self:promptMoveTo(tempList, oldX, oldY, newX, newY)
			return
		end
	end

	--提示打开未展示的牌
	if #self.leftPokers > 0 then
		local count = #self.leftPokers
		local poker = self.leftPokers[count]
		local tempList = {}
		table.insert(tempList, poker)
		local oldX,oldY = poker:getPosition()
		local newX,newY = PokerReferPos.left.show.x, PokerReferPos.left.show.y
		self:promptMoveTo(tempList, oldX, oldY, newX, newY)
		return
	end

	--提示将展示的牌放回原处，重新翻开
	if #self.leftPokers == 0 and #self.leftShowPokers > 1 then
		-- print("循环剩余的牌---------------->")
		local action = cc.ScaleBy:create(0.1,1.1,1.1)
		self.leftSp:runAction(cc.Sequence:create(action, action:reverse()))
		return
	end


	-- print("没有可以移动的牌了-------------------->")

	require("app.views.NoticeTip").new("没有可以移动的牌了,重新开始吧",nil,function()
		self.playPokerLayer:removeAllChildren()
		self:initObjectsOnPokerLayer()
	end,true)

end

function GameScene:canMoveArray(poker, index, list)
	local number,color = poker:getPoker()
	local can_down = false
	local targetPoker = nil
	for i,v in ipairs(self.topPokers) do
		if #v > 0 then
			can_down = self:canSortInTop(poker, v[#v])
			if can_down then
				targetPoker = v[#v]
				print("targetPoker--->,",targetPoker:getFileName())
				break
			end
		end
	end

	if can_down then
		local tempList = {}
		for i=index,#list do
			table.insert(tempList, list[i])
		end
		local oldX,oldY = poker:getPosition()
		local newX,newY = targetPoker:getPositionX(), targetPoker:getPositionY() - PokerReferPos.top.spaceY

		self:promptMoveTo(tempList, oldX, oldY, newX, newY)
	end

	return can_down
end

function GameScene:promptMoveTo(list, oldX, oldY, newX, newY)
	print("promptMoveTo---->")
	local time = 0.2
	for i,v in ipairs(list) do
		local pos_newY = newY - (i-1) * PokerReferPos.top.spaceY
		local pos_oldY = oldY - (i-1) * PokerReferPos.top.spaceY
		local action_to_new = cc.MoveTo:create(time, cc.p(newX, pos_newY))
		local action_to_old = cc.MoveTo:create(time, cc.p(oldX, pos_oldY))
		local order = v:getZOrder()
		v:setZOrder(Zorder.TOUCH)
		v:runAction(cc.Sequence:create(action_to_new,action_to_old))
		performWithDelay(v, function ( ... )
			v:setZOrder(order)
		end,time * 2)
	end
end


function GameScene:startTimer()
	if not self.timeHandler then
		self.timeHandler = _schedule:scheduleScriptFunc(handler(self,self.updateTimer), 1, false)
		if not self.startTime then
			self.startTime = Max_Time
		end
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

function GameScene:showFailedLayer()
	--失败代码
	local callFunc = function()
		self:getApp():enterScene("MainScene")
	end

	local callFunc_re = function()
		self.playPokerLayer:removeAllChildren()
		self:initObjectsOnPokerLayer()
	end
	self:removeTimeHandler()
	require("app.views.SuccessLayer").new(false, "不要放弃，继续哟！", callFunc, callFunc_re)
end

function GameScene:removeTimeHandler()
	if self.timeHandler then
		_schedule:unscheduleScriptEntry(self.timeHandler)
		self.timeHandler = nil
	end
end

function GameScene:timeToString(_time)
	local h = math.floor(_time / 3600)
	local m = math.floor((_time % 3600) / 60)
	local s = math.floor((_time % 3600) % 60)
	return string.format("%02d:%02d:%02d", h, m, s)
end

function GameScene:onExit()
	self:removeTimeHandler()
end

return GameScene