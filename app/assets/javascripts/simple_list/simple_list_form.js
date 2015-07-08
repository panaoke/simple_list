$(function() {
    $('form.simple_list_form').on('submit', function (e, successCall, errorCall) {
        e.preventDefault();
        var $self = $(this);
        $self.ajaxSubmit(function() {
            if(successCall != undefined) {
                successCall()
            }
            $(e.target).trigger('submitSuccess');
        }, function() {
            if(errorCall != undefined) {
                errorCall()
            }
        });

        return false;
    });
});