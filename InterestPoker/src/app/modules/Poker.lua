local Pokder = class("Pokder",cc.Node)

function Pokder:ctor(_color, _number)
	self.m_color 	= _color
	self.m_number 	= _number
	local fileName = string.format("sp%d_%d.png", self.m_color, self.m_number)
	self.m_force = cc.Sprite:create("poker/"..fileName)
	self.m_back	 = cc.Sprite:create("poker/sp_back.png")

	self:addChild(self.m_force)
	self:addChild(self.m_back)

	--每张扑克都有个容器，可以放另一张扑克
	--每张扑克都可以拖动、点击
end

function Pokder:getShowStatus()
	if self.m_back:isVisible() == true then
		return false
	else
		return true
	end
end

function Pokder:turnCard()
	local time = 0.25
	print("Card:TurnCard---->")
	--cocos2d::DisplayLinkDirector::Projection::_2D
	cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)
	--开始角度设置为0，旋转90度  
	local cardOne = nil
	local cardTwo = nil
	-- if self:getShowStatus() then
	-- 	cardOne = self.m_force
	-- 	cardTwo = self.m_back
	-- else
	-- 	cardOne = self.m_force
	-- 	cardTwo = self.m_back
	-- end
	-- cardOne:hide()
	self.m_force:hide()
	self.m_back:runAction(cc.Sequence:create(cc.OrbitCamera:create(time,1,0,0,90,0,0),cc.Hide:create(),cc.CallFunc:create(function()
			--开始角度是270，旋转90度            
			self.m_force:runAction(cc.Sequence:create(cc.Show:create(),cc.OrbitCamera:create(time,1,0,270,90,0,0),cc.CallFunc:create(function()
				
			end)))
        end
    )))
end


function Pokder:getPoker()
    return self.m_number, self.m_color
end

function Pokder:getBack()
	return self.m_back
end

function Pokder:hideBack()
	self.m_back:hide()
end

function Pokder:showBack()
	self.m_back:show()
end

-- 通过_color和_number获取扑克对应的图片名称
function Pokder:getFileName()
    if self.m_color == nil or self.m_number == nil then
        return nil
    end
    return string.format("sp%d_%d.png", self.m_color, self.m_number)
end


return Pokder