
local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'

local LogoScene = class("LogoScene", cc.load("mvc").ViewBase)
local PaymentInterFace = require("app/PaymentInterFace")
local Charge 		= require("app.purchase.Charge")
function LogoScene:onCreate()
	_netMsg.clickOtherBtn("launch")
	-- local csb = self:getResourceNode()
 --    csb:setPositionX(_mutils.getAddW()/2)
 --    self.csb = csb

	self:addUI()
    -- self:loadMusic()
end

function LogoScene:addUI()
	print("LogoScene---->")
	
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
		self:getApp():enterScene("MainScene")
	end)))

	-- self:initAppStoreInfo()
end

function LogoScene:initAppStoreInfo()
    local productConfig=require("app/purchase/Recharge")
    local productsInfo = ""
    for i = 1, #productConfig do
        local tmpProduct = productConfig[i]
        local productId = tmpProduct["AppStore"]
        productsInfo = productsInfo .. productId .. ","
    end
    PaymentInterFace.initPaymentInfo(productsInfo)
    Charge.checkUncompleteOrder()
    Charge.handlePayMessage()
end

function LogoScene:loadMusic()
	audio.preloadMusic("res/sound/bg1.mp3")

	audio.playMusic("res/sound/bg1.mp3",true)
end

return LogoScene