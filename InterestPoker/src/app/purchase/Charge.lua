--
-- Author: Yang Liu
-- Date: 2016-02-22 15:23:46
--
-- module("Charge", package.seeall)

local PaymentInterFace = require("app/PaymentInterFace")
local rechargeCfg = require("app/purchase/Recharge")
local GameData 		= require 'app.views.GameData'
local gt = cc.exports.gt
cc.exports.Charge = {
	
}

local mt = {}

local Json = require("json")

gt.winSize = cc.Director:getInstance():getWinSize()
gt.scheduler = cc.Director:getInstance():getScheduler()

function Charge.createMaskLayer(opacity)
    if not opacity then
        -- 用默认透明度
        opacity = 255 / 2
    end

    local maskLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, opacity), gt.winSize.width, gt.winSize.height)
    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = maskLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, maskLayer)

    return maskLayer
end

function Charge.buy(id_)
	
	Charge.openMaskLayer()

	if mt.payResultHandler then
		gt.scheduler:unscheduleScriptEntry(mt.payResultHandler)
		mt.payResultHandler = nil
		Charge.updateOrderState("IAP_DELETE_ORDER")
	end

	mt.itemid = id_

	PaymentInterFace.resetPayResult()

	PaymentInterFace.postMessage(id_)

	Charge.updateOrderState("IAP_CREATE_ORDER")

	Charge.handlePayMessage()
end


function Charge.openMaskLayer()
	if not mt.maskLayer then
		mt.maskLayer = Charge.createMaskLayer()
		local loadingIcon = cc.Sprite:create("shop/comnnon_loading.png")
		local maskSize = mt.maskLayer:getContentSize()
		loadingIcon:setPosition(maskSize.width / 2 , maskSize.height / 2 + 80)
		mt.maskLayer:addChild(loadingIcon)

		local tipText = cc.Label:createWithSystemFont("请求中，请等待", "Helvetica", 30.0)
		tipText:setPosition(cc.p(maskSize.width / 2,maskSize.height / 2 - 60))
		mt.maskLayer:addChild(tipText)

		local action = cc.RotateBy:create(3 , 360)
		local seq = cc.RepeatForever:create(action:clone())
		loadingIcon:runAction(seq)
		local runningscene = cc.Director:getInstance():getRunningScene()
		runningscene:addChild(mt.maskLayer, 300)
	end
end

function Charge.closeMaskLayer()
	gt.isRecharging = false
	if mt.maskLayer then
		mt.maskLayer:removeFromParent()
		mt.maskLayer = nil
	end
end

function Charge.handlePayMessage()
	local getPayResult = function ()
		local ret = PaymentInterFace.getPayResult()

		if string.len(ret) > 0 and mt.checkPayResult then
			print("_______the ret is .." .. ret)

			mt.checkPayResult = false

			
			local response = Json.decode(ret)
			local event = response.event
			mt.chargeData = response.chargeData

			if event == "PAY_SUCCESS" then
				Charge.updateOrderState("IAP_PAY_SUCCESS")
				Charge.requestPayFromServer()
			elseif event == "PURCHASE_DISABLE" then
				Charge.updateOrderState("IAP_DELETE_ORDER")
				Charge.closeMaskLayer()
				require("app/views/NoticeTip"):create("购买失败", "您的设备已关闭内购，请去通用—访问限制中设置", nil, nil, true)
			elseif event == "PURCHASE_CANCEL" then
				Charge.updateOrderState("IAP_DELETE_ORDER")
				Charge.closeMaskLayer()
				local tipLayer = require("app/views/NoticeTip").new("购买取消",nil,nil,true)
				local runningscene = cc.Director:getInstance():getRunningScene()
				runningscene:addChild(tipLayer, 300)
				Charge.closeMaskLayer()
			elseif event == "PURCHASE_UNPURCHASE" then
				local tipLayer = require("app/views/NoticeTip").new("购买失败",nil,nil,true)
				local runningscene = cc.Director:getInstance():getRunningScene()
				runningscene:addChild(tipLayer, 300)
				Charge.closeMaskLayer()
			end

			gt.scheduler:unscheduleScriptEntry(mt.payResultHandler)
			mt.payResultHandler = nil

		end
	end
	mt.checkPayResult = true
	if mt.payResultHandler then
		gt.scheduler:unscheduleScriptEntry(mt.payResultHandler)
		mt.payResultHandler = nil
	end
	mt.payResultHandler = gt.scheduler:scheduleScriptFunc(getPayResult, 0, false)
end

--服务器验证
function Charge.requestPayFromServer()
	local chargeData = mt.chargeData
	local limitState = "purchaseLimited"

    Charge.updateOrderState("IAP_ORDER_COMPLETE")
    Charge.closeMaskLayer()

	-- gt.dispatchEvent(gt.EventType.PURCHASE_SUCCESS ,mt.itemid )

	--本地增加金币数量
	Charge.refreshLocalGold()
	Charge.completeTransaction()

end

function Charge.completeTransaction()
	print("Charge.completeTransaction----->")
	PaymentInterFace.postMessage()
	PaymentInterFace.resetPayResult()
end


--未完成订单状态更新
function Charge.updateOrderState(state_)
	print("---------updateOrderState:" .. state_)
	local curOrder = cc.UserDefault:getInstance():getStringForKey("IAP_ORDER")
	if not curOrder then
		curOrder = ""
	end

	if state_ == "IAP_CREATE_ORDER" then  --创建订单
		curOrder = Json.encode({itemId = mt.itemid, state = state_})
	elseif state_ == "IAP_DELETE_ORDER" then --取消订单
		curOrder = ""
	else
		if state_ == "IAP_PAY_SUCCESS" then  --支付成功尚未验证
			curOrder = Json.encode({itemId = mt.itemid, state = state_, receipt = mt.chargeData})
		elseif state_ == "IAP_ORDER_COMPLETE" then --验证通过，订单完成
			curOrder = ""
		end
	end

	cc.UserDefault:getInstance():setStringForKey("IAP_ORDER", curOrder)
	cc.UserDefault:getInstance():flush()
end

--新登录处理未完成订单
function Charge.checkUncompleteOrder()
	local curOrder = cc.UserDefault:getInstance():getStringForKey("IAP_ORDER")

	if curOrder and curOrder ~= "" then
		local orderData = Json.decode(curOrder)
		dump(orderData, "----未完成订单信息")
		local orderState = orderData.state
		mt.itemid = orderData.itemId

		if not mt.itemid then
			Charge.updateOrderState("IAP_DELETE_ORDER")
			return
		end

		if orderState == "IAP_CREATE_ORDER" then
			Charge.handlePayMessage()
		elseif orderState == "IAP_PAY_SUCCESS" then
			mt.chargeData = orderData.receipt

			Charge.requestPayFromServer()
		else
			Charge.updateOrderState("IAP_DELETE_ORDER")
			Charge.requestPayFromServer()
		end
	end
end

function Charge.refreshLocalGold()
	local buyGold = 0
	for k,v in pairs(rechargeCfg) do
		if mt.itemid == v.ID then
			buyGold = v.goldCount
			break
		end
	end

	local local_gold = GameData.getDiamondCount()
	GameData.setDiamondCount(buyGold + local_gold)

	local event = cc.EventCustom:new("UPDATE_DIMIAMOND")
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

return Charge