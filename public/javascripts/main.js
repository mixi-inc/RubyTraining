$(document).ready(function(){
    var wrappingPoints = ["h1", "h2", "h3", "h4", "h5", "h6"];

    wrappingPoints.forEach(function(element){
        $(element).each(function(){
            $(this).nextUntil(element).wrapAll('<section class="hints"></section>');
        });
    });

    $("h5").click(function(){
        $(this).next().toggle();
    });

});