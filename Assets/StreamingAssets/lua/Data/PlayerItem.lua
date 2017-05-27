PlayerItem = {
	gameObject,
	headerIcon,--ͷ��
	bankerImg,--ׯ��
	nameText,--����
	ReadyImg,--׼������
	ScoreText,--����
	chatAction,--����ͼ��
	offlineImage,--���߱�־
	chatMessage,--��������
	chatPaoPao,--���ﱳ��
	huFlag,--����ͼ��
	avatarvo,--�����Ϣ
	showTime,--������ʾʱ��
	showChatTime,--������ʾʱ��
	JiaGang--�Ӹ֡�Ʈ�ֵ�
}
local mt = { }-- Ԫ�����ࣩ
mt.__index = PlayerItem-- index����
-- ���캯��
function PlayerItem.New(go)
	local playerItem = { }
	playerItem.gameObject = go
	playerItem.headerIcon = go:GetComponent('Image')
	playerItem.bankerImg = go.transform:FindChild('bankerImg'):GetComponent('Image')
	playerItem.nameText = go.transform:FindChild('Text'):GetComponent('Text')
	playerItem.ReadyImg = go.transform:FindChild('readyImg'):GetComponent('Image')
	playerItem.ScoreText = go.transform:FindChild('Coins'):GetComponent('Text')
	playerItem.chatAction = go.transform:FindChild('Image_Chat').gameObject
	playerItem.offlineImage = go.transform:FindChild('Image_offline'):GetComponent('Image')
	playerItem.chatMessage = go.transform:FindChild('chatBg/Text'):GetComponent('Text')
	playerItem.chatPaoPao = go.transform:FindChild('chatBg').gameObject
	playerItem.huFlag = go.transform:FindChild('Image_hu').gameObject
	playerItem.JiaGang = go.transform:FindChild('Text_jiagang'):GetComponent('Text')
	setmetatable(playerItem, mt)
	return playerItem
end

function PlayerItem:Clean()

end

function PlayerItem:SetHuFlagHidde()

end

function PlayerItem:SetAvatarVo(avatar)


end