[![forthebadge](http://forthebadge.com/images/badges/fuck-it-ship-it.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/no-ragrets.svg)](http://forthebadge.com) 

# ASQT Pug Stats

Created for use with [Argo Server Query Tool](https://github.com/ericwoolard/Argo-Server-Query-Tool). ASQT was written for the r/globaloffensive subreddit modteam, to assist us in our community night 10-mans each Tuesday. 
This plugin creates 3 commands for retrieving the pug score, players grouped by team (with K/D), and a clients IP address.

------------

### Installation

To install, simply place the SMX file in your `addons/sourcemod/plugins` directory and restart your server or refresh your plugins with `sm plugins refresh`. 

### Commands

* `getplayers` - returns a list of all players in the server along with which team they're on and how many kills/deaths they have. E.g. "Warlord:CT:15:10"
* `getplayerip <#userid|name>` - returns the IP address of a specific player.
* `getpugscore` - returns the current score in the format: "T's = 8, CT's = 5".


## License

* [GNU GPLv3](https://gitlab.com/rGlobalOffensive/Argo-Server-Query-Tool/blob/6aef726fc6134cb50a2cb9a768ef439c2e7a56e3/LICENSE)