local GameData = {}

function GameData.setPlayerLeftColor(str)
	cc.UserDefault:getInstance():setStringForKey("LEFT_COLOR",tostring(str))
end

function GameData.getPlayerLeftColor()
	return cc.UserDefault:getInstance():getStringForKey("LEFT_COLOR","")
end

function GameData.setPlayerRightColor(str)
	cc.UserDefault:getInstance():setStringForKey("RIGHT_COLOR",tostring(str))
end

function GameData.getPlayerRightColor()
	return cc.UserDefault:getInstance():getStringForKey("RIGHT_COLOR","")
end

return GameData