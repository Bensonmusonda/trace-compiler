
# Trace Compiler

A lightweight custom compiler project built from the ground up in C using **Lex (Flex)** and **Yacc (Bison)**. This project is part of my compiler course and serves as a foundation for understanding key concepts of parsing, tokenization, and basic language design.

## 🧠 Features

- Lexical analysis using Flex (`.l` file)  
- Syntax analysis using Bison (`.y` file)  
- Token stream generation  
- Parse tree construction  
- Line number tracking  
- Error handling  

## 🛠️ Tech Stack

- C (GCC)  
- Flex (Lexical analyzer)  
- Bison (Yacc parser generator)  
- MINGW64 (Windows environment for compilation)  

## 🚀 How to Build

Ensure you have `flex`, `bison`, and `gcc` installed.

```bash
# Step 1: Generate lexer and parser
flex trace_lexer.l
bison -d parser.y

# Step 2: Compile everything
gcc -o trace_lexer trace_lexer_main.c lex.yy.c parser.tab.c line_num_wrapper.c -lfl
````

## 🧪 Running

```bash
./trace_lexer < source_code.txt
```


## 📁 Project Structure

```
trace/
├── parser.y              # Bison grammar rules
├── trace_lexer.l         # Flex lexical rules
├── trace_lexer_main.c    # Main file for lexer execution
├── parser_main.c         # Main file for parser testing
├── common.h              # Common macros / declarations
├── tokens.h              # Token types and enum
├── line_num_wrapper.c    # Line number tracking
└── tokens.txt            # Output of scanned tokens
```

## 📚 Learning Goals

- Understand how compilers tokenize and parse code
    
- Learn to write a basic parser and lexer in C
    
- Explore how programming languages interpret syntax
    

## 🧑‍💻 Author

Benson Musonda  
[GitHub](https://github.com/Bensonmusonda)

## 📌 Notes

This is an educational project and a stepping stone toward building more complex language tooling in the future. Stay tuned for extensions like:

- Semantic analysis
    
- Intermediate code generation
    
- Mini virtual machine for execution
    
