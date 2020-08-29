


namespace Border {

  const uint SCAN_INTERVAL = 100;

  // Method signature adapted from https://github.com/gnome-globalmenu/gnome-globalmenu
  [CCode(cname="gtk_module_init")]
  void gtk_module_init([CCode(array_length_pos=0.9)] ref unowned string[] argv) {
    Gtk.init(ref argv);


      Gtk.Window[] windows = {};
      //css_provider.load_from_path ("style.css");
      Gtk.CssProvider css_provider = new Gtk.CssProvider ();
      //Took this from Plotinus need to figure out if this needs to run in a loop like this
      //until then maybe don use new anywhere :D
      Timeout.add(SCAN_INTERVAL, () => {
      var application = Application.get_default() as Gtk.Application;
      if (application != null) {

      }

      Gtk.Window.list_toplevels().foreach((window) => {
      //!(window is PopupWindow) && 
      if (window != null){
        window.resize(100,100);
        css_provider.load_from_data("decoration { border: 4px solid red; background: gray; }");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

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
