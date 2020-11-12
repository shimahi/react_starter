import { ReactNode } from 'react'
import { ApolloClient, ApolloProvider, InMemoryCache, HttpLink } from '@apollo/client'

import { CacheProvider } from '@emotion/react'
import { cache as emotionCache } from '@emotion/css'

const cache = new InMemoryCache()
const link = new HttpLink({
  uri: process.env.NEXT_PUBLIC_GRAPHQL_ENDPOINT,
})

const client = new ApolloClient({
  cache,
  link,
})

type AppProviderProps = {
  children: ReactNode
}

const AppProvider = ({ children }: AppProviderProps) => {
  return (
    <ApolloProvider client={client}>
      <CacheProvider value={emotionCache}>{children}</CacheProvider>
    </ApolloProvider>
  )
}

export default AppProvider
