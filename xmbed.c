#include <X11/Xlib.h>
#include <gtk/gtk.h>
#include <gtk/gtkx.h>
//why is this called xmbed.c? because gtk socket plug support uses xmbed under the hood
//gcc -o xmbed ./xmbed.c `pkg-config --libs --cflags gdk-3.0 gtk+-3.0` -lX11
//pretty roundabout searches, but somthing to work with
//https://stackoverflow.com/questions/38798252/whats-the-counterpart-of-qx11embedwidget-in-qt5
//https://developer.gnome.org/gtk3/stable/GtkSocket.html

static void x11_win_reparent_to_gtk_csd(Window *w)
{

	/* Create window Objects*/
	GtkWidget *win  = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	GtkWidget *vbox = gtk_box_new(FALSE, 0);
	GtkWidget *sock = gtk_socket_new();
	GtkWidget *header = gtk_header_bar_new ();
	GdkDisplay *display = gdk_display_get_default();
	GdkScreen *screen = gdk_display_get_default_screen (display);
	GtkCssProvider *provider = gtk_css_provider_new ();
	
	//Add provider to style headerbar priority is 65535 which means it can't be overriden 
	gtk_style_context_add_provider_for_screen (screen, GTK_STYLE_PROVIDER(provider), 65535);
    //Simple little decoration to add to the window
    gtk_css_provider_load_from_data (
     provider, "decoration { border: 3px solid green; background: gray; } .titlebar { background: green ; color:white; }           	.titlebar:backdrop  {background: green; color:white;}           	window.ssd headerbar.titlebar { border: 5px; box-shadow: none;          	background-image: linear-gradient(to bottom, shade(blue, 1.05),           	shade(blue, 1.00)); }", -1, NULL);
    //I like windows that close
	gtk_header_bar_set_show_close_button (GTK_HEADER_BAR (header), TRUE);
	//subtitles? this show is already in my language
    gtk_header_bar_set_has_subtitle (GTK_HEADER_BAR (header), FALSE);
    //this would get set to "VMNAME - APPNAME" in the real app
    gtk_header_bar_set_title (GTK_HEADER_BAR (header), "x11 window embedded in a window with CSD");
	//swap default titlebar for headerbar to set CSD
	gtk_window_set_titlebar (GTK_WINDOW (win), header);
	
	//connect sockets
	//this is if the underlying window has been delete "ie: cancel dialog"
	g_signal_connect(sock, "plug-removed", gtk_main_quit, NULL);
    //this is for when you press the little X or ctrl+c out of program
	g_signal_connect(win,  "delete-event", gtk_main_quit, NULL);

	//Set default start size a little bigger.IDK might need todo some weirdness in the real but this is fine for demo 
	gtk_widget_set_size_request(sock, 400, 200);
	//why did add this?
	//gtk_box_pack_start(GTK_BOX(vbox), sock, TRUE,  TRUE, 0);

	//gotta add my wonderful nonexistant widgets or the sockets dont work
	gtk_container_add(GTK_CONTAINER(win), sock);
	
	//realize gtk window (required before embedding another window)

	//gtk_widget_show(sock);
	//gtk_widget_realize( sock );
	
	gtk_widget_show_all(win);
    // embed x11 window into a GtkSocket
    gtk_socket_add_id(GTK_SOCKET(sock),*w);
    //Call main cause it was in the example
	//gtk_main();
	//gtk_main_iteration();
	while(1){
		//non blocking gtk_main in a blocking loop :D
			gtk_main_iteration_do (FALSE);

		}
}


gint main(gint argc, gchar **argv)
{
    Window child_win;

    // the only reason gtkinit is here and not in the reparenting functin is that I need the display
    //in the real app thats pulled from some x11 voodoo struct
	gtk_init(NULL, NULL);
	GdkDisplay* gd = gdk_display_get_default();
    //get a display
    Display* d = GDK_DISPLAY_XDISPLAY(gd);
    //the simplest black window you ever saw
    child_win = XCreateSimpleWindow(d, DefaultRootWindow(d), 0, 0, 300, 300, 0, 0, 0);
    //magic reparenting function 
    x11_win_reparent_to_gtk_csd(&child_win);
	/* Run */
    printf("%#08x\n", 1);


	return 0;
}
