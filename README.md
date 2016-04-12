# AdminESP
## Description   
A simple admin ESP for Garry's Mod. Allows your admins and superadmins to see players through walls.

## Installation
#### Via Git   
1. Navigate to your server's `garrysmod/addons` directory
2. Clone the addon by running the command `git clone https://github.com/CoreRP/AdminESP.git admin_esp`

#### Via file   
1. Click the "Download Zip" button at the top of the page
2. Extract the contents of the zip so files like `README.md` exist in the folder `<path to your server>/garrysmod/addons/admin_esp/`

## Usage   
All of the configuration is done client-side. Note that, in this addon's current state, installation allows access to any admin or superadmin on your server.

#### Console Commands

**NB:** These are all client-side. Setting these in your server.cfg will not do anything.

| Command               | Purpose                                                       | Default Value | Notes |
| --------------------- | ------------------------------------------------------------- | ------------- | :---: |
| aesp_getgamemode      | Prints the name of the current gamemode. For developers.      | n/a           |       |
| aesp_enabled          | Set to 1 to enable the ESP                                    | 0             |       |
| aesp_maxdistance      | Targets further away than this distance will not be rendered  | 16384         |       |
| aesp_offsety          | Sets the text offset up/down of each target                   | 50            |       |
| aesp_drawmodel        | Draws the target's model through walls                        | 0             |[**Δ**][1]|
| aesp_drawname         | Draws the target's name as text over the target               | 1             |       |
| aesp_drawsteamid      | Draws the target's Steam ID as text over the target           | 1             |       |
| aesp_drawping         | Draws the target's ping as text over the target               | 0             |       |
| aesp_drawhealth       | Draws the target's health as text over the target             | 0             |       |
| aesp_drawarmor        | Draws the target's armor as text over the target              | 0             |       |
| aesp_drawgroup        | Draws the target ULX/other group as text over the target      | 0             |       |
| aesp_darkrp_drawjob   | Draws the target's job as text over the target                | 0             |[**✝**][1]|
| aesp_darkrp_drawmoney | Draws target's money as text over the target                  | 0             |[**✝**][1]|
| aesp_ttt_drawrole     | Draws the target's role as text over the target               | 0             |[**♠**][1]|

##### Footnotes:   
**Δ:** Can be more resource-intensive. Disable this if you notice significant performance drops.   
**✝:** Only available when the server is set to the DarkRP gamemode.   
**♠:** Only available when the server is set to the Trouble in Terrorist Town gamemode.

## Suggestions and Planned features
Please feel free to submit bug reports and pull requests for more features! You can find a current list of the features in development [here][2].

## Credits
[SubjectAlpha][3]: Original creator of the script
[RalphORama][4]: AESP v2.0 update.

[1]: #footnotes
[2]: https://trello.com/b/kUerE74L/admin-esp
[3]: https://github.com/SubjectAlpha/
[4]: https://github.com/RalphORama/
