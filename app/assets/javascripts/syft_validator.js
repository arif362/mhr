var style = document.createElement('style');
style.type = 'text/css';
style.innerHTML = '.danger-class { border-color: #a94442; }';
document.getElementsByTagName('head')[0].appendChild(style);

function dataRequired(scopeArea){
    return scopeArea.val();
}


(function($){
    $.fn.syftValidator = function(){

        var validatingkeys = ['data-required'];
        var validateCheckingKeys = {
            'data-required': 'dataRequired'
        }

        var validationMessage = {
            'data-required': "This is a required field."
        }

        function attrMaker(){
            var attrs = "";
            $.each(validatingkeys,function(key, value){
                if (key == 0){
                    attrs += '['+ value + ']';
                }
                else{
                    attrs += ', ['+ value + ']';
                }
            });
            return attrs;
        }

        function removeExistingMessage(scopeArea){
            scopeArea.parents('.input-validate-message-area').find('.helper-text').remove();
            scopeArea.removeClass('danger-class');
            scopeArea.next('.helper-text').remove();
        }

        function dataMessageElementGenerator(message){
            return " <div class='helper-text'>" +
                "<p style='color: #a94442; margin: 0 !important;'>"
                    + message +
                    "</p>"+
                "</div>";
        }

        function dataMessage(scopeArea, rule){
            return scopeArea.attr('data-message') ? dataMessageElementGenerator(scopeArea.attr('data-message')) : dataMessageElementGenerator( validationMessage[rule]);
        }

        function putMessage(scopeArea, message, operation){
            if(operation){
                scopeArea.append(message);
            }
            else{
                scopeArea.after(message);
            }
        }

        function checkMessageArea(scopeArea){
            return scopeArea.parents('.input-validate-message-area');
        }

        function validatingRules(scopeArea){
            var validateFiled = false;
            $.each(validatingkeys, function(key, value){
                if(scopeArea.attr(value) && !window[validateCheckingKeys[value]](scopeArea)){
                    removeExistingMessage(scopeArea);
                    scopeArea.addClass('danger-class')
                    checkMessageArea(scopeArea).length > 0 ? putMessage(checkMessageArea(scopeArea), dataMessage(scopeArea, value), true) : putMessage(scopeArea, dataMessage(scopeArea, value), false);
                    validateFiled = true;
                }
            });

            return validateFiled;
        }

        function isValidForSubmit(scopeArea){
            var isValid = true;
            console.log(scopeArea.find(attrMaker()));
            scopeArea.find(attrMaker()).each(function(){
                if(validatingRules($(this))){
                    isValid = false
                }
                else{
                    removeExistingMessage($(this));
                }
            });
            return isValid;
        }

        this.submit(function(e){

            if(!isValidForSubmit($(this))){
                e.preventDefault();
                e.stopPropagation();
            };
        });
        return this;
    };
}(jQuery));
