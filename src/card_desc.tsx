import type { ComponentChildren } from "preact";

type Props = {
  children: ComponentChildren;
};

const CardDesc = ({ children }: Props) => {
  return (
    <div class="m-4 flex flex-col justify-center">
      {children}
    </div>
  );
};

export default CardDesc;
