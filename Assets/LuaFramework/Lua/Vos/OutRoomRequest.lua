require"vos/APIS"
OutRoomRequest={}
--���캯��
function OutRoomRequest.New(data)
	local outRoomRequest = ClientRequest.New();
	--setmetatable(outRoomRequest, mt)
	outRoomRequest.headCode = APIS.OUT_ROOM_REQUEST;
	--outRoomRequest.messageContent='{'..data..'}'
	outRoomRequest.messageContent=data
	log("lua:outRoomRequest="..outRoomRequest.messageContent)
	return outRoomRequest
end