gnome color border
======================

Gnome shell extension that adds a colored border


Eventually this extension will enable qubes os to draw window borders in gnome. 

Right now there is just RedBorderEffect the plan is turn this into ColorBorderEffect and have it set the color when it goes to render.


Notes about settings titlebar gtk theme. It possible to get the xid of the window and automate this so maybe make a theme for each color and then set it?
`xprop  -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT dark`

works in wayland and seems to apply to everything that has a titlebar. For apps without a titlebar it falls apart I can force decorations with the commands below but they render very oddly.

To remove decorations:
xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x0, 0x0, 0x0"

To add decorations:
xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x1, 0x0, 0x0"
