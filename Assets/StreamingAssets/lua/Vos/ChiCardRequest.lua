require"vos/APIS"
ChiCardRequest={}
--���캯��
function ChiCardRequest.New(data)
	local chiCardRequest = ClientRequest.New();
	--setmetatable(chiCardRequest, mt)
	chiCardRequest.headCode = APIS.CHIPAI_REQUEST;
	--chiCardRequest.messageContent='{'..data..'}'
	chiCardRequest.messageContent=data
	log(chiCardRequest.messageContent)
	return chiCardRequest
end