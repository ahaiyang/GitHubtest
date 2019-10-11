
local _mutils       = require 'app.utils.MUtils'

local NoticeTip = class("NoticeTip", cc.Node)

function NoticeTip:ctor(content, cancleFunc, sureFunc, isSingle)
	local csb = cc.CSLoader:createNode("NoticeTip.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)

	local bg = _mutils.seekNodeByName(csb, "Image_bg")

	local contentTxt = _mutils.seekNodeByName(csb, "Text_content")
	if content then
		contentTxt:setString(content)
	end


	local btn_close = _mutils.seekNodeByName(csb, "Button_close")
	btn_close:hide()
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	local cancleBtn = _mutils.seekNodeByName(csb, "Button_cancle")
	local sureBtn = _mutils.seekNodeByName(csb, "Button_sure")
	_mutils.addBtnPressedListener(cancleBtn, function()
		if cancleFunc then
			cancleFunc()
		end
		self:closeSelf()
	end)

	_mutils.addBtnPressedListener(sureBtn, function()
		if sureFunc then
			sureFunc()
		end
		self:closeSelf()
	end)

	if isSingle then
		cancleBtn:hide()
		sureBtn:setPositionX(440)
	end

	
end

function NoticeTip:closeSelf()
	self:removeFromParent()
end

return NoticeTip