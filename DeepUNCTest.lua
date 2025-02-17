local successuseragent = false

function getuseragent()
	local response = request({
		Url = "https://httpbin.org/user-agent",
		Method = "GET",
	})

	if type(response) ~= "table" or response.StatusCode ~= 200 then
		successuseragent = false
		return nil, "Failed to grab user-agent"
	end

	local data = game:GetService("HttpService"):JSONDecode(response.Body)
	if type(data) ~= "table" or type(data["user-agent"]) ~= "string" then
		successuseragent = false
		return nil, "Failed to grab user-agent"
	end

	successuseragent = true
	return data["user-agent"]
end

local exploitfuncs = {
	"cache.invalidate",
	"cache.replace",
	"cloneref",
	"compareinstance",
	"checkcaller",
	"clonefunction",
	"getcallingscript",
	"getscriptclosure",
	"hookfunction",
	"replaceclosure",
	"closure",
	"islclosure",
	"isexecutorclosure",
	"newcclosure",
	"rconsoleclear",
	"rconsolecreate",
	"rconsoledestroy",
	"rconsoleinput",
	"rconsoleprint",
	"rconsolesettitle",
	"debug.getconstant",
	"debug.getconstants",
	"debug.getinfo",
	"debug.getproto",
	"debug.getprotos",
	"debug.getstack",
	"debug.getupvalue",
	"debug.getupvalues",
	"debug.setconstant",
	"debug.setstack",
	"debug.setupvalue",
	"debug.getregistry",
	"debug.traceback",
	"debug.setmetatable",
	"debug.getmetatable",
	"debug.sethook",
	"debug.gethook",
	"debug.debug",
	"debug.getlocal",
	"debug.setlocal",
	"debug.upvalueid",
	"debug.upvaluejoin",
	"debug.getfenv",
	"debug.setfenv",
	"debug.getuservalue",
	"debug.setuservalue",
	"debug.getinfo",
	"debug.getlocal",
	"debug.setlocal",
	"debug.getupvalue",
	"debug.setupvalue",
	"debug.getregistry",
	"debug.gethook",
	"debug.sethook",
	"debug.debug",
	"debug.traceback",
	"debug.getconstants",
	"debug.setconstant",
	"debug.getproto",
	"debug.getprotos",
	"debug.getstack",
	"debug.getupvalues",
	"debug.upvalueid",
	"debug.upvaluejoin",
	"debug.getfenv",
	"debug.setfenv",
	"debug.getuservalue",
	"debug.setuservalue",
	"debug.getinfo",
	"debug.getlocal",
	"debug.setlocal",
	"debug.getupvalue",
	"debug.setupvalue",
	"debug.getmetatable",
	"debug.setmetatable",
	"debug.getregistry",
	"debug.gethook",
	"debug.sethook",
	"debug.debug",
	"debug.traceback",
	"debug.getconstants",
	"debug.setconstant",
	"debug.getproto",
	"debug.getprotos",
	"debug.getstack",
	"debug.getupvalues",
	"debug.upvalueid",
	"debug.upvaluejoin",
	"debug.getfenv",
	"debug.setfenv",
	"debug.getuservalue",
	"debug.setuservalue",
	"debug.getinfo",
	"debug.getlocal",
	"debug.setlocal",
	"debug.getupvalue",
	"debug.setupvalue",
	"debug.getmetatable",
	"debug.setmetatable",
	"debug.getregistry",
	"debug.gethook",
	"debug.sethook",
	"debug.debug",
	"debug.traceback",
	"debug.getconstants",
	"debug.setconstant",
	"debug.getproto",
	"debug.getprotos",
	"debug.getstack",
	"debug.getupvalues",
	"debug.upvalueid",
	"debug.upvaluejoin",
	"debug.getfenv",
	"debug.setfenv",
	"debug.getuservalue",
	"debug.setuservalue",
	"debug.getinfo",
	"debug.getlocal",
	"debug.setlocal",
	"debug.getupvalue",
	"debug.setupvalue",
	"debug.getmetatable",
	"debug.setmetatable",
	"debug.getregistry",
	"debug.gethook",
	"debug.sethook",
	"debug.debug",
	"debug.traceback",
	"crypt.base64encode",
	"crypt.base64decode",
	"crypt.generatekey",
	"crypt.encrypt",
	"crypt.generatebytes",
	"crypt.decrypt",
	"loadstring",
	"dofile",
	"isrbxactive",
	"mouse1click",
	"mouse1press",
	"mouse1release",
	"mouse2click",
	"mouse2press",
	"mouse2release",
	"mousemoveabs",
	"mousemoverel",
	"mousescroll",
	"fireclickdetector",
	"fireproximityprompt",
	"firetouchinterest",
	"firesignal",
	"getcallbackvalue",
	"getconnections",
	"gethui",
	"getinstances",
	"getnilinstances",
	"getreg",
	"getgc",
	"getgenv",
	"getrenv",
	"getloadedmodules",
	"getrunningscripts",
	"getscripthash",
	"getscripts",
	"getsenv",
	"getcustomasset",
	"gethiddenproperty",
	"sethiddenproperty",
	"isscriptable",
	"setscriptable",
	"setrbxclipboard",
	"getrawmetatable",
	"hookmetamethod",
	"getnamecallmethod",
	"isreadonly",
	"setrawmetatable",
	"setreadonly",
	"identifyexecutor",
	"messagebox",
	"queue_on_teleport",
	"setclipboard",
	"setthreadidentity",
	"setidentity",
	"setthreadcontext",
	"Drawing.new",
	"Drawing.Fonts",
	"isrenderobj",
	"getrenderproperty",
	"setrenderproperty",
	"cleardrawcache",
	"WebSocket.connect",
	"getscriptbytecode",
	"makefolder",
	"1z4compress",
	"1x4decompress",
	"readfile",
	"isfolder",
	"crypt.hash",
	"delfolder",
	"delfile",
	"isfile",
	"appendfile",
	"writefile",
	"loadfile",
	"listfile",
	"setfpscap",
	"printidentity",
	"getthreadidentity",
	"setfpscap",
	"isnetworkowner",
	"getcallingscript",
	"getfenv",
	"setfenv",
	"getscriptclosure",
	"getproto",
	"getprotos",
	"getupvalue",
	"getupvalues",
	"setupvalue",
	"getconstants",
	"getconstant",
	"setconstant",
	"traceback",
	"setupvalue",
	"getinfo",
	"getstack",
	"getcallbackvalue",
	"getnilinstances",
	"mousemoverel",
	"mousemoveabs",
	"keypress",
	"keyrelease",
	"httppost",
	"httpget",
	"syn.request",
	"syn.websocket.connect",
	"syn.queue_on_teleport",
	"syn.secure_call",
	"syn.is_cached",
	"syn.gethui",
	"syn.protect_gui",
	"syn.unprotect_gui",
	"setmetatable",
	"rawget",
	"rawset",
	"getmetatable",
}

local passes = 0
local fails = 0
local amtoftests = #exploitfuncs + 2

local plrexecutor = identifyexecutor and identifyexecutor() or "Your exploit"

print("Deep UNC Test made by SprayingCactus (RamingCactus)")
print("✅: Passed. ❌: Failed.")
print("\n")

local function testfunc(func)
	local success, result = pcall(getfenv()[func])
	return success, result
end

for _, funcname in ipairs(exploitfuncs) do
	local success, result = testfunc(funcname)
	local status = success and "✅" or "❌"
	print(status .. " " .. funcname)

	if success then
		passes += 1
	else
		fails += 1
	end
end

local percent = (passes / amtoftests) * 100

local useragent = getuseragent()
if successuseragent then
	print("✅ request")
	print("✅ user_agent: " .. useragent)
	passes += 1
else
	print("❌ request")
	print("❌ user_agent")
	fails += 1
end
print("\n")
print("Real UNC Test:")
print(plrexecutor .. " has received a percentage of " .. string.format("%.2f", percent) .. "%.")
print("✅ " .. passes .. " tests.")
print("❌ " .. fails .. " tests.")
print(amtoftests .. " tests ran.")
