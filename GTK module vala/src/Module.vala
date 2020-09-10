

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
        //string title = get_window_title(window);
        if(((Gdk.X11.Window)winwig.get_window())!=null){

        Gdk.X11.Window gdk_window =  ((Gdk.X11.Window)winwig.get_window());
         //Gdk.X11.Window gdk_window= (Gdk.X11.Window) .get_root_window () ;
         
        Gdk.Screen.get_default().get_toplevel_windows().foreach((dwindow) => {
        //unlike gtk.window toplevels this seems to be listing theparent window xid I'm after
        //it looks like Screen.get_default scopes it a window so this isn't iterating globally
        Gdk.X11.Window gdwindow = (Gdk.X11.Window)dwindow;
        uint xidint = (uint)gdwindow.get_xid();
        //the obejct to populate with child X windows from xidint to check for props	
	
	string domaincolor = get_gdk_window_property  (dwindow,"_QUBES_LABEL_COLOR");
        //0x2e001d9
        print(domaincolor+"\n");
        string color = "%X".printf(uint.parse(domaincolor));
        //print(color+"\n");
        
       if (domaincolor == null){ 
        	//print("window is not lollypop");
        	domaincolor = "8421504";
        }
        //else
      //  {	//print("window is lollypop");
       // 	domaincolor = "15586304";
      //  }
        
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
        //print();
	//https://valadoc.org/x11/X.Display.query_tree.html I think after going though the toplevel windows I need to go into the children to get another set of xid's which should contain the property which I can then boil back up to gdk.Screen. "lol X11+gdk+gtk is super fun with this odd usecase"
        string xstring = "%X\n".printf(int.parse(xidint.to_string()));
        //janky logging not sure where else to put it after its loaded globally
        	//Process.spawn_command_line_sync (@"touch /home/test/Documents/$xstring");
        });
        
        
        
        //print(domaincolor);
        //print(domaincolor);


        
        
        
       

        
	//print((string)xidint);
        //gotta switch over to qubes to finish the color theming should be able to take the 
        //color property and pass it right into this CSS

        //what a colorcode looks like from win prop 8421504
        //int colornum = 15586304;
        //format to hex
        

          
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
    //datatypes for get_window_property
    X.Atom type;
    int format;
    ulong n_items;
    ulong bytes_after;
    void* data;
    string? name = null;
    //datatypes for query tree
    X.Window[] childwin;
    X.Window rootwin ;
    X.Window parentwin ;
    
    display.get_xdisplay().query_tree(win.get_xid(), out rootwin, out parentwin, out childwin);
    
    int i;
    for (i = 0; i < childwin.length; i++) {
    	X.Window xid = childwin[i];
    	X.Window poxid = win.get_xid();
    	uint winid = (uint)childwin[i];
    	uint pxid= (uint)win.get_xid();
    	//got the damn child ID!!!
    	print(@"$winid childwin id\n");
        print(@"$pxid pxid \n");
        display.error_trap_push();
        //why wont you get the info of the child win?????
        Process.spawn_command_line_sync (@"touch /home/test/Documents/$winid");
    	display.get_xdisplay().get_window_property(
        xid, Gdk.X11.get_xatom_by_name(property), 0, long.MAX, false,
        X.XA_CARDINAL,
        out type, out format, out n_items, out bytes_after, out data);
    	
    	display.error_trap_pop_ignored();
    
        if (data != null) {
        // = (int) data;
        uint dataa = *(uint *) data;
        name = "%u".printf(dataa);
        Process.spawn_command_line_sync (@"touch /home/test/Documents/$name");
        X.free(data);
    	}
    
    
    }
    //Gdk.X11.get_xatom_by_name_for_display(display, "CARDINAL")

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
    //this is for looking at child windows because the property might not be on the root win object
    X.Window[] childwin;
    X.Window rootwin ;
    X.Window parentwin ;
    
    X.Atom type;
    int format;
    ulong n_items;
    ulong bytes_after;
    void* data;
    string? name = null;
	
	
		

    display.error_trap_push();
    
    /* root window 
    display.get_xdisplay().get_window_property(
        win.get_xid(), Gdk.X11.get_xatom_by_name_for_display(display, property), 0, long.MAX, false,
        X.XA_CARDINAL,
        out type, out format, out n_items, out bytes_after, out data);
    display.error_trap_pop_ignored();

    if (data != null) {
    	int dataprop = * (int *) data;
        name = "%u".printf(dataprop);;
        X.free(data);
        //return name;
    }
    */
    display.get_xdisplay().query_tree(win.get_xid(), out rootwin, out parentwin, out childwin);
    
        int i;
        for (i = 0; i < childwin.length; i++) {
          uint winid = (uint)childwin[i];
          //got the damn child ID!!!
   	 print(@"$winid querytree did somthing\n");
            
            display.get_xdisplay().get_window_property(
             	winid, Gdk.X11.get_xatom_by_name_for_display(display, property), 0, long.MAX, false,
              X.XA_CARDINAL,
              out type, out format, out n_items, out bytes_after, out data);
          if (data != null) {
    	   int dataprop = * (int *) data;
           name = "%u".printf(dataprop);
           print(@"$name NAME\n");
           X.free(data);
           return name;
           }else{
           print("DATA WAS NULL\n");
           }
        
        }

	
    
    
    return name;
    
    
}


}
