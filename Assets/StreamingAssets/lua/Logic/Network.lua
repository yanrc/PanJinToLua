LJ�   J4   % > 4  7  4 7+  7> 4  7  4 7+  7> 4  7  4 7	+  7
> 4  7  4 7+  7> 4  7  4 7+  7> 4  7  4 7+  7> 4  7  4 7+  7> 4  7  4 7+  7> 4  7  4 7+  7> 4  7  4 7+  7> G  �ChatConnectFailOnChatDisconnectChatDisconnectOnChatExceptionChatExceptionOnChatMessageChatMessageOnChatConnectChatConnectOnDisconnectDisconnectOnExceptionExceptionOnMessageMessageOnConnectFailConnectFailOnConnectConnectProtocalAddListener
EventNetwork.Start!!logWarn�   4  4 7%    > = 4 74   > >G  tostringBrocast
Eventkey=%#x,data=%sformatstringlog�  	 +      T�Q �4   7  ' > 4    7  4 74 7% > = T �G  �	head	APISNewClientRequestSendMessagenetworkMgr	waitcoroutinem   
4   % > /  4  7  + 7> G  ��Sendheart
startcoroutineGame Server connected!!logWarn|    
4   % > 4  7  > 4  7  > G  ClearData	GameReturnStartPanelUIManagerGame Server connect fail!!logWarn�   4   % > /  4  7  + 7> 4    7  > G  ��SendConnectnetworkMgrSendheart	stopcoroutineOnException------->>>>logWarn�  	 4   % > /  4  7  + 7> 4  7  > 4  7  > G  ��ClearData	GameReturnStartPanelUIManagerSendheart	stopcoroutineOnDisconnect------->>>>logWarn4   4  % >G  OnMessage-------->>>logWarn7    4   % > G  Chat Server connected!!logWarn:    4   % > G  Game Server connect fail!!logWarn:    4   % > G  OnChatException------->>>>logWarn;    4   % > G   OnChatDisconnect------->>>>logWarn8   4  % >G  OnChatMessage-------->>>logWarnz     7  >  7 >4 %  %  $>G   str:> TestLoginBinary: protocal:>logReadStringReadByte� 	 	   7  >  7 >4 7> 7 >4 %  % 7$>G  id msg:>TestLoginPblua: protocal:>logParseFromStringLoginResponselogin_pbReadBufferReadByte�   7  7  >  7 >4 7% $4 7 % > 7%	 > 7
>4 7 >4 7%  >4 7>4 7>4 7>T
�4 % 7$7>A
N
�4 % 	 $	>G  TestLoginPbc: protocal:>log	typenumber	
phoneipairsid	name
printtutorial.Persondecoderegisterprotobuf
close*a	readrb	openiolua/3rd/pbc/addressbook.pbDataPath	UtilReadBufferReadByte�    7  >  7 >+  7% > 7%  >+  >4 %  $>G   �� TestLoginSproto: protocal:>logAddressBookdecode�							    .Person {
							        name 0 : string
							        id 1 : integer
							        email 2 : string

							        .PhoneNumber {
							            number 0 : string
							            type 1 : integer
							        }

							        phone 3 : *PhoneNumber
							    }

							    .AddressBook {
							        person 0 : *Person(id)
							        others 1 : *Person
							    }
							    
parseReadBufferReadByte�    64   7  4 7> 4   7  4 7> 4   7  4 7> 4   7  4 7> 4   7  4 7> 4   7  4 7> 4   7  4 7	> 4   7  4 7
> 4   7  4 7> 4   7  4 7> 4  % > G  Unload Network...logWarnChatConnectFailChatDisconnectChatExceptionChatMessageChatConnectConnectFailDisconnectExceptionMessageConnectProtocalRemoveListener
Event� 	 0 Y4   % > 4   % > 4   % > 4   % > 5  4   % > 4   % > 4   % > 4  %	 >4  %
 >2  5 4 * ) 4 1 :4 1 :4 1 :4 1 :4 1 :4 1 :4 1 :4 1 :4 1 :4 1 :4 1! : 4 1# :"4 1% :$4 1' :&4 1) :(4 1+ :*4 1- :,4 1/ :.0  �G   Unload TestLoginSproto TestLoginPbc TestLoginPblua TestLoginBinary OnChatMessage OnChatDisconnect OnChatException ChatConnectFail OnChatConnect OnMessage OnDisconnect OnException OnConnectFail OnConnect Sendheart OnSocket 
StartNetwork3rd/sproto/print_rsproto.core3rd/sproto/sproto3rd/pbc/protobuf3rd/pblua/login_pb
EventeventsCommon/functionsCommon/protocalCommon/definerequire 