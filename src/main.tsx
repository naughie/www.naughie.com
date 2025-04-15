import type { ComponentChildren } from "preact";

type Props = {
  children: ComponentChildren;
};

const Main = ({ children }: Props) => {
  return (
    <main role="main">
      <div class="grid grid-cols-5">
        <div class="col-span-3 col-start-2">
          {children}
        </div>
      </div>
    </main>
  );
};

export default Main;
