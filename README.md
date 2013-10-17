# Elixir Word Count 
## for CHUUG Language Showdown - 10/17/2013

The subject of October CHUUG meeting https://plus.google.com/communities/109291424733517240577 is a language showdown in which numerious implementations of the same problem will be demonstrated in various programming languages.  I volunteered to implement an Elixir solution.

Thus far, the requirements are

 1. Your program should take a path to a file as  command line argument. 
 2. The path will be a flat file of URLs separated by carriage return. 
 3. The URLs will point to a page of text. 
 4. Your program should output a text file containing the aggregate word counts for all the URLs contained in the flat file. 
 5. Additionally, your program should also display the time it took from initial invocation to the completion of writing the output file.

## Setup

Excellent Setup instructions here: http://elixir-lang.org/getting_started/1.html

## Running

```
git clone https://github.com/netinlet/chuug_word_count.git
cd chuug_word_count
mix deps.get
mix test
```

Make command line executable
```
mix compile
mix escriptize
```

Run it
```
./chuug_word_count --report full --seed /path/to/seed/file
```



