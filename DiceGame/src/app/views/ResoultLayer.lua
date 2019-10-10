local _netMsg 		= require 'app.utils.NetMsg'

local _mutils       = require 'app.utils.MUtils'

local ResoultLayer = class("ResoultLayer", cc.Node)

function ResoultLayer:ctor(callback1,callback2,winColor)
	local csb = cc.CSLoader:createNode("ResoultLayer.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)
	self.csb = csb
	self:initButtons(callback1,callback2)


	local title = {
		red 		= "resoult/tit_hfsl.png",
		blue  		= "resoult/tit_lfsl.png",
		yellow		= "resoult/tit_huangfsl.png"
	}
	if winColor then
		local img_title = _mutils.seekNodeByName(csb, "Image_title")
		img_title:loadTexture(title[winColor])
		img_title:ignoreContentAdaptWithSize(true)
	end

end

function ResoultLayer:initButtons(callback1,callback2)
	local Button_close 	= _mutils.seekNodeByName(self.csb, "Button_close")
	local Button_again = _mutils.seekNodeByName(self.csb, "Button_again")
	local Button_home 	= _mutils.seekNodeByName(self.csb, "Button_home")

	_mutils.addBtnPressedListener(Button_close, function()
		self:closeSelf()
		if callback1 then
			callback1
		end
	end)

	_mutils.addBtnPressedListener(Button_again, function()
		-- _netMsg.clickOtherBtn("tujian")
		if callback1 then
			callback1()
		end
	end)

	_mutils.addBtnPressedListener(Button_home, function()
		-- _netMsg.clickOtherBtn("paper")
		if callback2 then
			callback2()
		end
	end)
end

function ResoultLayer:closeSelf()
	self:removeFromParent()
end

return ResoultLayer