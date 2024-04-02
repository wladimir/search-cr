# Search

Sample application in Crystal that indexes the contents of text files and allows lookup by specific terms.

## Usage

```
❯ WORKERS=4 crystal run src/main.cr -- -q "monopolistic" -d "./input"
Found 'monopolistic' in file './input/input_3.txt' on lines: 2
```