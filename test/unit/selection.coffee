describe('Selection', ->
  beforeEach( ->
    @container = $('#editor-container').get(0)
    @container.innerHTML = '
      <div>
        <div><span>0123</span></div>
        <div><br></div>
        <div><img></div>
        <div><b><s>89</s></b><i>ab</i></div>
      </div>
    '
    @quill = new Quill(@container.firstChild)   # Need Quill to create iframe for focus logic
    @doc = @quill.editor.doc
    @selection = @quill.editor.selection
  )

  describe('helpers', ->
    tests =
      'text node':
        native: ->
          return [@doc.root.querySelector('s').firstChild, 1]
        normalized: ->
          return [@doc.root.querySelector('s').firstChild, 1]
        index: 9
      'between leaves':
        native: ->
          return [@doc.root.querySelector('i').firstChild, 0]
        normalized: ->
          return [@doc.root.querySelector('i').firstChild, 0]
        index: 10
      'break node':
        native: ->
          return [@doc.root.querySelector('br').parentNode, 0]
        normalized: ->
          return [@doc.root.querySelector('br'), 0]
        index: 5
      'before image':
        native: ->
          return [@doc.root.querySelector('img').parentNode, 0]
        normalized: ->
          return [@doc.root.querySelector('img'), 0]
        index: 6
      'after image':
        native: ->
          return [@doc.root.querySelector('img').parentNode, 1]
        normalized: ->
          return [@doc.root.querySelector('img'), 1]
        index: 7
      'end of document':
        native: ->
          return [@doc.root.querySelector('i').firstChild, 2]
        normalized: ->
          return [@doc.root.querySelector('i').firstChild, 2]
        index: 12


    describe('_normalizePosition()', ->
      _.each(tests, (test, name) ->
        it(name, ->
          [node, offset] = test.native.call(this)
          [resultNode, resultOffset] = @selection._normalizePosition(node, offset)
          [expectedNode, expectedOffset] = test.normalized.call(this)
          expect(resultNode).toEqual(expectedNode)
          expect(resultOffset).toEqual(expectedOffset)
        )
      )

      it('empty document', ->
        @container.innerHTML = '<div></div>'
        quill = new Quill(@container.firstChild)
        [resultNode, resultIndex] = quill.editor.selection._normalizePosition(quill.editor.doc.root, 0)
        expect(resultNode).toEqual(quill.editor.doc.root)
        expect(resultIndex).toEqual(0)
      )
    )

    describe('_positionToIndex()', ->
      _.each(tests, (test, name) ->
        it(name, ->
          [node, offset] = test.native.call(this)
          index = @selection._positionToIndex(node, offset)
          expect(index).toEqual(test.index)
        )
      )

      it('empty document', ->
        @container.innerHTML = '<div></div>'
        quill = new Quill(@container.firstChild)
        index = quill.editor.selection._positionToIndex(quill.editor.doc.root, 0)
        expect(index).toEqual(0)
      )
    )

    describe('_indexToPosition()', ->
      _.each(tests, (test, name) ->
        it(name, ->
          [node, offset] = @selection._indexToPosition(test.index)
          [expectedNode, expectedOffset] = test.native.call(this)
          expect(node).toEqual(expectedNode)
          expect(offset).toEqual(expectedOffset)
        )
      )

      it('empty document', ->
        @container.innerHTML = '<div></div>'
        quill = new Quill(@container.firstChild)
        [node, offset] = quill.editor.selection._indexToPosition(0)
        expect(node).toEqual(quill.editor.doc.root)
        expect(offset).toEqual(0)
      )
    )

    describe('get/set range', ->
      _.each(tests, (test, name) ->
        it(name, ->
          @quill.focus()
          @selection.setRange(new Quill.Lib.Range(test.index, test.index))
          expect(@selection.checkFocus()).toBe(true)
          range = @selection.getRange()
          expect(range).not.toEqual(null)
          expect(range.start).toEqual(test.index)
          expect(range.end).toEqual(test.index)
        )
      )

      it('entire document', ->
        @quill.focus()
        @selection.setRange(new Quill.Lib.Range(0, 12))
        expect(@selection.checkFocus()).toBe(true)
        range = @selection.getRange()
        expect(range).not.toEqual(null)
        expect(range.start).toEqual(0)
        expect(range.end).toEqual(12)
      )

      it('null range', ->
        @quill.focus()
        @selection.setRange(new Quill.Lib.Range(0, 0))
        expect(@selection.checkFocus()).toBe(true)
        @selection.setRange(null)
        expect(@selection.checkFocus()).toBe(false)
        range = @selection.getRange()
        expect(range).toBe(null)
      )

      it('empty document', ->
        @container.innerHTML = '<div></div>'
        quill = new Quill(@container.firstChild)
        quill.editor.selection.setRange(new Quill.Lib.Range(0, 0))
        expect(quill.editor.selection.checkFocus()).toBe(true)
        range = quill.editor.selection.getRange()
        expect(range).not.toEqual(null)
        expect(range.start).toEqual(0)
        expect(range.end).toEqual(0)
      )
    )
  )

  # Shift after
  # Preserve
    # We modify dat DOM
)
