
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    -- display.newSprite("test.png")
    --     :move(display.center)
    --     :addTo(self)
    --     :setScale(4)
        -- :setPosition(0,0)

    -- add HelloWorld label
    -- cc.Label:createWithSystemFont("Hello World", "Arial", 40)
    --     :move(display.cx, display.cy + 200)
    --     :addTo(self)

    -- self:test()
end
function MainScene:test()
	printf("resource node = %s", tostring(self:getResourceNode()))
 
    --绘制图片
    self.sprite = cc.Sprite:create("test.png")
    self.sprite:setAnchorPoint(0,0)
    self.sprite:setPosition(600, 200)
    self:addChild(self.sprite, 1)
    
    local function onTouchBegan(touch, event)
        local target = event:getCurrentTarget()
        local size = target:getContentSize()
        local rect = cc.rect(0, 0, size.width, size.height)
        local p = target:convertTouchToNodeSpace(touch)
        if cc.rectContainsPoint(rect, p) then
            return true
        end

        return false

        -- return true
    end
 
    local function onTouchMoved(touch, event)
        local dx = touch:getDelta().x
    end
 
    local function onTouchEnded(touch, event)
        -- local location = touch:getLocation()
        local location = self.sprite:convertTouchToNodeSpace(touch)
        dump(location, "点击的坐标是")
        
        print("点击到图形---->",GameUtils:alphaTouchCheck(self.sprite, location))
    end
 
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.sprite)
end

return MainScene
