
local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'

local GameData 		= require 'app.views.GameData'

local ModelScene = class("ModelScene", cc.load("mvc").ViewBase)
ModelScene.RESOURCE_FILENAME = "ModelScene.csb"
function ModelScene:onCreate()
	_netMsg.clickOtherBtn("model")
    local csb = self:getResourceNode()
    csb:setPositionY(_mutils.getAddH()/2)
    self.csb = csb
    self.playerCounts = 0
    self:initButtons()

    self.player1 = _mutils.seekNodeByName(csb, "Image_player1")
    self.player2 = _mutils.seekNodeByName(csb, "Image_player2")

end

function ModelScene:initButtons()
	local btn_close 	= _mutils.seekNodeByName(self.csb, "Button_close")
	_mutils.addBtnPressedListener(btn_close,function()
		self:getApp():enterScene("MainScene")
	end)

	local btnNames = {"red", "blue", "yellow"}
	for i,v in ipairs(btnNames) do
		local btn = _mutils.seekNodeByName(self.csb, "Button_"..v)
		btn:setName(v)
		local select_img = _mutils.seekNodeByName(btn, "Image_select")
		select_img:setVisible(false)

		_mutils.addBtnPressedListener(btn, function()
			if self.playerCounts >= 2 then
				return
			end
			select_img:setVisible(true)
			self.playerCounts = self.playerCounts + 1

			self:checkToStart(btn)
		end)
	end
end

function ModelScene:checkToStart(btn)
	print("name---->",btn:getName())
	if self.playerCounts == 1 then
		self.player1:setPosition(btn:getPositionX(),btn:getPositionY() - 180)
		self.player1:setVisible(true)
		GameData.setPlayerLeftColor(btn:getName())
		print("get--->",GameData.getPlayerLeftColor())
	elseif self.playerCounts == 2 then
		self.player2:setPosition(btn:getPositionX(),btn:getPositionY() - 180)
		self.player2:setVisible(true)
		GameData.setPlayerRightColor(btn:getName())
		print("get--->",GameData.getPlayerRightColor())
		performWithDelay(self,function()
			self:getApp():enterScene("GameBigScene")
		end,0.2)
	end
end

return ModelScene
