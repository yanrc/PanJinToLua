LJ�  L,   7  , +  7  >+  7  7% > 7% >, +  7  7% > 7% >, +  7  7% >7, +  7%	 >7, +  7%
 > 7% >, + 4 7:+ 7 7+ + 7>+ 7 7+ + 7>G  �� �����	�OpenXieyiPanel
LoginAddClicklua	LOGOGameSettingsprite
Image	logoButtongameObjectToggle/LabelToggle	TextGetComponentTextVersionFindChild	Inittransform�  -  7  >  7 >4 %  $>4 4 >4 74 7	 > = 5
 2 4
 77;4  74 74 7 *	
 > =4 +  >4 4 >G   �HomePanelOpenPanelLoginChat_Request	APISChatRequestSendChatMessagenetworkMgr	uuidaccountLoginDatadecode	jsonNewAvatarVOWaitingPanelClosePanel"LUA:StartPanel.LoginCallBack=logReadStringReadInt�  I  7  >  7 >4 4 >4 7 >5 4 ' :4 7	4 7
>4 %  $>' 4 7
 ' I�4 7
6774	 7		7			 T�5 2 4	 7		7		;	4	 
	 7		4 74 7 * > =	T�K�4 +  >4 4 74 7> = G   �roomTypeGetGameStartPanelOpenPanelLoginChat_Request	APISNewChatRequestSendChatMessagenetworkMgr	uuidLoginDataopenidaccountLua:RoomBackResponse=logplayerListSetListAvatarVOenterTypeRoomDatadecode	jsonWaitingPanelClosePanelReadStringReadIntQ   	4  7' >4  7>G  SendConnectnetworkMgr	waitcoroutine�   #4   4 > 4     T�4  7    7  4 7>    T�+   7  > T �4 	    T�4  7    7  4 7
>    T�+   7  > G   �WechatPlatformUNITY_IPHONE
LoginWeChatPlatformTypeIsAuthorizedshareSdkWechatOperateUNITY_ANDROIDWaitingPanelClosePanel�  
 +   7      T�+  7  > 4  4 % > T �4  % > 4  7  %	 ' > G  � �#请先同意用户使用协议SetTipsTipsManager'lua:请先同意用户使用协议log进入游戏中WaitingPanelOpenPaneldoLogin	isOn�    4   % 4 4 >% 4 4 >$> 4     T�4     T	�4    7  % 3	 4
 7> T �4  7  > G  
LoginWechatOperateTestLoginLoginManager  -Assets/Project/Prefabs/LoginPanel.prefabprefabsLoadPrefabresMgrUNITY_STANDALONE_WIN,UNITY_STANDALONE_WIN=UNITY_EDITORtostringUNITY_EDITOR=log�   4     7  ' > +      T�+     7  ) > T �4    7  % 3 + 7> G  � �InitXieyiPanel  -Assets/Project/Prefabs/xieyiPanel.prefabprefabsLoadPrefabresMgrSetActiveplaySoundByActionButtonsoundMgr�  %4  8  >,  +  74 77:+  74 7:+  7 7>+   7%	 >4 7:
+   7%	 >4 7:G  �offsetMin	zeroVector2offsetMaxRectTransformGetComponentSetAsLastSiblingoneVector3localScaleStartPanelparenttransformnewObjectl   4     7  ' > +      T�+     7  ) > G  �SetActiveplaySoundByActionButtonsoundMgr�  	 2  4  ;4 ;4 ;4 ;4 ;4 ;4 ;4 ;4 ;	6   T�4 H GamePanelTuidaohuGameJiujiangGameShuangliaoGameWuxiGameGuangdongGameChangshaGamePanjinGameZhuanzhuanGame�  4   7' >+  % 4 7$:4 4 % >4	 7
+ 7' >G  � �ConnectTime
startcoroutine正在连接服务器WaitingPanelOpenPanelversionApplication版本号：	textplayBGMsoundMgr�  4  74 7+  7>4  74 4 7>+  7>4  74 4 7	>+  7
>G   �RoomBackResponseBACK_LOGIN_RESPONSELoginCallBackLOGIN_RESPONSE	APIStostringOnConnectConnectProtocalRemoveListener
Event�  4  74 7+  7>4  74 4 7>+  7>4  74 4 7	>+  7
>G   �RoomBackResponseBACK_LOGIN_RESPONSELoginCallBackLOGIN_RESPONSE	APIStostringOnConnectConnectProtocalAddListener
Event�  ! 64   4 774 7> 5  4  *	 4
 1 :
4
 1 :
4
 1
 :	
4
 1 :
4
 1 :
4
 1 :
4
 1 :
4
 1 :
4
 1 :
4
 1 :
4
 1 :
4
 1 :
4
 1 :
4
 1  :
0  �G   AddListener RemoveListener OnOpen GetGame CloseXieyiPanel InitXieyiPanel OpenXieyiPanel doLogin 
Login OnConnect ConnectTime RoomBackResponse LoginCallBack OnCreate
FixUIStartPanelPanelsdefineUIBase 