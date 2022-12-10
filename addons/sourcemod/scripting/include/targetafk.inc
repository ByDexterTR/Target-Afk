#if defined _targetafk_included
 #endinput
#endif
#define _targetafk_included

/**
 * Returns whether or not a client is afk
 *
 * @param client        Client index.
 * @return              True if client is afk, false otherwise.
 */
native bool IsClientAfk(int client);

public SharedPlugin __pl_targetafk = 
{
	name = "targetafk",
	file = "targetafk.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_targetafk_SetNTVOptional()
{
	MarkNativeAsOptional("IsClientAfk");
}
#endif
