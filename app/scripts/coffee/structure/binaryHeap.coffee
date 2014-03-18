
define ->
  class BinaryHeap
    constructor: (scoreFunction) ->
      @content = []
      @scoreFunction = scoreFunction

    push: (element) =>

      # Add the new element to the end of the array.
      @content.push element

      # Allow it to sink down.
      @sinkDown @content.length - 1
      return

    pop: =>
      # Store the first element so we can return it later.
      result = @content[0]

      # Get the element at the end of the array.
      end = @content.pop()

      # If there are any elements left, put the end element at the
      # start, and let it bubble up.
      if @content.length > 0
        @content[0] = end
        @bubbleUp 0
      result

    remove: (node) =>
      i = @content.indexOf(node)

      # When it is found, the process seen in 'pop' is repeated
      # to fill up the hole.
      end = @content.pop()
      if i isnt @content.length - 1
        @content[i] = end
        if @scoreFunction(end) < @scoreFunction(node)
          @sinkDown i
        else
          @bubbleUp i
      return

    size: =>
      @content.length

    rescoreElement: (node) =>
      @sinkDown @content.indexOf(node)
      return

    sinkDown: (n) =>

      # Fetch the element that has to be sunk.
      element = @content[n]

      # When at 0, an element can not sink any further.
      while n > 0

        # Compute the parent element's index, and fetch it.
        parentN = ((n + 1) >> 1) - 1
        parent = @content[parentN]

        # Swap the elements if the parent is greater.
        if @scoreFunction(element) < @scoreFunction(parent)
          @content[parentN] = element
          @content[n] = parent

          # Update 'n' to continue at the new position.
          n = parentN

        # Found a parent that is less, no need to sink any further.
        else
          break
      return

    bubbleUp: (n) =>

      # Look up the target element and its score.
      length = @content.length
      element = @content[n]
      elemScore = @scoreFunction(element)
      loop

        # Compute the indices of the child elements.
        child2N = (n + 1) << 1
        child1N = child2N - 1

        # This is used to store the new position of the element,
        # if any.
        swap = null
        child1Score = undefined

        # If the first child exists (is inside the array)...
        if child1N < length

          # Look it up and compute its score.
          child1 = @content[child1N]
          child1Score = @scoreFunction(child1)

          # If the score is less than our element's, we need to swap.
          swap = child1N  if child1Score < elemScore

        # Do the same checks for the other child.
        if child2N < length
          child2 = @content[child2N]
          child2Score = @scoreFunction(child2)
          if child2Score < ((if swap is null then elemScore else child1Score))
            swap = child2N

        # If the element needs to be moved, swap it, and continue.
        if swap isnt null
          @content[n] = @content[swap]
          @content[swap] = element
          n = swap

        # Otherwise, we are done.
        else
          break
      return
