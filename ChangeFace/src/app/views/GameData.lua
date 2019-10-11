local GameData = {}

function GameData.getLevel()
	return cc.UserDefault:getInstance():getIntegerForKey("LEVELMODEL", 1)
end
function GameData.setLevel(count)
	cc.UserDefault:getInstance():setIntegerForKey("LEVELMODEL", count)
end

function GameData.getCurrentLevel()
	return cc.UserDefault:getInstance():getIntegerForKey("LOCAL_CUR_LEVEL",1)
end

function GameData.setCurrentLevel(count)
	cc.UserDefault:getInstance():setIntegerForKey("LOCAL_CUR_LEVEL",count)
end

function GameData.getFaceDIYData()
	return cc.UserDefault:getInstance():getStringForKey("FACE_DIY","")
end

function GameData.setFaceDIYData(content)
	cc.UserDefault:getInstance():setStringForKey("FACE_DIY", content)
end

return GameData