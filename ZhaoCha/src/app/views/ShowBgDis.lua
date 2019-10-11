
local _mutils       = require 'app.utils.MUtils'
local ShowBgDis = class("ShowBgDis", cc.Node)
local _netMsg 		= require 'app.utils.NetMsg'
function ShowBgDis:ctor(index)

	_netMsg.clickOtherBtn("gamescene")
	local csb = cc.CSLoader:createNode("ShowBgDis.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)

	local bg = _mutils.seekNodeByName(csb, "Image_bg")

	local btn_close = _mutils.seekNodeByName(csb, "Button_close")
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	_mutils.seekNodeByName(csb, "Image_show"):loadTexture("pictures/lv_"..index.. ".png")

end

function ShowBgDis:closeSelf()
	self:removeFromParent()
end

return ShowBgDis