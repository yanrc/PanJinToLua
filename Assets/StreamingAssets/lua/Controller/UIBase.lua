local _UIBase =
{
	name = "",
	gameObject = nil,
	transform = nil,
	lua = nil,
}
function _UIBase:Awake()
	logWarn(self.name .. ":Awake--->>");
	PanelManager:CreatePanel(self.name, self.OnCreate);
	CtrlManager.AddCtrl(self.name, self)
end

function _UIBase:Init(obj)
	self.gameObject = obj
	self.transform = obj.transform
	self.lua = obj:GetComponent('LuaBehaviour');
	obj:SetActive(false)
	logWarn("Start lua--->>" .. obj.name);
end

function _UIBase:Open(...)
	log("open panel:" .. self.name)
	if (self.gameObject) then
		self.gameObject:SetActive(true)
		self.transform:SetAsLastSibling();
		self.AddListener()
		self.OnOpen(...)
	end
end

function _UIBase:Close()
	self.gameObject:SetActive(false)
	self.RemoveListener()
end
_UIBase.__index = function(t, k)
	return rawget(_UIBase, k)
end
setmetatable(_UIBase, _UIBase)
function UIBase(name)
	local base = { name = name }
	setmetatable(base, _UIBase)
	return base
end