Cycle = require '@cycle/core'
CycleDOM = require '@cycle/dom'

drivers = (options) ->
  DOM: CycleDOM.makeDOMDriver options.hostElement,
    'panel-content': options.panelContent
  CONTENT: options.contentDriver

# view : Observable Content -> Observable CycleDOM
view = (state$) ->
  state$.map (content) ->
    CycleDOM.h 'div',
      {
        className: 'idris-panel-view'
      },
      [
        CycleDOM.h 'h1', { className: 'idris-panel-header' }, "Repl"
        CycleDOM.h 'panel-content.idris-panel-content', content: content
      ]

main = (responses) ->
  input = responses.DOM.select('.idris-panel-content').events('contentStream')
    .map (ev) -> ev.detail

  DOM: view responses.CONTENT
  CONTENT: input

module.exports =
  main: main
  drivers: drivers
