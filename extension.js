/* -*- mode: js2 - indent-tabs-mode: nil - js2-basic-offset: 4 -*- */
const St = imports.gi.St;
const Meta = imports.gi.Meta;
const Lang = imports.lang;
const Main = imports.ui.main;
const Tweener = imports.ui.tweener;
const Clutter = imports.gi.Clutter;

const SHADE_TIME = 0.3;
const SHADE_BRIGHTNESS = -0.3;

let on_window_created;

const RedBorderEffect = new Lang.Class({
     Name: 'RedBorderEffect',
     Extends: Clutter.Effect,
 
     vfunc_paint: function() {
         let actor = this.get_actor();
         actor.continue_paint();
 
         let color = new Cogl.Color();
         color.init_from_4ub(0xff, 0, 0, 0xc4);
         Cogl.set_source_color(color);
 
         let geom = actor.get_allocation_geometry();
         let width = 2;
 
         // clockwise order
         Cogl.rectangle(0, 0, geom.width, width);
         Cogl.rectangle(geom.width - width, width,
                        geom.width, geom.height);
         Cogl.rectangle(0, geom.height,
                        geom.width - width, geom.height - width);
         Cogl.rectangle(0, geom.height - width,
                        width, width);
     },
 });



const WindowShader = new Lang.Class({
    Name: 'WindowShader',

    _init: function(actor) {
        this._effect = new Clutter.BrightnessContrastEffect();
        actor.add_effect(this._effect);
        this.actor = actor;
        this._enabled = true;
        this._shadeLevel = 0.0;
        this._effect.enabled = (this._shadeLevel > 0);
    },

    set shadeLevel(level) {
        this._shadeLevel = level;
        this._effect.set_brightness(level * SHADE_BRIGHTNESS);
        this._effect.enabled = (this._shadeLevel > 0);
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
        wa._inactive_shader = new RedBorderEffect(wa);
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
