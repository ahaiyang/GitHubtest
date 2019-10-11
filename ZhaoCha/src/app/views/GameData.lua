
local GameData = {}

GameData.Model = {
	LEVELMODEL = 1,
	TIMEMODEL  = 2,
}

GameData.TYPE = GameData.Model.LEVELMODEL


function GameData.getLevevModel()
	return cc.UserDefault:getInstance():getIntegerForKey("LEVELMODEL", 1)
end

function GameData.setLevelModel(count)
	cc.UserDefault:getInstance():setIntegerForKey("LEVELMODEL", count)
end

function GameData.getLevevTimeModel()
	return cc.UserDefault:getInstance():getIntegerForKey("LEVELTIMEMODEL", 1)
end

function GameData.setLevelTimeModel(count)
	cc.UserDefault:getInstance():setIntegerForKey("LEVELTIMEMODEL", count)
end

function GameData.getCurrentLevel()
	return cc.UserDefault:getInstance():getIntegerForKey("LOCAL_CUR_LEVEL",1)
end

function GameData.setCurrentLevel(count)
	cc.UserDefault:getInstance():setIntegerForKey("LOCAL_CUR_LEVEL",count)
end

function GameData.getPlayCounts()
	return cc.UserDefault:getInstance():getIntegerForKey("LOCAL_PLAY_COUNT",1)
end

function GameData.setPlayCounts(count)
	cc.UserDefault:getInstance():setIntegerForKey("LOCAL_PLAY_COUNT",count)
end

return GameData