
# [SED](https://linuxhint.com/50_sed_command_examples/)
```sh
# Stands for "Stream Editor"
```

- It is meant to interactact with `stream` data on the terminal
```sh
eco "interactive" 's/inter/distr/'
# output distractive
```

- However, to manipulate data from files, use the `-i (interactive)` flag

```sh
sed -i 's/today/tomorrow/'
```

## Simple Back Referencing:
- Double Ampersand is used -- `&&`
- This will search and find the `specified string`. 
- It will print and append the `found string` with sed command.

```sh
echo database | sed 's/data/&&'
# output 
datadatabase
```

## Dot For Any Character
- A Dot can replace all existing characters with another set of characters with sed

```sh
echo xxxx-xx-xx | sed 's/...-..-../YYYY-MM-DD/'
```

# Search and Replace from a File
```sh
sed 's/Sunday/Sunday is holiday/' weekday.txt
```

# Replace all instances of a Text
```sh
Python is a very popular language.
Python is easy to use. Python is easy to learn.
Python is a cross-platform language

# In line 2, replace ALL instances of "Python" with "perl"
sed '2 s/Python/perl/g' python.txt  
```