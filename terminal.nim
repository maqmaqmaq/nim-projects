from terminal import getch

stdout.write("May you tell me your name: ")
var answer = readLine(stdin)
if answer != "no":
  echo "Nice to meet you, ", answer
echo "Press any key to continue"
let c = getch()
echo "OK, let us continue, you pressed key:", c