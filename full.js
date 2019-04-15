$(function () {
    var effects = 'animated rubberBand';
    var effectsEnd = 'animationend oAnimationEnd mozAnimationEnd webkitAnimationEnd';
    var jump = function () {
        $(this).addClass(effects).one(effectsEnd, function () {
            $(this).removeClass(effects);
        });
    };
    $('.tile1').hover(jump);
    $('.tile2').hover(jump);
    $('.tile3').hover(jump);
    $('.tile4').hover(jump);
    $('.tile5').hover(jump);
    $('.kontakt').hover(jump);
    $('.usos').hover(jump);
    $('.fb').hover(jump);
    $('.insta').hover(jump);
    $('.processingBox').hover(jump);
    $('.rhinoDown').hover(jump);

})
