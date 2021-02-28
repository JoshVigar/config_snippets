Move aliases_and_functions folder to $HOME and add this to `.bashrc`

```
for FILE in `find <path_of_aliases_and_functions> -type f `; do
  source $FILE
done
```
