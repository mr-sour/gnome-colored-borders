gnome color border
======================

Gnome shell extension that adds a colored border


Eventually this extension will enable qubes os to draw window borders in gnome. 

This is undergoing a rework to switch to GTK CSS. drafting notes here to see the best approach to takle this.
#It starts by making a new provider 
```provider = gtk_css_provider_new ();
#and then loading in css text into that provider
gtk_css_provider_load_from_data (provider, text, -1);
#then I get into the unknowns. The priority and provider I have but the tricky question is about display because we want per window decoration not global
gtk_style_context_add_provider_for_display (display,GTK_STYLE_PROVIDER (provider),GTK_STYLE_PROVIDER_PRIORITY_USER);
#heres the display object being passed to the function above. There is the a function to get the default display but this doesn't answer the question of per window decorations this should decorate everything and anything.
gdk_display_get_default()
```

  
https://developer.gnome.org/gtk4/stable/GtkStyleContext.html#gtk-style-context-add-provider-for-display




Notes about settings titlebar gtk theme. It possible to get the xid of the window and automate this so maybe make a theme for each color and then set it?
`xprop  -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT dark`

works in wayland and seems to apply to everything that has a titlebar. For apps without a titlebar it falls apart I can force decorations with the commands below but they render very oddly.

To remove decorations:
`xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x0, 0x0, 0x0"`

To add decorations:
`xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x1, 0x0, 0x0"`
