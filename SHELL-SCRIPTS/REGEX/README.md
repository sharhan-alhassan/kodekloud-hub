
# [REGEX_TUTORIAL_LINK](https://www.sitepoint.com/learn-regex/)
# Terminologies

```yml
1. pattern: regular expression pattern
2. string: test string used to match the pattern
3. digit: 0-9
4. letter: a-z, A-Z
5. symbol: !$%^&*()_+|~-=`{}[]:”;'<>?,./
6. space: single white space, tab
7. character: refers to a letter, digit or symbol
```

# Sample Data For This Tutorial
data.txt
```
rat bat cat sat fat cats eat tat cat mat CAT                                                           
```


# Global and Case Insensitive Regex Flags
- By Default, a Regex pattern will only return the FIRST match it finds
- In order to return all instances of the pattern, add/enable the Global flag denoted as `g`. 
- By default, regex search is case `sensitive`, to enable case `insensitive`, add `i` flag


# Character Sets
- To put in multiple characters to get matched to a regex patter, you bracket `[ ]` to match them
- Exampl; `[bcf]at` with give the following from the data.txt
```
bat cat fat
```
- Character sets also work with digits


# Ranges
- Let’s assume we want to match all words that end with `at`. We could supply the full alphabet inside the character set, but that would be tedious. The solution is to use ranges like this `[a-z]at`:

## Other Types of Ranges
```yml
1. Partial range: selections such as [a-f] or [g-p].
2. Capitalized range: [A-Z].
3. Digit range: [0-9].
4. Symbol range: for example, [#$%&@].
5. Mixed range: for example, [a-zA-Z0-9] includes all digits, lower and upper case letters. Do note that a range only specifies multiple alternatives for a single character in a pattern.To further understand how to define a range, it’s best to look at the full ASCII table in order to see how characters are ordered.
```

# Repeating Characters
- Let’s say you’d like to match all three-letter words. You’d probably do it like this:

```sh
[a-z][a-z][a-z]
```
- This would match all three-letter words. But what if you want to match a `five`- or `eight-character` word. The above method is tedious. There’s a better way to express such a pattern using the `{}` curly braces notation. All you have to do is specify the number of repeating characters. Here are examples:

```sh
`a{5}` will match `“aaaaa”`.
`n{3}` will match `“nnn”`.
`[a-z]{4}` will match any four-letter word such as `“door”`, `“room”` or `“book”`.
`[a-z]{6,}` will match any word with six or more letters.
`[a-z]{8,11}` will match any word between eight and 11 letters. Basic password validation can be done this way.
`[0-9]{11}` will match an 11-digit number. Basic international phone validation can be done this way
```

# Metacharacters
- Metacharacters allow you to write regular expression patterns that are even more compact. Let’s go through them one by one:

```
\d matches any digit that is the same as [0-9]
\w matches any letter, digit and underscore character
\s matches a whitespace character — that is, a space or tab
\t matches a tab character only

\w{5} matches any five-letter word or a five-digit number
\d{11} matches an 11-digit number such as a phone number
```


## Grep
- The `grep` command will search for `line` that matches the `specified pattern`.

- If the pattern is found in the line, it will print the `ENTIRE` line

## '\b<pattern>b\' OR -w
- Separating standalone words
```sh
echo "someone" | grep some 
# will output whole "someone" because "some" is in "someone"

echo "someone some" | grep `\bsome\b`
# will ONLY output "some" because it is a standalone word

echo "someone some" | grep -w some
# -w for matching ONLY this word
```

# Rename
- The rename command is mostly used to search a string and replace it with another string

```sh
rename 's/fromString/toString/'
```