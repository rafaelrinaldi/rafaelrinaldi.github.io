var getStdin = require('get-stdin')
var keys = Object.keys

function flatten (array) {
  return array.reduce(function (previous, current) {
    return previous.concat(current)
  })
}

function get (data, key) {
  return data[key] || data[`og:${key}`] || data[`twitter:${key}`]
}

function hasKey (data, key, category) {
  var falsy
  var _category = category ? `${category}:` : ''

  return data[`${_category}${key}`] !== falsy
}

function processStandard (data) {
  return keys(data).filter(function (key) {
    return !['twitter', 'og'].includes(key)
  }).map(function (key) {
    var value = data[key]

    return {
      name: key,
      content: Array.isArray(value) ? value.join(', ').trim() : value
    }
  })
}

function processOptional () {
  return [
    {charset: 'utf-8'}
  ]
}

function processPrefixed (data, prefix) {
  var attribute = /og/i.test(prefix) ? 'property' : 'name';

  var defaults = ['description', 'image', 'title'].map(function (key) {
    if (hasKey(data, key)) return {name: `${prefix}:${key}`, content: get(data, key)}
  })

  var prefixed = keys(data[prefix]).map(function (key) {
    return {[attribute]: `${prefix}:${key}`, content: data[prefix][key]}
  })

  return flatten([defaults, prefixed])
}

function render (data) {
  return data.map(function (node) {
    return keys(node).reduce(function (_, key) {
      return `${_} ${key}="${node[key]}"`
    }, '<meta').concat('>')
  }).join('\n')
}

getStdin().then(function (data) {
  var json = JSON.parse(data)
  var tree = flatten([
    processOptional(json),
    processStandard(json),
    processPrefixed(json, 'og'),
    processPrefixed(json, 'twitter')
  ])

  process.stdout.write(render(tree))
}).catch(function (error) {
  console.log(error)
  process.exit(1)
})
