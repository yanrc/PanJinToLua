UserInfoPanel = UIBase(define.Panels.UserInfoPanel, define.PopUI)
local this = UserInfoPanel
local gameObject
local headIcon
local IP
local ID
local nameText
local headIconPath
-- 启动事件--
function UserInfoPanel.OnCreate(obj)
	gameObject = obj;
	this:Init(obj)
	headIcon = obj.transform:Find("Image_icon"):GetComponent("Image")
	IP = obj.transform:Find("TextIP"):GetComponent("Text")
	ID = obj.transform:Find("TextID"):GetComponent("Text")
	nameText = obj.transform:Find("TextName"):GetComponent("Text")
	this.lua:AddClick(obj, this.CloseClick)
end

function UserInfoPanel.CloseClick()
	ClosePanel(this)
end

function UserInfoPanel:OnOpen(userInfo)
	headIconPath = userInfo.account.headicon;
	IP.text = "IP:" .. userInfo.IP;
	ID.text = "ID:" .. tostring(userInfo.account.uuid)
	nameText.text = "昵称:" .. userInfo.account.nickname;
	headIcon.sprite=UIManager.DefaultIcon
	CoMgr.LoadImg(headIcon, headIconPath);
end