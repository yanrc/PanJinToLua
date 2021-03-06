

StartPanel = UIBase(define.Panels.StartPanel, define.FixUI)
local this = StartPanel
local transform;
local gameObject;
local versionText;-- 版本号
local panelCreate;-- 要加载的面板的引用
local agreeProtocol;-- toggle
local xieyiPanel;-- 协议面板
local xieyiButton;-- 打开协议面板的按钮
local btnLogin-- 登录按钮
local logo
-- 启动事件--
function StartPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	versionText = gameObject.transform:Find("TextVersion"):GetComponent('Text');
	agreeProtocol = gameObject.transform:Find("Toggle"):GetComponent('Toggle');
	xieyiButton = gameObject.transform:Find("Toggle/Label").gameObject;
	btnLogin = transform:Find("Button").gameObject;
	logo=transform:Find("logo"):GetComponent("Image")
	logo.sprite=GameSetting.LOGO
	this.lua:AddClick(btnLogin, this.Login);
	this.lua:AddClick(xieyiButton, this.OpenXieyiPanel);

end



function StartPanel.LoginCallBack(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	log("LUA:StartPanel.LoginCallBack=" .. message);
	ClosePanel(WaitingPanel)
	LoginData = AvatarVO.New(json.decode(message));
	local userlist = { LoginData.account.uuid }
	networkMgr:SendChatMessage(ChatRequest.New(APIS.LoginChat_Request, userlist, nil, nil));
	ClosePanel(this)
	OpenPanel(HomePanel)
end
function StartPanel.RoomBackResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	ClosePanel(WaitingPanel)
	RoomData = json.decode(message);
	RoomData.enterType = 3
	AvatarVO.SetList(RoomData.playerList)
	log("Lua:RoomBackResponse=" .. message);
	for i = 1, #RoomData.playerList do
		local itemData = RoomData.playerList[i];
		if (itemData.account.openid == LoginData.account.openid) then
			LoginData = itemData
			local userlist = { LoginData.account.uuid }
			networkMgr:SendChatMessage(ChatRequest.New(APIS.LoginChat_Request, userlist, nil, nil));
			break;
		end
	end
	ClosePanel(this)
	OpenPanel(StartPanel.GetGame(RoomData.roomType))
end

function StartPanel.ConnectTime(time)
	coroutine.wait(1)
	networkMgr:SendConnect();
end

function StartPanel.OnConnect()
	ClosePanel(WaitingPanel)
	soundMgr:playBGM(1);
	-- 如果已经授权自动登录
	if UNITY_ANDROID then
		if (WechatOperate.shareSdk:IsAuthorized(PlatformType.WeChat)) then
			this.Login();
		end
	elseif UNITY_IPHONE then
		if (WechatOperate.shareSdk:IsAuthorized(PlatformType.WechatPlatform)) then
			this.Login();
		end
	end
end

function StartPanel.Login()
	-- 初始化界面数值
	if (agreeProtocol.isOn) then
		this.doLogin();
		OpenPanel(WaitingPanel, "进入游戏中")
	else
		log("lua:请先同意用户使用协议");
		TipsManager.SetTips("请先同意用户使用协议", 1);
	end
end
function StartPanel.doLogin()
	log("UNITY_EDITOR=" .. tostring(UNITY_EDITOR) .. ",UNITY_STANDALONE_WIN=" .. tostring(UNITY_STANDALONE_WIN))
	if UNITY_EDITOR or UNITY_STANDALONE_WIN then
		-- 用于测试 不用微信登录
		resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/LoginPanel.prefab' }, LoginManager.TestLogin);
	else
		WechatOperate.Login();
	end
end


function StartPanel.OpenXieyiPanel()
	soundMgr:playSoundByActionButton(1);
	if (xieyiPanel) then
		xieyiPanel:SetActive(true)
	else
		resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/xieyiPanel.prefab' }, this.InitXieyiPanel);
	end
end
function StartPanel.InitXieyiPanel(prefabs)
	xieyiPanel = newObject(prefabs[0]);
	xieyiPanel.transform.parent = StartPanel.transform.parent;
	xieyiPanel.transform.localScale = Vector3.one;
	xieyiPanel.transform:SetAsLastSibling();
	xieyiPanel:GetComponent("RectTransform").offsetMax = Vector2.zero;
	xieyiPanel:GetComponent("RectTransform").offsetMin = Vector2.zero;
end
function StartPanel.CloseXieyiPanel()
	soundMgr:playSoundByActionButton(1);
	if (xieyiPanel) then
		xieyiPanel:SetActive(false);
	end
end
function StartPanel.GetGame(roomType)
	local switch = {
		[1] = ZhuanzhuanGame,
		[2] = PanjinGame,
		[3] = ChangshaGame,
		[4] = GuangdongGame,
		[5] = PanjinGame,
		[6] = WuxiGame,
		[7] = ShuangliaoGame,
		[8] = JiujiangGame,
		[9] = TuidaohuGame,
	}
	return switch[roomType] or GamePanel
end

-------------------模板-------------------------
function StartPanel:OnOpen()
	versionText.text = "版本号：" .. Application.version;
	OpenPanel(WaitingPanel, "正在连接服务器")
	-- 1秒后开始连接
	coroutine.start(this.ConnectTime, 1);
end
-- 移除事件--
function StartPanel:RemoveListener()
	-- UpdateBeat:Remove(this.Update);
	Event.RemoveListener(Protocal.Connect, this.OnConnect);
	Event.RemoveListener(tostring(APIS.LOGIN_RESPONSE), this.LoginCallBack)
	Event.RemoveListener(tostring(APIS.BACK_LOGIN_RESPONSE), this.RoomBackResponse)
end

-- 增加事件--
function StartPanel:AddListener()
	-- UpdateBeat:Add(this.Update);
	Event.AddListener(Protocal.Connect, this.OnConnect);
	Event.AddListener(tostring(APIS.LOGIN_RESPONSE), this.LoginCallBack)
	Event.AddListener(tostring(APIS.BACK_LOGIN_RESPONSE), this.RoomBackResponse)
end
