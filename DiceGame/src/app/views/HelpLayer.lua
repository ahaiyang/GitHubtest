
local _mutils       = require 'app.utils.MUtils'
local HelpLayer = class("HelpLayer",cc.Node)

function HelpLayer:ctor(content)
	self.csb = cc.CSLoader:createNode("HelpLayer.csb")
	self:addChild(self.csb)
	self.csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)

	self:initButtons()

	if content then
		_mutils.seekNodeByName(self.csb, "Text_all"):setString(content)
	end
	
end

function HelpLayer:initButtons()
	local btn_close = _mutils.seekNodeByName(self.csb, "btn_close")
	
	btn_close:setTouchEnabled(true)
	_mutils.addBtnPressedListener(btn_close, function(sender)
        self:removeFromParent()
    end)
end


return HelpLayer