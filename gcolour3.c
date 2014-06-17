/*
   gcolour3 - "I don't care if it's considered `deprecated`; the new version SUCKS!"
   v1.0 2014-06-08 Steven Honeyman <stevenhoneyman at gmail com>

   Compile using: gcc gcolour3.c -Os -s `pkg-config gtk+-3.0 --cflags --libs` -o gcolour3
*/

#include <gtk/gtk.h>

int main(int argc, char *argv[])
{
  gtk_init (&argc, &argv);
  GtkWidget *dialog = gtk_color_selection_dialog_new("Colour Selection Dialog");
  return gtk_dialog_run(GTK_DIALOG(dialog));
}
