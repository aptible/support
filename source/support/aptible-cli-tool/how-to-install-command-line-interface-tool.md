---
title: How do I install the command line interface (CLI) tool?
---

# Installing the command line tool is easy

The easiest way to create and manage Aptible applications is with the Aptible command line interface (CLI) tool. To install the Aptible CLI, you must have Xcode Command Line Tools, Ruby version 1.9.3 or higher, and the RubyGems package manager installed.

Many developers already have these tools installed, so this article only covers how to verify their installation. For instructions on installing each tool, see our article on [how to install Xcode Command Line Tools, Ruby version 1.9.3 or higher, and the RubyGems package](https://aptible.zendesk.com/hc/en-us/articles/202592320).

## Step 1: Verify Xcode Command Line Tools

Verify that you have Xcode Command Line Tools installed:

```bash
$ xcode-select -p
/Library/Developer/CommandLineTools
```

## Step 2: Check for Ruby

Check to make sure you have Ruby installed:

```bash
$ ruby -v
```

## Step 3: Check for RubyGems

To check whether RubyGems is installed:

```bash
$ gem --version
```

## Step 4: Install the Aptible CLI tool

```bash
$ gem install aptible-cli
```
