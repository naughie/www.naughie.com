/// <reference lib="deno.ns" />

import { render } from "preact-render-to-string";

import Home from "./home.tsx";

await Deno.writeTextFile("./dist/index.html", render(<Home />));
