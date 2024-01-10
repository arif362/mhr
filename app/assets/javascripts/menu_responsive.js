$(window).resize(function () {
    menuResponsive();
});

$(function () {
    menuResponsive();

    $('.toggle-menu-bar').click(function () {
        element = $(this);
        icon = element.find('i');
        element.next().toggleClass('toggle-menu-hide');
        if (icon.hasClass('fa-bars')) {
            icon.removeClass('fa-bars').addClass('fa-times');
        }
        else {
            icon.removeClass('fa-times').addClass('fa-bars');
        }
        return false;
    });
});

function menuResponsive() {
    var main_menu = $('.expand-menu-items');
    var sub_menus = main_menu.find('> li').removeClass('hide');
    var menu_length = main_menu.width() - 370;
    var fit_index = 0, total_element_width = 0;
    var menu_items = sub_menus.length;
    sub_menus.each(function (indx, elemt) {
        element = $(elemt);
        total_element_width += element.width();
        if (total_element_width < menu_length) {
            fit_index = (indx + 1);
        }
    });
    console.log(fit_index, menu_items);
    float_menu = $('.float-menu-handler');
    if (fit_index != menu_items) {
        dropdown_menu = createDropDown(fit_index, menu_items, sub_menus);

        if (float_menu.length > 0) {
            float_menu.html(dropdown_menu);
        }
        else {
            main_menu.append("<div class='float-menu-handler'>" + dropdown_menu + "</div>");
        }
    }
    else {
        if (float_menu.length > 0) {
            float_menu.remove();
        }
    }
}

function createDropDown(index, total, sub_menus) {
    var popmenu = "";
    for (var i = index; i < total; i++) {
        sub_element = $(sub_menus[i]);
        popmenu += sub_element[0].outerHTML;
        sub_element.addClass('hide');
    }
    return '<ul>' + popmenu + '</ul>';
}