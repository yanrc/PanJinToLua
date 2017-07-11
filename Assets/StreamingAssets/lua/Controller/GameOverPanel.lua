GameOverPanel = UIBase(define.GameOverPanel, define.PopUI)
local this = GameOverPanel
local transform
local gameObject
-- ʱ��
local timeText
-- �����
local roomNoText
-- ����
local jushuText
-- ����
local title
-- �������
local SignalEndPanel
-- ȫ�����
local FinalEndPanel
-- �鿴ս����ť
local btnShowFinal
-- ������ť
local btnContinue
-- ����ť
local btnShare
-- �ر�/���ذ�ť
local btnReturn
-- ѡ����
local ReadySelect = { }

-- GamePanel�������б�
local AvatarvoList
-- ���������ʾ������
local SingalItem
-- ȫ�������ʾ������
local FinalItem
-- local mas_0 = { }
-- local mas_1 = { }
-- local mas_2 = { }
-- local mas_3 = { }
-- local allMasList = { }
-- local ValidMas = { }

-- �����¼�--
function GameOverPanel.OnCreate(obj)
	gameObject = obj
	transform = obj.transform
	this:Init(obj)
	timeText = transform:FindChild('Image_Game_Over_Bg/Text_Time'):GetComponent('Text')
	roomNoText = transform:FindChild('Image_Game_Over_Bg/Text_Room_Number'):GetComponent('Text')
	jushuText = transform:FindChild('Image_Game_Over_Bg/Text_Times'):GetComponent('Text')
	title = transform:FindChild('Image_Game_Over_Bg/Text_title'):GetComponent('Text')
	SignalEndPanel = transform:FindChild('Image_Game_Over_Bg/Panel_Current_Time').gameObject
	FinalEndPanel = transform:FindChild('Image_Game_Over_Bg/Panel_Final').gameObject
	btnShowFinal = transform:FindChild('Image_Game_Over_Bg/Button_Share_Current').gameObject
	btnContinue = transform:FindChild('Image_Game_Over_Bg/Button_Continue_Game').gameObject
	btnShare = transform:FindChild('Image_Game_Over_Bg/Button_Share_Final').gameObject
	btnReturn = transform:FindChild('Image_Game_Over_Bg/Button_Delete').gameObject
	ReadySelect[1] = transform:FindChild('DuanMen'):GetComponent('Toggle')
	ReadySelect[1] = transform:FindChild('Gang'):GetComponent('Toggle')
	this.lua:AddClick(btnContinue, this.ReStratGame)
	this.lua:AddClick(btnReturn, this.CloseClick)
	this.lua:AddClick(btnShowFinal, this.ShowFinal)
	this.lua:AddClick(btnShare, this.ShareFinal)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/Panel_Current_Item.prefab" }, function(prefabs) SingalItem = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/Panel_Final_Item.prefab" }, function(prefabs) FinalItem = prefabs[0] end)
end

-- ����������ʾ����
function GameOverPanel.OnOpen(avatarList, isNextBanker)
	AvatarList = avatarList;
	this.InitRoomBaseInfo();
	this.ClearPanel();
	this.ShowSingle(isNextBanker)
end

function GameOverPanel:ClearPanel()
	for i = 0, #signalEndPanel.transform.childCount do
		destroy(signalEndPanel.transform:GetChild(i).gameObject);
	end
	for i = 0, #finalEndPanel.transform.childCount do
		destroy(finalEndPanel.transform:GetChild(i).gameObject);
	end
end

-- ���÷�����Ϣ
function GameOverPanel:InitRoomBaseInfo()
	timeText.text = DateTime.Now.ToString("yyyy-MM-dd");
	roomNoText.text = "����ţ�" + GlobalData.roomVo.roomId;
	jushuText.text = "Ȧ����" ..(GlobalData.totalTimes - GlobalData.surplusTimes) .. "/" .. GlobalData.totalTimes;
	if (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_ZHUANZHUAN) then
		title.text = "תת�齫";
	elseif (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_HUASHUI) then
		title.text = "��ˮ�齫";
	elseif (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_CHANGSHA) then
		title.text = "��ɳ�齫";
	elseif (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_GUANGDONG) then
		title.text = "�㶫�齫";
	elseif (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_PANJIN) then
		title.text = "�̽��齫";
	end
end

function GameOverPanel:GetMas()

