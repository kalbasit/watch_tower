window.date_filtering =
  handleResponse: (response, textStatus, jqXHR) ->
    ($ '.page').html(response)
    percentage.applyPercentage()

  updateMetaTags: (dates) ->
    ($ 'meta[name="date_filtering_from"]').attr 'content', $.datepick.formatDate(dates[0])
    ($ 'meta[name="date_filtering_to"]').attr 'content', $.datepick.formatDate(dates[1])

  handleDatePicker: (dates) ->
    options = { from_date:  $.datepick.formatDate(dates[0]), to_date:  $.datepick.formatDate(dates[1]) }
    url = window.location.pathname
    date_filtering.updateMetaTags dates
    $.get url, options, date_filtering.handleResponse

jQuery ->
  ($ '#date input').datepick
    rangeSelect: true,
    monthsToShow: 2,
    alignment: 'bottomRight',
    onClose: date_filtering.handleDatePicker