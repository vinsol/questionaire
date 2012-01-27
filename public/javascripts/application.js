// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function view_all_tags(link) {
  $('#tag_view').css('overflow','auto');
  $('#tag_view').css('max-height', '182px');
  $('#view_all_tags').css('display','none');
}

$(document).ready( function() {

  function map_tags_and_type() {
    var ques_tags = $(".as-selection-item");
    var tags = [];
    for(var i = 0;i < ques_tags.length; i++) {
      tags.push($(ques_tags[i]).text().slice(1));
    }
    $("#as-values-tags").val(tags);
  }

  function get_type() {
    var types = $("input[name$='[type]']");
    for(var i = 0; i <= types.length; i++) {
      if($(types[i]).attr('checked') == 'checked') {
        return $(types[i]).val();
      }
    }
  }

  $("#question_submit").bind('click', map_answers);
  $("#question_submit").bind('click', destroy_waste_options);

  function map_answers() {
    if(get_type() == "MultipleChoice") {
      var ans = $("input[name='answer']");
    } else if(get_type() == "MultipleChoiceAnswer") {
      var ans = $("input[id^='answer_']");
    }
    for(var i = 0; i<= ans.length; i++) {
      if($(ans[i]).is(':checked')) {
        var val = $(ans[i]).attr('value');
        $('#question_options_attributes_'+val+'_answer').attr('value', true);
      }
    }
  }

  function destroy_waste_options() {
    if(get_type() != "Subjective") {
      var hidden_ids = $("input[id^='question_options_'][id$='_id'][type='hidden']");
      for(var i = 0; i < hidden_ids.length; i++) {
        var body = hidden_ids[i].id.replace("id", "body");
        if($('#'+body).val() == "") {
          var destroy_id = body.replace("body", "_destroy");
          $('#'+destroy_id).val("1");
        }
      }
    }
  }

});

function ques_validations() {
  var val = [];
  var c = false;
  var d = false;
  var e = false;
	var f = false;
	var g = false;
	
	// Optimize is possible
	// Validation for question paper name field
  if($("#name").val() == "") {
    $("#error1").html("can't be blank");
    var c = true;
  } else {
    $("#error1").html("");
  }
  // Validation for question paper name field
  if($("#instructions").val() == "") {
    $("#error4").html("can't be blank");
    var f = true;
  } else {
    $("#error4").html("");
  }
  
	// Set number should be integer
  if($("#sets").val() == "") {
    $("#error2").html("can't be blank");
    d = true;
  } else if(!($("#sets").val().match(/^\d+$/))) {
    $("#error2").html("number expected");
    d = true;
  } else if($("#sets").val() < 1) {
    $("#error2").html("number > 0 expected");
    d = true;
  } else {
    $("#error2").html("");
  }
  
  if ($("#category_id_").val() == "") {
    $("#error5").html("Please select a category");
    g = true;
  } else {
    $("#error5").html("");
  }
  
	// Question level should be integer
  var ques_level = $("input[id^='level_']");
  var level = [];
  for(var i = 0; i < ques_level.length; i++) {
    if(ques_level[i].value != "") {
      if(ques_level[i].value.match(/^\d+$/)) {
        $("#error3").html("");
      } else {
        $("#error3").html("number expected");
        e = true;
      }
    }
  }
  
  if(c || d || e || f || g) {
    return false
  }

  var ques_tags = $(".as-selection-item");
  var tags = []
  for(var i = 0;i < ques_tags.length; i++) {
    tags.push($(ques_tags[i]).text().slice(1));
  }
  $("#as-values-tags").val(tags)
}
