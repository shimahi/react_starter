import React from 'react'

// 静的ファイルは絶対パスで記述
import styles from 'assets/css/Hero.pcss'
import logo from 'assets/images/logo-w.png'

const Hero = () => (
  <section className={styles.hero}>
    <img src={logo} alt='' />
  </section>
)

export default Hero;
