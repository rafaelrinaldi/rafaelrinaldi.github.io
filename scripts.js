;(function () {
  var colorModeKey = 'isDarkMode'

  var font = new FontFaceObserver('SpaceGrotesk')
  font.load().then(function () {
    document.body.classList.add('font-loaded')
  })

  var root = document.documentElement
  var theme = document.querySelector('[data-theme]')

  var colorModes = {
    light: {
      primary: '#fff',
      secondary: '#0a0a0a'
    },

    dark: {
      primary: '#0a0a0a',
      secondary: '#fff'
    }
  }

  function get (key) {
    return JSON.parse(localStorage.getItem(key))
  }

  function set (key, value) {
    localStorage.setItem(key, value)
  }

  function has (key) {
    return localStorage.getItem(key) !== null
  }

  function guessDarkMode () {
    return theme.dataset.theme === 'dark'
  }

  var hasColorModePreference = has(colorModeKey)

  function setColorMode (isDarkMode) {
    var nextColorMode = isDarkMode ? 'light' : 'dark'
    var colorMode = colorModes[nextColorMode]

    set(colorModeKey, isDarkMode)

    root.style.setProperty('--color-primary', colorMode.primary)
    root.style.setProperty('--color-secondary', colorMode.secondary)
  }

  function toggleColorMode () {
    var isDarkMode = has(colorModeKey) ? get(colorModeKey) : guessDarkMode()
    setColorMode(!isDarkMode)
  }

  window
    .matchMedia('(prefers-color-scheme: dark)')
    .addEventListener('change', function (event) {
      if (!hasColorModePreference) setColorMode(event.matches)
    })

  var colorMode = document.querySelector('[data-color-mode]')
  colorMode.addEventListener('click', toggleColorMode)

  if (hasColorModePreference) {
    var colorModePreference = get(colorModeKey)
    setColorMode(colorModePreference)
  } else {
    var isDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches
    set(colorModeKey, isDarkMode)
  }
})()
