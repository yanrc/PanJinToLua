
ExitPanel = UIBase("ExitPanel");
local this = ExitPanel;

local transform;
local gameObject;

--�����¼�--
function ExitPanel.OnCreate(obj)
	gameObject = obj;
	this:Init(obj)
	this.lua:AddClick( ExitPanel.btnExit, this.Exit);
	this.lua:AddClick( ExitPanel.btnCancel, this.Cancel);
end

--�����¼�--
function ExitPanel.Exit(go)
	log("lua:exit click")
end

--�ر��¼�--
function ExitPanel.Cancel()
	log("lua:cancel")
end


-------------------ģ��-------------------------

--�Ƴ��¼�--
function ExitPanel.RemoveListener()
	
end

--�����¼�--
function ExitPanel.AddListener()

end