module.exports =
class Operation
  constructor: ({@project, @path, @buffer, @bufferRange, @newText, @preserveSelection, @errorMessage}) ->
    if @buffer?
      @buffer.retain()
      @getMarker()

  getMarker: ->
    @marker ?= @getBuffer().markRange(@bufferRange)

  getBuffer: ->
    @buffer ?= @project.bufferForPath(@path).retain()

  getPath: ->
    path = @path ? @getBuffer().getPath()
    @project.relativize(path)

  getBufferRange: ->
    @getMarker().getRange()

  execute: (editSession) ->
    @getBuffer().change(@getBufferRange(), @newText) if @newText?
    @getBufferRange() unless @preserveSelection

  preview: ->
    range = @getBufferRange()
    line = @getBuffer().lineForRow(range.start.row)
    prefix = line[0...range.start.column]
    match = line[range.start.column...range.end.column]
    suffix = line[range.end.column..]

    {prefix, suffix, match, range}

  destroy: ->
    @marker?.destroy()
    @buffer?.release()
