import json, tables, strutils

type
  Expense = object
    date: string
    amount: float
    category: string

proc enterExpense(expenses: var Table[string, seq[Expense]]): void =
  echo "Enter expense details:"
  echo "Date (YYYY-MM-DD): "
  let date = readLine(stdin)
  echo "Amount: "
  let amount = parseFloat(readLine(stdin))
  echo "Category: "
  let category = readLine(stdin)

  let expense: Expense = Expense(date: date, amount: amount, category: category)

  expenses.add(date, @[expense])  # Wrap the expense object in a sequence

  echo "Expense added successfully."

proc generateReport(expenses: Table[string, seq[Expense]]): void =
  echo "Expense Report:"
  for key, value in expenses.pairs:
    echo "Date: ", key
    for expense in value:
      echo "Amount: ", expense.amount
      echo "Category: ", expense.category
    echo "-----------------"

proc main() =
  var expenses: Table[string, seq[Expense]] = initTable[string, seq[Expense]]()

  while true:
    echo "Expense Tracker Menu:"
    echo "1. Enter Expense"
    echo "2. Generate Report"
    echo "3. Exit"
    echo "Enter your choice: "
    let choice = parseInt(readLine(stdin))

    case choice
    of 1:
      enterExpense(expenses)
    of 2:
      generateReport(expenses)
    of 3:
      break
    else:
      echo "Invalid choice. Please try again."

  echo "Exiting Expense Tracker."

when isMainModule:
  main()
