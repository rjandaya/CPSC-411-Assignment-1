import Kitura
import Cocoa

let router = Router()
let dbObj = Database.getInstance()

router.all("/ClaimService/add", middleware: BodyParser())

// http://localhost:8020/ClaimService/getAll
router.get("/ClaimService/getAll") {
    request, response, next in
    let cList = ClaimDAO().getAll()
//    JSON Serialization
    let jsonData: Data = try JSONEncoder ().encode(cList)
//    JSONArray
    let jsonStr = String(data: jsonData, encoding: .utf8)
    response.send(jsonStr)
    next()
}

// http://localhost:8020/ClaimService/add
// Postman POST Body: {"title":"Fraud","date":"2020 10-25","is_solved":0}
router.post("/ClaimService/add") {
//    JSON Deserialization
    request, response, next in
    let body = request.body
    let jObj = body?.asJSON         // JSON Object
    if let jDict = jObj as? [String:String] {
        if let title = jDict["title"],
           let date = jDict["date"] {
            let cObj = Claim(id: UUID().uuidString, title: title, date: date, isSolved: 0)
            ClaimDAO().addClaim(cObj: cObj)
        }
    }
    response.send("The Claim record was successfully inserted (via POST Method)")
}

// NOTE:
// Kill the process on the port, run in terminal
// Lsof -i tcp:8020
// Kill -9 <PID>
// or
// Change port # on repetitive runs
Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()
