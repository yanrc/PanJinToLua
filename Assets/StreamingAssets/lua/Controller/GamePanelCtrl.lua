require "View/GamePanel"
require "Logic/ButtonAction"
require "Data/DirectionEnum"
GamePanelCtrl={}
local this=GamePanelCtrl;
local gameObject;
this.playerItems={}
local timeFlag=false
local versionText
local btnActionScript
local dialog_fanhui
local showTimeNumber=0
--�����飬��ά
--1 �� �� �� value == 1 ��  value == 2 �ܣ�
--0 �� �±�Ϊ�� ����Ϊ���Ƶ�����
--��ʼ�����������õ�����������ֵ����ֻ�õ�����
local mineList
--�����б���ά�������gameObject
--0�Լ���1-�ұߡ�2-�ϱߡ�3-���
--�Լ��ᱣ���������ƣ������˲�����
local handerCardList
--�������ϵ���
local tableCardList
--������list
local PengGangList_L
local PengGangList_R
local PengGangList_T
local PengGangList_B
--
local avatarList
local bankerId--ׯ��
local curDirString
local LeavedRoundNumText
local isFirstOpen
local ruleText
--�ܷ������˳����䣬��ʼΪfalse����ʼ��Ϸ��true
local canClickButtonFlag=false
local inviteFriendButton
local btnJieSan
local ExitRoomButton
local live1
local live2
local centerImage
local liujuEffectGame
local ruleText
local LeavedCastNumText
local MoPaiCardPoint
local SelfAndOtherPutoutCard
local useForGangOrPengOrChi
local passStr
local chiPaiPointList
function GamePanelCtrl.Awake()
	logWarn("GamePanelCtrl.Awake--->>");
	if(CtrlManager.GamePanelCtrl) then
	this.Open()
else
	PanelManager:CreatePanel('GamePanel', this.OnCreate);
	CtrlManager.AddCtrl("GamePanelCtrl",this)
end
end

function GamePanelCtrl.OnCreate(go)
	logWarn("Start lua--->>"..go.name);
	gameObject = go;
	transform=go.transform
	lua = gameObject:GetComponent('LuaBehaviour');
	versionText=transform:FindChild('Text_version'):GetComponent('Text');
	btnActionScript =ButtonAction.New();
	dialog_fanhui=transform:FindChild('jiesan')
	LeavedRoundNumText=transform:FindChild('Leaved1/Text'):GetComponent('Text');
	ruleText=transform:FindChild('Rule'):GetComponent('Text');
	inviteFriendButton=transform:FindChild('Button_invite_friend'):GetComponent('Button');
	btnJieSan=transform:FindChild('Button_jiesan'):GetComponent('Button');
	ExitRoomButton=transform:FindChild('Button_other'):GetComponent('Button');
	live1=transform:FindChild('Leaved'):GetComponent('Image');
	live2=transform:FindChild('Leaved1'):GetComponent('Image');
	centerImage=transform:FindChild('table'):GetComponent('Image');
	liujuEffectGame=transform:FindChild('Liuju_B').gameObject
	ruleText=transform:FindChild('Rule'):GetComponent('Text');
	LeavedCastNumText=transform:FindChild('Leaved/Text'):GetComponent('Text');

	this.Start()
end
function GamePanelCtrl.Start()
	RandShowTime();
	timeFlag = true;
	soundMgr:playBGM(2);
	--norHu = new NormalHuScript();
	--naiziHu = new NaiziHuScript();
	--gameTool = new GameToolScript();
	versionText.text = "V" .. Application.version;
	this.AddListener();
	InitPanel();
	InitArrayList();
	--initPerson ();--��ʼ��ÿ����Ա1000��
	GlobalData.isonLoginPage = false;
	if (GlobalData.reEnterRoomData ~= nil) then
		--�����������뷿��
		GlobalData.loginResponseData.roomId = GlobalData.reEnterRoomData.roomId;
		ReEnterRoom();
	elseif (GlobalData.roomJoinResponseData ~= nil) then
		--�������˷���
		JoinToRoom(GlobalData.roomJoinResponseData.playerList);
	else
		--��������
		CreateRoomAddAvatarVO(GlobalData.loginResponseData);
	end
	GlobalData.reEnterRoomData = nil;
	TipsManager.Instance().setTips("",0);
	dialog_fanhui.gameObject:SetActive(false);
	InitbtnJieSan();
	UpdateBeat:Add(this.Update);
end

function GamePanelCtrl.ExitOrDissoliveRoom()
	GlobalData.loginResponseData.resetData();--��λ��������
	GlobalData.loginResponseData.roomId = 0;--��λ��������
	GlobalData.roomJoinResponseData = nil;--��λ��������
	GlobalData.roomVo.roomId = 0;
	--GlobalData.soundToggle = true;
	this.Clean();
	soundMgr:playBGM(1);
	if (HomePanel.gameObject ~= nil) then
		HomePanelCtrl.Open();

	else
		HomePanelCtrl.Awake();
	end

	while #playerItems > 0 do
		local item = playerItems[1];
		table.remove(playerItems,1)
		item.Clean();
		Destroy(item.gameObject);
	end
	this.Close();
end

local function RandShowTime()
	showTimeNumber =math.random(5000,10000)
end

local function InitPanel()
	Clean()
	btnActionScript.CleanBtnShow()
end

local function InitArrayList()
	mineList ={}
	handerCardList = {}
	tableCardList = {}
	PengGangList_L = {};
	PengGangList_R = {};
	PengGangList_T = {};
	PengGangList_B={};
end

local function CardSelect(obj)
	if GlobalData.isChiState then

		OnChipSelect(obj, true);

	else

		for k,v in pairs(handerCardList[1]) do
			if v == nil then
				handerCardList[1][k] = nil
			else
				handerCardList[1][k].transform.localPosition =Vector3.New(handerCardList[0][k].transform.localPosition.x, -292); --���ҵ������ζ���
				handerCardList[1][k].BottomScript.selected = false;
			end
		end

		if (obj ~= nil) then

			obj.transform.localPosition =Vector3.New(obj.transform.localPosition.x, -272);
			obj.bottomScript.selected = true;

		end
	end
end

local function StartGame(response)
	GlobalData.roomAvatarVoList = avatarList;
	--GlobalDataScript.surplusTimes -= 1;
	local sgvo =json.decode(response.message);
	bankerId = sgvo.bankerId;
	GlobalData.roomVo.guiPai = sgvo.gui;
	CleanGameplayUI ();
	--��ʼ��Ϸ����ʾ
	log("lua:GamePanelCtrl.StartGame");
	GlobalData.surplusTimes=GlobalData.surplusTimes-1;
	curDirString =GetDirection (bankerId);
	LeavedRoundNumText.text =tostring(GlobalData.surplusTimes)--ˢ��ʣ�����
	if (not isFirstOpen) then
		btnActionScript =ButtonAction.New();
		InitPanel ();
		--InitArrayList ();
		avatarList [bankerId].main = true;
	end
	GlobalData.finalGameEndVo = null;
	GlobalData.mainUuid = avatarList[bankerId].account.uuid;
	InitArrayList ();
	curDirString =GetDirection (bankerId);
	playerItems [GetIndexByDir(curDirString)]:SetbankImgEnable (true);
	SetDirGameObjectAction();
	isFirstOpen = false;
	GlobalData.isOverByPlayer = false;
	mineList = sgvo.paiArray;--����
	UpateTimeReStart ();
	DisplayTouzi(sgvo.touzi, sgvo.gui);--��ʾ����
	--displayGuiPai(sgvo.gui);
	SetAllPlayerReadImgVisbleToFalse ();
	InitMyCardListAndOtherCard (13,13,13);
	ShowLeavedCardsNumForInit();
	if (curDirString == DirectionEnum.Bottom) then
		--isSelfPickCard = true;
		GlobalData.isDrag = true;
	else
		--isSelfPickCard = false;
		GlobalData.isDrag = false;
	end
	local ruleStr = "";
	if (GlobalData.roomVo ~= nil and GlobalData.roomVo.roomType == 5) then
		if (GlobalData.roomVo.pingHu == true) then
			ruleStr=ruleStr .. "���\n";
		end
		if (GlobalData.roomVo.baoSanJia == true) then
			ruleStr=ruleStr  .. "������\n";
		end
		if (GlobalDataScript.roomVo.gui == 2) then
			ruleStr=ruleStr  .. "�����\n";
		end
		if (GlobalDataScript.roomVo.jue == true) then
			ruleStr=ruleStr  .. "��\n";
		end
		if (GlobalDataScript.roomVo.jiaGang == true) then
			ruleStr=ruleStr  .. "�Ӹ�\n";
		end
		if (GlobalDataScript.roomVo.duanMen == true and sgvo.duanMen) then
			ruleStr=ruleStr  .. "�����\n";
		end
		if (GlobalDataScript.roomVo.jihu == true) then
			ruleStr=ruleStr  .. "����\n";
		end
		if (GlobalDataScript.roomVo.qingYiSe == true) then
			ruleStr=ruleStr  .. "��һɫ\n";
		end
		ruleText.text = ruleStr;
	end
	for i = 1,#playerItems do
		if(sgvo.jiaGang[i]) then
		playerItems[GetIndexByDir(GetDirection(i))].jiaGang.text = "�Ӹ�"
	else
		playerItems[GetIndexByDir(GetDirection(i))].jiaGang.text = ""
	end
end

local jiaGang = GameToolScript.boolArrToInt(sgvo.jiaGang);
PlayerPrefs.SetInt("jiaGang", jiaGang);
log("lua:jiaGang=" ..tostring(jiaGang));
end

local function CleanGameplayUI()
	canClickButtonFlag = true;
	--weipaiImg.transform.gameObject.SetActive(false);
	inviteFriendButton.transform.gameObject:SetActive(false);
	btnJieSan.gameObject:SetActive(false);
	ExitRoomButton.transform.gameObject:SetActive(false);
	live1.transform.gameObject:SetActive(true);
	live2.transform.gameObject:SetActive(true);
	--tab.transform.gameObject.SetActive(true);
	centerImage.transform.gameObject:SetActive(true);
	liujuEffectGame:SetActive(false);
	ruleText.text = "";
end

local function ShowLeavedCardsNumForInit()
	local roomCreateVo = GlobalData.roomVo;
	local hong =roomCreateVo.hong;
	local RoomType = roomCreateVo.roomType;
	if (RoomType == 1) then
		--תת�齫
		LeavedCardsNum = 108;
		if (hong) then
			LeavedCardsNum = 112;
		end
	elseif (RoomType == 2) then
		--��ˮ�齫
		LeavedCardsNum = 108;
		if (roomCreateVo.addWordCard) then
			LeavedCardsNum = 136;
		end
	elseif (RoomType == 3) then
		LeavedCardsNum = 108;
	elseif (RoomType == 4) then
		LeavedCardsNum = 108;
		if (roomCreateVo.addWordCard) then
			LeavedCardsNum = 136;
		end
	elseif (RoomType == 5) then
		--�̽��齫
		LeavedCardsNum = 108;
		if (roomCreateVo.addWordCard) then
			LeavedCardsNum = 136;
		end
	elseif (RoomType == 6) then
		--�����齫
		LeavedCardsNum = 116;
		if (roomCreateVo.addWordCard) then
			LeavedCardsNum = 144;
		end
		LeavedCardsNum = LeavedCardsNum - 53;
		LeavedCastNumText.text = tostring(LeavedCardsNum);
	end
end

local function CardsNumChange()
	LeavedCardsNum=LeavedCardsNum-1;
	if (LeavedCardsNum < 0)then
		LeavedCardsNum = 0;
	end
	LeavedCastNumText.text =tostring(LeavedCardsNum);
end
--��������֪ͨ
local function OtherPickCard(response)
	UpateTimeReStart ();
	local json = json.decode(response.message);
	--��һ�������˵�����
	local avatarIndex =json["avatarIndex"];
	log ("GamePanelCtrl.OtherPickCard:otherPickCard avatarIndex = "..tostring(avatarIndex));
	OtherPickCardAndCreate(avatarIndex);
	SetDirGameObjectAction ();
	CardsNumChange();
	GlobalData.isChiState = false;
end
local function OtherPickCardAndCreate(avatarIndex)
	local myIndex = GetMyIndexFromList();
	local seatIndex = avatarIndex - myIndex;
	if (seatIndex < 0) then
		seatIndex = 4 + seatIndex;
	end
	curDirString = playerItems[seatIndex].dir;
	OtherMoPaiCreateGameObject(curDirString);
end

local function OtherMoPaiCreateGameObject()
	local tempVector3 =Vector3.zero;
	local switch = {
	[DirectionEnum.Top]=Vector3.New(-273, 0),
	[DirectionEnum.Left]=Vector3.New(0, -173),
	[DirectionEnum.Right]= Vector3.New(0, 183)
	}
	tempVector3=switch[dir]
	local path = "Assets/Project/Prefabs/card/Bottom_" + dir;
	--ʵ������ǰ������
	otherPickCardItem = CreateGameObjectAndReturn (path,parentList[GetIndexByDir(dir)],tempVector3);
	otherPickCardItem.transform.localScale = Vector3.one;
end

