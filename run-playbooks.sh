#!/bin/bash

# Farben
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
RESET="\e[0m"

SITE_PLAYBOOK="playbook.yml"
LOGFILE="ansible-run.log"

# Standardwerte
DRYRUN=true
LOG=true
TAGS=""
SKIP_TAGS=""
LIMIT=""
STEP=false
DIFF=true
CHECK_INVENTORY=false
USER_OPTION=""

show_help() {
  echo -e "${GREEN}Ansible Playbook Runner${RESET}"
  echo
  echo "Syntax: $0 [Optionen]"
  echo
  echo "Optionen:"
  echo "  -a, --apply                  Änderungen durchführen (kein Dry-Run)"
  echo "  -t, --tags TAG1,TAG2         Nur Aufgaben mit diesen Tags ausführen"
  echo "  -s, --skip-tags TAG1,TAG2    Aufgaben mit diesen Tags überspringen"
  echo "  -lm, --limit-machine HOST    Nur auf bestimmten Host im Inventory anwenden"
  echo "  -u, --user USERNAME          SSH-Benutzername für die Verbindung setzen"
  echo "  --step                       Schrittweise ausführen (interaktiv)"
  echo "  --check-inventory            Vorab Inventar & Erreichbarkeit prüfen"
  echo "  -h, --help                   Diesen Hilfetext anzeigen"
  echo
  echo "Standardverhalten:"
  echo "  - Dry-Run (kein Apply)"
  echo "  - Diff-Anzeige aktiv"
  echo "  - Logfile ($LOGFILE) wird bei jedem Lauf neu geschrieben"
}

check_inventory() {
  echo -e "${BLUE}>>> Überprüfe Inventory (ansible all -m ping)...${RESET}"
  CMD="ansible all -i inventory -m ping"
  [[ -n "$USER_OPTION" ]] && CMD+=" --user $USER_OPTION"
  eval "$CMD"
  exit 0
}

run_playbook() {
  echo -e "${BLUE}>>> Playbook: ${SITE_PLAYBOOK}${RESET}"
  [[ "$DRYRUN" = true ]] && echo -e "${YELLOW}>>> Modus: Dry Run (ohne Änderungen)${RESET}" || echo -e "${GREEN}>>> Modus: Apply (Änderungen werden durchgeführt)${RESET}"
  [[ -n "$TAGS" ]] && echo -e "${BLUE}>>> Tags: ${TAGS}${RESET}"
  [[ -n "$SKIP_TAGS" ]] && echo -e "${BLUE}>>> Skip-Tags: ${SKIP_TAGS}${RESET}"
  [[ -n "$LIMIT" ]] && echo -e "${BLUE}>>> Limit: ${LIMIT}${RESET}"
  [[ "$STEP" = true ]] && echo -e "${BLUE}>>> Interaktiver Schritt-für-Schritt-Modus aktiv${RESET}"
  [[ -n "$USER_OPTION" ]] && echo -e "${BLUE}>>> Benutzer: $USER_OPTION${RESET}"
  echo -e "${BLUE}>>> Logfile wird neu erstellt: ${LOGFILE}${RESET}"

  > "$LOGFILE"

  CMD="ansible-playbook $SITE_PLAYBOOK"
  [[ "$DRYRUN" = true ]] && CMD+=" --check"
  [[ "$DIFF" = true ]] && CMD+=" --diff"
  [[ -n "$TAGS" ]] && CMD+=" --tags $TAGS"
  [[ -n "$SKIP_TAGS" ]] && CMD+=" --skip-tags $SKIP_TAGS"
  [[ -n "$LIMIT" ]] && CMD+=" --limit $LIMIT"
  [[ "$STEP" = true ]] && CMD+=" --step"
  [[ -n "$USER_OPTION" ]] && CMD+=" --user $USER_OPTION"

  CMD+=" | tee $LOGFILE"
  eval "$CMD"
}

# Argumentverarbeitung
while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--apply)
      DRYRUN=false
      shift
      ;;
    -t|--tags)
      TAGS="$2"
      shift 2
      ;;
    -s|--skip-tags)
      SKIP_TAGS="$2"
      shift 2
      ;;
    -lm|--limit-machine)
      LIMIT="$2"
      shift 2
      ;;
    -u|--user)
      USER_OPTION="$2"
      shift 2
      ;;
    --step)
      STEP=true
      shift
      ;;
    --check-inventory)
      CHECK_INVENTORY=true
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo -e "${RED}Unbekannte Option: $1${RESET}"
      show_help
      exit 1
      ;;
  esac
done

[[ "$CHECK_INVENTORY" = true ]] && check_inventory

run_playbook