<div align="center">
<p>
    <img width="80" src="https://raw.githubusercontent.com/donnisnoni95/v-logo/master/dist/v-logo.svg?sanitize=true">
</p>
<h1>The V Programming Language</h1>

[vlang.io](https://vlang.io) |
[Docs](https://github.com/vlang/v/blob/master/doc/docs.md) |
[Changelog](https://github.com/vlang/v/blob/master/CHANGELOG.md) |
[Speed](https://fast.vlang.io/) |
[Contributing](https://github.com/vlang/v/blob/master/CONTRIBUTING.md)

</div>
<div align="center">

[![Build Status][WorkflowBadge]][WorkflowUrl]
[![Sponsor][SponsorBadge]][SponsorUrl]
[![Patreon][PatreonBadge]][PatreonUrl]
[![Discord][DiscordBadge]][DiscordUrl]
[![Twitter][TwitterUrl]][TwitterBadge]

</div>

## Key Features of V

- Simplicity: the language can be learned in less than an hour
- Fast compilation: ≈100k — 1.2 million loc/s
- Easy to develop: V compiles itself in less than a second
- Performance: within 3% of C
- Safety: no null, no globals, no undefined behavior, immutability by default
- C to V translation
- Hot code reloading
- [Cross-platform UI library](https://github.com/vlang/ui)
- Built-in graphics library
- Easy cross compilation
- REPL
- Built-in ORM
- C and JavaScript backends

A stable 0.2 release is planned for April 2020. Right now V is in an alpha stage.

## Installing V from source

### Linux, macOS, Windows, *BSD, Solaris, WSL, Android, Raspbian

```bash
git clone https://github.com/vlang/v
cd v
make
```

That's it! Now you have a V executable at `[path to V repo]/v`. `[path to V repo]` can be anywhere.

(On Windows `make` means running `make.bat`, so make sure you use `cmd.exe`.)

V is being constantly updated. To update V, simply run:

```
v up
```

### C compiler

You'll need Clang or GCC or Visual Studio. If you are doing development, you most likely already have one of those installed.

Otherwise, follow these instructions:

- [Installing a C compiler on Linux and macOS](https://github.com/vlang/v/wiki/Installing-a-C-compiler-on-Linux-and-macOS)

- [Installing a C compiler on Windows](https://github.com/vlang/v/wiki/Installing-a-C-compiler-on-Windows)

### Symlinking

You can create a `/usr/local/bin/v` symlink so that V is globally available:

```bash
sudo ./v symlink
```

### Docker

<details><summary>Expand Docker instructions</summary>

```bash
git clone https://github.com/vlang/v
cd v
docker build -t vlang .
docker run --rm -it vlang:latest
v
```

### Docker with Alpine/musl:
```bash
git clone https://github.com/vlang/v
cd v
docker build -t vlang --file=Dockerfile.alpine .
docker run --rm -it vlang:latest
/usr/local/v/v
```
</details>


### Testing and running the examples

Make sure V can compile itself:

```
v -o v2 cmd/v
```

```bash
$ v
V 0.1.x
Use Ctrl-C or `exit` to exit

>>> println('hello world')
hello world
>>>
```

```bash
cd examples
v hello_world.v && ./hello_world    # or simply
v run hello_world.v                 # this builds the program and runs it right away

v word_counter.v && ./word_counter cinderella.txt
v run news_fetcher.v
v run tetris/tetris.v
```

<img src='https://raw.githubusercontent.com/vlang/v/master/examples/tetris/screenshot.png' width=300>

In order to build Tetris and anything else using the graphics module, you will need to install glfw and freetype libraries.

If you plan to use the http package, you also need to install OpenSSL on non-Windows systems.

```
macOS:
brew install glfw freetype openssl

Debian/Ubuntu:
sudo apt install libglfw3 libglfw3-dev libfreetype6-dev libssl-dev

Arch/Manjaro:
sudo pacman -S glfw-x11 freetype2

Fedora:
sudo dnf install glfw glfw-devel freetype-devel

Windows:
git clone --depth=1 https://github.com/ubawurinna/freetype-windows-binaries [path to v repo]/thirdparty/freetype/

```

glfw dependency will be removed soon.

## V UI

<a href="https://github.com/vlang/ui">
<img src='https://raw.githubusercontent.com/vlang/ui/master/examples/screenshot.png' width=712>
</a>

https://github.com/vlang/ui

<!---
## JavaScript backend

[examples/hello_v_js.v](examples/hello_v_js.v):

```v
fn main() {
        for i in 0..3 {
                println('Hello from V.js')
        }
}
```

```bash
v -o hi.js examples/hello_v_js.v && node hi.js
Hello from V.js
Hello from V.js
Hello from V.js
```
-->

## Troubleshooting

https://github.com/vlang/v/wiki/Troubleshooting

[WorkflowBadge]: https://github.com/vlang/v/workflows/CI/badge.svg
[DiscordBadge]: https://img.shields.io/discord/592103645835821068?label=Discord&logo=discord&logoColor=white
[PatreonBadge]: https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.herokuapp.com%2Fvlang%2Fpledges&label=Patreon
[SponsorBadge]: https://camo.githubusercontent.com/da8bc40db5ed31e4b12660245535b5db67aa03ce/68747470733a2f2f696d672e736869656c64732e696f2f7374617469632f76313f6c6162656c3d53706f6e736f72266d6573736167653d254532253944254134266c6f676f3d476974487562
[TwitterBadge]: https://twitter.com/v_language

[WorkflowUrl]: https://github.com/vlang/v/commits/master
[DiscordUrl]: https://discord.gg/vlang
[PatreonUrl]: https://patreon.com/vlang
[SponsorUrl]: https://github.com/sponsors/medvednikov
[TwitterUrl]: https://img.shields.io/twitter/follow/v_language.svg?style=flatl&label=Follow&logo=twitter&logoColor=white&color=1da1f2
