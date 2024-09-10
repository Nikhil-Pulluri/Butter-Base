import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import Navbar from './components/Navbar/Navbar'
import Sidebar from './components/Sidebar'
import Card from './components/Card'
import Tag from './components/Tag'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <Navbar/>
      <div id="main">
        <div id="sidebar">
        <Sidebar/>
        </div>
        <div id="content">
          {[...Array(5)].map((_, index) => (
              <Card/>
            ))}
        </div>
        <div id="sidecontent">
          <div>
            <h4>Top Artists</h4>
            {[...Array(3)].map((_, index) => (
                <Tag/>
              ))}
          </div>
        </div>
      </div>
    </>
  )
}

export default App
