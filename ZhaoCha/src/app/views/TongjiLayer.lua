
local _mutils       = require 'app.utils.MUtils'
local GameData   = require("app.views.GameData")
local TongjiLayer = class("TongjiLayer", cc.Node)

function TongjiLayer:ctor(callback)
	local csb = cc.CSLoader:createNode("TongjiLayer.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)


	local btn_close = _mutils.seekNodeByName(csb, "Button_close")
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	local count = GameData.getLevevModel()

	_mutils.seekNodeByName(csb, "Text_MaxLevel"):setString(count.. "关")
	_mutils.seekNodeByName(csb, "Text_Tujian"):setString(count.. "张")
	_mutils.seekNodeByName(csb, "Text_Count"):setString(GameData.getPlayCounts().. "关")
end

function TongjiLayer:closeSelf()
	self:removeFromParent()
end

return TongjiLayer