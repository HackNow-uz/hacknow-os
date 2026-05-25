#!/bin/bash
# Toolset bo'yicha tool sanash

echo "HackNow OS — Tool hisobi"
echo "========================="

total=0
for f in toolsets/*.txt; do
    category=$(basename "$f" .txt | sed 's/^[0-9]*-//')
    count=$(grep -v '^#' "$f" | grep -v '^$' | grep -v '^\s' | wc -l)
    printf "%-20s %d\n" "$category" "$count"
    total=$((total + count))
done

echo "========================="
printf "%-20s %d\n" "JAMI" "$total"
