
local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
MainScene.RESOURCE_FILENAME = "MainScene.csb"
function MainScene:onCreate()
    local csb = self:getResourceNode()
    csb:setPositionY(_mutils.getAddH()/2)
    self.csb = csb

    self:initButtons()

end

function MainScene:initButtons()
	local btn_start 	= _mutils.seekNodeByName(self.csb, "Button_start")
	local btn_hudong 	= _mutils.seekNodeByName(self.csb, "Button_hudong")
	local Button_set 	= _mutils.seekNodeByName(self.csb, "Button_set")
	local Button_help 	= _mutils.seekNodeByName(self.csb, "Button_help")

	_mutils.addBtnPressedListener(btn_start,function()
		_netMsg.clickOtherBtn("start")
		self:getApp():enterScene("GameScene")
	end)
	_mutils.addBtnPressedListener(btn_hudong,function()
		_netMsg.clickOtherBtn("hudong")
		self:getApp():enterScene("ModelScene")
	end)
	_mutils.addBtnPressedListener(Button_set,function()
		_netMsg.clickOtherBtn("shezhi")
		require("app.views.SettingLayer").new()
	end)
	_mutils.addBtnPressedListener(Button_help,function()
		_netMsg.clickOtherBtn("help")
		require("app.views.HelpLayer").new()
	end)
end

return MainScene
