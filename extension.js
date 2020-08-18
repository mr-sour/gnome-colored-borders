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
        let width = 4;

        // clockwise order
        framebuffer.draw_rectangle(this._pipeline,
            0, 0, alloc.get_width(), width);
        framebuffer.draw_rectangle(this._pipeline,
            alloc.get_width() - width, width,
            alloc.get_width(), alloc.get_height());
        framebuffer.draw_rectangle(this._pipeline,
            0, alloc.get_height(),
            alloc.get_width() - width, alloc.get_height() - width);
        framebuffer.draw_rectangle(this._pipeline,
            0, alloc.get_height() - width,
            width, width);
    }
});


const WindowShader = new Lang.Class({
    Name: 'WindowShader',

    _init: function(actor) {
        this._effect = new RedBorderEffect();
        actor.add_effect(this._effect);
        this.actor = actor;
        this._enabled = true;
        //this._shadeLevel = 0.0;
        //this._effect.enabled = (this._shadeLevel > 0);
    },

    set shadeLevel(level) {
        this._shadeLevel = level;
        //this._effect.set_brightness(level * SHADE_BRIGHTNESS);
        //this._effect.enabled = (this._shadeLevel > 0);
    },

    get shadeLevel() {
        return this._shadeLevel;
    }
});

function init() {
}

function enable() {

    function use_shader(meta_win) {
    if (!meta_win) {
        return false;
    }
    var type = meta_win.get_window_type()
    return (type == Meta.WindowType.NORMAL ||
        type == Meta.WindowType.DIALOG ||
        type == Meta.WindowType.MODAL_DIALOG);
    }

    function verifyShader(wa) {
        if (wa._inactive_shader)
            return;
        var meta_win = wa.get_meta_window();
        if (!use_shader(meta_win)) {
            return;
        }
        wa._inactive_shader = new WindowShader(wa);
        if(!wa._inactive_shader)
            return;
        if (!meta_win.has_focus()) {
            Tweener.addTween(wa._inactive_shader,
                             { shadeLevel: 1.0,
                               time: SHADE_TIME,
                               transition: 'linear'
                             });
        }
    }

    function focus(the_window) {
        global.get_window_actors().forEach(function(wa) {
            verifyShader(wa);
            if (!wa._inactive_shader)
                return;
            if (the_window == wa.get_meta_window()) {
                Tweener.addTween(wa._inactive_shader,
                                 { shadeLevel: 0.0,
                                   time: SHADE_TIME,
                                   transition: 'linear'
                 });
            } else if(wa._inactive_shader.shadeLevel == 0.0) {
                Tweener.addTween(wa._inactive_shader,
                                 { shadeLevel: 1.0,
                                   time: SHADE_TIME,
                                   transition: 'linear'
                                 });
            }
        });
    }

    function window_created(__unused_display, the_window) {
        if (use_shader(the_window)) {
            the_window._shade_on_focus = the_window.connect('focus', focus);
        }
    }
    on_window_created = global.display.connect('window-created', window_created);

    global.get_window_actors().forEach(function(wa) {
        var meta_win = wa.get_meta_window();
        if (!meta_win) {
            return;
        }
        verifyShader(wa);
        window_created(null, wa.get_meta_window());
    });
}

function disable() {
    if (on_window_created) {
        global.display.disconnect(on_window_created);
    }
    global.get_window_actors().forEach(function(wa) {
        var win = wa.get_meta_window();
        if (win && win._shade_on_focus) {
            win.disconnect(win._shade_on_focus);
            delete win._shade_on_focus;
        }
        if(wa._inactive_shader) {
            wa._inactive_shader.shadeLevel = 0.0;
            wa.remove_effect(wa._inactive_shader._effect);
            delete wa._inactive_shader;
        }
    });
}
