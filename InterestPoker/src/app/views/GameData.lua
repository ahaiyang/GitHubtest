local GameData = {}

local DEFAULT_DIAMOND = 50
local DEFAULT_LEVEL	 = 1

function GameData.getDiamondCount()
	return cc.UserDefault:getInstance():getIntegerForKey("LOCAL_DIAMOND",DEFAULT_DIAMOND)
end

function GameData.setDiamondCount(count)
	cc.UserDefault:getInstance():setIntegerForKey("LOCAL_DIAMOND",count)
end

function GameData.getLevel()
	return cc.UserDefault:getInstance():getIntegerForKey("LOCAL_LEVEL",DEFAULT_LEVEL)
end

function GameData.setLevel(count)
	cc.UserDefault:getInstance():setIntegerForKey("LOCAL_LEVEL",count)
end

function GameData.getCurrentLevel()
	return cc.UserDefault:getInstance():getIntegerForKey("LOCAL_CUR_LEVEL",DEFAULT_LEVEL)
end

function GameData.setCurrentLevel(count)
	cc.UserDefault:getInstance():setIntegerForKey("LOCAL_CUR_LEVEL",count)
end

return GameData