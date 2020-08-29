gnome color border
======================

Gnome shell extension that adds a colored border


Eventually this extension will enable qubes os to draw window borders in gnome. 

This is undergoing a rework to switch to GTK CSS. drafting notes here to see the best approach to takle this.
```
#It starts by making a new provider 
provider = gtk_css_provider_new ();
#and then loading in css text into that provider
gtk_css_provider_load_from_data (provider, text, -1);
#then I get into the unknowns. The priority and provider I have but the tricky question is about display because we want per window decoration not global
gtk_style_context_add_provider_for_display (display,GTK_STYLE_PROVIDER (provider),GTK_STYLE_PROVIDER_PRIORITY_USER);
#heres the display object being passed to the function above. There is the a function to get the default display but this doesn't answer the question of per window decorations this should decorate everything and anything.
gdk_display_get_default()
```
  
https://developer.gnome.org/gtk4/stable/GtkStyleContext.html#gtk-style-context-add-provider-for-display
I think theres some kind of GObject editing going on. When the gtk inscpector is invoked I belive it passes though the GObject representing the window which it then uses the code above to attach styles to which are context bound to the window. What I need to discover is what is that object and how to I iterate though them. From there is a simple matter of attaching my css provder object to it or otherwise invoking it with the proper context to update the providers for that window.

when the inscector is launched i think it has a preloaded GTK_MODULES that contains the rest of code. I think this might be worth investigating as GTK_MODULES are apparently used to make theme engines which is pretty much what im doing.

A last resort option. GTK supports theme variants which can easilly be set though XPROP I could make variants of everything then its just a matter of 
running though each window and setting the theme varriant which can be done in qubes-GUID but I'm going to investigate this after adding the provider. 



Notes about settings titlebar gtk theme. It possible to get the xid of the window and automate this so maybe make a theme for each color and then set it?
`xprop  -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT dark`

works in wayland and seems to apply to everything that has a titlebar. For apps without a titlebar it falls apart I can force decorations with the commands below but they render very oddly.

To remove decorations:
`xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x0, 0x0, 0x0"`

To add decorations:
`xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x1, 0x0, 0x0"`
