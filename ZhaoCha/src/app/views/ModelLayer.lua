
local _mutils       = require 'app.utils.MUtils'
local GameData   = require("app.views.GameData")
local _netMsg 		= require 'app.utils.NetMsg'
local ModelLayer = class("ModelLayer", cc.Node)

function ModelLayer:ctor(callback)
	local csb = cc.CSLoader:createNode("ModelLayer.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)


	local btn_close = _mutils.seekNodeByName(csb, "Button_close")
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	local lvBtn = _mutils.seekNodeByName(csb, "Button_LV")
	local timeBtn = _mutils.seekNodeByName(csb, "Button_Time")
	_mutils.addBtnPressedListener(lvBtn, function()
		GameData.TYPE = GameData.Model.LEVELMODEL
		_netMsg.clickOtherBtn("level")
		self:closeSelf()
		require("app.views.SelectLayer").new(callback)
	end)

	_mutils.addBtnPressedListener(timeBtn, function()
		GameData.TYPE = GameData.Model.TIMEMODEL
		_netMsg.clickOtherBtn("time")
		if callback then
			callback()
		end
	end)
end

function ModelLayer:closeSelf()
	self:removeFromParent()
end

return ModelLayer