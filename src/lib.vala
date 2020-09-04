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
    
    //Gdk.X11.get_xatom_by_name_for_display(display, "CARDINAL")
    display.error_trap_push();
    display.get_xdisplay().get_window_property(
        win.get_xid(), Gdk.X11.get_xatom_by_name_for_display(display, property), 0, long.MAX, false,
        X.XA_CARDINAL,
        out type, out format, out n_items, out bytes_after, out data);
    display.error_trap_pop_ignored();

    if (data != null) {
        // = (int) data;
        uint dataa = *(uint *) data;
        name = "%u".printf(dataa);
        X.free(data);
    }
    return name;
}
