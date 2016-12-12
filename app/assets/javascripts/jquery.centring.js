jQuery.fn.center = function () {
    this.css("position","absolute");
    this.css("top",  Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2)   + $(window).scrollLeft()) + "px");
    this.css("margin-top", 0);
    this.css("margin-left", 0);
    return this;
}
