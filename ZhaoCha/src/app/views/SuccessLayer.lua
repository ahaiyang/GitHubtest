

local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'
local SuccessLayer = class("SuccessLayer", cc.Node)

function SuccessLayer:ctor(starcount, callback1, callback2)

	_netMsg.clickOtherBtn("success")
	local csb = cc.CSLoader:createNode("SuccessLayer.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)

	local bg = _mutils.seekNodeByName(csb, "Image_bg")


	local btn_close = _mutils.seekNodeByName(csb, "Button_close")
	btn_close:hide()
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	local backBtn = _mutils.seekNodeByName(csb, "Button_LV")
	local nextBtn = _mutils.seekNodeByName(csb, "Button_Time")
	_mutils.addBtnPressedListener(backBtn, function()
		
		callback1()
	end)

	_mutils.addBtnPressedListener(nextBtn, function()
		callback2()
	end)

	for i=1,starcount do
		local starBg = _mutils.seekNodeByName(csb, "starBg_"..i)
		local star = cc.Sprite:create("gamescene/nl_img_xingxing2.png")
		star:setPosition(starBg:getPosition())
		star:setScale(starBg:getScale())
		bg:addChild(star)
	end
end

function SuccessLayer:closeSelf()
	self:removeFromParent()
end

return SuccessLayer