$(document).ready(function(){

    implementNav('h2');

    var wrappingPoints = ["h1", "h2", "h3", "h4", "h5", "h6"];

    wrappingPoints.forEach(function(elementName){
        $(elementName).each(function(index){
            $(this).nextUntil(elementName).wrapAll('<section></section>');
        });
    });

    $("h5").click(function(){
        $(this).next().toggle();
    });

    function implementNav(elementName) {
        var sidebar = $(".question-list");

        $(elementName).each(function(index){
            var text = $(this).text()
            $(this).text((index + 1) + '. ' + text)
            $(this).attr("data-content", (index + 1) + ". ")
            $(this).attr("id", elementName + "-" + index);
            sidebar.append('<li><a href="#' + elementName + '-'+ index +'">' + text + "</a></li>")
        });
    }

});
