#! /bin/bash

# Display last two lines of the log for debugging
echo "Debug: Last two lines of rx_poc.log:"
tail -2 rx_poc.log

# Parse yesterday's forecast and today's temperature
yesterday_fc=$(tail -2 rx_poc.log | head -1 | cut -d " " -f5 | sed 's/[^0-9-]//g')
today_temp=$(tail -1 rx_poc.log | cut -d " " -f4 | sed 's/[^0-9-]//g')

# Debugging: Show parsed values
echo "Debug: Parsed yesterday_fc='$yesterday_fc', today_temp='$today_temp'"

# Validate extracted values are numeric
if [[ -z "$yesterday_fc" ]]; then
    echo "Error: yesterday_fc is empty. Please check the log file format."
    exit 1
fi

if [[ -z "$today_temp" ]]; then
    echo "Error: today_temp is empty. Please check the log file format."
    exit 1
fi

if [[ ! "$yesterday_fc" =~ ^-?[0-9]+$ ]] || [[ ! "$today_temp" =~ ^-?[0-9]+$ ]]; then
    echo "Error: Invalid data in log file. Ensure both yesterday's forecast ($yesterday_fc) and today's temperature ($today_temp) are numeric."
    exit 1
fi

# Calculate accuracy
accuracy=$((yesterday_fc - today_temp))
echo "accuracy is $accuracy"

# Determine accuracy range
if [ $accuracy -ge -1 ] && [ $accuracy -le 1 ]; then
    accuracy_range="excellent"
elif [ $accuracy -ge -2 ] && [ $accuracy -le 2 ]; then
    accuracy_range="good"
elif [ $accuracy -ge -3 ] && [ $accuracy -le 3 ]; then
    accuracy_range="fair"
else
    accuracy_range="poor"
fi

echo "Forecast accuracy is $accuracy_range"

# Parse date components from the last log row
row=$(tail -1 rx_poc.log)
year=$(echo $row | cut -d " " -f1)
month=$(echo $row | cut -d " " -f2)
day=$(echo $row | cut -d " " -f3)

# Debugging: Show parsed date
echo "Debug: Parsed date year='$year', month='$month', day='$day'"

# Validate date components
if [[ ! "$year" =~ ^[0-9]{4}$ ]] || [[ ! "$month" =~ ^[0-9]{1,2}$ ]] || [[ ! "$day" =~ ^[0-9]{1,2}$ ]]; then
    echo "Error: Invalid date format in log file. Row: $row"
    exit 1
fi

# Append results to the historical accuracy file
echo -e "$year\t$month\t$day\t$today_temp\t$yesterday_fc\t$accuracy\t$accuracy_range" >> historical_fc_accuracy.tsv
