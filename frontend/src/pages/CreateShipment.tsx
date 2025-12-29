import React, { useState } from 'react'

type PackageItem = {
  id: number
  type: string
  weight: number
  length?: number
  width?: number
  height?: number
  value?: number
}

export default function CreateShipment() {
  const [packages, setPackages] = useState<PackageItem[]>([
    { id: 1, type: 'Box', weight: 1 }
  ])

  function addPackage() {
    setPackages(p => [...p, { id: Date.now(), type: 'Box', weight: 1 }])
  }

  return (
    <div>
      <h2 className="text-xl font-semibold mb-4">Create Shipment</h2>
      <form className="space-y-4">
        <div>
          <label className="block text-sm font-medium">Pickup address</label>
          <input className="mt-1 block w-full border rounded p-2" placeholder="Address line" />
        </div>
        <div>
          <label className="block text-sm font-medium">Delivery address</label>
          <input className="mt-1 block w-full border rounded p-2" placeholder="Address line" />
        </div>

        <div>
          <label className="block text-sm font-medium">Pickup date</label>
          <input type="date" className="mt-1 block w-64 border rounded p-2" />
        </div>

        <div>
          <label className="block text-sm font-medium">Packages</label>
          <div className="mt-2 space-y-2">
            {packages.map(p => (
              <div key={p.id} className="p-3 border rounded flex items-center gap-3">
                <input className="border p-1 w-24" defaultValue={p.type} />
                <input className="border p-1 w-24" defaultValue={String(p.weight)} />
                <button type="button" className="text-sm text-red-600">Remove</button>
              </div>
            ))}
            <button type="button" onClick={addPackage} className="mt-2 text-sm text-blue-600">+ Add package</button>
          </div>
        </div>

        <div>
          <button type="submit" className="px-4 py-2 bg-blue-600 text-white rounded">Create Shipment</button>
        </div>
      </form>
    </div>
  )
}
