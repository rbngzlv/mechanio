$(document).ready(function(){
  $('[data-toggle = "tooltip"]').tooltip();

  // customize bootstrap file_upload_plugin
  $('input[type=file]').bootstrapFileInput();
  $('.file-input-wrapper').addClass('btn-success col-md-3');

  $('.mobile-nav').click(function(){
    $('.aside').wrap('<div class = "aside-wrapper"></div>').animate({left: '0'}, 400).addClass('show-aside');
    $('.header').css('z-index', '1');
    $('body').css('overflow', 'hidden');

    $('.aside-wrapper').click(function(){
      $('.aside').unwrap().animate({left: '-215'}).removeClass('show-aside');
      $('body').css('overflow', 'auto');
    });
  })
});
