BottomScript={
isSelected=false
}
local mt = {}--Ԫ�����ࣩ
mt.__index = BottomScript--index����
--���캯��
function BottomScript.New()
	local bottomScript = {}
	setmetatable(bottomScript, mt)
	return bottomScript
end

function BottomScript:Clean()
	
end

function BottomScript:GetPoint()
	
end