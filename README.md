# Kir

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

A [negroni](https://github.com/urfave/negroni) like micro-framework based on [Kitura](https://github.com/IBM-Swift/Kitura).

**This is currently WIP and API is not frozen yet.**

# Usage

```swift 
import Kitura
import Kir 

let k = Kir()
let router = Router()

k.use(Logger())
k.useHandler(handler: router)
k.run(port: 8000)
```
