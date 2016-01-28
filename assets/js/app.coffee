$ ->
  handleUpload = (id, options = {})->
    $cnt = $(id)
    $cnt.find(".upload-gallery").append $.cloudinary.unsigned_upload_tag CONFIG.cloudinary.uploaderName,
      cloud_name: CONFIG.cloudinary.cloudName
    .bind "cloudinarydone", (e, data) ->
      $image = $.cloudinary.image data.result.public_id,
        cloud_name: CONFIG.cloudinary.cloudName
        format: 'jpg'
        width: 110
        height: 90
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
          cloud_name: CONFIG.cloudinary.cloudName
          format: 'jpg'
          width: 110
          height: 90
          crop: 'thumb'
        $image.data "url", picUrl
        $image.addClass "file-preview-image"
        $imageCnt = $("<div class='file-preview-frame'></div>").append $image
        $actionButtons = $("<div class='row'><button class='button btn btn-danger delete' type='button'>X</button></div>")
        $imageCnt.append $actionButtons
        $cnt.find(".gallery-preview").prepend $imageCnt
    $cnt.on "click", ".delete", (ev)->
      $(@).parents(".file-preview-frame:first").remove()

  handleUpload "#gallery-pics-upload-cnt"  if $("#gallery-pics-upload-cnt").length
  handleUpload "#header-pic-upload-cnt", {replace: true}  if $("#header-pic-upload-cnt").length
  handleUpload "#logo-upload-cnt", {replace: true}  if $("#logo-upload-cnt").length

  $("#new-event-form").submit (ev)->
    ev.preventDefault()
    $form = $(@)
    $form.find("[name='gallery'],[name='header'],[name='logo']").remove()
    galleries = {"#gallery-pics-upload-cnt": "gallery", "#header-pic-upload-cnt": "header", "#logo-upload-cnt": "logo"}
    for id, type of galleries
      $form.find("#{id} img").each (i, el)->
        url = $(el).data "url"
        $form.prepend "<input type='hidden' name='#{type}[]' value='#{url}'>"
    $form.find("#gig-submit-button").attr "disabled", true
    $.ajax
      type: "POST"
      url: $form.attr "action"
      data: $form.serialize()
      dataType: "json"
      success: (response)->
        window.location = response.redirect_url
      error: (xhr)->
        $form.find("#gig-submit-button").attr "disabled", false
        alert "Please submit a valid title, name, email and tags."

  $("#new-event-form").find("input").on "keypress", (event)->
    return event.keyCode != 13

  $("#contact-form").submit (ev)->
    ev.preventDefault()
    $form = $(@)
    $.ajax
      type: "POST"
      url: $form.attr "action"
      data: $form.serialize()
      dataType: "json"
      success: (response)->
        $form.prev(".bg-message").removeClass "hidden"
        $form.hide()
      error: ->
        alert "Could not send message, please contact support."

  $("#sponsor-invest-form").submit (ev)->
    ev.preventDefault()
    $form = $(@)
    $.ajax
      type: "POST"
      url: $form.attr "action"
      data: $form.serialize()
      dataType: "json"
      success: (response)->
        $form.prev(".bg-message").removeClass "hidden"
        $form.hide()
      error: ->
        alert "Could not send message, please contact support."

  $gigBanner = $('#gig-banner')
  if $gigBanner.length
    if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
      $gigBanner.find(".hsContainer").removeClass "hsContainer"
      $gigBanner.find(".hsContent").removeClass "hsContent"
      $gigBanner.find(".bcg").removeClass "bcg"
    else
      $window = $(window)
      $body = $('body')
      setTimeout (->
        adjustWindow()
        return
      ), 800

      adjustWindow = ->
        s = skrollr.init(render: (data) ->
          #Debugging - Log the current scroll position.
          #console.log(data.curTop);
          return
        )
        winH = $window.height()
        if winH <= 550
          winH = 550
        $gigBanner.height winH
        s.refresh $('#gig-banner')
        return
