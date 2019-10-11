local PokerManager = class("PokerManager")

PokerManager.Count = 52

function PokerManager.getRandomData()

	local allPokers = {}
	local randomTab = {}
	
	for i=1,PokerManager.Count do
		local pokerObj = {}
		pokerObj._color = i%4
		pokerObj._number = i % 13 + 1
		table.insert(allPokers, pokerObj)
	end

	table.sort( allPokers, function(a,b)
		if a._color == b._color then 
			return a._number < b._number
		else
			return a._color < b._color
		end
	end )

	
	for i=1,PokerManager.Count do
		local len = #allPokers
		local random = math.random(1,len)
		local temp = allPokers[random]
		allPokers[random] = allPokers[len]
		allPokers[len] = temp
		table.insert(randomTab, allPokers[len])
		table.remove(allPokers)
	end

	return randomTab
end

return PokerManager