$(document).ready ->
  #기본 데이터 차트 표시
  chart_on_success = (data)->
    console.log(data);
    paracoords = d3.parcoords()('#para_coord').alpha(0.4)
    paracoords.data(data).composite('darker').render().shadows().reorderable().brushMode('1D-axes')

  Ajax.get('/ajax/data/'+id+'/paracoords',chart_on_success)
  return
