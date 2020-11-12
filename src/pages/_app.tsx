import React from 'react'
import { AppProps } from 'next/app'
import 'ress'
import { Global, css } from '@emotion/react'
import AppProvider from 'store'

const App = ({ Component, pageProps }: AppProps) => {
  return (
    <AppProvider>
      <>
        <Global styles={globalStyles} />
        <Component {...pageProps} />
      </>
    </AppProvider>
  )
}

export default App

const globalStyles = css`
  html {
    width: 100vw;
    overflow-x: hidden;
  }

  a {
    text-decoration: none;
  }
`
