require"vos/APIS"
GaveUpRequest={}
--���캯��
function GaveUpRequest.New(data)
	local gaveUpRequest = ClientRequest.New();
	--setmetatable(gaveUpRequest, mt)
	gaveUpRequest.headCode = APIS.GAVEUP_REQUEST;
	--gaveUpRequest.messageContent='{'..data..'}'
	gaveUpRequest.messageContent=data
	log("lua:gaveUpRequest="..gaveUpRequest.messageContent)
	return gaveUpRequest
end