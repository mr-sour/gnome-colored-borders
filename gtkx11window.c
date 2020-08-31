
// gcc test.c `pkg-config --cflags --libs gtk+-3.0 gdk-3.0` -lX11 && ./a.out

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

    GdkDisplay* gd = gdk_display_get_default();
    Display* d = GDK_DISPLAY_XDISPLAY(gd);

    Window w = XCreateSimpleWindow(d, DefaultRootWindow(d), 0, 0, 300, 300, 0, 0, 0);
    XMapRaised(d, w);

    GdkWindow* gw = gdk_x11_window_foreign_new_for_display(gd, w);

    GtkWidget* gtk = gtk_widget_new(GTK_TYPE_WINDOW, NULL);
    g_signal_connect(gtk, "realize", G_CALLBACK(my_gtk_realize), gw);
    gtk_widget_set_has_window(gtk, TRUE);
    gtk_widget_realize(gtk);

    GtkWidget* menubar = gtk_menu_bar_new();
    GtkWidget* file = gtk_menu_item_new_with_label("File");
    GtkWidget* filemenu = gtk_menu_new();
    GtkWidget* quit = gtk_menu_item_new_with_label("Quit");
    gtk_menu_shell_append(GTK_MENU_SHELL(filemenu), quit);
    gtk_menu_item_set_submenu(GTK_MENU_ITEM(file), filemenu);
    gtk_menu_shell_append(GTK_MENU_SHELL(menubar), file);

    GtkWidget* box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
    gtk_box_pack_start(GTK_BOX(box), menubar, FALSE, FALSE, 3);
    gtk_container_add(GTK_CONTAINER(gtk), box);

    gboolean running = TRUE;
    g_signal_connect(G_OBJECT(quit), "activate", G_CALLBACK(file_quit), &running);

    gtk_widget_show_all(gtk);

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