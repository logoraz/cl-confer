# CL Conf*iguration* E*nvironment* R*esource* (`:confer`)


<p align="center">
  <img src="assets/yin-yang-lisp-logo_512_svg.png" width="200" />
</p>

This is my Commmon Lisp configuration tool project. It servers as a general
resource for custom libraries, RC Files, ASDF configuration settings
and a playground to develop new systems. It's in a very early stage, so not
much functionality as a 'tool' here just yet, just a working project to store my
work at the moment...

Currently, the setup of this project itself acts as a template on how to scaffold
a modern Common Lisp system using the ASDF `package-inferred-system` along with a testing
framework (FiveAM). The Common Lisp code written herein also acts as a 'style guide' on my
functional/aesthetic preferences. I also use [ocicl](https://github.com/ocicl/ocicl) for
a modern approach for Common Lisp Systems Management - its a great tool (highly preferred
over quicklisp, qlot, roswell, CLPM, etc.) - really wish the community would adopt this
solution over the others!

The most recent addition is a testing framework (FiveAM) that has an example test template
borrowed from 
[The Common Lisp Cookbook:Testing With FiveAM](https://lispcookbook.github.io/cl-cookbook/testing.html#testing-with-fiveam).
The test(s) can be executed, in the project directory, via:

```lisp

* (asdf:test-system :confer-test)

```

As a fun exercise of incorporating a library, I adapted the `SDRAW` and `DTRACE` tools from
the book 
[Common Lisp: A Gentle Introduction to Symbolic Computation](https://www.cs.cmu.edu/~dst/LispBook/).
This is staged in the library `learncl` (alias `lcl`). For example, you can run the `sdraw`
learning tool (a cons cell visual aid) in this project as follows:

```lisp

(asdf:load-system :confer)
;; or
;; (asdf:load-system :confr) ; system alias
;;...

(learncl:sdraw '(This (is a (test!))))
;; or
;; (lcl:sdraw '(This (is a (test!)))) ; short alias
;;
;; =>
;; [*|*]--->[*|*]--->NIL
;;  |        |
;;  v        v
;; THIS     [*|*]--->[*|*]--->[*|*]--->NIL
;;           |        |        |
;;           v        v        v
;;           IS       A       [*|*]--->NIL
;;                             |
;;                             v
;;                            TEST!

```

## TODOs (Wish List)

 - Create a Common Lisp setup script to scaffold my prefered develop environment
 - Develop a Common Lisp Command Line tool to create Fedora RPM's for Common Lisp Libraries/Systems
 - TBD

## Changelog

### 0.0.3 (WIP)

  - Create simple database to track installed configuration elements (sqlite?)
  - Create common lisp setup script
  - Create command line application
  - TBD

### 0.0.2

  - Refactor/Clean-up project scaffold
  - Create System alias `:confr` & set to package nickname
  - Add unit-testing framework template (FiveAM)
  - Update README & Revision Bump

### 0.0.1

  - Initial commit
  - Added basic project scaffold

   
## References:

 - TBD

