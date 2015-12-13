$(document).ready ->

  #데이터 테이블 표시
  $('#basic_table').DataTable({language: data_table_language})

  #기본 데이터 차트 표시
  chart_on_success = (data)->
#    console.log data
    c3.generate({
      size:{
        height: 600
      },
      zoom:{
        enabled:true
      }
      data: data
    });

  Ajax.get('/ajax/data/'+id,chart_on_success)
  return
