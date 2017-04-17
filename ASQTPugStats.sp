#include <cstrike>
#include <sdktools>
#include <sourcemod>

ArrayList g_adtArray;
String:g_playerInfo[128];

public Plugin myinfo = {
	name = "ASQT Pug Stats",
	author = "Warlord",
	description = "Created for use with Argo Server Query Tool. Sets cmd's to retrieve the pug score, player lists for each team plus player K/D, or a specific clients IP address.",
	version = "1.3",
	url = "http://www.sourcemod.net/"
};

public OnPluginStart() {
	LoadTranslations("common.phrases");

	RegConsoleCmd("getpugscore", Teams_GetScore);
	RegAdminCmd("getplayers", Teams_GetPlayers, ADMFLAG_RCON);
	RegAdminCmd("getplayerip", Client_GetPlayerIp, ADMFLAG_RCON, "getplayerip <#userid|name>");
}

public void OnMapEnd() {
	CloseHandle(g_adtArray);
}


public Action:Client_GetPlayerIp(client, args) {
	if (args < 1) {
		ReplyToCommand(client, "[ASQTPugStats] Usage: getplayerip <#userid|name>");
		return Plugin_Handled;
	}

	decl String:arg[65];
	GetCmdArg(1, arg, sizeof(arg));

	decl String:player_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;

	if ((target_count = ProcessTargetString(
						arg,
						client,
						target_list,
						MAXPLAYERS,
						COMMAND_FILTER_CONNECTED,
						player_name,
						sizeof(player_name),
						tn_is_ml)) <= 0) {
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	char ipaddr[24];
	for (new i=0; i<target_count; i++) {
		GetClientIP(target_list[i], ipaddr, sizeof(ipaddr));
	}

	ReplyToCommand(client, "[ASQTPugStats] IP address of %s: %s", player_name, ipaddr);
	return Plugin_Handled;
}


public Action:Teams_GetPlayers(client, args) {
	if (args < 1) {

		g_adtArray = CreateArray(MaxClients);
		new team_index;
		new frags;
		new deaths;
		char name[30];

		for (new i=1; i<=MaxClients; i++) {
			if (IsClientInGame(i)) {
				GetClientName(i, name, sizeof(name));
				team_index = GetClientTeam(i);
				frags = GetClientFrags(i);
				deaths = GetClientDeaths(i);

				switch (team_index) {
					case 2: {
						Format(g_playerInfo, sizeof(g_playerInfo), "%s:T:%d:%d", name, frags, deaths);
						PushArrayString(g_adtArray, g_playerInfo);
					}
					case 3: {
						Format(g_playerInfo, sizeof(g_playerInfo), "%s:CT:%d:%d", name, frags, deaths);
						PushArrayString(g_adtArray, g_playerInfo);
					}
				}
			}
		}
		new String:buffer[MaxClients];

		for(new x=0; x<GetArraySize(g_adtArray); x++) {
			GetArrayString(g_adtArray, x, buffer, MaxClients);
			ReplyToCommand(client, "%s", buffer);
		}

		CloseHandle(g_adtArray);
		return Plugin_Handled;
	}

	ReplyToCommand(client, "[ASQTPugStats] Usage: getplayers (takes no arguments)");
	return Plugin_Handled;
}


public Action:Teams_GetScore(client, args) {
	if (args < 1) {
		new tscore = CS_GetTeamScore(CS_TEAM_T);
		new ctscore = CS_GetTeamScore(CS_TEAM_CT);

		ReplyToCommand(client, "T's = %d, CT's = %d", tscore, ctscore);
		return Plugin_Handled;
	}
	
	ReplyToCommand(client, "[ASQTPugStats] Usage: getpugscore (takes no arguments)");
	return Plugin_Handled;
}
