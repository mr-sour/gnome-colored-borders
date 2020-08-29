
#include <gtk/gtk.h>
#include <gdk/gdkx.h>
#include <glib.h> 
static const gchar* STYLE = "decoration { border: 4px solid red; background: gray; } .window-frame { box-shadow: none; margin: 0; } .titlebar { border-radius: 0; }";

void print_number(gpointer data_ptr, gpointer ignored)  
{  
  /* cast a pointer to a gint and print that value */  
  //g_print("%d ", *(gint *)data_ptr); 
  const gchar* winname = gtk_window_get_title(data_ptr);
  //g_print(winname); 
}  

void print_list(GList *list)  
{  
  if (list == NULL) {  
     g_print("List empty!\n\n");  
  } else {  
     g_list_foreach(list, print_number, NULL);  
     g_print("\n\n");  
   }  
}  

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
  //int xid = GDK_ROOT_WINDOW();
  //g_print("%s\n", ());
  //g_snprintf(str, "%i", xid);
  //g_print("%d ", xid);
  //GdkScreen* screen = gdk_screen_get_default ();
  //GList* winlist = gdk_screen_get_toplevel_windows (screen);
  //this one is empty
  //GList* winlist = gtk_window_list_toplevels (void);
  GApplication* _tmp0_;
  const gchar* id;
  _tmp0_ = g_application_get_default ();
  //id = g_application_get_application_id(_tmp0_);
  //GList* winlist = gtk_application_get_windows(_tmp0_);
  GList* winlist = gtk_window_list_toplevels();
  print_list(winlist);
  g_print("sanity");

  if (error)
    g_error(error->message);
  gtk_style_context_add_provider_for_screen(gdk_screen_get_default(),
                                            GTK_STYLE_PROVIDER(provider),
                                            GTK_STYLE_PROVIDER_PRIORITY_USER);
}

