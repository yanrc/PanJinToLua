require "View/HomePanel"
HomePanelCtrl={}
local this=HomePanelCtrl;
local gameObject;
local nickNameText;--昵称
local cardCountText;--房卡剩余数量
local IpText;--ID
local headIconImg--头像
local contactInfoContent--房卡面板显示内容
local roomCardPanel--房卡面板
local noticeText--广播
showNum=0
startFlag=false
function HomePanelCtrl.Awake()
	logWarn("HomePanelCtrl.Awake--->>");
	PanelManager:CreatePanel('HomePanel', this.OnCreate);
	CtrlManager.AddCtrl("HomePanelCtrl",this)
end

function HomePanelCtrl.OnCreate(go)
	gameObject = go;
	lua = gameObject:GetComponent('LuaBehaviour');
	nickNameText=go.transform:FindChild("Panel_Left/Text_Nick_Name"):GetComponent("Text")
	cardCountText=go.transform:FindChild("Panel_Left/Image_Card_Number_Bg/Text"):GetComponent("Text")
	IpText=go.transform:FindChild("Panel_Left/Text_Nick_IP"):GetComponent("Text")
	headIconImg=go.transform:FindChild("Panel_Left/Image_icon"):GetComponent("Image")
	contactInfoContent=go.transform:FindChild("roomCardInfo/Text_Info_Content"):GetComponent("Text")
	roomCardPanel=go.transform:FindChild("roomCardInfo").gameObject
	noticeText=go.transform:FindChild("Image_Notice_BG/Image (1)/Text"):GetComponent("Text")
	logWarn("Start lua--->>"..gameObject.name);
	this.Start()
end

function HomePanelCtrl.Start()
	this.InitUI();
	GlobalData.isonLoginPage = false;
	this.checkEnterInRoom();
	this.AddListener();
	noticeText.text="我在测试啊"
	local time =string.len(noticeText.text) * 0.5 + 422 / 56;
	local textTransform = gameObject.transform:FindChild("Image_Notice_BG/Image (1)/Text")
	local tweener = textTransform:DOLocalMove(Vector3.New(-string.len(noticeText.text) * 40, textTransform.localPosition.y), time/1.6,false);
	log(this.MoveCompleted)
	tweener:OnComplete(this.MoveCompleted)
	--tweener:SetEase(Ease.Linear);
end

function HomePanelCtrl.InitUI()
	if (GlobalData.loginResponseData ~= nil) then
		local headIcon = GlobalData.loginResponseData.account.headicon;
		local nickName = GlobalData.loginResponseData.account.nickname;
		local roomCardcount = GlobalData.loginResponseData.account.roomcard;
		cardCountText.text =tostring(roomCardcount);
		nickNameText.text = nickName;
		IpText.text = "ID:" ..tostring(GlobalData.loginResponseData.account.uuid);
		coroutine.start(this.LoadImg,headIcon);
	end
end
function HomePanelCtrl.LoadImg(headIcon)
	--开始下载图片
	log("lua:HomePanelCtrl.LoadImg headIcon="..headIcon)
	if (headIcon ~= nil and headIcon ~= "") then
		if (GlobalData.wwwSpriteImage.headIcon) then
			headIconImg.sprite = GlobalData.wwwSpriteImage.headIcon;
			coroutine.stop()
		end
		local www =WWW(headIcon);
		coroutine.www(www)
		local ret,errMessage=pcall(
		function()
			--下载完成，保存图片到路径filePath
			local texture2D = www.texture;
			local bytes = texture2D:EncodeToPNG();
			--将图片赋给场景上的Sprite
			local tempSp =Sprite.Create(texture2D,Rect.New(0, 0, texture2D.width, texture2D.height),Vector2.zero);
			headIconImg.sprite = tempSp;
			GlobalData.wwwSpriteImage.headIcon=tempSp;
		end)
		if not ret then
			error("error:"..errMessage)
			return
		end
	end
end

function HomePanelCtrl.checkEnterInRoom()
	if (GlobalData.roomVo ~= nil and GlobalData.roomVo.roomId ~= 0)then
		GamePanelCtrl.Awake()
	end
end

function HomePanelCtrl.CardChangeNotice(response)
	local oldCount =tonumber(cardCountText.text);--原来的钻石数量
	local newCount=tonumber(response.message);
	cardCountText.text = response.message;
	GlobalDataScript.loginResponseData.account.roomcard =newCount;
	contactInfoContent.text ="钻石"..tostring(newCount- oldCout).."颗";
	roomCardPanel:SetActive(true);
end

function HomePanelCtrl.ContactInfoResponse(response)
	contactInfoContent.text = response.message;
	roomCardPanel:SetActive(true);
end

function HomePanelCtrl.GameBroadcastNotice()
	showNum = 0;
	if (not startFlag) then
		startFlag = true;
		this.SetNoticeTextMessage();
	end
end

function HomePanelCtrl.SetNoticeTextMessage()
	--[[if (GlobalData.noticeMegs ~= nil and GlobalData.noticeMegs.Count ~= 0) then
		noticeText.transform.localPosition = Vector3.New(500, noticeText.transform.localPosition.y);
		noticeText.text = GlobalData.noticeMegs[showNum];
		local time = noticeText.text.Length * 0.5 + 422 / 56;
		local tweener = noticeText.transform.DOLocalMove(
		Vector3.New(-noticeText.text.Length * 40, noticeText.transform.localPosition.y), time/1.6)
		.OnComplete(this.MoveCompleted);
		tweener:SetEase(Ease.Linear);
	end--]]
end

function HomePanelCtrl.MoveCompleted()
	log("MoveCompleted")
end
-------------------模板-------------------------

--关闭事件--
function HomePanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

--移除事件--
function HomePanelCtrl.RemoveListener()
	SocketEventHandle.getInstance().cardChangeNotice = nil;
	SocketEventHandle.getInstance().contactInfoResponse = nil;
	Event.RemoveListener(DisplayBroadcast,this.GameBroadcastNotice)
end

--打开事件--
function HomePanelCtrl.Open()
	if(gameObject) then
	gameObject:SetActive(true)
	transform:SetAsLastSibling();
	this.AddListener()
end
end
--增加事件--
function HomePanelCtrl.AddListener()
	SocketEventHandle.getInstance().cardChangeNotice = this.CardChangeNotice;
	SocketEventHandle.getInstance().contactInfoResponse = this.ContactInfoResponse;
	Event.AddListener(DisplayBroadcast,this.GameBroadcastNotice)
end