$(document).ready ->

  result = null
  # 파일 로딩 아이콘 숨기기
  $('#parse_loading').hide()

  # 인풋 파일 로드시 파싱시작, PapaParse경우 몇억건의 데이터도 괜찮다는 결과가있음, 빅데이터 파싱용으로 적합
  $('#data-file-input').on 'fileloaded',(e,f,pid)->
    $('#parse_loading').show()
    $('#data-set-name').val(f.name)
    config = {
      complete: (results) ->
        result = results
        $('#btn_submit_data').attr('disabled',false)
        $('#parse_loading').hide()
        return
      ,
      encoding:'utf-8',
      header: true,
      fastMode: true,
      dynamicTyping: true
    }
    Papa.parse(f,config)

  # 인풋 파일 제거시
  $('#data-file-input').on 'filecleared',(e,f,pid)->
    $('#data-set-name').val('')

  # 인풋 폼 데이터 전송, 빅데이터시의 고려필요
  $('#btn_submit_data').click (()->
    console.log(result)
    result.meta.data_name = $('#data-set-name').val()

    on_success = (data)->
      console.log JSON.stringify(data)
      console.log data.id.$oid
      $('btn_submit_data').html('Data Processing..')
      location.href = '/' + data.id.$oid

    Ajax.post('/ajax/data',JSON.stringify(result),on_success)
    $(this).attr('disabled','true')
    $(this).html('Data Saving..')
  )

  #서버 저장되있는 데이터 셋 제거
  $('#btn_data_remove').click(()->

    id = $(this).closest('tr').attr('id')
    console.log 'remove data set having id of ' + id

    on_success = (data)->
      $(this).closest('tr').remove()
      toastr.info('Data Set is Removed')

    Ajax.delete('/ajax/data/'+id,on_success,this)
  )

