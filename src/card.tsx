import type { ComponentChildren } from "preact";

type Props = {
  children: ComponentChildren;
};

const Card = ({ children }: Props) => {
  return (
    <div class="card">
      <div class="flex">
        {children}
      </div>
    </div>
  );
};

export default Card;
