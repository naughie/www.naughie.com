import Body from "./body.tsx";

const Home = () => {
  return (
    <html>
      <head>
        <meta charset="utf-8" />
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1, shrink-to-fit=no"
        />
        <meta name="author" content="Naughie" />
        <meta name="dcterms.date" content="03/04" />

        <meta property="og:title" content="Naughie's Homepage" />
        <meta property="og:description" content="Naughie's homepage." />
        <meta property="og:type" content="article" />
        <meta property="og:url" content="https://www.naughie.com/" />
        <meta
          property="og:image"
          content="https://www.naughie.com/icon-naughie.png"
        />
        <meta property="og:site_name" content="Naughie's Homepage" />

        <meta name="twitter:card" content="summary" />
        <meta name="twitter:site" content="@naughiez" />
        <link rel="stylesheet" type="text/css" href="styles.css" />
        <title>Naughie's HP</title>
      </head>
      <body>
        <Body />
      </body>
    </html>
  );
};

export default Home;
