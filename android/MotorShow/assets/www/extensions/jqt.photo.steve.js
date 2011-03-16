/**
 *    Provides event handling for iPhone like photo gallery (without thumbnail portion)
 *
 *    @author Sam Shull <http://www.google.com/profiles/brickysam26>
 *    @copyright 2010 Sam Shull <http://samshull.blogspot.com/>
 *
 *    Special Thanks to Steve Simitzis <http://saturn5.com>
 *
 *    @license <http://www.opensource.org/licenses/mit-license.html>
 *
 *    Permission is hereby granted, free of charge, to any person obtaining a copy
 *    of this software and associated documentation files (the "Software"), to deal
 *    in the Software without restriction, including without limitation the rights
 *    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *    copies of the Software, and to permit persons to whom the Software is
 *    furnished to do so, subject to the following conditions:
 *    
 *    The above copyright notice and this permission notice shall be included in
 *    all copies or substantial portions of the Software.
 *    
 *    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *    THE SOFTWARE.
 *
 *    Custom Events handled by each gallery:
 *
 *        jqt-photo-slideto            - slide to a given index (e, [index = int [, options = Object [, slides = jQuery ] ] ] )
 *        jqt-photo-play                - start the slideshow from the given point
 *        jqt-photo-pause                - stop the slideshow
 *        jqt-photo-prev                - go to the previous slide
 *        jqt-photo-next                - go to the next slide
 *        jqt-photo-hide-toolbars        - hide the visibility of the toolbars
 *        jqt-photo-show-toolbars        - show the visibility of the toolbars
 *        jqt-photo-toggle-toolbars    - toggle the visibility of the toolbars
 */
