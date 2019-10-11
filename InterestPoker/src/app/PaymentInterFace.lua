-- PaymentInterFace.lua
-- created by wangjunpeng 2017.04.18

local PaymentInterFace = {}

local AppController = "PaymentInterface"


-- ios only
function PaymentInterFace.initPaymentInfo(paymentInfo)
	local luaBridge = require("cocos/cocos2d/luaoc")
	luaBridge.callStaticMethod(AppController, "initPaymentInfo", {paymentInfo = paymentInfo})
end


function PaymentInterFace.postMessage(itemId)
	local luaBridge = require("cocos/cocos2d/luaoc")
	local msg = {event = "PAY_COMPLETE"}
	if itemId then
		msg = {event = "PAY", productId = tostring(itemId)}
	end
	luaBridge.callStaticMethod(AppController, "postMessage",msg )
end


function PaymentInterFace.getPayResult()
	local luaBridge = require("cocos/cocos2d/luaoc")
	local ok, ret = luaBridge.callStaticMethod(AppController, "getPayResult")
	return ret
end


function PaymentInterFace.resetPayResult()
	local luaBridge = require("cocos/cocos2d/luaoc")
	luaBridge.callStaticMethod(AppController, "resetPayResult")
end


return PaymentInterFace