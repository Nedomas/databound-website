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
#= require twitter/bootstrap
#= require turbolinks
#= require_tree .

App = (->
  init = ->
    # initEditor()
    # bindEditor()

  initEditor = ->
    editor().setTheme('ace/theme/github')
    editor().getSession().setMode('ace/mode/javascript')
    editor().setFontSize(16)
    editor().setShowPrintMargin(false)
    editor().setShowFoldWidgets(false)
    editor().setShowInvisibles(false)
    editor().renderer.setShowGutter(false)

    $.get('landing/initial_code').then (resp) ->
      editor().setValue(resp, 1)
      renderBrowser()

  editor = ->
    window.ace.edit('editor')

  renderBrowser = ->
    cleanBrowser()
    eval(editor().getValue())

  cleanBrowser = ->
    browser().html('')

  bindEditor = ->
    $('#run-editor').on('click', renderBrowser)

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
