#!/bin/bash
hour=$(date +%H)
min=$(date +%M)
period="${hour}:$([ $min -lt 30 ] && echo '00' || echo '30')"

names=("Matheus" "Senpai" "Player One" "Protagonist" "root" "dev" "Chosen One" "sudo user" "architect")
name=${names[$RANDOM % ${#names[@]}]}

case $period in
    "00:00") echo "Midnight, $name. The cron jobs run. So do you." ;;
    "00:30") echo "The logs are quiet, $name. Too quiet." ;;
    "01:00") echo "The compiler never sleeps, $name. But maybe you should." ;;
    "01:30") echo "This commit better be worth it, $name." ;;
    "02:00") echo "Dark mode isn't just aesthetic anymore, $name." ;;
    "02:30") echo "Save. Close. Sleep. In that order, $name." ;;
    "03:00") echo "The void opened a PR, $name. You're reviewing it." ;;
    "03:30") echo "Even the servers are asleep, $name. Follow them." ;;
    "04:00") echo "Final arc or touching grass, $name. Choose one." ;;
    "04:30") echo "The debug session has gone too far, $name." ;;
    "05:00") echo "5AM, $name. Early bird gets the merge conflict." ;;
    "05:30") echo "Sunrise loading, $name. Please wait." ;;
    "06:00") echo "The terminal is cold, $name. Warm it up." ;;
    "06:30") echo "Coffee before the first segfault of the day, $name." ;;
    "07:00") echo "Your codebase missed you, $name." ;;
    "07:30") echo "Stand-up arc begins soon, $name. Ship something first." ;;
    "08:00") echo "Time to open 47 tabs and close none, $name." ;;
    "08:30") echo "The day boss fight is loading, $name." ;;
    "09:00") echo "9AM, $name. Stand-up in how long?" ;;
    "09:30") echo "Peak hours, $name. No distractions. Maybe." ;;
    "10:00") echo "Main quest or side quest today, $name?" ;;
    "10:30") echo "The stack is watching, $name. Don't disappoint." ;;
    "11:00") echo "Lunch arc incoming, $name. Hold the line." ;;
    "11:30") echo "Save your progress before noon hits, $name." ;;
    "12:00") echo "Lunch arc unlocked, $name. You earned it." ;;
    "12:30") echo "Still at the keyboard, $name? Eat something." ;;
    "13:00") echo "Post-lunch grind begins, $name. Don't let the food coma win." ;;
    "13:30") echo "The afternoon boss waits, $name. Whenever you're ready." ;;
    "14:00") echo "The sleepy hours are here, $name. Ctrl+C on the nap." ;;
    "14:30") echo "Second wind incoming, $name. Any moment now." ;;
    "15:00") echo "Side quest or main story, $name? Choose wisely." ;;
    "15:30") echo "The afternoon boss is still beatable, $name." ;;
    "16:00") echo "Don't start anything you can't finish before dark, $name." ;;
    "16:30") echo "Final stretch of the day shift, $name." ;;
    "17:00") echo "5PM, $name. Day shift ends. The real arc begins." ;;
    "17:30") echo "Evening mode activated, $name." ;;
    "18:00") echo "Coffee or dark mode, $name? Both. Always both." ;;
    "18:30") echo "New chapter of the day unlocked, $name." ;;
    "19:00") echo "Prime time for deep work, $name. Or anime. No judgment." ;;
    "19:30") echo "The evening grind hits different, $name." ;;
    "20:00") echo "This is the way, $name." ;;
    "20:30") echo "Still shipping features, $name? Respect." ;;
    "21:00") echo "Don't push to main at this hour, $name. Seriously." ;;
    "21:30") echo "The night is young, $name. Your bugs are not." ;;
    "22:00") echo "Saving progress before the final boss: sleep, $name." ;;
    "22:30") echo "One more commit, $name. Just one. We both know." ;;
    "23:00") echo "Commit, push, rest, $name. In that order." ;;
    "23:30") echo "11:30PM, $name. Midnight is loading. Wrap it up." ;;
esac