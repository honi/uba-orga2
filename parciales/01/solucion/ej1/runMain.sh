#!/usr/bin/env bash
reset

command -v valgrind > /dev/null
if [ $? -ne 0 ]; then
  echo "ERROR: No se encuentra valgrind."
  exit 1
fi

make main
if [ $? -ne 0 ]; then
  echo "ERROR: Error de compilacion."
  exit 1
fi

valgrind --show-reachable=yes --leak-check=full --error-exitcode=1 ./main
if [ $? -ne 0 ]; then
  echo "  **Error de memoria"
  exit 1
fi

