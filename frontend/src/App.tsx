import React from 'react'
import { Outlet, Link } from 'react-router-dom'

export default function App() {
  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white shadow">
        <div className="max-w-4xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl font-bold text-gray-900">DelhiveryApp (MVP)</h1>
          <nav className="mt-2">
            <Link to="/" className="mr-4 text-blue-600">Create</Link>
            <Link to="/track" className="text-blue-600">Track</Link>
          </nav>
        </div>
      </header>
      <main className="py-6">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <Outlet />
        </div>
      </main>
    </div>
  )
}
