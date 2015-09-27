Cycle = require '@cycle/core'
CycleDOM = require '@cycle/dom'
highlighter = require '../utils/highlighter'

# highlight :
#   forall a. { code : String, highlightInformation : HighlightInformation } ->
#     CycleDOM
highlight = ({ code, highlightInformation }) ->
  highlights = highlighter.highlight code, highlightInformation
  highlighter.highlightToCycle highlights

# view : Observable State -> Observable CycleDOM
view = (state$) ->
  state$.map (lines) ->
    lines = lines.map (line) ->
      highlightedCode = highlight line
      CycleDOM.h 'div', { className: 'idris-repl-line' }, highlightedCode

    CycleDOM.h 'div',
      [
        CycleDOM.h 'input', { type: 'text', className: 'native-key-bindings' }, 'toggle'
        CycleDOM.h 'div', lines
      ]

main = (responses) ->
  input = responses.DOM.select('input').events('keydown')
    .filter (ev) -> ev.keyCode == 13
    .map (ev) -> ev.target.value
    .startWith ''

  DOM: view responses.props.get('content')
  events:
    contentStream: input

# driver : forall a.
#   IdrisModel -> Observable String ->
#     Observable (List { a | code : String, highlightInformation : highlightInformation })
driver =
  (model) ->
    (inp) ->
      inp
        .filter (line) -> line != ''
        .flatMap (line) ->
          escapedLine = line.replace(/"/g, '\\"')
          model.interpret escapedLine
        .map (e) ->
          code: e.msg[0]
          highlightInformation: e.msg[1]
        .scan ((acc, x) -> acc.concat x), []
        .startWith []

module.exports =
  main: main
  driver: driver
