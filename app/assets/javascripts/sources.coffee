$(document).ready ->
  if $(document).find('body').attr('data-controller') == 'sources' && $(document).find('body').attr('data-action') == 'edit' || $(document).find('body').attr('data-action') == 'new'
    sources_edit_javascript()
  if $(document).find('body').attr('data-controller') == 'sources' && $(document).find('body').attr('data-action') == 'show'
    sources_show_javascript()

sources_edit_javascript = ->
  insert_at_caret = (areaId, text) ->
    txtarea = document.getElementById areaId
    if !txtarea
      return

    scrollPos = txtarea.scrollTop
    strPos = 0
    br = if (txtarea.selectionStart || txtarea.selectionStart == '0') then "ff" else (if document.selection then "ie" else false)
    if br == "ie"
      txtarea.focus()
      range = document.selection.createRange()
      range.moveStart 'character', -txtarea.value.length
      strPos = range.text.length
    else if br == "ff"
      strPos = txtarea.selectionStart

    front = txtarea.value.substring 0, strPos
    back = txtarea.value.substring strPos, txtarea.value.length
    txtarea.value = front + text + back
    strPos = strPos + text.length
    if br == "ie"
      txtarea.focus()
      ieRange = document.selection.createRange()
      ieRange.moveStart 'character', -txtarea.value.length
      ieRange.moveStart 'character', strPos
      ieRange.moveEnd 'character', 0
      ieRange.select()
    else if br == "ff"
      txtarea.selectionStart = strPos
      txtarea.selectionEnd = strPos
      txtarea.focus()

    txtarea.scrollTop = scrollPos

  get_ext = ->
    $('#source_ext').val()
  add_button = (id, disp, str) ->
    $('.sourcesButtons').append "<li id='sources#{id}' class='#{gon.button_class}'>#{disp}</li>"
    $(".sourcesButtons > #sources#{id}").click ->
      insert_at_caret 'source_contents', str
  show_buttons = ->
    $('.sourcesButtonsUtils > .sourcesButtons').empty()
    ext = get_ext().slice 1
    for k, v of gon.editor_buttons[ext]
      add_button k, v.key, v.val
  $('.sourcesButtonsUtils > #sourcesButtonsPulldown').click show_buttons
  clear_contents = ->
    $('#source_contents').val ''
sources_show_javascript = ->
  $('.sourcesClear > #sourcesButtonClear').click clear_contents
  $('.proof').wrap "<div class='proofWrapper'></div>"
  $('.proof').after "<span class='proofQED'> ∎</span>"
  $('.proof').before "<span class='proofToggle'>Proof.</span>"
  $('.proof').hide()
  $('.proofToggle').click ->
    $(this).next().toggle()
  $('.thm').after "<br />"
  $('.main').prepend "<div id='tableOfContents'></div>"
  $('#tableOfContents').append "<h1 class='contents'>Contents</h1>"
  $('#tableOfContents').append "<ul class='contents'></ul>"
  create_toc = ->
    toc = $('#tableOfContents > ul.contents')
    append_link = (elem, klass) ->
      toc.append "<li class='#{klass}'><a href='##{$(elem).attr 'id'}'>#{$(elem).text()}</a></li>"
    $('.main > h1:not(.contents), .main > h2').each (index, elem) ->
      if $(elem).prop('tagName') == 'H1'
        append_link elem, 'tocFirstLevel'
      else
        append_link elem, 'tocSecondLevel'
  create_toc()
