GameOverScript={

}
local mt = {}--Ԫ�����ࣩ
mt.__index = GameOverScript--index����
--���캯��
function GameOverScript.New()
	local gameOverScript = {}
	setmetatable(gameOverScript, mt)
	return gameOverScript
end