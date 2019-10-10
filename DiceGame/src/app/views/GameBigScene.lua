
local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'
local GameData 		= require 'app.views.GameData'

local max_row = 10
local GameBigScene = class("GameBigScene", cc.load("mvc").ViewBase)
local BigCfg = require("app.views.BigSceneCfg")

local DiceType = {
	["red"] 	= "gamebigsecne/ico_hong.png",
	["blue"] 	= "gamebigsecne/ico_lan.png",
	["yellow"] 	= "gamebigsecne/ico_huang.png",
}

GameBigScene.RESOURCE_FILENAME = "GameBigScene.csb"
function GameBigScene:onCreate()
	_netMsg.clickOtherBtn("gamebigscene")
    local csb = self:getResourceNode()
    csb:setPositionY(_mutils.getAddH()/2)
    self.csb = csb

    self:initButtons()
    self:initUI()
    self:initStepCount()
end

function GameBigScene:initButtons()
	local Button_set 	= _mutils.seekNodeByName(self.csb, "Button_set")
	local Button_exit 	= _mutils.seekNodeByName(self.csb, "Button_exit")
	local Button_rule 	= _mutils.seekNodeByName(self.csb, "Button_rule")
	_mutils.addBtnPressedListener(Button_set,function()
		require("app.views.SettingLayer").new()
	end)

	_mutils.addBtnPressedListener(Button_exit,function()
		self:getApp():enterScene("MainScene")
	end)

	_mutils.addBtnPressedListener(Button_rule, function()
		require("app.views.HelpLayer").new("互动模式，两个玩家对垒，每次只能移动一个骰子，且只能移动一个平行的格子，先全部占领对方的阵营的玩家胜出。")
	end)
end

function GameBigScene:initStepCount()
	self.leftCount	 = 0 
	self.rightCount  = 0
	local Colors = {
		red 	= cc.c3b(255,0,0),
		blue 	= cc.c3b(88,186,246),
		yellow 	= cc.c3b(255,255,0),
	}

	self.step_left = _mutils.seekNodeByName(self.csb, "step_left")
	self.step_left:setFontSize(34)
	self.step_left:setColor(Colors[GameData:getPlayerLeftColor()])

	self.step_right = _mutils.seekNodeByName(self.csb, "step_right")
	self.step_right:setFontSize(34)
	self.step_right:setColor(Colors[GameData:getPlayerRightColor()])
end

function GameBigScene:initUI()
	self.bg = _mutils.seekNodeByName(self.csb, "Panel_bg")
	self.bg:setSwallowTouches(false)
	local posTab = BigCfg.posTab
	local validTab = BigCfg.valid
	for i,v in ipairs(posTab) do
		local hold = ccui.ImageView:create("gamebigsecne/hold.png")
		hold:setPosition(posTab[i])
		self.bg:addChild(hold)
		hold:setOpacity(0)

		local row = math.floor((i-1) / 10) + 1
		local cow = (i-1)%10 + 1
		hold:setVisible(validTab[row][cow] == 1)
		hold:setTouchEnabled(true)
		hold:addTouchEventListener(function(sender, eventType )
			if eventType == ccui.TouchEventType.ended then
				print("holdtag---->",i)
				self:checkDownPos(i)
			end
		end)
	end

	self:addPlayerDices()
end

function GameBigScene:addPlayerDices()
	local havedice = BigCfg.havedice
	local posTab = BigCfg.posTab
	self.leftDices = {}
	self.rightDices = {}
	self.posDices = {}
	for i=1,10 do
		local diceName = DiceType[GameData.getPlayerRightColor()]
		if i > 5 then
			diceName = DiceType[GameData.getPlayerLeftColor()]
		end

		for k=1,10 do
			local temp = {}
			temp.have = false
			if havedice[i][k] == 1 then
				local dice = ccui.ImageView:create(diceName)
				self.bg:addChild(dice)
				dice:setTag((i-1)*10 + k)
				dice:setPosition(posTab[(i-1)*10+k])

				if i > 5 then
					dice.Type = "player1"
					table.insert(self.leftDices, dice)
				else
					dice.Type = "player2"
					table.insert(self.rightDices, dice)
				end
				temp.have = true

				dice:setTouchEnabled(true)
				dice:addTouchEventListener(function(sender, eventType)
					if eventType == ccui.TouchEventType.ended then
						print("tag---->",sender:getTag())

						self:selectCurrentDice(sender)
					end
				end)
			end
			table.insert(self.posDices, temp)


		end
	end 
	-- dump(self.posDices, "self.posDices---->")
end

function GameBigScene:selectCurrentDice(dice)
	self.currentDice = dice
end

function GameBigScene:checkDownPos(index)
	print("index---->",index)
	print("have---->",self.posDices[index].have)

	if not self.currentDice then
		return
	end

	local canRun = false
	local tag = self.currentDice:getTag()
	local row1 = math.floor((tag-1)/max_row) + 1
	local cow1 = tag%max_row == 0 and max_row or tag%max_row

	local row2 = math.floor((index-1)/max_row) + 1
	local cow2 = index%max_row == 0 and max_row or index%max_row
	if (row1 == row2 and math.abs(cow1 - cow2) == 1) or
		(cow1 == cow2 and math.abs(row1 - row2) == 1) then
		canRun = true
	end


	if self.currentDice and self.posDices[index].have == false and canRun then
		self.currentDice:setPosition(BigCfg.posTab[index])
		self.posDices[index].have = true
		self.posDices[self.currentDice:getTag()].have = false
		self.currentDice:setTag(index)
		

		self:checkSuccess()
		self:addSteps()

		self.currentDice = nil
	end
end

function GameBigScene:addSteps()
	if self.currentDice.Type == "player1" then
		self.leftCount = self.leftCount + 1
		self.step_left:setString("Step:"..self.leftCount)
	elseif self.currentDice.Type == "player2" then
		self.rightCount = self.rightCount + 1
		self.step_right:setString("Step:"..self.rightCount)
	end
end

function GameBigScene:checkSuccess()
	local leftWin = true
	local rightWin = true
	for i,v in ipairs(self.rightDices) do
		if v:getPositionX() > BigCfg.posTab[51].x then
			leftWin = false
			break
		end
	end

	for i,v in ipairs(self.leftDices) do
		if v:getPositionX() < BigCfg.posTab[6].x then
			rightWin = false
			break
		end
	end

	local callback1 = function()
		self:getApp():enterScene("GameBigScene")
	end
	local callback2 = function()
		self:getApp():enterScene("MainScene")
	end

	if leftWin then
		require("app.views.ResoultLayer").new(callback1, callback2,GameData.getPlayerRightColor())
	elseif rightWin then
		require("app.views.ResoultLayer").new(callback1, callback2,GameData.getPlayerLeftColor())
	else
		print("双方继续---->")
	end
end

return GameBigScene