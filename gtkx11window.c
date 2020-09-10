
// gcc -o simple ./gtkx11window.c `pkg-config --libs --cflags gdk-3.0 gtk+-3.0` -lX11   

#include <X11/Xlib.h>
#include <unistd.h>
#include <stdio.h>

#include <gtk/gtk.h>
#include <gdk/gdkx.h>

static void my_gtk_realize(GtkWidget* widget, gpointer user)
{
    gtk_widget_set_window(widget, (GdkWindow*)user);
}

static void file_quit(GtkWidget* widget, gpointer user)
{
    gboolean* running = (gboolean*)user;
    *running = FALSE;
}
//this is a little demo of using GTK and X togther somthing that might be needed
//for when the switch to GTK4
int main(int argc, char** argv)
{
    gtk_init(&argc, &argv);

    GtkWidget *header;
    GtkWidget *window;

    GdkDisplay* gd = gdk_display_get_default();
    Display* d = GDK_DISPLAY_XDISPLAY(gd);

    Window w = XCreateSimpleWindow(d, DefaultRootWindow(d), 0, 0, 300, 300, 0, 0, 0);
    XMapRaised(d, w);

    GdkWindow* gw = gdk_x11_window_foreign_new_for_display(gd, w);
    
    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
     g_signal_connect(window, "destroy",
       G_CALLBACK(gtk_main_quit), NULL); 

    if (w != 0) {

        window_container = gdk_window_foreign_new(w);
        if (GTK_WIDGET_MAPPED(window))
            gtk_widget_unmap(window);

        gdk_window_reparent(window->window, window_container, 0, 0);

    }
    //GtkWidget* gtk = gtk_widget_new(GTK_TYPE_WINDOW, NULL);
    
    //g_signal_connect(gtk, "realize", G_CALLBACK(my_gtk_realize), gw);
    //gtk_widget_set_has_window(gtk, TRUE);
    //gtk_widget_realize(gtk);
    
   //widgets were here
    gboolean running = TRUE;

    //gtk_widget_show_all(gtk);

    GC gc = XCreateGC(d, w, 0, 0);
    XColor red;
    XAllocNamedColor(d, DefaultColormap(d, DefaultScreen(d)), "red", &red, &red);
    XSetForeground(d, gc, red.pixel);

    while (running)
    {
        while (gtk_events_pending())
        {
            gtk_main_iteration();
        }

        XDrawRectangle(d, w, gc, 100, 100, 200, 200);
    }
}
