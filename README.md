gnome color border
======================

Gnome shell extension that adds a colored border


Eventually this extension will enable qubes os to draw window borders in gnome. 

This is undergoing a rework to switch to GTK CSS. drafting notes here to see the best approach.

  
https://developer.gnome.org/gtk4/stable/GtkStyleContext.html#gtk-style-context-add-provider-for-display


https://github.com/p-e-w/plotinus/blob/master/src/Module.vala

export GTK_MODULES=$GTK_MODULES:<path/to/module.so>

it looks like I might need to switch to vala. Its certainly possible to interact with these GObjects in C but its becoming painful and vala seems todo what I need. I can use the method signature from gnome-globalmenu and that should allow me to create the module in vala. Hopfully then my lists return usful gtkwindow objects which I need in order to apply per window style providers
https://valadoc.org/gtk+-3.0/Gtk.Window.list_toplevels.html



A last resort option. GTK supports theme variants which can easilly be set though XPROP I could make variants of everything then its just a matter of 
running though each window and setting the theme varriant which can be done in qubes-GUID but I'm going to investigate this after adding the provider. 



Notes about settings titlebar gtk theme. It possible to get the xid of the window and automate this so maybe make a theme for each color and then set it?
`xprop  -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT dark`

works in wayland and seems to apply to everything that has a titlebar. For apps without a titlebar it falls apart I can force decorations with the commands below but they render very oddly.

To remove decorations:
`xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x0, 0x0, 0x0"`

To add decorations:
`xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x1, 0x0, 0x0"`
