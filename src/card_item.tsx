import type { ComponentChildren } from "preact";

type Props = {
  bullet?: boolean;
  class?: string;
  children: ComponentChildren;
};

const CardItem = (props: Props) => {
  const append = props.class ? props.class : "";
  const { bullet, children } = props;
  return (
    <div class={`card-body ${append}`}>
      {bullet && <span class="bullet" />} {children}
    </div>
  );
};
export type CardItem = typeof CardItem;

export default CardItem;
