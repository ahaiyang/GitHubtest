
local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'


local max_row = 7
local GameScene = class("GameScene", cc.load("mvc").ViewBase)
GameScene.RESOURCE_FILENAME = "GameScene.csb"
function GameScene:onCreate()
	_netMsg.clickOtherBtn("gamescene")
    local csb = self:getResourceNode()
    csb:setPositionY(_mutils.getAddH()/2)
    self.csb = csb

    self:initButtons()
    self:initUI()

    self.step_count = 0
    self:initStep()
end

function GameScene:initStep()
	
	self.step_label = _mutils.seekNodeByName(self.csb, "step_right")
	self.step_label:setString("Step:"..self.step_count)
end

function GameScene:initUI()
	self.bg = _mutils.seekNodeByName(self.csb, "Panel_bg")
	self.bg:setSwallowTouches(false)

	local startX = 640
	local startY = 670
	local spaceX = 76
	local spaceY = 62
	

	self.posTab = {}
	self.dices 	= {}

	self.redDices = {}
	self.blueDices = {}

	for i=1,49 do
		
		local row_num = math.floor(i / max_row) + 1
		if i % max_row == 0 then
			row_num = row_num - 1
		end

		local cow_num = i % max_row
		if cow_num == 0 then
			cow_num = max_row
		end

		local dice = ccui.ImageView:create("gamescene/ico_blue.png")
		dice:setPosition(startX - (row_num-1)*spaceX + (row_num-1)*4 + (cow_num-1)*spaceX,startY - (cow_num-1)*spaceY -(row_num-1)*spaceY-(row_num-1)*1)
		self.bg:addChild(dice)

		local temp = {}
		temp.validPos = true
		temp.haveDice = true
		if (row_num <= 3 and cow_num<=3) or (row_num >=5 and cow_num>=5) or (row_num == cow_num) then
			dice:setVisible(false)
			temp.haveDice = false
		end 

		if (row_num <= 3 and cow_num<=3) or (row_num >=5 and cow_num>=5) then
			temp.validPos = false
		end

		temp.pos = cc.p(dice:getPositionX(),dice:getPositionY())
		table.insert(self.posTab, temp)

		if dice:getPositionX() < 640 then
			dice:loadTexture("gamescene/ico_red.png")
			dice:setName("red")
		elseif dice:getPositionX() > 640 then
			dice:setName("blue")
		end
		dice:setTag(i)
		table.insert(self.dices, dice)
		dice:setTouchEnabled(true)
		
		dice:addTouchEventListener(function(sender,eventType)
			if eventType == ccui.TouchEventType.ended then
				
				self:checkPos(self.dices[i])
			end
		end)

	end

	for i,v in ipairs(self.dices) do
		if v:getName() == "red" and v:isVisible() then
			table.insert(self.redDices, v)
		elseif v:getName() == "blue" and v:isVisible() then
			table.insert(self.blueDices, v)
		end
	end
end

function GameScene:checkPos(dice)
	local kong_row
	local kong_cow
	local cur_row
	local cur_cow

	cur_row = math.floor(dice:getTag() / max_row) + 1
	if dice:getTag() % max_row == 0 then
		cur_row = cur_row - 1
	end

	cur_cow = dice:getTag() % max_row
	if cur_cow == 0 then
		cur_cow = max_row
	end

	for i,v in ipairs(self.posTab) do
		if v.validPos == true and v.haveDice == false then
			kong_row = math.floor(i / max_row) + 1
			if i % max_row == 0 then
				kong_row = kong_row - 1
			end

			kong_cow = i % max_row
			if kong_cow == 0 then
				kong_cow = max_row
			end

			if ((kong_row == cur_row) and math.abs(kong_cow - cur_cow) <= 2) or
				((kong_cow == cur_cow) and math.abs(kong_row - cur_row) <= 2) then
				dice:setPosition(v.pos)
				v.haveDice = true
				self.posTab[dice:getTag()].haveDice = false
				dice:setTag(i)

				self.step_count = self.step_count + 1
				self:initStep()


				if self:checkGameSuccess() then
					local callback1 = function()
						self:getApp():enterScene("GameScene")
					end
					local callback2 = function()
						self:getApp():enterScene("MainScene")
					end
					require("app.views.ResoultLayer").new(callback1, callback2)
				end
				break
			else
				print("不能移动--->")
			end
		end
	end
end

function GameScene:checkGameSuccess()
	for i,v in ipairs(self.redDices) do
		if v:getPositionX() < 640 then
			print("红色未完成---->")
			return false
		end
	end
	for i,v in ipairs(self.blueDices) do
		if v:getPositionX() > 640 then
			print("蓝色未完成---->")
			return false
		end
	end
	print("game success")
	return true
end

function GameScene:initButtons()
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
		require("app.views.HelpLayer").new("单人玩法：每次只能移动一个骰子，直到两边的骰子全部互换位置，完成游戏。")
	end)

end

return GameScene
