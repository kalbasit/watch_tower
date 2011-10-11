animateGrowth = (domId, width) ->
  ($ domId).attr('width', width)
  
  
jQuery ->
  ($ '.percentage_img').each (index, element) ->
    width = ($ element).attr('data-width')
    animateGrowth(element, width * 3)