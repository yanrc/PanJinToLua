require"vos/APIS"
HupaiRequest={}
--���캯��
function HupaiRequest.New(data)
	local hupaiRequest = ClientRequest.New();
	--setmetatable(hupaiRequest, mt)
	hupaiRequest.headCode = APIS.HUPAI_REQUEST;
	--hupaiRequest.messageContent='{'..data..'}'
	hupaiRequest.messageContent=data
	log("lua:hupaiRequest="..hupaiRequest.messageContent)
	return hupaiRequest
end