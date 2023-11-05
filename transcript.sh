# Input file containing HTML content
input_file="mymp3s.txt"

# Remove the "transcripts" directory if it exists
rm -r transcripts 2>/dev/null

# Create the "transcripts" directory
mkdir -p transcripts

# head or tail/n1 to get certain lines
# Loop over each line in the input file
while IFS= read -r html_content; do
    # Extract Chickasaw content between <span> tags, ignoring <u> and <i> tags
    chickasaw_text=$(echo "$html_content" | grep -o '<span>.*</span>' | sed 's/<[^>]*>//g')

    # Extract the file name (whatever is before the .mp3 part)
    file_name=$(echo "$html_content" | grep -o 'href="audio/\(.*\).mp3' | sed 's/href="audio\///' | sed 's/\.mp3//')

    # Remove whitespace between the last alphabet character and ".txt"
    file_name=$(echo "$file_name" | sed 's/\(.*[A-Za-z]\)[[:space:]]*\.txt/\1.txt/')

    # Replace underscores with spaces in the file_name
    english_text=$(echo "$file_name" | sed 's/_/ /g')

    # Create a new .txt file with the Chickasaw content in the "transcripts" directory
    if [[ -n "$file_name" && -n "$chickasaw_text" ]]; then
        echo -e "$english_text, $chickasaw_text" > "transcripts/${file_name}.txt"
        echo "File Name: transcripts/${file_name}.txt"
    fi

done < "$input_file"