(function($){
    
    /**
     *
     *
     *
     */
    var undefined, 
        galleries = [],
        parseRuleSet = false,
        window = this,
        Math = window.Math,
        min = Math.min,
        floor = Math.floor,
        sqrt = Math.sqrt,
        pow = Math.pow,
        abs = Math.abs,
        orientation = abs(window.orientation) == 90 ? "landscape" : "portrait",
        defaults = {
            /**
             *    displays in title bar
             *
             *    @var String
             */
            galleryName: "{0} of {1}",
            
            /**
             *    where to start the slides
             *
             *    @var Number
             */
            defaultIndex: 0,
            
            /**
             *    properties to animate
             *
             *    @var Number
             */
            transitionProperty: "-webkit-transform",
            
            /**
             *    timing function
             *
             *    @var String
             */
            timingFunction: "cubic-bezier(0,0,.25,1)",
            
            /**
             *    the reset transform
             *
             *    @var String
             */
            defaultTransform: "translate3d(0,0,0)",
            
            /**
             *    
             *
             *    @var String
             */
			blankImage: "data:image/gif;base64,AAAA",
            
            /**
             *    default speed for slideshow
             *
             *    @var Number
             */
            slideDelay: 5000,
            
            /**
             *    default speed for slide change
             *
             *    @var Number
             */
            scrollSpeed: 500,
            
            /**
             *    default speed for scale resizing
             *
             *    @var Number
             */
            scaleSpeed: 500,
            
            /**
             *    tags to ignore
             *
             *    @var Array
             */
            tagNames: "A,INPUT,SELECT,TEXTAREA",
            
            //only used by generator
            
            /**
             *    link to return
             *
             *    @var String
             */
            backLink: '<a class="back" href="#home">Home</a>',
            
            /**
             *    an individual slides template
             *
             *    @var String
             */
            slideTemplate: '<td class="jqt-photo-image-slide"><div><img/><div class="jqt-photo-caption"></div></div></td>',
            
            /**
             *    CSS Rule for removing the max-width/max-height properties from the images
             *
             *    @var String
             */
            parsedClassTemplate: "#jqt .jqt-photo .jqt-photo-image-slide > .{0}{max-width:auto;max-height:auto;}",
            
            /**
             *    the overall psuedo page template
             *
             *    @var String
             */
            galleryTemplate: '<div class="jqt-photo">\
                                    <div class="toolbar toolbar-top"><\/div>\
                                    <table class="jqt-photo-image-list">\
                                        <tr class="jqt-photo-slide-list"><\/tr>\
                                    <\/table>\
                                    <div class="toolbar toolbar-bottom">\
                                        <div class="jqt-photo-prev"></div>\
                                        <div class="jqt-photo-pause"></div>\
                                        <div class="jqt-photo-play"></div>\
                                        <div class="jqt-photo-next"></div>\
                                    <\/div>\
                                <\/div>',
            
            //psuedo events
            
            /**
             *    Handle the pageAnimationEnd event fired by jQTouch
             *    Resets the positions and scales
             *
             *    @var Function
             */
            pageAnimationEnd: pageAnimationEnd,
            
            /**
             *    Handle the pageAnimationStart event fired by jQTouch
             *    Resets the positions and scales
             *
             *    @var Function
             */
			pageAnimationStart: pageAnimationStart,
            
            /**
             *    Handle the transition of slides in a gallery
             *
             *    @var Function
             */
            slideTo: slideTo,
            
            /**
             *    Begin a slideshow on a gallery
             *
             *    @var Function
             */
            play: play,
            
            /**
             *    End a slideshow on a gallery
             *
             *    @var Function
             */
            pause: pause,
            
            /**
             *    Go to the next slide in the list
             *
             *    @var Function
             */
            next: next,
            
            /**
             *    Go to the previous slide in the list
             *
             *    @var Function
             */
            prev: prev,
            
            /**
             *    Go to a specific or implied slide
             *
             *    @var Function
             */
            goTo: goTo,
            
            /**
             *    Reveal the toolbars
             *
             *    @var Function
             */
            showToolbars: showToolbars,
            
            /**
             *    Hide the toolbars
             *
             *    @var Function
             */
            hideToolbars: hideToolbars,
            
            /**
             *    Show/Hide the toolbars where appropriate
             *
             *    @var Function
             */
            toggleToolbars: toggleToolbars,
            
            //mouse events
            
            /**
             *    Handle a touchstart event on the gallery
             *
             *    @var Function
             */
            touchStart: touchStart,
            
            /**
             *    Handle a drag start event (triggered by touchstart)
             *
             *    @var Function
             */
            dragStart: dragStart,
            
            /**
             *
             *
             *    @var Function
             */
            drag: drag,
            
            /**
             *
             *
             *    @var Function
             */
            dragEnd: dragEnd,
            
            /**
             *
             *
             *    @var Function
             */
            scaleStart: scaleStart,
            
            /**
             *
             *
             *    @var Function
             */
            scale: scale,
            
            /**
             *
             *
             *    @var Function
             */
            scaleEnd: scaleEnd,
            
            //classes
            
            /**
             *    Keep track of preloaded images
             *
             *    @var String
             */
            presizedClass: "jqt-photo-presized",
            
            /**
             *    keep track of images that have data
             *
             *    @var String
             */
            parsedClass: "jqt-photo-parsed",
            
            /**
             *    Class name for identifying the current slide
             *
             *    @var String
             */
            imageCurrentClass: "jqt-photo-current",
            
            /**
             *    Class name for designating that a slideshow is in progress 
             *    (and cause pause icon to show, not play icon)
             *
             *    @var String
             */
            playingClass: "jqt-photo-playing",
            
            /**
             *    Class name for initiating an animation to show the toolbars
             *
             *    @var String
             */
            toolbarAnimationInClass: "jqt-photo-toolbar-animation-in",
            
            /**
             *    Class name for initiating an animation to hide the toolbars
             *
             *    @var String
             */
            toolbarAnimationOutClass: "jqt-photo-toolbar-animation-out",
            
            /**
             *    Class name for hiding toolbars - applied outside of animation
             *
             *    @var String
             */
            toolbarHideClass: "jqt-photo-toolbar-hidden",
            
            //selectors
            
            /**
             *    The selector for a caption element
             *
             *    Not yet implemented - need to figure out a way to 
             *    accommodate captions on individual slides, as well as,
             *    caption handler for entire gallery
             *
             *    @var String
             */
            imageCaptionSelector: ".jqt-photo-image-caption",
            
            /**
             *    The selector for the container of the slides
             *
             *    @var String
             */
            imageListSelector: ".jqt-photo-image-list",
            
            /**
             *    The selector of a slide container
             *
             *    @var String
             */
            imageSlideSelector: ".jqt-photo-image-slide",
            
            /**
             *    The selector of the scalable element, relative to a slide
             *
             *    @var String
             */
            imageSelector: "img",
            
            /**
             *    The selector of the Play Icon
             *
             *    @var String
             */
            galleryPlaySelector: ".jqt-photo-play",
            
            /**
             *    The selector of the Pause Icon
             *
             *    @var String
             */
            galleryPauseSelector: ".jqt-photo-pause",
            
            /**
             *    The selector of the Next Icon
             *
             *    @var String
             */
            galleryNextSelector: ".jqt-photo-next",
            
            /**
             *    The selector of the Previous Icon
             *
             *    @var String
             */
            galleryPrevSelector: ".jqt-photo-prev",
            
            /**
             *    The selector of a gallery element
             *
             *    @var String
             */
            gallerySelector: ".jqt-photo",
            
            /**
             *    The selector of the title element
             *
             *    @var String
             */
            toolbarTitleSelector: ".toolbar-top h1"
        },
		caption = function (vars){return (window.innerHeight - vars.caption) + "px";},
		height = function(){return window.innerHeight + "px";},
		width = function(){return window.innerWidth + "px"},
		toolbar = function(vars){return (window.innerHeight - vars.toolbar) + "px";},
		cssRules = {
            variables : {
				caption: 90,
				toolbar: 45
			},
			defaults: {
				"#jqt .jqt-photo .toolbar-bottom" : {
					top:toolbar,
					"font-size":"30px",
					"text-align":"center",
					"vertical-align":"top"
				},
				"#jqt .jqt-photo .jqt-photo-image-slide > div" : {
					width:width,
					height:height,
					"line-height":height,
					"border-spacing":"0 10px 0 0",
					overflow:"hidden",
					"text-align":"center",
					position:"relative",
				},
				"#jqt .jqt-photo .jqt-photo-image-slide .jqt-photo-caption" : {
					top:caption,
				}
			},
            portrait: {
				"#jqt.portrait .jqt-photo" : {
					height:height,
					width:width,
				},
				"#jqt.portrait .jqt-photo .toolbar-bottom" : {
					top:toolbar,
					"font-size":"30px",
					"text-align":"center",
					"vertical-align":"top",
				},
				"#jqt.portrait .jqt-photo .jqt-photo-image-slide > div" : {
					width:width,
					height:height,
					"line-height":height,
					"border-spacing":"0 10px 0 0",
					overflow:"hidden",
					"text-align":"center",
				},
				"#jqt .jqt-photo .jqt-photo-image-slide .jqt-photo-caption" : {
					top:caption,
				}
			},
            landscape: {
				"#jqt.landscape .jqt-photo" : {
					height:height,
					width:width,
				},
				"#jqt.landscape .jqt-photo .toolbar-bottom" : {
					top:toolbar,
				},
				"#jqt.landscape .jqt-photo .jqt-photo-image-list" : {
					height:height,
				},
				"#jqt.landscape .jqt-photo .jqt-photo-image-slide > div" : {
					height:height,
					width:width,
					"line-height":height,
				},
				"#jqt .jqt-photo .jqt-photo-image-slide .jqt-photo-caption" : {
					top:caption,
				}
			}
        };
    
    /*
     *    jQTouch extension
     */
    if ($.jQTouch) {
        //bind the extension
        $.jQTouch.addExtension(function (jqt) {   
            //event handler
            function binder (e, info) {
                if (info.page.is(defaults.gallerySelector)) {
                    info.page.jqtPhoto();
                }
            }
              
            //attach
            $(document.body).bind("pageInserted", binder);
            
            //attach to appropriate containers on DOMREADY
            $(function() {
                $(defaults.gallerySelector)
                    .each(function() {
                        binder(null, {page: $(this)});
                    });
            });
            
            return {
                /**
                 *    Jump to the index of a slide in a gallery
                 *
                 *    @param jQuery | String (selector) | Element gallery
                 *    @param Number index
                 *    @param String | Object animation
                 *    @param Boolean reverse
                 *    @return jQuery
                 */
                goToSlide: function (gallery, index, animation, reverse) {
                    //trigger this first
                    var g = $(gallery), options = g.data("jqt-photo-options");
                    
                    if (!g.hasClass("current")) {
                        jqt.goTo(g, animation || "slide", reverse);
                    }
                     
                    if (g.find(options.imageSlideSelector).index("."+options.imageCurrentClass) != index) {
                        g.triggerHandler("jqt-photo-goto", [index]);
                    }
                    
                    return g;
                },
                
                /**
                 *    Generate a gallery and attach it to the #jqt element,
                 *    additionally updates scaling data, so you don't have to
                 *
                 *    <code>
                 *        images = [{src:"/somewhere1.jpg",caption:"Not Yet Implemented"},
                 *                  {src:"/somewhere2.jpg",caption:"Not Yet Implemented",current:true}];
                 *    </code>
                 *
                 *    @param Array<Object> images
                 *    @param Object options - @see defaults
                 */
                generateGallery: function (id, images, options) {
                    options = $.extend({}, defaults, options);
                    
                    if (!parseRuleSet) {
                        parseRuleSet = true;
                        var sheet = document.styleSheets[document.styleSheets.length-1];
                        sheet.insertRule(
                            format(options.parsedClassTemplate, options.parsedClass), 
                            sheet.cssRules.length
                        );
                    }
                    
                    var innerWidth = window.innerWidth,
                        innerHeight = window.innerHeight,
                        html = format(options.galleryTemplate, 
                                  id, 
                                  format(options.galleryName, options.defaultIndex + 1, images.length), 
                                  options.backLink || ""
                        ),
                        gallery = $(html).appendTo("#jqt"),
                        list = gallery.find(".jqt-photo-slide-list"),
                        toolbar = gallery.attr("id", id)
                                    .find(".toolbar-top")
                                    .append($("<h1></h1>").html(format(options.galleryName, options.defaultIndex + 1, images.length)));
                    
                    if (options.backLink) {
                        toolbar.append(options.backLink)
                    }
                    
                    $.each(images, function(i, image) {
                        var slide = $(image.template || options.slideTemplate),
                            img = slide.find("img").attr("will-src", image.src);//.load(function(){console.log("loaded: "+image.src)})
                        
                        list.append(slide);
                        
                        if (image.current || i == options.defaultIndex) {
                            img.attr("src", image.src).removeAttr("will-src");
							slide.addClass(options.imageCurrentClass);
                        }
                        
                        if (image.caption) {
                            slide.find(".jqt-photo-caption").html(image.title);
                        }
                        
                        if ("width" in image && "height" in image) {
                            var t = img,
                                w = image.width,
                                h = image.height,
                                scale = min(min(w, innerWidth)/w, min(h, innerHeight)/h),
                                width = w * scale,
                                height = h * scale,
                                left = -floor(((width - innerWidth) / scale) / 2),
                                top = -floor(((height - innerHeight) / scale) / 2), 
                                data = {};
                            
                            if (width > innerWidth || height > innerHeight) {
                                t.css({
                                         webkitTransitionDuration: "0",
                                         webkitTransform: format("scale({0}) translate3d({1}px, {2}px, 0)", scale, left, top)
                                    })
                                    .addClass(options.presizedClass)
                                    .data("jqt-photo-info", data);
                                
                                data = data[orientation];
                                data.current.scale = data.original.scale = scale;
                                data.current.left = data.original.left = left;
                                data.current.top = data.original.top = top;
                                data.current.width = data.original.width = width * scale;
                                data.current.height = data.original.height = height * scale;
                            }
                        } else {
                            $(new Image())
                                .css({
                                     position:"absolute",
                                     left:10000,
                                     opacity:0,
                                     display:"block",
                                     maxWidth:"auto",
                                     maxHeight:"auto",
                                     width:"auto",
                                     height:"auto"
                                })
                                .load(function() {
                                    var innerWidth = window.innerWidth,
                                        innerHeight = window.innerHeight,
                                        t = $(this),
                                        w = t.width(),
                                        h = t.height(),
                                        scale = min(min(w, innerWidth)/w, min(h, innerHeight)/h),
                                        width = w * scale,
                                        height = h * scale,
                                        left = -floor(((width - innerWidth) / scale) / 2),
                                        top = -floor(((height - innerHeight) / scale) / 2), 
                                        data;
                                    
                                    if (width > innerWidth || height > innerHeight) {
                                        data = gallery.find(format("img[src='{0}']", this.src))
                                            .css({
                                                 webkitTransitionDuration: "0",
                                                 webkitTransform: format("scale({0}) translate3d({1}px, {2}px, 0)", scale, left, top)
                                            })
                                            .addClass(options.presizedClass)
                                            .data("jqt-photo-info");
                                        
                                        if (data) {
                                            data = data[orientation];
                                            data.current.scale = data.original.scale = scale;
                                            data.current.left = data.original.left = left;
                                            data.current.top = data.original.top = top;
                                            data.current.width = data.original.width = width * scale;
                                            data.current.height = data.original.height = height * scale;
                                        }
                                    }
                                    
                                    t.remove();
                                })
                                .appendTo("body")
                                .attr("src",this.src);
                        }
                    });
                    
                    jqtPhoto(gallery[0], options);
                }
            };
        });
    }
    
    //Orientation event listener bind
    $(window).bind("orientationchange", onorientationchange);
    
    /*
     *
     *    jQuery Extensions
     *
     */
    
    /**
     *    A jQuery prototype extension for enabling the photo gallery
     *    on a given set of elements
     *
     *    @param Object options
     *    @return jQuery
     */
    $.fn.jqtPhoto = function(options) {
        options = $.extend({}, defaults, options || {});
        return this.each(function(){jqtPhoto(this, options)});
    };
    
    /**
     *    A static jQuery extension for setting and retrieving the jQT-Photo defaults
     *
     *    @param Object options - optional
     *    @return Object
     */
    $.jqtPhotoDefaults = function(options) {
        if (options) {
            defaults = $.extend(defaults, options);
        }
        
        return $.extend({}, defaults);
    };
    
    /*
     *
     *    Functions
     *
     */
    
    /**
     *    Intialize the photo gallery
     *
     *    @param Element | String | jQuery element
     *    @param Object options
     *    @return null
     */
    function jqtPhoto (element, options) {
        var $elem = $(element),
            slides = attachEvents($elem, options).find(options.imageSlideSelector),
            images = slides.find(options.imageSelector);
        
        options.slides = slides;
        options.images = images;
        
        $elem.find(options.imageListSelector).css({
            webkitTransitionProperty: options.transitionProperty,
            webkitTransitionTimingFunction: options.timingFunction,
            webkitTransitionDuration: options.defaultDuration,
            webkitTransform: options.defaultTransform
        });
        
        if (!slides.filter("."+options.imageCurrentClass).length) {
            slides.eq(options.defaultIndex).addClass(options.imageCurrentClass);
        }
        
        parseImageData($elem, images, options);
        
        tableData($elem.data("jqt-photo-options", options), options);
        
        galleries = galleries.concat($.makeArray($elem));
        
        return null;
    }
    
    /**
     *    Record the initial start position of the image list element
     *
     *    @param jQuery target
     *    @param Object options
     *    @return null
     */
    function tableData (target, options) {
        var table = target.find(options.imageListSelector),
            transform = window.getComputedStyle(table[0]).webkitTransform,
            matrix = new WebKitCSSMatrix(transform);
        
        table.data("jqt-photo-position", {x:Number(matrix.m41 || 0),gallery:target});
        return null;
    }
    
    /**
     *    Attach event listeners to the gallery
     *
     *    To Do: refractor event listeners into delegate
     *
     *    @param jQuery target
     *    @param Object options
     *    @return jQuery
     */
    function attachEvents (target, options) {
        if ($.jQTouch) {
            target.bind("pageAnimationEnd", options.pageAnimationEnd);
        }
		
		//target.bind("pageAnimationEnd jqt-photo-slideto jqt-photo-goto jqt-photo-play jqt-photo-pause jqt-photo-prev jqt-photo-next jqt-photo-hide-toolbars jqt-photo-show-toolbars jqt-photo-toggle-toolbars", function(e){console.log(e.type)});
        
        return target
                .each(function(){this.addEventListener("touchstart", options.touchStart, false)})
                .bind("jqt-photo-slideto", options.slideTo)
                .bind("jqt-photo-goto", options.goTo)
                .bind("jqt-photo-play", options.play)
                .bind("jqt-photo-pause", options.pause)
                .bind("jqt-photo-prev", options.prev)
                .bind("jqt-photo-next", options.slideTo)
                .bind("jqt-photo-hide-toolbars", options.hideToolbars)
                .bind("jqt-photo-show-toolbars", options.showToolbars)
                .bind("jqt-photo-toggle-toolbars", options.toggleToolbars);
    }
    
    /**
     *    Record initial slide data
     *
     *    @param jQuery images
     *    @param Object options
     *    @return jQuery
     */
    function parseImageData (target, images, options) {
        return images.each(function() {
            var t = $(this).addClass(options.parsedClass),
                matrix = new WebKitCSSMatrix(window.getComputedStyle(this).webkitTransform),
                scale = Number(matrix.m11),
                original = t.data("jqt-photo-info") || {}, 
                c = {
                    scale: scale,
                    top: Number(matrix.m42),
                    left: Number(matrix.m41),
                    width: t.width() * scale,
                    height: t.height() * scale,
                    parent: t.parent()
                };
            
            original[orientation] = {current: c, original: $.extend({}, c)};
            
            t.data("jqt-photo-info", original);
        });
    }
    
    /**
     *    Distributive handling for touchstart events
     *
     *    To Do: refractor to use all event based triggers
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @return Boolean
     */
    function touchStart (e) {
        var target = $(e.target.nodeType == 3 ? e.target.parentNode : e.target), $this = $(this),
            options = $this.data("jqt-photo-options"),
            tt = e.targetTouches;
        
        if (target.is(options.tagNames)) {
            return null;
        }
        //console.log("touchstart: "+e.target);
        if (target.is(options.galleryPlaySelector)) {
            if (!$this.hasClass(options.playingClass) && options.play) {
                return options.play.call(this, e);
            }
            
            return false;
        } else if (target.is(options.galleryPauseSelector)) {
            if ($this.hasClass(options.playingClass) && options.pause) {
                return options.pause.call(this, e);
            }
            
            return false;
        } else if (target.is(options.galleryNextSelector) && options.next) {
            return options.next.call(this, e);
        } else if (target.is(options.galleryPrevSelector) && options.prev) {
            return options.prev.call(this, e);
        } else if (tt.length == 2 && target.closest(options.imageSelector).length && options.scaleStart) {
            if ($this.hasClass(options.playingClass) && options.pause) {
                return options.pause.call(this);
            }
            
            return options.scaleStart.call(this, e);
        } else if (tt.length == 1 && options.dragStart) {
            if ($this.hasClass(options.playingClass) && options.pause) {
                return options.pause.call(this, e);
            }
            
            return options.dragStart.call(this, e);
        }
        
        return true;
    }
        
    /**
     *    Initialize a drag event
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @return Boolean
     */
    function dragStart (e) {
        e.preventDefault();
        window.scrollTo(0,0);
        
        var $this = $(this),
            options = $this.data("jqt-photo-options"),
            table = $this.find(options.imageListSelector).css({webkitTransitionDuration: "0"}),
            position = table.data("jqt-photo-position"),
            target = $(e.target).closest(options.imageSelector),
            data = target.data("jqt-photo-info") || false,
            offset = !!data && data[orientation] || false,
            current = !!offset && offset.current || {},
            tt = e.targetTouches[0];
        
        this.addEventListener("touchmove", options.drag, false);
        this.addEventListener("touchend", options.dragEnd, false);
        
        $this
            .data("jqt-photo-event", {
                table: table,
                position: {current: position.x, original: position.x},
                target: target.css({webkitTransitionDuration: "0"}),
                options: options,
                moved: false,
                x: tt.clientX,
                y: tt.clientY,
                left: current.left || 0,
                top: current.top || 0,
                timeStamp: +new Date
            });
            
        return false;
    }
    
    /**
     *    Perform a drag event
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @return Boolean
     */
    function drag (e) {
        e.preventDefault();
        
        var $this = $(this),
            original = $this.data("jqt-photo-event"),
            table = original.table,
            position = original.position,
            target = original.target,
            info = target.data("jqt-photo-info"),
            data = !!info && info[orientation] || false,
            current = data.current || false,
            tt = e.targetTouches[0],
            distanceX = original.x - tt.clientX,
            distanceY = original.y - tt.clientY,
            w, h, x, y, l, t, d, 
            s = current.scale;
        
        original.moved = true;
        
        //image
        if (data) {
            $this.triggerHandler("jqt-photo-hide-toolbars", [original.options]);
            
            if (distanceX) {
                x = target.width() * s;
                w = current.parent.width();
                l = original.left;
                
                if (x > w) {
                    l -= distanceX / s;
                    distanceX = 0;
                    d = ((x - w) / s) / 2;
                    
                    if (l > d) {
                        distanceX = d - l;
                        l = d;
                    } else if (l < -d) {
                        distanceX = -(l + d);
                        l = -d;
                    }
                }
                
                current.left = floor(l);
            }
            
            if (distanceY) {
                y = target.height() * s;
                h = current.parent.height(),
                t = original.top;
                
                if (y > h) {
                    t -= distanceY / s;
                }
                
                current.top = floor(t);
            }
            
            target.css("webkitTransform", format("scale({0}) translate3d({1}px, {2}px, 0)", s, current.left, current.top));
        }
        
        //table
        position.current = position.original - distanceX;
        table.css("webkitTransform", format("translate3d({0}px, 0, 0)", position.current));
        
        return false;
    }
    
    /**
     *    End and clean up a drag event
     *
     *
     *    To Do: refractor for options.slides usage
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @return Boolean
     */
    function dragEnd (e) {
        var $this = $(this),
            original = $this.data("jqt-photo-event"),
            table = original.table,
            tablePosition = table.data("jqt-photo-position"),
            position = original.position,
            target = original.target,
            info = target.data("jqt-photo-info"),
            data = !!info && info[orientation] || false,
            current = data.current || false,
            slides = original.options.slides,
            h, x, y, t, d, n, w,
            s = current.scale;
        
        this.removeEventListener("touchmove", original.options.drag, false);
        this.removeEventListener("touchend", original.options.dragEnd, false);
        
        if (!original.moved) {
            original.options.toggleToolbars.call(this, {}, original.options);
            return dispatchClick(e.target);
        }
        
        e.preventDefault();
        
        //image
        if (data) {
            y = target.height() * s;
            h = current.parent.height(),
            t = current.top;
            
            if (y > h) {
                d = ((y - h) / s) / 2;
                
                if (t > d) {
                    t = d;
                } else if (t < -d) {
                    t = -d;
                }
            }
            
            current.top = floor(t);
            
            target.css({
                webkitTransitionDuration: original.options.scaleSpeed + "ms",
                webkitTransform: format("scale({0}) translate3d({1}px, {2}px, 0)", s, current.left, current.top)
            });
        }
        
        d = (+new Date() - original.timeStamp);
        
        //table
        if (position.current > 0) {
            tablePosition.x = 0;
        } else if (position.current < (slides.eq(slides.length-1).width() - table.outerWidth())) {
            tablePosition.x = (slides.eq(slides.length-1).width() - table.outerWidth());
        } else
        {
            n = tablePosition.x < position.current ? -1 : 1;
            x = slides.filter("."+original.options.imageCurrentClass);
            t = abs(x.offset().left + position.current);
            w = x.width() / 3;
            
            if (t > w) {
                return slideTo.call(this, e, slides.index(x[0]) + n, (d > 1000 ? 1000 : d), original.options, slides);
            }
        }
        
        table.css({
            webkitTransitionDuration: (d > 1000 ? 1000 : d) + "ms",
            webkitTransform: format("translate3d({0}px, 0, 0)", tablePosition.x)
        });
        
        return false;
    }
    
    /**
     *    Initialize a scaling event
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @return Boolean
     */
    function scaleStart (e) {
        e.preventDefault();
        window.scrollTo(0,0);
        
        var $this = $(this),
            options = $this.data("jqt-photo-options"),
            tt = e.targetTouches;
        
        this.addEventListener("touchmove", options.scale, false);
        this.addEventListener("touchend", options.scaleEnd, false);
        try{
            this.removeEventListener("touchmove", options.drag, false);
            this.removeEventListener("touchend", options.dragEnd, false);
        }catch(e){}
        
        $this.data("jqt-photo-event", {
                target: $(e.target).closest(options.imageSelector).css("webkitTransitionDuration", "0"),
                options: options,
                distance: sqrt(
                    pow((tt[1].clientX - tt[0].clientX), 2)
                    + pow((tt[1].clientY - tt[0].clientY), 2)
                )
            })
            .find(".image-list")
            .css("webkitTransitionDuration", "0");//end any transform on this table
            
        return false;
    }
    
    /**
     *    Perform a scaling event
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @return Boolean
     */
    function scale (e) {
        e.preventDefault();
        
        var $this = $(this),
            original = $this.data("jqt-photo-event"),
            target = original.target,
            info = target.data("jqt-photo-info"),
            data = !!info && info[orientation] || false,
            tt = e.targetTouches,
            distance = sqrt(
                pow((tt[1].clientX - tt[0].clientX), 2) +
                pow((tt[1].clientY - tt[0].clientY), 2)
            ),
            difference = distance - original.distance,
            percentChange = (difference / original.distance) / 2,
            current = data.current,
            transform;
        
        if (!current) {
            return;
        }
        
        $this.triggerHandler("jqt-photo-hide-toolbars", [original.options]);
        
        transform = format("scale({0}) translate3d({1}px, {2}px, 0)", 
                        (current.scale = (current.scale + (current.scale * percentChange))), 
                        current.left, 
                        current.top                        
                   );
        
        original.distance = distance;
            
        target.css("webkitTransform", transform);
        
        return false;
    }
    
    /**
     *    End a scaling event
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @return Boolean
     */
    function scaleEnd (e) {
        e.preventDefault();
        
        var $this = $(this),
            original = $this.data("jqt-photo-event"),
            target = original.target,
            info = target.data("jqt-photo-info"),
            data = !!info && info[orientation] || false,
            current = data.current;
        
        this.removeEventListener("touchmove", original.options.scale, false);
        this.removeEventListener("touchend", original.options.scaleEnd, false);
        
        if (!current) {
            return;
        }
        
        if (current.scale < data.original.scale) {
            current.scale = data.original.scale;
            current.left = data.original.left;
            current.top = data.original.top;
        }
        
        target.css({
            webkitTransitionDuration: original.options.scaleSpeed + "ms",
            webkitTransform: format("scale({0}) translate3d({1}px, {2}px, 0)", current.scale, current.left, current.top)
        });
        
        return false;
    }
    
    /**
     *    Dispatch a click event on a given target, in the event 
     *    a single-target touch event did not result in movement
     *
     *    @param Element target
     *    @return Boolean
     */
    function dispatchClick (target) {
        var theEvent = target.ownerDocument.createEvent("MouseEvents");
        theEvent.initEvent("click", true, true);
        target.dispatchEvent(theEvent);
        return true;
    }
    
    /**
     *    Begin a slideshow
     *
     *    To Do: refractor for options.slides usage
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @param Number index
     *    @return Boolean
     */
    function play (e, index) {
        e.preventDefault && e.preventDefault();
        
        var $this = $(this),
            options = $this.data("jqt-photo-options"),
            slides = $this.find(options.imageSlideSelector),
            n = index === undefined || index < 0 
                ? slides.index(slides.filter("."+options.imageCurrentClass)[0])
                : abs(index);
        addHover($this, $this.find(options.galleryPauseSelector)[0]);
        $this.addClass(options.playingClass);
        
        if (n != index) {
            options.slideTo.call(this, {}, n, 0);
        }
        
        $this.data("jqt-photo-slide-timer", setInterval(function(){slideInterval($this, slides, options)}, options.slideDelay))
            .addClass(options.playingClass);
        
        return false;
    }
    
    /**
     *    Handler for slideshow intervals
     *
     *
     *    To Do: refractor for options.slides usage
     *
     *    @param jQuery target
     *    @param jQuery slides
     *    @param Object options
     *    @return null
     */
    function slideInterval (target, slides, options) {
        //current index + 1
        var index = slides.index(slides.filter("."+options.imageCurrentClass)[0]) + 1;
        
        if (index === slides.length) {
            index = 0;
        }
        
        options.slideTo.call(target[0], {}, index, options.scrollSpeed, options, slides);
        
        target.triggerHandler("jqt-photo-hide-toolbars", [options]);
        
        return null;
    }
    
    /**
     *    End a slideshow
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @return Boolean
     */
    function pause (e) {
        e.preventDefault && e.preventDefault();
        
        var $this = $(this), 
            timer = $this.data("jqt-photo-slide-timer"), 
            options = $this.data("jqt-photo-options");
			
        addHover($this, $this.find(options.galleryPlaySelector)[0]);
		
        clearInterval(timer);
        $this.removeClass(options.playingClass).data("jqt-photo-slide-timer", null);
        
        return false;
    }
    
    /**
     *    Perform a slide to a given, or inferred next slide, using the data provided
     *
     *
     *    To Do: refractor for options.slides usage
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @param Number index
     *    @param Number duration
     *    @param Object options
     *    @param jQuery slides
     *    @return Boolean
     */
    function slideTo (e, index, duration, options, slides) {
        e.preventDefault && e.preventDefault();
        
        var $this = $(this), table, current, title, last, next;
        
        options = options || $this.data("jqt-photo-options");
        
        slides = slides || $this.find(options.imageSlideSelector);
        
        table = $this.find(options.imageListSelector);
        
        index = index || 0;
        //how long should this particular transition take?
        duration = duration === undefined || duration < 0 ? options.scrollSpeed : (Number(duration) || 0);
        
        if (index >= slides.length) {
            index = 0;
        }
        
        if (index < 0) {
            index = slides.length + index;
        }
        
		last = slides.filter("."+options.imageCurrentClass).find(options.imageSelector);
		
        //new current
        current = slides.removeClass(options.imageCurrentClass).eq(index);
        //new position
        position = -(current.addClass(options.imageCurrentClass)[0].offsetLeft);
		
		next = slides.eq(index + 1).find(options.imageSelector);
		prev = slides.eq(index - 1).find(options.imageSelector);
		
		if (next.length && next.attr("will-src")) {
			next.attr("src", next.attr("will-src")).removeAttr("will-src");
		}
		
		if (prev.length && prev.attr("will-src")) {
			prev.attr("src", prev.attr("will-src")).removeAttr("will-src");
		}
		
		if (current.length && current.find(options.imageSelector).attr("will-src")) {
			current.find(options.imageSelector)
				.attr("src", current.find(options.imageSelector).attr("will-src"))
				.removeAttr("will-src");
		}
        
        if (position > 0) {
            position = 0;
        } else if (position < -(table.width()-current.width())) {
            position = -(table.width()-current.width());
        }
        
        //title element
        title = $this.find(options.toolbarTitleSelector);
        //trigger slide change event
        $this.trigger("jqt-photo-slide-change", [index, duration, position]);
        //save the position
        table.data("jqt-photo-position").x = position;
        //atach animation end listener, and set necessary css properties
        table.one("webkitTransitionEnd", function(){resetDimensions(last)}).css({
            webkitTransitionDuration: duration+"ms",
            webkitTransform: format("translate3d({0}px, 0, 0)", position)
        });
        //update the title of the gallery
        title.html(format(options.galleryName || title.html(), index+1, slides.length));
        
        return false;
    }
    
    /**
     *    Jump to a given, or inferred next slide, using the data provided
     *
     *
     *    To Do: refractor for options.slides usage
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @param Number index    - optional; index of the slide to go to
     *    @param Number duration - optional; duration of the transition
     *    @param Object options - optional; the options associated with the gallery
     *    @param jQuery slides - optional; easier access
     *    @return Boolean
     */
    function goTo (e, index, duration, options, slides) {
        e.preventDefault && e.preventDefault();
        
        var $this = $(this), table, current, title, last, next, prev;
        
        options = options || $this.data("jqt-photo-options");
        
        slides = slides || $this.find(options.imageSlideSelector);
        
        table = $this.find(options.imageListSelector);
        
        index = index || 0;
        
        if (index >= slides.length) {
            index = 0;
        }
        
        if (index < 0) {
            index = slides.length + index;
        }
        
		last = slides.filter("."+options.imageCurrentClass).find(options.imageSelector);
		
        //new current
        current = slides.removeClass(options.imageCurrentClass).eq(index);
        //position of the new current
        position = -(current.addClass(options.imageCurrentClass)[0].offsetLeft);
		
		next = slides.eq(index + 1).find(options.imageSelector);
		prev = slides.eq(index - 1).find(options.imageSelector);
		
		if (next.length && next.attr("will-src")) {
			next.attr("src", next.attr("will-src")).removeAttr("will-src");
		}
		
		if (prev.length && prev.attr("will-src")) {
			prev.attr("src", prev.attr("will-src")).removeAttr("will-src");
		}
		
		if (current.length && current.find(options.imageSelector).attr("will-src")) {
			current.find(options.imageSelector)
				.attr("src", current.find(options.imageSelector).attr("will-src"))
				.removeAttr("will-src");
		}
        
        if (position > 0) {
            position = 0;
        } else if (position < -(table.width()-current.width())) {
            position = -(table.width()-current.width());
        }
        //title element
        title = $this.find(options.toolbarTitleSelector);
        //save the position
        table.data("jqt-photo-position").x = position;
        //reset scales after slide and set css to cause the slide
        table.css({
            webkitTransitionDuration: "0",
            webkitTransform: format("translate3d({0}px, 0, 0)", position)
        });
		resetDimensions(last);
        //resetScales.call(table[0]);
        //update the title
        title.html(format(options.galleryName || title.html(), index+1, slides.length));
        
        return false;
    }
    
    /**
     *    Reset the transform after an orientation change
     *    to ensure that the slides are correctly aligned
     *
     *
     *    To Do: refractor for options.slides usage
     *
     *    @param jQuery galleries
     *    @return jQuery
     */
    function alignSlides (galleries) {
        return galleries.each(function() {
            var $this = $(this),
            options = $this.data("jqt-photo-options"),
            slides = $this.find(options.imageSlideSelector),
            table = $this.find(options.imageListSelector),
            current = slides.filter("."+options.imageCurrentClass),
            position = -(current.offset().left);
                
            table.data("jqt-photo-position").x = position;
            
            table.css({
                webkitTransitionDuration: "0",
                webkitTransform: format("translate3d({0}px, 0, 0)", position)
            });
        });
    }
    
    /**
     *    Transition to previous slide (or last slide) in gallery
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @return Boolean
     */
    function prev (e) {
        e.preventDefault && e.preventDefault();
        
        var $this = $(this),
            options = $this.data("jqt-photo-options"),
            slides = options.slides;
           
		addHover($this, e.target);
		   
        return options.goTo.call(this, {}, slides.index(slides.filter("."+options.imageCurrentClass)[0])-1);
    }
    
    /**
     *    Transition to next slide (or first slide) in gallery
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @return Boolean
     */
    function next (e) {
        e.preventDefault && e.preventDefault();
        
        var $this = $(this),
            options = $this.data("jqt-photo-options"),
            slides = options.slides;
            
        addHover($this, e.target);
		
		return options.goTo.call(this, {}, slides.index(slides.filter("."+options.imageCurrentClass)[0])+1);
    }
    
    /**
     *    Trigger an animation to slide up/slide down the toobars on a given gallery
     *    using a predetermined class
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @param Object options
     *    @return null
     */
    function toggleToolbars (e, options) {
        if (e && e.target && e.target.tagName === "A") {
            return null;
        }
        
        var gallery = $(this);
        
        options = options || gallery.data("jqt-photo-options");
        
        if (gallery.hasClass(options.toolbarHideClass)) {
            gallery.triggerHandler("jqt-photo-show-toolbars", [options]);
        } else
        {
            gallery.triggerHandler("jqt-photo-hide-toolbars", [options]);
        }
        return null;
    }
    
    /**
     *    Trigger an animation to slide up the toobars on a given gallery
     *    using a predetermined class
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @param Object options
     *    @return null
     */
    function hideToolbars (e, options) {
        var gallery = $(this);
        
        options = options || gallery.data("jqt-photo-options");
        
        if (!gallery.hasClass(options.toolbarHideClass)) {
            gallery.one("webkitTransitionEnd",function() {
                gallery.addClass(options.toolbarHideClass)
                    .removeClass(options.toolbarAnimationOutClass);
            })
            .addClass(options.toolbarAnimationOutClass);
        }
        return null;
    }
    
    /**
     *    Trigger an animation to slide down the toobars on a given gallery
     *    using a predetermined class
     *
     *
     *    @context The gallery element
     *
     *    @param Event e
     *    @param Object options
     *    @return null
     */
    function showToolbars (e, options) {
        var gallery = $(this);
        
        options = options || gallery.data("jqt-photo-options");
        
        if (gallery.hasClass(options.toolbarHideClass)) {
            gallery.one("webkitTransitionEnd",function() {
                gallery.removeClass(options.toolbarAnimationInClass);
            })
            .addClass(options.toolbarAnimationInClass)
            .removeClass(options.toolbarHideClass);
        }
        return null;
    }
    
    /**
     *
     *
     *
     *
     */
    function pageAnimationStart (e, info) {
        if (info && info.direction == "in") {
            var $this = $(this),
                options = $this.data("jqt-photo-options"),
                slides = $this.find(options.imageSlideSelector),
                index = slides.index("."+options.imageCurrentClass);
            
            options.goTo.call(this, {}, index > -1 ? index : options.defaultIndex, 0, options, slides);
            $(this).triggerHandler("jqt-photo-show-toolbars");
        }
    }
    
    /**
     *
     *
     *
     *
     */
    function pageAnimationEnd (e, info) {
        if (info && info.direction == "out") {
            var $this = $(this),
                options = $this.data("jqt-photo-options"),
                slides = $this.find(options.imageSlideSelector),
                images = slides.filter("."+options.imageCurrentClass).find(options.imageSelector);
            
            options.goTo.call(this, {}, options.defaultIndex, 0, options, slides);
            resetDimensions(images);
        }
    }
    
    /**
     *    Event handler used to reset the dimensions of the images in an
     *    associated gallery after a transition event has fired
     *
     *
     *    To Do: refractor for options.slides usage
     *
     *    @context The slide list element
     *
     *    @return null
     */
    function resetScales () {
        var $this = $(this),
            options = $this.data("jqt-photo-position").gallery.data("jqt-photo-options");
            
        resetDimensions($this.find(options.imageSlideSelector).filter("."+options.imageCurrentClass).find(options.imageSelector));
        return null;
    }
    
    /**
     *    Reset the scale and position of the given slides
     *
     *    @param jQuery images
     *    @return jQuery
     */
    function resetDimensions (images) {
        return images.each(function(i) {
            var t = $(this),
                d = t.data("jqt-photo-info")[orientation];
            
            t.css({
                webkitTransitionDuration: "0", 
                webkitTransform: format("scale({0}) translate3d({1}px, {2}px, 0)", 
                                        d.current.scale = d.original.scale,
                                        d.current.left = d.original.left,
                                        d.current.top = d.original.top
                                 )
            });
            
            d.current.width = d.original.width;
            d.current.height = d.original.height;
            
            return null;
        });
    }
    
    /**
     *    
     *
     *    @return String
     */
    function addHover (gallery, element) {
        $(element).addClass("hover")
		gallery.one("touchend", function(){$(element).removeClass("hover")});
    }
    
    /**
     *    Generate a new string suitable for use as an id attribute
     *
     *    @return String
     */
    function newId () {
        return format("jqt-photo-{0}", +new Date);
    }
    
    /**
     *    Format a String followed by a set of arguments using the format
     *    {0} is replaced with arguments[1]
     *
     *    @param String s
     *    @param Object arg1 ... argN
     *    @return String
     */
    function format (s) {
        var args = arguments;
        return s.replace(/\{(\d+)\}/g, function(a,b){return args[Number(b)+1] + ""});
    }
    
    /**
     *    window.onorientationchange event handler updates all slide data for the new orientation
     *    (if it doesn't already exist) and resets the scale of the images
     *
     *    @return null
     */
    function onorientationchange () {
        var g = $(galleries), current,
            slides, images = [],
            playing = [];
        
        orientation = abs(window.orientation) == 90 ? "landscape" : "portrait";
        
        g.each(function() {
            var $this = $(this), options = $this.data("jqt-photo-options");
            if ($this.hasClass(options.playingClass)) {
                playing.push(this);
                $this.triggerHandler("jqt-photo-pause");
            }
            images = images.concat($.makeArray($this.find(options.imageSlideSelector).find(options.imageSelector)));
        });
        
        slides = $(images);
        
        if (!slides.data("jqt-photo-info")[orientation]) {
            parseImageData(null, slides, defaults);
        }
                
        resetDimensions(slides);
        
        //make sure the slides line up appropriately, use delay to ensure repaint has passed
        setTimeout(function(){alignSlides(g);$(playing).triggerHandler("jqt-photo-play");},50);
        
        return null;
    }
    
    $(function() {
        window.scrollTo(0,0);
		var stringRules = "", 
            rules = cssRules, 
            o = window.innerHeight > window.innerWidth ? "portrait" : "landscape",
            buildProperties = function (name, value) {
                stringRules += name + ":" + ($.isFunction(value) ? value(rules.variables) : value) + ";";
            },
            buildRules = function (name, properties) {
                stringRules += name + "{";
                
                $.each(properties, buildProperties);
                
                stringRules += "}";
            };
        
        $.each(rules.defaults, buildRules);
        $.each(rules[o], buildRules);
        
        
        $(document.createElement("style"))
            .attr({type:"text/css",media:"screen"})
            .html(stringRules)
            .appendTo("head");
        
        $(window).one("orientationchange", function () {
            //ensure repaint
            setTimeout(function () {
                window.scrollTo(0,0);
				stringRules = "";
                
                $.each(rules[window.innerHeight > window.innerWidth ? "portrait" : "landscape"], buildRules);
                
                $(document.createElement("style"))
                    .attr({type:"text/css",media:"screen"})
                    .html(stringRules)
                    .appendTo("head");
            },30)
        });
    });
    
})(jQuery);
