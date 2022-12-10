#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Target @afk | @!afk", 
	author = "ByDexter", 
	description = "", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

int lastbutton[65] = { 0, ... };
int gametime[65] = { 0, ... };

public void OnPluginStart()
{
	AddCommandListener(Checkafkcommand);
	AddMultiTargetFilter("@afk", Afkplayer, "Afk olan", false);
	AddMultiTargetFilter("@!afk", Noafkplayer, "Afk olmayan", false);
	
	for (int i = 1; i <= MaxClients; i++)if (IsValidClient(i))
	{
		OnClientPostAdminCheck(i);
	}
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("IsClientAfk", Native_IsClientAfk);
	RegPluginLibrary("jb_targetafk");
	
	return APLRes_Success;
}

public int Native_IsClientAfk(Handle hPlugin, int numParams)
{
	int client = GetNativeCell(1);
	if (client < 1 || client > MaxClients)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}
	
	if (!IsClientInGame(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Client %d is not in game", client);
	}
	
	bool HeAfk = false;
	if (IsValidClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2 && gametime[client] + 5 <= GetTime())
	{
		HeAfk = true;
	}
	
	return HeAfk;
}

public void OnClientPostAdminCheck(int client)
{
	gametime[client] = GetTime() + 2;
}

public Action Checkafkcommand(int client, const char[] command, int argc)
{
	if (IsValidClient(client))
	{
		gametime[client] = GetTime() + 15;
	}
}

public Action OnPlayerRunCmd(int client, int & buttons)
{
	if (IsValidClient(client) && lastbutton[client] != buttons)
	{
		lastbutton[client] = buttons;
		gametime[client] = GetTime() + 10;
	}
}

bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
}

public bool Afkplayer(const char[] pattern, Handle clients)
{
	for (int i = 1; i <= MaxClients; i++)if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2 && gametime[i] + 5 <= GetTime())
	{
		PushArrayCell(clients, i);
	}
	return true;
}

public bool Noafkplayer(const char[] pattern, Handle clients)
{
	for (int i = 1; i <= MaxClients; i++)if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2 && gametime[i] + 5 > GetTime())
	{
		PushArrayCell(clients, i);
	}
	return true;
} 