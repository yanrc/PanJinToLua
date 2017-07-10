GameOverScript = {

}
local mt = { }-- Ԫ�����ࣩ
mt.__index = GameOverScript-- index����
-- ���캯��
function GameOverScript.New(obj)
	local gameOverScript = { }
	setmetatable(gameOverScript, mt)
	return gameOverScript
end
-- ����������ʾ����
-- flg:0��ʾ�������ݣ�1��ʾ��������
function GameOverScript:SetDisplaContent(flg, personList, allMas, validMas, isNextBanker)
	self.AvatarList = personList;
	self.ValidMas = validMas;
	self:initRoomBaseInfo();
	self:ClearPanel();
	self.jushuText.text = "Ȧ����" ..(GlobalData.totalTimes - GlobalData.surplusTimes) .. "/" .. GlobalData.totalTimes;
	if (flg == 0) then
		allMasList = { }
		mas_0 = { }
		mas_1 = { }
		mas_2 = { }
		mas_3 = { }
		self.signalEndPanel:SetActive(true);
		self.finalEndPanel:SetActive(false);
		self.continueGame:SetActive(true);
		self.shareFinalButton:SetActive(false);
		self.button_Delete:SetActive(false);
		self.closeButton.transform.gameObject:SetActive(false);
		-- ���ֽ�������ʾ�鿴ս����ť
		if (GlobalDataScript.surplusTimes == 0 or GlobalDataScript.isOverByPlayer) then
			self.shareSiganlButton.gameObject:SetActive(true);
			self.continueGame.gameObject:SetActive(false);
		else
			self.shareSiganlButton.gameObject:SetActive(false);
			self.continueGame.gameObject:SetActive(true);
			self.ReadySelect[0].gameObject:SetActive(GlobalDataScript.roomVo.duanMen);
			self.ReadySelect[1].gameObject:SetActive(GlobalDataScript.roomVo.jiaGang);
			self.ReadySelect[0].interactable = isNextBanker;
		end
		self:getMas(allMas);
		self:setSignalContent();
	elseif (flg == 1) then
		self.signalEndPanel:SetActive(false);
		self.finalEndPanel:SetActive(true);
		self.shareSiganlButton:SetActive(false);
		self.continueGame.gameObject:SetActive(false);
		self.continueGame:SetActive(false);
		self.shareFinalButton:SetActive(true);
		self.button_Delete:SetActive(true);
		self.closeButton.transform.gameObject:SetActive(true);
		self:setFinalContent();
	end
end

function GameOverScript:ClearPanel()
	for i = 0, #signalEndPanel.transform.childCount do
		destroy(signalEndPanel.transform:GetChild(i).gameObject);
	end
	for i = 0, #finalEndPanel.transform.childCount do
		destroy(finalEndPanel.transform:GetChild(i).gameObject);
	end
end


function GameOverScript:initRoomBaseInfo()
	timeText.text = DateTime.Now.ToString("yyyy-MM-dd");
	roomNoText.text = "����ţ�" + GlobalData.roomVo.roomId;
	if (GlobalDataScript.roomVo.roomType == GameConfig.GAME_TYPE_ZHUANZHUAN) then
		title.text = "תת�齫";
	elseif (GlobalDataScript.roomVo.roomType == GameConfig.GAME_TYPE_HUASHUI) then
		title.text = "��ˮ�齫";
	elseif (GlobalDataScript.roomVo.roomType == GameConfig.GAME_TYPE_CHANGSHA) then
		title.text = "��ɳ�齫";
	elseif (GlobalDataScript.roomVo.roomType == GameConfig.GAME_TYPE_GUANGDONG) then
		title.text = "�㶫�齫";
	elseif (GlobalDataScript.roomVo.roomType == GameConfig.GAME_TYPE_PANJIN) then
		title.text = "�̽��齫";
	end
end

function GameOverScript:getMas()

end

function GameOverScript:setSignalContent()


end

function GameOverScript:setFinalContent()

end