require"vos/APIS"
PutOutCardRequest={}
--���캯��
function PutOutCardRequest.New(data)
	local putOutCardRequest = ClientRequest.New();
	--setmetatable(putOutCardRequest, mt)
	putOutCardRequest.headCode = APIS.CHUPAI_REQUEST;
	--putOutCardRequest.messageContent='{'..data..'}'
	putOutCardRequest.messageContent=data
	log("lua:PutOutCardRequest="..putOutCardRequest.messageContent)
	return putOutCardRequest
end