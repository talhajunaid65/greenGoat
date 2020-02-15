//= require arctic_admin/base
//= require pickadate/picker
//= require pickadate/picker.date
//= require select2

//= require admin/products

$(document).ready(function(){
  $("#date_from, #date_to").pickadate();
  $( ".select2-dropdown" ).select2();
});
