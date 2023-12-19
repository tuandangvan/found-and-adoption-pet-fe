import { useState } from 'react'
import RouterAdmin from './routes/RouterAdmin'
import Auth from './routes/Auth'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <Auth/>
  )
}

export default App
