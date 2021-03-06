

UIManager = { }
local this = UIManager;
this.PanelNum = 0
--预制体加载好了再加载panel
function UIManager.InitPanels()
	log("Lua:UIManager.InitPanels")
	Event.AddListener(define.PanelsInited, this.OnInited)
	for k, v in pairs(define.Panels) do
		this.PanelNum = this.PanelNum + 1
		_G[v]:Awake()
	end
end
-- 面板都加载好了，再打开StartPanel
function UIManager.OnInited(panel)
	this.PanelNum = this.PanelNum - 1
	if (this.PanelNum == 0) then
		LoadingProgress.ClearProgressBar();
		UpdateBeat:Add(this.Update);
		OpenPanel(StartPanel)
	end
end
--先加载预制体
function UIManager.InitPrefabs()
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/Pointer.prefab" }, function(prefabs) this.Pointer = newObject(prefabs[0]) end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_B.prefab' }, function(prefabs) this.Bottom_B = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_R.prefab' }, function(prefabs) this.Bottom_R = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_T.prefab' }, function(prefabs) this.Bottom_T = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_L.prefab' }, function(prefabs) this.Bottom_L = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard.prefab" }, function(prefabs) this.TopAndBottomCard = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ThrowCard/ThrowCard_R.prefab" }, function(prefabs) this.ThrowCard_R = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ThrowCard/ThrowCard_L.prefab" }, function(prefabs) this.ThrowCard_L = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_B.prefab" }, function(prefabs) this.PengGangCard_B = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_R.prefab" }, function(prefabs) this.PengGangCard_R = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_T.prefab" }, function(prefabs) this.PengGangCard_T = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_L.prefab" }, function(prefabs) this.PengGangCard_L = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/gangBack.prefab" }, function(prefabs) this.GangBack = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/GangBack_L&R.prefab" }, function(prefabs) this.GangBack_LR = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/GangBack_T.prefab" }, function(prefabs) this.GangBack_T = prefabs[0] end)
	resMgr:LoadSprite('dynaimages', { 'Assets/Project/DynaImages/morentouxiang.jpg' }, function(sprite) this.DefaultIcon = sprite[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ShopItem.prefab" }, function(prefabs) this.ShopItem = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/RecordItem.prefab" }, function(prefabs) this.RecordItem = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/DetailItem.prefab" }, function(prefabs) this.DetailItem = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/playBack/HandCard_B.prefab" }, function(prefabs) this.HandCard_B = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/playBack/HandCard_R.prefab" }, function(prefabs) this.HandCard_R = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/playBack/HandCard_T.prefab" }, function(prefabs) this.HandCard_T = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/playBack/HandCard_L.prefab" }, function(prefabs) this.HandCard_L = prefabs[0] end)
	this.InitCards()
end

function UIManager.InitCards()
	this.bCards = { }
	this.lrCards = { }
	this.sCards = { }
	local path = { }
	for i = 1, 34 do
		table.insert(path, "Assets/Project/DynaImages/Cards/Big/b" ..(i - 1) .. ".png")
	end
	for i = 1, 34 do
		table.insert(path, "Assets/Project/DynaImages/Cards/Left&Right/lr" ..(i - 1) .. ".png")
	end
	for i = 1, 34 do
		table.insert(path, "Assets/Project/DynaImages/Cards/Small/s" ..(i - 1) .. ".png")
	end
	resMgr:LoadSprite('dynaimages', path, function(prefabs)
		for i = 1, 34 do
			table.insert(this.bCards,prefabs[i-1])
		end
		for i = 1, 34 do
			table.insert(this.lrCards,prefabs[i+33])
		end
		for i = 1, 34 do
			table.insert(this.sCards,prefabs[i+67])
		end
	end)
	this.InitPanels();
end

function OpenPanel(panel, ...)
	if (panel._type == define.FixUI) then
		log("Lua:OpenFix==>" .. panel.name)
	else
		log("Lua:OpenPop==>" .. panel.name)
	end
	local args = { ...};
	xpcall(
	function() panel:Open(unpack(args)) end, logError
	)
end


function ClosePanel(panel)
	if (panel._type == define.FixUI) then
		log("Lua:CloseFix==>" .. panel.name)
	else
		log("Lua:ClosePop==>" .. panel.name)
	end
	xpcall(
	function() panel:Close() end, logError
	)
end

-- 返回登陆界面
function UIManager.ReturnStartPanel()
	log(debug.traceback())
	for k, v in pairs(define.Panels) do
		if v ~= "GamePanel" then
			ClosePanel(_G[v])
		end
	end
	ClosePanel(StartPanel.GetGame(RoomData.roomType))
	LoginData = { }
	OpenPanel(StartPanel)
end

function UIManager.Update()
	if (Input.GetKey(KeyCode.Escape)) then
		OpenPanel(ExitPanel)
	end
end

