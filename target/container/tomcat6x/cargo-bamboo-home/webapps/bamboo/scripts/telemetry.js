var BAMBOO = window.BAMBOO || {};
BAMBOO.TELEMETRY = {
    refreshDelay: 30000,
    refreshDelayOnError: 30000
};

BAMBOO.TELEMETRY.refresh = function () {
    jQuery.ajax({
        url: document.location.href,
        cache: false,
        data: {
            decorator: 'rest',
            confirm: 'true'
        },
        dataType: 'html',
        error: function (xhr, textStatus) {
            if (!jQuery('#error-blanket').length) {
                jQuery(document.body).append('<div id="error-blanket"></div><div id="error-refreshing">An error occurred while refreshing the wallboard. Trying again soon&hellip;</div>');
            }
            setTimeout(BAMBOO.TELEMETRY.refresh, BAMBOO.TELEMETRY.refreshDelayOnError);
        },
        success: function (data) {
            jQuery(document.body).html(data);
            BAMBOO.TELEMETRY.addSpinners();
            setTimeout(BAMBOO.TELEMETRY.refresh, BAMBOO.TELEMETRY.refreshDelay);
        }
    });
};

BAMBOO.TELEMETRY.addSpinners = function () {
    $('.spinner').each(function (i) {
        spinner(this.id, 10, 15, 10, 4, "#FFF");
    });
};

(function ($) {
    $('.build.').live('click', function (e) {
        var $details = $(this).find('.details-ext');
        $details[( $details.is(':visible') ? 'fadeOut' : 'fadeIn' )]();
    });
    
    setTimeout(BAMBOO.TELEMETRY.refresh, BAMBOO.TELEMETRY.refreshDelay);

    $(function ($) {
        BAMBOO.TELEMETRY.addSpinners();
    });
})(jQuery);