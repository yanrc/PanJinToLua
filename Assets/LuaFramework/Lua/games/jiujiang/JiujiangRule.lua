JiujiangRule = {
	name = "九江麻将",
	index=GameConfig.GAME_TYPE_JIUJIANG,
	groups =
	{
		{
			title = "局数",
			content =
			{
				{ name = "4局", cost = "x1", pos = { 100, 0 } },
				{ name = "8局", cost = "x2", pos = { 400, 0 } },
				{ name = "16局", cost = "x4", pos = { 700, 0 } },
			},
			pos = { 0, - 60 },
			isCheckBox = false
		},
		{
			title = "滴麻油",
			content =
			{
				{ name = "0个", pos = { 100, 0 } },
				{ name = "1个", pos = { 400, 0 } },
				{ name = "2个", pos = { 700, 0 } },
			},
			pos = { 0, - 160 },
			isCheckBox = false
		},
		{
			title = "捆买",
			content =
			{
				{ name = "0分", pos = { 100, 0 } },
				{ name = "1分", pos = { 400, 0 } },
				{ name = "2分", pos = { 700, 0 } },
			},
			pos = { 0, - 260 },
			isCheckBox = false
		},
		{
			title = "赖子",
			content =
			{
				{ name = "红中赖子", pos = { 100, 0 } },
			},
			pos = { 0, - 360 },
			isCheckBox = false
		}
	},
	RuleText =
	{
		"九江麻将																					\n",
		"【游戏说明】																				\n",
		"牌数：共120张：万、条、筒、中、发、白。													\n",
		"平胡是指牌型达到了听胡基本要求,九江麻将必须自己二炮起胡。								\n",
		"【规则】																					\n",
		"1.由创建者坐庄，以后谁胡谁做庄															\n",
		"2.不可以吃，可以碰，胡牌可以接炮														   	\n",
		"3.抓到发财补牌，须等到自己抓牌时才补牌													\n",
		"4.暗杠不显牌，其他玩家也不能枪杠														   	\n",
		"5.玩家补杠不要求摸到即杠，允许过圈														\n",
		"6.自摸平胡加1分																			\n",
		"7.1~3炮计1分，以后每4炮加1分，以此类推													\n",
		"【可选以下】																				\n",
		"a.局数：8局，16局																		\n",
		"b.游戏人数:3人,4人																		\n",
		"c.滴麻油数：0个，1个，2个（相当于抓鸟数）												\n",
		"d.红中癞子																				\n",
		"【加算炮规则】																			\n",
		"（累计加算）																				\n",
		"1炮：平胡，门清，卡张，碰红中或白板，1个发财，自摸，明杠（不包括红中跟白板），单吊		\n",
		"2炮：手抓3个红中或白板，暗杠（不包括红中跟白板）										   	\n",
		"3炮：明杠红中或白板																		\n",
		"4炮：暗杠红中或白板																		\n",
		"5炮：碰碰胡，抢杠，杠开，杠上流泪，海底													\n",
		"7炮：7对																				   	\n",
		"8炮：4个发财																				\n",
		"10炮：清一色，全求人																		\n",
	}
}
																							