# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require databound
#= require twitter/bootstrap
#= require turbolinks
#= require_tree .

App = (->
  Code = new Databound('codes')

  init = ->
    initEditors()
    bindRun()
    startTracking()

  initEditors = ->
    _.each editors(), (editor, file) ->
      setDefaults(editor)
      customize(editor, file)

  setDefaults = (editor) ->
    editor.setTheme('ace/theme/github')
    editor.setFontSize(16)
    editor.setShowPrintMargin(false)
    editor.setShowFoldWidgets(false)
    editor.setShowInvisibles(false)
    editor.renderer.setShowGutter(false)

  SYNTAX_TYPES = {
    javascript: 'javascript',
    gemfile: 'ruby',
    routes: 'ruby',
    controller: 'ruby'
  }

  customize = (editor, file) ->
    editor.getSession().setMode("ace/mode/#{SYNTAX_TYPES[file]}")

    $.get("landing/initial_code", file: file).then((resp) ->
      editor.setValue(resp, 1)
    ).then ->
      if file == 'javascript'
        run()
        startEditTracking()

      if _.include(['gemfile', 'routes', 'controller'], file)
        editor.setReadOnly(true)

  editors = ->
    result = {}

    _.each ['javascript', 'gemfile', 'routes', 'controller'], (file) ->
      result[file] = window.ace.edit(file)

    result

  run   = ->
    cleanBrowser()
    eval(editors()['javascript'].getValue())

  cleanBrowser = ->
    browser().html('')

  bindRun = ->
    $('#run').on('click', run)

  startTracking = ->
    $(document).on 'click', 'a', (link) ->
      analytics.track 'Clicked link',
        text: $(link.target).text()
        href: $(link.target).prop('href')

    $(document).on 'click', 'button', (button) ->
      text = $(button.target).text()

      analytics.track 'Clicked button',
        text: text

      if text == ' Run'
        Code.create(content: editors().javascript.getValue())

  startEditTracking = ->
    editors().javascript.getSession().on 'change', _.debounce(logEdit, 5000,
      leading: false
      trailing: true
    )

  logEdit = (e) ->
    Code.create(partial: true, content: editors().javascript.getValue())

  return {
    init: init
  }
)()


window.browser = ->
  $('#browser')

window.print = (content) ->
  unless _.isString(content)
    pretty = require('js-object-pretty-print').pretty
    content = pretty(content, 2, 'HTML')

  browser().append($('<div>').html("#{content}"))

window.onerror = (e) ->
  print('ERROR: ' + e)

$(-> App.init())
