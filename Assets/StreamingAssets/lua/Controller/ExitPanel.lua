
ExitPanel = UIBase(define.ExitPanel,define.PopUI);
local this = ExitPanel;
local transform;
local gameObject;

local btnExit
local btnCancel

-- �����¼�--
function ExitPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform;
	this:Init(obj)
	btnExit = transform:FindChild('Image_Bg/Button_Sure').gameObject
	btnCancel = transform:FindChild('Image_Bg/Button_Cancle').gameObject
	this.lua:AddClick(btnExit, this.Exit)
	this.lua:AddClick(btnCancel, this.CloseClick)
end


function ExitPanel.Exit()
	log("lua:exit click")
end


-------------------ģ��-------------------------
function ExitPanel.CloseClick()
ClosePanel(this)
end

function ExitPanel.OnOpen()
	
end
-- �Ƴ��¼�--
function ExitPanel.RemoveListener()

end

-- �����¼�--
function ExitPanel.AddListener()

end