import { defineConfig } from 'vite'

export default async () => {
  const { default: react } = await import('@vitejs/plugin-react')
  return defineConfig({
    plugins: [react()],
  })
}
