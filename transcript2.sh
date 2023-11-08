# Input file containing HTML content
input_file="mymp3s.txt"

# Output CSV file
output_file="transcripts.csv"

# Remove the existing transcripts.csv file if it exists
if [ -e "$output_file" ]; then
    rm "$output_file"
fi

# Create the CSV file and add headers
echo "file_name, chickasaw_text, english_text" > "$output_file"

# Loop over each line in the input file
while IFS= read -r html_content; do
    # Extract Chickasaw content between <span> tags, ignoring <u> and <i> tags
    chickasaw_text=$(echo "$html_content" | grep -o '<span>.*</span>' | sed 's/<[^>]*>//g')

    # Extract the file name (whatever is before the .mp3 part)
    file_name=$(echo "$html_content" | grep -o 'href="audio/\(.*\).mp3' | sed 's/href="audio\///' | sed 's/\.mp3//')

    # Remove whitespace between the last alphabet character and ".txt"
    # file_name=$(echo "$file_name" | sed 's/\(.*[A-Za-z]\)[[:space:]]*\.txt/\1.txt/')
    file_name=$(echo "$file_name" | sed 's/^[[:space:]]*//' | sed 's/\.mp3/.mp3/')

    # Replace underscores with spaces in the file_name
    english_text=$(echo "$file_name" | sed 's/_/ /g')

    # Add the data to the CSV file
    if [[ -n "$file_name" && -n "$chickasaw_text" ]]; then
        echo "\"$file_name.mp3\", \"$chickasaw_text\", \"$english_text\"" >> "$output_file"
    fi

done < "$input_file"
