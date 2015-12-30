AppHelper = require "../../lib/app_helper"
_         = require "underscore"

module.exports = (sequelize, DataTypes) ->

  Gig = sequelize.define "Gig",
      title:
        type: DataTypes.STRING
        allowNull: true
      location:
        type: DataTypes.STRING
        allowNull: true
      geo:
        type: DataTypes.STRING
        allowNull: true
      site:
        type: DataTypes.STRING
        allowNull: true
      email:
        type: DataTypes.STRING
        allowNull: true
      phone:
        type: DataTypes.STRING
        allowNull: true
      organizer:
        type: DataTypes.STRING
        allowNull: true
      start_date:
        type: DataTypes.DATE
      end_date:
        type: DataTypes.DATE
      tags:
        type: DataTypes.STRING
        allowNull: true
      visitors:
        type: DataTypes.STRING
        allowNull: true
      social:
        type: DataTypes.TEXT
        allowNull: true
      description:
        type: DataTypes.TEXT
        allowNull: true
      pics:
        type: DataTypes.TEXT
        allowNull: true
      video:
        type: DataTypes.TEXT
        allowNull: true
      status:
        type: DataTypes.INTEGER.UNSIGNED
        allowNull: false
        defaultValue: AppHelper.getGigStatusInt "enabled"
        get: ()->
          AppHelper.getGigStatusLiteral @getDataValue("status")
        set: (status)->
          @setDataValue "status", AppHelper.getGigStatusInt(status)
    ,
      tableName: "gigs"
      getterMethods:

        logo: ->
          AppHelper.getPic @pics, "logo"

        header: ->
          AppHelper.getPic @pics, "header"

        gallery: ->
          AppHelper.getGallery @pics

        slug: ->
          @title.toLowerCase().replace /[^a-z0-9]/g, "-"

        all_tags: ->
          @tags.split("|")

        main_tag: ->
          @all_tags[0]

        lat: ->
          @geo.split("|")[0]

        lng: ->
          @geo.split("|")[1]

        site_url: ->
          "http://" + @site.replace("http://", "")

        facebook: ->
          AppHelper.getSocial @social, "facebook"

        youtube: ->
          AppHelper.getSocial @social, "youtube"

        twitter: ->
          AppHelper.getSocial @social, "twitter"

        gplus: ->
          AppHelper.getSocial @social, "gplus"

      classMethods:

        findEnabled: (callback = ->)->
          Gig.findAll({where: {status: AppHelper.getGigStatusInt "enabled"}}).complete callback

        findEnabledFirstPage: (callback = ->)->
          Gig.findAll({where: {status: AppHelper.getGigStatusInt "enabled"}, limit: 8}).complete callback

        findById: (id, callback = ->)->
          Gig.find(id).complete callback

  Gig