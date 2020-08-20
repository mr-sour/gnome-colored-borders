gnome color border
======================

Gnome shell extension that adds a colored border


Eventually this extension will enable qubes os to draw window borders in gnome. 

Right now there is just RedBorderEffect the plan is turn this into ColorBorderEffect and have it set the color when it goes to render.


Notes about settings titlebar gtk theme. It possible to get the xid of the window and automate this so maybe make a theme for each color and then set it?
xprop  -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT dark
