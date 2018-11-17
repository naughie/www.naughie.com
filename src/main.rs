#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

use rocket_contrib::serve::StaticFiles;

#[get("/")]
fn hello() -> &'static str {
    "Hello, World!テスト😀ほげほげ\n"
}

fn main() {
    rocket::ignite().mount("/", routes![hello])
        .mount("/advent", StaticFiles::from("public/articles/advent"))
        .launch();
}
