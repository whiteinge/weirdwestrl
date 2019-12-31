
var Benchmark = require('benchmark')
var suite = new Benchmark.Suite()

suite
  .add('functionName', functionName)
  .on('cycle', function(event) { console.log(String(event.target)) })
  .on('complete', function() {
    console.log('Fastest is ' + this.filter('fastest').map('name'))
  })
  .run({ async: true })
