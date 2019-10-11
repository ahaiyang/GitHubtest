


local _mutils       = require 'app.utils.MUtils'

local HelpLayer = class("HelpLayer", cc.Node)

function HelpLayer:ctor()
	local csb = cc.CSLoader:createNode("HelpLayer.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)


	local btn_close = _mutils.seekNodeByName(csb, "btn_close")
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	--内容
	local txt_help = _mutils.seekNodeByName(csb, "Text_help")
end

function HelpLayer:closeSelf()
	self:removeFromParent()
end

return HelpLayer