require("json")
local MUtils = {}
local _winSize = cc.Director:getInstance():getWinSize()

local SET_W = 1280
local SET_H = 720


MUtils.winCenter = cc.p(_winSize.width * 0.5, _winSize.height * 0.5)


function MUtils.addBtnPressedListener(btn, listener, scale)
    if not btn or not listener then
        return
    end
    
    btn:addClickEventListener(function (event, sender)
        audio.playSound("res/sound/click.mp3",false)
        listener(event, sender)
    end)

    if not scale then
        scale = -0.1
    end
    if scale then
        btn:setPressedActionEnabled(true)
        btn:setZoomScale(scale)
    end
end


function MUtils.createMaskLayer(opacity)
    if not opacity then
        -- 用默认透明度
        opacity = 255 / 2
    end

    local maskLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, opacity), _winSize.width, _winSize.height)
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


function MUtils.seekNodeByName(rootNode, name)
    if not rootNode or not name or tolua.isnull(rootNode) then
        return nil
    end

    if rootNode:getName() == name then
        return rootNode
    end

    local children = rootNode:getChildren()
    if not children or #children == 0 then
        return nil
    end
    for i, parentNode in ipairs(children) do
        local childNode = MUtils.seekNodeByName(parentNode, name)
        if childNode then
            return childNode
        end
    end

    return nil
end


function MUtils.repScale(node, time, scale1, scale2)
    local scaleTo1 = cc.ScaleTo:create(time, scale1)
    local scaleTo2 = cc.ScaleTo:create(time, scale2)
    local seq = cc.Sequence:create(scaleTo1, scaleTo2)
    local rep = cc.RepeatForever:create(seq)
    node:runAction(rep)
end


-- 
--
function MUtils.getAddW()
    return _winSize.width - SET_W
end

function MUtils.getAddH()
    return _winSize.height - SET_H
end



-- 收藏菜谱
--
function MUtils.getSaveKeyByID(saveID)
    return 'save_caipu_'..saveID
end

function MUtils.delSaveKeyByID(saveID)
    local ukey = MUtils.getSaveKeyByID(saveID)
    cc.UserDefault:getInstance():deleteValueForKey(ukey)
    cc.UserDefault:getInstance():flush()
end

function MUtils.saveCaiPuByID(saveID)
    local ukey = MUtils.getSaveKeyByID(saveID)
    cc.UserDefault:getInstance():setIntegerForKey(ukey, saveID)
    cc.UserDefault:getInstance():flush()
end

function MUtils.isSaveByID(saveID)
    local ukey = MUtils.getSaveKeyByID(saveID)
    local result = cc.UserDefault:getInstance():getIntegerForKey(ukey)
    if not result or result <= 0 then
        return false
    end

    return true
end

function MUtils.getSaveBookCFG()
    local mcfg     = require 'app.utils.book_cfg'
    local retCFG = {}

    for i=1,#mcfg do
        local tdata = mcfg[i]

        if  MUtils.isSaveByID(tdata['ID']) then
            table.insert(retCFG, tdata)
        end
    end

    return retCFG
end


-- book配置
--
function MUtils.getBooCFGByID(bookID)
    local mcfg     = require 'app.utils.book_cfg'

    for i=1,#mcfg do
        local tdata = mcfg[i]
        if tdata['ID'] == bookID then
            return tdata
        end
    end

    return nil
end


-- 钻石
--
local DIAMOND_KEY = 'DIAMOND_KEY_VAL'
function MUtils.getDiamondNum()
    local num = cc.UserDefault:getInstance():getIntegerForKey(DIAMOND_KEY)
    if not num then
        return 0
    end
    return num
end

function MUtils.subDiamondNum(num)
    local nowNum = MUtils.getDiamondNum() - num
    if nowNum < 0 then
        return false
    end

    cc.UserDefault:getInstance():setIntegerForKey(DIAMOND_KEY, nowNum)
    cc.UserDefault:getInstance():flush()

    return true
end

function MUtils.addDiamondNum(num)
    local nowNum = MUtils.getDiamondNum() + num
    cc.UserDefault:getInstance():setIntegerForKey(DIAMOND_KEY, nowNum)
    cc.UserDefault:getInstance():flush()
end


--视频
--
local VIDEO_BUY_KEY = 'VIDEO_BUY_KEY'
function MUtils.isBuyVideo(ID)
    return cc.UserDefault:getInstance():getBoolForKey(VIDEO_BUY_KEY..ID)
end

function MUtils.setBuyVide(ID)
    cc.UserDefault:getInstance():setBoolForKey(VIDEO_BUY_KEY..ID, true)
    cc.UserDefault:getInstance():flush()
end


--商城设置背景
--
function MUtils.getExplainBGImg()
    local img = cc.UserDefault:getInstance():getStringForKey('LUA_IOS_USE_BG_KEY')
    if not img or img == '' then
        return 'tips/xl_alerl_bg.png'
    end

    return img
end



--做菜笔记
--
local STU_COOK_NOTE = 'STU_COOK_NOTE'
function MUtils.getCookNote()
    local str = cc.UserDefault:getInstance():getStringForKey(STU_COOK_NOTE) 
    if not str or str == '' then
        return nil
    end

    return str
end

