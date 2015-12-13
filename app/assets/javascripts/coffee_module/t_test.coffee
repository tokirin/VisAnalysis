$(document).ready ->
  c1_id = $('#t_test_c1').val()
  c2_id = $('#t_test_c2').val()
  url = '/ajax/data/'+id+'/t_test?c1_id='+c1_id+'&c2_id='+c2_id

  on_success = (data)->

    console.log data

    $('#t_test_col1_name').html(data.basic_data.columns[0])
    $('#t_test_col2_name').html(data.basic_data.columns[1])
    $('#t_test_col1_avg').html(data.basic_data.avgs[0])
    $('#t_test_col2_avg').html(data.basic_data.avgs[1])
    $('#t_test_col1_var').html(data.basic_data.vars[0])
    $('#t_test_col2_var').html(data.basic_data.vars[1])
    $('#t_test_col1_sample_num').html(data.basic_data.size)
    $('#t_test_col2_sample_num').html(data.basic_data.size)
    $('#t_test_cc').html(data.result_data.correlation)
    $('#t_test_hypothesis_avg_diff').html(data.result_data.hypo_diff)
    $('#t_test_freedom').html(data.result_data.freedom)
    $('#t_test_t_value').html(data.result_data.t_value)

  Ajax.get(url,on_success,this)

  $('#btn_t_test_submit').click(()->
    c1_id = $('#t_test_c1').val()
    c2_id = $('#t_test_c2').val()
    url = '/ajax/data/'+id+'/t_test?c1_id='+c1_id+'&c2_id='+c2_id
    if c1_id == c2_id
      alert('변수1과 변수2는 중복될 수 없습니다.')
    else
      Ajax.get(url,on_success,this)
  )