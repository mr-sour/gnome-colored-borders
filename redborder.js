
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
        let width = 2;

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

        let allocc = actor.get_meta_window();
        let alloc = actor.get_content_box();

        let width = 1;
        let = allocc.get_frame_rect();
        //this computes the diference between width and height to size the box
        let dw = alloc.get_width() - winrect.width ;
        let dh = alloc.get_height() - winrect.height ;
        //let dy = winrect.y - alloc.get_y() ;
        //let dx = winrect.x - alloc.get_x() ;
        //TODO compute the diference between x and y to place it correctly?


        //this._highlight.set_size(rect.width, rect.height);
        //this._highlight.set_position(rect.x - x, rect.y - y);

        // clockwise order
        //0,0 is top right of the clutter actor not the window 
        //fuck theres a differnt cordinate system for the actor and global window
        // going to have to change framebuffer object to the window should be able to make a new one with the 
        //meta_window object?
//it being wonkey isn't to bad. I need to take the the window size rect and use that to make the rect np
//I can then just shift it over based the the diference of x,y between win rect and actor rect the extra on the bottom
//doesn't really mean anything cause I dont need compute height diference I just need to use rect heigh and subtract the cord difference vs hieght difference
        framebuffer.draw_rectangle(this._pipeline,
             dw/2,
             dh-20, 
             winrect.width+(dw/2) , 
             (dh)+1);
        /*
        framebuffer.draw_rectangle(this._pipeline,
            alloc.get_width() - width, 
            width,
            alloc.get_width(), 
            alloc.get_height());
        /*
        framebuffer.draw_rectangle(this._pipeline,
            0, alloc.get_height(),
            alloc.get_width() - width, alloc.get_height() - width);

        framebuffer.draw_rectangle(this._pipeline,
            0, alloc.get_height() - width,
            width, width);
        */
    }
});
