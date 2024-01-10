(function($){
    $.fn.attachmentPreview = function(){
        this.on('click', function(){
            var iFrameContent = '<iframe src="" class="attachment-content"  width="700" height="600"></iframe>'
            var imageContent = '<img class="attachment-content">'
            var contentForPreview = $(this).attr('data-content');
            if(contentForPreview.match(/\.pdf$/i)){
                $('#attachment-wrapper').css('display','block');
                $('#attachment-content').html($(iFrameContent).attr('src', contentForPreview));
            }
            else{
                $('#attachment-wrapper').css('display','block');
                $('#attachment-content').html($(imageContent).attr('src', contentForPreview));
            }
        });
        $('#attachment-wrapper')
            .find('.attachment-close')
            .on('click', function(){
                $('#attachment-wrapper').css('display', 'none');
            });

        return this;
    };
}(jQuery));
