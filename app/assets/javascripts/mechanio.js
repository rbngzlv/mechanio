$(document).ready(function(){
  $('[data-toggle = "tooltip"]').tooltip();

  // customize bootstrap file_upload_plugin
  $('input[type=file]').bootstrapFileInput();
  $('.file-input-wrapper').addClass('btn-success col-md-3');
});
