
#include <gtk/gtk.h>

static const gchar* STYLE = "decoration { border: 4px solid gray; background: gray; } .window-frame { box-shadow: none; margin: 0; } .titlebar { border-radius: 0; }";

void
gtk_module_init(gint *argc, gchar ***argv[])
{
  GError* error = NULL;
  GtkCssProvider* provider = gtk_css_provider_new();
  gtk_css_provider_load_from_data(provider, STYLE, -1,
                                  &error);
  if (error)
    g_error(error->message);
  gtk_style_context_add_provider_for_screen(gdk_screen_get_default(),
                                            GTK_STYLE_PROVIDER(provider),
                                            GTK_STYLE_PROVIDER_PRIORITY_USER);
}