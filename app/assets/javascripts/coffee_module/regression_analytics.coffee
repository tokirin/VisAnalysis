$(document).ready ->
  x_id = $('#regression_x_axis').val()
  y_id = $('#regression_y_axis').val()
  regression_chart = null

  on_success = (data)->
    c3.generate(
      data.chart_data
    )
    $('#regression_cc').html(data.result_data.cc)
    $('#regression_dc').html(data.result_data.dc)
    $('#regression_std_error').html(data.result_data.std_error)
    $('#regression_sample_num').html(data.result_data.sample_num)
    $('#regression_slope').html(data.result_data.a)
    $('#regression_y_intercept').html(data.result_data.y_intercept)

  Ajax.get('/ajax/data/'+id+'/regression?x_id='+x_id+'&y_id='+y_id,on_success,this)

  $('#btn_regression_submit').click(()->
    x_id = $('#regression_x_axis').val()
    y_id = $('#regression_y_axis').val()
    Ajax.get('/ajax/data/'+id+'/regression?x_id='+x_id+'&y_id='+y_id,on_success,this)
  )