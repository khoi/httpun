import App

let config = try Config()

let drop = try Droplet(config)
try drop.setup()

try drop.run()
