$(document).ready(function () {
  lightSlider = $('#lightSlider')
  if(lightSlider.length > 0) {
    lightSlider.lightSlider({
      gallery: true,
      item: 1,
      loop: true,
      slideMargin: 0,
      thumbItem: 9
    });
  }
})
