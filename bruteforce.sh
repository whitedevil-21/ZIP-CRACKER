#!/bin/bash

# Colors for output
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# Welcome message
echo -e "${BLUE}ZIP Password Cracker - Debug Mode${RESET}"
echo -e "${YELLOW}Created for educational purposes only.${RESET}\n"

# Input ZIP file path
read -p "Enter the path of the ZIP file: " ZIP_FILE
if [ ! -f "$ZIP_FILE" ]; then
  echo -e "${RED}Error: ZIP file not found!${RESET}"
  exit 1
fi

# Input Wordlist path
read -p "Enter the path of the wordlist: " WORDLIST
if [ ! -f "$WORDLIST" ]; then
  echo -e "${RED}Error: Wordlist not found!${RESET}"
  exit 1
fi

# Start cracking
echo -e "\n${GREEN}Starting ZIP password cracking...${RESET}"
START_TIME=$(date +%s)

PASSWORD_FOUND=false
TRY_COUNT=0

while IFS= read -r password; do
  TRY_COUNT=$((TRY_COUNT + 1))
  echo -ne "${YELLOW}[Trying]${RESET} Password #$TRY_COUNT: $password\r"

  # Debugging: Check if unzip command works
  if unzip -P "$password" -tq "$ZIP_FILE" &>/dev/null; then
    echo -e "\n\n${GREEN}Password found: ${RESET}$password"
    PASSWORD_FOUND=true
    break
  else
    echo -ne "\n${RED}[Failed]${RESET} Password #$TRY_COUNT: $password\r"
  fi
done < "$WORDLIST"

# Calculate elapsed time
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))

if [ "$PASSWORD_FOUND" = true ]; then
  echo -e "\n${GREEN}Cracking successful!${RESET}"
  echo -e "Time taken: ${BLUE}$ELAPSED_TIME seconds${RESET}"
else
  echo -e "\n${RED}Password not found in the wordlist.${RESET}"
  echo -e "Time taken: ${BLUE}$ELAPSED_TIME seconds${RESET}"
fi

exit 0
