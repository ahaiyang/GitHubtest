
local _mutils       = require 'app.utils.MUtils'

local NoticeTip = class("NoticeTip", cc.Node)

function NoticeTip:ctor(content, cancleFunc, okFunc, isSingle)
	local csb = cc.CSLoader:createNode("NoticeTip.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)


	local btn_close = _mutils.seekNodeByName(csb, "btn_close")
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	local cancleBtn = _mutils.seekNodeByName(csb, "Button_cancle")
	_mutils.addBtnPressedListener(cancleBtn, function()
		if cancleFunc then
			cancleFunc()
		end
		self:closeSelf()
	end)

	local sureBtn = _mutils.seekNodeByName(csb, "Button_sure")
	_mutils.addBtnPressedListener(sureBtn, function()
		if okFunc then
			okFunc()
		end
		self:closeSelf()
	end)

	if isSingle then
		sureBtn:setPositionX(332)
		cancleBtn:setVisible(false)
	end

	local Text_1 = _mutils.seekNodeByName(csb, "Text_1")
	Text_1:setString(content)
end

function NoticeTip:closeSelf()
	self:removeFromParent()
end

return NoticeTip