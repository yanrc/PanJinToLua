ButtonAction={}
local mt = {}--Ԫ�����ࣩ
mt.__index = ButtonAction--index����
--���캯��
function ButtonAction.New()
	local ButtonAction = {}
	setmetatable(ButtonAction, mt)
	return ButtonAction
end

function ButtonAction.Clean()
	
end

function ButtonAction.CleanBtnShow()
	
end