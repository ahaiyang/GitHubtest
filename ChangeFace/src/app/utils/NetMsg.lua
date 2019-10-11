local _json = require("json")
local _md5 = require("app.md5")

local APP_STORE_LOG = 'xsdk_app_store_log_log'

local NetMsg = {}

local APPID = 15001

function NetMsg.clickOtherBtn(_type)
	local appName = "川剧变脸"
	local MsgTab = {
		["launch"]			= appName.."--自启动",
		["chip"]			= appName.."--绘色动作",
		["select"] 			= appName.."——选择色块", 
		["update"]			= appName.."--刷新按钮",
		["btn_force"]		= appName.."--前一页",
		
		["btn_next"]		= appName.."--后一页",
		-- ["paihang"]			= appName.."--排行榜按钮",
		-- ["gamescene"]		= appName.."--游戏界面",


		-- ["nextstep"]		= appName.."--点击步行",
		-- ["gameclose"]		= appName.."--关闭游戏界面",
		["lv_1"]			= appName.."--第1关界面",
		["lv_2"]			= appName.."--第2关界面",
		["lv_3"]			= appName.."--第3关界面",
		["lv_4"]			= appName.."--第4关界面",
		-- ["lv_6"]			= appName.."--第6关界面",
		-- ["lv_7"]			= appName.."--第7关界面",
		-- ["lv_8"]			= appName.."--第8关界面",
		-- ["lv_9"]			= appName.."--第9关界面",
		-- ["lv_10"]			= appName.."--第10关界面",
		-- ["lv_11"]			= appName.."--第11关界面",
		-- ["lv_12"]			= appName.."--第12关界面",
		-- ["lv_13"]			= appName.."--第13关界面",
		-- ["lv_14"]			= appName.."--第14关界面",
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


-- 新打点
-- appid：项目组appid     string类型
-- strTag：任意表示字符串   string类型
function NetMsg.postLog(appid, strTag)
	print("strTag---->",strTag)
	requestPostNet_New(appid, strTag)
end


return NetMsg