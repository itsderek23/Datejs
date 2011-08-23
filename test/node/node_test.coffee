fs = require('fs')
path = require('path')

root = path.normalize(path.join(__dirname, '../..'))

files = [ 'globalization/en-US.js', 'core.js', 'extras.js', 'parser.js', 'sugarpak.js', 'time.js' ]

for filename in files
  data = fs.readFileSync path.join(root, 'src', filename), 'utf-8'
  eval data

class Specification
  constructor: (@spec) ->

testDirectories = [ 'core', 'date', 'date_and_time', 'date_math', 'dst', 'parseExact', 'partial', 'relative', 'relative_date_and_time', 'rememberthemilk', 'ruby_chronic', 'sugarpak', 'time', 'tostring' ]

for testDirectory in testDirectories
  data = fs.readFileSync path.join(root, 'test', testDirectory, 'index.js'), 'utf-8'
  eval data
    
  spec = Date.Specification.spec
  Date.Specification = undefined

  for contextName, tests of spec
    group = exports["#{testDirectory}: #{contextName}"] = {}
    setupBlock = (block for name, block of tests when name == 'setup')[0]

    for testName, testBody of tests
      continue if testName == 'setup'
      do (setupBlock, testName, testBody) ->
        group[testName] = (test) ->
          setupBlock.call(this)   if setupBlock
          testBody.run.call(this) if testBody.run
          test.ok(testBody.assert.call(this), testBody.assert)
          test.done()
