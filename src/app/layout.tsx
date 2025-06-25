// src/app/layout.tsx
import 'src/app/globals.css'
import { Providers } from '@/components/Providers'

export const metadata = {
  title: 'My Asset App',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  )
}
