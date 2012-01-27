function paging(page_num, link){
  $('.pages').addClass('hide');
  var all_links = $(link).siblings();
  $(all_links).removeClass('current');
  $(link).addClass('current');
  $('#'+page_num).removeClass('hide');
  if(page_num == 1) {
    $('#previous').addClass('hide');
  } else {
    $('#previous').removeClass('hide');
  }
  if(page_num == $('.page_links').length){
    $('#next').addClass('hide');
  } else {
    $('#next').removeClass('hide');
  }
}

function previous_page(){
  paging($('.current').prev()[0].innerHTML,$('.current').prev()[0]);
}

function next_page() {
  paging($('.current').next()[0].innerHTML,$('.current').next()[0]);
}

