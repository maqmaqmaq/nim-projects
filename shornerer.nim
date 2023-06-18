import jester, json, strutils, random

const BaseURL = "https://your-domain.com/"
var urlDB: Table[string, string] = initTable[string, string]()

proc isNilOrWhitespace(str: string): bool =
  str.strip.isNilOrWhitespace

proc randomString(length: int): string =
  var result: string
  for _ in 0..<length:
    result.add("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"[random.rand(62)])
  return result

proc shortenURL(req: Request): JsonNode =
  let longURL = req.params.getOrDefault("url", "")
  if isNilOrWhitespace(longURL):
    result = %*{"error": "Invalid URL"}
  else:
    let shortURL = BaseURL & randomString(5)
    urlDB[shortURL] = longURL
    result = %*{"shortURL": shortURL}

proc redirect(req: Request): Response =
  let shortURL = req.pathParams.getOrDefault("shortURL", "")
  if shortURL in urlDB:
    var result = newResponse(Http302, "")
    result.headers.add("Location", urlDB[shortURL])
    return result
  else:
    result = newResponse(Http404, "URL not found")

proc main() =
  let router = newRouter()
  router.get("/shorten", shortenURL)
  router.get("/:shortURL", redirect)
  serve(Port(5000), router)

when isMainModule:
  main()
