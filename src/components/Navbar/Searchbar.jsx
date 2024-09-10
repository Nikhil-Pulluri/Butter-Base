import React from 'react'

function Searchbar() {
  return (
    <div>
        <form id="searchbar">
            <img src="/search-icon.png" id="search-icon"/>
            <input type="text" placeholder="Search" id="search-input"/>
        </form>
    </div>
  )
}

export default Searchbar