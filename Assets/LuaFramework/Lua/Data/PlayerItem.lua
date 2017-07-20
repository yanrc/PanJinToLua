PlayerItem = {
	gameObject,
	headerIcon,-- ͷ��
	bankerImg,-- ׯ��
	nameText,-- ����
	readyImg,-- ׼������
	scoreText,-- ����
	chatAction,-- ����ͼ��
	offlineImage,-- ���߱�־
	chatMessage,-- ��������
	chatPaoPao,-- ���ﱳ��
	HuFlag,-- ����ͼ��
	uuid,-- ���uuid
	showTime,-- ������ʾʱ��
	showChatTime,-- ������ʾʱ��
	jiaGang,-- �Ӹ֡�Ʈ�ֵ�
	avatarvo,
}
local mt = { }-- Ԫ�����ࣩ
mt.__index = PlayerItem-- index����
-- ���캯��
function PlayerItem.New(go)
	local playerItem = { }
	setmetatable(playerItem, mt)
	playerItem.gameObject = go
	playerItem.headerIcon = go:GetComponent('Image')
	playerItem.bankerImg = go.transform:FindChild('bankerImg'):GetComponent('Image')
	playerItem.nameText = go.transform:FindChild('Text'):GetComponent('Text')
	playerItem.readyImg = go.transform:FindChild('readyImg'):GetComponent('Image')
	playerItem.scoreText = go.transform:FindChild('Coins'):GetComponent('Text')
	playerItem.chatAction = go.transform:FindChild('Image_Chat').gameObject
	playerItem.offlineImage = go.transform:FindChild('Image_offline'):GetComponent('Image')
	playerItem.chatMessage = go.transform:FindChild('chatBg/Text'):GetComponent('Text')
	playerItem.chatPaoPao = go.transform:FindChild('chatBg').gameObject
	playerItem.HuFlag = go.transform:FindChild('Image_hu').gameObject
	playerItem.jiaGang = go.transform:FindChild('Text_jiagang'):GetComponent('Text')
	playerItem.showTime = 0
	playerItem.showChatTime = 0
	playerItem.uuid = -1
	playerItem.avatarvo = nil
	UpdateBeat:Add(playerItem.Update, playerItem);
	return playerItem
end

function PlayerItem:Update()
	if (self.showTime > 0) then
		self.showTime = self.showTime - 1;
		if (self.showTime <= 0) then
			self.chatPaoPao:SetActive(false);
		end
	end
	if (self.showChatTime > 0) then
		self.showTime = self.showTime - 1;
		if (self.showChatTime <= 0) then
			self.chatAction:SetActive(false);
		end
	end
end

function PlayerItem:SetAvatarVo(avatar)
	if (avatar ~= nil) then
		self.readyImg.enabled = avatar.isReady;
		self.bankerImg.enabled = avatar.main;
		self.nameText.text = avatar.account.nickname;
		self.scoreText.text = tostring(avatar.scores)
		self.offlineImage.enabled =(not avatar.isOnLine);
		self.uuid = avatar.account.uuid
		self.avatarvo = avatar
		CoMgr.LoadImg(self.headerIcon, avatar.account.headicon);
	else
		self:Clean()
	end
end

function PlayerItem:SetBankImg(flag)
	self.bankerImg.enabled = flag;
end

function PlayerItem:SetReadyImg(flag)
	self.readyImg.enabled = flag;
end

function PlayerItem:ShowChatAction()
	self.showChatTime = 120;
	self.chatAction:SetActive(true);
end

function PlayerItem:GetUuid()
	return self.uuid
end

function PlayerItem:Clean()
	self.headerIcon.sprite = UIManager.DefaultIcon
	self.bankerImg.enabled = false
	self.readyImg.enabled = false
	self.scoreText.text = "";
	self.nameText = ""
	self.uuid = -1;
end

function PlayerItem:SetPlayerOffline(value)
	self.offlineImage.enabled = value
end
-- ��Ƶ ��1001-1011
function PlayerItem:ShowChatMessage(index)
	self.showTime = 200;
	index = index - 1000;
	self.chatMessage.text = GlobalData.messageBoxContents[index];
	self.chatPaoPao:SetActive(true);
end


function PlayerItem.DisplayAvatorIp(self)
	if (self.avatarvo ~= nil) then
		OpenPanel(UserInfoPanel, self.avatarvo)
		soundMgr:playSoundByActionButton(1);
	end
end

function PlayerItem:SetHuFlag(value)
	self.HuFlag:SetActive(value);
end
