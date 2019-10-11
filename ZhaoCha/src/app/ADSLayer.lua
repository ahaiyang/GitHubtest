-- AdSLayer.lua
local gt = cc.exports.gt

local winSize = cc.Director:getInstance():getWinSize()
local schedule = cc.Director:getInstance():getScheduler()
local AdSLayer = class("AdSLayer",function ()
	return cc.Scene:create()
	-- body
end)

local _netMsg 		= require 'app.utils.NetMsg'



function AdSLayer:ctor( )

	-- body
    -- gt.netMsg.intoAdLayer()
	self:initUI()
	self.limitTime = 5
	if not self.timeHandlerAds then
        self.timeHandlerAds = schedule:scheduleScriptFunc(handler(self,self.updateTimerAds), 1, false)
    end
    _netMsg.clickOtherBtn("ads")
end


function AdSLayer:updateTimerAds()
    self.limitTime = self.limitTime - 1
    if self.limitTime <= 0 then
       self:removeAction()
    end
    if self.timeLable then
    	local str = "跳过 " .. self.limitTime
	    self.timeLable:setString(str)
	end
end


function AdSLayer:createTextLab(  )
	-- body

	local textBg = cc.Scale9Sprite:create("res/ad/ad_text_bg.png")
	local textSize = cc.size(140,90)
	textBg:setContentSize(textSize)
	local textLab = cc.Label:createWithSystemFont("广告", "Helvetica", 36.0)
	textLab:setPosition(textSize.width / 2 , textSize.height / 2)
	textBg:addChild(textLab)
	textBg._textLab = textLab
	return textBg
end

function AdSLayer:removeAction( )
	-- body
	 if self.timeHandlerAds then
        schedule:unscheduleScriptEntry(self.timeHandlerAds)
        self.timeHandlerAds = nil
    end
	-- local loginScene = require("app/views/LoginScene"):create()
	-- cc.Director:getInstance():replaceScene(loginScene)
	-- local updateScene = require("app/views/UpdateScene"):create()
	-- cc.Director:getInstance():replaceScene(updateScene)

	self:removeFromParent()
end

function AdSLayer:initUI( )
	print("AdSLayer:initUI---->")
	-- body
	local imgIdx = math.random(1,3)
	local name = "res/ad/ad_"..imgIdx .. ".png"
	local pBackground = cc.Scale9Sprite:create(name)
	-- local pBackground = cc.Sprite:create(name)
	pBackground:setContentSize(winSize)
	pBackground:setPosition(winSize.width/2,winSize.height / 2)
	-- pBackground:setScale(gt.winSize.width/1280, gt.winSize.height/720)
	self:addChild(pBackground) 

	-- 
	local adTextSpr = self:createTextLab()
	pBackground:addChild(adTextSpr)
	adTextSpr:setPosition(winSize.width * 0.9,winSize.height * 0.8)
	-- 
   
	local closeSize = cc.size(140,90)
	local imgName = "res/ad/ad_text_bg.png"
	local btn = ccui.Button:create(imgName, imgName)
	local btnSize = btn:getContentSize()
	local scaleX = closeSize.width / btnSize.width 
	local scalY = closeSize.height / btnSize.height 

	btn:setScale(scaleX,scalY)
	btn:setTouchEnabled(false)
	btn:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then 
            local scale = cc.ScaleTo:create(1,0.8)
            local ease_elastic = cc.EaseElasticOut:create(scale)
            sender:runAction(ease_elastic)      
            
        elseif eventType == ccui.TouchEventType.ended then
            local scale = cc.ScaleTo:create(1,1)
            local ease_elastic = cc.EaseElasticOut:create(scale)
            sender:runAction(ease_elastic)

           -- self:removeAction()
         
        elseif eventType == ccui.TouchEventType.canceled then
           local scale = cc.ScaleTo:create(1,1)
            local ease_elastic = cc.EaseElasticOut:create(scale)
            sender:runAction(ease_elastic)
        end
    end)

    local benPos = cc.p(winSize.width * 0.9,winSize.height * 0.2)

	pBackground:addChild(btn)
	btn:setPosition(benPos)


	local textLab = cc.Label:createWithSystemFont("跳过 5", "Helvetica", 36.0)
	textLab:setPosition(benPos)
	pBackground:addChild(textLab)
	self.timeLable = textLab


end




return AdSLayer