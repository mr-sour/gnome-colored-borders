
#include <gtk/gtk.h>
#include <gdk/gdkx.h>

static const gchar* STYLE = "decoration { border: 4px solid red; background: gray; } .window-frame { box-shadow: none; margin: 0; } .titlebar { border-radius: 0; }";

void
gtk_module_init(gint *argc, gchar ***argv[])
{
  GError* error = NULL;
  GtkCssProvider* provider = gtk_css_provider_new();
  gtk_css_provider_load_from_data(provider, STYLE, -1,
                                  &error);
  //GtkWidget* widget = gtk_label_new(NULL);
  //GdkWindow *gtk_window = gtk_widget_get_parent_window(widget);
  //GtkWindow *parent = NULL;
  //gdk_window_get_user_data(gtk_window, (gpointer *)&parent);
  //gtk_window_get_title(parent)
  
  int xid = gdk_x11_get_default_root_xwindow();
  //g_print("%s\n", ());
  //g_snprintf(str, "%i", xid);
  g_print("%d ", xid);
  if (error)
    g_error(error->message);
  gtk_style_context_add_provider_for_screen(gdk_screen_get_default(),
                                            GTK_STYLE_PROVIDER(provider),
                                            GTK_STYLE_PROVIDER_PRIORITY_USER);
}