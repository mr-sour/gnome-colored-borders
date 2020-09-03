

[CCode (cheader_filename = "gdk/gdkx.h")]
private static extern X.ID gdk_x11_window_get_xid (Gdk.Window window);
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
	//aparently either this is failing or get_window is failing
        Gtk.Widget winwig = ((Gtk.Widget) window);
	//X.ID drawable = gdk_x11_window_get_xid ((Gdk.X11.Window)winwig.get_window());
        //check to make sure its real
        string title = get_window_title(window);
        if(((Gdk.X11.Window)winwig.get_window())!=null){

        Gdk.X11.Window gdk_window =  ((Gdk.X11.Window)winwig.get_window());
         //Gdk.X11.Window gdk_window= (Gdk.X11.Window) .get_root_window () ;
         
        Gdk.Screen.get_default().get_toplevel_windows().foreach((dwindow) => {
        //unlike gtk.window toplevels this seems to be listing theparent window xid I'm after
        Gdk.X11.Window gdwindow = (Gdk.X11.Window)dwindow;
        uint xidint = (uint)gdwindow.get_xid();
        //print();
	//https://valadoc.org/x11/X.Display.query_tree.html I think after my inital list I need to go into the children to get another set of xid's to look for the property on
        string xstring = "%X\n".printf(int.parse(xidint.to_string()));
        //janky logging not sure where else to put it after its loaded globally
        Process.spawn_command_line_sync (@"touch /home/test/Documents/$xstring");
        });
        
        
        string domaincolor = get_window_property_as_utf8  (gdk_window,"WM_NAME");
        //0x2e001d9
        //print(domaincolor+"\n");
        
        if (gdk_window != null){ 
        	print("window is not lollypop");
        	domaincolor = "8421504";
        }else
        {	//print("window is lollypop");
        	domaincolor = "15586304";
        }
        //print(domaincolor);
        //print(domaincolor);


        
        
        
       

        
	//print((string)xidint);
        //gotta switch over to qubes to finish the color theming should be able to take the 
        //color property and pass it right into this CSS

        //what a colorcode looks like from win prop 8421504
        //int colornum = 15586304;
        //format to hex
        
        string wincolor = "%X\n".printf(int.parse(domaincolor));
        //debug
        //print(color);
        	//titlebar doesn't seem todo the trick but window.ssd does
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider, uint.MAX);          
        css_provider.load_from_data(@"
          	decoration { border: 3px solid #$wincolor; background: gray; } 
          	.titlebar { background: #$wincolor ; color:white; } 
          	.titlebar:backdrop  {background: #$wincolor; color:white;} 
          	window.ssd headerbar.titlebar { border: 5px; box-shadow: none;
          	background-image: linear-gradient(to bottom, shade(#$wincolor, 1.05), 
          	shade(#$wincolor, 1.00)); }");
          
       }


        //TODO
        //use the props to set the css provider data.


      }

      });
      return true;

      });
      

  }


public string? get_window_property_as_utf8(Gdk.Window? window, string property) {
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
       X.XA_STRING,
        out type, out format, out n_items, out bytes_after, out data);
    display.error_trap_pop_ignored();

    if (data != null) {
        name = (string) data;
        X.free(data);
    }
    return name;
}
public string? get_gdk_window_propertyy(Gdk.Window? window, string property) {
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
        X.XA_CARDINAL,
        out type, out format, out n_items, out bytes_after, out data);
    display.error_trap_pop_ignored();

    if (data != null) {
    	int dataprop = * (int *) data;
        name = "%u".printf(dataprop);;
        X.free(data);
    }
    return name;
}

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
}
