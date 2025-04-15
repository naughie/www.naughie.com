import Main from "./main.tsx";
import TitleRibbon from "./title_ribbon.tsx";

import Card from "./card.tsx";
import CardDesc from "./card_desc.tsx";
import CardItem from "./card_item.tsx";
import CardTitle from "./card_title.tsx";

const Body = () => {
  return (
    <Main>
      <TitleRibbon>Naughie's Homepage</TitleRibbon>

      <Card>
        <img
          src="icon-naughie.png"
          alt="Icon of Naughie"
          class="w-1/4 object-contain rounded-xl"
        />

        <CardDesc>
          <CardTitle>Name</CardTitle>
          <CardItem bullet>仲田 将斗　Masato Nakata</CardItem>
          <CardItem bullet>
            なっふぃ　Naughie{" "}
            <small>
              (pronounce /naʔ︎ɸ︎ɪ︎ː/ like <span class="italic">laugh-fee</span>)
            </small>
          </CardItem>
        </CardDesc>
      </Card>

      <Card>
        <CardDesc>
          <CardTitle>Contacts</CardTitle>
          <CardItem bullet>
            Email: masaton <small>(at)</small> naughie.com
          </CardItem>
          <CardItem bullet>
            <a href="https://github.com/naughie">GitHub: naughie</a>
          </CardItem>
          <CardItem bullet>
            <a href="https://x.com/naughiez">
              X (Twitter): <small>@</small>naughiez
            </a>
          </CardItem>
        </CardDesc>
      </Card>

      <Card>
        <CardDesc>
          <CardTitle>Affiliation</CardTitle>
          <CardItem bullet>
            京都大学大学院 情報学研究科　Graduate School of Informatics, Kyoto
            University
          </CardItem>
          <CardItem bullet>
            知能情報学コース　Intelligence Science and Technology Course
          </CardItem>
          <CardItem bullet>
            <a
              href="http://www.lsta.media.kyoto-u.ac.jp/"
              class="text-cardsmall"
            >
              (Link to lab)
            </a>
          </CardItem>
        </CardDesc>
      </Card>

      <Card>
        <CardDesc>
          <CardTitle>Job</CardTitle>
          <CardItem bullet>
            <a href="https://www.linfer-inc.jp/">Linfer</a>{" "}
            <span class="text-cardsmall">(software engineer)</span>, mainly
            developing <a href="https://app.linfer.jp/lita/">LiTA</a>
          </CardItem>
        </CardDesc>
      </Card>

      <Card>
        <CardDesc>
          <CardTitle>Publications</CardTitle>
          <CardItem bullet>
            <span class="italic font-medium">
              Texylon: Dataset of Log-to-Description and Description-to-Log
              Generation for Text Analytics Tools
            </span>. New Frontiers in Artificial Intelligence (2024), pp.
            269-283.{" "}
            <small>
              <a href="https://link.springer.com/chapter/10.1007/978-981-97-3076-6_19">
                (Link)
              </a>
            </small>
          </CardItem>
          <CardItem bullet class="pt-2">
            <span class="italic font-medium">
              テキストアナリティクスツールの説明文に含まれる設定キーの認識
            </span>. 言語処理学会第30回年次大会 (2024), pp. 2961-2965.{" "}
            <small>
              <a href="https://www.anlp.jp/proceedings/annual_meeting/2024/pdf_dir/P10-20.pdf">
                (Link)
              </a>
            </small>
          </CardItem>
        </CardDesc>
      </Card>

      <Card>
        <CardDesc>
          <CardTitle>Techs</CardTitle>
          <CardItem bullet>
            I love Rust,{" "}
            <small>
              an extremely type-safe programming language bundled with ever a
              rich ecosystem and a plenty of documentations, whereby I am
              confident of what I do and never loose my ways...♡
            </small>
          </CardItem>
          <CardItem bullet>
            Prefer hence tools written in Rust: WezTerm, xremap, Deno, Tauri,
            candle (ML), <span class="italic">etc</span>.
          </CardItem>
        </CardDesc>
      </Card>

      <Card>
        <CardDesc>
          <CardTitle>Links</CardTitle>
          <CardItem bullet>
            <a href="https://advent.naughie.com/">
              Advent Calendar &mdash; https://advent.naughie.com/
            </a>
          </CardItem>
          <CardItem bullet>
            <a href="https://notes.naughie.com/">
              Notes &mdash; https://notes.naughie.com/
            </a>
          </CardItem>
          <CardItem bullet>
            <a href="https://zenn.dev/naughie">
              Zenn (written in Japanese) &mdash; https://zenn.dev/naughie
            </a>
          </CardItem>
          <CardItem bullet>
            <a href="https://crates.io/users/naughie">
              Rust crates &mdash; https://crates.io/users/naughie
            </a>
          </CardItem>
          <CardItem bullet>
            <a href="https://test-latin-to-greek-rs.naughie.com/">
              Latin to Greek &mdash; https://test-latin-to-greek-rs.naughie.com/
            </a>
          </CardItem>
        </CardDesc>
      </Card>
    </Main>
  );
};

export default Body;
