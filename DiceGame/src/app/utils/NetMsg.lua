local _json = require("json")
local _md5 = require("app.md5")

local APP_STORE_LOG = 'xsdk_app_store_log_log'

local NetMsg = {}

local APPID = 15001

local DOT_URL = "http://120.77.236.214:8081/clientinfo/v1/private/temp"
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

function NetMsg.clickOtherBtn(_type)
	local appName = "DICE MIX 骰子"
	local MsgTab = {
		["launch"]			= appName.."--自启动",

		["start"]			= appName.."--开始游戏",
		["hudong"] 			= appName.."——互动模式按钮", 
		["help"]			= appName.."--游戏说明",
		["shezhi"]	 		= appName.."--设置",

		["model"]	 		= appName.."--互动选择界面",
		


		["gamescene"]		= appName.."--单人游戏界面",
		["gamebigscene"]	= appName.."--双人对局游戏界面",

		
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

local function requestPostNet_New(appId, strTag)
	print("requestPostNet_New--->")
	local purl = 'http://120.77.236.214:8081/clientinfo/v1/private/temp'
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

local function requestPostNet(appId, strTag)
	requestPostNet_New(appId, strTag)
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

return NetMsg