local function PickCard(response)
	UpateTimeReStart();
	local cardvo = json.decode(response.message);
	MoPaiCardPoint = cardvo.cardPoint;
	log("GamePanelCtrl:PickCard:����" ..tostring(MoPaiCardPoint));
	SelfAndOtherPutoutCard = MoPaiCardPoint;
	useForGangOrPengOrChi = cardvo.cardPoint;
	PutCardIntoMineList(MoPaiCardPoint);
	MoPai();
	curDirString = DirectionEnum.Bottom;
	SetDirGameObjectAction();
	CardsNumChange();
	GlobalData.isDrag = true;
end
-- �����ܣ������ԣ�pass��ť��ʾ.
local function ActionBtnShow(response)
	GlobalData.isDrag = false;
	GlobalData.isChiState = false;
	log("GamePanelCtrl ActionBtnShow:msg ="..tostring(response.message));
	local strs =string.split(response.message,',')
	if (curDirString == DirectionEnum.Bottom) then
		passType = "selfPickCard";
	else
		passType = "otherPickCard";
	end
	btnActionScript.ShowBtn(5);
	for i = 1,#strs do
		if string.match(strs[i],"hu") then
			btnActionScript.ShowBtn(1);
			passStr=passStr.."hu_"
		end
		if string.match(strs[i],"qianghu") then
			SelfAndOtherPutoutCard = string.split(str[i],':')[2]
			btnActionScript.ShowBtn(1);
			isQiangHu = true;
			passStr=passStr.."qianghu_"
		end
		if string.match(strs[i],"peng") then
			btnActionScript.ShowBtn(3);
			putOutCardPoint = string.split(str[i],':')[3]
			passStr=passStr.."peng_"
		end
		if string.match(strs[i],"gang") then
			btnActionScript.ShowBtn(2);
			gangPaiList = string.split(str[i],':');
			table.remove(gangPaiList,1)
			passStr=passStr.."gang_"
		end
		if string.match(strs[i],"chi") then
			--��ʽ��chi��������ң�������|��1_��2_��3| ��1_��2_��3
			--eg:"chi:1:2|1_2_3|2_3_4"
			GlobalData.isChiState = true;
			local strChi =string.split(str[i],'|');
			putOutCardPoint = string.split(str[1],':')[3];
			chiPaiPointList={};
			for m = 2,#strChi do
				local strChiList =string.split(str[i],'_');
				local cpoint ={};
				cpoint.putCardPoint = putOutCardPoint;
				for n = 1,#strChiList do
					if (strChiList[n]== putOutCardPoint) then
						table.remove(strChiList,n)
					end
					cpoint.oneCardPoint=strChiList[1]
					cpoint.twoCardPoint=strChiList[2]
					chiPaiPointList.Add(cpoint);
				end
				btnActionScript.ShowBtn(4);
				passStr=passStr.."chi_"
			end
		end
	end
end

--�������򣬹����Ƶ���ǰ
local function SortMyCardList()
	local guipaiList={};
	for k,v in pairs(handerCardList[1]) do
		if (v ~= nil) then
			if (v.BottomScript.GetPoint() == GlobalData.roomVo.guiPai) then
				guipaiList.Add(v);--����
				handerCardList[1][k]=nil
			end
		end
	end
	table.sort(handerCardList[1])
	for k,v in pairs(guipaiList) do
		table.insert(handerCardList[1],0,v)
	end
end
--��ʼ������
local function InitMyCardListAndOtherCard(topCount,leftCount,rightCount)
	for i = 1,#mineList[1].Count do --�ҵ���13��
		if (mineList[1][i] > 0) then
			for j = 1,#mineList[1][i] do
				local gob = resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/card/Bottom_B.prefab'},function()
					if (gob ~= nil) then
						gob.transform.SetParent(parentList[0]);
						gob.transform.localScale =Vector3.New(1.1,1.1,1);
						gob.bottomScript=BottomScript.New();
						gob.bottomScript.onSendMessage = CardChange;
						gob.bottomScript.reSetPoisiton = CardSelect;
						gob.bottomScript.setPoint(i, GlobalData.roomVo.guiPai);
						SetPosition(false);
						handerCardList[1].Add(gob);
					else
						log("GamePanelCtrl InitMyCardListAndOtherCard:"..tostring(i).."is null");--��Ϸ����Ϊ��
					end
				end)
			end
			SortMyCardList ();
		end
	end
	InitOtherCardList (DirectionEnum.Left,leftCount);
	InitOtherCardList (DirectionEnum.Right,rightCount);
	InitOtherCardList (DirectionEnum.Top,topCount);
	if (bankerId == GetMyIndexFromList()) then
		SetPosition(true);--����λ��
		--checkHuPai();
	else
		SetPosition(false);
		OtherPickCardAndCreate(bankerId);
	end
end
local function SetAllPlayerReadImgVisbleToFalse()
	for _,v in pairs(playerItems) do
		v.readyImg.enabled = false;
	end
end
local function SetAllPlayerHuImgVisbleToFalse()
	for _,v in pairs(playerItems) do
		v:SetHuFlagHidde(false) ;
	end
end

local function GetIndexByDir(dir)
	local result = 0;
	local switch=
	{
	[DirectionEnum.Top]=3,
	[DirectionEnum.Left]=4,
	[DirectionEnum.Right]=2,
	[DirectionEnum.Bottom]=1
	}
	result=switch[dir]
	return result;
end

--��ʼ�������˵�����
local function InitOtherCardList(initDiretion,count)
	for i = 1,count do
		local temp =resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/card/Bottom_B.prefab'},function() --ʵ������ǰ��
		if (temp ~= nil) then--�п���û����
			temp.transform:SetParent(parentList[GetIndexByDir(initDiretion)]);
			temp.transform.localScale = Vector3.one;
			local switch={
			[DirectionEnum.Top] = function()
				temp.transform.localPosition = Vector3.New(-204 + 38 * i, 0);
				handerCardList[3].Add(temp);
				temp.transform.localScale = Vector3.one; --ԭ��С
			end,
			[DirectionEnum.Left] = function()
				temp.transform.localPosition = Vector3.New(0, -105 + i * 30);
				temp.transform.SetSiblingIndex(0);
				handerCardList[4].Add(temp);
			end,
			[DirectionEnum.Right]=function()
				temp.transform.localPosition = Vector3.New(0, 119 - i * 30);
				handerCardList[2].Add(temp);
			end
			}
			switch[initDiretion]();
		end
	end)
end
end

--����
local function MoPai()
	pickCardItem=resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/card/Bottom_B.prefab'},function()
		log ("GamePanelCtrl MoPai:"..tostring(MoPaiCardPoint));
		if (pickCardItem ~= nil) then --�п���û����
			pickCardItem.name = "pickCardItem";
			pickCardItem.transform:SetParent(parentList[1]); --���ڵ�
			pickCardItem.transform.localScale = Vector3.New(1.1,1.1,1);--ԭ��С
			pickCardItem.transform.localPosition =Vector3.New(580, -292); --λ��
			pickCardItem.bottomScript=BottomScript.New()
			pickCardItem.bottomScript.onSendMessage = cardChange;
			pickCardItem.bottomScript.reSetPoisiton = cardSelect;
			pickCardItem.bottomScript:SetPoint(MoPaiCardPoint, GlobalData.roomVo.guiPai);
			InsertCardIntoList(pickCardItem);
		end
	end)
end
function putCardIntoMineList(cardPoint)
	if (mineList[1][cardPoint] < 4) then
		mineList[1][cardPoint]=mineList[1][cardPoint]+1;
	end
end
function pushOutFromMineList(cardPoint)
	if (mineList[1][cardPoint] > 0) then
		mineList[1][cardPoint]=mineList[1][cardPoint]-1;
	end
end
--���յ������˵ĳ���֪ͨ
local function OtherPutOutCard(response)
	local json = json.decode(response.message);
	local cardPoint = json["cardIndex"];
	local curAvatarIndex =json["curAvatarIndex"];
	putOutCardPointAvarIndex = GetIndexByDir(GetDirection(curAvatarIndex));
	log("otherPickCard avatarIndex = " ..tostring(curAvatarIndex));
	useForGangOrPengOrChi = cardPoint;
	if (otherPickCardItem ~=nil) then
		local dirIndex = GetIndexByDir(GetDirection(curAvatarIndex));
		CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, otherPickCardItem.transform.position);
		Destroy(otherPickCardItem);
		otherPickCardItem = nil;
	else
		local dirIndex = GetIndexByDir(GetDirection(curAvatarIndex));
		local obj = handerCardList[dirIndex][1];
		CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, obj.transform.position);
		table.remove(handerCardList[dirIndex],1)
		Destroy(obj)
	end
	--createPutOutCardAndPlayAction(cardPoint, curAvatarIndex);
	GlobalData.isChiState = false;
end
--���������ĵ��ƶ��󣬲��ҿ�ʼ���Ŷ���
local function CreatePutOutCardAndPlayAction(cardPoint,curAvatarIndex,position)
	soundMgr:playSound (cardPoint,avatarList[curAvatarIndex].account.sex);
	local tempVector3 =Vector3.zero;
	local destination =Vector3.zero;
	local path = "";
	local Dir = GetDirection(curAvatarIndex);
	local switch=
	{
	[DirectionEnum.Bottom]=function()
		path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		tempVector3 = Vector3.New(0, -100);
		destination =  Vector3.New(-261 + tableCardList[0].Count % 14 * 37, (int)(tableCardList[0].Count / 14) * 67);
	end,
	[DirectionEnum.Right]=function()
		path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_R";
		tempVector3 =  Vector3.New(420, 0);
		destination =  Vector3.New((-tableCardList[1].Count / 13 * 54), -180 + tableCardList[1].Count % 13 * 28);
	end,
	[DirectionEnum.Top]=function()
		path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		tempVector3 = Vector3.New(0, 130);
		destination =  Vector3.New(289 - tableCardList[2].Count % 14 * 37, -(int)(tableCardList[2].Count / 14) * 67);
	end,
	[DirectionEnum.Left]=function()
		path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_L";
		tempVector3 =  Vector3.New(-370, 0);
		destination =  Vector3.New(tableCardList[3].Count / 13 * 54, 152 - tableCardList[3].Count % 13 * 28);
	end
	}
	switch[Dir]()
	local tempGameObject = CreateGameObjectAndReturn(path, parentList[0], tempVector3);
	tempGameObject.transform.position = position;
	tempGameObject.name = "putOutCard";
	tempGameObject.transform.localScale = Vector3.one;
	tempGameObject.transform.parent = outparentList[GetIndexByDir(Dir)];
	if (Dir == DirectionEnum.Right or Dir == DirectionEnum.Left) then
		tempGameObject.TopAndBottomCardScript=TopAndBottomCardScript.New()
		tempGameObject.TopAndBottomCardScript.SetLefAndRightPoint(cardPoint);
		if(Dir == DirectionEnum.Right) then
		tempGameObject.transform:SetAsFirstSibling();
	end
else
	tempGameObject.TopAndBottomCardScript=TopAndBottomCardScript.New()
	tempGameObject.TopAndBottomCardScript.SetPoint(cardPoint);
end
putOutCardPoint = cardPoint;
SelfAndOtherPutoutCard = cardPoint;
putOutCard = tempGameObject;
local tweener = tempGameObject.transform:DOLocalMove(destination,1).OnComplete(
function()
	DestroyPutOutCard(cardPoint, Dir);
	if (putOutCard ~= nil) then
		Destroy(putOutCard, 1);
	end
end);
if (Dir ~= DirectionEnum.Bottom) then
	tweener:SetEase(Ease.OutExpo);
else
	tweener:SetEase(Ease.OutExpo);
end
end

--����һ��������������������õ���������ڵķ�λ��L-��T-��,R-�ң�B-�£��Լ���
local function GetDirection()
	local result = DirectionEnum.Bottom;
	local myselfIndex = GetMyIndexFromList();
	if (myselfIndex == avatarIndex) then
		--log ("getDirection == B");
		return result;
	end
	--���Լ���ʼ���㣬��һλ������
	for i = 1,4 do
		myselfIndex=myselfIndex+1;
		if (myselfIndex >= 5) then
			myselfIndex = 1;
		end
		if (myselfIndex == avatarIndex) then
			if (i == 1) then
				--log ("getDirection == R");
				return DirectionEnum.Right;
			elseif (i == 2) then
				--log ("getDirection == T");
				return DirectionEnum.Top;
			else
				--log ("getDirection == L");
				return DirectionEnum.Left;
			end
		end
		return result;
	end
end


-- ���ú�ɫ��ͷ����ʾ����
function SetDirGameObjectAction() --���÷���
	--UpateTimeReStart();
	for i = 1,#dirGameList do
		dirGameList [i]:SetActive (false);
	end
	dirGameList[GetIndexByDir(curDirString)]:SetActive(true);
end

