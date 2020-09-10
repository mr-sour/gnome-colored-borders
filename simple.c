#include <gtk/gtk.h>
#include <gdk/gdkx.h>

int main(int argc, char *argv[]) {
  GtkWidget *header;
  GtkWidget *window;
  int xid;
  gtk_init(&argc, &argv);

  window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    g_signal_connect(window, "destroy",
      G_CALLBACK(gtk_main_quit), NULL); 

    GtkCssProvider *provider = gtk_css_provider_new ();
    GdkDisplay *display = gdk_display_get_default();
    GdkScreen *screen = gdk_display_get_default_screen (display);
    gtk_style_context_add_provider_for_screen (screen, GTK_STYLE_PROVIDER(provider), 65535);
    gtk_css_provider_load_from_data (
        provider, " decoration { border: 3px solid blue; background: gray; }           	.titlebar { background: green ; color:white; }           	.titlebar:backdrop  {background: blue; color:white;}           	window.ssd headerbar.titlebar { border: 5px; box-shadow: none;          	background-image: linear-gradient(to bottom, shade(blue, 1.05),           	shade(blue, 1.00)); }", -1, NULL);
  header = gtk_header_bar_new ();
  gtk_header_bar_set_show_close_button (GTK_HEADER_BAR (header), TRUE);
  gtk_header_bar_set_has_subtitle (GTK_HEADER_BAR (header), FALSE);
  gtk_header_bar_set_title (GTK_HEADER_BAR (header), "BLAH BLAH");
  gtk_window_set_titlebar (GTK_WINDOW (window), header);

  gtk_widget_show_all(window);
  GdkWindow *gdk_window = gtk_widget_get_window(GTK_WIDGET(window));

  xid = (int)gdk_x11_window_get_xid(gdk_window);
  printf("%#08x\n", xid);
  
  gtk_main();

  return 0;
}