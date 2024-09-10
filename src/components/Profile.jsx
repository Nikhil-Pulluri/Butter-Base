import React from 'react'

function Profile() {
  return (
    <div id="profile">
        <div id="details">
            <div id= "PI">
                <img src="" alt="Profile Picture"/>
                <div id="deets">
                    <h3>Name</h3>
                    <p>City, State, Country</p>
                </div>
            </div>
            <div id="bio">
                <h3>Bio</h3>
                <p>I am Sergeant Peanut Butter. I am a wonderful B99 horse. NEIGH!!!!</p>
            </div>
        </div>
        <div id="properties">
            <div id="prop-bt">
                <button id="pb-bt">Public</button>
                <button id="pvt-bt">Private</button>
            </div>
            <div id="myprop">
                <img src="/ArtPlaceholder.png"/>
            </div>
        </div>
    </div>
  )
}

export default Profile