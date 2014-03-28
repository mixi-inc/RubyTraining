$(document).ready(function(){

    implementNav('h3');

    var wrappingPoints = ["h1", "h2", "h3", "h4", "h5", "h6"];

    wrappingPoints.forEach(function(elementName){
        $(elementName).each(function(index){
            $(this).nextUntil(elementName).wrapAll('<section class="hints"></section>');
        });
    });

    $("h3").each(function(index){
        $(this).attr("data-content", (index + 1) + ". ")
    });

    $("h5").click(function(){
        $(this).next().toggle();
    });

    function implementNav(elementName) {
        var sidebar = $(".question-list");

        $(elementName).each(function(index){
            $(this).attr("id", elementName + "-" + index);
            sidebar.append('<li><a href="#' + elementName + '-'+ index +'">' + $(this).text() + "</a></li>")
        });
    }

});