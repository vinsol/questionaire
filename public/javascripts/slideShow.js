$(document).ready(function(){
  var a = $(".show_question")
  for(var i = 0; i<a.length; i++) {
    $(a[i]).bind('click', function(){
      $(this).children().next().slideToggle("fast");
    })
  }
});
