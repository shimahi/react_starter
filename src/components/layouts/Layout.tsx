import React, { ReactNode } from 'react'
import Head from 'next/head'

type LayoutProps = {
  children: ReactNode
}

export const Layout = ({ children }: LayoutProps) => {
  return (
    <>
      <Head>
        <title>Document</title>
        {/* <link rel="icon" href="/favicon.ico" /> */}
      </Head>
      <main>{children}</main>
    </>
  )
}
