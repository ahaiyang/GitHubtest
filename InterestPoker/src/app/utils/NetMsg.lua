local _json = require("json")
local _md5 = require("app.md5")

local APP_STORE_LOG = 'xsdk_app_store_log_log'

local NetMsg = {}

local APPID = 15001

local DOT_URL = "http://45.32.84.116:8089/api/test?key=xlgame@123!&act="
local IS_DEBUBG = true

local function requestNet(tag)
	if IS_DEBUBG then return end

	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr:open("GET", DOT_URL..tag)

	local function launchNetBack()
	    if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
	        print(xhr.response)
	    else
	        print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
	    end

	    xhr:unregisterScriptHandler()
	end

	xhr:registerScriptHandler(launchNetBack)
	xhr:send()
end


--[[
打点成功标识： {"errCode":0,"errDesc":"成功"}
]]

-- -- 启动
-- function NetMsg.launchApp(appid)
-- 	NetMsg.postLog(appid, '启动_对对碰日文版')
-- end


-- --点击任意按钮(点击任意按钮调用即可，最好三个按钮调用)
-- function NetMsg.clickButton(appid)
-- 	NetMsg.postLog(appid, '点击按钮_对对碰日文版')
-- end


-- --进入商城(没有商城的不需要调用)
-- function NetMsg.intoShop(appid)
-- 	NetMsg.postLog(appid, '进入商城')
-- end

function NetMsg.clickOtherBtn(_type)
	
	local MsgTab = {
		["launch"]		= "8min接龙--启动",
		["start"]		= "8min接龙--开始游戏",
		["select"] 		= "8min接龙——难度选择", 
		["help"]		= "8min接龙--游戏帮助",
		["replay"]		= "8min接龙--重新开始按钮",
		["pause"]		= "8min接龙--暂停按钮",
		["tishi"]		= "8min接龙--提示按钮",

		["shezhi"]	 	= "8min接龙--设置",
		["shop"]	 	= "8min接龙--商城",
		["gamescene"]	= "8min接龙--游戏界面"
	}
	print("*********--->",_type)
	print("*********--->",MsgTab[_type])
	NetMsg.postLog(APPID, MsgTab[_type])
end






local function get_reqsign(tbdata, methodname, url)
    local keys = table.keys(tbdata)
    table.sort(keys)
    local arr_str_param = {}
    for _, key in ipairs(keys) do
        table.insert(arr_str_param, string.format("%s:%s",key,tbdata[key]))
    end

    local hash_str = methodname..table.concat(arr_str_param,"")..url 
    hash_str = hash_str .. '3c6e0b8a9c15224a8228b9a98ca1531d'
    return string.upper(_md5.sumhexa(hash_str))
end


--设置安全策略的文件头
local function get_header(appId, url, reqType)
    local timestamp = os.time()
    local nonce = tostring(os.time())

    local headcont ={
        ["X-QP-AppId"] = appId,
        ["X-QP-Timestamp"] = timestamp,
        ["X-QP-Nonce"] = nonce,
    }
    local sing = get_reqsign(headcont, reqType, url)
    headcont["X-QP-Signature"] = sing 
    return headcont
end

local function requestPostNet(appId, strTag)
	local purl = 'https://api.ixianlai.com/logcollector/v1/log/upload'
	local xhr = cc.XMLHttpRequest:new()

	local headdic = get_header(appId, purl, 'POST')
    if  (type(headdic) == 'table') then 
        for keyname, val in pairs(headdic) do 
            xhr:setRequestHeader(keyname, val)
        end
    end

	xhr:open("POST", purl)

	local function handlerFunc()
		print('------------- App_Store_Log -------------')
	    if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
	        print(xhr.response)
	    else
	        print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
	    end
	    xhr:unregisterScriptHandler()
	end
	xhr:registerScriptHandler(handlerFunc)

	local str = string.format('%s_%s %s', APP_STORE_LOG, appId, strTag)
	print('上传log:'..str)
	xhr:send(str)
end



-- 新打点
-- appid：项目组appid     string类型
-- strTag：任意表示字符串   string类型
function NetMsg.postLog(appid, strTag)
	print("strTag---->",strTag)
	requestPostNet(appid, strTag)
end



-- NetMsg.postLog('10001', 'doudizhu')








return NetMsg