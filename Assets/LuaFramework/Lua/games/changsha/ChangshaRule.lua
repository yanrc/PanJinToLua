ChangshaRule = {
	name = "长沙麻将",
	index = GameConfig.GAME_TYPE_CHANGSHA,
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
			title = "玩法",
			content =
			{
				{ name = "分庄闲", pos = { 100, 0 } },
			},
			pos = { 0, - 160 },
			isCheckBox = false
		},
		{
			title = "扎鸟",
			content =
			{
				{ name = "不扎鸟", pos = { 100, 0 } },
				{ name = "单鸟", pos = { 400, 0 }, des = "(倍)" },
				{ name = "双鸟", pos = { 700, 0 }, des = "(倍)" },
				{ name = "两只鸟", pos = { 100, - 60 }, des = "(分)" },
				{ name = "单鸟", pos = { 400, - 60 }, des = "(分)" },
				{ name = "双鸟", pos = { 700, - 60 }, des = "(分)" },
			},
			pos = { 0, - 260 },
			isCheckBox = false
		},
	},
	RuleText =
	{
		"长沙麻将\n",
		"一：规则介绍\n",
		"【基本规则】\n",
		"1.庄家确定：首局牌，掷骰子决定庄家；首局后，庄家胡不换庄，称为“连庄”，其他情\n",
		"况庄家的下家接庄。\n",
		"2.起张牌数：庄家的起张牌数为14张，闲家的起张牌数为13张。\n",
		"3.可行操作：可摸牌，可碰牌、可吃牌、可补张、可开杠，手中的牌满足相关规定的牌型\n",
		"条件时胡牌。\n",
		"4.胡牌时，小番子需2、5、8作将，大番子为乱将胡。\n",
		"5.点炮时点炮者只负责自己的输分,允许一炮多响，一炮多响被称为通炮。\n",
		"6.胡牌时若为自摸、杠上花、海底捞月,则三家输分。\n",
		"【算分规则】\n",
		"牌型的番数\n",
		"长沙麻将的成牌后部分牌型的番数分为“小胡”和“大胡”。小胡记番为1番，大胡记番\n",
		"为6番，如果牌型同时包含两个或多个大胡，称为“番上番”，记为12番。\n",
		"胡牌后，与庄家有关的番数都要加1。如庄家自摸或点胡，番数加1；如果其他玩家自摸，\n",
		"庄家单独多付1番；庄家点炮也需要多付1番。\n",
		"·注意：庄家胡番上番算作14番；其他玩家胡番上番如果与庄家有关，庄家也需要付14番。\n",
		"小胡\n",
		"1.四喜：起完牌后，玩家手上已有四张一样的牌，即可胡牌。且算作小胡自摸。\n",
		"2.板板胡：起完牌后，玩家手上没有一张2、5、8（将牌），即可胡牌。且算作小胡自摸。\n",
		"3.缺一色：起完牌后，玩家手上筒、索、万任缺一门，即可胡牌。且算作小胡自摸。\n",
		"4.六六顺：起手抓牌手上有任意俩个三张同样的牌算胡牌，比如你手上有三个4万、三个5条。且算作小胡自摸。\n",
		"5.小胡需将：小胡牌型胡牌时，必需2、5、8作将牌。\n",
		"大胡\n",
		"1.杠上花：玩家有四张一样的牌，即可开杠（听牌的情况下）。\n",
		"·按照开出的点数从牌城倒数，摸上面那张牌，此牌为杠牌(如果上面那张没有则取下一张)，\n",
		"如果杠牌能胡，则为杠上花。\n",
		"·杠上花为大胡自摸，但是必需2、5、8做将牌，不然不记杠上花番数。\n",
		"2.抢杠胡：，甲玩家先碰，后又摸到相同的一张牌，然后开杠。而别的玩家可以胡所补张\n",
		"的牌，即为抢杠胡。\n",
		"· 玩家开杠的四张牌都为自摸而来，不可抢杠。\n",
		"· 抢杠胡为大胡，但是必需2、5、8做将牌，不然不记抢杠胡番数。\n",
		"3.杠炮：某玩家开杠，而杠后摸的牌别的玩家可胡，为杠炮。\n",
		"4.海底捞月：摸到最后一张牌称为海底牌。海底捞月即为摸了海底牌自摸。\n",
		"5.海底炮：点胡别人出的海底牌。\n",
		"6.天胡：庄家起牌后就胡牌。\n",
		"7.地胡：庄家打出第一张牌,闲家胡。\n",
		"8.碰碰胡：由坎子、碰牌、以及一对牌组成的牌型。\n",
		"9.将将胡：所有牌由将牌(2、5、8)组成的牌型。\n",
		"10.清一色：同一种花色的牌。\n",
		"11.七小对：七对任意牌。\n",
		"12.全求人：牌全部依靠吃和碰对，最后只叫成一张牌，且为点胡。\n",
		"【其他规则】\n",
		"1.扎鸟：\n",
		"·玩家胡牌后，再摸紧跟着的牌即为鸟。如果海底胡，即以海底为牌为鸟，看鸟落谁家。\n",
		"·鸟的计算方法为：以胡牌家为起点，按牌面数字计算。一、五、九表示胡牌家，二、六\n",
		"表示下家，三、七为对家，四、八为上家。\n",
		"·点胡时、鸟如果扎在胡牌方或点炮方，即为中鸟，点炮人出双倍分数。\n",
		"·自摸时，鸟如果扎在胡牌方，即所有玩家给双倍分数；如果扎在别的玩家，只此一玩家\n",
		"给双倍分数。\n",
		"2.杠和补：\n",
		"·长沙麻将获得4张相同的牌后，只可以选“杠”或“补”。\n",
		"·长沙麻将在可以补张的情况下，手中的牌成牌，可以“杠”或“补”。\n",
		"·选择杠后为开杠，不可换张，如果不能胡牌，直接出摸到的牌。\n",
		"3.海底牌：\n",
		"·长沙麻将中，海底牌可漫游。即第一个玩家不要，第二个玩家可要，依此类推。如果四\n",
		"个玩家都不要，就直接流局。\n",
		"4.跟胡\n",
		"·长沙麻将不允许跟胡,即你不可以不胡下家而是去胡上家或对家,或者不胡对家而去胡上家。\n",
		"·过了一圈即不受此限,即自己摸过牌后再胡不算跟胡。\n",
	}
}