local function ThrowBottom(index,Dir)
	local temp = null;
	local path = "";
	local poisVector3 = Vector3.one;
	log("put out huaPaiPoint"..tostring(index).."---ThrowBottom---");
	if (Dir == DirectionEnum.Bottom) then
		path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		poisVector3 = Vector3.New(-261 + tableCardList[0].Count%14*37, (int)(tableCardList[0].Count/14)*67);
		GlobalDataScript.isDrag = false;
	elseif (Dir == DirectionEnum.Right) then
		path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_R";
		poisVector3 = Vector3.New((-tableCardList[1].Count/13*54), -180 + tableCardList[1].Count%13*28);
	elseif (Dir == DirectionEnum.Top) then
		path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		poisVector3 = Vector3.New(289 - tableCardList[2].Count%14*37, -(int)(tableCardList[2].Count/14)*67);
	elseif (Dir == DirectionEnum.Left) then
		path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_L";
		poisVector3 = Vector3.New(tableCardList[3].Count/13*54, 152 - tableCardList[3].Count%13*28);
		--parenTransform = leftOutParent;
	end
	temp = CreateGameObjectAndReturn (path,outparentList[getIndexByDir(Dir)],poisVector3);
	temp.transform.localScale = Vector3.one;
	temp.TopAndBottomCardScript=TopAndBottomCardScript.New()
	if (Dir == DirectionEnum.Right or Dir == DirectionEnum.Left) then
		temp.TopAndBottomCardScript:setLefAndRightPoint(index);
	else
		temp.TopAndBottomCardScript:setPoint(index);
	end
	cardOnTable = temp;
	--temp.transform.SetAsLastSibling();
	table.insert(tableCardList[GetIndexByDir(Dir)],temp)
	if (Dir == DirectionEnum.Right) then
		temp.transform.SetSiblingIndex(0);
	end
	--������?
	--������?
	SetPointGameObject(temp);
end


local function PengCard(response)
	UpateTimeReStart ();
	local cardVo = json.decode(response.message);
	otherPengCard = cardVo.cardPoint;
	curDirString = GetDirection (cardVo.avatarId);
	print("Current Diretion==========>" + curDirString);
	SetDirGameObjectAction ();
	effectType = "peng";
	PengGangHuEffectCtrl();
	soundMgr:playSoundByAction ("peng",avatarList [cardVo.avatarId].account.sex);
	--�������ϱ�������
	if (cardOnTable ~= nil) then
		ReSetOutOnTabelCardPosition (cardOnTable);
		Destroy (cardOnTable);
	end
	if (curDirString == DirectionEnum.Bottom) then
		--�Լ�����
		putCardIntoMineList(putOutCardPoint)--��mineList[1]���Ӽ�һ����
		mineList[2][putOutCardPoint] = 2;--����������2����
		--��handerCardList[1]�Ƴ�2����
		local removeCount = 0;
		for k,v in pairs(handerCardList[1]) do
			if(v.bottomScript.GetPoint()==putOutCardPoint)then
			v=nil
			removeCount=removeCount+1
			if(removeCount==2) then
			break
		end
	end
end
SetPosition(true);
BottomPeng();
else
	--����������
	local tempCardList = handerCardList[getIndexByDir(curDirString)];
	local path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_" + curDirString;
	if (tempCardList ~= nil)then
		--ֱ�Ӽ���ǰ��2����
		for i = 1, 2 do
			Destroy(tempCardList[1]);
			table.remove(tempCardList,1)
		end

		--�����ѵ�һ�����õ����ұߣ���������
		otherPickCardItem = tempCardList[0];
		GameToolScript.setOtherCardObjPosition(tempCardList, curDirString, 1);
		--������handerCardList����������ϵ���
		table.remove(tempCardList,1)
	end
	local tempvector3 =Vector3.zero;
	local tempList = {}
	--��ʾ3����
	local switch={
	[DirectionEnum.Right]=function()
		for i = 1,3 do
			local obj=resMgr:LoadPrefab('prefabs',{path+".prefab"},function()
				obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
				obj.TopAndBottomCardScript:setLefAndRightPoint(cardVo.cardPoint);
				tempvector3 =Vector3.New(0, -122 + PengGangList_R.Count * 95 + i * 26);
				obj.transform.parent = pengGangParenTransformR.transform;
				obj.transform:SetSiblingIndex(0);
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = tempvector3;
				table.insert(tempList,obj)
			end)
		end
	end,
	[DirectionEnum.Top]=function()
		for i = 1,3 do
			local obj=resMgr:LoadPrefab('prefabs',{path+".prefab"},function()
				obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
				obj.TopAndBottomCardScript:setPoint(cardVo.cardPoint);
				tempvector3 = Vector3.New(251 - PengGangList_T.Count * 120 + i * 37, 0, 0);
				obj.transform.parent = pengGangParenTransformT.transform;
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = tempvector3;
				table.insert(tempList,obj)
			end)
		end
	end,
	[DirectionEnum.Left]=function()
		for i = 1,3 do
			local obj=resMgr:LoadPrefab('prefabs',{path+".prefab"},function()
				obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
				obj.TopAndBottomCardScript:setLefAndRightPoint(cardVo.cardPoint);
				tempvector3 = new Vector3(0, 122 - PengGangList_L.Count * 95 - i * 26, 0);
				obj.transform.parent = pengGangParenTransformL.transform;
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = tempvector3;
				table.insert(tempList,obj)
			end)
		end
	end
	}
	switch[curDirString]();
	AddListToPengGangList(curDirString, tempList);
end
GlobalData.isChiState = false;
end


function ChiCard(response)
	UpateTimeReStart();
	print("ChiCard:"..response.message)
	local cardVo = json.decode(response.message);
	otherPengCard = cardVo.cardPoint;
	curDir = GetDirection(cardVo.avatarId);
	SetDirGameObjectAction();
	effectType = "chi";
	PengGangHuEffectCtrl();
	soundMgr:playSoundByAction("chi", avatarList[cardVo.avatarId].account.sex);
	if (cardOnTable~= nil) then
		ReSetOutOnTabelCardPosition(cardOnTable);
		Destroy(cardOnTable);
	end
	if (curDir == DirectionEnum.Bottom) then
		--�Լ�����
		mineList[1][putOutCardPoint]=mineList[1][putOutCardPoint]+1;
		--mineList[3][putOutCardPoint] = 1;
		--��һ������
		for k,v in pairs(handerCardList[1]) do
			if(v.bottomScript.GetPoint()==cardVo.onePoint)then
			v=nil
			break
		end
	end
	--�ڶ�������
	for k,v in pairs(handerCardList[1]) do
		if(v.bottomScript.GetPoint()==cardVo.twoPoint)then
		v=nil
		break
	end
