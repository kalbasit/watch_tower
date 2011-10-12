date_filtering =
  handleResponse: (response, textStatus, jqXHR) ->
    ($ '.page').html(response)
  handleDatePicker: (dates) ->
    options = { from_date:  $.datepick.formatDate(dates[0]), to_date:  $.datepick.formatDate(dates[1]) }
    url = window.location.pathname
    $.get url, options, date_filtering.handleResponse

jQuery ->
  ($ '#date input').datepick
    rangeSelect: true,
    monthsToShow: 2,
    alignment: 'bottomRight',
    onClose: date_filtering.handleDatePicker