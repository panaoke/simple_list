$(function() {
    $('form.simple_list_form').on('submit', function (e, successCall, errorCall) {
        e.preventDefault();
        var $self = $(this);
        $self.ajaxSubmit(function(data) {
            console.log(data);
            if(data.is_success == true) {
                if(successCall != undefined) {
                    successCall()
                }
                $(e.target).trigger('submitSuccess');
            }else {
                bootbox.alert(data.error_infos.join("<br>"))
            }

        }, function() {
            if(errorCall != undefined) {
                errorCall()
            }
        });

        return false;
    });
});