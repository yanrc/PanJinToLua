require "View/ExitPanel"
ExitPanelCtrl = {};
local this = ExitPanelCtrl;

local transform;
local gameObject;

--��������--
function ExitPanelCtrl.New()
	logWarn("ExitPanelCtrl.New--->>");
	return this;
end

function ExitPanelCtrl.Awake()
	logWarn("ExitPanelCtrl.Awake--->>");
	PanelManager:CreatePanel('ExitPanel', this.OnCreate);
	CtrlManager.ExitPanelCtrl=this
end

--�����¼�--
function ExitPanelCtrl.OnCreate(obj)
	gameObject = obj;
	lua = gameObject:GetComponent('LuaBehaviour');
	lua:AddClick( ExitPanel.btnExit, this.Exit);
	lua:AddClick( ExitPanel.btnCancel, this.Cancel);
	logWarn("Start lua--->>"..gameObject.name);
end

--�����¼�--
function ExitPanelCtrl.Exit(go)
	log("lua:exit click")
end

--�ر��¼�--
function ExitPanelCtrl.Cancel()
	log("lua:cancel")
end


-------------------ģ��-------------------------

--�ر����--
function ExitPanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

--�Ƴ��¼�--
function ExitPanelCtrl.RemoveListener()
	
end

--�����--
function ExitPanelCtrl.Open()
	if(gameObject) then
	gameObject:SetActive(true)
	transform:SetAsLastSibling();
	this.AddListener()
	end
end
--�����¼�--
function ExitPanelCtrl.AddListener()

end