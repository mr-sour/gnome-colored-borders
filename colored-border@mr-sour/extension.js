/* -*- mode: js2 - indent-tabs-mode: nil - js2-basic-offset: 4 -*- */
const Lang = imports.lang;
const Main = imports.ui.main;
const Tweener = imports.ui.tweener;

const { Clutter, Cogl, Gio, GLib, GObject,
        Graphene, Meta, Pango, Shell, St } = imports.gi;

const SHADE_TIME = 0.3;
const SHADE_BRIGHTNESS = -0.3;

let on_window_created;


var RedBorderEffect = GObject.registerClass(
class RedBorderEffect extends Clutter.Effect {
    _init() {
        super._init();
        this._pipeline = null;
    }

    vfunc_paint(paintContext) {
        let framebuffer = paintContext.get_framebuffer();
        let coglContext = framebuffer.get_context();
        let actor = this.get_actor();
        actor.continue_paint(paintContext);
        if (!this._pipeline) {
            let color = new Cogl.Color();
            color.init_from_4ub(0xff, 0, 0, 0xc4);

            this._pipeline = new Cogl.Pipeline(coglContext);
            this._pipeline.set_color(color);
        }

        let alloc = actor.get_allocation_box();
        let borderwidth = 3;
        let mwin = actor.get_meta_window();
        let winrect = mwin.get_frame_rect();
        //why so much stuff? the actor box is larger then the windowframe
        //the padding is arbitary depending on the framework. this computes
        //the difference between the actorbox (used to draw) and the window frame
        //so we can shift the border peices over

        //diference between width and height
        let dw = alloc.get_width() - winrect.width ;
        let dh = alloc.get_height() - winrect.height ;
        //difference between x and y
        let dy = winrect.y - alloc.y1  ;
        let dx = winrect.x - alloc.x1 ;
        // top
        framebuffer.draw_rectangle(this._pipeline,
            dx ,
            dy , 
            winrect.width + dx, 
            (dy)+borderwidth);
        //right
        framebuffer.draw_rectangle(this._pipeline,
            winrect.width + dx, 
            dy ,
            winrect.width + dx - borderwidth, 
            winrect.height + dy);
        //bottom
        framebuffer.draw_rectangle(this._pipeline,
            dx, 
            winrect.height + dy,
            winrect.width + dx, 
            winrect.height + dy - borderwidth); 
        //left
        framebuffer.draw_rectangle(this._pipeline,
            dx, 
            winrect.height + dy - borderwidth,
            borderwidth+dx,
            dy);
        
    }
});

const WindowShader = new Lang.Class({
    Name: 'WindowShader',

    _init: function(actor) {
        this._effect = new RedBorderEffect();
        actor.add_effect(this._effect);
        this.actor = actor;
        this._enabled = true;
        //this._bordercolor = 0.0;
       
    },

    set borderColor(color) {
        this._bordercolor = color;

    },

    get borderColor() {
        return this._bordercolor;
    }
});

function init() {
}

function enable() {

    function draw_border(meta_win) {
    if (!meta_win) {
        return false;
    }

    var type = meta_win.get_window_type()
    return (type == Meta.WindowType.NORMAL ||
        type == Meta.WindowType.DIALOG ||
        type == Meta.WindowType.MODAL_DIALOG);
    }

    function verifyBorder(wa) {

        var meta_win = wa.get_meta_window();
        if (!draw_border(meta_win)) {
            return;
        }
        wa = new WindowShader(wa);


    }

    function windowborder(the_window) {
        global.get_window_actors().forEach(function(wa) {
            verifyBorder(wa);
            if (!wa._inactive_shader)
                return;
        });
    }

    function window_created(__unused_display, the_window) {
        if (draw_border(the_window)) {
            the_window._colorborder = the_window.connect('window-created', windowborder);
        }
    }

    on_window_created = global.display.connect('window-created', windowborder);

    global.get_window_actors().forEach(function(wa) {
        var meta_win = wa.get_meta_window();
        if (!meta_win) {
            return;
        }
        verifyBorder(wa);
        window_created(null, wa.get_meta_window());
    });
}

function disable() {
    if (on_window_created) {
        global.display.disconnect(on_window_created);
    }
    global.get_window_actors().forEach(function(wa) {
        var win = wa.get_meta_window();
        if (win && win._colorborder) {
            win.disconnect(win._colorborder);
            delete win._colorborder;
        }
    });
}