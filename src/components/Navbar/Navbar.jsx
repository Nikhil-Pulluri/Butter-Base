import React from 'react'
import Searchbar from './Searchbar'

function Navbar() {
  return (
    <div id="header">
        <a href="#"><img src="/ButterBase.png" id="logo"/></a>
        <Searchbar/>
        <button id="login">Login</button>
    </div>
  )
}

export default Navbar