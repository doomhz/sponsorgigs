_          = require "underscore"
cloudinary = require "cloudinary"
cloudinary.config GLOBAL.appConfig().cloudinary

GIG_STATUS =
  enabled: 1
  disabled: 2

AppHelper =

  getGigStatusInt: (status)->
    GIG_STATUS[status]

  getGigStatusLiteral: (status)->
    _.invert(GIG_STATUS)[status]

  getPic: (fieldContent, picType)->
    return ""  if not fieldContent
    pics = fieldContent.split "\n"
    pic = _.find pics, (p)->
      p.indexOf("[#{picType}]") > -1
    return ""  if not pic
    pic.replace "[#{picType}]", ""

  getGallery: (fieldContent)->
    gallery = []
    return gallery  if not fieldContent
    pics = fieldContent.split "\n"
    for pic in pics
      gallery.push pic.replace "[gallery]", ""  if pic.indexOf("[gallery]") > -1
    gallery

  getSocial: (fieldContent, type)->
    return ""  if not fieldContent
    socials = fieldContent.split "\n"
    return ""  if not socials.length
    link = _.find socials, (s)->
      s.indexOf("[#{type}]") > -1
    return ""  if not link
    link.replace "[#{type}]", ""

  thumbURL: (url, width, height)->
    return ""  if not url
    cloudinary.url url.substr(url.lastIndexOf("/")), {width: width, height: height, crop: "thumb"}

  resizeURL: (url, width, height)->
    return ""  if not url
    scaleOption =
      crop: "fit"
    scaleOption.width = width  if width
    scaleOption.height = height  if height
    cloudinary.url url.substr(url.lastIndexOf("/")), scaleOption

exports = module.exports = AppHelper