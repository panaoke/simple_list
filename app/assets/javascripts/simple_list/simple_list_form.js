$(function() {

    $('form.simple_list_form').on('submit', function (e, successCall, errorCall) {
        e.preventDefault();
        var $self = $(this);
        $self.ajaxSubmit(function(data) {
            if(data.is_success == true) {
                if(successCall != undefined) {
                    successCall()
                }
                $(e.target).trigger('submitSuccess');
            }else {
                bootbox.alert(
                    {
                        className: 'alert-dialog',
                        message: data.error_infos.join("<br>"),
                        callback: function() {
                            $self.addClass('active');
                        }
                    }
                )
            }
        }, function() {
            isLoading = false;
            if(errorCall != undefined) {
                errorCall()
            }
        });

        return false;
    });

}, jQuery);