function MUtils.setCookNote(str)
    if not str then return end

    cc.UserDefault:getInstance():setStringForKey(STU_COOK_NOTE, str)
    cc.UserDefault:getInstance():flush()
end




-- 传入DrawNode对象，画圆角矩形
function MUtils.drawNodeRoundRect(newNode, rect, borderWidth, radius, color, fillColor)
    -- segments表示圆角的精细度，值越大越精细
    local segments    = 200
    local origin      = cc.p(rect.x, rect.y)
    local destination = cc.p(rect.x + rect.width, rect.y + rect.height)
    local points      = {}

    -- 算出1/4圆
    local coef     = math.pi / 2 / segments
    local vertices = {}

    for i=0, segments do
        local rads = (segments - i) * coef
        local x    = radius * math.sin(rads)
        local y    = radius * math.cos(rads)
        table.insert(vertices, cc.p(x, y))
    end

    local tagCenter      = cc.p(0, 0)
    local minX           = math.min(origin.x, destination.x)
    local maxX           = math.max(origin.x, destination.x)
    local minY           = math.min(origin.y, destination.y)
    local maxY           = math.max(origin.y, destination.y)
    local dwPolygonPtMax = (segments + 1) * 4
    local pPolygonPtArr  = {}

    -- 左上角
    tagCenter.x = minX + radius;
    tagCenter.y = maxY - radius;

    for i=0, segments do
        local x = tagCenter.x - vertices[i + 1].x
        local y = tagCenter.y + vertices[i + 1].y
        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 右上角
    tagCenter.x = maxX - radius;
    tagCenter.y = maxY - radius;

    for i=0, segments do
        local x = tagCenter.x + vertices[#vertices - i].x
        local y = tagCenter.y + vertices[#vertices - i].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 右下角
    tagCenter.x = maxX - radius;
    tagCenter.y = minY + radius;

    for i=0, segments do
        local x = tagCenter.x + vertices[i + 1].x
        local y = tagCenter.y - vertices[i + 1].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 左下角
    tagCenter.x = minX + radius;
    tagCenter.y = minY + radius;

    for i=0, segments do
        local x = tagCenter.x - vertices[#vertices - i].x
        local y = tagCenter.y - vertices[#vertices - i].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    if fillColor == nil then
        fillColor = cc.c4f(0, 0, 0, 0)
    end


    -- 切
    local clip = cc.ClippingNode:create()
    clip:setInverted(false)
    clip:setAnchorPoint(0,0)
    clip:setAlphaThreshold(0)

    local stencil = cc.DrawNode:create()
    stencil:drawPolygon(pPolygonPtArr, #pPolygonPtArr, fillColor, borderWidth, color)
    stencil:setPosition(0,0)

    clip:setStencil(stencil)
    clip:addChild(newNode, 1)
    clip:setContentSize(newNode:getContentSize())

    return clip
end

-- 解析json字符串.返回值为nil时解析出错
function MUtils.decode( _str )
	-- 检测字符串是否是json
	if not _str or type(_str) ~= "string" or #_str < 3 then
		print("_str error")
		return nil
	end

	local jsonStr = string.gsub(_str, "^%s*(.-)%s*$", "%1") --首尾去空格
	local startChar = string.sub(jsonStr,1,1)
	if startChar == "{" or startChar == "[" then
	 	-- if cc.UtilityExtension.getCapabilitySet and cc.UtilityExtension:getCapabilitySet() > 65535 and bit:_and(bit:_rshift(cc.UtilityExtension:getCapabilitySet(),15),bit:_rshift(0x80000,15)) then
		-- 	return require("cjson").decode(jsonStr) 
		-- else
		-- 	require("json")
        -- 	return json.decode(jsonStr)
        -- end	
        return json.decode(jsonStr)	
	end
	
	return nil
end

function MUtils.shakeNode(node, time, originPos, offset)
    local duration = 0.03
    if not offset then
        offset = 6
    end
    -- 一个震动耗时4个duration左,复位,右,复位
    -- 同时左右和上下震动
    local times = math.floor(time / (duration * 4))
    originPos = originPos or cc.p(node:getPositionX(), node:getPositionY())
    local moveLeft = cc.MoveBy:create(duration, cc.p(-offset, 0))
    local moveLReset = cc.MoveBy:create(duration, cc.p(offset, 0))
    local moveRight = cc.MoveBy:create(duration, cc.p(offset, 0))
    local moveRReset = cc.MoveBy:create(duration, cc.p(-offset, 0))
    local horSeq = cc.Sequence:create(moveLeft, moveLReset, moveRight, moveRReset)
    local moveUp = cc.MoveBy:create(duration, cc.p(0, offset))
    local moveUReset = cc.MoveBy:create(duration, cc.p(0, -offset))
    local moveDown = cc.MoveBy:create(duration, cc.p(0, -offset))
    local moveDReset = cc.MoveBy:create(duration, cc.p(0, offset))
    local verSeq = cc.Sequence:create(moveUp, moveUReset, moveDown, moveDReset)
    node:runAction(cc.Sequence:create(cc.Repeat:create(cc.Spawn:create(horSeq, verSeq), times), cc.CallFunc:create(function()
        node:setPosition(originPos)
    end)))
end


return MUtils