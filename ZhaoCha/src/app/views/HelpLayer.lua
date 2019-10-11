
local _mutils       = require 'app.utils.MUtils'

local HelpLayer = class("HelpLayer", cc.Node)

function HelpLayer:ctor()
	local csb = cc.CSLoader:createNode("HelpLayer.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)

	local bg = _mutils.seekNodeByName(csb, "Image_bg")

	local btn_close = _mutils.seekNodeByName(csb, "Button_close")
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

end

function HelpLayer:closeSelf()
	self:removeFromParent()
end

return HelpLayer