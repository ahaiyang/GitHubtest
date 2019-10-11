
local _mutils       = require 'app.utils.MUtils'
local _netMsg 		= require 'app.utils.NetMsg'

local LogoScene = class("LogoScene", cc.load("mvc").ViewBase)

function LogoScene:onCreate()
	_netMsg.clickOtherBtn("launch")


	self:addUI()
    self:loadMusic()
end

function LogoScene:addUI()
	print("LogoScene---->")
	
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
		self:getApp():enterScene("MainScene")
	end)))
end



function LogoScene:loadMusic()
	audio.preloadMusic("res/sound/bg1.mp3")

	audio.playMusic("res/sound/bg1.mp3",true)
end

return LogoScene