/*
 * A simple Gtk3 message box using non-deprecated Gtk functions
 * ...it was much neater in Gtk2
 *
 * Steven Honeyman 2014-06-18
 *
 */

#include <stdbool.h>
#include <gtk/gtk.h>

void msgbox(const gchar* messagetext, const gchar* title, const bool isError)
{
    GtkWidget *label = gtk_label_new (messagetext);
    GtkWidget *image = gtk_image_new_from_icon_name (isError? "dialog-error":"dialog-information", GTK_ICON_SIZE_DIALOG);
    GtkWidget *dialog = gtk_dialog_new_with_buttons (title, NULL, GTK_DIALOG_MODAL | GTK_DIALOG_DESTROY_WITH_PARENT,
						    "_OK", GTK_RESPONSE_OK, NULL);
    GtkWidget *content_area = gtk_dialog_get_content_area (GTK_DIALOG(dialog));
    gtk_container_set_border_width (GTK_CONTAINER(content_area), 8);
    gtk_window_set_resizable (GTK_WINDOW(dialog), FALSE);

    GtkWidget *grid = gtk_grid_new();
    gtk_grid_set_column_spacing (GTK_GRID(grid), 8);
    gtk_grid_set_row_spacing (GTK_GRID(grid), 8);

    gtk_container_add (GTK_CONTAINER(content_area), grid);
    gtk_widget_set_valign (image,GTK_ALIGN_START);
    gtk_widget_set_valign (label,GTK_ALIGN_START);
    gtk_grid_attach (GTK_GRID(grid),image,0,0,1,1);
    gtk_grid_attach (GTK_GRID(grid),label,1,0,1,1);
    /* (grid, widget, column, row, width-in-cols, height-in-rows) */

    gtk_widget_show_all (dialog);
    gtk_dialog_run (GTK_DIALOG (dialog));
    gtk_widget_destroy (dialog);
}

void main(int argc, char *argv[])
{
    gtk_init (&argc, &argv);

    //example usage
    msgbox("Hello, World!", "Information", 0);
    msgbox("ERROR MESSAGE", "Error", 1);
}
