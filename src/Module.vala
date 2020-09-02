


namespace Border {

  const uint REFRESH_INTERVAL = 1000;

  // Method signature adapted from https://github.com/gnome-globalmenu/gnome-globalmenu
  [CCode(cname="gtk_module_init")]
  void gtk_module_init([CCode(array_length_pos=0.9)] ref unowned string[] argv) {
    Gtk.init(ref argv);


      Gtk.Window[] windows = {};
      //css_provider.load_from_path ("style.css");
      Gtk.CssProvider css_provider = new Gtk.CssProvider ();

      Timeout.add(REFRESH_INTERVAL, () => {
      var application = Application.get_default() as Gtk.Application;
      if (application != null) {

      }
      
      //Gtk.StyleContext.remove_provider_for_screen (Gdk.Screen.get_default (), css_provider);
      Gtk.Window.list_toplevels().foreach((window) => {

      if (window != null){

        Gtk.Widget winwig = ((Gtk.Widget)window);

        //check to make sure its real
        if(winwig.get_window()!=null){
        Gdk.X11.Window gdk_window =  ((Gdk.X11.Window)winwig.get_window());
        string objpath = get_gdk_window_property  (gdk_window,"_GTK_APPLICATION_OBJECT_PATH");
        //gdk_window.set_theme_variant("SEEMEEEE");

        //X.Window xid = gdk_window.get_xid(); 
        //uint xidint = (uint)xid;

        //gotta switch over to qubes to finish the color theming should be able to take the 
        //color property and pass it right into this CSS

        //what a colorcode looks like from win prop
        int colornum = 15586304;
        //format to hex
        string color = "%X\n".printf(colornum);
        //debug
        //print(color);
        	//titlebar doesn't seem todo the trick but window.ssd does
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider, uint.MAX);          
        css_provider.load_from_data(@"
          	decoration { border: 3px solid #$color; background: gray; } 
          	.titlebar { background: blue ; color:white; } 
          	.titlebar:backdrop  {background: #777777; color:white;} 
          	window.ssd headerbar.titlebar { border: 5px; box-shadow: none;
          	background-image: linear-gradient(to bottom, shade(green, 1.05), 
          	shade(@theme_bg_color, 1.00)); }");
          
       }


        //TODO
        //use the props to set the css provider data.


      }

      });
      return true;

      });
      

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


}
