
local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'
local GameData 		= require 'app.views.GameData'

local MainScene = class("MainScene", cc.load("mvc").ViewBase)
MainScene.RESOURCE_FILENAME = "MainScene.csb"
function MainScene:onCreate()
    print("MainScene:onCreate---->")

    local csb = self:getResourceNode()
    csb:setPositionY(_mutils.getAddH()/2)
    self.csb = csb

    self:initButtons()
end

function MainScene:initButtons()
	local Button_level 			= _mutils.seekNodeByName(self.csb, "Button_level")
	local Button_help 			= _mutils.seekNodeByName(self.csb, "Button_help")
	local Button_continue 		= _mutils.seekNodeByName(self.csb, "Button_continue")
	local Button_start 			= _mutils.seekNodeByName(self.csb, "Button_start")
	local Button_shop 			= _mutils.seekNodeByName(self.csb, "Button_add")
	self.diamond_count			= _mutils.seekNodeByName(self.csb, "count_diamond")
	self.diamond_count:setString(GameData.getDiamondCount())
	
	_mutils.addBtnPressedListener(Button_level, function()
		_netMsg.clickOtherBtn("select")
		print(" select level---->")
		require("app.views.SelectLevelLayer").new()

	end)
	_mutils.addBtnPressedListener(Button_help, function()
		_netMsg.clickOtherBtn("help")
		require("app.views.HelpLayer").new()
	end)
	_mutils.addBtnPressedListener(Button_continue, function()
		-- _netMsg.clickOtherBtn("all")

	end)
	_mutils.addBtnPressedListener(Button_start, function()
		_netMsg.clickOtherBtn("start")

		local callBack = function()
			self:getApp():enterScene("GameScene")
		end
		require("app.views.LevelLayer").new(callBack)
		
	end)

	_mutils.addBtnPressedListener(Button_shop, function()
		_netMsg.clickOtherBtn("shop")
		require("app.views.ShopLayer").new()
	end)

end

function MainScene:updateDiamond()
	self.diamond_count:setString(GameData.getDiamondCount())
end

function MainScene:onEnter()
	print("MainScene:onEnter----->")
	self.listenerCustom = cc.EventListenerCustom:create("UPDATE_DIMIAMOND",handler(self,self.updateDiamond))
    local customEventDispatch=cc.Director:getInstance():getEventDispatcher()
    customEventDispatch:addEventListenerWithFixedPriority(self.listenerCustom, 1)
end

function MainScene:onExit()
	print("MainScene:onExit----->")
	cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listenerCustom)
end

return MainScene
