
local _mutils       = require 'app.utils.MUtils'

local SuccessLayer = class("SuccessLayer", cc.Node)

function SuccessLayer:ctor(issuccess,content, cancleFunc, okFunc)
	local csb = cc.CSLoader:createNode("SuccessLayer.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)

	local title = _mutils.seekNodeByName(csb, "title")
	local backBtn = _mutils.seekNodeByName(csb, "Button_back")
	local replayBtn = _mutils.seekNodeByName(csb, "Button_replay")
	local overBtn = _mutils.seekNodeByName(csb, "Button_over")

	overBtn:setVisible(issuccess)
	backBtn:setVisible(not issuccess)
	replayBtn:setVisible(not issuccess)

	if not issuccess then
		title:loadTexture("res/gamescene/jl_img_shibai.png")
	end


	local btn_close = _mutils.seekNodeByName(csb, "btn_close")
	btn_close:setVisible(false)
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	
	_mutils.addBtnPressedListener(backBtn, function()
		if cancleFunc then
			cancleFunc()
		end
		self:closeSelf()
	end)

	
	_mutils.addBtnPressedListener(replayBtn, function()
		if okFunc then
			okFunc()
		end
		self:closeSelf()
	end)

	
	_mutils.addBtnPressedListener(overBtn, function()
		if okFunc then
			okFunc()
		end
		self:closeSelf()
	end)

	local Text_1 = _mutils.seekNodeByName(csb, "Text_1")
	Text_1:setString(content)
end

function SuccessLayer:closeSelf()
	self:removeFromParent()
end

return SuccessLayer