end
SetPosition(true);
BottomChi(otherPengCard,cardVo.onePoint,cardVo.twoPoint)
else
	--�����˳���
	local tempCardList = handerCardList[getIndexByDir(curDir)];
	local path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_" + curDir;
	if (tempCardList ~= nil) then
		for i = 1, 2 do
			Destroy(tempCardList[1]);
			table.remove(tempCardList,1)
		end
		otherPickCardItem = tempCardList[1];
		GameToolScript.setOtherCardObjPosition(tempCardList, curDir, 1);
		table.remove(tempCardList,1)
	end
	local tempvector3 = Vector3.zero
	local tempList = {}
	for i = 1,3 do
		local obj=resMgr:LoadPrefab('prefabs',{path+".prefab"},function()
			obj.TopAndBottomCardScript=TopAndBottomCardScript.New();
			if (i == 0) then
				obj.TopAndBottomCardScript:Init(cardVo.cardPoint, curDir, GlobalData.roomVo.guiPai == cardVo.cardPoint);
			elseif (i == 1) then
				obj.TopAndBottomCardScript:Init(cardVo.onePoint, curDir, GlobalData.roomVo.guiPai == cardVo.onePoint);
			elseif (i == 2) then
				obj.TopAndBottomCardScript:Init(cardVo.twoPoint, curDir, GlobalData.roomVo.guiPai == cardVo.twoPoint);
			end
			local switch=
			{
			[DirectionEnum.Right]=function()
				tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + i * 26);
				obj.transform.parent = pengGangParenTransformR.transform;
				obj.transform:SetSiblingIndex(0);
			end,
			[DirectionEnum.Top]=function()
				tempvector3 = Vector3.New(251 - #PengGangList_T* 120 + i * 37, 0, 0);
				obj.transform.parent = pengGangParenTransformT.transform;
			end,
			[DirectionEnum.Left]=function()
				tempvector3 = Vector3.New(0, 122 - #PengGangList_L * 95 - i * 26, 0);
				obj.transform.parent = pengGangParenTransformL.transform;
			end
			}
			switch[curDir]()
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition = tempvector3;
			table.insert(tempList,obj)
		end)
	end
	AddListToPengGangList(curDir, tempList);
end
end

function BottomPeng()
	local templist = {}
	for i=1,3 do
		local obj=resMgr:LoadPrefab('prefabs',{"Assets/Project/Prefabs/PengGangCard/PengGangCard_B.prefab"},function()
			obj.transform.parent=pengGangParenTransformB.transform
			obj.transform.localPosition=Vector3.New(-370 + #PengGangList_B * 190 + i * 60, 0);
			obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
			obj.TopAndBottomCardScript:Init(putOutCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == putOutCardPoint);
			obj.transform.localScale = Vector3.one;
			table.insert(templist,obj)
		end)
	end
	table.insert(PengGangList_B,templist)
	GlobalData.isDrag = true;
end


function BottomChi(putCardPoint,oneCardPoint,twoCardPoint)
	local templist ={};
	for i=1,3 do
		local obj=resMgr:LoadPrefab('prefabs',{"Assets/Project/Prefabs/PengGangCard/PengGangCard_B.prefab"},function()
			obj.transform.parent=pengGangParenTransformB.transform
			obj.transform.localPosition=Vector3.New(-370 + #PengGangCardList * 190 + j * 60, 0);
			obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
			if (j == 0) then
				obj.TopAndBottomCardScript:Init(putCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == putCardPoint);
			elseif (j == 1) then
				obj.TopAndBottomCardScript:Init(oneCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == oneCardPoint);
			elseif (j == 2) then
				obj.TopAndBottomCardScript:Init(twoCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == twoCardPoint);
			end
			obj.transform.localScale = Vector3.one;
			table.insert(templist,obj)
		end)
	end
	table.insert(PengGangCardList,tempList)
	GlobalData.isDrag = true;
end

function PengGangHuEffectCtrl()
	if (effectType == "peng") then
		pengEffectGame:SetActive(true)
	elseif (effectType == "gang") then
		gangEffectGame:SetActive(true)
	elseif (effectType == "hu") then
		huEffectGame:SetActive(true)
	elseif (effectType == "liuju") then
		liujuEffectGame:SetActive(true)
	elseif (effectType == "chi") then
		chiEffectGame:SetActive(true)
	end
	coroutine.start(
	function()
		coroutine.wait(1)
		pengEffectGame:SetActive(false);
		gangEffectGame:SetActive (false);
		huEffectGame:SetActive (false);
		chiEffectGame:SetActive(false);
	end
	)
end


local function OtherGang(response)
	local gangNotice = json.decode(response.message);
	otherGangCard = gangNotice.cardPoint;
	otherGangType = gangNotice.type;
	local path = "";--�������������
	local path2 = "";--���������һ��
	local tempvector3 =Vector3.zero;
	curDir = GetDirection(gangNotice.avatarId);
	effectType = "gang";
	PengGangHuEffectCtrl ();
	SetDirGameObjectAction();
	soundMgr:playSoundByAction("gang", avatarList[gangNotice.avatarId].account.sex)
	local tempCardList
	--ȷ���Ʊ��������ܣ����ܣ�
	local switch=
	{
	[DirectionEnum.Right]=function()
		tempCardList = handerCardList[2];
		path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_R";
		path2 = "Assets/Project/Prefabs/PengGangCard/GangBack_L&R";
	end,
	[DirectionEnum.Top]=function()
		tempCardList = handerCardList[3];
		path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_T";
		path2 = "Assets/Project/Prefabs/PengGangCard/GangBack_T";
	end,
	[DirectionEnum.Top]=function()
		tempCardList = handerCardList[4];
		path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_L";
		path2 = "Assets/Project/Prefabs/PengGangCard/GangBack_L&R";
	end
	}
	local tempList ={}
	--���ܺͰ���
	if (GetPaiInpeng(otherGangCard, curDir) == -1) then
		--ɾ��������ƣ�������������������������ʱ������ɾ������
		for i = 1,3 do
			local temp = tempCardList[1];
			table.remove(tempCardList,1)
			Destroy(temp);
		end
		SetPosition (false)
		if( tempCardList ~= nil) then
		GameToolScript.setOtherCardObjPosition(tempCardList, curDir, 2);
	end
	--����
	if (otherGangType == 0) then
		if (cardOnTable ~= nil) then
			ReSetOutOnTabelCardPosition(cardOnTable);
			Destroy(cardOnTable);
		end
		for i=1,4 do
			--ʵ���������˸���
			local obj=resMgr:LoadPrefab('prefabs',{"Assets/Project/Prefabs/PengGangCard/PengGangCard_B.prefab"},function()
				obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
				obj.TopAndBottomCardScript:Init(otherGangCard, curDir,GlobalData.roomVo.guiPai== otherGangCard);
				local switch=
				{
				[DirectionEnum.Right]=function()
					obj.transform.parent = pengGangParenTransformR.transform;
					if (i == 3) then
						tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + 33);
					else
						tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + i * 28);
						obj.transform:SetSiblingIndex(0);
					end
				end,
				[DirectionEnum.Top]=function()
					obj.transform.parent = pengGangParenTransformT.transform;
					if (i == 3) then
						tempvector3 = Vector3.New(251 - #PengGangList_T * 120 + 37, 20);
					else
						tempvector3 = Vector3.New(251 - #PengGangList_T * 120 + i * 37, 0);
					end
				end,
				[DirectionEnum.Left]=function()
					obj.transform.parent = pengGangParenTransformL.transform;
					if (i == 3) then
						tempvector3 = Vector3.New(0, 122 - #PengGangList_L * 95 - 18);
					else
						tempvector3 = Vector3.New(0, 122 - #PengGangList_L * 95 - i * 28);
					end
				end
				}
				switch[curDir]()
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = tempvector3;
				table.insert(tempList,obj)
			end)
		end
		--����
	elseif (otherGangType == 1) then
		Destroy(otherPickCardItem);
		local common=function()
			local switch=
			{
			[DirectionEnum.Right]=function()
				obj.transform.parent = pengGangParenTransformR.transform;
				if (j == 3) then
					tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + 33,0);
				else
					tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + j * 28,0);
				end
			end,
			[DirectionEnum.Top]=function()
				obj.transform.parent = pengGangParenTransformT.transform;
				if (j == 3) then
					tempvector3 = Vector3.New(251 - PengGangList_T.Count * 120 + 37, 10);
				else
					tempvector3 = Vector3.New(251 - PengGangList_T.Count * 120 + j * 37, 0);
				end
			end,
			[DirectionEnum.Left]=function()
				obj.transform.parent = pengGangParenTransformL.transform;
				if (j == 3) then
					tempvector3 = new Vector3(0, 122 - PengGangList_L.Count * 95 - 18, 0);
				else
					tempvector3 = new Vector3(0, 122 - PengGangList_L.Count * 95 - j * 28, 0);
				end
			end
			}
			switch[curDir]()
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition = tempvector3;
			table.insert(tempList,obj)
		end
		for i=1,4 do
			local obj;
			if (j == 3) then
				obj=resMgr:LoadPrefab('prefabs',{path + ".prefab"},function()
					obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
					obj.TopAndBottomCardScript:Init(otherGangCard, curDir, GlobalData.roomVo.guiPai == otherGangCard);
					common()
				end)
			else
				obj=resMgr:LoadPrefab('prefabs',{path2 + ".prefab"},function()
					common()
				end)
			end

		end
	end
	AddListToPengGangList(curDir, tempList);
	--����
else
	local gangIndex = GetPaiInpeng(otherGangCard, curDir);
	if (otherPickCardItem ~= nil) then
		Destroy(otherPickCardItem);
	end
	local obj=resMgr:LoadPrefab('prefabs',{path + ".prefab"},function()
		obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
		obj.TopAndBottomCardScript:Init(otherGangCard, curDir, GlobalData.roomVo.guiPai == otherGangCard);
		local switch=
		{
		[DirectionEnum.Top]=function()
			obj.transform.parent = pengGangParenTransformT.transform;
			tempvector3 = Vector3.New(251 - gangIndex * 120 + 37, 20);
			table.insert(PengGangList_T[gangIndex],obj)
		end,
		[DirectionEnum.Left]=function()
			obj.transform.parent = pengGangParenTransformL.transform;
			tempvector3 = Vector3.New(0, 122 - gangIndex * 95 - 26, 0);
			table.insert(PengGangList_L[gangIndex],obj)
		end,
		[DirectionEnum.Right]=function()
			obj.transform.parent = pengGangParenTransformR.transform;
			tempvector3 = Vector3.New(0, -122 + gangIndex * 95 + 26);
			table.insert(PengGangList_R[gangIndex],obj)
		end
		}
		switch[curDir]()
		obj.transform.localScale = Vector3.one;
		obj.transform.localPosition = tempvector3;
	end)
end
GlobalData.isChiState = false;
end

function AddListToPengGangList(dir,tempList)
	local switch=
	{
	[DirectionEnum.Right]=function()
		table.insert(PengGangList_R,tempList)
	end,
	[DirectionEnum.Top]=function()
		table.insert(PengGangList_T,tempList)
	end,
	[DirectionEnum.Left]=function()
		table.insert(PengGangList_L,tempList)
	end
	}
	switch[dir]()
end


--[[ �ж����Ƶ����������Ƿ����ĳ���ƣ������ж��Ƿ�ʵ����һ���ƻ���������
cardpoint���Ƶ�
direction������
����-1  ����û����
��������list��λ��--]]

function GetPaiInpeng(cardPoint,direction)
	local jugeList = {}
	local switch=
	{
	[DirectionEnum.Bottom]=function()--�Լ�
		jugeList = PengGangCardList;
	end,
	[DirectionEnum.Right]=function()
		jugeList = PengGangList_R;
	end,
	[DirectionEnum.Left]=function()
		jugeList = PengGangList_L;
	end,
	[DirectionEnum.Top]=function()
		jugeList = PengGangList_T;
	end
	}
	switch[direction]()
	if (jugeList == nil or #jugeList == 0) then
		return -1;
	end
	--ѭ�������ȶԵ���
	for i =1,#jugeList do
		local index
		local ret,errMessage=pcall(
		function()
			if (jugeList[i][1].TopAndBottomCardScript.CardPoint == cardPoint) then
				index=i
			end
		end)
		if not ret then
			error("error:"..errMessage)
			index=-1
			return
		end
		if(index>-1) then
		return index
	end
end
return -1;
end
--���ö���
local function SetPointGameObject(parent)
	if (parent ~= nil) then
		local common=function()
			Pointertemp.transform:SetParent(parent.transform);
			Pointertemp.transform.localScale = Vector3.one;
			Pointertemp.transform.localPosition = Vector3.New(0, parent.transform:GetComponent("RectTransform").sizeDelta.y / 2 + 10);
		end
		if (Pointertemp == nil) then
			Pointertemp=resMgr:LoadPrefab('prefabs',{"Assets/Project/Prefabs/Pointer.prefab"},function()
				common()
			end)
		else
			common()
		end
	end
end

local function OnChipSelect(obj,isSelected)
	if (isSelect) then --ѡ�����
		if (oneChiCardPoint ~= -1 and twoChiCardPoint ~= -1) then
			return
		end
		if (oneChiCardPoint == -1) then
			oneChiCardPoint = obj.bottomScript.CardPoint;
		else
			twoChiCardPoint = obj.bottomScript.CardPoint;
		end
		obj.transform.localPosition = Vector3.New(obj.transform.localPosition.x, -272);
		obj.bottomScript.selected = true;
	else--ȡ��ѡ��
		if (oneChiCardPoint == obj.bottomScript.CardPoint) then
			oneChiCardPoint = -1;
		elseif (twoChiCardPoint == obj.bottomScript.CardPoint) then
			twoChiCardPoint = -1;
		end
		obj.transform.localPosition = Vector3.New(obj.transform.localPosition.x, -292);
		obj.bottomScript.selected = false;
	end
end

--�Լ��������
local function CardChange(obj)
	if (GlobalDataScript.isChiState) then
		onChipSelect(obj, false);
	else
		local handCardCount = #handerCardList[1]
		if (handCardCount % 3 == 2) then --��ʱ����ܳ���
			obj.bottomScript.onSendMessage =nil;
			obj.bottomScript.reSetPoisiton =nil;
			local putOutCardPointTemp = obj.bottomScript.CardPoint;
			pushOutFromMineList(putOutCardPointTemp);                         --��������Ƴ�
			table.remove(handerCardList[1],obj)
			Destroy(obj);
			SetPosition(false);
			CreatePutOutCardAndPlayAction(putOutCardPointTemp, GetMyIndexFromList(),obj.transform.position);--���ƶ���
			local cardvo = {}
			cardvo.cardPoint = putOutCardPointTemp;
			putOutCardPointAvarIndex = getIndexByDir(getDirection(getMyIndexFromList()));
			CustomSocket.getInstance():sendMsg(PutOutCardRequest.New(json.encode(cardvo)));
			GlobalData.isChiState = false;
			GlobalData.isDrag = false;
		end
	end
end

function InsertCardIntoList(item)--�����Ƶķ���
	if (item ~= nil) then
		local curCardPoint = item.bottomScript.CardPoint;--�õ���ǰ��ָ��
		if (curCardPoint == GlobalData.roomVo.guiPai) then
			table.insert(handerCardList[1],1,item)--���Ʒŵ���ǰ��
			return;
		else
			for i = 1,#handerCardList[1] do--��Ϸ������� ����
				local cardPoint = handerCardList[1][i].bottomScript.CardPoint;--�õ�������ָ��
				if (cardPoint ~= GlobalData.roomVo.guiPai and cardPoint >= curCardPoint) then --��ָ��>=��ǰ�Ƶ�ʱ�����
					table.insert(handerCardList[1],i,item)
					SortMyCardList();
					return;
				end
				table.insert(handerCardList[1],item)--��Ϸ�����б���ӵ�ǰ��
				SortMyCardList();
			end
		end
		item = nil;
	end
end

local function SetPosition(flag)--����λ��
	local count = #handerCardList[1];
	local startX = 594 - count * 80;
	if (flag) then
		for i=1,count-1 do
			handerCardList[1][i].transform.localPosition =Vector3.New(startX + i * 80, -292,0); --���������ζ���
		end
		handerCardList[1][count - 1].transform.localPosition =Vector3.New(580, -292,0); --���������ζ���
	else
		for i=1,count do
			handerCardList[1][i].transform.localPosition = Vector3.New(startX + i * 80 - 80, -292,0); --���������ζ���
		end
	end
end

function GamePanelCtrl.Update()
	timer =timer - Time.deltaTime;
	if (timer < 0) then
		timer = 0;
	end
	Number.text =math.floor(timer);
	if (timeFlag) then
		showTimeNumber=showTimeNumber-1;
		if (showTimeNumber < 0) then
			timeFlag = false;
			showTimeNumber = 0;
			PlayNoticeAction();
		end
	end
end

function PlayNoticeAction()
	noticeGameObject:SetActive(true);
	if (GlobalData.noticeMegs ~= nil and #GlobalData.noticeMegs ~= 0) then
		noticeText.transform.localPosition =Vector3.New(500, noticeText.transform.localPosition.y);
		noticeText.text = GlobalData.noticeMegs[showNoticeNumber];
		local time = noticeText.text.Length * 0.5 + 422/ 56;
		local tweener = noticeText.transform:DOLocalMove(
		Vector3.New(-noticeText.text.Length * 28, noticeText.transform.localPosition.y), time)
		.OnComplete(MoveCompleted);
		tweener:SetEase(Ease.Linear);
	end
end

function MoveCompleted()
	showNoticeNumber=showNoticeNumber+1;
	if (showNoticeNumber == #GlobalData.noticeMegs) then
		showNoticeNumber = 0;
	end
	noticeGameObject:SetActive(false);
	RandShowTime();
	timeFlag = true;
end

-- ���¿�ʼ��ʱ
function UpateTimeReStart()
	timer = 16;
end


--���������ť
function MyPassBtnClick()
	btnActionScript.CleanBtnShow();
	if isSelfPickCard then
		GlobalData.isDrag = true;
		isSelfPickCard = false;
	end
	if (passType == "selfPickCard") then
		GlobalData.isDrag = true;
	end
	passType = "";
	CustomSocket.getInstance():sendMsg(GaveUpRequest.New("gaveup|" .. passStr));
	GlobalData.isChiState = false;
	passStr = "";
end

function MyPengBtnClick()
	GlobalData.isDrag = true;
	UpateTimeReStart();
	local cardvo = {};
	cardvo.cardPoint = putOutCardPoint;
	CustomSocket.getInstance().sendMsg(PengCardRequest.New(json.encode(cardvo)));
	btnActionScript.CleanBtnShow();
	passStr = "";
end


function ShowChipai(idx)
	local cpoint = chiPaiPointList[idx];
	if (idx == 1) then
		chiList_1[1].bottomScript.CardPoint=cpoint.putCardPoint;
		chiList_1[2].bottomScript.CardPoint=cpoint.oneCardPoint;
		chiList_1[3].bottomScript.CardPoint=cpoint.twoCardPoint;
	end
	if (idx == 2) then
		chiList_2[1].bottomScript.CardPoint=cpoint.putCardPoint;
		chiList_2[2].bottomScript.CardPoint=cpoint.oneCardPoint;
		chiList_2[3].bottomScript.CardPoint=cpoint.twoCardPoint;
	end
	if (idx == 3) then
		chiList_3[1].bottomScript.CardPoint=cpoint.putCardPoint;
		chiList_3[2].bottomScript.CardPoint=cpoint.oneCardPoint;
		chiList_3[3].bottomScript.CardPoint=cpoint.twoCardPoint;
	end
end

--��ʾ�ɳ��Ƶ���ʾ
local function ShowChiList()
	btnActionScript.CleanBtnShow();
	for i =1,#canChiList do
		if (i <= #chiPaiPointList) then
			canChiList[i].gameObject:SetActive(true);
			ShowChipai(i);
		else
			canChiList[i].gameObject:SetActive(false);
		end
	end
end

--����ѡ����
local function MyChiBtnClick2(idx)
	local cpoint = chiPaiPointList[idx];
	GlobalData.isDrag = true;
	UpateTimeReStart ();
	local cardvo ={}
	cardvo.cardPoint = cpoint.putCardPoint;
	cardvo.onePoint = cpoint.oneCardPoint;
	cardvo.twoPoint = cpoint.twoCardPoint;
	CustomSocket.getInstance ():sendMsg (ChiCardRequest.New (json.encode(cardvo)));
	btnActionScript.CleanBtnShow ();
	GlobalData.isChiState = false;
	oneChiCardPoint = -1;
	twoChiCardPoint = -1;
	passStr = "";
	for i=1,#canChiList do
		canChiList [i].gameObject:SetActive (false);
	end
end

--�԰�ť���
local function MyChiBtnClick()
	if (#chiPaiPointList == 1) then
		local cpoint = chiPaiPointList [1];
		GlobalData.isDrag = true;
		UpateTimeReStart ();
		local cardvo = {};
		cardvo.cardPoint = cpoint.putCardPoint;
		cardvo.onePoint = cpoint.oneCardPoint;
		cardvo.twoPoint = cpoint.twoCardPoint;
		CustomSocket.getInstance ():sendMsg (ChiCardRequest.New (json.encode(cardvo)));
		btnActionScript.CleanBtnShow ();
		GlobalData.isChiState = false;
		oneChiCardPoint = -1;
		twoChiCardPoint = -1;
		passStr = "";
		for i=1,#canChiList do
			canChiList [i].gameObject:SetActive (false);
		end
	else
		ShowChiList();
	end
end

local function GangResponse(response)
	UpateTimeReStart ();
	local gangBackVo =json.decode(response.message);
	local gangKind = gangBackVo.type;
	if (#gangBackVo.cardList== 0) then
		mineList[1][selfGangCardPoint] = 2;
		if (gangKind == 0) then
			--����
			if (GetPaiInpeng(selfGangCardPoint, DirectionEnum.Bottom) == -1) then
				--���Ʋ��������������ڣ�һ��Ϊ���˴����
				mineList[1][putOutCardPoint]=mineList[1][putOutCardPoint]-3;
				--���ٱ��˴����
				if (putOutCard ~= nil) then
					Destroy(putOutCard);
				end
				if (cardOnTable ~= nil) then
					ReSetOutOnTabelCardPosition(cardOnTable);
					Destroy(cardOnTable)
				end
				--���������е�������
				local removeCount = 0;
				for i=1,#handerCardList[1] do
					local temp = handerCardList[1][i];
					local tempCardPoint = handerCardList[1][i].bottomScript.CardPoint;
					if (selfGangCardPoint == tempCardPoint) then
						table.remove(handerCardList[1],i)
						Destroy(temp);
						i=i-1
						removeCount=removeCount+1;
						if (removeCount == 3) then
							break;
						end
					end
				end
				--������������
				local gangTempList = {};
				for i=1,4 do
					local obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
					pengGangParenTransformB.transform, Vector3.New(-370 + #PengGangCardList* 190 + i * 60, 0));
					obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
					obj.TopAndBottomCardScript.Init(selfGangCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == selfGangCardPoint);
					obj.transform.localScale = Vector3.one;
					if (i == 3) then
						obj.transform.localPosition = Vector3.New(-310 + #PengGangCardList * 190, 24);
					end
					table.insert(gangTempList,obj)
				end
				--��ӵ�������������
				table.insert(PengGangCardList,gangTempList)
				--����
			else
				--�������������ڣ���һ������������
				mineList[1][putOutCardPoint] =mineList[1][putOutCardPoint]- 4;
				for i=1,#handerCardList[1] do
					if (handerCardList[1][i].bottomScript.CardPoint == selfGangCardPoint) then
						local temp = handerCardList[1][i];
						table.remove(handerCardList[1],i)
						Destroy(temp);
						break;
					end
				end
				local index = GetPaiInpeng(selfGangCardPoint, DirectionEnum.Bottom);
				--�����Ʒŵ���Ӧλ��
				local obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
				pengGangParenTransformB.transform,Vector3.New(-370 + PengGangCardList.Count * 190 , 0));
				obj.TopAndBottomCardScript =TopAndBottomCardScript.New()
				obj.TopAndBottomCardScript.Init(selfGangCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == selfGangCardPoint)
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = Vector3.New(-310 + index * 190, 24);
				table.insert(PengGangCardList[index],obj)
				--����
			end
		elseif (gangKind == 1) then
				mineList[1][selfGangCardPoint] =mineList[1][selfGangCardPoint]-4;
				local removeCount = 0;
				for i=1,#handerCardList[1] do
					local temp = handerCardList[1][i];
					local tempCardPoint = handerCardList[1][i].bottomScript.CardPoint;
					if (selfGangCardPoint == tempCardPoint) then
						table.remove(handerCardList[1],i)
						Destroy(temp);
						i=i-1
						removeCount=removeCount+1;
						if (removeCount == 4) then
							break;
						end
					end
				end
				local tempGangList = {};
				for i=1,4 do
					if (i < 3) then
						local obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/gangBack",
						pengGangParenTransformB.transform,Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
						table.insert(tempGangList,obj)
					elseif (i == 3) then
						local obj = createGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
						pengGangParenTransformB.transform,Vector3.New(-310 + #PengGangCardList * 190, 24));
						obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
						obj.TopAndBottomCardScript.Init(selfGangCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == selfGangCardPoint)
						table.insert(tempCardList,obj)
					end
				end
				table.insert(PengGangCardList,tempGangList)
			end
	elseif (gangBackVo.cardList.Count == 2) then
	end
	SetPosition(false);
	GlobalData.isChiState = false;

end

local function CreateGameObjectAndReturn(path,parent,position)
	local obj = resMgr:LoadPrefab('prefabs', {path + ".prefab"},function()
		obj.transform:SetParent(parent);
		obj.transform.localScale = Vector3.one;
		obj.transform.localPosition = position;
	end)
	return obj;
end

local function MyGangBtnClick()
	--useForGangOrPengOrChi = int.Parse (gangPaiList [1]);
	--GlobalDataScript.isDrag = true;--���ڴ������ܺ������˸ܰ�ť�Ժ󻹲��ܴ��ƣ��յ�����Ϣ���ܴ�
	if (#gangPaiList == 1) then
		useForGangOrPengOrChi =tonumber(gangPaiList[1])
		selfGangCardPoint = useForGangOrPengOrChi;
	else
		--������
		useForGangOrPengOrChi = tonumber(gangPaiList[1])
		selfGangCardPoint = useForGangOrPengOrChi;
	end
	CustomSocket.getInstance():sendMsg(GangCardRequest.New(useForGangOrPengOrChi, 0));
	soundMgr:playSoundByAction("gang", GlobalData.loginResponseData.account.sex);
	btnActionScript.CleanBtnShow();
	effectType = "gang";
	PengGangHuEffectCtrl();
	gangPaiList = nil;
	GlobalData.isChiState = false;
	passStr = "";
end

local function Clean()
	CleanArrayList(handerCardList)
	CleanArrayList(tableCardList)
	CleanArrayList(PengGangList_L)
	CleanArrayList(PengGangCardList)
	CleanArrayList(PengGangList_R)
	CleanArrayList(PengGangList_T)
	if (mineList ~=nil) then
		mineList={}
	end
	if (putOutCard ~=nil) then
		Destroy(putOutCard);
	end
	if (pickCardItem ~=nil) then
		Destroy(pickCardItem);
	end
	if (otherPickCardItem ~=nil) then
		Destroy(otherPickCardItem);
	end
	guiObj:SetActive(false);
end

local function CleanArrayList(list)
	if (list ~= nil) then
		while #list > 0 do
			local tempList = list[1]
			table.remove(list,1)
			CleanList(tempList)
		end
	end
end

local function CleanList(tempList)
	if (tempList ~= nil) then
		while #tempList > 0 do
			local temp = tempList[1];
			table.remove(tempList,1)
			Destroy(temp);
		end
	end
end

local function SetRoomRemark()
	local roomvo = GlobalData.roomVo;
	GlobalData.totalTimes = roomvo.roundNumber;
	GlobalData.surplusTimes = roomvo.roundNumber;
	--LeavedRoundNumText.text = GlobalDataScript.surplusTimes + "";
	local str = "����ţ�\n"..roomvo.roomId.."\n"
	.. "Ȧ����" .. roomvo.roundNumber .. "\n\n"
	roomRemark.text = str;
end

local function AddAvatarVOToList(avatar)
	if (avatarList == nil) then
		avatarList = {};
	end
	table.insert(avatarList,avatar)
	SetSeat(avatar);
end
--��������
local function CreateRoomAddAvatarVO(avatar)
	avatar.scores = 1000;
	AddAvatarVOToList(avatar);
	SetRoomRemark();
	if (GlobalData.roomVo.duanMen or GlobalData.roomVo.jiaGang) then
		ReadySelect[1].gameObject:SetActive(GlobalData.roomVo.duanMen)
		ReadySelect[2].gameObject:SetActive(GlobalData.roomVo.jiaGang)
		btnReadyGame:SetActive(true);
		ReadySelect[1].interactable = true;
	else
		ReadyGame();
	end
end

--���뷿��
local function JoinToRoom(avatars)
	avatarList = avatars;
	for i=1,#avatars do
		SetSeat (avatars[i])
	end
	SetRoomRemark ();
	if(GlobalData.roomVo.jiaGang) then
	ReadySelect[1].gameObject:SetActive(GlobalData.roomVo.duanMen);
	ReadySelect[2].gameObject:SetActive(GlobalData.roomVo.jiaGang);
	btnReadyGame:SetActive(true);
	ReadySelect[1].interactable = false;
else
	ReadyGame();
end
end

--���õ�ǰ��ɫ����λ
local function SetSeat(avatar)
	--��Ϸ�������õ����ݣ���ɾ������
	if (avatar.account.uuid == GlobalData.loginResponseData.account.uuid) then
		playerItems[1]:SetAvatarVo(avatar);
	else
		local myIndex = GetMyIndexFromList();
		local curAvaIndex =table.indexOf(avatarList,avatar)
		local seatIndex = curAvaIndex - myIndex;
		if (seatIndex < 1) then
			seatIndex = 4 + seatIndex;
		end
		playerItems[seatIndex]:SetAvatarVo(avatar);
	end
end

local function GetMyIndexFromList()
	if (avatarList ~=nil) then
		for i=1,#avatarList do
			if (avatarList[i].account.uuid == GlobalData.loginResponseData.account.uuid or avatarList[i].account.openid == GlobalData.loginResponseData.account.openid) then
				GlobalData.loginResponseData.account.uuid = avatarList[i].account.uuid;
				return i
			end
		end
	end
	return 0;
end

local function GetIndex(uuid)
	if (avatarList ~= nil) then
		for i=1,#avatarList do
			if (avatarList[i].account ~= nil) then
				if (avatarList[i].account.uuid == uuid) then
					return i;
				end
			end
		end
		return 0;
	end
end

local function OtherUserJointRoom(response)
	local avatar =json.decode(response.message);
	AddAvatarVOToList(avatar);
end

--���ư�ť���
local function HupaiRequest()
	if (SelfAndOtherPutoutCard ~= -1) then
		local cardPoint = SelfAndOtherPutoutCard;--���޸ĳ���ȷ�ĺ���cardpoint
		local requestVo = {};
		requestVo.cardPoint = cardPoint;
		if (isQiangHu) then
			requestVo.type = "qianghu";
			isQiangHu = false;
		end
		local sendMsg = json.encode(requestVo);
		CustomSocket.getInstance():sendMsg(HupaiRequest.New(sendMsg));
		btnActionScript.CleanBtnShow();
		GlobalData.isChiState = false;
	end
end

local function HupaiCallBack(response)
	for i=1,#playerItems do
		playerItems[GetIndexByDir(GetDirection(i))].jiaGang.text ="";
	end
	GlobalData.hupaiResponseVo = json.decode(response.message);
	local scores = GlobalData.hupaiResponseVo.currentScore;
	HupaiCoinChange(scores);
	local huPaiPoint = 0;
	if (GlobalData.hupaiResponseVo.type == "0") then
		SoundMgr:playSoundByAction("hu", GlobalData.loginResponseData.account.sex);
		effectType = "hu";
		PengGangHuEffectCtrl();
		for i=1,#GlobalData.hupaiResponseVo.avatarList do
			if(GlobalData.hupaiResponseVo.avatarList[i].uuid == GlobalData.hupaiResponseVo.winnerId) then
			huPaiPoint = GlobalData.hupaiResponseVo.avatarList[i].cardPoint;
			if (GlobalData.hupaiResponseVo.winnerId ~= GlobalData.hupaiResponseVo.dianPaoId) then
				--���ں�
				playerItems[GetIndexByDir(GetDirection(i))]:SetHuFlagDisplay();
				soundMgr:playSoundByAction("hu", avatarList[i].account.sex);
			else
				--������
				playerItems[GetIndexByDir(GetDirection(i))]:SetHuFlagDisplay();
				soundMgr:playSoundByAction("zimo", avatarList[i].account.sex);
			end
		else
			playerItems[GetIndexByDir(GetDirection(i))]:SetHuFlagHidde();
		end
	end
	allMas = GlobalData.hupaiResponseVo.allMas;
	if (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_ZHUANZHUAN
		or GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_CHANGSHA) then
		--תת�齫��ʾץ����Ϣ
		if (GlobalData.roomVo.ma > 0 and allMas ~= nil and #allMas> 0) then
			zhuamaPanel=resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/card/Panel_ZhuaMa.prefab'},nil)
			zhuamaPanel.ZhuMaScript=ZhuMaScript.New()
			zhuamaPanel.ZhuMaScript:arrageMas(allMas, avatarList, GlobalData.hupaiResponseVo.validMas)
			coroutine.start(
			Invoke(OpenGameOverPanelSignal, 7)
			)
		else
			coroutine.start(
			Invoke(OpenGameOverPanelSignal, 3)
			)
		end
	elseif (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_GUANGDONG) then
		--�㶫�齫��ʾץ����Ϣ
		if (GlobalData.roomVo.ma > 0 and allMas ~= nil and #allMas > 0) then
			zhuamaPanel=resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/card/Panel_ZhuaMa.prefab'},nil)
			zhuamaPanel.ZhuMaScript=ZhuMaScript.New()
			zhuamaPanel.ZhuMaScript:arrageMas(allMas, avatarList, GlobalData.hupaiResponseVo.validMas, GlobalData.roomVo.roomType);
			coroutine.start(
			Invoke(OpenGameOverPanelSignal, 7)
			)
		else
			coroutine.start(
			Invoke(OpenGameOverPanelSignal, 3)
			)
		end
	elseif (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_PANJIN) then
		--�̽��齫��
		if (GlobalData.roomVo.jue) then
			zhuamaPanel=resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/Panel_ZhuaMa.prefab'},nil)
			zhuamaPanel.ZhuMaScript=ZhuMaScript.New()
			zhuamaPanel.ZhuMaScript:arrageJue(huPaiPoint, avatarList, GlobalData.hupaiResponseVo.validMas);
			coroutine.start(
			Invoke(OpenGameOverPanelSignal, 7)
			)
		else
			coroutine.start(
			Invoke(OpenGameOverPanelSignal, 3)
			)
		end
	else
		coroutine.start(
		Invoke(OpenGameOverPanelSignal, 3)
		)
	end
elseif (GlobalData.hupaiResponseVo.type == "1") then
	soundMgr:playSoundByAction("liuju", GlobalData.loginResponseData.account.sex);
	effectType = "liuju";
	PengGangHuEffectCtrl();
	coroutine.start(
	Invoke(OpenGameOverPanelSignal, 3)
	)
else
	coroutine.start(
	Invoke(OpenGameOverPanelSignal, 3)
	)
end
end

local function Invoke(f,time)
	coroutine.wait(time)
	f()
end

local function  HupaiCoinChange(scores)
	local scoreList =string.split(scores,',')
	if (scoreList ~= nil and #scoreList > 0) then
		for i=1,#scoreList - 1 do
			local itemstr = scoreList[i];
			local uuid = tonumber(string.split(itemstr,':')[1]);
			local score = tonumber(string.split(itemstr,':')[2]) + 1000;
			playerItems[GetIndexByDir(GetDirection(GetIndex(uuid)))].scoreText.text =tostring(score);
			avatarList[GetIndex(uuid)].scores = score;
		end
	end
end


--���ֽ����������ݵĵط�

local function OpenGameOverPanelSignal()
	--���ֽ���
	liujuEffectGame:SetActive(false);
	SetAllPlayerHuImgVisbleToFalse();
	playerItems[GetIndexByDir(GetDirection(bankerId))]:SetbankImgEnable(false);
	if (handerCardList ~= nil and #handerCardList > 0 and #handerCardList[1] > 0) then
		for i=1,#handerCardList[1] do
			handerCardList[1][i].bottomScript.onSendMessage =nil
			handerCardList[1][i].bottomScript.reSetPoisiton =nil
		end
	end
	InitPanel();
	if (zhuamaPanel ~= nil) then
		Destroy(zhuamaPanel);
	end
	local obj=resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/Panel_Game_Over.prefab'},function()
		obj.GameOverScript=GameOverScript.New()
		obj.GameOverScript:SetDisplaContent(0, avatarList, allMas, GlobalData.hupaiResponseVo.validMas, GlobalData.hupaiResponseVo.nextBankerId == GlobalData.loginResponseData.account.uuid);
		table.insert(GlobalData.singalGameOverList,obj)
	end)
	allMas = "";--��ʼ����������Ϊ��
	avatarList[bankerId].main = false;
end

function ReSetOutOnTabelCardPosition(cardOnTable)
	log("putOutCardPointAvarIndex===========:" ..tostring(putOutCardPointAvarIndex));
	if (putOutCardPointAvarIndex ~= -1)then
		local objIndex =table.indexOf(tableCardList[putOutCardPointAvarIndex],cardOnTable)
		if (objIndex ~= -1)then
			table.remove(tableCardList[putOutCardPointAvarIndex],objIndex)
			return;
		end
	end
end


--�˳���������
local function QuiteRoom()
	if (bankerId == getMyIndexFromList()) then
		dialog_fanhui_text.text = "�ף�ȷ��Ҫ��ɢ������?";
	else
		dialog_fanhui_text.text = "�ף�ȷ��Ҫ�뿪������?";
	end
	dialog_fanhui.gameObject:SetActive(true);
end

local function tuichu()
	local vo = {};
	vo.roomId = GlobalData.roomVo.roomId;
	local sendMsg = json.encode(vo)
	CustomSocket.getInstance():sendMsg(OutRoomRequest.New(sendMsg));
	dialog_fanhui.gameObject:SetActive(false);
end

local function quxiao()
	dialog_fanhui.gameObject:SetActive(false);
end

local function OutRoomCallbak()
	local responseMsg = json.decode(response.message)
	if (responseMsg.status_code == "0") then
		if (responseMsg.type == "0") then
			local uuid = responseMsg.uuid;
			if (uuid ~= GlobalData.loginResponseData.account.uuid) then
				local index = GetIndex(uuid);
				table.remove(avatarList,index)
				for i =1,#playerItems do
					playerItems[i]:setAvatarVo(nil);
				end
				if (avatarList ~= nil) then
					for i=1,#avatarList do
						SetSeat(avatarList[i]);
					end
				end
			else
				ExitOrDissoliveRoom();
			end
		else
			ExitOrDissoliveRoom();
		end
	else
		TipsManager.Instance().setTips("�˳�����ʧ�ܣ�" ..tostring(responseMsg.error));
	end
end

local dissoliveRoomType = "0";
local function DissoliveRoomRequest()
	SoundMgr:playSoundByActionButton(1);
	if (canClickButtonFlag) then
		dissoliveRoomType = "0";
		TipsManagerScript:LoadDialog("�����ɢ����", "��ȷ��Ҫ�����ɢ���䣿", doDissoliveRoomRequest, cancle);
	else
		TipsManager.Instance().setTips("��û�п�ʼ��Ϸ�����������˳�����");
	end
end
--��Ϸ����
local function OpenGameSettingDialog()
        SoundMgr:playSoundByActionButton(1);
        loadPerfab("Assets/Project/Prefabs/Panel_Setting");
		panelCreateDialog.SettingScript=SettingScript.New()
        local ss = panelCreateDialog.SettingScript
        if (canClickButtonFlag) then
            ss.canClickButtonFlag = canClickButtonFlag;
            ss.jiesanBtn:GetComponentInChildren("Text").text = "�����ɢ����";
            ss.type = 2;
        else
            if (bankerId == GetMyIndexFromList()) then--���Ƿ�����һ��ʼׯ���Ƿ�����
                ss.canClickButtonFlag = canClickButtonFlag;
                ss.jiesanBtn:GetComponentInChildren("Text").text = "��ɢ����";
                ss.type = 3;
                ss.dialog_fanhui = dialog_fanhui;
                dialog_fanhui_text.text = "�ף�ȷ��Ҫ��ɢ������?";
            else
                ss.canClickButtonFlag = canClickButtonFlag;
                ss.jiesanBtn:GetComponentInChildren("Text").text = "�뿪����";
                ss.type = 3;
                ss.dialog_fanhui = dialog_fanhui;
                dialog_fanhui_text.text = "�ף�ȷ��Ҫ�뿪������?";
            end
        end

end

local  panelCreateDialog;--�����ϴ򿪵�dialog
local function loadPerfab(perfabName)
        panelCreateDialog =resMgr:LoadPrefab('prefabs', {perfabName + ".prefab"},function()
        panelCreateDialog.transform.parent = gameObject.transform;
        panelCreateDialog.transform.localScale = Vector3.one;
        panelCreateDialog:GetComponent("RectTransform").offsetMax = Vector2.zero;
        panelCreateDialog:GetComponent("RectTransform").offsetMin = Vector2.zero;
		end)
end

	--�����ɢ����ص�

    local dissoDialog;
    local function DissoliveRoomResponse(response)
        local dissoliveRoomResponseVo = json.decode(response.message);
        local plyerName = dissoliveRoomResponseVo.accountName;
        local uuid= dissoliveRoomResponseVo.uuid;
        if (dissoliveRoomResponseVo.type == "0") then
            GlobalDataScript.isonApplayExitRoomstatus = true;
            dissoliveRoomType = "1";
            dissoDialog = PrefabManage.loadPerfab("Assets/Project/Prefabs/Panel_Apply_Exit");
			dissoDialog.VoteScript=VoteScript.New()
            dissoDialog.VoteScript.iniUI(uuid,plyerName, avatarList);
        elseif (dissoliveRoomResponseVo.type == "3") then
            if (zhuamaPanel ~= nil and GlobalData.isonApplayExitRoomstatus) then
                Destroy(zhuamaPanel)
			end
            GlobalData.isonApplayExitRoomstatus = false;
            if (dissoDialog  ~= nil) then
                dissoDialog.VoteScript.RemoveListener();
                Destroy(dissoDialog);
            end
            GlobalData.isOverByPlayer = true;
        end
    end


	--�����ͬ���ɢ��������
    local function DoDissoliveRoomRequest()
	local dissoliveRoomRequestVo = DissoliveRoomRequestVo.New();
        dissoliveRoomRequestVo.roomId = GlobalData.loginResponseData.roomId;
        dissoliveRoomRequestVo.type = dissoliveRoomType;
        local sendMsg = josn.encode(dissoliveRoomRequestVo);
        CustomSocket.getInstance():sendMsg(DissoliveRoomRequest.New(sendMsg));
        GlobalData.isonApplayExitRoomstatus = true;
    end

	local function cancle()
	end

	  local function ExitOrDissoliveRoom()
        GlobalData.loginResponseData.ResetData();--��λ��������
        GlobalData.loginResponseData.roomId = 0;--��λ��������
        GlobalData.roomJoinResponseData = nil;--��λ��������
        GlobalData.roomVo.roomId = 0;
        GlobalData.soundToggle = true;
        Clean();
        RemoveListener();

        --SoundCtrl.getInstance().playBGM(0);
        SoundMgr:playBGM(1);
        if (GlobalData.homePanel ~= nil) then
            GlobalData.homePanel:SetActive(true);
            GlobalData.homePanel.transform:SetSiblingIndex(1);
		else
            GlobalData.homePanel = PrefabManage.loadPerfab("Assets/Project/Prefabs/Panel_Home");
            GlobalData.homePanel.transform.SetSiblingIndex(1);
        end

        while (#playerItems.Count > 0) do
            local item = playerItems[1];
			table.remove(playerItems,1)
            Destroy(item.gameObject);
        end
        Destroy(gameObject);
    end

	local function GameReadyNotice(response)
        local message = Json.decode(response.message);
        local avatarIndex = message["avatarIndex"];
        local myIndex = GetMyIndexFromList();
        local seatIndex = avatarIndex - myIndex;
        if (seatIndex < 1) then
            seatIndex = 4 + seatIndex;
        end
        playerItems[seatIndex].readyImg.enabled = true;
        avatarList[avatarIndex].isReady = true;
    end

--���ظ�ׯ
local function GameFollowBanderNotice(response)
		genZhuang:SetActive(true);
		coroutine.start(Invoke(HideGenzhuang,2))
end

local function HideGenzhuang()
        genZhuang:SetActive(false);
end

local function ReEnterRoom()
  if (GlobalDataScript.reEnterRoomData ~= nil) then
local roomVo=GlobalData.roomVo;
local reEnterRoomData=GlobalData.reEnterRoomData
            --��ʾ���������Ϣ
            roomVo.addWordCard = reEnterRoomData.addWordCard;
            roomVo.hong = reEnterRoomData.hong;
            roomVo.name = reEnterRoomData.name;
            roomVo.roomId = reEnterRoomData.roomId;
            roomVo.roomType = reEnterRoomData.roomType;
            roomVo.roundNumber = reEnterRoomData.roundNumber;
            roomVo.sevenDouble = reEnterRoomData.sevenDouble;
            roomVo.xiaYu = reEnterRoomData.xiaYu;
            roomVo.ziMo = reEnterRoomData.ziMo;
            roomVo.magnification = reEnterRoomData.magnification;
            roomVo.ma = reEnterRoomData.ma;
            roomVo.gangHu = reEnterRoomData.gangHu;
            roomVo.guiPai = reEnterRoomData.guiPai;

            roomVo.pingHu = reEnterRoomData.pingHu;
            --log("GlobalDataScript.reEnterRoomData.jue=" + GlobalDataScript.reEnterRoomData.jue);
            roomVo.jue = reEnterRoomData.jue;
            roomVo.baoSanJia = reEnterRoomData.baoSanJia;
            roomVo.jiaGang = reEnterRoomData.jiaGang;
            roomVo.gui = reEnterRoomData.gui;
            roomVo.duanMen = reEnterRoomData.duanMen;
            roomVo.jihu = reEnterRoomData.jihu;
            roomVo.qingYiSe = reEnterRoomData.qingYiSe;
            roomVo.siguiyi = reEnterRoomData.siguiyi;
            roomVo.menqing = reEnterRoomData.menqing;
            SetRoomRemark();
            --������λ
            avatarList = reEnterRoomData.playerList;
            GlobalData.roomAvatarVoList = reEnterRoomData.playerList;
            for i = 1,#avatarList do
                SetSeat(avatarList[i]);
                if (avatarList[i].main) then
                    bankerId = i;
					end
            end

            RecoverOtherGlobalData();
            local selfPaiArray = reEnterRoomData.playerList[GetMyIndexFromList()].paiArray;
            if (selfPaiArray == nil or #selfPaiArray == 0) then
            --��Ϸ��û�п�ʼ
                if (not avatarList[GetMyIndexFromList()].isReady) then
                    --log("bankerId=" + bankerId + "    getMyIndexFromList()=" + getMyIndexFromList());
                    if (roomVo.duanMen or roomVo.jiaGang) then
                        ReadySelect[1].gameObject:SetActive(roomVo.duanMen);
                        ReadySelect[2].gameObject:SetActive(roomVo.jiaGang);
                        btnReadyGame:SetActive(true);
                        ReadySelect[1].interactable = avatarList[GetMyIndexFromList()].main;
                    else
                        ReadyGame();
                    end
                end
            else
            --�ƾ��ѿ�ʼ
                SetAllPlayerReadImgVisbleToFalse();
                CleanGameplayUI();
                --��ʾ��������
                DisplayTableCards();
                --��ʾ����
                DisplayGuiPai();
                --��ʾ����
                DisplayOtherHandercard();--��ʾ������ҵ�����
                DisplayallGangCard();--��ʾ����
                DisplayPengCard();--��ʾ����
                DisplayChiCard();--��ʾ����
                DispalySelfhanderCard();--��ʾ�Լ�������
                CustomSocket.getInstance():sendMsg(CurrentStatusRequest.New());
            end
end
end

  --�ָ�����ȫ������
    local function RecoverOtherGlobalData()
        local selfIndex = getMyIndexFromList();
		--�ָ��������ݣ���ʱ�����滹û��load�����������������ʾ
        GlobalData.loginResponseData.account.roomcard = GlobalData.reEnterRoomData.playerList[selfIndex].account.roomcard;
    end


    local function DispalySelfhanderCard()
        mineList = ToList(GlobalData.reEnterRoomData.playerList[GetMyIndexFromList()].paiArray);
        for i=1, #mineList[1] do
            if (mineList[1][i] > 0) then
                for j = 1,#mineList[1][i] do
                    local gob = resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/card/Bottom_B.prefab'},function()
					if (gob ~= nil) then
						gob.transform:SetParent(parentList[1]);--���ø��ڵ�
						gob.transform.localScale =Vector3.New(1.1,1.1,1);
						gob.bottomScript.onSendMessage = CardChange;--������Ϣfd
						gob.bottomScript.reSetPoisiton = CardSelect;
                        gob.bottomScript.CardPoint = i;
                        if (i == GlobalData.roomVo.guiPai) then
						gob.bottomScript.SetLaizi(true);
						end
						table.insert(handerCardList[1],god)--������Ϸ����
						SortMyCardList();
					end
					end)
				end
            end
        end
        SetPosition(false);
    end

    local function ToList(param)
        local returnData = {};
        for  i = 1,#param do

            local temp = {};
            for j=1,#param[i] do
			temp[j]=param[i][j]
            end
            returnData[i]=temp
        end
        return returnData;
    end

	function MyselfSoundActionPlay()
        playerItems[1].ShowChatAction();
    end


    --������ʾ��������
	local function displayTableCards()
        local Dir;
		for i =1,# GlobalData.reEnterRoomData.playerList do
			local chupai = GlobalData.reEnterRoomData.playerList [i].chupais;
            Dir = GetDirection (GetIndex (GlobalData.reEnterRoomData.playerList [i].account.uuid));
			if (chupai ~= nil and #chupai > 0) then
				for j=1,#chupai do
					ThrowBottom (chupai[j],Dir,true);
				end
			end
		end
	end

	--��ʾ�������
    local function DisplayTouzi(touzi,gui)
        if (gui ~= -1 and GlobalData.roomVo.roomType == 4 and GlobalData.roomVo.gui == 2) then
         --��ʾ����
            local r1 = touzi / 10;
            local r2 = touzi % 10;
			touziObj.TouziActionScript=TouziActionScript.New()
            local bts = touziObj.TouziActionScript;
            bts:SetResult(r1, r2);
            touziObj:SetActive(true);
			coroutine.start(Invoke(DisplayGuiPai,5.5))
        else
            DisplayGuiPai();
        end
    end

	--��ȡ��ʾ����Ƥ������2�� ��ʾ1��
    local function GetDisplayGuiPai(gui)
        if (gui == 0 or gui == 9 or gui == 18) then
            return gui + 8;
        elseif (gui == 27) then
        --��
            return gui + 3;
        elseif (gui == 31) then
        --�з���
            return gui + 2;
        else
            return gui - 1;
		end
    end

	--��ʾ�������
    local function DisplayGuiPai()
        touziObj:SetActive(false);
        local gui = GlobalData.roomVo.guiPai;
        if (gui ~= -1 and (GlobalData.roomVo.hong or GlobalData.roomVo.gui > 0)) then
        --��ʾ����
            --int mGui = getDisplayGuiPai(gui);//�̽��淨����ʾ��ǰ���Ƶ�ǰһ��
            guiObj.TopAndBottomCardScript.Init(gui, DirectionEnum.T,true);
            guiObj:SetActive(true);
        end
    end

    --��ʾ�����˵�����
    local function DisplayOtherHandercard()
        for i=1,#GlobalData.reEnterRoomData.playerList do
            local dir = GetDirection(GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid));
            local count = GlobalData.reEnterRoomData.playerList[i].commonCards;
            if (dir ~= DirectionEnum.B) then
                InitOtherCardList(dir, count);
            end
        end
    end

    --��ʾ����
    local function DisplayallGangCard()
        for i=1,#GlobalData.reEnterRoomData.playerList do
            local paiArrayType = GlobalData.reEnterRoomData.playerList[i].paiArray[2];
            local dirstr = GetDirection(GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid));
            if (table.Contains(paiArrayType,2)) then

                local gangString = GlobalData.reEnterRoomData.playerList[i].huReturnObjectVO.totalInfo.gang;
                if (gangString ~= nil) then
                    local gangtemps =string.split(gangString,',')
                    for j=1,#gangtemps do
                        local item = gangtemps[j];
                       gangpaiObj = {};
                        gangpaiObj.uuid =string.split(item,':')[1];
                        gangpaiObj.cardPiont = tonumber(string.split(item,':')[2]);
                        gangpaiObj.type = string.split(item,':')[3];
                        --�����ж��Ƿ�Ϊ�Լ��ĸ��ƵĲ���

                        GlobalData.reEnterRoomData.playerList[i].paiArray[1][gangpaiObj.cardPiont] =GlobalData.reEnterRoomData.playerList[i].paiArray[1][gangpaiObj.cardPiont]- 4;
                        if (gangpaiObj.type == "an") then
                            DoDisplayPengGangCard(dirstr, gangpaiObj.cardPiont, 4, 1);
                        else
                            DoDisplayPengGangCard(dirstr, gangpaiObj.cardPiont, 4, 0);
                        end
                    end
                end
            end

        end
    end


    --��������������߼�д�úܷ����ࣩ
    local function DisplayPengCard()
        for i=0,#GlobalData.reEnterRoomData.playerList do
            local paiArrayType = GlobalData.reEnterRoomData.playerList[i].paiArray[2];--�ڶ�������洢��������
            local dirstr = GetDirection(GetIndex(GlobalDataScript.reEnterRoomData.playerList[i].account.uuid));
            if (table.Contains(paiArrayType,1)) then--1��������������
                for j=1,#paiArrayType do
                    if (paiArrayType[j] == 1 and GlobalData.reEnterRoomData.playerList[i].paiArray[0][j] > 0) then
                        --������ûȥ���Ѿ������ܵ��ƣ����Դ���һ�£���Ҫ��Ҫȥ���Լ��ģ�
                        GlobalData.reEnterRoomData.playerList[i].paiArray[1][j] =GlobalData.reEnterRoomData.playerList[i].paiArray[1][j]-3;
                        DoDisplayPengGangCard(dirstr, j, 3, 2);
						end
                end
            end
        end
    end


    --���Ƶ�����

    local function DisplayChiCard()
        for i=1,#GlobalData.reEnterRoomData.playerList do
            local dirstr = GetDirection(GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid));
            local chiPaiArray = GlobalData.reEnterRoomData.playerList[i].chiPaiArray;
            if #chiPaiArray>0 then
                for j =1,#chiPaiArray do
                    for k=1,#chiPaiArray[j] do
                        if (GlobalData.reEnterRoomData.playerList[i].paiArray[1][chiPaiArray[j][k]] > 0) then
                            GlobalData.reEnterRoomData.playerList[i].paiArray[1][chiPaiArray[j][k]]=GlobalData.reEnterRoomData.playerList[i].paiArray[1][chiPaiArray[j][k]]-1;
                        end
                    end
                    DoDisplayChiCard(dirstr, chiPaiArray[j]);
                end
            end
        end
    end


    --��ʾ������
    --cloneCount ����clone�Ĵ���  ��Ϊ3���ʾ��   ��Ϊ4���ʾ��
    --flag 1���� 0���ܺ�����
    local function DoDisplayPengGangCard(dirstr,point,cloneCount,flag)

        local gangTempList={};
        switch=
        {
            [DirectionEnum.B]=function()
                for i=1, #cloneCount do
                    local obj;
                    if (i < 4) then
                        if (flag ~= 1) then
                            obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
                                pengGangParenTransformB.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
							obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                            obj.TopAndBottomCardScript:Init(point,dirstr,GlobalData.roomVo.guiPai==point);
                            obj.transform.localScale = Vector3.one;
                        else
                            obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/gangBack",
                                pengGangParenTransformB.transform,Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
                            obj.transform.localScale = Vector3.one;
						end
                    else
                        obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
                            pengGangParenTransformB.transform, Vector3.New(-310 + #PengGangCardList * 190, 24));
						obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                        obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);
                    end
					table.insert(gangTempList,obj)
                end
				table.insert(PengGangCardList,gangTempList);
            end,
            [DirectionEnum.T]=function()
                for i=1, #cloneCount do
                    local obj;
                    if (i < 4) then
                        if (flag ~= 1) then
                            obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_T",
                                pengGangParenTransformT.transform, Vector3.New(-370 + #PengGangList_T * 190 + i * 60, 0));
							obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                            obj.TopAndBottomCardScript:Init(point,dirstr,GlobalData.roomVo.guiPai==point);
                        else
                            obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/GangBack_T",
                                pengGangParenTransformT.transform,Vector3.New(251 - #PengGangList_T * 120 + i * 37, 0));
                            obj.transform.localScale = Vector3.one;
						end
                    else
                        obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_T",
                            pengGangParenTransformT.transform, Vector3.New(251 - #PengGangList_T * 120 + 37, 20));
						obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                        obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);

                    end
					table.insert(gangTempList,obj)
                end
				table.insert(PengGangList_T,gangTempList);
            end,
            [DirectionEnum.L]=function()
               for i=1, #cloneCount do
                    local obj;
                    if (i < 4) then
                        if (flag ~= 1) then
                            obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_L",
                                pengGangParenTransformL.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
							obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                            obj.TopAndBottomCardScript:Init(point,dirstr,GlobalData.roomVo.guiPai==point);
                        else
                            obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/GangBack_L&R",
                                pengGangParenTransformL.transform,Vector3.New(0, 122 - #PengGangList_L * 95 - i * 28));
						end
                    else
                        obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_L",
                            pengGangParenTransformL.transform, Vector3.New(0, 122 - #PengGangList_L * 95 - 18,0));
						obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                        obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);
                    end
					table.insert(gangTempList,obj)
                end
				table.insert(PengGangList_L,gangTempList);
                end,
            [DirectionEnum.R]=function()
                for i=1, #cloneCount do
                    local obj;
                    if (i < 4) then
                        if (flag ~= 1) then
                            obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_R",
                                pengGangParenTransformR.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
							obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                            obj.TopAndBottomCardScript:Init(point,dirstr,GlobalData.roomVo.guiPai==point);
                        else
                            obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/GangBack_L&R",
                                pengGangParenTransformR.transform,Vector3.New(0, -122 + #PengGangList_R * 95 + i * 28));
                             obj.transform:SetSiblingIndex(0);
						end
                    else
                        obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_R",
                            pengGangParenTransformR.transform, Vector3.New(0, -122 + #PengGangList_R * 95 + 33));
						obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                        obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);
                    end
					table.insert(gangTempList,obj)
                end
				table.insert(PengGangList_R,gangTempList);
                end
        }
		switch[dirstr]()
    end


    --��������

    local function DoDisplayChiCard(dirstr,point)
        local gangTempList={};
        switch =
        {
            [DirectionEnum.B]=function()
                for i =1, 3 do
                   local obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
                        pengGangParenTransformB.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
						obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                    obj.TopAndBottomCardScript:Init(point[i], dirstr, GlobalData.roomVo.guiPai == point[i]);
                    obj.transform.localScale = Vector3.one;
					table.insert(gangTempList,obj)
                end
				table.insert(PengGangCardList,gangTempList)
            end,
            [DirectionEnum.T]=function()
                 for i =1, 3 do
                   local obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_T",
                        pengGangParenTransformT.transform,Vector3.New(251 - #PengGangList_T * 120 + i * 37, 0));
						obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                    obj.TopAndBottomCardScript:Init(point[i], dirstr, GlobalData.roomVo.guiPai == point[i]);
					table.insert(gangTempList,obj)
                end
				table.insert(PengGangList_T,gangTempList)
			end,
            [DirectionEnum.L]=function()
                 for i =1, 3 do
                   local obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_L",
                        pengGangParenTransformL.transform, Vector3.New(0, 122 - #PengGangList_L * 95 - i * 28));
                 		obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                    obj.TopAndBottomCardScript:Init(point[i], dirstr, GlobalData.roomVo.guiPai == point[i]);
					table.insert(gangTempList,obj)
                end
				table.insert(PengGangList_T,gangTempList)
            end,
            [DirectionEnum.R]=function()
                 for i =1, 3 do
                   local obj = CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_R",
                        pengGangParenTransformR.transform, Vector3.New(0, -122 + #PengGangList_R * 95 + i * 28));
                   		obj.TopAndBottomCardScript=TopAndBottomCardScript.New()
                    obj.TopAndBottomCardScript:Init(point[i], dirstr, GlobalData.roomVo.guiPai == point[i]);
					obj.transform:SetSiblingIndex(0);
					table.insert(gangTempList,obj)
                end
				table.insert(PengGangList_T,gangTempList)
			end
        }
		switch [dirstr]()
    end

	function InviteFriend()
        GlobalData.wechatOperate:inviteFriend();
    end

    --�û����߻ص�
    function offlineNotice(response)
        local uuid = tonumber(response.message);
        local index = GetIndex(uuid);
        local dirstr = GetDirection(index);
        switch=
        {
            [DirectionEnum.B]=function()
                playerItems[1].PlayerItemScript:SetPlayerOffline();
                end,
            [DirectionEnum.R]=function()
                playerItems[2].PlayerItemScript:SetPlayerOffline();
                end,
            [DirectionEnum.T]=function()
                playerItems[3].PlayerItemScript:SetPlayerOffline();
                end,
            [DirectionEnum.L]=function()
                playerItems[4].PlayerItemScript:SetPlayerOffline();
                end
        }
		switch[dirstr]()
        --�����ɢ��������У����˵��ߣ�ֱ�Ӳ��ܽ�ɢ����
        if (GlobalData.isonApplayExitRoomstatus) then
            if (dissoDialog ~= nil) then
                dissoDialog.VoteScript.removeListener();
                Destroy(dissoDialog);
            end
            TipsManager.setTips("����" .. avatarList[index].account.nickname .. "���ߣ�ϵͳ���ܽ�ɢ���䡣");
        end
    end

	--�û���������
    local function OnlineNotice(response)
        local uuid = tonumber(response.message);
        local index = GetIndex(uuid);
        local dirstr = GetDirection(index);
        switch=
        {
            [DirectionEnum.B]=function()
                playerItems[1].PlayerItemScript:SetPlayerOnline();
            end,
            [DirectionEnum.R]=function()
                playerItems[2].PlayerItemScript:SetPlayerOnline();
            end,
            [DirectionEnum.T]=function()
                playerItems[3].PlayerItemScript:SetPlayerOnline();
            end,
            [DirectionEnum.L]=function()
                playerItems[4].PlayerItemScript:SetPlayerOnline();
            end
        }
		switch[dirstr]()
    end

	local function messageBoxNotice(response)
        local arr =string.split(response.message,'|')
        local uuid = tonumber(arr[1]);
        local myIndex = GetMyIndexFromList();
        local curAvaIndex = GetIndex(uuid);
        local seatIndex = curAvaIndex - myIndex;
        if (seatIndex < 1) then
            seatIndex = 4 + seatIndex;
        end
        playerItems[seatIndex]:ShowChatMessage(tonumber(arr[1]));
    end


    --׼����Ϸ

    local function ReadyGame()
        readyvo = {};
        readyvo.duanMen = ReadySelect[1].isOn;
        readyvo.jiaGang = ReadySelect[2].isOn;
        log("ReadySelect[1].isOn=" + ReadySelect[1].isOn .. "ReadySelect[2].isOn=" .. ReadySelect[2].isOn);
        ReadySelect[1].gameObject:SetActive(false);
        ReadySelect[2].gameObject:SetActive(false);
        btnReadyGame:SetActive(false);
        CustomSocket.getInstance():sendMsg(GameReadyRequest.New(readyvo));
    end

	local function MicInputNotice(response)
        local sendUUid = tonumber(response.message)
        if (sendUUid > 0) then
            for i=1,#playerItems do
                if (playerItems[i]:GetUuid() ~= -1) then
                    if (sendUUid == playerItems[i]:GetUuid()) then
                        playerItems[i]:ShowChatAction();
                    end
                end
            end
        end
    end


    -- ���һ�β����������Ҳд�úܷ����ࣩ

    local function returnGameResponse(response)
        local returnstr = response.message;
        log("returnGameResponse="..returnstr);
        --1.��ʾʣ���Ƶ�������Ȧ��
        local returnJsonData = json.decode(response.message);
        local surplusCards = returnJsonData.surplusCards;
        LeavedCastNumText.text =tostring(surplusCards);
        LeavedCardsNum = surplusCards;
        local gameRound = returnJsonData.gameRound;
        LeavedRoundNumText.text =tostring(gameRound);
        GlobalData.surplusTimes = gameRound;
        local curAvatarIndexTemp = -1;--��ǰ�����˵�����
        local pickAvatarIndexTemp = -1; --��ǰ�����˵�����
        local putOffCardPointTemp = -1;--��ǰ��õ���
        local currentCardPointTemp = -1;--��ǰ���ĵ���
        --�����Լ�����

            curAvatarIndexTemp = returnJsonData.curAvatarIndex;--��ǰ�����˵�����
            putOffCardPointTemp = returnJsonData.putOffCardPoint;--��ǰ��õ���
            putOutCardPointAvarIndex = GetIndexByDir(GetDirection(curAvatarIndexTemp));
            putOutCardPoint = putOffCardPointTemp;
            SelfAndOtherPutoutCard = putOutCardPoint;
            pickAvatarIndexTemp = returnJsonData.pickAvatarIndex;--��ǰ�������˵�����

            if(table.Contains(returnJsonData,currentCardPoint)) then
            currentCardPointTemp = returnJsonData.currentCardPoint;--��ǰ���õĵ���  (�������Ժ󣬷������������ֵ��-2)
            SelfAndOtherPutoutCard = currentCardPointTemp;
			end


        if (pickAvatarIndexTemp == GetMyIndexFromList()) then
        --�Լ�����
            if (currentCardPointTemp == -2) then
                MoPaiCardPoint = handerCardList[1][#handerCardList[1]].bottomScript.CardPoint;
                SelfAndOtherPutoutCard = MoPaiCardPoint;
                useForGangOrPengOrChi = curAvatarIndexTemp;
                Destroy(handerCardList[1][#handerCardList[1]]);
				table.remove(handerCardList[1])
                SetPosition(false);
                PutCardIntoMineList(MoPaiCardPoint);
                MoPai();
                curDir = DirectionEnum.B;
                SetDirGameObjectAction();
                GlobalData.isDrag = true;
            else
                if ((#handerCardList[1]) % 3 ~= 1) then
                    MoPaiCardPoint = currentCardPointTemp;
                    log("����" .. MoPaiCardPoint);
                    SelfAndOtherPutoutCard = MoPaiCardPoint;
                    useForGangOrPengOrChi = curAvatarIndexTemp;
                    for i=1,#handerCardList[1] do
                        if (handerCardList[1][i].bottomScript.CardPoint == currentCardPointTemp) then
                            Destroy(handerCardList[1][i]);
							table.remove(handerCardList[1],i)
                            break;
                        end
                    end
                    SetPosition(false);
                    PutCardIntoMineList(MoPaiCardPoint);
                    MoPai();
                    curDir = DirectionEnum.B;
                    SetDirGameObjectAction();
                    GlobalData.isDrag = true;
                end
            end
        else
        --��������
            curDir = GetDirection(pickAvatarIndexTemp);
            --otherMoPaiCreateGameObject (curDirString);
            SetDirGameObjectAction();
        end





        --���ָ�������
        local dirindex = GetIndexByDir(GetDirection(curAvatarIndexTemp));
        --cardOnTable = tableCardList[dirindex][tableCardList[dirindex].Count - 1];
        if (tableCardList[dirindex] == nil or #tableCardList[dirindex] == 0) then
        --������
        else
            local temp = tableCardList[dirindex][#tableCardList[dirindex]];
            cardOnTable = temp;
            SetPointGameObject(temp);
        end
end





--��ɢ���䰴ť
local function InitbtnJieSan()
 if (bankerId == GetMyIndexFromList()) then--���Ƿ�����һ��ʼׯ���Ƿ�����

            btnJieSan.GetComponent("Image").sprite = resMgr:LoadPrefab('prefabs', {'Assets/Project/DynaImages/jiesan.png'}, nil)

        else

            btnJieSan.GetComponent("Image").sprite = AssetBundleManager.ABInstantiate("Assets/Project/DynaImages/leaveRoom.png",nil)
        end
        btnJieSan.onClick.AddListener(QuiteRoom);
end


------------------------------------------------------------
--�ر����--
function GamePanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

--�Ƴ��¼�--
function GamePanelCtrl.RemoveListener()
	SocketEventHandle.getInstance().StartGameNotice       =nil;
	SocketEventHandle.getInstance().pickCardCallBack      =nil
	SocketEventHandle.getInstance().otherPickCardCallBack =nil
	SocketEventHandle.getInstance().putOutCardCallBack    =nil
	SocketEventHandle.getInstance().otherUserJointRoomCallBack = nil
	SocketEventHandle.getInstance().PengCardCallBack = nil;
	SocketEventHandle.getInstance().ChiCardCallBack  = nil
	SocketEventHandle.getInstance().GangCardCallBack = nil
	SocketEventHandle.getInstance().gangCardNotice =nil
	SocketEventHandle.getInstance ().btnActionShow =nil
	SocketEventHandle.getInstance ().HupaiCallBack =nil
	--SocketEventHandle.getInstance ().FinalGameOverCallBack -= finalGameOverCallBack;
	SocketEventHandle.getInstance ().outRoomCallback =nil
	SocketEventHandle.getInstance ().dissoliveRoomResponse =nil
	SocketEventHandle.getInstance ().gameReadyNotice =nil
	SocketEventHandle.getInstance ().offlineNotice =nil
	SocketEventHandle.getInstance().onlineNotice =nil
	SocketEventHandle.getInstance ().messageBoxNotice =nil
	SocketEventHandle.getInstance ().returnGameResponse =nil
	--CommonEvent.getInstance ().readyGame -= markselfReadyGame;
	SocketEventHandle.getInstance ().micInputNotice =nil
	SocketEventHandle.getInstance ().gameFollowBanderNotice =nil
	Event.RemoveListener(closeGamePanel,this.ExitOrDissoliveRoom)
end

--�����--
function GamePanelCtrl.Open()
	if(gameObject) then
	gameObject:SetActive(true)
	transform:SetAsLastSibling();
	this.AddListener()
end
end
--�����¼�--
function GamePanelCtrl.AddListener()
	SocketEventHandle.getInstance().StartGameNotice =StartGame;
	SocketEventHandle.getInstance().pickCardCallBack =PickCard;
	SocketEventHandle.getInstance().otherPickCardCallBack =OtherPickCard;
	SocketEventHandle.getInstance().putOutCardCallBack =OtherPutOutCard;
	SocketEventHandle.getInstance().otherUserJointRoomCallBack =OtherUserJointRoom;
	SocketEventHandle.getInstance().PengCardCallBack =PengCard;
	SocketEventHandle.getInstance().ChiCardCallBack =ChiCard;
	SocketEventHandle.getInstance().GangCardCallBack =GangResponse;
	SocketEventHandle.getInstance().gangCardNotice =OtherGang;
	SocketEventHandle.getInstance ().btnActionShow =ActionBtnShow;
	SocketEventHandle.getInstance ().HupaiCallBack = HupaiCallBack;
	--SocketEventHandle.getInstance ().FinalGameOverCallBack =this.FinalGameOverCallBack;
	SocketEventHandle.getInstance ().outRoomCallback =OutRoomCallbak;
	SocketEventHandle.getInstance ().dissoliveRoomResponse =DissoliveRoomResponse;
	SocketEventHandle.getInstance ().gameReadyNotice = GameReadyNotice;
	SocketEventHandle.getInstance ().offlineNotice = OfflineNotice;
	SocketEventHandle.getInstance ().messageBoxNotice = MessageBoxNotice;
	SocketEventHandle.getInstance ().returnGameResponse = ReturnGameResponse;
	SocketEventHandle.getInstance().onlineNotice = OnlineNotice;
	--CommonEvent.getInstance ().readyGame = this.MarkselfReadyGame;
	SocketEventHandle.getInstance ().micInputNotice = MicInputNotice;
	SocketEventHandle.getInstance ().gameFollowBanderNotice = GameFollowBanderNotice;
	Event.AddListener(closeGamePanel,this.ExitOrDissoliveRoom)
end
