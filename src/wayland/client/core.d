/+
 +  Wayland copyright:
 +  Copyright © 2008 Kristian Høgsberg
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
/+
 +  D bindings copyright:
 +  Copyright © 2015 Rémi Thebault
 +/
module wayland.client.core;

import wayland.client.util;
import wayland.client.opaque_types;

version (Dynamic) {

    extern (C) {

        alias da_wl_event_queue_destroy = void function(wl_event_queue *queue);

        alias da_wl_proxy_marshal = void function(wl_proxy *p, uint opcode, ...);
        alias da_wl_proxy_marshal_array = void function(wl_proxy *p, uint opcode,
                                    wl_argument *args);
        alias da_wl_proxy_create = wl_proxy *function(wl_proxy *factory,
                                        const (wl_interface*) iface);
        alias da_wl_proxy_marshal_constructor = wl_proxy *function(wl_proxy *proxy,
                                                    uint opcode,
                                                    const (wl_interface*) iface,
                                                    ...);
        alias da_wl_proxy_marshal_array_constructor = wl_proxy *function(wl_proxy *proxy,
                                        uint opcode, wl_argument *args,
                                        const (wl_interface*) iface);

        alias da_wl_proxy_destroy = void function(wl_proxy *proxy);
        alias da_wl_proxy_add_listener = int function(wl_proxy *proxy,
                                void function()* implementation, void *data);
        alias da_wl_proxy_get_listener = const (void*) function(wl_proxy *proxy);
        alias da_wl_proxy_add_dispatcher = int function(wl_proxy *proxy,
                                    wl_dispatcher_func_t dispatcher_func,
                                    const (void*)  dispatcher_data, void *data);
        alias da_wl_proxy_set_user_data = void function(wl_proxy *proxy, void *user_data);
        alias da_wl_proxy_get_user_data = void *function(wl_proxy *proxy);
        alias da_wl_proxy_get_id = uint function(wl_proxy *proxy);
        alias da_wl_proxy_get_class = const (char*) function(wl_proxy *proxy);
        alias da_wl_proxy_set_queue = void function(wl_proxy *proxy, wl_event_queue *queue);

        alias da_wl_display_connect = wl_display *function(const (char*) name);
        alias da_wl_display_connect_to_fd = wl_display *function(int fd);
        alias da_wl_display_disconnect = void function(wl_display *display);
        alias da_wl_display_get_fd = int function(wl_display *display);
        alias da_wl_display_dispatch = int function(wl_display *display);
        alias da_wl_display_dispatch_queue = int function(wl_display *display,
                                    wl_event_queue *queue);
        alias da_wl_display_dispatch_queue_pending = int function(wl_display *display,
                                            wl_event_queue *queue);
        alias da_wl_display_dispatch_pending = int function(wl_display *display);
        alias da_wl_display_get_error = int function(wl_display *display);
        alias da_wl_display_get_protocol_error = uint function(wl_display *display,
                                            const (wl_interface*)* iface,
                                            uint *id);
        alias da_wl_display_flush = int function(wl_display *display);
        alias da_wl_display_roundtrip_queue = int function(wl_display *display,
                                    wl_event_queue *queue);
        alias da_wl_display_roundtrip = int function(wl_display *display);
        alias da_wl_display_create_queue = wl_event_queue *function(wl_display *display);
        alias da_wl_display_prepare_read_queue = int function(wl_display *display,
                                        wl_event_queue *queue);
        alias da_wl_display_prepare_read = int function(wl_display *display);
        alias da_wl_display_cancel_read = void function(wl_display *display);
        alias da_wl_display_read_events = int function(wl_display *display);

        alias da_wl_log_set_handler_client = void function(wl_log_func_t handler);
    }

    __gshared {

        da_wl_event_queue_destroy wl_event_queue_destroy;

        da_wl_proxy_marshal wl_proxy_marshal;
        da_wl_proxy_marshal_array wl_proxy_marshal_array;
        da_wl_proxy_create wl_proxy_create;
        da_wl_proxy_marshal_constructor wl_proxy_marshal_constructor;
        da_wl_proxy_marshal_array_constructor wl_proxy_marshal_array_constructor;
        da_wl_proxy_destroy wl_proxy_destroy;
        da_wl_proxy_add_listener wl_proxy_add_listener;
        da_wl_proxy_get_listener wl_proxy_get_listener;
        da_wl_proxy_add_dispatcher wl_proxy_add_dispatcher;
        da_wl_proxy_set_user_data wl_proxy_set_user_data;
        da_wl_proxy_get_user_data wl_proxy_get_user_data;
        da_wl_proxy_get_id wl_proxy_get_id;
        da_wl_proxy_get_class wl_proxy_get_class;
        da_wl_proxy_set_queue wl_proxy_set_queue;

        da_wl_display_connect wl_display_connect;
        da_wl_display_connect_to_fd wl_display_connect_to_fd;
        da_wl_display_disconnect wl_display_disconnect;
        da_wl_display_get_fd wl_display_get_fd;
        da_wl_display_dispatch wl_display_dispatch;
        da_wl_display_dispatch_queue wl_display_dispatch_queue;
        da_wl_display_dispatch_queue_pending wl_display_dispatch_queue_pending;
        da_wl_display_dispatch_pending wl_display_dispatch_pending;
        da_wl_display_get_error wl_display_get_error;
        da_wl_display_get_protocol_error wl_display_get_protocol_error;
        da_wl_display_flush wl_display_flush;
        da_wl_display_roundtrip_queue wl_display_roundtrip_queue;
        da_wl_display_roundtrip wl_display_roundtrip;
        da_wl_display_create_queue wl_display_create_queue;
        da_wl_display_prepare_read_queue wl_display_prepare_read_queue;
        da_wl_display_prepare_read wl_display_prepare_read;
        da_wl_display_cancel_read wl_display_cancel_read;
        da_wl_display_read_events wl_display_read_events;

        da_wl_log_set_handler_client wl_log_set_handler_client;

    }
}
else {
    extern (C) {
        void wl_event_queue_destroy(wl_event_queue *queue);

        void wl_proxy_marshal(wl_proxy *p, uint opcode, ...);
        void wl_proxy_marshal_array(wl_proxy *p, uint opcode,
                                    wl_argument *args);
        wl_proxy *wl_proxy_create(wl_proxy *factory,
                                        const (wl_interface*) iface);
        wl_proxy *wl_proxy_marshal_constructor(wl_proxy *proxy,
                                                    uint opcode,
                                                    const (wl_interface*) iface,
                                                    ...);
        wl_proxy *
        wl_proxy_marshal_array_constructor(wl_proxy *proxy,
                                        uint opcode, wl_argument *args,
                                        const (wl_interface*) iface);

        void wl_proxy_destroy(wl_proxy *proxy);
        int wl_proxy_add_listener(wl_proxy *proxy,
                                void function()* implementation, void *data);
        const (void*) wl_proxy_get_listener(wl_proxy *proxy);
        int wl_proxy_add_dispatcher(wl_proxy *proxy,
                                    wl_dispatcher_func_t dispatcher_func,
                                    const (void*)  dispatcher_data, void *data);
        void wl_proxy_set_user_data(wl_proxy *proxy, void *user_data);
        void *wl_proxy_get_user_data(wl_proxy *proxy);
        uint wl_proxy_get_id(wl_proxy *proxy);
        const (char*) wl_proxy_get_class(wl_proxy *proxy);
        void wl_proxy_set_queue(wl_proxy *proxy, wl_event_queue *queue);

        wl_display *wl_display_connect(const (char*) name);
        wl_display *wl_display_connect_to_fd(int fd);
        void wl_display_disconnect(wl_display *display);
        int wl_display_get_fd(wl_display *display);
        int wl_display_dispatch(wl_display *display);
        int wl_display_dispatch_queue(wl_display *display,
                                    wl_event_queue *queue);
        int wl_display_dispatch_queue_pending(wl_display *display,
                                            wl_event_queue *queue);
        int wl_display_dispatch_pending(wl_display *display);
        int wl_display_get_error(wl_display *display);
        uint wl_display_get_protocol_error(wl_display *display,
                                            const (wl_interface*)* iface,
                                            uint *id);

        int wl_display_flush(wl_display *display);
        int wl_display_roundtrip_queue(wl_display *display,
                                    wl_event_queue *queue);
        int wl_display_roundtrip(wl_display *display);
        wl_event_queue *wl_display_create_queue(wl_display *display);

        int wl_display_prepare_read_queue(wl_display *display,
                                        wl_event_queue *queue);
        int wl_display_prepare_read(wl_display *display);
        void wl_display_cancel_read(wl_display *display);
        int wl_display_read_events(wl_display *display);

        void wl_log_set_handler_client(wl_log_func_t handler);


    }

}

