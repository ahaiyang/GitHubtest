local _mutils       = require 'app.utils.MUtils'

local ShopLayer = class("ShopLayer", cc.Node)

local ShopCfg = require("app.purchase.Recharge")
local Charge = require("app.purchase.Charge")

function ShopLayer:ctor()
	local csb = cc.CSLoader:createNode("ShopLayer.csb")
	self:addChild(csb)
	self.csb = csb
	csb:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)


	local btn_close = _mutils.seekNodeByName(csb, "btn_close")
	_mutils.addBtnPressedListener(btn_close, function()
		self:closeSelf()
	end)


	self:initItems()

end

function ShopLayer:initItems()
	local image_bg = _mutils.seekNodeByName(self.csb, "Image_bg")
	local model = _mutils.seekNodeByName(self.csb, "Button_buy")
	model:setVisible(false)

	self.buttons = {}
	for i=1,#ShopCfg do
		local button = model:clone()
		button:setPosition(170 + (i-1) * 300, 280)
		button:setVisible(true)
		image_bg:addChild(button)

		local title = _mutils.seekNodeByName(button, "buy_title")
		local image = _mutils.seekNodeByName(button, "buy_diamond")
		local costLabel = _mutils.seekNodeByName(button, "buy_cost_label")
		local select_img = _mutils.seekNodeByName(button, "buy_select")
		select_img:setVisible(false)

		title:setString(ShopCfg[i].getdis)
		costLabel:setString(ShopCfg[i].CostValue)

		_mutils.addBtnPressedListener(button, function()
			self:selectItem()
			select_img:setVisible(true)
			Charge.buy(i)
		end)
		table.insert(self.buttons, button)
	end
end

function ShopLayer:selectItem()
	for i,v in ipairs(self.buttons) do
		_mutils.seekNodeByName(v, "buy_select"):setVisible(false)
	end
end

function ShopLayer:closeSelf()
	self:removeFromParent()
end

return ShopLayer