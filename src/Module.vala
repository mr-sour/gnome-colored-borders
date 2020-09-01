


namespace Border {

  const uint SCAN_INTERVAL = 1000;

  // Method signature adapted from https://github.com/gnome-globalmenu/gnome-globalmenu
  [CCode(cname="gtk_module_init")]
  void gtk_module_init([CCode(array_length_pos=0.9)] ref unowned string[] argv) {
    Gtk.init(ref argv);


      Gtk.Window[] windows = {};
      //css_provider.load_from_path ("style.css");
      Gtk.CssProvider css_provider = new Gtk.CssProvider ();
      //Took this from Plotinus need to figure out if this needs to run in a loop like this
      //until then maybe don use new anywhere :D
  		// css_provider.load_from_data("decoration { border: 3px solid blue; background: gray; } .titlebar { background: blue ; color:white; } .titlebar:backdrop  {background: #777777; color:white;} window.ssd headerbar.titlebar { border: 5px; box-shadow: none; background-image: linear-gradient(to bottom, shade(green, 1.05), shade(@theme_bg_color, 1.00)); }");
        // Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider, uint.MAX);
      Timeout.add(SCAN_INTERVAL, () => {
      var application = Application.get_default() as Gtk.Application;
      if (application != null) {

      }
      
      //Gtk.StyleContext.remove_provider_for_screen (Gdk.Screen.get_default (), css_provider);
      Gtk.Window.list_toplevels().foreach((window) => {

      if (window != null){
        if(window.has_toplevel_focus){
        	//titlebar doesn't seem todo the trick but window.ssd does
          Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider, uint.MAX);          
          css_provider.load_from_data("
          	decoration { border: 3px solid blue; background: gray; } 
          	.titlebar { background: blue ; color:white; } 
          	.titlebar:backdrop  {background: #777777; color:white;} 
          	window.ssd headerbar.titlebar { border: 5px; box-shadow: none;
          	background-image: linear-gradient(to bottom, shade(green, 1.05), 
          	shade(@theme_bg_color, 1.00)); }");
          
        }else{

        }
        Gtk.Widget winwig = ((Gtk.Widget)window);
        //Gdk.Window gdk_window =  Gdk.Window.get_toplevel();

        //check to make sure its real
        if(winwig.get_window()!=null){
        Gdk.X11.Window gdk_window =  ((Gdk.X11.Window)winwig.get_window());
        //uint xid = (uint*)Gdk.X11Window.get_xid(gdk_window);
        string objpath = get_gdk_window_property(gdk_window,"_GTK_APPLICATION_OBJECT_PATH");
        gdk_window.set_theme_variant("SEEMEEEE");
        X.Window xid = gdk_window.get_xid(); 
        uint xidint = (uint)xid;
        //Hey got the xid without a segfault :party:
        print(objpath);
        //print(xidint.to_string());
       }


        //TODO
        //https://valadoc.org/gdk-x11-3.0/Gdk.X11Window.get_xid.html ^
        //https://tronche.com/gui/x/xlib/window-information/XGetWindowProperty.html
        //https://valadoc.org/x11/X.Display.get_window_property.html
        //get the xid of the window use the xid to get props 
        //use the props to set the css provider data.

      }
      if (window.type == Gtk.WindowType.TOPLEVEL && window.is_visible())
        windows += window;
      });


      return true;

      });
      

/*
            foreach (var window in windows) {
          //window.add_events(Gdk.EventMask.KEY_PRESS_MASK);
          //GLib.g_print(get_window_title(window));
        }
*/


      /*if (application != null) {
        var application_name = "Application";

        // Try to determine the actual name of the application
        if (application.application_id != null) {
          var id_parts = application.application_id.split(".");
          application_name = id_parts[id_parts.length - 1];

          // In many cases, the AppInfo ID follows this convention
          var app_info_id = (application.application_id + ".desktop").casefold();
          AppInfo.get_all().foreach((app_info) => {
            if (app_info.get_id().casefold() == app_info_id)
              application_name = app_info.get_name();
          });
        }

        keybinder = new ApplicationKeybinder(application);
        command_extractor = new CommandExtractor.with_application(application, application_name);

      } else if (Gtk.Window.list_toplevels().length() > 0) {
        // There is no Gtk.Application yet but there are already Gtk.Windows.
        // Since creating an Application is almost always the first thing a program does,
        // this means that the program probably does not use Gtk.Application at all.
        keybinder = new WindowKeybinder();
        command_extractor = new CommandExtractor();
      }

      */
  }


public string? get_gdk_window_property(Gdk.Window? window, string property) {
    Gdk.X11.Window win;
    if (window != null) {
        win = window as Gdk.X11.Window;
    } else {
        win = Gdk.get_default_root_window() as Gdk.X11.Window;
    }
    var display = win.get_display() as Gdk.X11.Display;

    X.Atom type;
    int format;
    ulong n_items;
    ulong bytes_after;
    void* data;
    string? name = null;

    display.error_trap_push();
    display.get_xdisplay().get_window_property(
        win.get_xid(), Gdk.X11.get_xatom_by_name_for_display(display, property), 0, long.MAX, false,
        Gdk.X11.get_xatom_by_name_for_display(display, "UTF8_STRING"),
        out type, out format, out n_items, out bytes_after, out data);
    display.error_trap_pop_ignored();

    if (data != null) {
        name = (string) data;
        X.free(data);
    }
    return name;
}


/*
  string? get_window_title(Gtk.Window window) {
    var titlebar = window.get_titlebar();
    if (titlebar == null)
      return window.title;

    Gtk.HeaderBar header_bar = titlebar as Gtk.HeaderBar;
    if (header_bar == null && titlebar is Gtk.Container)
      // Some applications nest the header bar inside another widget, such as a Gtk.Paned
      header_bar = find_widget(titlebar as Gtk.Container, typeof(Gtk.HeaderBar)) as Gtk.HeaderBar;

    if (header_bar != null && header_bar.custom_title == null && header_bar.title != null)
      return header_bar.title;

    return window.title;
  }

  Gtk.Widget? find_widget(Gtk.Container container, Type widget_type) {
    var widgets = container.get_children();

    for (var i = 0; i < widgets.length(); i++) {
      var widget = widgets.nth_data(i);

      if (!widget.get_visible())
        continue;

      if (widget.get_type().is_a(widget_type)) {
        return widget;
      } else if (widget is Gtk.Container) {
        var inner_widget = find_widget(widget as Gtk.Container, widget_type);
        if (inner_widget != null)
          return inner_widget;
      }
    }

    return null;
  }
  */
}
