This reproduces the compilation issue with Rust 1.91.0. The same command works on the nightly-2025-11-05 toolchain.

```
$ nix develop --command just serve
trunk serve --port 3000
2025-11-06T15:17:13.382395Z  INFO 🚀 Starting trunk 0.21.14
2025-11-06T15:17:13.570854Z  INFO 📦 starting build
   Compiling leptos-struct-table v0.15.0
error: proc macro panicked
  --> /home/steveej/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/leptos-struct-table-0.15.0/src/components/mod.rs:33:13
   |
33 | /             view! {
34 | |                 <$tag class=class>
35 | |                     {content}
36 | |                 </$tag>
37 | |             }
   | |_____________^
   |
  ::: /home/steveej/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/leptos-struct-table-0.15.0/src/components/thead.rs:5:1
   |
 5 | / wrapper_render_fn!(
 6 | |     /// thead
 7 | |     DefaultTableHeadRenderer,
 8 | |     thead,
 9 | | );
   | |_- in this macro invocation
   |
   = help: message: was checked: Error("invalid tag name or attribute key")
   = note: this error originates in the macro `wrapper_render_fn` (in Nightly builds, run with -Z macro-backtrace for more info)

error: proc macro panicked
  --> /home/steveej/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/leptos-struct-table-0.15.0/src/components/mod.rs:33:13
   |
33 | /             view! {
34 | |                 <$tag class=class>
35 | |                     {content}
36 | |                 </$tag>
37 | |             }
   | |_____________^
   |
  ::: /home/steveej/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/leptos-struct-table-0.15.0/src/components/thead.rs:11:1
   |
11 | / wrapper_render_fn!(
12 | |     /// thead row
13 | |     DefaultTableHeadRowRenderer,
14 | |     tr,
15 | | );
   | |_- in this macro invocation
   |
   = help: message: compiler/fallback mismatch L626
   = note: this error originates in the macro `wrapper_render_fn` (in Nightly builds, run with -Z macro-backtrace for more info)

error: custom attribute panicked
  --> /home/steveej/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/leptos-struct-table-0.15.0/src/components/thead.rs:23:1
   |
23 | #[component]
   | ^^^^^^^^^^^^
   |
   = help: message: compiler/fallback mismatch L720

error: could not compile `leptos-struct-table` (lib) due to 3 previous errors
2025-11-06T15:17:14.431044Z ERROR ❌ error
error from build pipeline

Caused by:
    0: HTML build pipeline failed (1 errors), showing first
    1: error from asset pipeline
    2: running cargo build
    3: error during cargo build execution
    4: cargo call to executable 'cargo' with args: '["build", "--target=wasm32-unknown-unknown", "--manifest-path", "/home/steveej/src/steveej/repro-leptos-stable-struct/Cargo.toml"]' returned a bad status: exit status: 101
2025-11-06T15:17:14.431255Z  INFO 📡 serving static assets at -> /
2025-11-06T15:17:14.431549Z  INFO 📡 server listening at:
2025-11-06T15:17:14.431571Z  INFO     🏠 http://127.0.0.1:3000/
2025-11-06T15:17:14.431586Z  INFO     🏠 http://[::1]:3000/
2025-11-06T15:17:14.431880Z  INFO     🏠 http://localhost.:3000/
2025-11-06T15:17:14.432235Z ERROR error from server task error=Address already in use (os error 98)
2025-11-06T15:17:14.432312Z ERROR Address already in use (os error 98)
error: Recipe `serve` failed on line 2 with exit code 1
```
