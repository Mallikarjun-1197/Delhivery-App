import React from 'react'

export default function Track() {
  return (
    <div>
      <h2 className="text-xl font-semibold mb-4">Track shipment</h2>
      <div className="space-y-4">
        <input placeholder="Enter booking ID" className="w-64 border p-2 rounded" />
        <div className="p-4 border rounded">Tracking status will appear here for the skeleton MVP.</div>
      </div>
    </div>
  )
}
