#include <gtk/gtk.h>
#include <X11/Xlib.h>
#include <unistd.h>
#include <stdio.h>
#include <gdk/gdkx.h>
#include <gtk/gtkx.h>

//gcc -o simple ./xmbed.c `pkg-config --libs --cflags gdk-3.0 gtk+-3.0` -lX11
//https://stackoverflow.com/questions/38798252/whats-the-counterpart-of-qx11embedwidget-in-qt5
//https://developer.gnome.org/gtk3/stable/GtkSocket.html

static void my_gtk_realize(GtkWidget* widget, gpointer user)
{
    gtk_widget_set_window(widget, (GdkWindow*)user);
}


static void reparent_x11win_gtk_csd(Window w)
{

	/* Create window */
	GtkWidget *win  = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	GtkWidget *vbox = gtk_box_new(FALSE, 0);
	GtkWidget *sock = gtk_socket_new();
	GtkWidget *header = gtk_header_bar_new ();
	GdkDisplay *display = gdk_display_get_default();
	GdkScreen *screen = gdk_display_get_default_screen (display);
	GtkCssProvider *provider = gtk_css_provider_new ();
	//Add provider to style headerbar

	gtk_style_context_add_provider_for_screen (screen, GTK_STYLE_PROVIDER(provider), 65535);
        gtk_css_provider_load_from_data (
        provider, " decoration { border: 3px solid green; background: gray; }           	.titlebar { background: green ; color:white; }           	.titlebar:backdrop  {background: green; color:white;}           	window.ssd headerbar.titlebar { border: 5px; box-shadow: none;          	background-image: linear-gradient(to bottom, shade(blue, 1.05),           	shade(blue, 1.00)); }", -1, NULL);
        //swap titlebar for headerbar to set CSD
	gtk_header_bar_set_show_close_button (GTK_HEADER_BAR (header), TRUE);
        gtk_header_bar_set_has_subtitle (GTK_HEADER_BAR (header), FALSE);
        gtk_header_bar_set_title (GTK_HEADER_BAR (header), "x11 window embedded in a window with CSD");
	gtk_window_set_titlebar (GTK_WINDOW (win), header);
	//connect socket
	g_signal_connect(sock, "plug-removed", gtk_main_quit, NULL);
	g_signal_connect(win,  "delete-event", gtk_main_quit, NULL);

	//Set default start size a little bigger. 
	gtk_widget_set_size_request(sock, 400, 200);
	//gtk_box_pack_start(GTK_BOX(vbox), sock, TRUE,  TRUE, 0);
	gtk_container_add(GTK_CONTAINER(win), sock);
	//realize gtk window (required before embedding another window)
	gtk_widget_show( sock);
	gtk_widget_realize( sock );
	gtk_widget_show_all(win);
    // embed x11 window into a GtkSocket
    gtk_socket_add_id(GTK_SOCKET(sock),w);
	gtk_main();

}


gint main(gint argc, gchar **argv)
{


	gtk_init(NULL, NULL);


	/* Embed vim */
	//get the id of the gtk socket
	
	//Window id = gtk_socket_get_id(GTK_SOCKET(sock));

	//tell gvim to embed to this window
	//gchar *command = g_strdup_printf("gvim --socketid %d",  id);
	//g_spawn_command_line_async(command, NULL);
	//Obiously this is no fun because it means the app needs to get launched with socketid 
	//but fret not gtk_socket_add_id is what the real app would use which works the other way


	//x11 window
	GdkDisplay* gd = gdk_display_get_default();

    Display* d = GDK_DISPLAY_XDISPLAY(gd);
    Window w = XCreateSimpleWindow(d, DefaultRootWindow(d), 0, 0, 300, 300, 0, 0, 0);
    
    reparent_x11win_gtk_csd(w);








	/* Run */
	return 0;
}
