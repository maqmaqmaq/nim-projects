import os
import json
import strutils
import std/db_sqlite
import nimx/[window, layout, button, text_field, split_view, scroll_view, context]

type
  Snippet = object
    title: string
    code: string
    tags: seq[string]

var db: DbConn

proc openDatabase(): void =
  db = open("mytest.db","","","")
  db.exec(sql"""
    CREATE TABLE IF NOT EXISTS snippets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      code TEXT,
      tags TEXT
    );
  """)

proc addSnippet(title: string, code: string, tags: seq[string]): void =
  let tagsString = tags.join(",")
  db.exec(sql"""
    INSERT INTO snippets (title, code, tags) VALUES (?, ?, ?);
  """, title, code, tagsString)

proc searchSnippets(query: string): seq[Snippet] =
  var matchedSnippets: seq[Snippet] = @[]

  let stmt = db.prepare("SELECT title, code, tags FROM snippets WHERE title LIKE ? OR code LIKE ?")
  stmt.bindParams("%" & query & "%","%" & query & "%")

  for row in db.rows(stmt):
   let title = row[0]
   let code = row[1]
   let tagsString = row[2]
   let tags = tagsString.split(",")
   let snippet: Snippet = Snippet(title: title, code: code, tags: tags)
   matchedSnippets.add(snippet)

  return matchedSnippets

proc displaySnippet(snippet: Snippet): string =
  var output = ""
  output = output & "Title: " & snippet.title
  output = output & "Code: " & snippet.code
  output = output & "Tags: " & snippet.tags.join(", ")
  output = output & "-----------------"
  return output

proc displaySnippets(snippets: seq[Snippet]): string =
  if len(snippets) == 0:
    return "No snippets found."
  else:
    var outp = ""
    for snippet in snippets:
      outp = outp & displaySnippet(snippet)
    return outp

proc readTags(tagsInput: string): seq[string] =
  let tags = tagsInput.split(",")
  return tags

proc main() =
  openDatabase()

  let red = newColor(1, 0, 0)
  let blue = newColor(0, 0, 1)
  let yellow = newColor(1, 1, 0)

  runApplication:
    let w = newWindow(newRect(50, 50, 700, 350))
    let margin = 5.0
    w.makeLayout: # DSL follows
          - TextField as title:
              centerX == super
              top == super
              width == 100
              height == 40
              text: "title"
          - TextField as code:
              centerX == super
              top == prev.bottom + 5
              width == 100
              height == 40
              text: "code"
          - TextField as tags:
              centerX == super
              top == prev.bottom + 5
              width == 100
              height == 40
              text: "tags"
          - TextField as lista:
              top == super
              left == 5
              width == 100
              height == 150
              text: displaySnippets(searchSnippets(""))
          - Button: # Add a view of type Button. We're not referring to it so it's anonymous.
              centerX == super # center horizontally
              top == prev.bottom + 5 # the button should be lower than the label by 5 points
              width == 100
              height == 25
              title: "Add Snippet"
              onAction:
                  addSnippet(title.text,code.text,readTags(tags.text))
          - TextField as search:
              centerX == super
              top == prev.bottom + 5
              width == 100
              height == 25
              text: "search"
          - Button: # Add a view of type Button. We're not referring to it so it's anonymous.
              centerX == super # center horizontally
              top == prev.bottom + 5 # the button should be lower than the label by 5 points
              width == 100
              height == 25
              title: "Search Snippet"
              onAction:
                  lista.text = displaySnippets(searchSnippets(search.text))
          - Button: # Add a view of type Button. We're not referring to it so it's anonymous.
              centerX == super # center horizontally
              top == prev.bottom + 5 # the button should be lower than the label by 5 points
              width == 100
              height == 25
              title: "Exit"
              onAction:
                  quit()


  # while true:
  #   echo "Code Snippet Manager Menu:"
  #   echo "1. Add Snippet"
  #   echo "2. Search Snippets"
  #   echo "3. Exit"
  #   let choice = parseInt(readLine(stdin))

  #   case choice
  #   of 1:
  #     echo "Add Snippet"
  #     echo "Title: "
  #     let title = readLine(stdin)
  #     let code = readCode("Code: ")
  #     let tags = readTags("Tags (comma-separated): ")
  #     addSnippet(title, code, tags)
  #     echo "Snippet added successfully."
  #   of 2:
  #     echo "Search Snippets"
  #     echo "Enter search query: "
  #     let query = readLine(stdin)
  #     let matchedSnippets = searchSnippets(query)
  #     displaySnippets(matchedSnippets)
  #   of 3:
  #     break
  #   else:
  #     echo "Invalid choice. Please try again."

  # echo "Exiting Code Snippet Manager."

when isMainModule:
  main()
