module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  roots: ['<rootDir>/src'],
  moduleDirectories: ['src', 'node_modules'],
  moduleNameMapper: {
    'src/(.*)$': '<rootDir>/src/$1',
  },
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json'],
  testPathIgnorePatterns: ['<rootDir>/.next/', '<rootDir>/node_modules/'],
  transform: {
    '^.+\\.(ts|tsx)$': 'ts-jest',
  },
  globals: {
    // test 時に TypeScript の設定を一部変更して実行する設定
    'ts-jest': {
      tsconfig: {
        jsx: 'react-jsx',
      },
    },
  },
}
