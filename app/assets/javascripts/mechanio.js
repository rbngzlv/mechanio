$(document).ready(function(){
  $('[data-toggle = "tooltip"]').tooltip();

  // customize bootstrap file_upload_plugin
  $('input[type=file]').bootstrapFileInput();
  $('.file-input-wrapper').addClass('btn-success col-md-3');

  $('.mobile-nav').click(function(){
    $('.aside').wrap('<div class = "aside-wrapper"></div>').addClass('show-aside');
    $('.header').css('z-index', '1');

    $('.aside-wrapper').click(function(){
      $('.aside').unwrap().removeClass('show-aside');
    });
  })
});
