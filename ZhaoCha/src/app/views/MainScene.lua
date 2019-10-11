
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
	local Button_tujian 			= _mutils.seekNodeByName(self.csb, "Button_tujian")
	local Button_start 				= _mutils.seekNodeByName(self.csb, "Button_start")
	local Button_tongji 			= _mutils.seekNodeByName(self.csb, "Button_tongji")
	local Button_lianxi 			= _mutils.seekNodeByName(self.csb, "Button_lianxi")
	local Button_paihang 			= _mutils.seekNodeByName(self.csb, "Button_paihang")
	local Button_help 				= _mutils.seekNodeByName(self.csb, "Button_wanfa")
	
	_mutils.addBtnPressedListener(Button_tujian, function()
		_netMsg.clickOtherBtn("tujian")
		require("app.views.TujianLayer").new()
	end)
	_mutils.addBtnPressedListener(Button_start, function()
		_netMsg.clickOtherBtn("start")

		require("app.views.ModelLayer").new(function()
			self:getApp():enterScene("GameScene")
		end)
	end)
	_mutils.addBtnPressedListener(Button_tongji, function()
		_netMsg.clickOtherBtn("tongji")
		require("app.views.TongjiLayer").new()
	end)
	_mutils.addBtnPressedListener(Button_lianxi, function()
		_netMsg.clickOtherBtn("lianxi")
		require("app.views.FeedBack").new()
	end)

	_mutils.addBtnPressedListener(Button_paihang, function()
		_netMsg.clickOtherBtn("shezhi")
		require("app.views.SettingLayer").new()
	end)

	_mutils.addBtnPressedListener(Button_help, function()
		_netMsg.clickOtherBtn("help")
		require("app.views.HelpLayer").new()
	end)

end

return MainScene
