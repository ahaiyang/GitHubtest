local _mutils       = require 'app.utils.MUtils'

local SelectLevelLayer = class("SelectLevelLayer", cc.Node)

function SelectLevelLayer:ctor()
	local csb = cc.CSLoader:createNode("SelectLevelLayer.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)


	local btn_close = _mutils.seekNodeByName(csb, "btn_close")
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	for i=1,4 do
		local btn = _mutils.seekNodeByName(csb, "Button_"..i)
		_mutils.addBtnPressedListener(btn, function( ... )
			self:closeSelf()
		end)
	end
end

function SelectLevelLayer:closeSelf()
	self:removeFromParent()
end

return SelectLevelLayer