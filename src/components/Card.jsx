import React from 'react'

function Card() 
{
  return (
    <div id="card">
        <div className="user-info">
            <img src="/User.png" alt="User Profile"/>
            <span>Name</span>
        </div>
        <img src="/ArtPlaceholder.png" alt="Art Piece" className="art"/>
        <div className="desc">
            <div className="art-details">
                <p>Description:</p>
            </div>
            <div className="actions">
                <img src="/like.png" alt="Like" className="action-bt"/>
                <img src="/comment.png" alt="Comment" className="action-bt"/>
                <img src="/save.png" alt="Save" className="action-bt"/>
                <button id="buy"><strong>Buy</strong></button>
            </div>
        </div>
    </div>
  )
}

export default Card