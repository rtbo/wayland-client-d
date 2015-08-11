D bindings to wayland-client library

D code sample

    module connect;

    import wayland.client;
    import std.stdio;

    int main(string[] args)
    {
        // with version(Dynamic) of wayland-client-d, no linkage is necessary
        // but loadWaylandClient() must be called before any use of the library
        // with default version of wayland-client-d, one must link with wayland-client-d
        // and initialization is performed automatically
        loadWaylandClient();

        wl_display *display = wl_display_connect(null);
        if (!display) {
            stderr.writeln("Can't connect to display");
            return 1;
        }
        writeln("connected to display");

        wl_display_disconnect(display);
        writeln("disconnected from display");

        return 0;
    }

