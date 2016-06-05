import Kitura

let k = Kir()
let router = Router()

k.use(Logger())
k.useHandler(handler: router)

k.run(port: 8000)