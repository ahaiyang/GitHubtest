local _mutils       = require 'app.utils.MUtils'

local LevelLayer = class("LevelLayer", cc.Node)
local GameData 		= require 'app.views.GameData'
function LevelLayer:ctor(callBack)
	local csb = cc.CSLoader:createNode("LevelLayer.csb")
	self:addChild(csb)
	self.csb = csb
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)


	local btn_close = _mutils.seekNodeByName(csb, "btn_close")
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	--内容
	self:initItems(callBack)
end

function LevelLayer:initItems(callBack)
	local lv_bg = _mutils.seekNodeByName(self.csb, "Image_bg")
	local model = _mutils.seekNodeByName(self.csb, "Button_lv")
	model:setVisible(false)

	local Level = GameData.getLevel()
	local img_lv = ""
	for i=1,8 do
		local button = model:clone()
		button:setVisible(true)
		lv_bg:addChild(button)
		if i <= 4 then
			button:setPosition(140 + (i-1) * 220,350)
		else
			button:setPosition(140 + (i-5) * 220,130)
		end

		if i <= Level then
			img_lv = "guanqia/lv_"..i..".png"
		else
			img_lv = "guanqia/lock_"..i..".png"
		end
		button:loadTextures(img_lv,img_lv,img_lv)

		_mutils.addBtnPressedListener(button, function()
			if i <= Level then
				GameData.setCurrentLevel(i)
				callBack()
			else
				require("app.views.NoticeTip").new("请先通过前一关卡！", nil, nil, true)
			end
		end)
	end
end

function LevelLayer:closeSelf()
	self:removeFromParent()
end

return LevelLayer