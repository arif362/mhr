$(function(){
    $('#new-discussion-not-login, #new-comment-not-login').click(function(){
        var $this = $(this),
            $toElement      = $this.attr('data-scroll-to'),
            $focusElement   = $this.attr('data-scroll-focus'),
            $offset         = $this.attr('data-scroll-offset') * 1 || 0,
            $speed          = $this.attr('data-scroll-speed') * 1 || 500;

        $('html, body').animate({
            scrollTop: $($toElement).offset().top + $offset
        }, $speed);

        if ($focusElement) {
            $($focusElement).focus();
            $($toElement).find('.community-form').addClass('community-form-focus-border');
        }
        popupMessage($(this).attr('data-message'),'alert-warning');

    });
    $('.community-form').on('click focus blur',function(e){
        $(this).removeClass('community-form-focus-border');
    });
});