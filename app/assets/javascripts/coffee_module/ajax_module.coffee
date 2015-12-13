AjaxModule = do ->
  _post = (url,data,success,context=null,fail=null) ->
    $.ajax({
      context:context,
      data: data,
      dataType: 'json',
      type:'POST',
      url: url,
      success: success,
      fail: fail
    })

  _update = (url,data,success,context=null,fail=null) ->
    $.ajax({
      context:context,
      data: data,
      dataType: 'json',
      type:'UPDATE',
      url: url,
      success: success,
      fail: fail
    })

  _get =  (url,success,context=null,fail=null) ->
    $.ajax({
      context:context,
      type:'GET',
      url: url,
      success: success,
      fail: fail
    })

  _delete = (url,success,context=null,fail=null) ->
    $.ajax({
      context:context,
      type:'DELETE',
      url: url,
      success: success,
      fail: fail
    })


  {
  post: (url,data,success,fail) ->
    _post(url,data,success,fail)
  ,
  update: (url,data,success,fail) ->
    _update(url,data,success,fail)
  ,
  get: (url,data,success,fail) ->
    _get(url,data,success,fail)
  ,
  delete: (url,data,success,fail) ->
    _delete(url,data,success,fail)
  ,
  }

this.Ajax = AjaxModule
