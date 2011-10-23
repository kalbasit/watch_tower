window.file_tree =
  handle_button: (domId) ->
    if ($ domId).hasClass "collapsed"
      ($ domId).removeClass "collapsed"
      ($ domId).addClass "expanded"
      ($ domId).text '-'
      file_tree.show_folder domId
    else
      ($ domId).removeClass "expanded"
      ($ domId).addClass "collapsed"
      ($ domId).text '+'
      file_tree.hide_folder domId

  show_folder: (button_domId) ->
    ($ button_domId).parent().parent().children('.nested_folder').each (index, element) ->
      ($ element).show()
    ($ button_domId).parent().parent().children('.files').each (index, element) ->
      ($ element).show()


  hide_folder: (button_domId) ->
    ($ button_domId).parent().parent().children('.nested_folder').each (index, element) ->
      ($ element).hide()
    ($ button_domId).parent().parent().children('.files').each (index, element) ->
      ($ element).hide()

jQuery ($) ->
  ($ '.collapsed').each (index, element) ->
    ($ element).bind 'click', ->
      file_tree.handle_button element