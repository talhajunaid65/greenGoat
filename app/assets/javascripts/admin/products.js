$(document).ready(function(){
  weightCalculation();
  filtersubCategoryUsingCategory();

  function weightCalculation(){
    var totalWeight = parseFloat($('#product_weight').val())
    otherEle = $('#product_other');

    $('#product_weight').keyup(function() {
      otherEle.val($(this).val())
      totalWeight = parseFloat($(this).val());
    });

    $('#product_wood').change(function(){
      labelEle = $('#wood_weight_in_kg')
      calculateAndSetWeight($(this), labelEle);
    })

    $('#product_ceramic').change(function(){
      labelEle = $('#ceramic_weight_in_kg')
      calculateAndSetWeight($(this), labelEle);
    })

    $('#product_glass').change(function(){
      labelEle = $('#glass_weight_in_kg')
      calculateAndSetWeight($(this), labelEle);
    })

    $('#product_metal').change(function(){
      labelEle = $('#metal_weight_in_kg')
      calculateAndSetWeight($(this), labelEle);
    })

    $('#product_stone_plastic').change(function(){
      labelEle = $('#stone_plastic_weight_in_kg')
      calculateAndSetWeight($(this), labelEle);
    })

    function calculateAndSetWeight(ele, labelEle) {
      if(totalWeight == 0) {
        $(ele).val('');
        alert('Please add weight first.');
        return;
      }

      percentage = parseFloat($(ele).val());
      if(percentage == 0 || isNaN(percentage)) {
        addedValue = parseFloat(labelEle.text().split(': ')[1])
        if (isNaN(addedValue)) { return; }
        otherEle.val(parseFloat(otherEle.val()) + addedValue)
        labelEle.text(`Weight in kg:`);
        return;
      }

      calcualtedWeight = (totalWeight * (percentage / 100)).toFixed(2);
      labelEle.text(`Weight in kg: ${calcualtedWeight}`);
      otherEle.val(parseFloat(otherEle.val()) - calcualtedWeight)
    }
  }

  function filtersubCategoryUsingCategory(){
    $('#product_category_id').change(function(){
      debugger
      categoryId = $(this).val();
      $.ajax({
        url: `/admin/items/filter_sub_categories?category_id=${categoryId}`,
        method: 'GET'
      })
    })
  }
});