end

function GameOverPanel:SetSignalContent()
	if (GlobalData.hupaiResponseVo ~= nil) then
		for i = 1, #GlobalData.hupaiResponseVo.avatarList do
			local itemdata = GlobalData.hupaiResponseVo.avatarList[i];
			local item = newObject(SingalItem)
			item.transform:SetParent(SignalEndPanel.transform)
			item.transform.localScale = Vector3.one;
			local itemCtrl = SignalOverItem.New(item)
			local Banker = GamePanel.GetBanker()
			itemCtrl:SetUI(itemdata, Banker);
		end
	end
end

function GameOverPanel:SetFinalContent()
	if (GlobalData.finalGameEndVo.totalInfo ~= nil) then
		local itemdatas = GlobalData.finalGameEndVo.totalInfo;
		local topScore = itemdatas[1].scores;
		local topPaoshou = itemdatas[1].dianpao;
		local lastTopIndex = 1;
		local lastPaoshouIndex = 1;
		for i = 1, #itemdatas do
			-- �����Ӯ��
			if (topScore < itemdatas[i].scores) then
				lastTopIndex = i;
				topScore = itemdatas[i].scores;
			end
			-- ���������
			if (topPaoshou < itemdatas[i].dianpao and not itemdatas[i].IsWiner) then
				lastPaoshouIndex = i;
				topPaoshou = itemdatas[i].dianpao;
			end
		end
		itemdatas[lastTopIndex].IsWiner = true;
		itemdatas[lastPaoshouIndex].IsPaoshou = true;
		local owerUuid = GlobalData.finalGameEndVo.theowner;
		for i = 1, #itemdatas do
			local itemdata = itemdatas[i];
			-- ׯ��
			if (owerUuid == itemdata.uuid) then
				itemdata.IsMain = true;
			end
			local account = GamePanel.GetAccount(itemdata.uuid);
			-- ͷ�������
			if (account ~= nil) then
				itemdata.Icon = account.headicon;
				itemdata.Nickname = account.nickname;
			end
			local item = newObject(FinalItem)
			item.transform.parent = FinalEndPanel.transform;
			item.transform.localScale = Vector3.one;
			local itemCtrl = FinalOverItem.New(item)
			itemCtrl:SetUI(itemdata);
		end
	end
end
-- ��ʼ��һ��
function GameOverPanel.ReStratGame()
	local Readyvo = { }
	Readyvo.duanMen = ReadySelect[0].isOn;
	Readyvo.jiaGang = ReadySelect[1].isOn;
	networkMgr:SendMessage(ClientRequest.New(APIS.PrepareGame_MSG_REQUEST, json.decode(Readyvo)));
	soundMgr:playSoundByActionButton(1);
	ClosePanel(this)
end

function GameOverPanel.ShowSingle(isNextBanker)
	SignalEndPanel:SetActive(true);
	FinalEndPanel:SetActive(false);
	btnShare:SetActive(false);
	btnReturn:SetActive(false);
	-- ���ֽ�������ʾ�鿴ս����ť
	if (GlobalData.surplusTimes == 0 or GlobalData.isOverByPlayer) then
		btnShowFinal:SetActive(true);
		btnContinue:SetActive(false);
	else
		btnShowFinal:SetActive(false);
		btnContinue:SetActive(true);
		ReadySelect[0].gameObject:SetActive(GlobalData.roomVo.duanMen);
		ReadySelect[1].gameObject:SetActive(GlobalData.roomVo.jiaGang);
		ReadySelect[0].interactable = isNextBanker;
	end
	this.SetSignalContent();
end

function GameOverPanel.ShowFinal()
	SignalEndPanel:SetActive(false);
	btnContinue:SetActive(false);
	btnShowFinal:SetActive(false);
	FinalEndPanel:SetActive(true);
	btnShare:SetActive(true);
	btnReturn:SetActive(true);
	this.SetFinalContent();
	soundMgr:playSoundByActionButton(1);
end

function GameOverPanel.ShareFinal()
	GlobalData.wechatOperate:shareAchievementToWeChat(PlatformType.WeChat);
	soundMgr:playSoundByActionButton(1);
end
-------------------ģ��-------------------------
function GameOverPanel.CloseClick()
	ClosePanel(this)
	OpenPanel(HomePanel)
end

function GameOverPanel.OnOpen()

end