$(document).ready(function () {
    $('form#access_right select').on('change', function () {
        $(this).parent().next().children('.fa-check').addClass('hidden');
        $(this).parent().next().children('.fa-spin').removeClass('hidden');
        $('form#access_right').submit();
    });
});