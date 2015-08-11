/+
 +  Copyright © 2015 Rémi Thebault
 +
 +  Permission is hereby granted, free of charge, to any person
 +  obtaining a copy of this software and associated documentation files
 +  (the "Software"), to deal in the Software without restriction,
 +  including without limitation the rights to use, copy, modify, merge,
 +  publish, distribute, sublicense, and/or sell copies of the Software,
 +  and to permit persons to whom the Software is furnished to do so,
 +  subject to the following conditions:
 +
 +  The above copyright notice and this permission notice (including the
 +  next paragraph) shall be included in all copies or substantial
 +  portions of the Software.
 +
 +  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 +  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 +  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 +  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 +  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 +  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 +  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 +  SOFTWARE.
 +/
module wayland.client.dy_loader;


version (Dynamic) {

    import derelict.util.loader;
    import wayland.client.util;
    import wayland.client.core;
    import ifaces = wayland.client.ifaces;
    import wayland.client.egl;


    private __gshared WaylandClientLoader clientLoader;
    private __gshared WaylandEglLoader eglLoader;


    enum wld_client_lib_name = "libwayland-client.so";

    public void loadWaylandClient() {
        if (clientLoader) return;

        clientLoader = new WaylandClientLoader(wld_client_lib_name);
        clientLoader.load();
    }


    enum wld_egl_lib_name = "libwayland-egl.so";

    public void loadWaylandEgl() {
        if (eglLoader) return;

        eglLoader = new WaylandEglLoader(wld_egl_lib_name);
        eglLoader.load();
    }


    version (unittest) {
        shared static this() {
            loadWaylandClient();
        }
    }

    private class WaylandClientLoader : ifaces.WaylandClientLoader
    {
        public this(string libName) {
            super(libName);
        }

        protected override void loadSymbols() {

            super.loadSymbols();

            bindFunc( cast( void** )&wl_list_init, "wl_list_init");
            bindFunc( cast( void** )&wl_list_insert, "wl_list_insert");
            bindFunc( cast( void** )&wl_list_length, "wl_list_length");
            bindFunc( cast( void** )&wl_list_empty, "wl_list_empty");
            bindFunc( cast( void** )&wl_list_remove, "wl_list_remove");
            bindFunc( cast( void** )&wl_list_insert_list, "wl_list_insert_list");

            bindFunc( cast( void** )&wl_array_init, "wl_array_init");
            bindFunc( cast( void** )&wl_array_release, "wl_array_release");
            bindFunc( cast( void** )&wl_array_add, "wl_array_add");
            bindFunc( cast( void** )&wl_array_copy, "wl_array_copy");

            bindFunc( cast( void** )&wl_event_queue_destroy, "wl_event_queue_destroy");

            bindFunc( cast( void** )&wl_proxy_marshal, "wl_proxy_marshal");
            bindFunc( cast( void** )&wl_proxy_marshal_array, "wl_proxy_marshal_array");
            bindFunc( cast( void** )&wl_proxy_create, "wl_proxy_create");
            bindFunc( cast( void** )&wl_proxy_marshal_constructor, "wl_proxy_marshal_constructor");
            bindFunc( cast( void** )&wl_proxy_marshal_array_constructor, "wl_proxy_marshal_array_constructor");
            bindFunc( cast( void** )&wl_proxy_destroy, "wl_proxy_destroy");
            bindFunc( cast( void** )&wl_proxy_add_listener, "wl_proxy_add_listener");
            bindFunc( cast( void** )&wl_proxy_get_listener, "wl_proxy_get_listener");
            bindFunc( cast( void** )&wl_proxy_add_dispatcher, "wl_proxy_add_dispatcher");
            bindFunc( cast( void** )&wl_proxy_set_user_data, "wl_proxy_set_user_data");
            bindFunc( cast( void** )&wl_proxy_get_user_data, "wl_proxy_get_user_data");
            bindFunc( cast( void** )&wl_proxy_get_id, "wl_proxy_get_id");
            bindFunc( cast( void** )&wl_proxy_get_class, "wl_proxy_get_class");
            bindFunc( cast( void** )&wl_proxy_set_queue, "wl_proxy_set_queue");

            bindFunc( cast( void** )&wl_display_connect, "wl_display_connect");
            bindFunc( cast( void** )&wl_display_connect_to_fd, "wl_display_connect_to_fd");
            bindFunc( cast( void** )&wl_display_disconnect, "wl_display_disconnect");
            bindFunc( cast( void** )&wl_display_get_fd, "wl_display_get_fd");
            bindFunc( cast( void** )&wl_display_dispatch, "wl_display_dispatch");
            bindFunc( cast( void** )&wl_display_dispatch_queue, "wl_display_dispatch_queue");
            bindFunc( cast( void** )&wl_display_dispatch_queue_pending, "wl_display_dispatch_queue_pending");
            bindFunc( cast( void** )&wl_display_dispatch_pending, "wl_display_dispatch_pending");
            bindFunc( cast( void** )&wl_display_get_error, "wl_display_get_error");
            bindFunc( cast( void** )&wl_display_get_protocol_error, "wl_display_get_protocol_error");
            bindFunc( cast( void** )&wl_display_flush, "wl_display_flush");
            bindFunc( cast( void** )&wl_display_roundtrip_queue, "wl_display_roundtrip_queue");
            bindFunc( cast( void** )&wl_display_roundtrip, "wl_display_roundtrip");
            bindFunc( cast( void** )&wl_display_create_queue, "wl_display_create_queue");
            bindFunc( cast( void** )&wl_display_prepare_read_queue, "wl_display_prepare_read_queue");
            bindFunc( cast( void** )&wl_display_prepare_read, "wl_display_prepare_read");
            bindFunc( cast( void** )&wl_display_cancel_read, "wl_display_cancel_read");
            bindFunc( cast( void** )&wl_display_read_events, "wl_display_read_events");

            bindFunc( cast( void** )&wl_log_set_handler_client, "wl_log_set_handler_client");

        }
    }

    private class WaylandEglLoader : SharedLibLoader
    {
        public this(string libName) {
            super(libName);
        }

        protected override void loadSymbols() {

            bindFunc( cast( void** )&wl_egl_window_create, "wl_egl_window_create");
            bindFunc( cast( void** )&wl_egl_window_destroy, "wl_egl_window_destroy");
            bindFunc( cast( void** )&wl_egl_window_resize, "wl_egl_window_resize");
            bindFunc( cast( void** )&wl_egl_window_get_attached_size,
                                    "wl_egl_window_get_attached_size");

        }
    }


}
