PlayerItem={

}
local mt = {}--Ԫ�����ࣩ
mt.__index = PlayerItem--index����
--���캯��
function PlayerItem.New()
	local playerItem = {}
	setmetatable(playerItem, mt)
	return playerItem
end

function PlayerItem:Clean()
	
end

function PlayerItem:SetHuFlagHidde()
	
end

function PlayerItem:SetAvatarVo(avatar)


end