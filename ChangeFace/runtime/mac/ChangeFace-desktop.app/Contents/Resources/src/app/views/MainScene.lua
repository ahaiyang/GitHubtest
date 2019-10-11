
local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'

local MainScene = class("MainScene", cc.load("mvc").ViewBase)
MainScene.RESOURCE_FILENAME = "MainScene.csb"
function MainScene:onCreate()
	local csb = self:getResourceNode()
    -- csb:setPositionY(_mutils.getAddH()/2)
    print("csb---->",csb:getPositionX())
    print("getAddW---->",_mutils.getAddW())
    csb:setPositionX(csb:getPositionX() + math.abs(_mutils.getAddW()/2))
    self.csb = csb


	self:initUI()
	self:initButtons()
end

function MainScene:initUI()
	
end

function MainScene:initButtons()
	
end

return MainScene
