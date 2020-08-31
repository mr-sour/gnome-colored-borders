gnome color border
======================

Gnome shell extension that adds a colored border


Eventually this extension will enable qubes os to draw window borders in gnome. 

This is undergoing a rework to switch to GTK CSS. drafting notes here to see the best approach.

  
https://developer.gnome.org/gtk4/stable/GtkStyleContext.html#gtk-style-context-add-provider-for-display


https://github.com/p-e-w/plotinus/blob/master/src/Module.vala

launch apps in terminal
export GTK_MODULES=$GTK_MODULES:<path/to/module.so>

To install add it to `/ect/environment`


```
sudo dnf install git cmake vala gtk3-devel
```

```
mkdir build
cd build
cmake ..
make
sudo make install
```

Other gnomey stuff to look into
I think its going to be nessisary to ship a applet extension so users can mount drives use wifi ect...

https://github.com/ubuntu/gnome-shell-extension-appindicator

A nice looking wifi applet from elementry OS called nm-applet integrates very cleanly.
I assume other things from elementry will also look if needed. The other option is to create an extension that loads that stuff into the native gnome menu but thats gonna suck expecially when it comes to drawing borders and showing VM seperation.
nm-applet




I dont think this bit below is going to be needed I got the provders loading correctly as far as I can tell so things would have to go really south for this to be needed.
A last resort option. GTK supports theme variants which can easilly be set though XPROP I could make variants of everything then its just a matter of 
running though each window and setting the theme varriant which can be done in qubes-GUID but I'm going to investigate this after adding the provider. 



Notes about settings titlebar gtk theme. It possible to get the xid of the window and automate this so maybe make a theme for each color and then set it?
`xprop  -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT dark`

works in wayland and seems to apply to everything that has a titlebar. For apps without a titlebar it falls apart I can force decorations with the commands below but they render very oddly.

To remove decorations:
`xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x0, 0x0, 0x0"`

To add decorations:
`xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x1, 0x0, 0x0"`
