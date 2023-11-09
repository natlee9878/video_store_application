//= require gnmenu

function menuCode() {
  if (document.getElementById('gn-menu') === null)
    return;

  new gnMenu(document.getElementById('gn-menu'));
}

function inputCode() {
  $('input[type=checkbox]').each(function () {
    if (this.checked) {
      $(this).closest('.checkbox').find('span').addClass('mvi-active-checkbox');
    }
  });

// Fixes issue where double click events were occuring
  $('.btn-more, .btn-add-all, .btn-add-one, .btn-remove-one, .btn-remove-all').unbind('click').bind('click', function () {
    setTimeout( function(){
      $('.button--loading').removeClass('button--loading');
    }, 100);
  });

  $("input[type='checkbox']").unbind('click').bind('click', function () {
    $(this).closest('.checkbox').find('span').toggleClass('mvi-active-checkbox');
  });

  $('.btn').on('click', function(){
    let selectedButton = $(this);
    selectedButton.addClass('button--loading');

    //Fallback in case logic button doesn't clear the spinner
    setTimeout( function(){
      selectedButton.removeClass('button--loading');
    }, 60000);
  })

  $(".ibox-header").each(function() {
    if(!$(this).prev().hasClass('positioning-header')) {
      let headerText = $(this).find('.mvi-ibox-title').find('h3').text()
      $( "<div class=\"positioning-header\"><div class=\"mvi-ibox-title\"><h3>" + headerText + "</h3></div></div>" ).insertBefore($(this));
    }
  });
}

$(function(){
  let flag = 0;

  $('.share').on('click',function(){
    if(flag === 0)
    {
      $(this).siblings('.one').animate({
        top:'160px',
        left:'50%',
      },200);

      $(this).siblings('.two').delay(200).animate({
        top:'260px',
        left:'40%'
      },200);

      $(this).siblings('.three').delay(300).animate({
        top:'260px',
        left:'60%'
      },200);

      $('.one i, .two i, .three i').delay(500).fadeIn(200);
      flag = 1;
    }


    else{
      $('.one, .two, .three').animate({
        top:'300px',
        left:'50%'
      },200);

      $('.one i, .two i, .three i').delay(500).fadeOut(200);
      flag = 0;
    }
  });
});

function subMenuCode() {
  $('.submenu-header').click(function() {
    $(this).toggleClass('active-submenu');

    $(this).find('li').delay(50).each(function(i) {
      $(this).delay(25 * i).queue(function() {
        $(this).toggleClass('active-submenu-li');
      })
    })
  });
}

$(document).ready(function () {
  inputCode();
  // menuCode();
  subMenuCode();
});

$(document).ajaxComplete(function () {
  inputCode();
});

$(document).on('click', '.submit-dismiss-js', function(e) {
  e.preventDefault();
  e.stopImmediatePropagation();
  var currentLink = $(this);
  var currentForm = currentLink.closest('form');

  currentForm.submit();
  $('#action-modal').modal('hide');

  setTimeout( function(){
    $('.btn').removeClass('button--loading');
  }, 1000);

});
