import os
import strformat
import strutils

type
  Task = object
    name: string
    completed: bool

proc displayTasks(tasks: seq[Task]) =
  for i, task in tasks:
    let status = if task.completed: " [x]" else: " [ ]"
    echo $i & ". " & task.name & status

proc addTask(tasks: var seq[Task], name: string) =
  tasks.add(Task(name: name, completed: false))

proc completeTask(tasks: var seq[Task], index: int) =
  if index >= 0 and index < tasks.len:
    tasks[index].completed = true
  else:
    echo "Invalid task index"

proc deleteTask(tasks: var seq[Task], index: int) =
  if index >= 0 and index < tasks.len:
    tasks.del(index)
  else:
    echo "Invalid task index"

proc main() =
  var tasks: seq[Task] = @[]

  while true:
    echo "Task Manager"
    echo "1. View Tasks"
    echo "2. Add Task"
    echo "3. Complete Task"
    echo "4. Delete Task"
    echo "0. Exit"
    let choice = parseInt(readLine(stdin))

    case choice
    of 1:
      displayTasks(tasks)
    of 2:
      echo "Enter task name:"
      let name = readLine(stdin)
      addTask(tasks, name)
    of 3:
      echo "Enter task index to complete:"
      let index = parseInt(readLine(stdin))
      completeTask(tasks, index)
    of 4:
      echo "Enter task index to delete:"
      let index = parseInt(readLine(stdin))
      deleteTask(tasks, index)
    of 0:
      return
    else:
      echo "Invalid choice. Please try again."
    echo ""

when isMainModule:
  main()
