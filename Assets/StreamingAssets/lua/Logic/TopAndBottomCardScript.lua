TopAndBottomCardScript={

}
local mt = {}--Ԫ�����ࣩ
mt.__index = TopAndBottomCardScript--index����
--���캯��
function TopAndBottomCardScript.New()
	local topAndBottomCardScript = {}
	setmetatable(topAndBottomCardScript, mt)
	return topAndBottomCardScript
end

function TopAndBottomCardScript:Init(cardPoint,Dir,isGuiPai)

end