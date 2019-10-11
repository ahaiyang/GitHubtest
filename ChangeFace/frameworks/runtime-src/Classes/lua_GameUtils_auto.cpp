#include "lua_GameUtils_auto.hpp"
#include "GameUtils.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"


int lua_GameUtils_GameUtils_alphaTouchCheck(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"GameUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        cocos2d::Sprite* arg0;
        cocos2d::Point arg1;
        ok &= luaval_to_object<cocos2d::Sprite>(tolua_S, 2, "cc.Sprite",&arg0, "GameUtils:alphaTouchCheck");
        ok &= luaval_to_point(tolua_S, 3, &arg1, "GameUtils:alphaTouchCheck");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_GameUtils_GameUtils_alphaTouchCheck'", nullptr);
            return 0;
        }
        bool ret = GameUtils::alphaTouchCheck(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "GameUtils:alphaTouchCheck",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_GameUtils_GameUtils_alphaTouchCheck'.",&tolua_err);
#endif
    return 0;
}
int lua_GameUtils_GameUtils_setEnableLocationPush(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"GameUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        bool arg0;
        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "GameUtils:setEnableLocationPush");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_GameUtils_GameUtils_setEnableLocationPush'", nullptr);
            return 0;
        }
        GameUtils::setEnableLocationPush(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "GameUtils:setEnableLocationPush",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_GameUtils_GameUtils_setEnableLocationPush'.",&tolua_err);
#endif
    return 0;
}
int lua_GameUtils_GameUtils_getUserPowerRebackTime(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"GameUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_GameUtils_GameUtils_getUserPowerRebackTime'", nullptr);
            return 0;
        }
        int ret = GameUtils::getUserPowerRebackTime();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "GameUtils:getUserPowerRebackTime",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_GameUtils_GameUtils_getUserPowerRebackTime'.",&tolua_err);
#endif
    return 0;
}
int lua_GameUtils_GameUtils_createImageFromSprite(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"GameUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        cocos2d::Sprite* arg0;
        ok &= luaval_to_object<cocos2d::Sprite>(tolua_S, 2, "cc.Sprite",&arg0, "GameUtils:createImageFromSprite");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_GameUtils_GameUtils_createImageFromSprite'", nullptr);
            return 0;
        }
        cocos2d::Image* ret = GameUtils::createImageFromSprite(arg0);
        object_to_luaval<cocos2d::Image>(tolua_S, "cc.Image",(cocos2d::Image*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "GameUtils:createImageFromSprite",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_GameUtils_GameUtils_createImageFromSprite'.",&tolua_err);
#endif
    return 0;
}
int lua_GameUtils_GameUtils_setUserPowerRebackTime(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"GameUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "GameUtils:setUserPowerRebackTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_GameUtils_GameUtils_setUserPowerRebackTime'", nullptr);
            return 0;
        }
        GameUtils::setUserPowerRebackTime(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "GameUtils:setUserPowerRebackTime",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_GameUtils_GameUtils_setUserPowerRebackTime'.",&tolua_err);
#endif
    return 0;
}
int lua_GameUtils_GameUtils_getEnableLocationPush(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"GameUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_GameUtils_GameUtils_getEnableLocationPush'", nullptr);
            return 0;
        }
        bool ret = GameUtils::getEnableLocationPush();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "GameUtils:getEnableLocationPush",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_GameUtils_GameUtils_getEnableLocationPush'.",&tolua_err);
#endif
    return 0;
}
int lua_GameUtils_GameUtils_setUserPVPRebackTime(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"GameUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "GameUtils:setUserPVPRebackTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_GameUtils_GameUtils_setUserPVPRebackTime'", nullptr);
            return 0;
        }
        GameUtils::setUserPVPRebackTime(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "GameUtils:setUserPVPRebackTime",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_GameUtils_GameUtils_setUserPVPRebackTime'.",&tolua_err);
#endif
    return 0;
}
int lua_GameUtils_GameUtils_getUserPVPRebackTime(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"GameUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_GameUtils_GameUtils_getUserPVPRebackTime'", nullptr);
            return 0;
        }
        int ret = GameUtils::getUserPVPRebackTime();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "GameUtils:getUserPVPRebackTime",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_GameUtils_GameUtils_getUserPVPRebackTime'.",&tolua_err);
#endif
    return 0;
}
static int lua_GameUtils_GameUtils_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (GameUtils)");
    return 0;
}

int lua_register_GameUtils_GameUtils(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"GameUtils");
    tolua_cclass(tolua_S,"GameUtils","GameUtils","",nullptr);

    tolua_beginmodule(tolua_S,"GameUtils");
        tolua_function(tolua_S,"alphaTouchCheck", lua_GameUtils_GameUtils_alphaTouchCheck);
        tolua_function(tolua_S,"setEnableLocationPush", lua_GameUtils_GameUtils_setEnableLocationPush);
        tolua_function(tolua_S,"getUserPowerRebackTime", lua_GameUtils_GameUtils_getUserPowerRebackTime);
        tolua_function(tolua_S,"createImageFromSprite", lua_GameUtils_GameUtils_createImageFromSprite);
        tolua_function(tolua_S,"setUserPowerRebackTime", lua_GameUtils_GameUtils_setUserPowerRebackTime);
        tolua_function(tolua_S,"getEnableLocationPush", lua_GameUtils_GameUtils_getEnableLocationPush);
        tolua_function(tolua_S,"setUserPVPRebackTime", lua_GameUtils_GameUtils_setUserPVPRebackTime);
        tolua_function(tolua_S,"getUserPVPRebackTime", lua_GameUtils_GameUtils_getUserPVPRebackTime);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(GameUtils).name();
    g_luaType[typeName] = "GameUtils";
    g_typeCast["GameUtils"] = "GameUtils";
    return 1;
}
TOLUA_API int register_all_GameUtils(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_GameUtils_GameUtils(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

