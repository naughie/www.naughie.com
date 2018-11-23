#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

use rocket::response::NamedFile;
use rocket::response::status::NotFound;
use rocket_contrib::serve::StaticFiles;

#[get("/")]
fn root() -> Result<NamedFile, NotFound<String>> {
    NamedFile::open("public/index.html")
        .map_err(|_| NotFound("Not Found!😭\n".to_string()))
}

fn main() {
    rocket::ignite()
        .mount("/", routes![root])
        .mount("/advent", StaticFiles::from("public/articles/advent"))
        .launch();
}
