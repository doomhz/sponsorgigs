$ ->
  handleUpload = (id, options = {})->
    $cnt = $(id)
    $cnt.find(".upload-gallery").append $.cloudinary.unsigned_upload_tag "event_gallery",
      cloud_name: "dhz"
    .bind "cloudinarydone", (e, data) ->
      $image = $.cloudinary.image data.result.public_id,
        cloud_name: "dhz"
        format: 'jpg'
        width: 160
        height: 160
        crop: 'thumb'
      $image.data "url", data.result.url
      $image.addClass "file-preview-image"
      $imageCnt = $("<div class='file-preview-frame'></div>").append $image
      $actionButtons = $("<div class='row'><button class='button btn btn-danger delete' type='button'>X</button></div>")
      $imageCnt.append $actionButtons
      $cnt.find(".file-preview-frame").remove()  if options.replace
      $cnt.find(".gallery-preview").prepend $imageCnt
      $cnt.find(".upload-gallery-progress").addClass "hidden"
    .bind "cloudinaryprogress", (e, data) ->
      progress = Math.round(data.loaded * 100.0 / data.total)
      $pb = $cnt.find(".upload-gallery-progress")
      $pb.removeClass("hidden").find(".progress-bar").css("width",  "#{progress}%").text("#{progress}%")
    if $cnt.data("pics").length
      pics = $cnt.data("pics").split "|"
      for picUrl in pics
        $image = $.cloudinary.image picUrl,
          cloud_name: "dhz"
          format: 'jpg'
          width: 160
          height: 160
          crop: 'thumb'
        $image.data "url", picUrl
        $image.addClass "file-preview-image"
        $imageCnt = $("<div class='file-preview-frame'></div>").append $image
        $actionButtons = $("<div class='row'><button class='button btn btn-danger delete' type='button'>X</button></div>")
        $imageCnt.append $actionButtons
        $cnt.find(".gallery-preview").prepend $imageCnt
    $cnt.on "click", ".delete", (ev)->
      $(@).parents(".file-preview-frame:first").remove()

  handleUpload "#gallery-pics-upload-cnt"
  handleUpload "#header-pic-upload-cnt", {replace: true}
  handleUpload "#logo-upload-cnt", {replace: true}

  $("#new-event-form").submit (ev)->
    ev.preventDefault()
    $form = $(@)
    $form.find("[name='gallery'],[name='header'],[name='logo']").remove()
    galleries = {"#gallery-pics-upload-cnt": "gallery", "#header-pic-upload-cnt": "header", "#logo-upload-cnt": "logo"}
    for id, type of galleries
      $form.find("#{id} img").each (i, el)->
        url = $(el).data "url"
        $form.prepend "<input type='hidden' name='#{type}[]' value='#{url}'>"
    $.ajax
      type: "POST"
      url: $form.attr "action"
      data: $form.serialize()
      dataType: "json"
      success: (response)->
        window.location = response.redirect_url
      error: ->
        alert "Could not add event, please contact support."

  $("#new-event-form").find("input").on "keypress", (event)->
    return event.keyCode != 13

