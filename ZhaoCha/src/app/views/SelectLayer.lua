
local _mutils       = require 'app.utils.MUtils'

local SelectLayer = class("SelectLayer", cc.Node)
local GameData   = require("app.views.GameData")

function SelectLayer:ctor(callback)
	local csb = cc.CSLoader:createNode("SelectLevel.csb")
	self:addChild(csb)
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)


	local btn_close = _mutils.seekNodeByName(csb, "Button_close")
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)

	self.scorollView = _mutils.seekNodeByName(csb, "ScrollView")
	self.model 	= _mutils.seekNodeByName(csb, "Button_model")
	self.model:setVisible(false)

	self:initLevel(callback)
end

function SelectLayer:initLevel(callback)

	local row_max = 3
	local levels = 15
	local spaceX = 240
	local spaceY = 300
	local startX = 160
	local rows = 10
	local cellH = 300

	local scroH = spaceY * 5
	local scroW = 800
	local startY = scroH - 300/2 -10

	local currentLV = GameData.getLevevModel()

	self.scorollView:setInnerContainerSize(cc.size(scroW,scroH))
	for i=1,levels do
		local button = self.model:clone()
		local filename = "levelPic/lv_".. i .. ".png"
		button:loadTextures(filename,filename,filename)
		local lock = _mutils.seekNodeByName(button, "Image_lock")
		button:setVisible(true)
		self.scorollView:addChild(button)

		local xNumber = i % row_max
		local yNumber = math.floor(i/row_max)
		if xNumber == 0 then
            xNumber = row_max
        end
        if i % row_max > 0 then
            yNumber = yNumber + 1
        end 

        local posX = startX + (xNumber -1) * spaceX
        local posY = startY - (yNumber -1) * spaceY
		button:setPosition(posX, posY)

		if i <= currentLV then
			lock:setVisible(false)
		end

		_mutils.addBtnPressedListener(button, function()
			if i <= currentLV then
				GameData.setCurrentLevel(i)
				callback()
			else
				require("app.views.NoticeTip").new("请找出前一关的所有不同的地方", nil, nil, true)
			end
		end)

	end
end

function SelectLayer:closeSelf()
	self:removeFromParent()
end

return SelectLayer