# Elixir Word Count 
## for CHUUG Language Showdown - 10/17/2013

The subject of October CHUUG meeting https://plus.google.com/communities/109291424733517240577 is a language showdown in which numerious implementations of the same problem will be demonstrated in various programming languages.  I volunteered to implement an Elixir solution.

Thus far, the requirements are

 1. Everyone is coded and deployed to a common platform before the ev ent.
 2. You are given a flat file of 50 URLS.
 3. The flat file must be consumed and you must download all 50 URLS.
 4. Strip the content of each URL of HTML.
 5. Perform a word count on all 50 documents.
 6. Present a combined wordcount.

## Setup

Excellent Setup instructions here: http://elixir-lang.org/getting_started/1.html

## Running

git clone https://github.com/netinlet/chuug_word_count.git
cd chuug_word_count
mix deps.get
mix test

Make command line executable

mix compile
mix escriptize

./chuug_word_count --report summary --seed http://netinlet.com/assets/word_count_urls.txt



