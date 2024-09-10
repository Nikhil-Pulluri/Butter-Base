import React from 'react'

function PicGrid() {
  return (
    <div id="picgrid">
        {[...Array(5)].map((_, index) => (
                <img src="/ArtPlaceholder.png"></img>
              ))}
    </div>
  )
}

export default PicGrid