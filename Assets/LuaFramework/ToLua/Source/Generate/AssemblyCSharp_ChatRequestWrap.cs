﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class AssemblyCSharp_ChatRequestWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(AssemblyCSharp.ChatRequest), typeof(System.Object));
		L.RegFunction("WriterInt", WriterInt);
		L.RegFunction("WriteShort", WriteShort);
		L.RegFunction("ToBytes", ToBytes);
		L.RegFunction("New", _CreateAssemblyCSharp_ChatRequest);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("headCode", get_headCode, set_headCode);
		L.RegVar("ChatSound", get_ChatSound, set_ChatSound);
		L.RegVar("totelLenght", get_totelLenght, set_totelLenght);
		L.RegVar("userList", get_userList, set_userList);
		L.RegVar("myUUid", get_myUUid, set_myUUid);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateAssemblyCSharp_ChatRequest(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				AssemblyCSharp.ChatRequest obj = new AssemblyCSharp.ChatRequest();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: AssemblyCSharp.ChatRequest.New");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriterInt(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)ToLua.CheckObject(L, 1, typeof(AssemblyCSharp.ChatRequest));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			byte[] o = obj.WriterInt(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteShort(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)ToLua.CheckObject(L, 1, typeof(AssemblyCSharp.ChatRequest));
			short arg0 = (short)LuaDLL.luaL_checknumber(L, 2);
			byte[] o = obj.WriteShort(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToBytes(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)ToLua.CheckObject(L, 1, typeof(AssemblyCSharp.ChatRequest));
			byte[] o = obj.ToBytes();
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_headCode(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)o;
			int ret = obj.headCode;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index headCode on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ChatSound(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)o;
			byte[] ret = obj.ChatSound;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index ChatSound on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_totelLenght(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)o;
			int ret = obj.totelLenght;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index totelLenght on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_userList(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)o;
			System.Collections.Generic.List<int> ret = obj.userList;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index userList on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_myUUid(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)o;
			int ret = obj.myUUid;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index myUUid on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_headCode(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.headCode = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index headCode on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ChatSound(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)o;
			byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
			obj.ChatSound = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index ChatSound on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_totelLenght(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.totelLenght = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index totelLenght on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_userList(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)o;
			System.Collections.Generic.List<int> arg0 = (System.Collections.Generic.List<int>)ToLua.CheckObject(L, 2, typeof(System.Collections.Generic.List<int>));
			obj.userList = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index userList on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_myUUid(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ChatRequest obj = (AssemblyCSharp.ChatRequest)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.myUUid = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index myUUid on a nil value" : e.Message);
		}
	}
}
