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

function MUtils.createTTFLabel(text, fontSize, font)
    text = text or ""
    font = font or "Arial"
    fontSize = fontSize or 18
    local ttfLabel = cc.Label:createWithSystemFont( text, font, fontSize)

    return ttfLabel
end

-- @param contentText 文本内容(0,255,0|文本|0,255,0|文本)
-- @param fontSize 字体大小
-- @param contentSize 内容区域(如果为空不换行)
-- @param verticalSpace 行间距
-- end --
function MUtils.rich_label_template(contentText, fontSize, contentSize, verticalSpace)
    if not contentText then return end
    local richText = ccui.RichText:create()
    fontSize = fontSize or 18
    -- 内容显示区域
    if contentSize then
        richText:ignoreContentAdaptWithSize(false)
        richText:setContentSize(contentSize)
    else
        richText:ignoreContentAdaptWithSize(true)
    end
    if verticalSpace then
        -- 行间距
        richText:setVerticalSpace(verticalSpace)
    end
    local unitsArray = string.split(contentText, "|")
    local eleTag = 1
    for i = 1, #unitsArray, 2 do
        local textColor = string.split(unitsArray[i], ",")
        fontSize = textColor[4] or 18
        local eleText = ccui.RichElementText:create(eleTag, cc.c3b(textColor[1], textColor[2], textColor[3]), 255, unitsArray[i + 1], "fonts/DFYuanW7-GB2312.ttf", fontSize)
        richText:pushBackElement(eleText)
        eleTag = eleTag + 1
    end
    return richText
end

--- 创建一个timeline动画
-- @param csbFileName    the csbFileName of the animation
-- @param animationName    the animationName of the animation
-- @param loop    wheather need loop the animation
-- @return animaNode, animate   
function MUtils.create_csb_animation( csbFileName, animationName, loop)
    local createCSAnimation = function( ... )
        local csbNode = cc.CSLoader:createNode(csbFileName)
        local action = cc.CSLoader:createTimeline(csbFileName)
        csbNode:runAction(action)
        return csbNode, action
    end
    local animaNode, animate = createCSAnimation(csbFileName)
    if animationName then
        animate:play(animationName, loop)
    end
    return animaNode, animate
end



return MUtils