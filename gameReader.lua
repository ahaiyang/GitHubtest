1、加载CCS资源文件，如下所示：
	local csbNode = cc.CSLoader:createNode("Login.csb")
	csbNode:setPosition(gt.winCenter)
	self:addChild(csbNode)
	self.rootNode = csbNode

2、注册节点事件：
self:registerScriptHandler(handler(self, self.onNodeEvent))
function MainScene:onNodeEvent(eventName)
	if "enter" == eventName then
		--清理纹理
		cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
		cc.Director:getInstance():getTextureCache():removeAllTextures()
	elseif "exit" == eventName then
		
	end
end
3、添加按钮事件：gt.seekNodeByName(playerInfoNode, "Btn_full")
local buyCardFullBtn = gt.seekNodeByName(playerInfoNode, "Btn_full")
(1)、Press
gt.addBtnPressedListener(buyCardFullBtn, function()
	-- 弹出房卡购买提示
	if gt.isOpenIAP then
		local layer = require("app/views/Purchase/RechargeLayer"):create( )
		self:addChild(layer, 50)
	else 
		require("app/views/NoticeTipsForFangKa"):create(gt.getLocationString("LTKey_0007"), gt.roomCardBuyInfo, nil, nil, true)
	end 
end)
（2）、click
joinRoomPanel:addClickEventListener(function()
	if self.isRoomCreater then
					
	else
		
	end
end)
4、监听事件：
	（1）gt.CommonEvent:addEventListener("ROOM_EVENT_CHANGE_MOVE_CARD",handler(self,self.changeMoveCard))
	（2）gt.CommonEvent:pushEvent("ROOM_EVENT_CHANGE_MOVE_CARD")
	（3）gt.CommonEvent:removeEventListenersByEvent("ROOM_EVENT_CHANGE_MOVE_CARD")

5、延时操作
performWithDelay(btn_yaoqing,function()
	btn_yaoqing:setEnabled(true)
end,1)