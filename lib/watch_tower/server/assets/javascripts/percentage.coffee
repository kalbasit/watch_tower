percentage =
  applyPercentage: ->
    ($ '.percentage_img').each (index, element) ->
      width = ($ element).attr('data-width')
      percentage.animateGrowth(element, width * 3)

  animateGrowth: (domId, width, overGrow = false) ->
    overGrowth = width + 50
    overGrowth = 300 if overGrowth > 300
    if overGrow
      ($ domId).effect 'size', { to: { width: width } }, 1000
    else
      ($ domId).effect 'size', { to: { width: overGrowth } }, 1000, ->
        percentage.animateGrowth domId, width, true
  
  
jQuery ->
  percentage.applyPercentage()