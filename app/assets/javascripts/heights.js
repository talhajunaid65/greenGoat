function setHeights() {
    var heights = [];
    $('.carousel-item').each(function() {
      heights.push($(this).height());
    });
  
    $('.carousel-item').height(Math.max(...heights)); 
  }
  
  setHeights();