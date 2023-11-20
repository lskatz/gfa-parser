# GFA Parser

A simple perl parser for GFA format.
There are many other tools much better than this tool listed at <https://github.com/GFA-spec/GFA-spec>.

## Usage

```text
gfa-info.pl: gives stats on a Graphical Fragment Assembly (GFA) file
  Usage: gfa-info.pl [options] assembly.gfa
  --node   Focus on one node
  --help   This useful help menu
```

## example

In this example, I used `cut -c` for brevity
due to the lengths of unitigs.

```text
$ perl scripts/gfa-info.pl t/data/test.gfa --node 37958 --node 2254218 | cut -c 1-60
S       37958   cigar   KC:i:284
S       37958   seq     TGGGCCAGTTGGTGATTTTGAACTTTTGCTTTGCCACGGAACGGTCTG
L       37958   overlap 111M
L       37958   to      2255152
L       37958   toOrient        +
L       37958   fromOrient      +
S       2254218 cigar   KC:i:645456
S       2254218 seq     CGGTGGTAATAAAGCGAAGAAATTCGGTGGAGCGGTAGTTCAGTCG
L       2254218 toOrient        +
L       2254218 fromOrient      -
L       2254218 overlap 111M
L       2254218 to      2235416

```
