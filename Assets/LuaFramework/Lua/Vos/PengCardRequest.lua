require"vos/APIS"
PengCardRequest={}
--���캯��
function PengCardRequest.New(data)
	local pengCardRequest = ClientRequest.New();
	--setmetatable(pengCardRequest, mt)
	pengCardRequest.headCode = APIS.PENGPAI_REQUEST;
	--pengCardRequest.messageContent='{'..data..'}'
	pengCardRequest.messageContent=data
	log("lua:pengCardRequest="..pengCardRequest.messageContent)
	return pengCardRequest
end
